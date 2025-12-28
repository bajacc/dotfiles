#!/bin/bash
set -eu

VENV_DIR="$HOME/.config/aerospace/venv"
VENV_PY="$VENV_DIR/bin/python"
SCRIPT="$HOME/.config/aerospace/alacritty.py"

# Create venv if it does not exist
if [ ! -x "$VENV_PY" ]; then
    echo "[+] Creating venv at $VENV_DIR"
    python3 -m venv "$VENV_DIR"

    echo "[+] Installing dependencies"
    "$VENV_PY" -m pip install --upgrade pip
    "$VENV_PY" -m pip install toml
fi

# Replace shell with the script (no extra process)
exec "$VENV_PY" "$SCRIPT" "$@"