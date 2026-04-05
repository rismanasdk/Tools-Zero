#!/usr/bin/env bash

set -euo pipefail

require_medusa() {
  if ! command -v medusa >/dev/null 2>&1; then
    echo "medusa is not installed."
    echo "Please install medusa first, then try again."
    return 1
  fi
}

print_command() {
  echo
  echo "Medusa Command"
  printf '%s\n' "$*"
  echo
}

run_medusa() {
  require_medusa || return 1
  print_command "$@"
  "$@"
}
