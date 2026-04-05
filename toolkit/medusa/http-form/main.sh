#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
HTTP-Form Query
HTTP-Form Command

1. Basic web form attack
medusa -h [host] -u [username] -P [password file] -M web-form -m DIR:[path] -m PARAMS:[params] -m F:[fail string]
2. Web form with SSL
medusa -h [host] -u [username] -P [password file] -s -M web-form -m DIR:[path] -m PARAMS:[params] -m F:[fail string]
EOF

read -r -p $'\nSelect-Options>Medusa>HTTP-Form>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    read -r -p "Input path> " path
    read -r -p "Input params> " params
    read -r -p "Input fail string> " fail
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M web-form -m "DIR:$path" -m "PARAMS:$params" -m "F:$fail"
    ;;
  2)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    read -r -p "Input path> " path
    read -r -p "Input params> " params
    read -r -p "Input fail string> " fail
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -s -M web-form -m "DIR:$path" -m "PARAMS:$params" -m "F:$fail"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
