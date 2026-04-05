#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
FUZZ Query
FUZZ Command

1. Basic fuzzing
gobuster fuzz -u [url] -w [wordlist]
2. Fuzzing with pattern
gobuster fuzz -u [url] -w [wordlist] -p [pattern file]
EOF

read -r -p $'\nSelect-Options>Gobuster>FUZZ>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    run_gobuster gobuster fuzz -u "$url" -w "$wordlist"
    ;;
  2)
    read -r -p "Input URL> " url
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input pattern file> " pattern
    run_gobuster gobuster fuzz -u "$url" -w "$wordlist" -p "$pattern"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
