#!/usr/bin/env bash

set -euo pipefail

VENV_DIR=".venv"
LAUNCHER_PATH="/usr/local/bin/toolszero"

if [[ -d "${VENV_DIR}" ]]; then
  echo "Removing virtual environment ${VENV_DIR}..."
  rm -rf "${VENV_DIR}"
else
  echo "Virtual environment ${VENV_DIR} not found."
fi

if [[ -f "${LAUNCHER_PATH}" ]]; then
  echo "Removing launcher ${LAUNCHER_PATH}..."
  sudo rm -f "${LAUNCHER_PATH}"
else
  echo "Launcher ${LAUNCHER_PATH} not found."
fi

echo "Done."
