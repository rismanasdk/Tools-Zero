#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

declare -a AIRSERV_LABELS=(
  "Show help screen"
  "Set TCP port to listen on"
  "Set wifi interface to use"
  "Set channel to use"
  "Set debug level"
)

declare -a AIRSERV_TEMPLATES=(
  "airserv-ng -h"
  "airserv-ng -p [port]"
  "airserv-ng -d [iface]"
  "airserv-ng -c [chan]"
  "airserv-ng -v [level]"
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

run_airserv_ng() {
  tools_zero_run_command "Airserv-ng" "airserv-ng" "$@"
}

main_airserv_ng() {
  echo ""
  echo "Airserv-ng Query"
  echo ""
  echo "Airserv-ng Command"
  echo ""
  
  for i in "${!AIRSERV_LABELS[@]}"; do
    echo "$((i + 1)). ${AIRSERV_LABELS[$i]}"
    echo "${AIRSERV_TEMPLATES[$i]}"
    echo ""
  done
  
  read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airserv-ng>' select
  
  if ! [[ "$select" =~ ^[0-9]+$ ]]; then
    echo "Input command must be a number."
    return 1
  fi
  
  local index=$((select - 1))
  if [[ $index -lt 0 ]] || [[ $index -ge ${#AIRSERV_TEMPLATES[@]} ]]; then
    echo "Selected command is not available."
    return 1
  fi
  
  local cmd
  cmd=$(build_command "${AIRSERV_TEMPLATES[$index]}")
  if [[ -n "$cmd" ]]; then
    eval "run_airserv_ng $cmd"
  fi
}

main_airserv_ng "$@"
