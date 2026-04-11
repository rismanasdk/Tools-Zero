#define _POSIX_C_SOURCE 200809L

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

static int connect_with_timeout(const char *host, int port, int timeout_ms) {
  struct addrinfo hints;
  struct addrinfo *result = NULL;
  struct addrinfo *entry = NULL;
  char port_text[16];
  int status = 0;
  int fd = -1;

  memset(&hints, 0, sizeof(hints));
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;

  snprintf(port_text, sizeof(port_text), "%d", port);
  status = getaddrinfo(host, port_text, &hints, &result);
  if (status != 0) {
    fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
    return -1;
  }

  for (entry = result; entry != NULL; entry = entry->ai_next) {
    fd = socket(entry->ai_family, entry->ai_socktype, entry->ai_protocol);
    if (fd < 0) {
      continue;
    }

    int flags = fcntl(fd, F_GETFL, 0);
    if (flags >= 0) {
      fcntl(fd, F_SETFL, flags | O_NONBLOCK);
    }

    int rc = connect(fd, entry->ai_addr, entry->ai_addrlen);
    if (rc == 0) {
      close(fd);
      freeaddrinfo(result);
      return 0;
    }

    if (errno == EINPROGRESS) {
      fd_set writefds;
      struct timeval timeout;
      FD_ZERO(&writefds);
      FD_SET(fd, &writefds);
      timeout.tv_sec = timeout_ms / 1000;
      timeout.tv_usec = (timeout_ms % 1000) * 1000;

      rc = select(fd + 1, NULL, &writefds, NULL, &timeout);
      if (rc > 0) {
        int error = 0;
        socklen_t error_len = sizeof(error);
        if (getsockopt(fd, SOL_SOCKET, SO_ERROR, &error, &error_len) == 0 && error == 0) {
          close(fd);
          freeaddrinfo(result);
          return 0;
        }
      }
    }

    close(fd);
    fd = -1;
  }

  freeaddrinfo(result);
  return -1;
}

int main(int argc, char *argv[]) {
  char *ports_text = NULL;
  char *saveptr = NULL;
  char *token = NULL;
  int delay_ms = 250;

  if (argc != 4) {
    fprintf(stderr, "Usage: %s <host> <port1,port2,...> <delay-ms>\n", argv[0]);
    return 1;
  }

  delay_ms = atoi(argv[3]);
  if (delay_ms < 0 || delay_ms > 5000) {
    fprintf(stderr, "delay-ms must be between 0 and 5000.\n");
    return 1;
  }

  ports_text = strdup(argv[2]);
  if (ports_text == NULL) {
    perror("strdup");
    return 1;
  }

  printf("Port knocking %s with sequence %s\n", argv[1], argv[2]);

  token = strtok_r(ports_text, ",", &saveptr);
  while (token != NULL) {
    int port = atoi(token);
    if (port < 1 || port > 65535) {
      fprintf(stderr, "Invalid port in sequence: %s\n", token);
      free(ports_text);
      return 1;
    }

    if (connect_with_timeout(argv[1], port, 1000) == 0) {
      printf("[sent] TCP knock to %s:%d\n", argv[1], port);
    } else {
      printf("[sent] TCP knock attempted to %s:%d\n", argv[1], port);
    }

    if (delay_ms > 0) {
      struct timespec delay;
      delay.tv_sec = delay_ms / 1000;
      delay.tv_nsec = (long)(delay_ms % 1000) * 1000000L;
      nanosleep(&delay, NULL);
    }

    token = strtok_r(NULL, ",", &saveptr);
  }

  free(ports_text);
  printf("Sequence complete.\n");
  return 0;
}
