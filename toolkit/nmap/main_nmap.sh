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

combined_commands() {
  cat <<'EOF'
Combined Commands
Nmap Query
Nmap Command

1. Stealth scan with OS detection and verbose
nmap -sS -O -v [target]
2. UDP scan with OS detection
nmap -sU -O [target]
3. Comprehensive scan
nmap -sS -sU -A -T4 [target]
4. NSE vuln scan
nmap --script=vuln [target]
5. Service & Version Detection
nmap -sV --version-intensity 5 [target]
6.Scanning all range port
nmap -p 1-65535 [target]
7.Bypass Firewall
nmap -f -T 0 [target]
EOF

  read -r -p $'\nSelect-Options>Nmap>Commands>' select
  case "$select" in
    1) read -r -p "Input target> " target; run_nmap nmap -sS -O -v "$target" ;;
    2) read -r -p "Input target> " target; run_nmap nmap -sU -O "$target" ;;
    3) read -r -p "Input target> " target; run_nmap nmap -sS -sU -A -T4 "$target" ;;
    4) read -r -p "Input target> " target; run_nmap nmap --script=vuln "$target" ;;
    5) read -r -p "Input target> " target; run_nmap nmap -sV --version-intensity 5 "$target" ;;
    6) read -r -p "Input target> " target; run_nmap nmap -p 1-65535 "$target" ;;
    7) read -r -p "Input target> " target; run_nmap nmap -f -T 0 "$target" ;;
    *) echo "Command options are not yet available." ;;
  esac
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
