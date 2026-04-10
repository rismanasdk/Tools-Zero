#!/usr/bin/env bash

# Gobuster consolidated orchestrator - Phase 1 refactoring
# Consolidates 8 mode subdirectories into single file

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  bash "${BASE_DIR}/help_commands.sh"
}

handle_mode() {
  local mode="$1"
  
  case "$mode" in
    dir)
      cat << 'EOF'
Directory Enumeration - Mode DIR

1. Basic directory enumeration
   gobuster dir -u [url] -w [wordlist]
2. Directory enumeration with extensions
   gobuster dir -u [url] -w [wordlist] -x [extensions]
3. Directory enumeration with status codes
   gobuster dir -u [url] -w [wordlist] -s [status codes]
4. Directory enumeration with threads
   gobuster dir -u [url] -w [wordlist] -t [threads]
EOF
      read -r -p $'\nSelect-Options>Gobuster>Dir>' select
      case "$select" in
        1)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster dir -u "$url" -w "$wordlist"
          ;;
        2)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          read -r -p "Input extensions (comma-separated)> " extensions
          run_gobuster gobuster dir -u "$url" -w "$wordlist" -x "$extensions"
          ;;
        3)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          read -r -p "Input status codes (comma-separated)> " statuscodes
          run_gobuster gobuster dir -u "$url" -w "$wordlist" -s "$statuscodes"
          ;;
        4)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          read -r -p "Input thread count> " threads
          run_gobuster gobuster dir -u "$url" -w "$wordlist" -t "$threads"
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
    dns)
      cat << 'EOF'
DNS Subdomain Enumeration - Mode DNS

1. Basic DNS enumeration
   gobuster dns -d [domain] -w [wordlist]
2. DNS enumeration with threads
   gobuster dns -d [domain] -w [wordlist] -t [threads]
3. DNS enumeration verbose
   gobuster dns -d [domain] -w [wordlist] -v
EOF
      read -r -p $'\nSelect-Options>Gobuster>DNS>' select
      case "$select" in
        1)
          read -r -p "Input domain> " domain
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster dns -d "$domain" -w "$wordlist"
          ;;
        2)
          read -r -p "Input domain> " domain
          read -r -p "Input wordlist> " wordlist
          read -r -p "Input thread count> " threads
          run_gobuster gobuster dns -d "$domain" -w "$wordlist" -t "$threads"
          ;;
        3)
          read -r -p "Input domain> " domain
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster dns -d "$domain" -w "$wordlist" -v
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
    vhost)
      cat << 'EOF'
Virtual Host Enumeration - Mode VHOST

1. Basic virtual host enumeration
   gobuster vhost -u [url] -w [wordlist]
2. Virtual host enumeration with threads
   gobuster vhost -u [url] -w [wordlist] -t [threads]
EOF
      read -r -p $'\nSelect-Options>Gobuster>Vhost>' select
      case "$select" in
        1)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster vhost -u "$url" -w "$wordlist"
          ;;
        2)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          read -r -p "Input thread count> " threads
          run_gobuster gobuster vhost -u "$url" -w "$wordlist" -t "$threads"
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
    fuzz)
      cat << 'EOF'
Fuzzing - Mode FUZZ

1. Basic fuzzing
   gobuster fuzz -u [url] -w [wordlist]
2. Fuzzing with extensions
   gobuster fuzz -u [url] -w [wordlist] -x [extensions]
EOF
      read -r -p $'\nSelect-Options>Gobuster>Fuzz>' select
      case "$select" in
        1)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster fuzz -u "$url" -w "$wordlist"
          ;;
        2)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          read -r -p "Input extensions> " extensions
          run_gobuster gobuster fuzz -u "$url" -w "$wordlist" -x "$extensions"
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
    gcs)
      cat << 'EOF'
Google Cloud Storage Enumeration - Mode GCS

1. Basic GCS enumeration
   gobuster gcs -w [wordlist]
EOF
      read -r -p $'\nSelect-Options>Gobuster>GCS>' select
      case "$select" in
        1)
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster gcs -w "$wordlist"
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
    s3)
      cat << 'EOF'
S3 Bucket Enumeration - Mode S3

1. Basic S3 bucket enumeration
   gobuster s3 -w [wordlist]
EOF
      read -r -p $'\nSelect-Options>Gobuster>S3>' select
      case "$select" in
        1)
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster s3 -w "$wordlist"
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
    tftp)
      cat << 'EOF'
TFTP Server Enumeration - Mode TFTP

1. Basic TFTP enumeration
   gobuster tftp -u [url] -w [wordlist]
EOF
      read -r -p $'\nSelect-Options>Gobuster>TFTP>' select
      case "$select" in
        1)
          read -r -p "Input URL> " url
          read -r -p "Input wordlist> " wordlist
          run_gobuster gobuster tftp -u "$url" -w "$wordlist"
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
    version)
      cat << 'EOF'
Version Detection - Mode VERSION

1. Basic version detection
   gobuster version -u [url]
EOF
      read -r -p $'\nSelect-Options>Gobuster>Version>' select
      case "$select" in
        1)
          read -r -p "Input URL> " url
          run_gobuster gobuster version -u "$url"
          ;;
        *)
          echo "Selected command is not available."
          ;;
      esac
      ;;
  esac
}

main() {
  while true; do
    show_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>Gobuster>' select

    case "$select" in
      1) handle_mode "dir" ;;
      2) handle_mode "dns" ;;
      3) handle_mode "vhost" ;;
      4) handle_mode "fuzz" ;;
      5) handle_mode "gcs" ;;
      6) handle_mode "s3" ;;
      7) handle_mode "tftp" ;;
      8) handle_mode "version" ;;
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
