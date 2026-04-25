n#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${BASE_DIR}/../.." && pwd)"
source "${BASE_DIR}/common.sh"

# Use centralized binaries from core/engines/bin/
PING_SWEEP_BIN="${PROJECT_ROOT}/core/engines/bin/icmp_alive_scanner"
PROC_MONITOR_BIN="${PROJECT_ROOT}/core/engines/bin/linux_process_monitor"
PORT_KNOCK_BIN="${PROJECT_ROOT}/core/engines/bin/port_knocking_client"
TCP_CHECK_BIN="${PROJECT_ROOT}/core/engines/bin/tcp_connect_checker"
DNS_LOOKUP_BIN="${PROJECT_ROOT}/core/engines/bin/dns_lookup_tool"

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
        run_c_tool "${PING_SWEEP_BIN}" "${cidr}" "${timeout_ms}" "${parallelism}"
        ;;
      2)
        read -r -p "Input top N processes [10]> " limit
        limit="${limit:-10}"
        run_c_tool "${PROC_MONITOR_BIN}" "${limit}"
        ;;
      3)
        read -r -p "Input host> " host
        read -r -p "Input port sequence (comma-separated)> " ports
        read -r -p "Input delay milliseconds [250]> " delay_ms
        delay_ms="${delay_ms:-250}"
        run_c_tool "${PORT_KNOCK_BIN}" "${host}" "${ports}" "${delay_ms}"
        ;;
      4)
        read -r -p "Input host> " host
        read -r -p "Input port> " port
        read -r -p "Input timeout milliseconds [1000]> " timeout_ms
        timeout_ms="${timeout_ms:-1000}"
        run_c_tool "${TCP_CHECK_BIN}" "${host}" "${port}" "${timeout_ms}"
        ;;
      5)
        read -r -p "Input hostname or IP> " query
        run_c_tool "${DNS_LOOKUP_BIN}" "${query}"
        ;;
      6)
        run_c_tool "${PING_SWEEP_BIN}" "0.0.0.0/0" "1000" "32"
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
