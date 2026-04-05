#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
General Query
General Command

1. Batch mode
sqlmap -u [url] --batch
2. Crawl
sqlmap -u [url] --crawl=[depth] --batch
3. Set level and risk
sqlmap -u [url] --level=[level] --risk=[risk] --batch
4. Set threads
sqlmap -u [url] --threads=[threads] --batch
5. Set time limit
sqlmap -u [url] --time-limit=[seconds] --batch
6. Force forms
sqlmap -u [url] --forms --batch
EOF

read -r -p $'\nSelect-Options>Sqlmap>General>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --batch
    ;;
  2)
    read -r -p "Input URL> " url
    read -r -p "Input crawl depth> " depth
    run_sqlmap sqlmap -u "$url" --crawl="$depth" --batch
    ;;
  3)
    read -r -p "Input URL> " url
    read -r -p "Input level> " level
    read -r -p "Input risk> " risk
    run_sqlmap sqlmap -u "$url" --level="$level" --risk="$risk" --batch
    ;;
  4)
    read -r -p "Input URL> " url
    read -r -p "Input threads> " threads
    run_sqlmap sqlmap -u "$url" --threads="$threads" --batch
    ;;
  5)
    read -r -p "Input URL> " url
    read -r -p "Input time limit> " seconds
    run_sqlmap sqlmap -u "$url" --time-limit="$seconds" --batch
    ;;
  6)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --forms --batch
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
