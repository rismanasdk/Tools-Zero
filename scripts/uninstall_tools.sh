#!/usr/bin/env bash

set -euo pipefail

VENV_DIR=".venv"

if [[ -d "${VENV_DIR}" ]]; then
  echo "Removing virtual environment ${VENV_DIR}..."
  rm -rf "${VENV_DIR}"
else
  echo "Virtual environment ${VENV_DIR} not found."
fi

echo "Done."
