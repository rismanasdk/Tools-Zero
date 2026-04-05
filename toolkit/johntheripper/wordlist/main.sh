#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Wordlist Mode Query
Wordlist Mode Command

1. Basic wordlist attack
john -wordlist:[wordlist file] [password file]
2. Wordlist with rules
john -wordlist:[wordlist file] -rules [password file]
3. Wordlist with session
john -wordlist:[wordlist file] -session:[session file] [password file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Wordlist>' select

case "$select" in
  1)
    read -r -p "Input wordlist file> " wordlist
    read -r -p "Input password file> " passwd
    run_john john -wordlist:"$wordlist" "$passwd"
    ;;
  2)
    read -r -p "Input wordlist file> " wordlist
    read -r -p "Input password file> " passwd
    run_john john -wordlist:"$wordlist" -rules "$passwd"
    ;;
  3)
    read -r -p "Input wordlist file> " wordlist
    read -r -p "Input session file> " session
    read -r -p "Input password file> " passwd
    run_john john -wordlist:"$wordlist" -session:"$session" "$passwd"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
