#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
GCS Query
GCS Command

1. Basic GCS brute force
gobuster gcs -b [bucket] -w [wordlist]
2. GCS brute force with output
gobuster gcs -b [bucket] -w [wordlist] -o [output file]
EOF

read -r -p $'\nSelect-Options>Gobuster>GCS>' select

case "$select" in
  1)
    read -r -p "Input bucket> " bucket
    read -r -p "Input wordlist> " wordlist
    run_gobuster gobuster gcs -b "$bucket" -w "$wordlist"
    ;;
  2)
    read -r -p "Input bucket> " bucket
    read -r -p "Input wordlist> " wordlist
    read -r -p "Input output file> " outfile
    run_gobuster gobuster gcs -b "$bucket" -w "$wordlist" -o "$outfile"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
