#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSHOP_TARGET_DIR="${AI_WORKSHOP_TARGET_DIR:-$HOME/.ai-workshop}"
REFERENCES_DIR="$ROOT_DIR/references"
REFERENCE_PACKAGES=(golang python docker vue)

target_source="all"
package=""
initial_args=("$@")

show_help() {
  cat <<'EOF'
Usage:
  ./list.sh
  ./list.sh --source all
  ./list.sh --source local
  ./list.sh --source external
  ./list.sh --source external --package golang

Options:
  --source <all|local|external>
      Show the installed local skill set, the installed external skill set, or both.
  --package <name>
      Optional filter for an external reference package when listing external installs.
  --help
      Show this help text.

Default behavior:
  If no arguments are supplied, the script prompts interactively.
  If arguments are supplied, it runs in headless mode without prompting.
EOF
}

prompt_choice() {
  local prompt="$1"
  shift
  local options=("$@")
  local choice
  local index=1

  echo "$prompt"
  for option in "${options[@]}"; do
    printf '  %s) %s\n' "$index" "$option"
    index=$((index + 1))
  done

  while true; do
    read -r choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
      echo "${options[$((choice - 1))]}"
      return 0
    fi
    echo "Please choose a valid option number." >&2
  done
}

list_local_skills() {
  local target_dir="$WORKSHOP_TARGET_DIR/skills"
  if [[ ! -d "$target_dir" ]]; then
    echo "No local skills installed in $target_dir"
    return 0
  fi

  if [[ -n "$(find "$target_dir" -mindepth 1 -maxdepth 1 -type d -print -quit 2>/dev/null)" ]]; then
    find "$target_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
  else
    echo "No local skills installed in $target_dir"
  fi
}

resolve_reference_url() {
  local selected_package="$1"
  local package_dir="$REFERENCES_DIR/$selected_package"
  local install_script="$package_dir/install.sh"

  if [[ ! -f "$install_script" ]]; then
    return 1
  fi

  local repo_value
  repo_value="$(grep '^REPO_URL=' "$install_script" 2>/dev/null | head -n 1 || true)"
  if [[ -n "$repo_value" ]]; then
    repo_value="${repo_value#REPO_URL=}"
    printf '%s\n' "$repo_value"
    return 0
  fi

  case "$selected_package" in
    golang)
      printf '%s\n' "https://github.com/samber/cc-skills-golang"
      ;;
    python)
      printf '%s\n' "https://github.com/Paldom/python-skills"
      ;;
    docker)
      printf '%s\n' "https://github.com/docker/skills"
      ;;
    vue)
      printf '%s\n' "https://github.com/antfu/skills"
      ;;
    *)
      return 1
      ;;
  esac
}

list_external_skills() {
  if ! command -v npx >/dev/null 2>&1; then
    echo "npx is not installed; external skill inventory is unavailable."
    return 0
  fi

  if [[ -n "$package" ]]; then
    if [[ " ${REFERENCE_PACKAGES[*]} " != *" $package "* ]]; then
      echo "Unsupported reference package: $package" >&2
      return 1
    fi

    local repo_url
    repo_url="$(resolve_reference_url "$package")" || {
      echo "No external skill inventory available for package: $package" >&2
      return 1
    }

    echo "External skills from $repo_url"
    npx skills list | grep -i "${package}" || npx skills list
    return 0
  fi

  echo "Installed external skill inventory"
  npx skills list
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      target_source="$2"
      shift 2
      ;;
    --package)
      package="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      show_help >&2
      exit 1
      ;;
  esac
done

if [[ ${#initial_args[@]} -eq 0 ]]; then
  target_source="$(prompt_choice "Choose a list source" "all" "local" "external")"
fi

case "$target_source" in
  all)
    echo "== Local workshop skills =="
    list_local_skills
    echo
    echo "== External skill inventory =="
    list_external_skills
    ;;
  local)
    echo "== Local workshop skills =="
    list_local_skills
    ;;
  external)
    echo "== External skill inventory =="
    list_external_skills
    ;;
  *)
    echo "Unsupported source: $target_source" >&2
    show_help >&2
    exit 1
    ;;
 esac
