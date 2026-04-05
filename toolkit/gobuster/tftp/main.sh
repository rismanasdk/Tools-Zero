#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
TFTP Query
TFTP Command

1. Basic TFTP brute force
gobuster tftp -s [server] -w [wordlist]
EOF

read -r -p $'\nSelect-Options>Gobuster>TFTP>' select

case "$select" in
  1)
    read -r -p "Input server> " server
    read -r -p "Input wordlist> " wordlist
    run_gobuster gobuster tftp -s "$server" -w "$wordlist"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
