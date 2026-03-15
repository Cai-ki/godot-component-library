#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$ROOT_DIR/.claude/skills/godot-development"
DST_DIR="$ROOT_DIR/.agents/skills/godot-development"

MODE="${1:-sync}"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "[sync-skill] source not found: $SRC_DIR" >&2
  exit 1
fi

if [[ "$MODE" == "check" ]]; then
  if diff -rq "$SRC_DIR" "$DST_DIR" >/dev/null; then
    echo "[sync-skill] OK: .agents and .claude godot-development are in sync"
    exit 0
  fi
  echo "[sync-skill] OUT-OF-SYNC: run tools/sync_godot_skill.sh" >&2
  diff -rq "$SRC_DIR" "$DST_DIR" || true
  exit 2
fi

mkdir -p "$DST_DIR"
cp "$SRC_DIR/SKILL.md" "$DST_DIR/SKILL.md"
mkdir -p "$DST_DIR/references"
cp "$SRC_DIR/references/"*.md "$DST_DIR/references/"

echo "[sync-skill] synced from .claude -> .agents"
