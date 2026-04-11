#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

# Category 1: Options
declare -a OPTIONS_LABELS=(
  "Set access point MAC address"
  "Capture packets from interface"
  "Use WEP key to encrypt or decrypt packets"
  "Set source MAC for MITM mode"
  "Disallow specified client MACs"
  "Set WEP flag in beacons"
  "Quiet mode"
  "Verbose mode"
  "Enable MITM mode"
  "Enable ad-hoc mode"
  "External packet processing"
  "Set channel"
  "Hidden ESSID"
  "Force shared key authentication"
  "Set shared key challenge length"
  "Enable Caffe-Latte attack"
  "Enable Hirte attack"
  "Set packets per second"
  "Disable responses to broadcast probes"
  "Set all WPA WEP open tags"
  "Set WPA1 tags"
  "Set WPA2 tags"
  "Set fake EAPOL type"
  "Write sent and received frames to pcap file"
  "Respond to all probes"
  "Set beacon interval"
  "Enable beaconing of probed ESSIDs"
)

declare -a OPTIONS_TEMPLATES=(
  "airbase-ng -a [bssid] [replay interface]"
  "airbase-ng -i [iface] [replay interface]"
  "airbase-ng -w [WEP key] [replay interface]"
  "airbase-ng -h [MAC] [replay interface]"
  "airbase-ng -f [disallow] [replay interface]"
  "airbase-ng -W [0|1] [replay interface]"
  "airbase-ng -q [replay interface]"
  "airbase-ng -v [replay interface]"
  "airbase-ng -M [replay interface]"
  "airbase-ng -A [replay interface]"
  "airbase-ng -Y [in|out|both] [replay interface]"
  "airbase-ng -c [channel] [replay interface]"
  "airbase-ng -X [replay interface]"
  "airbase-ng -s [replay interface]"
  "airbase-ng -S [length] [replay interface]"
  "airbase-ng -L [replay interface]"
  "airbase-ng -N [replay interface]"
  "airbase-ng -x [nbpps] [replay interface]"
  "airbase-ng -y [replay interface]"
  "airbase-ng -0 [replay interface]"
  "airbase-ng -z [type] [replay interface]"
  "airbase-ng -Z [type] [replay interface]"
  "airbase-ng -V [type] [replay interface]"
  "airbase-ng -F [prefix] [replay interface]"
  "airbase-ng -P [replay interface]"
  "airbase-ng -I [interval] [replay interface]"
  "airbase-ng -C [seconds] -P [replay interface]"
)

# Category 2: Filter Options
declare -a FILTER_LABELS=(
  "Filter or use a BSSID"
  "Read BSSID list from file"
  "Accept client by MAC"
  "Read client MAC list from file"
  "Specify a single ESSID"
  "Read ESSID list from file"
)

declare -a FILTER_TEMPLATES=(
  "airbase-ng --bssid [MAC] [replay interface]"
  "airbase-ng --bssids [file] [replay interface]"
  "airbase-ng --client [MAC] [replay interface]"
  "airbase-ng --clients [file] [replay interface]"
  "airbase-ng --essid [ESSID] [replay interface]"
  "airbase-ng --essids [file] [replay interface]"
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

run_airbase_ng() {
  tools_zero_run_command "Airbase-ng" "airbase-ng" "$@"
}

show_help() {
  echo "1. Options"
  echo "2. Filter Options"
}

show_category_commands() {
  local category="$1"
  local title="$2"
  local -n labels=$3
  local -n templates=$4
  
  echo ""
  echo "$title"
  echo ""
  echo "Airbase-ng Query"
  echo ""
  echo "Airbase-ng Command"
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
      show_category_commands "1" "Options" OPTIONS_LABELS OPTIONS_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Airbase-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#OPTIONS_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${OPTIONS_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airbase_ng $cmd"
        fi
      fi
      ;;
    2)
      show_category_commands "2" "Filter Options" FILTER_LABELS FILTER_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Airbase-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#FILTER_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${FILTER_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_airbase_ng $cmd"
        fi
      fi
      ;;
    *)
      echo "Selected category is not available."
      return 1
      ;;
  esac
}

main_airbase_ng() {
  show_help
  read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Airbase-ng>' select
  handle_category "$select"
}

main_airbase_ng "$@"
