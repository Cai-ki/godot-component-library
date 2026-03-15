#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "[smoke] 1/3 skill sync check"
"$ROOT_DIR/tools/sync_godot_skill.sh" check

echo "[smoke] 2/3 docs consistency check"
"$ROOT_DIR/tools/docs_consistency_check.sh"

echo "[smoke] 3/3 godot probe"
if [[ "${SKIP_GODOT_PROBE:-0}" == "1" ]]; then
  echo "[smoke] skipped (SKIP_GODOT_PROBE=1)"
  exit 0
fi

GODOT_BIN=""
for candidate in godot4 godot; do
  if command -v "$candidate" >/dev/null 2>&1; then
    GODOT_BIN="$candidate"
    break
  fi
done

if [[ -z "$GODOT_BIN" ]]; then
  echo "[smoke] skipped (godot binary not found)"
  exit 0
fi

"$GODOT_BIN" --headless --path "$ROOT_DIR" --quit >/dev/null
echo "[smoke] godot headless startup OK"
