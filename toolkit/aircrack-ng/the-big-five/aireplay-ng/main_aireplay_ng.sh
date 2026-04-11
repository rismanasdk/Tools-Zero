#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

# Category 1: Filter Options
declare -a FILTER_LABELS=(
  "Set access point MAC address"
  "Set destination MAC address"
  "Set source MAC address"
  "Set minimum packet length"
  "Set maximum packet length"
  "Set frame control type field"
  "Set frame control subtype field"
  "Set To DS bit"
  "Set From DS bit"
  "Set WEP bit"
)

declare -a FILTER_TEMPLATES=(
  "aireplay-ng -b [bssid] [replay interface]"
  "aireplay-ng -d [dmac] [replay interface]"
  "aireplay-ng -s [smac] [replay interface]"
  "aireplay-ng -m [len] [replay interface]"
  "aireplay-ng -n [len] [replay interface]"
  "aireplay-ng -u [type] [replay interface]"
  "aireplay-ng -v [subt] [replay interface]"
  "aireplay-ng -t [tods] [replay interface]"
  "aireplay-ng -f [fromds] [replay interface]"
  "aireplay-ng -w [iswep] [replay interface]"
)

# Category 2: Replay Options
declare -a REPLAY_LABELS=(
  "Set packets per second"
  "Set frame control word"
  "Set access point MAC address"
  "Set destination MAC address"
  "Set source MAC address"
  "Set target AP SSID for fakeauth or injection test"
  "Inject FromDS packets in ARP replay"
  "Change ring buffer size"
  "Set destination IP in fragments"
  "Set source IP in fragments"
  "Set packets per burst"
  "Set keep-alive interval"
  "Set keystream for shared key auth"
  "Bit rate test"
  "Disable AP detection"
  "Choose first matching packet or fast test"
  "Disable /dev/rtc usage"
)

declare -a REPLAY_TEMPLATES=(
  "aireplay-ng -x [nbpps] [replay interface]"
  "aireplay-ng -p [fctrl] [replay interface]"
  "aireplay-ng -a [bssid] [replay interface]"
  "aireplay-ng -c [dmac] [replay interface]"
  "aireplay-ng -h [smac] [replay interface]"
  "aireplay-ng -e [essid] [replay interface]"
  "aireplay-ng -j [replay interface]"
  "aireplay-ng -g [value] [replay interface]"
  "aireplay-ng -k [IP] [replay interface]"
  "aireplay-ng -l [IP] [replay interface]"
  "aireplay-ng -o [npckts] [replay interface]"
  "aireplay-ng -q [sec] [replay interface]"
  "aireplay-ng -y [prga] [replay interface]"
  "aireplay-ng --bittest [replay interface]"
  "aireplay-ng -D [replay interface]"
  "aireplay-ng --fast [replay interface]"
  "aireplay-ng -R [replay interface]"
)

# Category 3: Source Options
declare -a SOURCE_LABELS=(
  "Capture packets from interface"
  "Extract packets from pcap file"
)

declare -a SOURCE_TEMPLATES=(
  "aireplay-ng [replay interface]"
  "aireplay-ng -r [file] [replay interface]"
)

# Category 4: Attack Modes
declare -a ATTACK_LABELS=(
  "Deauthentication attack"
  "Fake authentication attack"
  "Interactive packet replay"
  "ARP request replay attack"
  "KoreK chopchop attack"
  "Fragmentation attack"
  "Injection test"
)

declare -a ATTACK_TEMPLATES=(
  "aireplay-ng --deauth [count] -a [bssid] [replay interface]"
  "aireplay-ng --fakeauth [delay] -a [bssid] -h [smac] [replay interface]"
  "aireplay-ng --interactive [replay interface]"
  "aireplay-ng --arpreplay -b [bssid] -h [smac] [replay interface]"
  "aireplay-ng --chopchop -b [bssid] [replay interface]"
  "aireplay-ng --fragment -b [bssid] -h [smac] [replay interface]"
  "aireplay-ng --test [replay interface]"
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

run_aireplay_ng() {
  tools_zero_run_command "Aireplay-ng" "aireplay-ng" "$@"
}

show_help() {
  echo "1. Filter Options"
  echo "2. Replay Options"
  echo "3. Source Options"
  echo "4. Attack Modes"
}

show_category_commands() {
  local category="$1"
  local title="$2"
  local -n labels=$3
  local -n templates=$4
  
  echo ""
  echo "$title"
  echo ""
  echo "Aireplay-ng Query"
  echo ""
  echo "Aireplay-ng Command"
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
      show_category_commands "1" "Filter Options" FILTER_LABELS FILTER_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aireplay-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#FILTER_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${FILTER_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aireplay_ng $cmd"
        fi
      fi
      ;;
    2)
      show_category_commands "2" "Replay Options" REPLAY_LABELS REPLAY_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aireplay-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#REPLAY_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${REPLAY_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aireplay_ng $cmd"
        fi
      fi
      ;;
    3)
      show_category_commands "3" "Source Options" SOURCE_LABELS SOURCE_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aireplay-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#SOURCE_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${SOURCE_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aireplay_ng $cmd"
        fi
      fi
      ;;
    4)
      show_category_commands "4" "Attack Modes" ATTACK_LABELS ATTACK_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aireplay-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#ATTACK_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${ATTACK_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aireplay_ng $cmd"
        fi
      fi
      ;;
    *)
      echo "Selected category is not available."
      return 1
      ;;
  esac
}

main_aireplay_ng() {
  show_help
  read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aireplay-ng>' select
  handle_category "$select"
}

main_aireplay_ng "$@"
