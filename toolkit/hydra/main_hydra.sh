#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  show_menu
  read -r -p $'\nSelect-Options>Hydra>' select

  case "$select" in
    1) bash "${BASE_DIR}/ssh/main.sh" ;;
    2) bash "${BASE_DIR}/ftp/main.sh" ;;
    3) bash "${BASE_DIR}/http-post-form/main.sh" ;;
    4) bash "${BASE_DIR}/smb/main.sh" ;;
    5) bash "${BASE_DIR}/rdp/main.sh" ;;
    6) bash "${BASE_DIR}/telnet/main.sh" ;;
    7) bash "${BASE_DIR}/mysql/main.sh" ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

main

