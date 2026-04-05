#!/usr/bin/env bash

set -euo pipefail

require_nmap() {
  if ! command -v nmap >/dev/null 2>&1; then
    echo "nmap is not installed."
    echo "Please install nmap first, then try again."
    return 1
  fi
}

print_command() {
  echo
  echo "Nmap Command"
  printf '%s\n' "$*"
  echo
}

run_nmap() {
  require_nmap || return 1
  print_command "$@"
  "$@"
}
