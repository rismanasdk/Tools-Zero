#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
POP3 Query
POP3 Command

1. Basic POP3 attack
medusa -h [host] -u [username] -P [password file] -M pop3
2. POP3 SSL attack
medusa -h [host] -u [username] -P [password file] -s -M pop3
EOF

read -r -p $'\nSelect-Options>Medusa>POP3>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M pop3
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -s -M pop3
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
