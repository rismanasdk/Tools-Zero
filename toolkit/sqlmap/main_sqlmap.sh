#!/usr/bin/env bash

# SQLMap consolidated orchestrator - Phase 1 refactoring
# Consolidates 8 category subdirectories into single file with inline handlers

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

# Main category menu - inlined to avoid subprocess
show_category_menu() {
  cat << 'EOF'
1. Target
2. Request
3. Enumeration
4. File System Access
5. Operating System Access
6. General
7. Misc
EOF
}

# Target category handler
handle_target() {
  cat << 'EOF'
Target Query - Target Command

1. Target URL
   sqlmap -u [url] --batch
2. Direct DB connection
   sqlmap -d [connection string] --batch
3. Parse proxy log file
   sqlmap -l [log file] --batch
4. Scan multiple targets
   sqlmap -m [bulk file] --batch
5. Load HTTP request from file
   sqlmap -r [request file] --batch
6. Google dork targets
   sqlmap -g [google dork] --batch
7. Load config file
   sqlmap -c [config file] --batch
EOF

  read -r -p $'\nSelect-Options>Sqlmap>Target>' select

  case "$select" in
    1)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --batch
      ;;
    2)
      read -r -p "Input direct connection string> " dsn
      run_sqlmap sqlmap -d "$dsn" --batch
      ;;
    3)
      read -r -p "Input log file> " logfile
      run_sqlmap sqlmap -l "$logfile" --batch
      ;;
    4)
      read -r -p "Input bulk file> " bulkfile
      run_sqlmap sqlmap -m "$bulkfile" --batch
      ;;
    5)
      read -r -p "Input request file> " requestfile
      run_sqlmap sqlmap -r "$requestfile" --batch
      ;;
    6)
      read -r -p "Input Google dork> " dork
      run_sqlmap sqlmap -g "$dork" --batch
      ;;
    7)
      read -r -p "Input config file> " configfile
      run_sqlmap sqlmap -c "$configfile" --batch
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

# Request category handler
handle_request() {
  cat << 'EOF'
Request Query - Request Command

1. HTTP method
   sqlmap --method INT -u [url] --batch
2. Data body
   sqlmap -u [url] --data=[data] --batch
3. Cookie
   sqlmap -u [url] --cookie=[cookie] --batch
4. User-Agent
   sqlmap -u [url] --user-agent -a [agent] --batch
5. Proxy
   sqlmap -u [url] --proxy=[url] --batch
6. Authentication
   sqlmap -u [url] --auth-type=[type] --auth-cred=[cred] --batch
7. HTTP referer
   sqlmap -u [url] --referer [url] --batch
EOF

  read -r -p $'\nSelect-Options>Sqlmap>Request>' select

  case "$select" in
    1)
      read -r -p "Input HTTP method> " method
      read -r -p "Input URL> " url
      run_sqlmap sqlmap --method "$method" -u "$url" --batch
      ;;
    2)
      read -r -p "Input URL> " url
      read -r -p "Input data body> " data
      run_sqlmap sqlmap -u "$url" --data="$data" --batch
      ;;
    3)
      read -r -p "Input URL> " url
      read -r -p "Input cookie> " cookie
      run_sqlmap sqlmap -u "$url" --cookie="$cookie" --batch
      ;;
    4)
      read -r -p "Input URL> " url
      read -r -p "Input user-agent> " useragent
      run_sqlmap sqlmap -u "$url" --user-agent="$useragent" --batch
      ;;
    5)
      read -r -p "Input URL> " url
      read -r -p "Input proxy URL> " proxy
      run_sqlmap sqlmap -u "$url" --proxy="$proxy" --batch
      ;;
    6)
      read -r -p "Input URL> " url
      read -r -p "Input auth type (Basic/Digest/NTLM)> " authtype
      read -r -p "Input auth credentials (user:pass)> " authcred
      run_sqlmap sqlmap -u "$url" --auth-type="$authtype" --auth-cred="$authcred" --batch
      ;;
    7)
      read -r -p "Input URL> " url
      read -r -p "Input referer URL> " referer
      run_sqlmap sqlmap -u "$url" --referer "$referer" --batch
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

# General category handler
handle_general() {
  cat << 'EOF'
General Query - General Command

1. Batch mode
   sqlmap -u [url] --batch
2. Crawl
   sqlmap -u [url] --crawl=[depth] --batch
3. Set level and risk
   sqlmap -u [url] --level=[level] --risk=[risk] --batch
4. Set threads
   sqlmap -u [url] --threads=[threads] --batch
5. Set time limit
   sqlmap -u [url] --time-limit=[seconds] --batch
6. Force forms
   sqlmap -u [url] --forms --batch
EOF

  read -r -p $'\nSelect-Options>Sqlmap>General>' select

  case "$select" in
    1)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --batch
      ;;
    2)
      read -r -p "Input URL> " url
      read -r -p "Input crawl depth> " depth
      run_sqlmap sqlmap -u "$url" --crawl="$depth" --batch
      ;;
    3)
      read -r -p "Input URL> " url
      read -r -p "Input level> " level
      read -r -p "Input risk> " risk
      run_sqlmap sqlmap -u "$url" --level="$level" --risk="$risk" --batch
      ;;
    4)
      read -r -p "Input URL> " url
      read -r -p "Input threads> " threads
      run_sqlmap sqlmap -u "$url" --threads="$threads" --batch
      ;;
    5)
      read -r -p "Input URL> " url
      read -r -p "Input time limit> " seconds
      run_sqlmap sqlmap -u "$url" --time-limit="$seconds" --batch
      ;;
    6)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --forms --batch
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

# Enumeration category handler
handle_enumeration() {
  cat << 'EOF'
Enumeration Query - Enumeration Command

1. List databases
   sqlmap -u [url] --dbs --batch
2. List tables
   sqlmap -u [url] -D [database] --tables --batch
3. Dump table
   sqlmap -u [url] -D [database] -T [table] --dump --batch
4. Dump all
   sqlmap -u [url] --dump-all --batch
5. Search
   sqlmap -u [url] --search --batch
6. Check for DBMS
   sqlmap -u [url] --current-db --batch
EOF

  read -r -p $'\nSelect-Options>Sqlmap>Enumeration>' select

  case "$select" in
    1)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --dbs --batch
      ;;
    2)
      read -r -p "Input URL> " url
      read -r -p "Input database> " database
      run_sqlmap sqlmap -u "$url" -D "$database" --tables --batch
      ;;
    3)
      read -r -p "Input URL> " url
      read -r -p "Input database> " database
      read -r -p "Input table> " table
      run_sqlmap sqlmap -u "$url" -D "$database" -T "$table" --dump --batch
      ;;
    4)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --dump-all --batch
      ;;
    5)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --search --batch
      ;;
    6)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --current-db --batch
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

# File-system category handler
handle_file_system() {
  cat << 'EOF'
File-System Query - File-System Command

1. File read
   sqlmap -u [url] --file-read [file] --batch
2. File write
   sqlmap -u [url] --file-write [file] --file-dest [file] --batch
3. Directory listing
   sqlmap -u [url] --dir-listing [path] --batch
4. Operating system shell
   sqlmap -u [url] --os-shell --batch
5. Operating system cmd
   sqlmap -u [url] --os-cmd [cmd] --batch
EOF

  read -r -p $'\nSelect-Options>Sqlmap>File-System>' select

  case "$select" in
    1)
      read -r -p "Input URL> " url
      read -r -p "Input file path to read> " filepath
      run_sqlmap sqlmap -u "$url" --file-read "$filepath" --batch
      ;;
    2)
      read -r -p "Input URL> " url
      read -r -p "Input file to write> " writefile
      read -r -p "Input destination file> " destfile
      run_sqlmap sqlmap -u "$url" --file-write "$writefile" --file-dest "$destfile" --batch
      ;;
    3)
      read -r -p "Input URL> " url
      read -r -p "Input directory path> " dirpath
      run_sqlmap sqlmap -u "$url" --dir-listing "$dirpath" --batch
      ;;
    4)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --os-shell --batch
      ;;
    5)
      read -r -p "Input URL> " url
      read -r -p "Input OS command> " oscmd
      run_sqlmap sqlmap -u "$url" --os-cmd "$oscmd" --batch
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

# OS-Access category handler
handle_os_access() {
  cat << 'EOF'
OS-Access Query - OS-Access Command

1. Operating system shell
   sqlmap -u [url] --os-shell --batch
2. Operating system command
   sqlmap -u [url] --os-cmd [command] --batch
3. Operating system shell with DB
   sqlmap -u [url] --os-shell --db-creds --batch
4. File read
   sqlmap -u [url] --file-read [file] --batch
5. File write
   sqlmap -u [url] --file-write [file] --file-dest [file] --batch
EOF

  read -r -p $'\nSelect-Options>Sqlmap>OS-Access>' select

  case "$select" in
    1)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --os-shell --batch
      ;;
    2)
      read -r -p "Input URL> " url
      read -r -p "Input OS command> " oscmd
      run_sqlmap sqlmap -u "$url" --os-cmd "$oscmd" --batch
      ;;
    3)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --os-shell --db-creds --batch
      ;;
    4)
      read -r -p "Input URL> " url
      read -r -p "Input file path to read> " filepath
      run_sqlmap sqlmap -u "$url" --file-read "$filepath" --batch
      ;;
    5)
      read -r -p "Input URL> " url
      read -r -p "Input file to write> " writefile
      read -r -p "Input destination file> " destfile
      run_sqlmap sqlmap -u "$url" --file-write "$writefile" --file-dest "$destfile" --batch
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

# Misc category handler
handle_misc() {
  cat << 'EOF'
Misc Query - Misc Command

1. Tamper script
   sqlmap -u [url] --tamper [script] --batch
2. WAF detection
   sqlmap -u [url] --identify-waf --batch
3. Technique
   sqlmap -u [url] --technique [A|T|E|S|U] --batch
4. OS detection
   sqlmap -u [url] --os-shell --technique U --batch
5. Wizard
   sqlmap --wizard --batch
EOF

  read -r -p $'\nSelect-Options>Sqlmap>Misc>' select

  case "$select" in
    1)
      read -r -p "Input URL> " url
      read -r -p "Input tamper script> " tamper
      run_sqlmap sqlmap -u "$url" --tamper "$tamper" --batch
      ;;
    2)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --identify-waf --batch
      ;;
    3)
      read -r -p "Input URL> " url
      read -r -p "Input technique (A|T|E|S|U)> " technique
      run_sqlmap sqlmap -u "$url" --technique "$technique" --batch
      ;;
    4)
      read -r -p "Input URL> " url
      run_sqlmap sqlmap -u "$url" --os-shell --technique U --batch
      ;;
    5)
      run_sqlmap sqlmap --wizard --batch
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

main() {
  while true; do
    show_category_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>Sqlmap>' select

    case "$select" in
      1) handle_target ;;
      2) handle_request ;;
      3) handle_enumeration ;;
      4) handle_file_system ;;
      5) handle_os_access ;;
      6) handle_general ;;
      7) handle_misc ;;
      b|B) return 0 ;;
      q|Q) exit 0 ;;
      *)
        echo "Selected command is not available."
        ;;
    esac
    echo
  done
}

main
