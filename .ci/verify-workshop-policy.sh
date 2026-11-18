#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_root_scripts=(install.sh uninstall.sh list.sh)
for script in "${required_root_scripts[@]}"; do
  if [[ ! -f "$script" ]]; then
    echo "Missing required root script: $script" >&2
    exit 1
  fi
done

package_dirs=()
while IFS= read -r package_dir; do
  package_dirs+=("$package_dir")
done < <(find references -mindepth 1 -maxdepth 1 -type d | sort)
if [[ ${#package_dirs[@]} -eq 0 ]]; then
  echo "No reference packages found under references/." >&2
  exit 1
fi

for package_dir in "${package_dirs[@]}"; do
  install_script="$package_dir/install.sh"
  wrappers_dir="$package_dir/wrappers"

  if [[ ! -f "$install_script" ]]; then
    echo "Missing install script: $install_script" >&2
    exit 1
  fi

  if [[ ! -d "$wrappers_dir" ]]; then
    echo "Missing wrappers directory: $wrappers_dir" >&2
    exit 1
  fi

  wrappers=()
  while IFS= read -r wrapper; do
    wrappers+=("$wrapper")
  done < <(find "$wrappers_dir" -mindepth 1 -maxdepth 1 -type f -name "*.sh" | sort)
  if [[ ${#wrappers[@]} -eq 0 ]]; then
    echo "No wrapper scripts found in: $wrappers_dir" >&2
    exit 1
  fi

  for wrapper in "${wrappers[@]}"; do
    if ! grep -q '"\$TOOL_DIR/install.sh" "\$@"' "$wrapper"; then
      echo "Wrapper does not delegate to package install.sh: $wrapper" >&2
      exit 1
    fi
  done

done

echo "Workshop policy checks complete."
