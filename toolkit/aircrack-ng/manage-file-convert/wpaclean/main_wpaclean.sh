#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

declare -a WPACLEAN_LABELS=(
  "Clean capture files"
)

declare -a WPACLEAN_TEMPLATES=(
  "wpaclean [out.cap] [in.cap] [in2.cap]"
)

extract_placeholders() {
  local template="$1"
  grep -oP '\[\K[^\]]+(?=\])' <<< "$template" || true
}

build_command() {
  local template="$1"
  local command="$template"
  
  while IFS= read -r placeholder; do
    if [[ -n "$placeholder" ]]; then
      read -r -p "Input $placeholder> " value
      if [[ -z "$value" ]]; then
        echo "$placeholder cannot be empty."
        return 1
      fi
      command="${command//\[$placeholder\]/$value}"
    fi
  done < <(extract_placeholders "$template")
  
  echo "$command"
}

run_wpaclean() {
  tools_zero_run_command "Wpaclean" "wpaclean" "$@"
}

main_wpaclean() {
  echo ""
  echo "Wpaclean Query"
  echo ""
  echo "Wpaclean Command"
  echo ""
  
  for i in "${!WPACLEAN_LABELS[@]}"; do
    echo "$((i + 1)). ${WPACLEAN_LABELS[$i]}"
    echo "${WPACLEAN_TEMPLATES[$i]}"
    echo ""
  done
  
  read -r -p $'\nSelect-Options>Aircrack-ng>Manage-File-Convert>Wpaclean>' select
  
  if [[ "$select" != "1" ]]; then
    echo "Selected command is not available."
    return 1
  fi
  
  local cmd
  cmd=$(build_command "${WPACLEAN_TEMPLATES[0]}")
  if [[ -n "$cmd" ]]; then
    eval "run_wpaclean $cmd"
  fi
}

main_wpaclean "$@"
