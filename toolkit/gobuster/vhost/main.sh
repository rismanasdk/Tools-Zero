#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
VHOST Query
VHOST Command

1. Basic vhost brute force
gobuster vhost -u [url] -w [wordlist]
2. Vhost brute force with output
gobuster vhost -u [url] -w [wordlist] -o [output file]
EOF

read -r -p $'\nSelect-Options>Gobuster>VHOST>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    run_gobuster gobuster vhost -u "$url" -w "$wordlist"
    ;;
  2)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input output file> " outfile
    run_gobuster gobuster vhost -u "$url" -w "$wordlist" -o "$outfile"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
