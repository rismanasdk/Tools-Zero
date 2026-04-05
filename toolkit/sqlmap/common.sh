#!/usr/bin/env bash

set -euo pipefail

require_sqlmap() {
  if ! command -v sqlmap >/dev/null 2>&1; then
    echo "sqlmap is not installed."
    echo "Please install sqlmap first, then try again."
    return 1
  fi
}

print_command() {
  echo
  echo "Sqlmap Command"
  printf '%s\n' "$*"
  echo
}

run_sqlmap() {
  require_sqlmap || return 1
  print_command "$@"
  "$@"
}
