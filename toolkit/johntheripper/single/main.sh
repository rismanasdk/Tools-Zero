#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Single Crack Mode Query
Single Crack Mode Command

1. Single crack attack
john -single [password file]
2. Single crack with format
john -single -format:[name] [password file]
3. Single crack with session
john -single -session:[session file] [password file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Single>' select

case "$select" in
  1)
    read -r -p "Input password file> " passwd
    run_john john -single "$passwd"
    ;;
  2)
    read -r -p "Input format name> " fmt
    read -r -p "Input password file> " passwd
    run_john john -single -format:"$fmt" "$passwd"
    ;;
  3)
    read -r -p "Input session file> " session
    read -r -p "Input password file> " passwd
    run_john john -single -session:"$session" "$passwd"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
