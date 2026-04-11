# Tools Zero

Professional-grade cybersecurity toolkit featuring centralized C/C++ build system with Python orchestration layer. Combines compiled system utilities with unified menu-based distribution of security tools.

## Overview

Tools Zero provides:

- **C/C++ Core Engine** - High-performance compiled tools (DNS lookup, ICMP scanner, process monitor, TCP relay, port knocker, connectivity checker)
- **Unified Toolkit Interface** - Consistent shell-based menus for 10+ security tools (Nmap, Aircrack-ng, Hydra, John, Medusa, Gobuster, Nikto, SQLMap, etc.)
- **Python Orchestration** - CLI entry point with centralized binary management
- **Professional Build System** - Makefile-based compilation and installation

## Key Features

✓ **Centralized C/C++ Compilation** - `core/engines/` with automatic binary discovery and compilation  
✓ **Modular Toolkit Architecture** - Each tool in `toolkit/` with standard structure (common.sh, main\_[tool].sh, help_commands.sh)  
✓ **Python CLI Integration** - Dynamic binary path resolution (local `core/engines/bin/` + system PATH)  
✓ **Professional Build Targets** - `make build`, `make install`, `make clean`, `make dev`  
✓ **Performance Optimized** - C/C++ for intensive operations, Shell for orchestration, Python for high-level control  
✓ **Clean Project Root** - 11 essential files + organized subdirectories

## Project Structure

```
tools-zero/
├── core/engines/              ← Centralized C/C++ build system
│   ├── src/                   (dns_lookup_tool.c, icmp_alive_scanner.c, etc.)
│   ├── bin/                   (Compiled executables)
│   └── Makefile               (Auto-discovers & compiles all C/C++)
│
├── toolkit/                   ← Unified tool interfaces
│   ├── nmap/                  (main_nmap.sh, help_commands.sh, common.sh)
│   ├── aircrack-ng/           (Menu system for WiFi tools)
│   ├── c-utils/               (Wrapper for core/engines/bin/ utilities)
│   ├── tcp-relay/             (Wrapper for local_tcp_relay)
│   ├── hydra/, john/, medusa/ (Password cracking tools)
│   ├── gobuster/, nikto/      (Web scanning tools)
│   └── sqlmap/                (SQL injection tool)
│
├── docs/                      ← Documentation (non-essential)
├── scripts/dev/               ← Development & testing scripts
├── config/                    ← Configuration files
├── logs/                      ← Runtime logs & history
├── sessions/                  ← Session storage
│
├── main.py                    ← Application entry point
├── cli.py                     ← CLI orchestrator
├── menu.py                    ← Menu formatting
├── banner.py                  ← ASCII branding
├── runtime_utils.py           ← Binary path resolution + logging
├── Makefile                   ← Root build orchestration
└── README.md                  ← This file
```

## Requirements

- **Operating System**: Linux (Ubuntu, Debian, CentOS, etc.)
- **Build Tools**: `gcc` (C), `g++` (C++) with C++17 support
- **Scripting**: `bash` 4.0+, `Python 3.7+`
- **Development**: `make`
- **External Tools** (optional): `nmap`, `aircrack-ng`, `hydra`, `john`, `medusa`, `gobuster`, `nikto`, `sqlmap`, etc.

Dependencies can be installed via:

```bash
# Ubuntu/Debian
sudo apt-get install build-essential python3 bash

# Installation script (includes optional tools)
bash scripts/install_tools.sh
```

## Installation

### 1. Clone & Build Core Tools

```bash
# Navigate to project
cd tools-zero

# Compile all C/C++ tools
make build

# (Optional) Install compiled binaries system-wide
make install
```

### 2. Verify Installation

```bash
# Check compiled binaries
ls -l core/engines/bin/

# Run application
python3 main.py
```

## Usage

### Quick Start

```bash
# From project root
make dev                    # Runs: python3 main.py

# Or direct execution
python3 main.py

# Or with CLI options
python3 cli.py
```

### Build Commands

```bash
make build                  # Compile all C/C++ sources to core/engines/bin/
make install                # Install binaries to /usr/local/bin/
make clean                  # Remove build artifacts
make dev                    # Launch main application
make help                   # Show available targets
```

### Compiled Tools (core/engines/bin/)

| Tool                    | Type | Purpose                                  |
| ----------------------- | ---- | ---------------------------------------- |
| `dns_lookup_tool`       | C    | DNS resolution & lookup                  |
| `icmp_alive_scanner`    | C    | ICMP ping sweep (private ranges only)    |
| `linux_process_monitor` | C    | Process inspection & monitoring          |
| `port_knocking_client`  | C    | Port knocking for authorized access      |
| `tcp_connect_checker`   | C    | TCP port availability checker            |
| `local_tcp_relay`       | C++  | Local TCP traffic relay (127.0.0.1 only) |

### Toolkit Tools (toolkit/)

Access via Python menu or direct shell invocation:

```bash
# Via menu (automatically launched from main.py)
toolkit/nmap/main_nmap.sh
toolkit/aircrack-ng/main_aircrack_ng.sh
toolkit/hydra/main_hydra.sh
# ... and more
```

### C Utilities Wrapper

```bash
# Unified interface for compiled C tools
toolkit/c-utils/main_c_utils.sh

# Directly invoke compiled tools
core/engines/bin/dns_lookup_tool example.com
core/engines/bin/icmp_alive_scanner 192.168.1.0/24
```

## Architecture

### Core Layer (C/C++)

Located in `core/engines/`, these compiled tools provide high-performance utilities:

- **dns_lookup_tool** - DNS queries with caching
- **icmp_alive_scanner** - Parallelized ICMP scanning (private networks only)
- **linux_process_monitor** - Real-time process inspection
- **port_knocking_client** - Authorized port knock sequences
- **tcp_connect_checker** - TCP connectivity verification
- **local_tcp_relay** - Loopback-only traffic relay (127.0.0.1)

### Toolkit Layer (Shell + Python)

Located in `toolkit/`, each subdirectory provides consistent interface:

- `common.sh` - Shared utilities and logging
- `main_[tool].sh` - Interactive menu-driven launch wrapper
- `help_commands.sh` - Context-specific help/documentation

Supports: Nmap, Aircrack-ng, Hydra, John the Ripper, Medusa, Gobuster, Nikto, SQLMap, etc.

### Orchestration Layer (Python)

Located in root, coordinates all execution:

- `main.py` - Application entry point
- `cli.py` - Command dispatcher and tool orchestration
- `runtime_utils.py` - Binary path resolution, logging, command execution
- `menu.py` - Menu formatting utilities
- `banner.py` - ASCII art branding

### Build System

- **Root Makefile** - Orchestrates core/engines builds, provides convenience targets
- **core/engines/Makefile** - Auto-discovers .c/.cpp files, compiles independently to bin/
- Zero-dependency builds - All tools compile with standard gcc/g++

## Security Notes

- **TCP Relay** intentionally binds only to loopback (`127.0.0.1`, `::1`) for local debugging
- **ICMP Scanner** limited to private IPv4 ranges (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- **Port Knocking** designed for authorized network environments only
- All external tools require explicit permission before use

## Development

### Project Status

Currently in production. Active development at `/scripts/dev/`.

### Adding New Tools

1. Create `toolkit/[tool]/` directory
2. Add required files:
   ```
   toolkit/[tool]/
   ├── common.sh             (Source shared utilities)
   ├── help_commands.sh      (Menu items & descriptions)
   └── main_[tool].sh        (Tool orchestration script)
   ```
3. Follow existing patterns from `toolkit/nmap/` or `toolkit/aircrack-ng/`

### Adding New C/C++ Tools

1. Add source to `core/engines/src/[tool].c` or `[tool].cpp`
2. Ensure `main()` function exists
3. Run `make build` - automatic compilation to `core/engines/bin/[tool]`
4. Create wrapper in `toolkit/` if needed

### Compilation Details

The build system:

- Compiles each `.c` file independently with gcc (C99 standard)
- Compiles each `.cpp` file independently with g++ (C++17 standard)
- Uses aggressive optimization flags `-O2`
- Links against standard libraries as needed
- Outputs executables to `core/engines/bin/`

Windows support not included - Linux/Unix only.

## Contributing

Contributions are welcome. Please:

1. **Report Issues** - Use GitHub Issues for bugs/features
2. **Create Feature Branch** - `git checkout -b feature/your-feature`
3. **Follow Standards** - Maintain code style (C: POSIX/GNU, Python: PEP8, Shell: POSIX sh)
4. **Test Locally** - Run `make clean && make build` before submitting
5. **Submit PR** - Include description, test results, and any new dependencies

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed workflow.

## Troubleshooting

| Issue                                       | Solution                                                  |
| ------------------------------------------- | --------------------------------------------------------- |
| `Command not found` during `main_[tool].sh` | Run `make build` first to compile core tools              |
| Build fails with compiler errors            | Ensure gcc/g++ C++17 support: `g++ --version`             |
| Tools directory not found                   | Run from project root: `cd tools-zero && python3 main.py` |
| Permission denied at /usr/local/bin         | Use: `make install` (may require sudo)                    |
| Import errors in Python                     | Verify Python 3.7+: `python3 --version`                   |

## License

See [LICENSE](LICENSE) for license details.

## Disclaimer

This toolkit is provided for authorized security testing and system administration only. Users are responsible for ensuring they have explicit permission before running any security tools. Unauthorized access to computer systems is illegal.
