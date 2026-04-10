#!/usr/bin/env bash

# Generic framework for config-driven tool wrappers
# Usage: source this file and define MENU_ITEMS array, then call run_menu_loop

set -euo pipefail

# Display menu from MENU_ITEMS array
# Expected format:
#   MENU_ITEMS[0]="option_number|display_name"
#   MENU_ITEMS[1]="1|Description of option 1"
#   ...
display_menu() {
  local header="${1:-Menu}"
  echo "$header"
  echo ""
  for item in "${MENU_ITEMS[@]:-}"; do
    echo "${item#*|}"
  done
}

# Extract option handler from MENU_ITEMS
# Usage: get_option_handler "1" => prints the case block or command
get_option_handler() {
  local option="$1"
  
  for item in "${OPTION_HANDLERS[@]:-}"; do
    local opt="${item%%|*}"
    if [[ "$opt" == "$option" ]]; then
      echo "${item#*|}"
      return 0
    fi
  done
  return 1
}

# Generic menu loop
# Expected env vars:
#   - MENU_PROMPT: prompt text (e.g., "Select-Options>Sqlmap>")
#   - MENU_ITEMS: array of display items
#   - OPTION_HANDLERS: array of "option|handler_function_or_command"
run_menu_loop() {
  local menu_prompt="${MENU_PROMPT:-Select>}"
  
  while true; do
    display_menu
    echo "b. Back"
    echo "q. Quit"
    read -r -p "$'\n'"$menu_prompt select
    
    case "$select" in
      b|B) return 0 ;;
      q|Q) exit 0 ;;
      *)
        local handler
        if handler="$(get_option_handler "$select" 2>/dev/null)"; then
          # If handler is a function name (callable), call it
          # Otherwise, eval it as a command
          if declare -f "$handler" >/dev/null 2>&1; then
            "$handler"
          else
            eval "$handler"
          fi
        else
          echo "Selected option is not available."
        fi
        ;;
    esac
    echo
  done
}

# Simplified generic loop: just show options and call function/command
# Usage:
#   MENU_OPTIONS=("1" "2" "3")
#   MENU_HANDLERS=("handle_1" "handle_2" "handle_3")
#   run_simple_menu "Select>Sqlmap>" "Target|Request|General"
run_simple_menu() {
  local menu_prompt="$1"
  local menu_display="$2"
  
  # Display
  echo "$menu_display" | nl
  echo "b. Back"
  echo "q. Quit"
  read -r -p "$'\n'"$menu_prompt select
  
  case "$select" in
    b|B) return 0 ;;
    q|Q) exit 0 ;;
    *)
      # Call a registered handler
      # Must be defined by caller
      handle_menu_option "$select" || echo "Selected option is not available."
      ;;
  esac
}
