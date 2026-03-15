# Keyboard Accessibility Regression Run (Record)

Run date: 2026-03-15  
Commit: `65e6fe5`

## Summary

- Automated checks: PASS
- Engine launch check: PASS
- Manual interactive keyboard verification (GUI operations): NOT EXECUTED in MCP environment

## Environment

- Godot: `4.6.1.stable.official.14d19694e`
- Device/Renderer: `OpenGL API 4.1 Metal - Compatibility - Apple M4`
- Known non-code warning:
  - App userdata path case mismatch (`.../Application Support/Godot/...` vs `.../Application Support/godot/...`)

## Automated Results

1. `tools/smoke_check.sh`: PASS
   - skill sync check: OK
   - docs consistency check: OK
   - godot probe: skipped (local binary not found, expected in this environment)
2. Godot MCP run/stop with debug output: PASS
   - no new GDScript compile/runtime errors
3. Keyboard hook static inspection: PASS
   - `UISelect`: host-level `_unhandled_input` + `set_process_unhandled_input(true)`
   - `UIDropdown`: host-level `_unhandled_input` + `set_process_unhandled_input(true)`
   - `UITabs`: host-level `_unhandled_input` + `set_process_unhandled_input(true)`
   - `UIAccordion`: host-level `_unhandled_input` + `set_process_unhandled_input(true)`
   - `UIModal`: host-level `_unhandled_input` + `set_process_unhandled_input(true)`
   - `UIDrawer`: host-level `_unhandled_input` + `set_process_unhandled_input(true)`
   - `UICommandPalette`: global `_input` + search-box key handler confirmed

## Manual Matrix Status

Reference checklist: `plans/keyboard_accessibility_regression.md`

1. Inputs page (`UISelect`): UNVERIFIED (manual GUI action required)
2. Navigation page (`UITabs`): UNVERIFIED
3. Navigation page (`UIAccordion`): UNVERIFIED
4. Navigation page (`UIDropdown`): UNVERIFIED
5. Advanced page (`UICommandPalette`): UNVERIFIED
6. Modals page (`UIModal`, `UIDrawer`): UNVERIFIED
7. Scene settings (`UITabs`, `UISelect` nested composition): UNVERIFIED

## Notes

This record run is valid for automated/static regression only.  
For full sign-off, execute the manual matrix on real UI input devices (keyboard in running app window) and append PASS/FAIL per item.
