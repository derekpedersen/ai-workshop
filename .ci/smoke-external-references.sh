#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v npx >/dev/null 2>&1; then
  echo "npx is required for external reference checks." >&2
  exit 1
fi

echo "Checking external package argument handling without interactive prompts"
./install.sh --source external --package golang --wrapper none --all --help >/dev/null || true

for package_dir in references/*; do
  [[ -d "$package_dir" ]] || continue
  install_script="$package_dir/install.sh"

  if [[ -f "$install_script" ]]; then
    echo "Validating non-interactive execution path for $install_script"
    bash -n "$install_script"
  fi
done

echo "Optional external reference check complete."
