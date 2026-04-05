#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
SSH Query
SSH Command

1. Basic SSH attack
medusa -h [host] -u [username] -P [password file] -M ssh
2. SSH attack with port
medusa -h [host] -u [username] -P [password file] -n [port] -M ssh
3. SSH attack with many hosts
medusa -H [host file] -U [user file] -P [password file] -M ssh
EOF

read -r -p $'\nSelect-Options>Medusa>SSH>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M ssh
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    read -r -p "Input port> " port
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -n "$port" -M ssh
    ;;
  3)
    read -r -p "Input host file> " hostfile
    read -r -p "Input user file> " userfile
    read -r -p "Input password file> " passfile
    run_medusa medusa -H "$hostfile" -U "$userfile" -P "$passfile" -M ssh
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
