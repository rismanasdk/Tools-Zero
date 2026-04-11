#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

declare -a AIRGRAPH_LABELS=(
  "Create CAPR graph"
  "Create CPG graph"
  "Create CAPR graph and keep dot file"
  "About"
)

declare -a AIRGRAPH_TEMPLATES=(
  "airgraph-ng -i [input csv] -o [output png] -g CAPR"
  "airgraph-ng -i [input csv] -o [output png] -g CPG"
  "airgraph-ng -i [input csv] -o [output png] -g CAPR -d"
  "airgraph-ng -a"
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

run_airgraph_ng() {
  tools_zero_run_command "Airgraph-ng" "airgraph-ng" "$@"
}

main_airgraph_ng() {
  echo ""
  echo "Airgraph-ng Query"
  echo ""
  echo "Airgraph-ng Command"
  echo ""
  
  for i in "${!AIRGRAPH_LABELS[@]}"; do
    echo "$((i + 1)). ${AIRGRAPH_LABELS[$i]}"
    echo "${AIRGRAPH_TEMPLATES[$i]}"
    echo ""
  done
  
  read -r -p $'\nSelect-Options>Aircrack-ng>Manage-File-Convert>Airgraph-ng>' select
  
  if ! [[ "$select" =~ ^[0-9]+$ ]]; then
    echo "Input command must be a number."
    return 1
  fi
  
  local index=$((select - 1))
  if [[ $index -lt 0 ]] || [[ $index -ge ${#AIRGRAPH_TEMPLATES[@]} ]]; then
    echo "Selected command is not available."
    return 1
  fi
  
  local cmd
  cmd=$(build_command "${AIRGRAPH_TEMPLATES[$index]}")
  if [[ -n "$cmd" ]]; then
    eval "run_airgraph_ng $cmd"
  fi
}

main_airgraph_ng "$@"
