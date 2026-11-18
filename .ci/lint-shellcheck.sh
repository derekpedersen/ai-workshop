#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

report_dir="${CI_REPORTS_DIR:-reports}"
mkdir -p "$report_dir"
report_file="$report_dir/shellcheck-checkstyle.xml"

if ! command -v shellcheck >/dev/null 2>&1; then
  echo "shellcheck is required but was not found on PATH." >&2
  echo "Install shellcheck on the Jenkins agent, then rerun." >&2
  exit 1
fi

shell_scripts=()
while IFS= read -r script; do
  shell_scripts+=("$script")
done < <(find . -type f -name "*.sh" -not -path "./.git/*" | sort)

if [[ ${#shell_scripts[@]} -eq 0 ]]; then
  echo "No shell scripts found."
  exit 0
fi

echo "Running shellcheck on ${#shell_scripts[@]} shell scripts"
shellcheck --severity=warning --format=checkstyle "${shell_scripts[@]}" >"$report_file"

echo "Shellcheck report written to: $report_file"

echo "Shellcheck validation complete."
