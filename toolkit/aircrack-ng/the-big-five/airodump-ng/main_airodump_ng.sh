#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

declare -a AIRODUMP_LABELS=(
  "Save only captured IVs"
  "Use GPSd"
  "Dump file prefix"
  "Record all beacons in dump file"
  "Display update delay in seconds"
  "Print ack/cts/rts statistics"
  "Hide known stations for showack"
  "Time in ms between hopping channels"
  "Set berlin timeout"
  "Read packets from a file"
  "Simulate packet arrival while reading file"
  "Active scanning simulation"
  "Display manufacturer from IEEE OUI list"
  "Display AP uptime from beacon timestamp"
  "Display WPS information"
  "Set output format"
  "Ignore negative one fixed channel message"
  "Set output write interval"
  "Override background detection"
  "Minimum AP packets before display"
  "Filter APs by cipher suite"
  "Filter APs by mask"
  "Filter APs by BSSID"
  "Filter APs by ESSID"
  "Filter APs by ESSID regex"
  "Filter unassociated clients"
  "Set channel to HT20"
  "Set channel to HT40-"
  "Set channel to HT40+"
  "Capture on specific channels"
  "Select hopping band"
  "Use specific frequencies in MHz"
  "Set channel switching method"
)

declare -a AIRODUMP_TEMPLATES=(
  "airodump-ng --ivs [interface]"
  "airodump-ng --gpsd [interface]"
  "airodump-ng --write [prefix] [interface]"
  "airodump-ng --beacons [interface]"
  "airodump-ng --update [secs] [interface]"
  "airodump-ng --showack [interface]"
  "airodump-ng --showack -h [interface]"
  "airodump-ng -f [msecs] [interface]"
  "airodump-ng --berlin [secs] [interface]"
  "airodump-ng -r [file] [interface]"
  "airodump-ng -r [file] -T [interface]"
  "airodump-ng -x [msecs] [interface]"
  "airodump-ng --manufacturer [interface]"
  "airodump-ng --uptime [interface]"
  "airodump-ng --wps [interface]"
  "airodump-ng --output-format [formats] --write [prefix] [interface]"
  "airodump-ng --ignore-negative-one [interface]"
  "airodump-ng --write-interval [seconds] --write [prefix] [interface]"
  "airodump-ng --background [enable] [interface]"
  "airodump-ng -n [int] [interface]"
  "airodump-ng --encrypt [suite] [interface]"
  "airodump-ng --netmask [netmask] [interface]"
  "airodump-ng --bssid [bssid] [interface]"
  "airodump-ng --essid [essid] [interface]"
  "airodump-ng --essid-regex [regex] [interface]"
  "airodump-ng -a [interface]"
  "airodump-ng --ht20 [interface]"
  "airodump-ng --ht40- [interface]"
  "airodump-ng --ht40+ [interface]"
  "airodump-ng --channel [channels] [interface]"
  "airodump-ng --band [abg] [interface]"
  "airodump-ng -C [frequencies] [interface]"
  "airodump-ng --cswitch [method] [interface]"
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

run_airodump_ng() {
  tools_zero_run_command "Airodump-ng" "airodump-ng" "$@"
}

show_commands() {
  echo ""
  echo "The Big Five"
  echo ""
  echo "Airodump-ng Query"
  echo ""
  echo "Airodump-ng Command"
  echo ""
  
  for i in "${!AIRODUMP_LABELS[@]}"; do
    echo "$((i + 1)). ${AIRODUMP_LABELS[$i]}"
    echo "${AIRODUMP_TEMPLATES[$i]}"
    echo ""
  done
}

main_airodump_ng() {
  show_commands
  read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Airodump-ng>' select

  if ! [[ "$select" =~ ^[0-9]+$ ]]; then
    echo "Input command must be a number."
    return 1
  fi

  local index=$((select - 1))
  if [[ $index -lt 0 ]] || [[ $index -ge ${#AIRODUMP_TEMPLATES[@]} ]]; then
    echo "Selected command is not available."
    return 1
  fi

  local command
  command=$(build_command "${AIRODUMP_TEMPLATES[$index]}")
  if [[ -n "$command" ]]; then
    eval "run_airodump_ng $command"
  fi
}

main_airodump_ng "$@"
