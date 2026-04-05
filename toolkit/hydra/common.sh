#!/usr/bin/env bash

set -euo pipefail

require_hydra() {
  if ! command -v hydra >/dev/null 2>&1; then
    echo "hydra is not installed."
    echo "Please install hydra first, then try again."
    return 1
  fi
}

print_command() {
  echo
  echo "Hydra Command"
  printf '%s\n' "$*"
  echo
}

run_hydra() {
  require_hydra || return 1
  print_command "$@"
  "$@"
}

