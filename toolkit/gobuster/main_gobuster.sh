#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  show_menu
  read -r -p $'\nSelect-Options>Gobuster>' select

  case "$select" in
    1) bash "${BASE_DIR}/dir/main.sh" ;;
    2) bash "${BASE_DIR}/dns/main.sh" ;;
    3) bash "${BASE_DIR}/vhost/main.sh" ;;
    4) bash "${BASE_DIR}/fuzz/main.sh" ;;
    5) bash "${BASE_DIR}/gcs/main.sh" ;;
    6) bash "${BASE_DIR}/s3/main.sh" ;;
    7) bash "${BASE_DIR}/tftp/main.sh" ;;
    8) bash "${BASE_DIR}/version/main.sh" ;;
    *)
      echo "Pilihan belum tersedia."
      ;;
  esac
}

main
