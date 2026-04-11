#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "${BASE_DIR}/.." && pwd)"
ROOT_DIR="$(cd "${PARENT_DIR}/../.." && pwd)"
source "${ROOT_DIR}/shared/common.sh"

show_help() {
  echo "1. Start monitor mode"
  echo "2. Stop monitor mode"
  echo "3. Check interfering processes"
  echo "4. Check and kill interfering processes"
  echo "5. Verbose mode"
  echo "6. Debug mode"
  echo "7. Elite mode"
}

run_airmon_ng() {
  tools_zero_run_command "Airmon-ng" "airmon-ng" "$@"
}

main_airmon_ng() {
  show_help
  read -r -p $'\nSelect-Options>Aircrack-ng>The-Big-Five>Airmon-ng>' select

  case "$select" in
    1)
      read -r -p "Input interface> " iface
      if [[ -z "$iface" ]]; then
        echo "Interface cannot be empty."
        return 1
      fi
      read -r -p "Input channel (optional, enter to skip)> " channel || channel=""
      if [[ -n "$channel" ]]; then
        run_airmon_ng start "$iface" "$channel"
      else
        run_airmon_ng start "$iface"
      fi
      ;;
    2)
      read -r -p "Input interface> " iface
      if [[ -z "$iface" ]]; then
        echo "Interface cannot be empty."
        return 1
      fi
      run_airmon_ng stop "$iface"
      ;;
    3)
      run_airmon_ng check
      ;;
    4)
      run_airmon_ng check kill
      ;;
    5)
      run_airmon_ng --verbose
      ;;
    6)
      run_airmon_ng --debug
      ;;
    7)
      run_airmon_ng --elite
      ;;
    *)
      echo "Selected command is not available."
      return 1
      ;;
  esac
}

main_airmon_ng "$@"
