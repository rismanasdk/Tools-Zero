#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
IMAP Query
IMAP Command

1. Basic IMAP attack
medusa -h [host] -u [username] -P [password file] -M imap
2. IMAP SSL attack
medusa -h [host] -u [username] -P [password file] -s -M imap
EOF

read -r -p $'\nSelect-Options>Medusa>IMAP>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M imap
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -s -M imap
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
