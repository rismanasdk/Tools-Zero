#!/usr/bin/env bash

# Shared logging module for bash scripts
# Usage: source toolkit/shared/logging/logger.sh
#        setup_logging "tool_name"
#        log_info "Message here"

set -euo pipefail

# Log directory (default: ./logs)
LOG_DIR="${LOG_DIR:=./logs}"
LOG_LEVEL="${LOG_LEVEL:=INFO}"
TOOL_NAME="${TOOL_NAME:=unknown}"

# Log levels
readonly DEBUG=0
readonly INFO=1
readonly WARNING=2
readonly ERROR=3
readonly CRITICAL=4

# Convert log level string to number
_get_level_number() {
    case "${1,,}" in
        debug) echo $DEBUG ;;
        info) echo $INFO ;;
        warning) echo $WARNING ;;
        error) echo $ERROR ;;
        critical) echo $CRITICAL ;;
        *) echo $INFO ;;
    esac
}

# Create log file
_ensure_log_dir() {
    mkdir -p "$LOG_DIR"
}

# Get level name from number
_get_level_name() {
    case "$1" in
        $DEBUG) echo "DEBUG" ;;
        $INFO) echo "INFO" ;;
        $WARNING) echo "WARNING" ;;
        $ERROR) echo "ERROR" ;;
        $CRITICAL) echo "CRITICAL" ;;
        *) echo "INFO" ;;
    esac
}

# Internal log function
_log() {
    local level=$1
    local message="$2"
    local level_name
    local log_file
    local timestamp
    
    level_name=$(_get_level_name "$level")
    log_file="$LOG_DIR/${TOOL_NAME}.log"
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    _ensure_log_dir
    
    # Write to file
    echo "[$timestamp] [$TOOL_NAME] $level_name: $message" >> "$log_file"
    
    # Write to console based on level
    local current_level
    current_level=$(_get_level_number "$LOG_LEVEL")
    
    if [[ $level -ge $current_level ]]; then
        echo "[$TOOL_NAME] $level_name: $message" >&2
    fi
}

# Setup logging for a tool
setup_logging() {
    TOOL_NAME="${1:=unknown}"
    _ensure_log_dir
}

# Log functions
log_debug() {
    _log $DEBUG "$1"
}

log_info() {
    _log $INFO "$1"
}

log_warning() {
    _log $WARNING "$1"
}

log_error() {
    _log $ERROR "$1"
}

log_critical() {
    _log $CRITICAL "$1"
}

# Convenience function for errors with exit
log_and_exit() {
    local message="$1"
    local code="${2:=1}"
    log_error "$message"
    exit "$code"
}

# Set log level
set_log_level() {
    LOG_LEVEL="${1:=INFO}"
}

# Get log file location
get_log_file() {
    echo "$LOG_DIR/${TOOL_NAME}.log"
}

# Tail logs
tail_logs() {
    local lines="${1:=50}"
    tail -n "$lines" "$(get_log_file)"
}

# Example usage (uncomment to test):
# setup_logging "test_tool"
# log_debug "This is a debug message"
# log_info "This is an info message"
# log_warning "This is a warning message"
# log_error "This is an error message"
# echo "Log file at: $(get_log_file)"
