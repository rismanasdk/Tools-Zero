#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Advanced Query
Advanced Command

1. Set format
john -format:[name] [password file]
2. Set users filter
john -users:[login|uid] [password file]
3. Set shells filter
john -shells:[shell] [password file]
4. Set groups filter
john -groups:[gid] [password file]
5. Set external mode
john -external:[mode] [password file]
6. Make charset file
john -makechars:[file] [password file]
7. Set salts
john -salts:[count] [password file]
8. Set save memory level
john -savemem:[level] [password file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Advanced>' select

case "$select" in
  1)
    read -r -p "Input format name> " fmt
    read -r -p "Input password file> " passwd
    run_john john -format:"$fmt" "$passwd"
    ;;
  2)
    read -r -p "Input users filter> " users
    read -r -p "Input password file> " passwd
    run_john john -users:"$users" "$passwd"
    ;;
  3)
    read -r -p "Input shells filter> " shells
    read -r -p "Input password file> " passwd
    run_john john -shells:"$shells" "$passwd"
    ;;
  4)
    read -r -p "Input groups filter> " groups
    read -r -p "Input password file> " passwd
    run_john john -groups:"$groups" "$passwd"
    ;;
  5)
    read -r -p "Input external mode> " mode
    read -r -p "Input password file> " passwd
    run_john john -external:"$mode" "$passwd"
    ;;
  6)
    read -r -p "Input charset file> " charset
    read -r -p "Input password file> " passwd
    run_john john -makechars:"$charset" "$passwd"
    ;;
  7)
    read -r -p "Input salts count> " salts
    read -r -p "Input password file> " passwd
    run_john john -salts:"$salts" "$passwd"
    ;;
  8)
    read -r -p "Input save memory level> " level
    read -r -p "Input password file> " passwd
    run_john john -savemem:"$level" "$passwd"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
