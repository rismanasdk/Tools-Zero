#!/usr/bin/env bash

set -euo pipefail

TOOLS_ZERO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TOOLS_ZERO_LOG_DIR="${TOOLS_ZERO_LOG_DIR:-${TOOLS_ZERO_ROOT}/logs}"
TOOLS_ZERO_HISTORY_FILE="${TOOLS_ZERO_HISTORY_FILE:-${TOOLS_ZERO_LOG_DIR}/command_history.log}"

tools_zero_slug() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-'
}

tools_zero_timestamp() {
  date '+%Y%m%d-%H%M%S'
}

tools_zero_ensure_log_dir() {
  local tool_slug="$1"
  mkdir -p "${TOOLS_ZERO_LOG_DIR}/${tool_slug}"
}

tools_zero_format_command() {
  printf '%q ' "$@"
}

tools_zero_record_history() {
  local tool_name="$1"
  local status="$2"
  local command_text="$3"

  mkdir -p "${TOOLS_ZERO_LOG_DIR}"
  printf '%s | %s | exit=%s | %s\n' \
    "$(date '+%Y-%m-%d %H:%M:%S')" \
    "${tool_name}" \
    "${status}" \
    "${command_text}" >> "${TOOLS_ZERO_HISTORY_FILE}"
}

tools_zero_print_command() {
  local header="$1"
  shift

  echo
  echo "${header} Command"
  tools_zero_format_command "$@"
  echo
}

tools_zero_require_command() {
  local binary="$1"
  if ! command -v "${binary}" >/dev/null 2>&1; then
    echo "${binary} is not installed."
    echo "Please install ${binary} first, then try again."
    return 1
  fi
}

tools_zero_run_command() {
  local tool_name="$1"
  local binary="$2"
  shift 2

  local tool_slug
  local timestamp
  local log_file
  local command_text
  local status

  tools_zero_require_command "${binary}" || return 1

  tool_slug="$(tools_zero_slug "${tool_name}")"
  tools_zero_ensure_log_dir "${tool_slug}"
  timestamp="$(tools_zero_timestamp)"
  log_file="${TOOLS_ZERO_LOG_DIR}/${tool_slug}/${timestamp}.log"
  command_text="$(tools_zero_format_command "$@")"

  tools_zero_print_command "${tool_name}" "$@"
  echo "Output log: ${log_file}"
  echo

  set +e
  "$@" 2>&1 | tee "${log_file}"
  status=${PIPESTATUS[0]}
  set -e

  tools_zero_record_history "${tool_name}" "${status}" "${command_text}"

  if [ "${status}" -ne 0 ]; then
    echo
    echo "${tool_name} exited with status ${status}."
  fi

  return "${status}"
}
