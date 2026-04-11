#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

# Category 1: General Options
declare -a GENERAL_LABELS=(
  "Set packets per second"
  "Set access point MAC address"
  "Capture packets from interface"
  "Read PRGA from file"
  "Use WEP key to encrypt packets"
  "Use WPA passphrase to decrypt packets"
  "Set target network SSID"
  "Set frame direction or WDS tunnel mode"
  "Read frames from pcap file"
  "Set source MAC address"
)

declare -a GENERAL_TEMPLATES=(
  "airtun-ng -x [nbpps] [replay interface]"
  "airtun-ng -a [bssid] [replay interface]"
  "airtun-ng -i [iface] [replay interface]"
  "airtun-ng -y [file] [replay interface]"
  "airtun-ng -w [wepkey] [replay interface]"
  "airtun-ng -p [pass] -a [bssid] -e [essid] [replay interface]"
  "airtun-ng -e [essid] [replay interface]"
  "airtun-ng -t [tods] [replay interface]"
  "airtun-ng -r [file] [replay interface]"
  "airtun-ng -h [MAC] [replay interface]"
)

# Category 2: WDS Bridge Mode Options
declare -a WDS_LABELS=(
  "Set transmitter MAC address"
  "Enable bidirectional mode"
)

declare -a WDS_TEMPLATES=(
  "airtun-ng -s [transmitter] [replay interface]"
  "airtun-ng -b [replay interface]"
)

# Category 3: Repeater Options
declare -a REPEATER_LABELS=(
  "Activate repeat mode"
  "Set BSSID to repeat"
  "Set netmask for BSSID filter"
)

declare -a REPEATER_TEMPLATES=(
  "airtun-ng --repeat [replay interface]"
  "airtun-ng --bssid [mac] [replay interface]"
  "airtun-ng --netmask [mask] [replay interface]"
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

run_airtun_ng() {
  tools_zero_run_command "Airtun-ng" "airtun-ng" "$@"
}

show_help() {
  echo "1. General Options"
  echo "2. WDS Bridge Mode Options"
  echo "3. Repeater Options"
}

show_category_commands() {
  local title="$1"
  local -n labels=$2
  local -n templates=$3
  
  echo ""
  echo "$title"
  echo ""
  echo "Airtun-ng Query"
  echo ""
  echo "Airtun-ng Command"
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
      show_category_commands "General Options" GENERAL_LABELS GENERAL_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airtun-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#GENERAL_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${GENERAL_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airtun_ng $cmd"
        fi
      fi
      ;;
    2)
      show_category_commands "WDS Bridge Mode Options" WDS_LABELS WDS_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airtun-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#WDS_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${WDS_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airtun_ng $cmd"
        fi
      fi
      ;;
    3)
      show_category_commands "Repeater Options" REPEATER_LABELS REPEATER_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airtun-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#REPEATER_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${REPEATER_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airtun_ng $cmd"
        fi
      fi
      ;;
    *)
      echo "Selected category is not available."
      return 1
      ;;
  esac
}

main_airtun_ng() {
  show_help
  read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Airtun-ng>' select
  handle_category "$select"
}

main_airtun_ng "$@"
