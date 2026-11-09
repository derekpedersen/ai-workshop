#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${SKILLS_REPO_URL:-https://github.com/samber/cc-skills-golang}"
ARGS=("$@")

if [ "${#ARGS[@]}" -eq 0 ]; then
  ARGS=(--all)
fi

printf 'Installing Go skill pack from %s\n' "$REPO_URL"

npx skills add "$REPO_URL" "${ARGS[@]}"
