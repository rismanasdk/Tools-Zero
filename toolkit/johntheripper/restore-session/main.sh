#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Restore / Session Query
Restore / Session Command

1. Restore latest session
john -restore
2. Restore a specific session
john -restore:[file]
3. Set session name
john -session:[file] [password file]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Restore>' select

case "$select" in
  1)
    run_john john -restore
    ;;
  2)
    read -r -p "Input restore file> " restore_file
    run_john john -restore:"$restore_file"
    ;;
  3)
    read -r -p "Input session file> " session
    read -r -p "Input password file> " passwd
    run_john john -session:"$session" "$passwd"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
