#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

export AI_WORKSHOP_TARGET_DIR="$tmp_root/workshop-target"
mkdir -p "$AI_WORKSHOP_TARGET_DIR"

skill_name="testing"

echo "Smoke test: local install"
./install.sh --source local --skill "$skill_name"

if [[ ! -d "$AI_WORKSHOP_TARGET_DIR/skills/$skill_name" ]]; then
  echo "Expected skill directory missing after install: $AI_WORKSHOP_TARGET_DIR/skills/$skill_name" >&2
  exit 1
fi

echo "Smoke test: local list"
list_output="$(./list.sh --source local)"
echo "$list_output"
if ! grep -q "$skill_name" <<<"$list_output"; then
  echo "Expected skill not found in list output: $skill_name" >&2
  exit 1
fi

echo "Smoke test: local uninstall"
./uninstall.sh --source local --skill "$skill_name"

if [[ -d "$AI_WORKSHOP_TARGET_DIR/skills/$skill_name" ]]; then
  echo "Skill directory still exists after uninstall: $AI_WORKSHOP_TARGET_DIR/skills/$skill_name" >&2
  exit 1
fi

echo "Local lifecycle smoke test complete."
