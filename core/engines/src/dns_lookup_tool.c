#define _POSIX_C_SOURCE 200809L

#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>

#ifndef NI_MAXHOST
#define NI_MAXHOST 1025
#endif

static void print_forward_lookup(const char *query) {
  struct addrinfo hints;
  struct addrinfo *result = NULL;
  struct addrinfo *entry = NULL;
  char host[NI_MAXHOST];

  memset(&hints, 0, sizeof(hints));
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;

  if (getaddrinfo(query, NULL, &hints, &result) != 0) {
    perror("getaddrinfo");
    return;
  }

  printf("Forward lookup for %s\n", query);
  for (entry = result; entry != NULL; entry = entry->ai_next) {
    if (getnameinfo(entry->ai_addr, entry->ai_addrlen, host, sizeof(host), NULL, 0,
                    NI_NUMERICHOST) == 0) {
      printf("  %s\n", host);
    }
  }

  freeaddrinfo(result);
}

static void print_reverse_lookup(const char *query) {
  struct sockaddr_storage storage;
  socklen_t storage_len = 0;
  char host[NI_MAXHOST];

  memset(&storage, 0, sizeof(storage));

  if (inet_pton(AF_INET, query, &((struct sockaddr_in *)&storage)->sin_addr) == 1) {
    struct sockaddr_in *addr = (struct sockaddr_in *)&storage;
    addr->sin_family = AF_INET;
    storage_len = sizeof(*addr);
  } else if (inet_pton(AF_INET6, query, &((struct sockaddr_in6 *)&storage)->sin6_addr) == 1) {
    struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&storage;
    addr6->sin6_family = AF_INET6;
    storage_len = sizeof(*addr6);
  }

  if (storage_len == 0) {
    return;
  }

  if (getnameinfo((struct sockaddr *)&storage, storage_len, host, sizeof(host), NULL, 0, 0) == 0) {
    printf("Reverse lookup for %s\n", query);
    printf("  %s\n", host);
  }
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <hostname-or-ip>\n", argv[0]);
    return 1;
  }

  print_forward_lookup(argv[1]);
  print_reverse_lookup(argv[1]);
  return 0;
}
