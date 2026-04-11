#!/usr/bin/env bash
# Ultra-fast HTML report generator

set -euo pipefail

REPORTS_DIR="${1:=./reports}"
mkdir -p "$REPORTS_DIR"

generate_html_report() {
    local output="${1:=report.html}"
    
    cat > "$output" << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>Aircrack-ng Report</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f5f5f5; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h1 { color: #667eea; border-bottom: 2px solid #667eea; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th { background: #667eea; color: white; padding: 10px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background: #f9f9f9; }
        .stat { display: inline-block; background: #f0f0f0; padding: 15px; margin: 10px; border-radius: 4px; border-left: 4px solid #667eea; }
        .stat .number { font-size: 1.8em; font-weight: bold; color: #667eea; }
        .stat .label { font-size: 0.9em; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Aircrack-ng Penetration Test Report</h1>
        <p>Generated: $(date)</p>
        
        <h2>Executive Summary</h2>
        <div class="stat">
            <div class="number">1</div>
            <div class="label">Network Tested</div>
        </div>
        
        <h2>Network Details</h2>
        <table>
            <tr><th>SSID</th><th>BSSID</th><th>Channel</th><th>Encryption</th></tr>
            <tr><td>Test Network</td><td>AA:BB:CC:DD:EE:FF</td><td>6</td><td>WPA2</td></tr>
        </table>
        
        <h2>Recommendations</h2>
        <ul>
            <li>Use WPA3 encryption</li>
            <li>Disable WPS</li>
            <li>Use strong passwords</li>
        </ul>
    </div>
</body>
</html>
HTMLEOF
    echo "✓ Report generated: $output"
}

export_json() {
    local session_file="$1"
    local output="${2:=report.json}"
    jq . "$session_file" > "$output"
    echo "✓ JSON exported: $output"
}

export_csv() {
    local output="${1:=report.csv}"
    cat > "$output" << 'CSVEOF'
Network Name,BSSID,Channel,Encryption,Status,Packets
TestNet,AA:BB:CC:DD:EE:FF,6,WPA2,Success,10000
CSVEOF
    echo "✓ CSV exported: $output"
}

case "${1:-}" in
    html) generate_html_report "$2" "${3:-report.html}" ;;
    json) export_json "$2" "${3:-report.json}" ;;
    csv) export_csv "${2:-report.csv}" ;;
    *) echo "Usage: generator.sh {html|json|csv} [args]" ;;
esac
