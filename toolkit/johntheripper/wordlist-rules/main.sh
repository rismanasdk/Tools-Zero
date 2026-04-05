#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Wordlist Rules / StdIn / StdOut Query
Wordlist Rules / StdIn / StdOut Command

1. Use wordlist rules
john -wordlist:[wordlist file] -rules [password file]
2. Read wordlist from stdin
john -stdin [password file]
3. Print generated words to stdout
john -stdout [password file]
4. Print generated words to stdout with length
john -stdout:[length] [password file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Wordlist-Rules>' select

case "$select" in
  1)
    read -r -p "Input wordlist file> " wordlist
    read -r -p "Input password file> " passwd
    run_john john -wordlist:"$wordlist" -rules "$passwd"
    ;;
  2)
    read -r -p "Input password file> " passwd
    run_john john -stdin "$passwd"
    ;;
  3)
    read -r -p "Input password file> " passwd
    run_john john -stdout "$passwd"
    ;;
  4)
    read -r -p "Input length> " length
    read -r -p "Input password file> " passwd
    run_john john -stdout:"$length" "$passwd"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
