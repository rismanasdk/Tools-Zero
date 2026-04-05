#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
SMTP Query
SMTP Command

1. SMTP auth attack
medusa -h [host] -u [username] -P [password file] -M smtp
2. SMTP verify attack
medusa -h [host] -u [username] -P [password file] -M smtp-vrfy
EOF

read -r -p $'\nSelect-Options>Medusa>SMTP>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M smtp
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M smtp-vrfy
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
