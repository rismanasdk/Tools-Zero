#define _POSIX_C_SOURCE 200809L

#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct ProcessInfo {
  int pid;
  int ppid;
  char state[8];
  long rss_kb;
  char name[128];
  char command[256];
};

static int compare_processes(const void *lhs, const void *rhs) {
  const struct ProcessInfo *left = (const struct ProcessInfo *)lhs;
  const struct ProcessInfo *right = (const struct ProcessInfo *)rhs;
  if (left->rss_kb < right->rss_kb) {
    return 1;
  }
  if (left->rss_kb > right->rss_kb) {
    return -1;
  }
  return left->pid - right->pid;
}

static int read_process_info(int pid, struct ProcessInfo *info) {
  char path[PATH_MAX];
  FILE *file = NULL;
  long rss_pages = 0;

  snprintf(path, sizeof(path), "/proc/%d/status", pid);
  file = fopen(path, "r");
  if (file == NULL) {
    return -1;
  }

  memset(info, 0, sizeof(*info));
  info->pid = pid;

  char line[512];
  while (fgets(line, sizeof(line), file) != NULL) {
    if (sscanf(line, "Name:%127s", info->name) == 1) {
      continue;
    }
    if (sscanf(line, "State:%7s", info->state) == 1) {
      continue;
    }
    if (sscanf(line, "PPid:%d", &info->ppid) == 1) {
      continue;
    }
    if (sscanf(line, "VmRSS:%ld", &info->rss_kb) == 1) {
      continue;
    }
  }
  fclose(file);

  snprintf(path, sizeof(path), "/proc/%d/cmdline", pid);
  file = fopen(path, "r");
  if (file != NULL) {
    size_t bytes = fread(info->command, 1, sizeof(info->command) - 1, file);
    fclose(file);
    if (bytes > 0) {
      for (size_t index = 0; index + 1 < bytes; ++index) {
        if (info->command[index] == '\0') {
          info->command[index] = ' ';
        }
      }
      info->command[bytes] = '\0';
    }
  }

  if (info->command[0] == '\0') {
    snprintf(info->command, sizeof(info->command), "[%s]", info->name);
  }

  if (info->rss_kb == 0) {
    snprintf(path, sizeof(path), "/proc/%d/statm", pid);
    file = fopen(path, "r");
    if (file != NULL) {
      long total_pages = 0;
      if (fscanf(file, "%ld %ld", &total_pages, &rss_pages) == 2) {
        info->rss_kb = rss_pages * (long)sysconf(_SC_PAGESIZE) / 1024L;
      }
      fclose(file);
    }
  }

  return 0;
}

int main(int argc, char *argv[]) {
  DIR *proc_dir = NULL;
  struct dirent *entry = NULL;
  struct ProcessInfo *items = NULL;
  size_t count = 0;
  size_t capacity = 0;
  long limit = 10;

  if (argc > 2) {
    fprintf(stderr, "Usage: %s [top-n]\n", argv[0]);
    return 1;
  }

  if (argc == 2) {
    limit = strtol(argv[1], NULL, 10);
    if (limit <= 0 || limit > 200) {
      fprintf(stderr, "top-n must be between 1 and 200.\n");
      return 1;
    }
  }

  proc_dir = opendir("/proc");
  if (proc_dir == NULL) {
    perror("opendir /proc");
    return 1;
  }

  while ((entry = readdir(proc_dir)) != NULL) {
    if (!isdigit((unsigned char)entry->d_name[0])) {
      continue;
    }

    if (count == capacity) {
      size_t new_capacity = capacity == 0 ? 64 : capacity * 2;
      struct ProcessInfo *new_items =
          (struct ProcessInfo *)realloc(items, new_capacity * sizeof(*items));
      if (new_items == NULL) {
        perror("realloc");
        free(items);
        closedir(proc_dir);
        return 1;
      }
      items = new_items;
      capacity = new_capacity;
    }

    if (read_process_info(atoi(entry->d_name), &items[count]) == 0) {
      ++count;
    }
  }

  closedir(proc_dir);

  qsort(items, count, sizeof(*items), compare_processes);

  printf("%-7s %-7s %-7s %-10s %s\n", "PID", "PPID", "STATE", "RSS_KB", "COMMAND");
  for (size_t index = 0; index < count && (long)index < limit; ++index) {
    printf("%-7d %-7d %-7s %-10ld %s\n",
           items[index].pid,
           items[index].ppid,
           items[index].state,
           items[index].rss_kb,
           items[index].command);
  }

  free(items);
  return 0;
}
