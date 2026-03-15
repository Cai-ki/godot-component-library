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
