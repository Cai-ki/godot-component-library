#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
README_FILE="$ROOT_DIR/README.md"
AGENTS_FILE="$ROOT_DIR/AGENTS.md"

fail() {
  echo "[docs-check] ERROR: $1" >&2
  exit 1
}

[[ -f "$README_FILE" ]] || fail "README.md not found"
[[ -f "$AGENTS_FILE" ]] || fail "AGENTS.md not found"

component_count="$(find "$ROOT_DIR/components" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"

if ! grep -Eq "\\*\\*${component_count} Standalone Components\\*\\*" "$README_FILE"; then
  fail "README.md component count text is out of sync with components/ (${component_count})"
fi

if ! grep -Eq "包含 \\*\\*${component_count} 个\\*\\*" "$AGENTS_FILE"; then
  fail "AGENTS.md component count text is out of sync with components/ (${component_count})"
fi

if ! grep -Eq "Indigo / Slate / Stone / Light / Midnight" "$README_FILE"; then
  fail "README.md theme switch list is not the expected 5-theme set"
fi

if ! grep -Eq "Dark Indigo / Slate / Stone / Light / Midnight" "$AGENTS_FILE"; then
  fail "AGENTS.md theme switch list is not the expected 5-theme set"
fi

overlay_components=(
  "UIToast"
  "UITooltip"
  "UIContextMenu"
  "UISelect"
  "UIDrawer"
  "UIDatePicker"
  "UICommandPalette"
  "UIDropdown"
  "UIPopover"
)

for name in "${overlay_components[@]}"; do
  grep -q "$name" "$README_FILE" || fail "README.md missing overlay component: $name"
  grep -q "$name" "$AGENTS_FILE" || fail "AGENTS.md missing overlay component: $name"
done

echo "[docs-check] OK: docs are consistent"
