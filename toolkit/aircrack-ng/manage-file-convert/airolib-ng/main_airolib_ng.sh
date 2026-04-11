#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

declare -a AIROLIB_LABELS=(
  "Show database stats"
  "Execute SQL statement"
  "Clean database"
  "Clean database deeply"
  "Start batch processing"
  "Verify database"
  "Verify database deeply"
  "Import ESSID list"
  "Import password list"
  "Import cowpatty file"
  "Export cowpatty file"
)

declare -a AIROLIB_TEMPLATES=(
  "airolib-ng [database] --stats"
  "airolib-ng [database] --sql [sql]"
  "airolib-ng [database] --clean"
  "airolib-ng [database] --clean all"
  "airolib-ng [database] --batch"
  "airolib-ng [database] --verify"
  "airolib-ng [database] --verify all"
  "airolib-ng [database] --import essid [file]"
  "airolib-ng [database] --import passwd [file]"
  "airolib-ng [database] --import cowpatty [file]"
  "airolib-ng [database] --export cowpatty [essid] [file]"
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

run_airolib_ng() {
  tools_zero_run_command "Airolib-ng" "airolib-ng" "$@"
}

main_airolib_ng() {
  echo ""
  echo "Airolib-ng Query"
  echo ""
  echo "Airolib-ng Command"
  echo ""
  
  for i in "${!AIROLIB_LABELS[@]}"; do
    echo "$((i + 1)). ${AIROLIB_LABELS[$i]}"
    echo "${AIROLIB_TEMPLATES[$i]}"
    echo ""
  done
  
  read -r -p $'\nSelect-Options>Aircrack-ng>Manage-File-Convert>Airolib-ng>' select
  
  if ! [[ "$select" =~ ^[0-9]+$ ]]; then
    echo "Input command must be a number."
    return 1
  fi
  
  local index=$((select - 1))
  if [[ $index -lt 0 ]] || [[ $index -ge ${#AIROLIB_TEMPLATES[@]} ]]; then
    echo "Selected command is not available."
    return 1
  fi
  
  local cmd
  cmd=$(build_command "${AIROLIB_TEMPLATES[$index]}")
  if [[ -n "$cmd" ]]; then
    eval "run_airolib_ng $cmd"
  fi
}

main_airolib_ng "$@"
