#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

report_dir="${CI_REPORTS_DIR:-reports}"
mkdir -p "$report_dir"
junit_file="$report_dir/junit-smoke-local.xml"

xml_escape() {
  local value="$1"
  value="${value//&/&amp;}"
  value="${value//</&lt;}"
  value="${value//>/&gt;}"
  printf '%s' "$value"
}

write_junit_report() {
  local status="$1"
  local message="$2"
  local escaped_message
  escaped_message="$(xml_escape "$message")"

  if [[ "$status" -eq 0 ]]; then
    cat >"$junit_file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="local-lifecycle-smoke" tests="1" failures="0">
  <testcase classname="ci.smoke" name="local lifecycle"/>
</testsuite>
EOF
  else
    cat >"$junit_file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<testsuite name="local-lifecycle-smoke" tests="1" failures="1">
  <testcase classname="ci.smoke" name="local lifecycle">
    <failure message="$escaped_message"/>
  </testcase>
</testsuite>
EOF
  fi

  echo "JUnit report written to: $junit_file"
}

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

export AI_WORKSHOP_TARGET_DIR="$tmp_root/workshop-target"
mkdir -p "$AI_WORKSHOP_TARGET_DIR"

skill_name="testing"
status=0
failure_message=""

echo "Smoke test: local install"
if ! ./install.sh --source local --skill "$skill_name"; then
  status=1
  failure_message="local install command failed"
fi

if [[ "$status" -eq 0 && ! -d "$AI_WORKSHOP_TARGET_DIR/skills/$skill_name" ]]; then
  echo "Expected skill directory missing after install: $AI_WORKSHOP_TARGET_DIR/skills/$skill_name" >&2
  status=1
  failure_message="installed skill directory not found"
fi

if [[ "$status" -eq 0 ]]; then
  echo "Smoke test: local list"
  if ! list_output="$(./list.sh --source local)"; then
    status=1
    failure_message="local list command failed"
  else
    echo "$list_output"
    if ! grep -q "$skill_name" <<<"$list_output"; then
      echo "Expected skill not found in list output: $skill_name" >&2
      status=1
      failure_message="installed skill missing from list output"
    fi
  fi
fi

if [[ "$status" -eq 0 ]]; then
  echo "Smoke test: local uninstall"
  if ! ./uninstall.sh --source local --skill "$skill_name"; then
    status=1
    failure_message="local uninstall command failed"
  fi
fi

if [[ "$status" -eq 0 && -d "$AI_WORKSHOP_TARGET_DIR/skills/$skill_name" ]]; then
  echo "Skill directory still exists after uninstall: $AI_WORKSHOP_TARGET_DIR/skills/$skill_name" >&2
  status=1
  failure_message="skill directory still present after uninstall"
fi

write_junit_report "$status" "$failure_message"

if [[ "$status" -ne 0 ]]; then
  exit 1
fi

echo "Local lifecycle smoke test complete."
