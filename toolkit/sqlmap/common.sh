#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/shared/common.sh"

run_sqlmap() {
  tools_zero_run_command "Sqlmap" "sqlmap" "$@"
}
