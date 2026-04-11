#!/usr/bin/env bash
# High-performance config manager using jq and shell

set -euo pipefail

CONFIG_DIR="${CONFIG_DIR:=./config}"
CONFIG_FILE="${CONFIG_DIR}/config.json"
DEFAULT_CONFIG="${CONFIG_DIR}/default_config.json"

# Initialize config system
init_config() {
    mkdir -p "$CONFIG_DIR"
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        if [[ -f "$DEFAULT_CONFIG" ]]; then
            cp "$DEFAULT_CONFIG" "$CONFIG_FILE"
        else
            cat > "$CONFIG_FILE" << 'EOFCONF'
{
  "logging": {"level": "INFO", "path": "./logs"},
  "timeout": {"default": 30, "long_running": 300},
  "proxy": {"enabled": false}
}
EOFCONF
        fi
    fi
}

# Get config value (fast path)
config_get() {
    init_config
    local key_path="$1"
    local default="${2:-.}"
    
    jq -r "$key_path // \"$default\"" "$CONFIG_FILE" 2>/dev/null || echo "$default"
}

# Set config value (fast path)
config_set() {
    init_config
    local key_path="$1"
    local value="$2"
    
    jq "$key_path = \"$value\"" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && \
        mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
}

# Get entire config
config_dump() {
    init_config
    cat "$CONFIG_FILE"
}

# Load from environment variable
config_from_env() {
    local env_var="$1"
    local key_path="$2"
    
    if [[ -n "${!env_var:-}" ]]; then
        config_set "$key_path" "${!env_var}"
    fi
}

# Main execution
init_config

case "${1:-}" in
    get) config_get "$2" "${3:-.}" ;;
    set) config_set "$2" "$3" ;;
    dump) config_dump ;;
    init) init_config ;;
    *) echo "Usage: config_manager.sh {get|set|dump|init} [args]" ;;
esac
