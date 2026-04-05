#!/usr/bin/env bash

set -euo pipefail

require_nikto() {
  if ! command -v nikto >/dev/null 2>&1; then
    echo "nikto is not installed."
    echo "Please install nikto first, then try again."
    return 1
  fi
}

print_command() {
  echo
  echo "Nikto Command"
  printf '%s\n' "$*"
  echo
}

run_nikto() {
  require_nikto || return 1
  print_command "$@"
  "$@"
}
