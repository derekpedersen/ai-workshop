#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

shell_scripts=()
while IFS= read -r script; do
  shell_scripts+=("$script")
done < <(find . -type f -name "*.sh" -not -path "./.git/*" | sort)

if [[ ${#shell_scripts[@]} -eq 0 ]]; then
  echo "No shell scripts found."
  exit 0
fi

echo "Running bash -n on ${#shell_scripts[@]} shell scripts"
for script in "${shell_scripts[@]}"; do
  bash -n "$script"
  echo "OK: $script"
done

echo "Bash syntax validation complete."
