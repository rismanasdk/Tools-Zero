#!/usr/bin/env bash

# Medusa consolidated orchestrator - Phase 1 refactoring
# Consolidates 14 protocol subdirectories into single file

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

handle_protocol() {
  local protocol="$1"
  
  cat << EOF
${protocol^^} Query - ${protocol^^} Command

1. Basic ${protocol} attack
   medusa -h [host] -u [username] -P [password file] -M ${protocol}
2. ${protocol} attack with port
   medusa -h [host] -u [username] -P [password file] -n [port] -M ${protocol}
3. ${protocol} attack with many hosts
   medusa -H [host file] -U [user file] -P [password file] -M ${protocol}
EOF

  read -r -p $'\nSelect-Options>Medusa>'"${protocol}"> select

  case "$select" in
    1)
      read -r -p "Input host> " host
      read -r -p "Input username> " user
      read -r -p "Input password file> " passfile
      run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M "$protocol"
      ;;
    2)
      read -r -p "Input host> " host
      read -r -p "Input username> " user
      read -r -p "Input password file> " passfile
      read -r -p "Input port> " port
      run_medusa medusa -h "$host" -u "$user" -P "$passfile" -n "$port" -M "$protocol"
      ;;
    3)
      read -r -p "Input host file> " hostfile
      read -r -p "Input user file> " userfile
      read -r -p "Input password file> " passfile
      run_medusa medusa -H "$hostfile" -U "$userfile" -P "$passfile" -M "$protocol"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

main() {
  while true; do
    show_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>Medusa>' select

    case "$select" in
      1) handle_protocol "ssh" ;;
      2) handle_protocol "ftp" ;;
      3) handle_protocol "http-form" ;;
      4) handle_protocol "smbnt" ;;
      5) handle_protocol "mysql" ;;
      6) handle_protocol "telnet" ;;
      7) handle_protocol "vnc" ;;
      8) handle_protocol "smtp" ;;
      9) handle_protocol "pop3" ;;
      10) handle_protocol "imap" ;;
      11) handle_protocol "mssql" ;;
      12) handle_protocol "postgres" ;;
      13) handle_protocol "snmp" ;;
      14) handle_protocol "svn" ;;
      b|B) return 0 ;;
      q|Q) exit 0 ;;
      *)
        echo "Selected option is not available."
        ;;
    esac
    echo
  done
}

main
