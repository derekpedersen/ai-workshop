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
  ./install.sh
  ./install.sh --source external --package golang --wrapper claude --all
  ./install.sh --source external --package python --wrapper copilot --skill python-project-layout
  ./install.sh --source local --skill testing
  ./install.sh --source local --skill project-planning --wrapper claude

Options:
  --source <external|local>
      Choose whether to install an external reference package or local workshop skills.
  --package <name>
      External reference package to install: golang, python, docker, vue.
  --wrapper <name>
      Wrapper target: none, copilot, claude, codex, cursor.
  --skill <name>
      One skill to install. Repeat to install multiple skills.
  --all
      Install all available skills for the selected source.
  --help
      Show this help text.

Interactive mode:
  If no arguments are supplied, the installer prompts for the source, package or skill,
  wrapper, and whether to install all or a specific selection.
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
  if [[ -d "$SKILLS_DIR" ]]; then
    while IFS= read -r skill; do
      names+=("$skill")
    done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | sed 's|.*/||' | sort)
  fi
  printf '%s\n' "${names[@]}"
}

install_local_skills() {
  local target_dir="$WORKSHOP_TARGET_DIR/skills"
  mkdir -p "$target_dir"

  local selected=()
  if [[ "$install_all" == true ]]; then
    while IFS= read -r skill; do
      selected+=("$skill")
    done < <(list_local_skills)
  elif [[ ${#skills[@]} -gt 0 ]]; then
    selected=("${skills[@]}")
  else
    selected+=("$(prompt_choice "Select a local skill to install" $(list_local_skills))")
  fi

  if [[ ${#selected[@]} -eq 0 ]]; then
    echo "No local skills selected." >&2
    exit 1
  fi

  echo "Installing local workshop skills into $target_dir"
  for skill in "${selected[@]}"; do
    local source_dir="$SKILLS_DIR/$skill"
    if [[ ! -d "$source_dir" ]]; then
      echo "Local skill not found: $skill" >&2
      exit 1
    fi
    cp -R "$source_dir" "$target_dir/"
    printf 'Installed local skill: %s -> %s/%s\n' "$skill" "$target_dir" "$skill"
  done
}

install_reference_package() {
  local package="$1"
  local wrapper="$2"
  local install_args=("${@:3}")
  local package_dir="$REFERENCES_DIR/$package"
  local install_script="$package_dir/install.sh"

  if [[ ! -d "$package_dir" ]]; then
    echo "Reference package not found: $package" >&2
    exit 1
  fi

  if [[ ! -f "$install_script" ]]; then
    echo "Missing install script for package: $package" >&2
    exit 1
  fi

  if [[ "$wrapper" == "none" ]]; then
    printf 'Installing external reference package: %s (base install)\n' "$package"
    "$install_script" "${install_args[@]}"
    return
  fi

  local wrapper_script="$package_dir/wrappers/${wrapper}.sh"
  if [[ ! -f "$wrapper_script" ]]; then
    echo "Missing wrapper script for $wrapper on package $package" >&2
    exit 1
  fi

  printf 'Installing external reference package: %s using %s wrapper\n' "$package" "$wrapper"
  "$wrapper_script" "${install_args[@]}"
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
  echo "AI Workshop install selector"
  source="$(prompt_choice "Choose an install source" "external reference package" "local workshop skill")"

  if [[ "$source" == "external reference package" ]]; then
    package="$(prompt_choice "Select a reference package" $(list_reference_packages))"
    wrapper="$(prompt_choice "Select a wrapper" "none" "copilot" "claude" "codex" "cursor")"
    echo "Install all skills in this package or choose specific skills?"
    local choice
    choice="$(prompt_choice "Install scope" "all" "specific")"
    if [[ "$choice" == "all" ]]; then
      install_all=true
    else
      install_all=false
      echo "The package installer handles specific skill choices itself, so this interactive mode will default to the package's supported install behavior."
      install_all=true
    fi
  else
    wrapper="$(prompt_choice "Select a wrapper target for the local skill installation" "none" "copilot" "claude" "codex" "cursor")"
    local skill_name="$(prompt_choice "Select a local skill" $(list_local_skills))"
    skills=("$skill_name")
    install_all=false
  fi
fi

if [[ "$source" == "external reference package" || "$source" == "external" ]]; then
  if [[ -z "$package" ]]; then
    echo "A reference package is required for external installs." >&2
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

  install_args=()
  if [[ "$install_all" == true ]]; then
    install_args=(--all)
  elif [[ ${#skills[@]} -gt 0 ]]; then
    for skill_name in "${skills[@]}"; do
      install_args+=(--skill "$skill_name")
    done
  else
    install_args=(--all)
  fi

  install_reference_package "$package" "$wrapper" "${install_args[@]}"
  exit 0
fi

if [[ "$source" == "local workshop skill" || "$source" == "local" ]]; then
  if [[ "$install_all" == false && ${#skills[@]} -eq 0 ]]; then
    if [[ -n "$(list_local_skills)" ]]; then
      skills=("$(prompt_choice "Choose a local skill to install" $(list_local_skills))")
    else
      echo "No local skills are available in $SKILLS_DIR" >&2
      exit 1
    fi
  fi

  if [[ "$wrapper" == "none" ]]; then
    echo "Local skill installation target: $WORKSHOP_TARGET_DIR/skills"
  else
    echo "Local skill installation target: $WORKSHOP_TARGET_DIR/skills (wrapper hint: $wrapper)"
  fi
  install_local_skills
  exit 0
fi

echo "Unsupported install source: $source" >&2
show_help >&2
exit 1
