#!/usr/bin/env bash
# Ultra-fast result exporter with multiple formats

set -euo pipefail

export_csv() {
    local input="${1:-}"
    local output="${2:-}"
    
    if [[ -z "$output" ]]; then
        output="-"
    fi
    
    {
        echo "url,status_code,length"
        if [[ "$input" == "-" || -z "$input" ]]; then
            cat
        else
            cat "$input"
        fi | grep -v '^$' | awk '{print $1","$2","$3}'
    } > "$output"
    [[ "$output" != "-" ]] && echo "✓ CSV exported: $output" || true
}

export_json() {
    local input="${1:-}"
    local output="${2:-}"
    
    if [[ -z "$output" ]]; then
        output="-"
    fi
    
    {
        echo "["
        if [[ "$input" == "-" || -z "$input" ]]; then
            cat
        else
            cat "$input"
        fi | grep -v '^$' | while read -r line; do
            url=$(echo "$line" | awk '{print $1}')
            status=$(echo "$line" | awk '{print $2}')
            length=$(echo "$line" | awk '{print $3}')
            echo "  {\"url\": \"$url\", \"status\": $status, \"length\": $length},"
        done | sed '$ s/,$//'
        echo "]"
    } > "$output"
    [[ "$output" != "-" ]] && echo "✓ JSON exported: $output" || true
}

export_html() {
    local input="${1:-}"
    local output="${2:-}"
    
    if [[ -z "$output" ]]; then
        output="-"
    fi
    
    cat > "$output" << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>Gobuster Results</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f5f5f5; }
        h1 { color: #333; }
        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #667eea; color: white; }
        tr:hover { background: #f9f9f9; }
        .status-200 { color: green; font-weight: bold; }
        .status-301 { color: blue; }
        .status-403 { color: red; }
    </style>
</head>
<body>
    <h1>Directory Enumeration Results</h1>
    <table>
        <tr><th>URL</th><th>Status</th><th>Length</th></tr>
HTMLEOF
    
    if [[ "$input" == "-" || -z "$input" ]]; then
        cat
    else
        cat "$input"
    fi | grep -v '^$' | while read -r line; do
        url=$(echo "$line" | awk '{print $1}')
        status=$(echo "$line" | awk '{print $2}')
        length=$(echo "$line" | awk '{print $3}')
        echo "        <tr><td>$url</td><td class=\"status-$status\">$status</td><td>$length</td></tr>"
    done >> "$output"
    
    cat >> "$output" << 'HTMLEOF'
    </table>
</body>
</html>
HTMLEOF
    [[ "$output" != "-" ]] && echo "✓ HTML exported: $output" || true
}

export_text() {
    local input="${1:-}"
    local output="${2:-}"
    
    if [[ -z "$output" ]]; then
        output="-"
    fi
    
    {
        echo "=== GOBUSTER RESULTS ==="
        echo "Generated: $(date)"
        echo "================================"
        if [[ "$input" == "-" || -z "$input" ]]; then
            cat
        else
            cat "$input"
        fi
    } > "$output"
    [[ "$output" != "-" ]] && echo "✓ Text exported: $output" || true
}

case "${1:-}" in
    csv) export_csv "${2:-}" "${3:-}" ;;
    json) export_json "${2:-}" "${3:-}" ;;
    html) export_html "${2:-}" "${3:-}" ;;
    text) export_text "${2:-}" "${3:-}" ;;
    *)
        echo "Usage: exporter.sh {csv|json|html|text} [input] [output]"
        echo ""
        echo "Examples:"
        echo "  cat scan.txt | exporter.sh csv - results.csv"
        echo "  exporter.sh json scan.txt results.json"
        echo "  exporter.sh html < scan.txt > results.html"
        ;;
esac
