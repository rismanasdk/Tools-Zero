#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
MySQL Query
MySQL Command

1. Basic MySQL attack
medusa -h [host] -u [username] -P [password file] -M mysql
2. MySQL attack with port
medusa -h [host] -u [username] -P [password file] -n [port] -M mysql
EOF

read -r -p $'\nSelect-Options>Medusa>MySQL>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M mysql
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    read -r -p "Input port> " port
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -n "$port" -M mysql
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
