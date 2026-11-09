#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${SKILLS_REPO_URL:-https://github.com/antfu/skills}"
ARGS=("$@")

if [ "${#ARGS[@]}" -eq 0 ]; then
  ARGS=(--all)
fi

printf 'Installing Vue/frontend skill pack from %s\n' "$REPO_URL"

npx skills add "$REPO_URL" "${ARGS[@]}"
