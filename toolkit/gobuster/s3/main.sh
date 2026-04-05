#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
S3 Query
S3 Command

1. Basic S3 brute force
gobuster s3 -b [bucket] -w [wordlist]
2. S3 brute force with output
gobuster s3 -b [bucket] -w [wordlist] -o [output file]
EOF

read -r -p $'\nSelect-Options>Gobuster>S3>' select

case "$select" in
  1)
    read -r -p "Input bucket> " bucket
    read -r -p "Input wordlist> " wordlist
    run_gobuster gobuster s3 -b "$bucket" -w "$wordlist"
    ;;
  2)
    read -r -p "Input bucket> " bucket
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input output file> " outfile
    run_gobuster gobuster s3 -b "$bucket" -w "$wordlist" -o "$outfile"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
