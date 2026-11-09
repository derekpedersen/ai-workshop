#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TOOL_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

printf 'Applying Cursor wrapper for Vue tooling.\n'

"$TOOL_DIR/install.sh" "$@"
