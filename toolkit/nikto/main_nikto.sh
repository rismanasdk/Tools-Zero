#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

main_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

basic_scan() {
  cat <<'EOF'
Basic Scan Query
Basic Scan Command

1. Scan host on default port
nikto -host [host]
2. Scan host on a specific port
nikto -host [host] -port [port]
3. Scan host with SSL
nikto -host [host] -ssl
4. Scan host with root path
nikto -host [host] -root [directory]
5. Scan virtual host
nikto -host [host] -vhost [virtual host]
EOF

  read -r -p $'\nSelect-Options>Nikto>Basic>' select
  case "$select" in
    1)
      read -r -p "Input host> " host
      run_nikto nikto -host "$host"
      ;;
    2)
      read -r -p "Input host> " host
      read -r -p "Input port> " port
      run_nikto nikto -host "$host" -port "$port"
      ;;
    3)
      read -r -p "Input host> " host
      run_nikto nikto -host "$host" -ssl
      ;;
    4)
      read -r -p "Input host> " host
      read -r -p "Input directory> " directory
      run_nikto nikto -host "$host" -root "$directory"
      ;;
    5)
      read -r -p "Input host> " host
      read -r -p "Input virtual host> " vhost
      run_nikto nikto -host "$host" -vhost "$vhost"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

output_menu() {
  cat <<'EOF'
Output / Save Query
Output / Save Command

1. Write output to file
nikto -host [host] -output [file]
2. Save output as CSV
nikto -host [host] -output [file] -Format csv
3. Save output as HTML
nikto -host [host] -output [file] -Format htm
4. Save output as XML
nikto -host [host] -output [file] -Format xml
5. Save to directory
nikto -host [host] -Save [directory]
EOF

  read -r -p $'\nSelect-Options>Nikto>Output>' select
  case "$select" in
    1)
      read -r -p "Input host> " host
      read -r -p "Input output file> " file
      run_nikto nikto -host "$host" -output "$file"
      ;;
    2)
      read -r -p "Input host> " host
      read -r -p "Input output file> " file
      run_nikto nikto -host "$host" -output "$file" -Format csv
      ;;
    3)
      read -r -p "Input host> " host
      read -r -p "Input output file> " file
      run_nikto nikto -host "$host" -output "$file" -Format htm
      ;;
    4)
      read -r -p "Input host> " host
      read -r -p "Input output file> " file
      run_nikto nikto -host "$host" -output "$file" -Format xml
      ;;
    5)
      read -r -p "Input host> " host
      read -r -p "Input directory> " directory
      run_nikto nikto -host "$host" -Save "$directory"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

tuning_menu() {
  cat <<'EOF'
Tuning / Evasion Query
Tuning / Evasion Command

1. Set scan tuning
nikto -host [host] -Tuning [tuning]
2. Set evasion technique
nikto -host [host] -evasion [technique]
3. Set display output
nikto -host [host] -Display [flags]
4. Set CGI dirs
nikto -host [host] -Cgidirs [dirs]
5. Set pause between tests
nikto -host [host] -Pause [seconds]
6. Set timeout
nikto -host [host] -timeout [seconds]
EOF

  read -r -p $'\nSelect-Options>Nikto>Tuning>' select
  case "$select" in
    1)
      read -r -p "Input host> " host
      read -r -p "Input tuning> " tuning
      run_nikto nikto -host "$host" -Tuning "$tuning"
      ;;
    2)
      read -r -p "Input host> " host
      read -r -p "Input evasion technique> " technique
      run_nikto nikto -host "$host" -evasion "$technique"
      ;;
    3)
      read -r -p "Input host> " host
      read -r -p "Input display flags> " flags
      run_nikto nikto -host "$host" -Display "$flags"
      ;;
    4)
      read -r -p "Input host> " host
      read -r -p "Input CGI dirs> " dirs
      run_nikto nikto -host "$host" -Cgidirs "$dirs"
      ;;
    5)
      read -r -p "Input host> " host
      read -r -p "Input pause seconds> " pause
      run_nikto nikto -host "$host" -Pause "$pause"
      ;;
    6)
      read -r -p "Input host> " host
      read -r -p "Input timeout seconds> " timeout
      run_nikto nikto -host "$host" -timeout "$timeout"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

advanced_menu() {
  cat <<'EOF'
Advanced / Info Query
Advanced / Info Command

1. Check database
nikto -dbcheck
2. List plugins
nikto -list-plugins
3. Print version
nikto -Version
4. Disable SSL
nikto -host [host] -nossl
5. Disable interactive features
nikto -host [host] -nointeractive
6. Disable DNS lookups
nikto -host [host] -nolookup
7. Update database and plugins
nikto -update
EOF

  read -r -p $'\nSelect-Options>Nikto>Advanced>' select
  case "$select" in
    1) run_nikto nikto -dbcheck ;;
    2) run_nikto nikto -list-plugins ;;
    3) run_nikto nikto -Version ;;
    4)
      read -r -p "Input host> " host
      run_nikto nikto -host "$host" -nossl
      ;;
    5)
      read -r -p "Input host> " host
      run_nikto nikto -host "$host" -nointeractive
      ;;
    6)
      read -r -p "Input host> " host
      run_nikto nikto -host "$host" -nolookup
      ;;
    7) run_nikto nikto -update ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

main() {
  while true; do
    main_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>Nikto>' select

    case "$select" in
      1) basic_scan ;;
      2) output_menu ;;
      3) tuning_menu ;;
      4) advanced_menu ;;
      b|B) return 0 ;;
      q|Q) exit 0 ;;
      *)
        echo "Pilihan belum tersedia."
        ;;
    esac
    echo
  done
}

main
