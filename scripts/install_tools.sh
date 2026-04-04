#!/usr/bin/env bash

set -euo pipefail

PACKAGES=(
  nmap
  aircrack-ng
  hydra
  john
  medusa
  nikto
  sqlmap
  gobuster
)

echo "Updating package index..."
sudo apt update

echo "Installing supported security tools..."
sudo apt install -y "${PACKAGES[@]}"

cat <<'EOF'

successfully installed:
- nmap
- aircrack-ng
- hydra
- john        
- medusa
- nikto
- sqlmap
- gobuster   

EOF

# Note:
# -I'm using Ubuntu 24.04 LTS, so please adjust the installation method to suit your operating system.
# -I haven't added Burp Suite, so you can skip it.