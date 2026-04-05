#!/usr/bin/env bash

set -euo pipefail

require_john() {
  if ! command -v john >/dev/null 2>&1; then
    echo "john is not installed."
    echo "Please install john first, then try again."
    return 1
  fi
}

print_command() {
  echo
  echo "John Command"
  printf '%s\n' "$*"
  echo
}

run_john() {
  require_john || return 1
  print_command "$@"
  "$@"
}
