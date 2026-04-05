#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Incremental Mode Query
Incremental Mode Command

1. Basic incremental attack
john -incremental [password file]
2. Incremental with mode
john -incremental:[mode] [password file]
3. Incremental with format
john -incremental -format:[name] [password file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Incremental>' select

case "$select" in
  1)
    read -r -p "Input password file> " passwd
    run_john john -incremental "$passwd"
    ;;
  2)
    read -r -p "Input incremental mode> " mode
    read -r -p "Input password file> " passwd
    run_john john -incremental:"$mode" "$passwd"
    ;;
  3)
    read -r -p "Input format name> " fmt
    read -r -p "Input password file> " passwd
    run_john john -incremental -format:"$fmt" "$passwd"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
