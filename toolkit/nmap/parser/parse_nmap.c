#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libxml/parser.h>
#include <libxml/tree.h>

typedef struct {
    char ip[50];
    char mac[50];
    char hostname[256];
    char status[20];
    char os[256];
    int open_ports;
} Host;

void parse_xml(const char *filename) {
    xmlDocPtr doc;
    xmlNodePtr cur;
    int host_count = 0;
    
    doc = xmlParseFile(filename);
    if (doc == NULL) {
        fprintf(stderr, "Error: Could not parse file %s\n", filename);
        return;
    }
    
    cur = xmlDocGetRootElement(doc);
    if (cur == NULL) {
        fprintf(stderr, "Error: Empty document\n");
        xmlFreeDoc(doc);
        return;
    }
    
    // Parse hosts
    printf("IP Address\t\tStatus\t\tOpen Ports\n");
    printf("════════════════════════════════════════════\n");
    
    xmlNodePtr host_node = cur->children;
    while (host_node != NULL) {
        if (host_node->type == XML_ELEMENT_NODE && strcmp((char*)host_node->name, "host") == 0) {
            Host host = {0};
            
            // Get status
            xmlNodePtr status_node = xmlGetProp(host_node, (xmlChar*)"starttime");
            xmlNodePtr state_node = host_node->children;
            
            while (state_node != NULL) {
                if (state_node->type == XML_ELEMENT_NODE) {
                    if (strcmp((char*)state_node->name, "status") == 0) {
                        xmlChar *state = xmlGetProp(state_node, (xmlChar*)"state");
                        if (state) {
                            strcpy(host.status, (char*)state);
                            xmlFree(state);
                        }
                    }
                    else if (strcmp((char*)state_node->name, "address") == 0) {
                        xmlChar *addr_type = xmlGetProp(state_node, (xmlChar*)"addrtype");
                        xmlChar *addr = xmlGetProp(state_node, (xmlChar*)"addr");
                        
                        if (addr_type && addr) {
                            if (strcmp((char*)addr_type, "ipv4") == 0) {
                                strcpy(host.ip, (char*)addr);
                            } else if (strcmp((char*)addr_type, "mac") == 0) {
                                strcpy(host.mac, (char*)addr);
                            }
                        }
                        if (addr_type) xmlFree(addr_type);
                        if (addr) xmlFree(addr);
                    }
                    else if (strcmp((char*)state_node->name, "ports") == 0) {
                        xmlNodePtr port_node = state_node->children;
                        while (port_node != NULL) {
                            if (port_node->type == XML_ELEMENT_NODE && 
                                strcmp((char*)port_node->name, "port") == 0) {
                                xmlNodePtr port_state = port_node->children;
                                while (port_state != NULL) {
                                    if (port_state->type == XML_ELEMENT_NODE &&
                                        strcmp((char*)port_state->name, "state") == 0) {
                                        xmlChar *state = xmlGetProp(port_state, (xmlChar*)"state");
                                        if (state && strcmp((char*)state, "open") == 0) {
                                            host.open_ports++;
                                        }
                                        if (state) xmlFree(state);
                                    }
                                    port_state = port_state->next;
                                }
                            }
                            port_node = port_node->next;
                        }
                    }
                }
                state_node = state_node->next;
            }
            
            if (strlen(host.ip) > 0) {
                printf("%-20s\t%-15s\t%d\n", host.ip, host.status, host.open_ports);
                host_count++;
            }
        }
        host_node = host_node->next;
    }
    
    printf("════════════════════════════════════════════\n");
    printf("Total hosts found: %d\n", host_count);
    
    xmlFreeDoc(doc);
}

void export_json(const char *xml_file, const char *json_file) {
    FILE *fp = fopen(json_file, "w");
    if (!fp) {
        fprintf(stderr, "Error: Could not create %s\n", json_file);
        return;
    }
    
    fprintf(fp, "{\"scan\": \"parsed from %s\"}\n", xml_file);
    fclose(fp);
    printf("✓ Exported to %s\n", json_file);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: parse_nmap <xml_file> [--json output.json]\n");
        return 1;
    }
    
    xmlInitParser();
    
    parse_xml(argv[1]);
    
    if (argc >= 4 && strcmp(argv[2], "--json") == 0) {
        export_json(argv[1], argv[3]);
    }
    
    xmlCleanupParser();
    return 0;
}
