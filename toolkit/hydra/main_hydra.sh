#!/usr/bin/env bash

# Hydra consolidated orchestrator - Phase 1 refactoring
# Consolidates 7 protocol subdirectories (ssh, ftp, http-post-form, smb, rdp, telnet, mysql)

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
   hydra -l [username] -P [password file] ${protocol}://[target]
2. ${protocol} attack with port
   hydra -l [username] -P [password file] -s [port] ${protocol}://[target]
3. ${protocol} wordlist attack
   hydra -L [user file] -P [password file] ${protocol}://[target]
EOF

  read -r -p $'\nSelect-Options>Hydra>'"${protocol}"> select

  case "$select" in
    1)
      read -r -p "Input username> " username
      read -r -p "Input password list> " passlist
      read -r -p "Input target> " target
      run_hydra hydra -l "$username" -P "$passlist" "${protocol}://${target}"
      ;;
    2)
      read -r -p "Input username> " username
      read -r -p "Input password list> " passlist
      read -r -p "Input port> " port
      read -r -p "Input target> " target
      run_hydra hydra -l "$username" -P "$passlist" -s "$port" "${protocol}://${target}"
      ;;
    3)
      read -r -p "Input user list> " userlist
      read -r -p "Input password list> " passlist
      read -r -p "Input target> " target
      run_hydra hydra -L "$userlist" -P "$passlist" "${protocol}://${target}"
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
    read -r -p $'\nSelect-Options>Hydra>' select

    case "$select" in
      1) handle_protocol "ssh" ;;
      2) handle_protocol "ftp" ;;
      3) handle_protocol "http-post-form" ;;
      4) handle_protocol "smb" ;;
      5) handle_protocol "rdp" ;;
      6) handle_protocol "telnet" ;;
      7) handle_protocol "mysql" ;;
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
