#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Show Query
Show Command

1. Show cracked passwords
john -show [password file]
2. Show cracked passwords with format
john -show -format:[name] [password file]
3. Show cracked passwords for a session
john -show -session:[file] [password file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Show>' select

case "$select" in
  1)
    read -r -p "Input password file> " passwd
    run_john john -show "$passwd"
    ;;
  2)
    read -r -p "Input format name> " fmt
    read -r -p "Input password file> " passwd
    run_john john -show -format:"$fmt" "$passwd"
    ;;
  3)
    read -r -p "Input session file> " session
    read -r -p "Input password file> " passwd
    run_john john -show -session:"$session" "$passwd"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
