#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/magic-shortcut"
HANDLERS_DIR="$CONFIG_DIR/handlers"
BIN_DIR="$HOME/.local/bin"

set -x

# Create config and bin directories
mkdir -p "$HANDLERS_DIR"
mkdir -p "$BIN_DIR"

# Copy handler scripts
install --target-directory="$HANDLERS_DIR" "$SCRIPT_DIR/handlers/"*

# Install main script
install "$SCRIPT_DIR/magic-shortcut" "$BIN_DIR/magic-shortcut"

# Check if the bin directory is in PATH
set +x
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "Warning: $BIN_DIR is not in your PATH. Please add it to use magic-shortcut from the command line."
fi
