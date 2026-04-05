#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  show_menu
  read -r -p $'\nSelect-Options>JohnTheRipper>' select

  case "$select" in
    1) bash "${BASE_DIR}/wordlist/main.sh" ;;
    2) bash "${BASE_DIR}/single/main.sh" ;;
    3) bash "${BASE_DIR}/incremental/main.sh" ;;
    4) bash "${BASE_DIR}/restore-session/main.sh" ;;
    5) bash "${BASE_DIR}/show/main.sh" ;;
    6) bash "${BASE_DIR}/status/main.sh" ;;
    7) bash "${BASE_DIR}/test/main.sh" ;;
    8) bash "${BASE_DIR}/wordlist-rules/main.sh" ;;
    9) bash "${BASE_DIR}/advanced/main.sh" ;;
    *)
      echo "Pilihan belum tersedia."
      ;;
  esac
}

main
