#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

PING_SWEEP_SRC="${BASE_DIR}/src/icmp_alive_scanner.c"
PING_SWEEP_BIN="${BASE_DIR}/bin/icmp_alive_scanner"
PROC_MONITOR_SRC="${BASE_DIR}/src/linux_process_monitor.c"
PROC_MONITOR_BIN="${BASE_DIR}/bin/linux_process_monitor"
PORT_KNOCK_SRC="${BASE_DIR}/src/port_knocking_client.c"
PORT_KNOCK_BIN="${BASE_DIR}/bin/port_knocking_client"
TCP_CHECK_SRC="${BASE_DIR}/src/tcp_connect_checker.c"
TCP_CHECK_BIN="${BASE_DIR}/bin/tcp_connect_checker"
DNS_LOOKUP_SRC="${BASE_DIR}/src/dns_lookup_tool.c"
DNS_LOOKUP_BIN="${BASE_DIR}/bin/dns_lookup_tool"

build_all() {
  build_c_tool "${PING_SWEEP_SRC}" "${PING_SWEEP_BIN}"
  build_c_tool "${PROC_MONITOR_SRC}" "${PROC_MONITOR_BIN}"
  build_c_tool "${PORT_KNOCK_SRC}" "${PORT_KNOCK_BIN}"
  build_c_tool "${TCP_CHECK_SRC}" "${TCP_CHECK_BIN}"
  build_c_tool "${DNS_LOOKUP_SRC}" "${DNS_LOOKUP_BIN}"
}

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  while true; do
    show_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>C-Utils>' select

    case "${select}" in
      1)
        read -r -p "Input private CIDR (example 192.168.1.0/24)> " cidr
        read -r -p "Input timeout milliseconds [1000]> " timeout_ms
        read -r -p "Input parallel workers [32]> " parallelism
        timeout_ms="${timeout_ms:-1000}"
        parallelism="${parallelism:-32}"
        build_c_tool "${PING_SWEEP_SRC}" "${PING_SWEEP_BIN}"
        run_c_tool "${PING_SWEEP_BIN}" "${cidr}" "${timeout_ms}" "${parallelism}"
        ;;
      2)
        read -r -p "Input top N processes [10]> " limit
        limit="${limit:-10}"
        build_c_tool "${PROC_MONITOR_SRC}" "${PROC_MONITOR_BIN}"
        run_c_tool "${PROC_MONITOR_BIN}" "${limit}"
        ;;
      3)
        read -r -p "Input host> " host
        read -r -p "Input port sequence (comma-separated)> " ports
        read -r -p "Input delay milliseconds [250]> " delay_ms
        delay_ms="${delay_ms:-250}"
        build_c_tool "${PORT_KNOCK_SRC}" "${PORT_KNOCK_BIN}"
        run_c_tool "${PORT_KNOCK_BIN}" "${host}" "${ports}" "${delay_ms}"
        ;;
      4)
        read -r -p "Input host> " host
        read -r -p "Input port> " port
        read -r -p "Input timeout milliseconds [1000]> " timeout_ms
        timeout_ms="${timeout_ms:-1000}"
        build_c_tool "${TCP_CHECK_SRC}" "${TCP_CHECK_BIN}"
        run_c_tool "${TCP_CHECK_BIN}" "${host}" "${port}" "${timeout_ms}"
        ;;
      5)
        read -r -p "Input hostname or IP> " query
        build_c_tool "${DNS_LOOKUP_SRC}" "${DNS_LOOKUP_BIN}"
        run_c_tool "${DNS_LOOKUP_BIN}" "${query}"
        ;;
      6)
        build_all
        ;;
      b|B)
        return 0
        ;;
      q|Q)
        exit 0
        ;;
      *)
        echo "Selected option is not available."
        ;;
    esac
    echo
  done
}

main
