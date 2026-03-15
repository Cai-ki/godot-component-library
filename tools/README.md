# Tools

## `sync_godot_skill.sh`

Purpose:
- Keep `.agents/skills/godot-development` aligned with `.claude/skills/godot-development`.

Usage:
```bash
# sync from .claude -> .agents
tools/sync_godot_skill.sh

# check whether both trees are identical
tools/sync_godot_skill.sh check
```

## `docs_consistency_check.sh`

Purpose:
- Validate core documentation metadata consistency between `README.md` and `AGENTS.md`.

Checks:
- Component count text matches actual `components/` directory count.
- Theme switch list uses the 5-theme set.
- Overlay component names are present in both docs.

Usage:
```bash
tools/docs_consistency_check.sh
```

## `smoke_check.sh`

Purpose:
- Run a fast local quality gate before commit/push.

Steps:
- Skill sync consistency check.
- Docs consistency check.
- Optional Godot headless startup probe.

Usage:
```bash
tools/smoke_check.sh

# skip Godot probe
SKIP_GODOT_PROBE=1 tools/smoke_check.sh
```
