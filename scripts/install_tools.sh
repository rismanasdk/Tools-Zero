#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LAUNCHER_PATH="/usr/local/bin/toolszero"

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

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but was not found in PATH."
  exit 1
fi

echo "Creating launcher at ${LAUNCHER_PATH}..."
sudo tee "${LAUNCHER_PATH}" >/dev/null <<EOF
#!/usr/bin/env bash
set -euo pipefail
cd "${PROJECT_ROOT}"
exec python3 main.py "\$@"
EOF
sudo chmod +x "${LAUNCHER_PATH}"

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

launcher installed:
- toolszero

EOF

# Note:
# -I'm using Ubuntu 24.04 LTS, so please adjust the installation method to suit your operating system.
# -I haven't added Burp Suite, so you can skip it.
