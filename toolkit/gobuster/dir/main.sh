#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
DIR Query
DIR Command

1. Basic directory brute force
gobuster dir -u [url] -w [wordlist]
2. Directory brute force with extensions
gobuster dir -u [url] -w [wordlist] -x [ext1,ext2]
3. Directory brute force with output
gobuster dir -u [url] -w [wordlist] -o [output file]
4. Directory brute force with threads
gobuster dir -u [url] -w [wordlist] -t [threads]
EOF

read -r -p $'\nSelect-Options>Gobuster>DIR>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    run_gobuster gobuster dir -u "$url" -w "$wordlist"
    ;;
  2)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input extensions> " ext
    run_gobuster gobuster dir -u "$url" -w "$wordlist" -x "$ext"
    ;;
  3)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input output file> " outfile
    run_gobuster gobuster dir -u "$url" -w "$wordlist" -o "$outfile"
    ;;
  4)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input threads> " threads
    run_gobuster gobuster dir -u "$url" -w "$wordlist" -t "$threads"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
