#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/shared/common.sh"

run_john() {
  tools_zero_run_command "JohnTheRipper" "john" "$@"
}
