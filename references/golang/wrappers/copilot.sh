#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TOOL_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

printf 'Applying Copilot wrapper for the Go skill package.\n'

"$TOOL_DIR/install.sh" --all
