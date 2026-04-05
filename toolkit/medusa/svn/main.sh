#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
SVN Query
SVN Command

1. Basic SVN attack
medusa -h [host] -u [username] -P [password file] -M svn
EOF

read -r -p $'\nSelect-Options>Medusa>SVN>' select

case "$select" in
  1)
    read -r -p "Input host> " host
    read -r -p "Input username> " user
    read -r -p "Input password file> " passfile
    run_medusa medusa -h "$host" -u "$user" -P "$passfile" -M svn
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
