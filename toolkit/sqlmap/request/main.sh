#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Request Query
Request Command

1. HTTP method
sqlmap -u [url] --method=[method] --batch
2. POST data
sqlmap -u [url] --data=[data] --batch
3. Cookie
sqlmap -u [url] --cookie=[cookie] --batch
4. Headers
sqlmap -u [url] --headers=[headers] --batch
5. Auth
sqlmap -u [url] --auth-type=[type] --auth-cred=[cred] --batch
6. Proxy
sqlmap -u [url] --proxy=[proxy] --batch
EOF

read -r -p $'\nSelect-Options>Sqlmap>Request>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    read -r -p "Input method> " method
    run_sqlmap sqlmap -u "$url" --method="$method" --batch
    ;;
  2)
    read -r -p "Input URL> " url
    read -r -p "Input data> " data
    run_sqlmap sqlmap -u "$url" --data="$data" --batch
    ;;
  3)
    read -r -p "Input URL> " url
    read -r -p "Input cookie> " cookie
    run_sqlmap sqlmap -u "$url" --cookie="$cookie" --batch
    ;;
  4)
    read -r -p "Input URL> " url
    read -r -p "Input headers> " headers
    run_sqlmap sqlmap -u "$url" --headers="$headers" --batch
    ;;
  5)
    read -r -p "Input URL> " url
    read -r -p "Input auth type> " atype
    read -r -p "Input auth cred> " acred
    run_sqlmap sqlmap -u "$url" --auth-type="$atype" --auth-cred="$acred" --batch
    ;;
  6)
    read -r -p "Input URL> " url
    read -r -p "Input proxy> " proxy
    run_sqlmap sqlmap -u "$url" --proxy="$proxy" --batch
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
