#!/usr/bin/env bash

set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${THIS_DIR}/.." && pwd)"
source "${PARENT_DIR}/common.sh"

show_menu() {
  bash "${THIS_DIR}/help_commands.sh"
}

main() {
  while true; do
    show_menu
    echo "b. Back"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>Aircrack-ng>Manage-File-Convert>' select

    case "$select" in
      1) run_aircrack_python "${THIS_DIR}/airgraph-ng/main_airgraph_ng.py" ;;
      2) run_aircrack_python "${THIS_DIR}/airolib-ng/main_airolib_ng.py" ;;
      3) run_aircrack_python "${THIS_DIR}/wpaclean/main_wpaclean.py" ;;
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
