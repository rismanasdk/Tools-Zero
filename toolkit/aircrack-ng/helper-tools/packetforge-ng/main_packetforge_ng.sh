#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

# Category 1: Forge Options
declare -a FORGE_LABELS=(
  "Set frame control word"
  "Set access point MAC address"
  "Set destination MAC address"
  "Set source MAC address"
  "Set FromDS bit"
  "Clear ToDS bit"
  "Disable WEP encryption"
  "Set destination IP and optional port"
  "Set source IP and optional port"
  "Set time to live"
  "Write packet to pcap file"
  "Specify size of null packet"
  "Set number of packets to generate"
)

declare -a FORGE_TEMPLATES=(
  "packetforge-ng --arp -p [fctrl] -w [file]"
  "packetforge-ng --arp -a [bssid] -w [file]"
  "packetforge-ng --arp -c [dmac] -w [file]"
  "packetforge-ng --arp -h [smac] -w [file]"
  "packetforge-ng --arp -j -w [file]"
  "packetforge-ng --arp -o -w [file]"
  "packetforge-ng --arp -e -w [file]"
  "packetforge-ng --udp -k [ip[:port]] -w [file]"
  "packetforge-ng --udp -l [ip[:port]] -w [file]"
  "packetforge-ng --udp -t [ttl] -w [file]"
  "packetforge-ng --arp -w [file]"
  "packetforge-ng --null -s [size] -w [file]"
  "packetforge-ng --arp -n [packets] -w [file]"
)

# Category 2: Source Options
declare -a SOURCE_LABELS=(
  "Read packet from raw file"
  "Read PRGA from file"
)

declare -a SOURCE_TEMPLATES=(
  "packetforge-ng --custom -r [file] -w [output file]"
  "packetforge-ng --arp -y [file] -w [output file]"
)

# Category 3: Modes
declare -a MODES_LABELS=(
  "Forge an ARP packet"
  "Forge a UDP packet"
  "Forge an ICMP packet"
  "Build a null packet"
  "Build a custom packet"
)

declare -a MODES_TEMPLATES=(
  "packetforge-ng --arp -a [bssid] -h [smac] -k [ip[:port]] -l [ip[:port]] -w [file]"
  "packetforge-ng --udp -a [bssid] -h [smac] -k [ip[:port]] -l [ip[:port]] -w [file]"
  "packetforge-ng --icmp -a [bssid] -h [smac] -k [ip[:port]] -l [ip[:port]] -w [file]"
  "packetforge-ng --null -a [bssid] -h [smac] -w [file]"
  "packetforge-ng --custom -r [file] -w [output file]"
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

run_packetforge_ng() {
  tools_zero_run_command "Packetforge-ng" "packetforge-ng" "$@"
}

show_help() {
  echo "1. Forge Options"
  echo "2. Source Options"
  echo "3. Modes"
}

show_category_commands() {
  local title="$1"
  local -n labels=$2
  local -n templates=$3
  
  echo ""
  echo "$title"
  echo ""
  echo "Packetforge-ng Query"
  echo ""
  echo "Packetforge-ng Command"
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
      show_category_commands "Forge Options" FORGE_LABELS FORGE_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Packetforge-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#FORGE_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${FORGE_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_packetforge_ng $cmd"
        fi
      fi
      ;;
    2)
      show_category_commands "Source Options" SOURCE_LABELS SOURCE_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Packetforge-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#SOURCE_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${SOURCE_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_packetforge_ng $cmd"
        fi
      fi
      ;;
    3)
      show_category_commands "Modes" MODES_LABELS MODES_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Packetforge-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#MODES_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${MODES_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_packetforge_ng $cmd"
        fi
      fi
      ;;
    *)
      echo "Selected category is not available."
      return 1
      ;;
  esac
}

main_packetforge_ng() {
  show_help
  read -r -p $'\nSelect-Options>Aircrack-ng>Helper-Tools>Packetforge-ng>' select
  handle_category "$select"
}

main_packetforge_ng "$@"
