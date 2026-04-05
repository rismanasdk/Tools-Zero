#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Test Query
Test Command

1. Benchmark all enabled formats
john -test
2. Benchmark with format override
john -test -format:[name]
EOF

read -r -p $'\nSelect-Options>JohnTheRipper>Test>' select

case "$select" in
  1)
    run_john john -test
    ;;
  2)
    read -r -p "Input format name> " fmt
    run_john john -test -format:"$fmt"
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
