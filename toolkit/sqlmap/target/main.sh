#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Target Query
Target Command

1. Target URL
sqlmap -u [url] --batch
2. Direct DB connection
sqlmap -d [connection string] --batch
3. Parse proxy log file
sqlmap -l [log file] --batch
4. Scan multiple targets
sqlmap -m [bulk file] --batch
5. Load HTTP request from file
sqlmap -r [request file] --batch
6. Google dork targets
sqlmap -g [google dork] --batch
7. Load config file
sqlmap -c [config file] --batch
EOF

read -r -p $'\nSelect-Options>Sqlmap>Target>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --batch
    ;;
  2)
    read -r -p "Input direct connection string> " dsn
    run_sqlmap sqlmap -d "$dsn" --batch
    ;;
  3)
    read -r -p "Input log file> " logfile
    run_sqlmap sqlmap -l "$logfile" --batch
    ;;
  4)
    read -r -p "Input bulk file> " bulkfile
    run_sqlmap sqlmap -m "$bulkfile" --batch
    ;;
  5)
    read -r -p "Input request file> " requestfile
    run_sqlmap sqlmap -r "$requestfile" --batch
    ;;
  6)
    read -r -p "Input Google dork> " dork
    run_sqlmap sqlmap -g "$dork" --batch
    ;;
  7)
    read -r -p "Input config file> " config
    run_sqlmap sqlmap -c "$config" --batch
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
