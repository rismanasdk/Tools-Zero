#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

basic_scanning() {
  cat <<'EOF'
Basic Scanning Techniques
Nmap Query
Nmap Command

1. Scan a single target
nmap [target]
2. Scan multiple targets
nmap [target1,target2,etc]
3. Scan a list of targets
nmap -iL [list.txt]
4. Scan a range of hosts
nmap [range of IP addresses]
5. Scan an entire subnet
nmap [IP address/cidr]
6. Scan random hosts
nmap -iR [number]
7. Excluding targets from a scan
nmap [targets] --exclude [targets]
8. Excluding targets using a list
nmap [targets] --excludefile [list.txt]
9. Perform an aggressive scan
nmap -A [target]
10. Scan an IPv6 target
nmap -6 [target]
11. Scan Port 80,443
nmap -p 80,443 [target]
12. Scan top 100 ports
nmap --top-ports 100 [target]
13. Scan all ports
nmap -p 1-65535 [target]
14 Scan custom ports
nmap -p [ports] [target]
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1)
      read -r -p "Input target> " target
      run_nmap nmap "$target"
      ;;
    2)
      read -r -p "Input targets (comma-separated)> " targets
      run_nmap nmap "$targets"
      ;;
    3)
      read -r -p "Input list file> " listfile
      run_nmap nmap -iL "$listfile"
      ;;
    4)
      read -r -p "Input range of IP addresses> " iprange
      run_nmap nmap "$iprange"
      ;;
    5)
      read -r -p "Input CIDR/IP address> " cidr
      run_nmap nmap "$cidr"
      ;;
    6)
      read -r -p "Input number> " number
      run_nmap nmap -iR "$number"
      ;;
    7)
      read -r -p "Input targets> " targets
      read -r -p "Input exclude targets> " exclude
      run_nmap nmap "$targets" --exclude "$exclude"
      ;;
    8)
      read -r -p "Input targets> " targets
      read -r -p "Input exclude file> " exclude_file
      run_nmap nmap "$targets" --excludefile "$exclude_file"
      ;;
    9)
      read -r -p "Input target> " target
      run_nmap nmap -A "$target"
      ;;
    10)
      read -r -p "Input IPv6 target> " target
      run_nmap nmap -6 "$target"
      ;;
    11)
      read -r -p "Input target> " target
      run_nmap nmap -p 80,443 "$target"
      ;;
    12)
      read -r -p "Input target> " target
      run_nmap nmap --top-ports 100 "$target"
      ;;
    13)
      read -r -p "Input target> " target
      run_nmap nmap -p 1-65535 "$target"
      ;;
    14)
      read -r -p "Input ports> " ports
      read -r -p "Input target> " target
      run_nmap nmap -p "$ports" "$target"
      ;;
    *)
      echo "Command options are not yet available."
      ;;
  esac
}

discovery_options() {
  cat <<'EOF'
Discovery Options
Nmap Query
Nmap Command

1. Perform a ping scan only
nmap -sP [target]
2. Don't ping
nmap -PN [target]
3. TCP SYN Ping
nmap -PS [target]
4. TCP ACK ping
nmap -PA [target]
5. UDP ping
nmap -PU [target]
6. SCTP Init Ping
nmap -PY [target]
7. ICMP echo ping
nmap -PE [target]
8. ICMP Timestamp ping
nmap -PP [target]
9. ICMP address mask ping
nmap -PM [target]
10. IP protocol ping
nmap -PO [target]
11. ARP ping
nmap -PR [target]
12. Traceroute
nmap --traceroute [target]
13. Force reverse DNS resolution
nmap -R [target]
14. Disable reverse DNS resolution
nmap -n [target]
15. Alternative DNS lookup
nmap --system-dns [target]
16. Manually specify DNS servers
nmap --dns-servers [servers] [target]
17. Create a host list
nmap -sL [targets]
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1) read -r -p "Input target> " target; run_nmap nmap -sP "$target" ;;
    2) read -r -p "Input target> " target; run_nmap nmap -PN "$target" ;;
    3) read -r -p "Input target> " target; run_nmap nmap -PS "$target" ;;
    4) read -r -p "Input target> " target; run_nmap nmap -PA "$target" ;;
    5) read -r -p "Input target> " target; run_nmap nmap -PU "$target" ;;
    6) read -r -p "Input target> " target; run_nmap nmap -PY "$target" ;;
    7) read -r -p "Input target> " target; run_nmap nmap -PE "$target" ;;
    8) read -r -p "Input target> " target; run_nmap nmap -PP "$target" ;;
    9) read -r -p "Input target> " target; run_nmap nmap -PM "$target" ;;
    10) read -r -p "Input target> " target; run_nmap nmap -PO "$target" ;;
    11) read -r -p "Input target> " target; run_nmap nmap -PR "$target" ;;
    12) read -r -p "Input target> " target; run_nmap nmap --traceroute "$target" ;;
    13) read -r -p "Input target> " target; run_nmap nmap -R "$target" ;;
    14) read -r -p "Input target> " target; run_nmap nmap -n "$target" ;;
    15) read -r -p "Input target> " target; run_nmap nmap --system-dns "$target" ;;
    16)
      read -r -p "Input DNS servers> " servers
      read -r -p "Input target> " target
      run_nmap nmap --dns-servers "$servers" "$target"
      ;;
    17) read -r -p "Input targets> " targets; run_nmap nmap -sL "$targets" ;;
    *) echo "Command options are not yet available." ;;
  esac
}

firewall_evasion() {
  cat <<'EOF'
Firewall Evasion Techniques
Nmap Query
Nmap Command

1. Fragment packets
nmap -f [target]
2. Specify a specific MTU
nmap --mtu [MTU] [target]
3. Use a decoy
nmap -D RND:[number] [target]
4. Idle zombie scan
nmap -sI [zombie] [target]
5. Manually specify a source port
nmap --source-port [port] [target]
6. Append random data
nmap --data-length [size] [target]
7. Randomize target scan order
nmap --randomize-hosts [target]
8. Spoof MAC Address
nmap --spoof-mac [MAC|0|vendor] [target]
9. Send bad checksums
nmap --badsum [target]
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1) read -r -p "Input target> " target; run_nmap nmap -f "$target" ;;
    2) read -r -p "Input MTU> " mtu; read -r -p "Input target> " target; run_nmap nmap --mtu "$mtu" "$target" ;;
    3) read -r -p "Input number> " number; read -r -p "Input target> " target; run_nmap nmap -D "RND:$number" "$target" ;;
    4) read -r -p "Input zombie> " zombie; read -r -p "Input target> " target; run_nmap nmap -sI "$zombie" "$target" ;;
    5) read -r -p "Input port> " port; read -r -p "Input target> " target; run_nmap nmap --source-port "$port" "$target" ;;
    6) read -r -p "Input size> " size; read -r -p "Input target> " target; run_nmap nmap --data-length "$size" "$target" ;;
    7) read -r -p "Input target> " target; run_nmap nmap --randomize-hosts "$target" ;;
    8) read -r -p "Input MAC/vendor> " mac; read -r -p "Input target> " target; run_nmap nmap --spoof-mac "$mac" "$target" ;;
    9) read -r -p "Input target> " target; run_nmap nmap --badsum "$target" ;;
    *) echo "Command options are not yet available." ;;
  esac
}

version_detection() {
  cat <<'EOF'
Version Detection
Nmap Query
Nmap Command

1. Operating system detection
nmap -O [target]
2. Attempt to guess an unknown OS
nmap -O --osscan-guess [target]
3. Service version detection
nmap -sV [target]
4. Troubleshooting version scans
nmap -sV --version-trace [target]
5. Perform a RPC scan
nmap -sR [target]
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1) read -r -p "Input target> " target; run_nmap nmap -O "$target" ;;
    2) read -r -p "Input target> " target; run_nmap nmap -O --osscan-guess "$target" ;;
    3) read -r -p "Input target> " target; run_nmap nmap -sV "$target" ;;
    4) read -r -p "Input target> " target; run_nmap nmap -sV --version-trace "$target" ;;
    5) read -r -p "Input target> " target; run_nmap nmap -sR "$target" ;;
    *) echo "Command options are not yet available." ;;
  esac
}

output_options() {
  cat <<'EOF'
Output Options
Nmap Query
Nmap Command

1. Save output to a text file
nmap -oN [scan.txt] [target]
2. Save output to a xml file
nmap -oX [scan.xml] [target]
3. Grepable output
nmap -oG [scan.txt] [target]
4. Output all supported file types
nmap -oA [path/filename] [target]
5. Periodically display statistics
nmap --stats-every [time] [target]
6. 133t output
nmap -oS [scan.txt] [target]
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1) read -r -p "Input output file> " out; read -r -p "Input target> " target; run_nmap nmap -oN "$out" "$target" ;;
    2) read -r -p "Input output file> " out; read -r -p "Input target> " target; run_nmap nmap -oX "$out" "$target" ;;
    3) read -r -p "Input output file> " out; read -r -p "Input target> " target; run_nmap nmap -oG "$out" "$target" ;;
    4) read -r -p "Input path/filename> " path; read -r -p "Input target> " target; run_nmap nmap -oA "$path" "$target" ;;
    5) read -r -p "Input time> " time; read -r -p "Input target> " target; run_nmap nmap --stats-every "$time" "$target" ;;
    6) read -r -p "Input output file> " out; read -r -p "Input target> " target; run_nmap nmap -oS "$out" "$target" ;;
    *) echo "Command options are not yet available." ;;
  esac
}

scripting_engine() {
  cat <<'EOF'
Scripting Engine
Nmap Query
Nmap Command

1. Execute individual scripts
nmap --script [script.nse] [target]
2. Execute multiple scripts
nmap --script [expression] [target]
3. Execute scripts by category
nmap --script [cat] [target]
4. Execute multiple scripts categories
nmap --script [cat1,cat2,etc]
5. Troubleshoot scripts
nmap --script [script] --script-trace [target]
6. Update the script database
nmap --script-updatedb
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1) read -r -p "Input script> " script; read -r -p "Input target> " target; run_nmap nmap --script "$script" "$target" ;;
    2) read -r -p "Input expression> " expr; read -r -p "Input target> " target; run_nmap nmap --script "$expr" "$target" ;;
    3) read -r -p "Input category> " cat; read -r -p "Input target> " target; run_nmap nmap --script "$cat" "$target" ;;
    4) read -r -p "Input categories> " cats; run_nmap nmap --script "$cats" ;;
    5) read -r -p "Input script> " script; read -r -p "Input target> " target; run_nmap nmap --script "$script" --script-trace "$target" ;;
    6) run_nmap nmap --script-updatedb ;;
    *) echo "Command options are not yet available." ;;
  esac
}

run_combined_command() {
  case "$1" in
    10|50)
      echo
      echo "Selected: $(combined_command_title "$1")"
      echo "Required input: target or CIDR"
      echo
      ;;
    17)
      echo
      echo "Selected: $(combined_command_title "$1")"
      echo "Required inputs: decoy IP and target"
      echo
      ;;
    *)
      echo
      echo "Selected: $(combined_command_title "$1")"
      echo "Required input: target"
      echo
      ;;
  esac

  case "$1" in
    1)  read -r -p "Input target> " target; run_nmap nmap -sS -O -v "$target" ;;
    2)  read -r -p "Input target> " target; run_nmap nmap -sU -O "$target" ;;
    3)  read -r -p "Input target> " target; run_nmap nmap -A -T4 "$target" ;;
    4)  read -r -p "Input target> " target; run_nmap nmap --script=vuln "$target" ;;
    5)  read -r -p "Input target> " target; run_nmap nmap -p80,443 -sV --script http-enum,http-title,http-methods "$target" ;;
    6)  read -r -p "Input target> " target; run_nmap nmap -p- -T4 "$target" ;;
    7)  read -r -p "Input target> " target; run_nmap nmap -f -T0 "$target" ;;
    8)  read -r -p "Input target> " target; run_nmap nmap -F -sV -O -T4 "$target" ;;
    9)  read -r -p "Input target> " target; run_nmap nmap -sV --script vuln,auth,default "$target" ;;
    10) read -r -p "Input target/CIDR> " target; run_nmap nmap -sn -PR "$target" ;;
    11) read -r -p "Input target> " target; run_nmap nmap -p445 --script smb-os-discovery,smb-vuln-ms17-010 "$target" ;;
    12) read -r -p "Input target> " target; run_nmap nmap -p3306,1433,1521 -sV --script mysql-info,ms-sql-info,oracle-tns-version "$target" ;;
    13) read -r -p "Input target> " target; run_nmap nmap -p22 --script ssh-auth-methods,ssh2-enum-algos "$target" ;;
    14) read -r -p "Input target> " target; run_nmap nmap -p25,110,143,465,587,993,995 -sV --script smtp-commands,smtp-enum-users "$target" ;;
    15) read -r -p "Input target> " target; run_nmap nmap -p443 --script ssl-heartbleed "$target" ;;
    16) read -r -p "Input target> " target; run_nmap nmap --source-port 53 "$target" ;;
    17) read -r -p "Input decoy IP (ex: 1.1.1.1)> " decoy; read -r -p "Input target> " target; run_nmap nmap -D "$decoy",ME "$target" ;;
    18) read -r -p "Input target> " target; run_nmap nmap --script auth,discovery,backdoor "$target" ;;
    19) read -r -p "Input target> " target; run_nmap nmap -sS -sV -T2 "$target" ;;
    20) read -r -p "Input target> " target; run_nmap nmap -sn --traceroute "$target" ;;
    21) read -r -p "Input target> " target; run_nmap nmap -sS -T1 "$target" ;;
    22) read -r -p "Input target> " target; run_nmap nmap -p 443,1604 -sV "$target" ;;
    23) read -r -p "Input target> " target; run_nmap nmap -sU -p 5060 --script sip-enum-users "$target" ;;
    24) read -r -p "Input target> " target; run_nmap nmap -p 1900,1883,5683 -sV "$target" ;;
    25) read -r -p "Input target> " target; run_nmap nmap -p 2375,6443,10250 "$target" ;;
    26) read -r -p "Input target> " target; run_nmap nmap -p 6379,11211 --script redis-info,memcached-info "$target" ;;
    27) read -r -p "Input target> " target; run_nmap nmap -p 8080,8088,9000 -sV "$target" ;;
    28) read -r -p "Input target> " target; run_nmap nmap --script http-oob-serialization "$target" ;;
    29) read -r -p "Input target> " target; run_nmap nmap -p 502 --script modbus-discover "$target" ;;
    30) read -r -p "Input target> " target; run_nmap nmap -p 3389,5900 --script rdp-enum-encryption,vnc-info "$target" ;;
    31) read -r -p "Input target> " target; run_nmap nmap --script dns-zone-transfer -p 53 "$target" ;;
    32) read -r -p "Input target> " target; run_nmap nmap -p 80,443 --script http-security-headers "$target" ;;
    33) read -r -p "Input target> " target; run_nmap nmap -p 443 --script ssl-enum-ciphers "$target" ;;
    34) read -r -p "Input target> " target; run_nmap nmap -p 445 --script smb-enum-shares,smb-enum-users "$target" ;;
    35) read -r -p "Input target> " target; run_nmap nmap -p 23,513 --script telnet-encryption,rlogin-auth "$target" ;;
    36) read -r -p "Input target> " target; run_nmap nmap --script tor-consensus-checker "$target" ;;
    37) read -r -p "Input target> " target; run_nmap nmap -sV --script snmp-sysdescr "$target" ;;
    38) read -r -p "Input target> " target; run_nmap nmap -sU -p 123 --script ntp-monlist "$target" ;;
    39) read -r -p "Input target> " target; run_nmap nmap -sU -p 161 --script snmp-brute "$target" ;;
    40) read -r -p "Input target> " target; run_nmap nmap -p 389 --script ldap-search "$target" ;;
    41) read -r -p "Input target> " target; run_nmap nmap -p 80,443 --script http-waf-detect,http-waf-fingerprint "$target" ;;
    42) read -r -p "Input target> " target; run_nmap nmap --script http-open-proxy,socks-open-proxy "$target" ;;
    43) read -r -p "Input target> " target; run_nmap nmap --script ftp-anon,smb-enum-shares "$target" ;;
    44) read -r -p "Input target> " target; run_nmap nmap -p 80,443 --script http-git "$target" ;;
    45) read -r -p "Input target> " target; run_nmap nmap -p 443 --script ssl-cert "$target" ;;
    46) read -r -p "Input target> " target; run_nmap nmap -sU -p 1900 --script upnp-info "$target" ;;
    47) read -r -p "Input target> " target; run_nmap nmap -p 113 --script auth-owners "$target" ;;
    48) read -r -p "Input target> " target; run_nmap nmap --script stuxnet-detect -p 445 "$target" ;;
    49) read -r -p "Input target> " target; run_nmap nmap -sV --version-intensity 9 "$target" ;;
    50) read -r -p "Input target/CIDR> " target; run_nmap nmap -sn -v "$target" ;;
    *) echo "Command options are not yet available." ;;
  esac
}

combined_command_title() {
  case "$1" in
    1) printf '%s' "Stealth Scan + OS Detection + Verbose" ;;
    2) printf '%s' "UDP Scan + OS Detection" ;;
    3) printf '%s' "Comprehensive Aggressive Scan" ;;
    4) printf '%s' "Standard Vulnerability Scan" ;;
    5) printf '%s' "Web Server Full Recon" ;;
    6) printf '%s' "Full Port Scan" ;;
    7) printf '%s' "Firewall Bypass (Fragmented + T0)" ;;
    8) printf '%s' "Quick Scan (Top 100 Ports)" ;;
    9) printf '%s' "Deep Vulnerability & Auth Audit" ;;
    10) printf '%s' "Network Discovery (Ping Sweep / CIDR)" ;;
    11) printf '%s' "SMB/Windows Recon (MS17-010)" ;;
    12) printf '%s' "Database Recon (SQL)" ;;
    13) printf '%s' "SSH Security Audit" ;;
    14) printf '%s' "Mail Server Recon" ;;
    15) printf '%s' "Heartbleed Bug Check" ;;
    16) printf '%s' "Firewall Evasion: Source Port 53" ;;
    17) printf '%s' "Firewall Evasion: Decoy Scan" ;;
    18) printf '%s' "Find Common Backdoors" ;;
    19) printf '%s' "Slow Comprehensive Scan (T2)" ;;
    20) printf '%s' "Generate Host Report with Traceroute" ;;
    21) printf '%s' "Slow & Stealthy Scan (T1)" ;;
    22) printf '%s' "Scan for Citrix/VPN Gateways" ;;
    23) printf '%s' "VoIP/SIP Enumeration" ;;
    24) printf '%s' "IoT Device Scan (MQTT, CoAP)" ;;
    25) printf '%s' "Docker/Kubernetes API Discovery" ;;
    26) printf '%s' "Redis/Memcached Unauth Check" ;;
    27) printf '%s' "Jenkins/TeamCity/CI-CD Server Recon" ;;
    28) printf '%s' "Scan for Out-of-Band (OOB) vulnerabilities" ;;
    29) printf '%s' "Industrial Systems (Modbus) Scan" ;;
    30) printf '%s' "VNC/RDP Screenshot & Auth Check" ;;
    31) printf '%s' "DNS Zone Transfer Attempt (AXFR)" ;;
    32) printf '%s' "HTTP Security Headers Audit" ;;
    33) printf '%s' "SSL/TLS Cipher Suite Enumeration" ;;
    34) printf '%s' "SMB Share Enumeration" ;;
    35) printf '%s' "Telnet/Rlogin Security Check" ;;
    36) printf '%s' "Scan for Tor Exit Nodes/Proxies" ;;
    37) printf '%s' "Detect Virtualization/Hypervisor" ;;
    38) printf '%s' "NTP Monlist Amplification Check" ;;
    39) printf '%s' "SNMP Community String Brute Force" ;;
    40) printf '%s' "LDAP/Active Directory Null Bind Check" ;;
    41) printf '%s' "Detect WAF Presence" ;;
    42) printf '%s' "Scan for Open Proxies (SOCKS, HTTP)" ;;
    43) printf '%s' "Check for Anonymous Write Access" ;;
    44) printf '%s' "Find Git/SVN/Hidden Repositories" ;;
    45) printf '%s' "SSL Certificate Expiry & Info Check" ;;
    46) printf '%s' "Scan for UPnP Devices (SSDP)" ;;
    47) printf '%s' "Identd (Port 113) User Enumeration" ;;
    48) printf '%s' "Check for Known SCADA Vulnerabilities" ;;
    49) printf '%s' "Aggressive Banner Grabbing" ;;
    50) printf '%s' "Discovery: List IPs, MACs & Vendors" ;;
    *) printf '%s' "Combined Command" ;;
  esac
}

show_combined_category_menu() {
  case "$1" in
    1)
      cat <<'EOF'
Web & Cloud Security

1. Web Server Full Recon
2. Heartbleed Bug Check
3. Jenkins/TeamCity/CI-CD Server Recon
4. Scan for Out-of-Band (OOB) vulnerabilities
5. HTTP Security Headers Audit
6. SSL/TLS Cipher Suite Enumeration
7. Detect WAF Presence
8. Find Git/SVN/Hidden Repositories
9. SSL Certificate Expiry & Info Check
10. Scan for Open Proxies (SOCKS, HTTP)
b. Back
EOF
      ;;
    2)
      cat <<'EOF'
Network & Infrastructure

1. Stealth Scan + OS Detection + Verbose
2. UDP Scan + OS Detection
3. Quick Scan (Top 100 Ports)
4. Network Discovery (Ping Sweep / CIDR)
5. SSH Security Audit
6. Mail Server Recon (SMTP, POP3, IMAP)
7. Generate Host Report with Traceroute
8. Scan for Citrix/VPN Gateways
9. VoIP/SIP Enumeration
10. DNS Zone Transfer Attempt (AXFR)
11. Telnet/Rlogin Security Check
12. Discovery: List IPs, MACs & Vendors
b. Back
EOF
      ;;
    3)
      cat <<'EOF'
Enterprise & Database

1. Comprehensive Aggressive Scan
2. Deep Vulnerability & Auth Audit
3. SMB/Windows Recon (MS17-010)
4. Database Recon (SQL)
5. Docker/Kubernetes API Discovery
6. Redis/Memcached Unauth Check
7. VNC/RDP Screenshot & Auth Check
8. SMB Share Enumeration
9. SNMP Community String Brute Force
10. LDAP/Active Directory Null Bind Check
11. Check for Anonymous Write Access
b. Back
EOF
      ;;
    4)
      cat <<'EOF'
IoT, ICS & SCADA

1. IoT Device Scan (MQTT, CoAP)
2. Industrial Systems (Modbus) Scan
3. NTP Monlist Amplification Check
4. Scan for UPnP Devices (SSDP)
5. Check for Known SCADA Vulnerabilities
6. Identd (Port 113) User Enumeration
b. Back
EOF
      ;;
    5)
      cat <<'EOF'
Stealth & Advanced Evasion

1. Standard Vulnerability Scan (NSE vuln)
2. Full Port Scan (p- -T4)
3. Firewall Bypass (Fragmented + T0)
4. Firewall Evasion: Source Port 53
5. Firewall Evasion: Decoy Scan
6. Find Common Backdoors
7. Slow Comprehensive Scan (T2)
8. Slow & Stealthy Scan (T1)
9. Scan for Tor Exit Nodes/Proxies
10. Detect Virtualization/Hypervisor
11. Aggressive Banner Grabbing
b. Back
EOF
      ;;
  esac
}

combined_commands() {
  while true; do
    cat <<'EOF'
Combined Commands

1. Web & Cloud Security (10 Menu)
2. Network & Infrastructure (12 Menu)
3. Enterprise & Database (11 Menu)
4. IoT, ICS & SCADA (6 Menu)
5. Stealth & Advanced Evasion (11 Menu)
b. Back
EOF

    read -r -p $'\nSelect-Options>Nmap>Combined>' category
    case "$category" in
      1|2|3|4|5)
        while true; do
          show_combined_category_menu "$category"
          read -r -p $'\nSelect-Options>Nmap>Commands>' select
          case "${category}:${select}" in
            1:1) run_combined_command 5 ;;
            1:2) run_combined_command 15 ;;
            1:3) run_combined_command 27 ;;
            1:4) run_combined_command 28 ;;
            1:5) run_combined_command 32 ;;
            1:6) run_combined_command 33 ;;
            1:7) run_combined_command 41 ;;
            1:8) run_combined_command 44 ;;
            1:9) run_combined_command 45 ;;
            1:10) run_combined_command 42 ;;
            2:1) run_combined_command 1 ;;
            2:2) run_combined_command 2 ;;
            2:3) run_combined_command 8 ;;
            2:4) run_combined_command 10 ;;
            2:5) run_combined_command 13 ;;
            2:6) run_combined_command 14 ;;
            2:7) run_combined_command 20 ;;
            2:8) run_combined_command 22 ;;
            2:9) run_combined_command 23 ;;
            2:10) run_combined_command 31 ;;
            2:11) run_combined_command 35 ;;
            2:12) run_combined_command 50 ;;
            3:1) run_combined_command 3 ;;
            3:2) run_combined_command 9 ;;
            3:3) run_combined_command 11 ;;
            3:4) run_combined_command 12 ;;
            3:5) run_combined_command 25 ;;
            3:6) run_combined_command 26 ;;
            3:7) run_combined_command 30 ;;
            3:8) run_combined_command 34 ;;
            3:9) run_combined_command 39 ;;
            3:10) run_combined_command 40 ;;
            3:11) run_combined_command 43 ;;
            4:1) run_combined_command 24 ;;
            4:2) run_combined_command 29 ;;
            4:3) run_combined_command 38 ;;
            4:4) run_combined_command 46 ;;
            4:5) run_combined_command 48 ;;
            4:6) run_combined_command 47 ;;
            5:1) run_combined_command 4 ;;
            5:2) run_combined_command 6 ;;
            5:3) run_combined_command 7 ;;
            5:4) run_combined_command 16 ;;
            5:5) run_combined_command 17 ;;
            5:6) run_combined_command 18 ;;
            5:7) run_combined_command 19 ;;
            5:8) run_combined_command 21 ;;
            5:9) run_combined_command 36 ;;
            5:10) run_combined_command 37 ;;
            5:11) run_combined_command 49 ;;
            *:b|*:B) break ;;
            *) echo "Command options are not yet available." ;;
          esac
        done
        ;;
      b|B) return ;;
      *) echo "Command options are not yet available." ;;
    esac
  done
}

timing_settings() {
  cat <<'EOF'
Timing and Performance
Nmap Query
Nmap Command

Time and Performance
1. Paranoid (-T0) - Very slow 
2. Sneaky (-T1) - Slow
3. Polite (-T2) - Bandwidth efficient
4. Normal (-T3) - Default
5. Aggressive (-T4) - Fast & Reliable 
6. Crazy (-T5) - Very fast 
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1) read -r -p "Input target> " target; run_nmap nmap -T0 "$target" ;;
    2) read -r -p "Input target> " target; run_nmap nmap -T1 "$target" ;;
    3) read -r -p "Input target> " target; run_nmap nmap -T2 "$target" ;;
    4) read -r -p "Input target> " target; run_nmap nmap -T3 "$target" ;;
    5) read -r -p "Input target> " target; run_nmap nmap -T4 "$target" ;;
    6) read -r -p "Input target> " target; run_nmap nmap -T5 "$target" ;;
    *) echo "Command options are not yet available." ;;
  esac
}

main() {
  if [[ $EUID -ne 0 ]]; then
    echo "Error: This tool requires sudo privileges."
    exit 1
  fi

  while true; do
    show_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>Nmap>' select
    case "$select" in
      1) basic_scanning ;;
      2) discovery_options ;;
      3) firewall_evasion ;;
      4) version_detection ;;
      5) output_options ;;
      6) scripting_engine ;;
      7) combined_commands ;;
      8) timing_settings ;;
      b|B) return 0 ;;
      q|Q) exit 0 ;;
      *) echo "Category selection is not yet available." ;;
    esac
    echo
  done
}

main
