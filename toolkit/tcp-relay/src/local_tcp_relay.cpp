#include <arpa/inet.h>
#include <netdb.h>
#include <sys/socket.h>
#include <unistd.h>

#include <atomic>
#include <cerrno>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

namespace {

struct Config {
  std::string listen_host = "127.0.0.1";
  int listen_port = 0;
  std::string target_host;
  int target_port = 0;
  std::size_t buffer_size = 4096;
};

void print_help(const char* program_name) {
  std::cout
      << "Local TCP Relay\n"
      << "Usage:\n"
      << "  " << program_name
      << " --listen-port <port> --target-host <host> --target-port <port> [options]\n\n"
      << "Options:\n"
      << "  --listen-host <host>   Loopback address to bind. Default: 127.0.0.1\n"
      << "  --listen-port <port>   Local port to listen on\n"
      << "  --target-host <host>   Remote target host\n"
      << "  --target-port <port>   Remote target port\n"
      << "  --buffer-size <bytes>  Transfer buffer size. Default: 4096\n"
      << "  --help                 Show this help text\n\n"
      << "Safety scope:\n"
      << "  This relay only binds to loopback addresses so it can be used for local\n"
      << "  debugging of traffic for systems and services you control.\n";
}

bool is_loopback_host(const std::string& host) {
  return host == "127.0.0.1" || host == "localhost" || host == "::1";
}

int parse_port(const std::string& value, const char* flag_name) {
  try {
    const int port = std::stoi(value);
    if (port < 1 || port > 65535) {
      throw std::out_of_range("port");
    }
    return port;
  } catch (const std::exception&) {
    throw std::runtime_error(std::string("Invalid value for ") + flag_name + ": " + value);
  }
}

std::size_t parse_buffer_size(const std::string& value) {
  try {
    const unsigned long size = std::stoul(value);
    if (size == 0) {
      throw std::out_of_range("buffer-size");
    }
    return static_cast<std::size_t>(size);
  } catch (const std::exception&) {
    throw std::runtime_error("Invalid value for --buffer-size: " + value);
  }
}

Config parse_args(int argc, char* argv[]) {
  Config config;

  for (int index = 1; index < argc; ++index) {
    const std::string arg = argv[index];
    auto require_value = [&](const char* flag_name) -> std::string {
      if (index + 1 >= argc) {
        throw std::runtime_error(std::string("Missing value for ") + flag_name);
      }
      return argv[++index];
    };

    if (arg == "--help" || arg == "-h") {
      print_help(argv[0]);
      std::exit(0);
    }
    if (arg == "--listen-host") {
      config.listen_host = require_value("--listen-host");
      continue;
    }
    if (arg == "--listen-port") {
      config.listen_port = parse_port(require_value("--listen-port"), "--listen-port");
      continue;
    }
    if (arg == "--target-host") {
      config.target_host = require_value("--target-host");
      continue;
    }
    if (arg == "--target-port") {
      config.target_port = parse_port(require_value("--target-port"), "--target-port");
      continue;
    }
    if (arg == "--buffer-size") {
      config.buffer_size = parse_buffer_size(require_value("--buffer-size"));
      continue;
    }

    throw std::runtime_error("Unknown argument: " + arg);
  }

  if (!is_loopback_host(config.listen_host)) {
    throw std::runtime_error(
        "Refusing to bind to a non-loopback address. Use 127.0.0.1, localhost, or ::1.");
  }
  if (config.listen_port == 0) {
    throw std::runtime_error("Missing required argument: --listen-port");
  }
  if (config.target_host.empty()) {
    throw std::runtime_error("Missing required argument: --target-host");
  }
  if (config.target_port == 0) {
    throw std::runtime_error("Missing required argument: --target-port");
  }

  return config;
}

int create_listener(const std::string& host, int port) {
  addrinfo hints{};
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE;

  addrinfo* result = nullptr;
  const std::string port_text = std::to_string(port);
  const int status = getaddrinfo(host.c_str(), port_text.c_str(), &hints, &result);
  if (status != 0) {
    throw std::runtime_error("getaddrinfo(listener) failed: " + std::string(gai_strerror(status)));
  }

  int listener = -1;
  for (addrinfo* entry = result; entry != nullptr; entry = entry->ai_next) {
    listener = socket(entry->ai_family, entry->ai_socktype, entry->ai_protocol);
    if (listener < 0) {
      continue;
    }

    int enabled = 1;
    setsockopt(listener, SOL_SOCKET, SO_REUSEADDR, &enabled, sizeof(enabled));

    if (bind(listener, entry->ai_addr, entry->ai_addrlen) == 0 &&
        listen(listener, 8) == 0) {
      break;
    }

    close(listener);
    listener = -1;
  }

  freeaddrinfo(result);

  if (listener < 0) {
    throw std::runtime_error("Unable to bind listener on " + host + ":" + std::to_string(port));
  }

  return listener;
}

int connect_target(const std::string& host, int port) {
  addrinfo hints{};
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;

  addrinfo* result = nullptr;
  const std::string port_text = std::to_string(port);
  const int status = getaddrinfo(host.c_str(), port_text.c_str(), &hints, &result);
  if (status != 0) {
    throw std::runtime_error("getaddrinfo(target) failed: " + std::string(gai_strerror(status)));
  }

  int target = -1;
  for (addrinfo* entry = result; entry != nullptr; entry = entry->ai_next) {
    target = socket(entry->ai_family, entry->ai_socktype, entry->ai_protocol);
    if (target < 0) {
      continue;
    }
    if (connect(target, entry->ai_addr, entry->ai_addrlen) == 0) {
      break;
    }
    close(target);
    target = -1;
  }

  freeaddrinfo(result);

  if (target < 0) {
    throw std::runtime_error("Unable to connect to target " + host + ":" + std::to_string(port));
  }

  return target;
}

void close_socket(int fd) {
  if (fd >= 0) {
    shutdown(fd, SHUT_RDWR);
    close(fd);
  }
}

void forward_stream(
    int source_fd,
    int destination_fd,
    std::size_t buffer_size,
    const std::string& label,
    std::atomic<bool>& stop_flag) {
  std::vector<char> buffer(buffer_size);

  while (!stop_flag.load()) {
    const ssize_t bytes_read = recv(source_fd, buffer.data(), buffer.size(), 0);
    if (bytes_read == 0) {
      std::cout << label << ": peer closed connection" << std::endl;
      stop_flag.store(true);
      shutdown(destination_fd, SHUT_WR);
      return;
    }

    if (bytes_read < 0) {
      if (errno == EINTR) {
        continue;
      }
      std::cerr << label << ": recv failed: " << std::strerror(errno) << std::endl;
      stop_flag.store(true);
      shutdown(destination_fd, SHUT_WR);
      return;
    }

    ssize_t total_sent = 0;
    while (total_sent < bytes_read) {
      const ssize_t bytes_sent = send(
          destination_fd,
          buffer.data() + total_sent,
          static_cast<std::size_t>(bytes_read - total_sent),
          0);
      if (bytes_sent < 0) {
        if (errno == EINTR) {
          continue;
        }
        std::cerr << label << ": send failed: " << std::strerror(errno) << std::endl;
        stop_flag.store(true);
        shutdown(destination_fd, SHUT_WR);
        return;
      }
      total_sent += bytes_sent;
    }

    std::cout << label << ": forwarded " << bytes_read << " bytes" << std::endl;
  }
}

}  // namespace

int main(int argc, char* argv[]) {
  try {
    const Config config = parse_args(argc, argv);
    const int listener = create_listener(config.listen_host, config.listen_port);

    std::cout << "Listening on " << config.listen_host << ":" << config.listen_port
              << " and forwarding to " << config.target_host << ":" << config.target_port
              << std::endl;

    while (true) {
      sockaddr_storage client_addr{};
      socklen_t client_len = sizeof(client_addr);
      const int client_fd =
          accept(listener, reinterpret_cast<sockaddr*>(&client_addr), &client_len);

      if (client_fd < 0) {
        if (errno == EINTR) {
          continue;
        }
        throw std::runtime_error("accept failed: " + std::string(std::strerror(errno)));
      }

      std::cout << "Accepted a local client connection" << std::endl;

      int target_fd = -1;
      try {
        target_fd = connect_target(config.target_host, config.target_port);
      } catch (const std::exception& error) {
        std::cerr << error.what() << std::endl;
        close_socket(client_fd);
        continue;
      }

      std::atomic<bool> stop_flag{false};

      std::thread client_to_target(
          forward_stream,
          client_fd,
          target_fd,
          config.buffer_size,
          "client->target",
          std::ref(stop_flag));

      std::thread target_to_client(
          forward_stream,
          target_fd,
          client_fd,
          config.buffer_size,
          "target->client",
          std::ref(stop_flag));

      client_to_target.join();
      target_to_client.join();

      close_socket(client_fd);
      close_socket(target_fd);
      std::cout << "Connection closed" << std::endl;
    }
  } catch (const std::exception& error) {
    std::cerr << "Error: " << error.what() << std::endl;
    return 1;
  }
}
