#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

# Category 1: Common Options
declare -a COMMON_LABELS=(
  "Keep 802.11 header"
  "Filter by access point MAC address"
  "Set target network SSID"
  "Set decrypted output file"
)

declare -a COMMON_TEMPLATES=(
  "airdecap-ng -l [pcap file]"
  "airdecap-ng -b [bssid] [pcap file]"
  "airdecap-ng -e [essid] [pcap file]"
  "airdecap-ng -o [fname] [pcap file]"
)

# Category 2: WEP Specific Option
declare -a WEP_LABELS=(
  "Set WEP key in hex"
  "Set corrupted WEP output file"
)

declare -a WEP_TEMPLATES=(
  "airdecap-ng -w [key] [pcap file]"
  "airdecap-ng -c [fname] [pcap file]"
)

# Category 3: WPA Specific Options
declare -a WPA_LABELS=(
  "Set WPA passphrase"
  "Set WPA Pairwise Master Key in hex"
)

declare -a WPA_TEMPLATES=(
  "airdecap-ng -p [pass] [pcap file]"
  "airdecap-ng -k [pmk] [pcap file]"
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

run_airdecap_ng() {
  tools_zero_run_command "Airdecap-ng" "airdecap-ng" "$@"
}

show_help() {
  echo "1. Common Options"
  echo "2. WEP Specific Option"
  echo "3. WPA Specific Options"
}

show_category_commands() {
  local title="$1"
  local -n labels=$2
  local -n templates=$3
  
  echo ""
  echo "$title"
  echo ""
  echo "Airdecap-ng Query"
  echo ""
  echo "Airdecap-ng Command"
  echo ""
  
  for i in "${!labels[@]}"; do
    echo "$((i + 1)). ${labels[$i]}"
    echo "${templates[$i]}"
    echo ""
  done
}

handle_category() {
  local choice="$1"
  
  case "$choice" in
    1)
      show_category_commands "Common Options" COMMON_LABELS COMMON_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airdecap-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#COMMON_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${COMMON_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airdecap_ng $cmd"
        fi
      fi
      ;;
    2)
      show_category_commands "WEP Specific Option" WEP_LABELS WEP_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airdecap-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#WEP_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${WEP_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airdecap_ng $cmd"
        fi
      fi
      ;;
    3)
      show_category_commands "WPA Specific Options" WPA_LABELS WPA_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airdecap-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#WPA_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${WPA_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airdecap_ng $cmd"
        fi
      fi
      ;;
    *)
      echo "Selected category is not available."
      return 1
      ;;
  esac
}

main_airdecap_ng() {
  show_help
  read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airdecap-ng>' select
  handle_category "$select"
}

main_airdecap_ng "$@"
