#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  show_menu
  read -r -p $'\nSelect-Options>Sqlmap>' select

  case "$select" in
    1) bash "${BASE_DIR}/target/main.sh" ;;
    2) bash "${BASE_DIR}/request/main.sh" ;;
    3) bash "${BASE_DIR}/enumeration/main.sh" ;;
    4) bash "${BASE_DIR}/file-system/main.sh" ;;
    5) bash "${BASE_DIR}/os-access/main.sh" ;;
    6) bash "${BASE_DIR}/general/main.sh" ;;
    7) bash "${BASE_DIR}/misc/main.sh" ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

main
