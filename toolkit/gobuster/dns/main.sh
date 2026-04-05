#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
DNS Query
DNS Command

1. Basic DNS brute force
gobuster dns -d [domain] -w [wordlist]
2. DNS brute force with output
gobuster dns -d [domain] -w [wordlist] -o [output file]
3. DNS brute force with threads
gobuster dns -d [domain] -w [wordlist] -t [threads]
EOF

read -r -p $'\nSelect-Options>Gobuster>DNS>' select

case "$select" in
  1)
    read -r -p "Input domain> " domain
    read -r -p "Input wordlist> " wordlist
    run_gobuster gobuster dns -d "$domain" -w "$wordlist"
    ;;
  2)
    read -r -p "Input domain> " domain
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input output file> " outfile
    run_gobuster gobuster dns -d "$domain" -w "$wordlist" -o "$outfile"
    ;;
  3)
    read -r -p "Input domain> " domain
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input threads> " threads
    run_gobuster gobuster dns -d "$domain" -w "$wordlist" -t "$threads"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
