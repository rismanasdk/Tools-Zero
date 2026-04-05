#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
SNMP Query
SNMP Command

1. Basic SNMP attack
medusa -h [host] -u [username] -P [password file] -M snmp
EOF

read -r -p $'\nSelect-Options>Medusa>SNMP>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input community/user> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M snmp
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
