#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

# Category 1: Common Options
declare -a COMMON_LABELS=(
  "Force attack mode"
  "Use ESSID for target selection"
  "Select target by BSSID"
  "Set number of CPUs to use"
  "Enable quiet mode"
  "Combine APs into a virtual one"
  "Log found key to file"
)

declare -a COMMON_TEMPLATES=(
  "aircrack-ng -a [amode] [capture file(s)]"
  "aircrack-ng -e [essid] [capture file(s)]"
  "aircrack-ng -b [bssid] [capture file(s)]"
  "aircrack-ng -p [nbcpu] [capture file(s)]"
  "aircrack-ng -q [capture file(s)]"
  "aircrack-ng -C [MACs] [capture file(s)]"
  "aircrack-ng -l [file name] [capture file(s)]"
)

# Category 2: Static WEP Cracking Options
declare -a WEP_LABELS=(
  "Restrict search to alphanumeric characters"
  "Restrict search to BCD hex characters"
  "Restrict search to numeric characters"
  "Set beginning of WEP key"
  "Filter WEP data packets by MAC"
  "Specify WEP key length"
  "Keep only IVs with selected key index"
  "Set fudge factor"
  "Disable selected Korek attack"
  "Disable last keybytes bruteforce"
  "Enable last keybyte bruteforce"
  "Enable last two keybytes bruteforce"
  "Disable bruteforce multithreading"
  "Show key in ASCII while cracking"
  "Run experimental single bruteforce attack"
  "Use PTW WEP cracking method"
  "Use PTW debug mode"
  "Use Korek WEP cracking method"
  "Run in WEP decloak mode"
  "Run only one PTW try"
  "Set maximum IVs to use"
  "Run in visual inspection mode"
)

declare -a WEP_TEMPLATES=(
  "aircrack-ng -c [capture file(s)]"
  "aircrack-ng -t [capture file(s)]"
  "aircrack-ng -h [capture file(s)]"
  "aircrack-ng -d [start] [capture file(s)]"
  "aircrack-ng -m [maddr] [capture file(s)]"
  "aircrack-ng -n [nbits] [capture file(s)]"
  "aircrack-ng -i [index] [capture file(s)]"
  "aircrack-ng -f [fudge] [capture file(s)]"
  "aircrack-ng -k [korek] [capture file(s)]"
  "aircrack-ng -x [capture file(s)]"
  "aircrack-ng -x1 [capture file(s)]"
  "aircrack-ng -x2 [capture file(s)]"
  "aircrack-ng -X [capture file(s)]"
  "aircrack-ng -s [capture file(s)]"
  "aircrack-ng -y [capture file(s)]"
  "aircrack-ng -z [capture file(s)]"
  "aircrack-ng -P [number] [capture file(s)]"
  "aircrack-ng -K [capture file(s)]"
  "aircrack-ng -D [capture file(s)]"
  "aircrack-ng -1 [capture file(s)]"
  "aircrack-ng -M [number] [capture file(s)]"
  "aircrack-ng -V [capture file(s)]"
)

# Category 3: WEP And WPA-PSK Cracking Options
declare -a WEPWPA_LABELS=(
  "Use one or more wordlists"
  "Create a new cracking session"
  "Restore a cracking session"
)

declare -a WEPWPA_TEMPLATES=(
  "aircrack-ng -w [words] [capture file(s)]"
  "aircrack-ng -N [file] [capture file(s)]"
  "aircrack-ng -R [file]"
)

# Category 4: WPA-PSK Options
declare -a WPA_LABELS=(
  "Create EWSA project file"
  "Create Hashcat HCCAPX file"
  "Create Hashcat capture file"
  "Run WPA cracking speed test"
  "Set WPA speed test duration"
  "Use airolib-ng database"
)

declare -a WPA_TEMPLATES=(
  "aircrack-ng -E [file] [capture file(s)]"
  "aircrack-ng -j [file] [capture file(s)]"
  "aircrack-ng -J [file] [capture file(s)]"
  "aircrack-ng -S"
  "aircrack-ng -Z [sec]"
  "aircrack-ng -r [database] [capture file(s)]"
)

# Category 5: SIMD Selection
declare -a SIMD_LABELS=(
  "Use selected SIMD optimization"
  "Show available SIMD optimizations"
)

declare -a SIMD_TEMPLATES=(
  "aircrack-ng --simd [optimization] [capture file(s)]"
  "aircrack-ng --simd-list"
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

run_aircrack_ng() {
  tools_zero_run_command "Aircrack-ng" "aircrack-ng" "$@"
}

show_help() {
  echo "1. Common Options"
  echo "2. Static WEP Cracking Options"
  echo "3. WEP And WPA-PSK Cracking Options"
  echo "4. WPA-PSK Options"
  echo "5. SIMD Selection"
}

show_category_commands() {
  local category="$1"
  local title="$2"
  local -n labels=$3
  local -n templates=$4
  
  echo ""
  echo "$title"
  echo ""
  echo "Aircrack-ng Query"
  echo ""
  echo "Aircrack-ng Command"
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
      show_category_commands "1" "Common Options" COMMON_LABELS COMMON_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#COMMON_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${COMMON_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aircrack_ng $cmd"
        fi
      fi
      ;;
    2)
      show_category_commands "2" "Static WEP Cracking Options" WEP_LABELS WEP_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#WEP_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${WEP_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aircrack_ng $cmd"
        fi
      fi
      ;;
    3)
      show_category_commands "3" "WEP And WPA-PSK Cracking Options" WEPWPA_LABELS WEPWPA_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#WEPWPA_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${WEPWPA_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aircrack_ng $cmd"
        fi
      fi
      ;;
    4)
      show_category_commands "4" "WPA-PSK Options" WPA_LABELS WPA_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#WPA_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${WPA_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aircrack_ng $cmd"
        fi
      fi
      ;;
    5)
      show_category_commands "5" "SIMD Selection" SIMD_LABELS SIMD_TEMPLATES
      read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>Commands>' select
      if [[ "$select" =~ ^[0-9]+$ ]]; then
        local idx=$((select - 1))
        if [[ $idx -ge 0 ]] && [[ $idx -lt ${#SIMD_TEMPLATES[@]} ]]; then
          local cmd
          cmd=$(build_command "${SIMD_TEMPLATES[$idx]}")
          [[ -n "$cmd" ]] && eval "run_aircrack_ng $cmd"
        fi
      fi
      ;;
    *)
      echo "Selected category is not available."
      return 1
      ;;
  esac
}

main_aircrack_ng() {
  show_help
  read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>' select
  handle_category "$select"
}

main_aircrack_ng "$@"
