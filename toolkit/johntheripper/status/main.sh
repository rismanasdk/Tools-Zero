#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Status Query
Status Command

1. Show status
john -status
2. Show status for a session
john -status:[file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Status>' select

case "$select" in
  1)
    run_john john -status
    ;;
  2)
    read -r -p "Input session file> " session
    run_john john -status:"$session"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
