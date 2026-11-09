#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${SKILLS_REPO_URL:-https://github.com/Paldom/python-skills}"
ARGS=("$@")

if [ "${#ARGS[@]}" -eq 0 ]; then
  ARGS=(--all)
fi

printf 'Installing Python skill pack from %s\n' "$REPO_URL"

npx skills add "$REPO_URL" "${ARGS[@]}"
