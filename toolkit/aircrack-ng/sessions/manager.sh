#!/usr/bin/env bash
# Lightning-fast session manager

set -euo pipefail

SESSIONS_DIR="${SESSIONS_DIR:=./sessions}"
mkdir -p "$SESSIONS_DIR"

# Create session
create_session() {
    local name="$1" ssid="$2" bssid="$3" channel="${4:=6}"
    local timestamp=$(date +%s)
    local session_file="$SESSIONS_DIR/${name}_${timestamp}.json"
    
    local iso_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    cat > "$session_file" <<EOF
{
  "name": "$name",
  "timestamp": "$iso_date",
  "network": {
    "ssid": "$ssid",
    "bssid": "$bssid",
    "channel": $channel,
    "encryption": "WPA2"
  },
  "status": "initialized",
  "packets": 0,
  "handshake": false
}
EOF
    echo "✓ Session created: $session_file"
}

# List all sessions
list_sessions() {
    echo "=== Aircrack-ng Sessions ==="
    ls -1 "$SESSIONS_DIR"/*.json 2>/dev/null | while read f; do
        echo "  $(basename "$f")"
    done || echo "  No sessions found"
}

# Get specific session
get_session() {
    local name="$1"
    local session=$(ls "$SESSIONS_DIR/${name}"*.json 2>/dev/null | head -1)
    test -f "$session" && cat "$session" || echo "{\"error\": \"Session not found\"}"
}

# Update session
update_session() {
    local name="$1"
    local packets="${2:=0}"
    local handshake="${3:=false}"
    local session=$(ls "$SESSIONS_DIR/${name}"*.json 2>/dev/null | head -1)
    
    if [ -f "$session" ]; then
        jq ".packets = $packets | .handshake = $handshake" "$session" > "${session}.tmp" && mv "${session}.tmp" "$session"
        echo "✓ Session updated"
    fi
}

# Print summary
summary() {
    echo "=== Session Summary ==="
    for f in "$SESSIONS_DIR"/*.json; do
        [ -f "$f" ] || continue
        name=$(jq -r '.name' "$f")
        ssid=$(jq -r '.network.ssid' "$f")
        packets=$(jq -r '.packets' "$f")
        echo "  $name: $ssid ($packets packets)"
    done
}

case "${1:-}" in
    create) create_session "$2" "$3" "$4" "${5:=6}" ;;
    list) list_sessions ;;
    get) get_session "$2" ;;
    update) update_session "$2" "${3:=0}" "${4:=false}" ;;
    summary) summary ;;
    *) echo "Usage: manager.sh {create|list|get|update|summary} [args]" ;;
esac
