#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Misc Query
Misc Command

1. Show version
sqlmap --version
2. Update
sqlmap --update
3. List tampers
sqlmap --list-tampers
4. Check dependencies
sqlmap --dependencies
5. Wizard
sqlmap --wizard
6. Save config
sqlmap -u [url] --save=[config file]
7. Offline mode
sqlmap -u [url] --offline --batch
8. Open shell
sqlmap -u [url] --shell --batch
EOF

read -r -p $'\nSelect-Options>Sqlmap>Misc>' select

case "$select" in
  1) run_sqlmap sqlmap --version ;;
  2) run_sqlmap sqlmap --update ;;
  3) run_sqlmap sqlmap --list-tampers ;;
  4) run_sqlmap sqlmap --dependencies ;;
  5) run_sqlmap sqlmap --wizard ;;
  6)
    read -r -p "Input URL> " url
    read -r -p "Input config file> " config
    run_sqlmap sqlmap -u "$url" --save="$config"
    ;;
  7)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --offline --batch
    ;;
  8)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --shell --batch
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
