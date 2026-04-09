#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/../shared/common.sh"

build_c_tool() {
  local source_file="$1"
  local output_file="$2"
  shift 2

  mkdir -p "${BASE_DIR}/bin"

  if [ -x "${output_file}" ] && [ "${output_file}" -nt "${source_file}" ]; then
    return 0
  fi

  tools_zero_run_command \
    "C Utils Build" \
    "gcc" \
    gcc -std=c11 -O2 -Wall -Wextra -pedantic \
    "${source_file}" \
    -o "${output_file}" \
    "$@"
}

run_c_tool() {
  local binary_path="$1"
  shift
  tools_zero_run_command "C Utils" "${binary_path}" "${binary_path}" "$@"
}
