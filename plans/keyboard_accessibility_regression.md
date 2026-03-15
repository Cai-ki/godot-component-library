# Keyboard Accessibility Regression Checklist

Last updated: 2026-03-15

## Scope

This checklist covers keyboard behavior regression for:

- `UISelect`
- `UIDropdown`
- `UICommandPalette`
- `UITabs`
- `UIAccordion`
- `UIModal`
- `UIDrawer`

Target pages:

- `inputs` (UISelect)
- `navigation` (UITabs / UIAccordion / UIDropdown)
- `advanced` (UICommandPalette)
- `modals` (UIModal / UIDrawer)
- `scene_settings` (UITabs / UISelect in real scene composition)

## Automated Verification (Done)

1. `tools/smoke_check.sh` passes (skill sync + docs consistency).
2. Project launches via Godot MCP without new GDScript errors.
3. Static input-hook check for target components:
   - `UITabs/UIAccordion/UIModal/UIDrawer/UIDropdown`: `set_process_unhandled_input(true)` present.
4. Fix applied in this round:
   - `UISelect` now enables `set_process_unhandled_input(true)` so `_unhandled_input()` escape path can work reliably.

## Manual Regression Matrix

### Inputs Page (`inputs`)

1. Focus a `UISelect` trigger with `Tab`.
2. Press `Enter` (or `Space`) to open.
3. Press `Down/Up` to move selection highlight.
4. Press `Enter` to select.
5. Re-open and press `Esc` to close.

Expected:

- Dropdown opens and closes without mouse.
- Highlight moves one option per key press.
- `selection_changed` fires once on confirm.
- Focus returns to trigger after `Esc` close.

### Navigation Page (`navigation`) - Tabs

1. Focus a tab button.
2. Press `Right/Left` to switch.
3. Press `Home/End` to jump first/last tab.
4. Press `Enter/Space` on focused tab.

Expected:

- Active tab changes with keyboard.
- Indicator animation tracks active tab.
- Content panel visibility follows active tab.

### Navigation Page (`navigation`) - Accordion

1. Focus an accordion header.
2. Press `Down/Up` to move between headers.
3. Press `Right` to expand focused item.
4. Press `Left` to collapse focused item.
5. Press `Enter/Space` to toggle.

Expected:

- Focus moves only among accordion headers.
- Expand/collapse animation remains smooth.
- No duplicate toggle signals from single key press.

### Navigation Page (`navigation`) - Dropdown

1. Open `UIDropdown` from trigger.
2. Use `Down/Up` to move focus.
3. Press `Enter` to activate item.
4. Re-open and press `Esc` to close.

Expected:

- First item gets initial focus.
- Keyboard activation triggers same callback path as mouse.
- Dropdown closes cleanly with `Esc`.

### Advanced Page (`advanced`) - Command Palette

1. Press `Ctrl+K` (macOS also test `Cmd+K`) to open.
2. Type keyword to filter.
3. Use `Down/Up` through results larger than 8 items.
4. Press `Enter` to execute selected command.
5. Re-open and press `Esc` to close.

Expected:

- Palette toggles reliably.
- Selected row always stays visible when navigating long result lists.
- Selected command executes exactly once.

### Modals Page (`modals`) - Modal/Drawer

1. Open any modal, press `Esc`.
2. Open drawer, press `Esc`.
3. Open drawer and verify close button receives initial focus.

Expected:

- `Esc` closes modal/drawer from keyboard path.
- Close animation and cleanup run once per close.
- Drawer close button is keyboard-focusable after open.

### Scene Settings (`scene_settings`)

1. Navigate tabs with `Left/Right/Home/End`.
2. Open and operate each `UISelect` by keyboard.
3. Press `Esc` while select is open.

Expected:

- Same behavior as showcase pages under nested real-scene layout.
- No focus trap after overlay closes.

## Known Gaps / Follow-ups

1. Sidebar navigation buttons in `scripts/main.gd` intentionally use `focus_mode = Control.FOCUS_NONE`, so full keyboard navigation across page routing is not yet available.
2. Theme demo page contains many `FOCUS_NONE` demo controls; this is currently visual-first and not fully keyboard-first.
3. Date picker keyboard navigation is not part of this baseline and should be tracked as a separate iteration.
