#!/usr/bin/env bash

set -euo pipefail

require_gobuster() {
  if ! command -v gobuster >/dev/null 2>&1; then
    echo "gobuster is not installed."
    echo "Please install gobuster first, then try again."
    return 1
  fi
}

print_command() {
  echo
  echo "Gobuster Command"
  printf '%s\n' "$*"
  echo
}

run_gobuster() {
  require_gobuster || return 1
  print_command "$@"
  "$@"
}
