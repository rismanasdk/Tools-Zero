#!/usr/bin/env bash

# John The Ripper consolidated orchestrator - Phase 1 refactoring
# Consolidates 9 mode subdirectories into single file

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${BASE_DIR}/common.sh"

show_menu() {
  cat << 'EOF'
1. Wordlist
2. Single
3. Incremental
4. Restore Session
5. Show
6. Status
7. Test
8. Wordlist Rules
9. Advanced
EOF
}

handle_wordlist() {
  cat << 'EOF'
Wordlist Mode Query - Wordlist Mode Command

1. Basic wordlist attack
   john -wordlist:[wordlist file] [password file]
2. Wordlist with rules
   john -wordlist:[wordlist file] -rules [password file]
3. Wordlist with session
   john -wordlist:[wordlist file] -session:[session file] [password file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Wordlist>' select

  case "$select" in
    1)
      read -r -p "Input wordlist file> " wordlist
      read -r -p "Input password file> " passwd
      run_john john -wordlist:"$wordlist" "$passwd"
      ;;
    2)
      read -r -p "Input wordlist file> " wordlist
      read -r -p "Input password file> " passwd
      run_john john -wordlist:"$wordlist" -rules "$passwd"
      ;;
    3)
      read -r -p "Input wordlist file> " wordlist
      read -r -p "Input session file> " session
      read -r -p "Input password file> " passwd
      run_john john -wordlist:"$wordlist" -session:"$session" "$passwd"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_single() {
  cat << 'EOF'
Single Mode Query - Single Mode Command

1. Single crack mode
   john -single [password file]
2. Single with session
   john -single -session:[session file] [password file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Single>' select

  case "$select" in
    1)
      read -r -p "Input password file> " passwd
      run_john john -single "$passwd"
      ;;
    2)
      read -r -p "Input session file> " session
      read -r -p "Input password file> " passwd
      run_john john -single -session:"$session" "$passwd"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_incremental() {
  cat << 'EOF'
Incremental Mode Query - Incremental Mode Command

1. Basic incremental attack
   john -incremental [password file]
2. Incremental with session
   john -incremental -session:[session file] [password file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Incremental>' select

  case "$select" in
    1)
      read -r -p "Input password file> " passwd
      run_john john -incremental "$passwd"
      ;;
    2)
      read -r -p "Input session file> " session
      read -r -p "Input password file> " passwd
      run_john john -incremental -session:"$session" "$passwd"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_restore_session() {
  cat << 'EOF'
Restore Session Query - Restore Session Command

1. Restore last session
   john -restore
2. Restore specific session
   john -restore:[session file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Restore-Session>' select

  case "$select" in
    1)
      run_john john -restore
      ;;
    2)
      read -r -p "Input session file> " session
      run_john john -restore:"$session"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_show() {
  cat << 'EOF'
Show Query - Show Command

1. Show cracked passwords
   john -show [password file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Show>' select

  case "$select" in
    1)
      read -r -p "Input password file> " passwd
      run_john john -show "$passwd"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_status() {
  cat << 'EOF'
Status Query - Status Command

1. Show session status
   john -status
2. Show session status specific
   john -status:[session file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Status>' select

  case "$select" in
    1)
      run_john john -status
      ;;
    2)
      read -r -p "Input session file> " session
      run_john john -status:"$session"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_test() {
  cat << 'EOF'
Test Query - Test Command

1. Run benchmark test
   john -test
2. Run benchmark test with duration
   john -test=[duration seconds]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Test>' select

  case "$select" in
    1)
      run_john john -test
      ;;
    2)
      read -r -p "Input duration in seconds> " duration
      run_john john -test="$duration"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_wordlist_rules() {
  cat << 'EOF'
Wordlist Rules Query - Wordlist Rules Command

1. Wordlist with default rules
   john -wordlist:[wordlist file] -rules [password file]
2. Wordlist with custom rules
   john -wordlist:[wordlist file] -rules=[rule file] [password file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Wordlist-Rules>' select

  case "$select" in
    1)
      read -r -p "Input wordlist file> " wordlist
      read -r -p "Input password file> " passwd
      run_john john -wordlist:"$wordlist" -rules "$passwd"
      ;;
    2)
      read -r -p "Input wordlist file> " wordlist
      read -r -p "Input rule file> " rulefile
      read -r -p "Input password file> " passwd
      run_john john -wordlist:"$wordlist" -rules="$rulefile" "$passwd"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

handle_advanced() {
  cat << 'EOF'
Advanced Query - Advanced Command

1. Mask attack
   john -mask=[mask] [password file]
2. External filter
   john -external:[filter] [password file]
3. Multiple formats
   john -format=[format] [password file]
EOF

  read -r -p $'\nSelect-Options>JohnTheRipper>Advanced>' select

  case "$select" in
    1)
      read -r -p "Input mask pattern> " mask
      read -r -p "Input password file> " passwd
      run_john john -mask:"$mask" "$passwd"
      ;;
    2)
      read -r -p "Input filter name> " filter
      read -r -p "Input password file> " passwd
      run_john john -external:"$filter" "$passwd"
      ;;
    3)
      read -r -p "Input format> " format
      read -r -p "Input password file> " passwd
      run_john john -format:"$format" "$passwd"
      ;;
    *)
      echo "Selected command is not available."
      ;;
  esac
}

main() {
  while true; do
    show_menu
    echo "b. Back to main menu"
    echo "q. Quit"
    read -r -p $'\nSelect-Options>JohnTheRipper>' select

    case "$select" in
      1) handle_wordlist ;;
      2) handle_single ;;
      3) handle_incremental ;;
      4) handle_restore_session ;;
      5) handle_show ;;
      6) handle_status ;;
      7) handle_test ;;
      8) handle_wordlist_rules ;;
      9) handle_advanced ;;
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
