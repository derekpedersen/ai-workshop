#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REFERENCES_DIR="$ROOT_DIR/references"
SKILLS_DIR="$ROOT_DIR/skills"
WORKSHOP_TARGET_DIR="${AI_WORKSHOP_TARGET_DIR:-$HOME/.ai-workshop}"
WRAPPERS=(none copilot claude codex cursor)
REFERENCE_PACKAGES=(golang python docker vue)

show_help() {
  cat <<'EOF'
Usage:
  ./uninstall.sh
  ./uninstall.sh --source external --package golang --wrapper claude --all
  ./uninstall.sh --source external --package python --wrapper copilot --skill python-project-layout
  ./uninstall.sh --source local --skill testing
  ./uninstall.sh --source local --skill project-planning --wrapper claude

Options:
  --source <external|local>
      Choose whether to remove an external reference package or a local workshop skill.
  --package <name>
      External reference package to remove: golang, python, docker, vue.
  --wrapper <name>
      Wrapper target context: none, copilot, claude, codex, cursor.
  --skill <name>
      One skill to remove. Repeat to remove multiple skills.
  --all
      Remove all available skills for the selected source.
  --help
      Show this help text.

Interactive mode:
  If no arguments are supplied, the installer prompts for the source, package or skill,
  wrapper, and whether to remove all or a specific selection.
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

list_reference_packages() {
  local names=()
  for package in "${REFERENCE_PACKAGES[@]}"; do
    if [[ -d "$REFERENCES_DIR/$package" ]]; then
      names+=("$package")
    fi
  done
  printf '%s\n' "${names[@]}"
}

list_local_skills() {
  local names=()
  if [[ -d "$WORKSHOP_TARGET_DIR/skills" ]]; then
    while IFS= read -r skill; do
      names+=("$skill")
    done < <(find "$WORKSHOP_TARGET_DIR/skills" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
  fi
  printf '%s\n' "${names[@]}"
}

remove_local_skills() {
  local target_dir="$WORKSHOP_TARGET_DIR/skills"
  local selected=()

  if [[ "$install_all" == true ]]; then
    while IFS= read -r skill; do
      selected+=("$skill")
    done < <(list_local_skills)
  elif [[ ${#skills[@]} -gt 0 ]]; then
    selected=("${skills[@]}")
  else
    if [[ -n "$(list_local_skills)" ]]; then
      selected+=("$(prompt_choice "Select a local skill to remove" $(list_local_skills))")
    else
      echo "No local skills are installed in $target_dir" >&2
      exit 1
    fi
  fi

  if [[ ${#selected[@]} -eq 0 ]]; then
    echo "No local skills selected for removal." >&2
    exit 1
  fi

  echo "Removing local workshop skills from $target_dir"
  for skill in "${selected[@]}"; do
    local source_dir="$target_dir/$skill"
    if [[ ! -d "$source_dir" ]]; then
      echo "Local skill not found: $skill" >&2
      continue
    fi
    rm -rf "$source_dir"
    printf 'Removed local skill: %s -> %s\n' "$skill" "$source_dir"
  done
}

resolve_reference_url() {
  local package="$1"
  local package_dir="$REFERENCES_DIR/$package"
  local install_script="$package_dir/install.sh"

  if [[ ! -f "$install_script" ]]; then
    echo "Missing install script for package: $package" >&2
    return 1
  fi

  local repo_value
  repo_value="$(grep '^REPO_URL=' "$install_script" 2>/dev/null | head -n 1 || true)"
  if [[ -n "$repo_value" ]]; then
    repo_value="${repo_value#REPO_URL=}"
    repo_value="${repo_value#\${SKILLS_REPO_URL:-}}"
    repo_value="${repo_value%%$'\r'}"
    repo_value="${repo_value%"\n"}"
    repo_value="${repo_value#\"}"
    repo_value="${repo_value%\"}"
    printf '%s\n' "$repo_value"
    return 0
  fi

  case "$package" in
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

remove_reference_package() {
  local package="$1"
  local wrapper="$2"
  local uninstall_args=("${@:3}")
  local repo_url

  repo_url="$(resolve_reference_url "$package")" || {
    echo "Unable to resolve a managed upstream repository for $package" >&2
    exit 1
  }

  if [[ "$wrapper" != "none" ]]; then
    printf 'Removing external reference package: %s using wrapper context: %s\n' "$package" "$wrapper"
  else
    printf 'Removing external reference package: %s\n' "$package"
  fi

  if [[ ${#uninstall_args[@]} -eq 0 ]]; then
    uninstall_args=(--all)
  fi

  if command -v npx >/dev/null 2>&1; then
    if npx skills remove "$repo_url" "${uninstall_args[@]}"; then
      return 0
    fi
    echo "The package manager does not support direct remove for this skill library. Remove it manually or re-run the package-specific install flow." >&2
    return 1
  fi

  echo "npx is not installed; cannot remove external skill package $package automatically." >&2
  return 1
}

source="external"
package=""
wrapper="none"
install_all=false
skills=()
initial_args=("$@")

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)
      source="$2"
      shift 2
      ;;
    --package)
      package="$2"
      shift 2
      ;;
    --wrapper)
      wrapper="$2"
      shift 2
      ;;
    --skill)
      skills+=("$2")
      shift 2
      ;;
    --all)
      install_all=true
      shift
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
  echo "AI Workshop uninstall selector"
  source="$(prompt_choice "Choose an uninstall source" "external reference package" "local workshop skill")"

  if [[ "$source" == "external reference package" ]]; then
    package="$(prompt_choice "Select a reference package" $(list_reference_packages))"
    wrapper="$(prompt_choice "Select a wrapper context" "none" "copilot" "claude" "codex" "cursor")"
    local choice
    choice="$(prompt_choice "Uninstall scope" "all" "specific")"
    if [[ "$choice" == "all" ]]; then
      install_all=true
    else
      install_all=false
      echo "The package manager decides which specific items can be removed in this context; falling back to the package's supported remove behavior."
      install_all=true
    fi
  else
    wrapper="$(prompt_choice "Select a wrapper target context" "none" "copilot" "claude" "codex" "cursor")"
    local skill_name="$(prompt_choice "Select a local skill to remove" $(list_local_skills))"
    skills=("$skill_name")
    install_all=false
  fi
fi

if [[ "$source" == "external reference package" || "$source" == "external" ]]; then
  if [[ -z "$package" ]]; then
    echo "A reference package is required for external uninstall." >&2
    show_help >&2
    exit 1
  fi

  if [[ " ${REFERENCE_PACKAGES[*]} " != *" $package "* ]]; then
    echo "Unsupported reference package: $package" >&2
    echo "Valid packages: ${REFERENCE_PACKAGES[*]}" >&2
    exit 1
  fi

  if [[ " ${WRAPPERS[*]} " != *" $wrapper "* ]]; then
    echo "Unsupported wrapper: $wrapper" >&2
    echo "Valid wrappers: ${WRAPPERS[*]}" >&2
    exit 1
  fi

  uninstall_args=()
  if [[ "$install_all" == true ]]; then
    uninstall_args=(--all)
  elif [[ ${#skills[@]} -gt 0 ]]; then
    for skill_name in "${skills[@]}"; do
      uninstall_args+=(--skill "$skill_name")
    done
  else
    uninstall_args=(--all)
  fi

  remove_reference_package "$package" "$wrapper" "${uninstall_args[@]}"
  exit 0
fi

if [[ "$source" == "local workshop skill" || "$source" == "local" ]]; then
  if [[ "$install_all" == false && ${#skills[@]} -eq 0 ]]; then
    if [[ -n "$(list_local_skills)" ]]; then
      skills=("$(prompt_choice "Choose a local skill to remove" $(list_local_skills))")
    else
      echo "No local skills are installed in $WORKSHOP_TARGET_DIR/skills" >&2
      exit 1
    fi
  fi

  if [[ "$wrapper" == "none" ]]; then
    echo "Local skill removal target: $WORKSHOP_TARGET_DIR/skills"
  else
    echo "Local skill removal target: $WORKSHOP_TARGET_DIR/skills (wrapper hint: $wrapper)"
  fi

  remove_local_skills
  exit 0
fi

echo "Unsupported uninstall source: $source" >&2
show_help >&2
exit 1
