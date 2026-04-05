#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Version Query
Version Command

1. Show gobuster version
gobuster version
EOF

read -r -p $'\nSelect-Options>Gobuster>VERSION>' select

case "$select" in
  1)
    run_gobuster gobuster version
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
