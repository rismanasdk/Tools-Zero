#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
MySQL Query
MySQL Command

1. Basic MySQL attack
hydra -l [username] -P [passwordlist] mysql://[target]
2. MySQL attack with port
hydra -l [username] -P [passwordlist] -s [port] mysql://[target]
EOF

read -r -p $'\nSelect-Options>Hydra>MySQL>' select

case "$select" in
  1)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" "mysql://$target"
    ;;
  2)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input port> " port
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" -s "$port" "mysql://$target"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac

