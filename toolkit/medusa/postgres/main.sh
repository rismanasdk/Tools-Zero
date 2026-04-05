#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
PostgreSQL Query
PostgreSQL Command

1. Basic PostgreSQL attack
medusa -h [host] -u [username] -P [password file] -M postgres
2. PostgreSQL attack with port
medusa -h [host] -u [username] -P [password file] -n [port] -M postgres
EOF

read -r -p $'\nSelect-Options>Medusa>PostgreSQL>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M postgres
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    read -r -p "Input port> " port
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -n "$port" -M postgres
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
