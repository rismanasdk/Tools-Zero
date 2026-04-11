#define _POSIX_C_SOURCE 200809L

#include <arpa/inet.h>
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

struct PingTask {
  pid_t pid;
  char ip_text[INET_ADDRSTRLEN];
};

static bool parse_cidr(const char *input, uint32_t *network_out, int *prefix_out) {
  char buffer[64];
  char *slash = NULL;
  struct in_addr addr;
  long prefix = 0;

  if (strlen(input) >= sizeof(buffer)) {
    return false;
  }

  snprintf(buffer, sizeof(buffer), "%s", input);
  slash = strchr(buffer, '/');
  if (slash == NULL) {
    return false;
  }

  *slash = '\0';
  ++slash;

  if (inet_pton(AF_INET, buffer, &addr) != 1) {
    return false;
  }

  prefix = strtol(slash, NULL, 10);
  if (prefix < 8 || prefix > 30) {
    return false;
  }

  *network_out = ntohl(addr.s_addr);
  *prefix_out = (int)prefix;
  return true;
}

static bool is_private_or_loopback(uint32_t ip_host_order) {
  if ((ip_host_order & 0xff000000U) == 0x0a000000U) {
    return true;
  }
  if ((ip_host_order & 0xfff00000U) == 0xac100000U) {
    return true;
  }
  if ((ip_host_order & 0xffff0000U) == 0xc0a80000U) {
    return true;
  }
  if ((ip_host_order & 0xff000000U) == 0x7f000000U) {
    return true;
  }
  return false;
}

static pid_t start_ping(const char *ip_text, int timeout_seconds) {
  pid_t child = fork();
  if (child < 0) {
    return (pid_t)-1;
  }

  if (child == 0) {
    char timeout_text[16];
    int devnull = open("/dev/null", O_WRONLY);
    if (devnull >= 0) {
      dup2(devnull, STDOUT_FILENO);
      dup2(devnull, STDERR_FILENO);
      close(devnull);
    }
    snprintf(timeout_text, sizeof(timeout_text), "%d", timeout_seconds);
    execlp("ping", "ping", "-c", "1", "-W", timeout_text, ip_text, (char *)NULL);
    _exit(127);
  }

  return child;
}

int main(int argc, char *argv[]) {
  uint32_t network = 0;
  int prefix = 0;
  uint32_t mask = 0;
  uint32_t start = 0;
  uint32_t end = 0;
  uint32_t host = 0;
  int alive = 0;
  int timeout_ms = 1000;
  int timeout_seconds = 1;
  int parallelism = 32;
  struct PingTask *tasks = NULL;

  if (argc < 2 || argc > 4) {
    fprintf(stderr, "Usage: %s <private-cidr> [timeout-ms] [parallelism]\n", argv[0]);
    return 1;
  }

  if (!parse_cidr(argv[1], &network, &prefix)) {
    fprintf(stderr, "Invalid CIDR. Use IPv4 private ranges such as 192.168.1.0/24.\n");
    return 1;
  }

  if (!is_private_or_loopback(network)) {
    fprintf(stderr, "Refusing to scan a non-private/non-loopback network.\n");
    return 1;
  }

  if (argc >= 3) {
    timeout_ms = atoi(argv[2]);
    if (timeout_ms < 250 || timeout_ms > 5000) {
      fprintf(stderr, "timeout-ms must be between 250 and 5000.\n");
      return 1;
    }
  }

  if (argc >= 4) {
    parallelism = atoi(argv[3]);
    if (parallelism < 1 || parallelism > 256) {
      fprintf(stderr, "parallelism must be between 1 and 256.\n");
      return 1;
    }
  }

  timeout_seconds = (timeout_ms + 999) / 1000;

  mask = prefix == 0 ? 0U : (0xffffffffU << (32 - prefix));
  network &= mask;
  start = network + 1U;
  end = (network | ~mask) - 1U;

  if (start > end) {
    fprintf(stderr, "CIDR range is too small for a host sweep.\n");
    return 1;
  }

  tasks = (struct PingTask *)calloc((size_t)parallelism, sizeof(*tasks));
  if (tasks == NULL) {
    perror("calloc");
    return 1;
  }

  printf("Ping sweep for %s (timeout=%d ms, parallel=%d)\n",
         argv[1],
         timeout_ms,
         parallelism);

  int active = 0;
  bool exhausted = false;

  while (!exhausted || active > 0) {
    while (!exhausted && active < parallelism) {
      struct in_addr addr;
      char ip_text[INET_ADDRSTRLEN];
      pid_t pid;

      if (host == 0) {
        host = start;
      }
      if (host > end) {
        exhausted = true;
        break;
      }

      addr.s_addr = htonl(host);
      ++host;

      if (inet_ntop(AF_INET, &addr, ip_text, sizeof(ip_text)) == NULL) {
        continue;
      }

      pid = start_ping(ip_text, timeout_seconds);
      if (pid < 0) {
        perror("fork");
        free(tasks);
        return 1;
      }

      tasks[active].pid = pid;
      snprintf(tasks[active].ip_text, sizeof(tasks[active].ip_text), "%s", ip_text);
      ++active;
    }

    int status = 0;
    pid_t finished = wait(&status);
    if (finished < 0) {
      if (errno == EINTR) {
        continue;
      }
      break;
    }

    for (int index = 0; index < active; ++index) {
      if (tasks[index].pid == finished) {
        if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
          printf("[alive] %s\n", tasks[index].ip_text);
          ++alive;
        }

        tasks[index] = tasks[active - 1];
        --active;
        break;
      }
    }
  }

  free(tasks);
  printf("Finished. %d host(s) responded.\n", alive);
  return 0;
}
