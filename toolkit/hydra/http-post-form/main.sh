#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
HTTP-Post-Form Query
HTTP-Post-Form Command

1. Basic http-post-form attack
hydra -l [username] -P [passwordlist] [target] http-post-form "[path]:[params]:F=[fail string]"
2. http-post-form attack with port
hydra -l [username] -P [passwordlist] -s [port] [target] http-post-form "[path]:[params]:F=[fail string]"
EOF

read -r -p $'\nSelect-Options>Hydra>HTTP-Post-Form>' select

case "$select" in
  1)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input target URL or host> " target
    read -r -p "Input path> " path
    read -r -p "Input params> " params
    read -r -p "Input fail string> " fail
    run_hydra hydra -l "$username" -P "$passlist" "$target" http-post-form "$path:$params:F=$fail"
    ;;
  2)
    read -r -p "Input username> " username
    read -r -p "Input password list> " passlist
    read -r -p "Input port> " port
    read -r -p "Input target URL or host> " target
    read -r -p "Input path> " path
    read -r -p "Input params> " params
    read -r -p "Input fail string> " fail
    run_hydra hydra -l "$username" -P "$passlist" -s "$port" "$target" http-post-form "$path:$params:F=$fail"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac

