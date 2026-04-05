#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
SSH Query
SSH Command

1. Basic SSH login attack
hydra -l [username] -P [passwordlist] ssh://[target]
2. SSH attack with port
hydra -l [username] -P [passwordlist] -s [port] ssh://[target]
EOF

read -r -p $'\nSelect-Options>Hydra>SSH>' select

case "$select" in
  1)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" "ssh://$target"
    ;;
  2)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input port> " port
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" -s "$port" "ssh://$target"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac

