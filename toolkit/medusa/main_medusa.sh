#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

main() {
  show_menu
  read -r -p $'\nSelect-Options>Medusa>' select

  case "$select" in
    1) bash "${BASE_DIR}/ssh/main.sh" ;;
    2) bash "${BASE_DIR}/ftp/main.sh" ;;
    3) bash "${BASE_DIR}/http-form/main.sh" ;;
    4) bash "${BASE_DIR}/smbnt/main.sh" ;;
    5) bash "${BASE_DIR}/mysql/main.sh" ;;
    6) bash "${BASE_DIR}/telnet/main.sh" ;;
    7) bash "${BASE_DIR}/vnc/main.sh" ;;
    8) bash "${BASE_DIR}/smtp/main.sh" ;;
    9) bash "${BASE_DIR}/pop3/main.sh" ;;
    10) bash "${BASE_DIR}/imap/main.sh" ;;
    11) bash "${BASE_DIR}/mssql/main.sh" ;;
    12) bash "${BASE_DIR}/postgres/main.sh" ;;
    13) bash "${BASE_DIR}/snmp/main.sh" ;;
    14) bash "${BASE_DIR}/svn/main.sh" ;;
    *)
      echo "Selected option is not available."
      ;;
  esac
}

main

