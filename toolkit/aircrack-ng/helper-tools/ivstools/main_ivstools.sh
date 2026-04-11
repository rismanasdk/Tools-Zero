#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

declare -a IVSTOOLS_LABELS=(
  "Extract IVs from a pcap file"
  "Merge IVS files"
)

declare -a IVSTOOLS_TEMPLATES=(
  "ivstools --convert [pcap file] [ivs output file]"
  "ivstools --merge [ivs file 1] [ivs file 2] [output file]"
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

run_ivstools() {
  tools_zero_run_command "IvsTools" "ivstools" "$@"
}

main_ivstools() {
  echo ""
  echo "IvsTools Query"
  echo ""
  echo "IvsTools Command"
  echo ""
  
  for i in "${!IVSTOOLS_LABELS[@]}"; do
    echo "$((i + 1)). ${IVSTOOLS_LABELS[$i]}"
    echo "${IVSTOOLS_TEMPLATES[$i]}"
    echo ""
  done
  
  read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>IvsTools>' select
  
  if ! [[ "$select" =~ ^[0-9]+$ ]]; then
    echo "Input command must be a number."
    return 1
  fi
  
  local index=$((select - 1))
  if [[ $index -lt 0 ]] || [[ $index -ge ${#IVSTOOLS_TEMPLATES[@]} ]]; then
    echo "Selected command is not available."
    return 1
  fi
  
  local cmd
  cmd=$(build_command "${IVSTOOLS_TEMPLATES[$index]}")
  if [[ -n "$cmd" ]]; then
    eval "run_ivstools $cmd"
  fi
}

main_ivstools "$@"
