#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
source "${PARENT_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  while true; do
    show_menu
    echo "b. Back"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>' select

    case "$select" in
      1) run_aircrack_python "${BASE_DIR}/airdecap-ng/main_airdecap_ng.py" ;;
      2) run_aircrack_python "${BASE_DIR}/airserv-ng/main_airserv_ng.py" ;;
      3) run_aircrack_python "${BASE_DIR}/airtun-ng/main_airtun_ng.py" ;;
      4) run_aircrack_python "${BASE_DIR}/ivstools/main_ivstools.py" ;;
      5) run_aircrack_python "${BASE_DIR}/packetforge-ng/main_packetforge_ng.py" ;;
      b|B) return 0 ;;
      q|Q) exit 0 ;;
      *)
        echo "Category selection is not yet available."
        ;;
    esac
    echo
  done
}

main
