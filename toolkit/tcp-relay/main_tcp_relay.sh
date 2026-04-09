#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  while true; do
    show_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>TCP-Relay>' select

    case "${select}" in
      1)
        build_tcp_relay
        ;;
      2)
        read -r -p "Input listen host [127.0.0.1]> " listen_host
        read -r -p "Input listen port> " listen_port
        read -r -p "Input target host> " target_host
        read -r -p "Input target port> " target_port

        listen_host="${listen_host:-127.0.0.1}"

        run_tcp_relay \
          --listen-host "${listen_host}" \
          --listen-port "${listen_port}" \
          --target-host "${target_host}" \
          --target-port "${target_port}"
        ;;
      3)
        run_tcp_relay --help
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
