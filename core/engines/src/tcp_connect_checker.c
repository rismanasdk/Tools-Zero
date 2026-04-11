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
#include <unistd.h>

int main(int argc, char *argv[]) {
  struct addrinfo hints;
  struct addrinfo *result = NULL;
  struct addrinfo *entry = NULL;
  char port_text[16];
  int timeout_ms = 1000;
  int status = 1;

  if (argc != 4) {
    fprintf(stderr, "Usage: %s <host> <port> <timeout-ms>\n", argv[0]);
    return 1;
  }

  timeout_ms = atoi(argv[3]);
  if (timeout_ms < 1 || timeout_ms > 10000) {
    fprintf(stderr, "timeout-ms must be between 1 and 10000.\n");
    return 1;
  }

  memset(&hints, 0, sizeof(hints));
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;

  snprintf(port_text, sizeof(port_text), "%s", argv[2]);
  if (getaddrinfo(argv[1], port_text, &hints, &result) != 0) {
    perror("getaddrinfo");
    return 1;
  }

  for (entry = result; entry != NULL; entry = entry->ai_next) {
    int fd = socket(entry->ai_family, entry->ai_socktype, entry->ai_protocol);
    if (fd < 0) {
      continue;
    }

    int flags = fcntl(fd, F_GETFL, 0);
    if (flags >= 0) {
      fcntl(fd, F_SETFL, flags | O_NONBLOCK);
    }

    int rc = connect(fd, entry->ai_addr, entry->ai_addrlen);
    if (rc == 0 || errno == EINPROGRESS) {
      fd_set writefds;
      struct timeval timeout;
      int error = 0;
      socklen_t error_len = sizeof(error);

      FD_ZERO(&writefds);
      FD_SET(fd, &writefds);
      timeout.tv_sec = timeout_ms / 1000;
      timeout.tv_usec = (timeout_ms % 1000) * 1000;

      rc = select(fd + 1, NULL, &writefds, NULL, &timeout);
      if (rc > 0 &&
          getsockopt(fd, SOL_SOCKET, SO_ERROR, &error, &error_len) == 0 &&
          error == 0) {
        printf("%s:%s is reachable over TCP.\n", argv[1], argv[2]);
        status = 0;
        close(fd);
        break;
      }
    }

    close(fd);
  }

  if (status != 0) {
    printf("%s:%s is not reachable over TCP within %d ms.\n", argv[1], argv[2], timeout_ms);
  }

  freeaddrinfo(result);
  return status;
}
