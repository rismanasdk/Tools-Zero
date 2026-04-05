#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/shared/common.sh"

require_python3() {
  tools_zero_require_command "python3"
}

run_aircrack_python() {
  local script_path="$1"
  shift || true

  require_python3 || return 1
  python3 "${script_path}" "$@"
}
