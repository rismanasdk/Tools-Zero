#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
MSSQL Query
MSSQL Command

1. Basic MSSQL attack
medusa -h [host] -u [username] -P [password file] -M mssql
2. MSSQL attack with port
medusa -h [host] -u [username] -P [password file] -n [port] -M mssql
EOF

read -r -p $'\nSelect-Options>Medusa>MSSQL>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M mssql
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    read -r -p "Input port> " port
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -n "$port" -M mssql
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
