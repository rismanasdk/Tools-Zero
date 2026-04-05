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
    read -r -p $'\nSelect-Options>Sqlmap>' select

    case "$select" in
      1) bash "${BASE_DIR}/target/main.sh" ;;
      2) bash "${BASE_DIR}/request/main.sh" ;;
      3) bash "${BASE_DIR}/enumeration/main.sh" ;;
      4) bash "${BASE_DIR}/file-system/main.sh" ;;
      5) bash "${BASE_DIR}/os-access/main.sh" ;;
      6) bash "${BASE_DIR}/general/main.sh" ;;
      7) bash "${BASE_DIR}/misc/main.sh" ;;
      b|B) return 0 ;;
      q|Q) exit 0 ;;
      *)
        echo "Selected command is not available."
        ;;
    esac
    echo
  done
}

main
