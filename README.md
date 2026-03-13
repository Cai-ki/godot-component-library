# Godot UI Component Library

A production-ready UI component library for **Godot 4.6**, featuring **36 styled components**, **20 interactive showcase pages**, and **3 real-world scene demos** (Login, Dashboard, Settings). Built with the **Dark Indigo** design system — all styling is done purely in GDScript code, no `.tres` theme files. Supports runtime **theme switching** (Dark Indigo / Light / Midnight).

> Goal: Push Godot's native UI as close to HTML/CSS design quality as possible.

## Features

- **36 Standalone Components** — Copy any component folder + `theme.gd` to your project
- **Pure Code Styling** — Every `StyleBoxFlat`, color, and shadow is set via GDScript
- **Dark Indigo Design System** — 5 surface layers, 6 status colors with 4 variants each
- **Runtime Theme Switching** — Dark Indigo / Light / Midnight, instant full-page rebuild
- **Interactive Showcase** — 20 pages demonstrating every component with live demos
- **Real-World Scenes** — Login form, admin dashboard, and settings page built entirely from library components
- **Overlay System** — Toast, Tooltip, Context Menu, Select, and Drawer use layered `CanvasLayer` architecture
- **Zero Dependencies** — Components only depend on `UITheme`, not on each other

## Components

| Component | Class | Base | Description |
|-----------|-------|------|-------------|
| Button | `UIButton` | Button | Solid, outline, soft, ghost variants |
| Card | `UICard` | PanelContainer | Elevation levels with shadow |
| Input | `UIInput` | VBoxContainer | Labeled text field with validation states |
| Badge | `UIBadge` | PanelContainer | Status indicators and labels |
| Alert | `UIAlert` | Control | Info/success/warning/error notifications |
| Progress | `UIProgress` | Control | Linear progress bars |
| Progress Ring | `UIProgressRing` | Control | Circular arc progress indicator |
| Modal | `UIModal` | Control | Overlay dialog with header/body/footer |
| Tabs | `UITabs` | VBoxContainer | Tab navigation with content panels |
| Accordion | `UIAccordion` | VBoxContainer | Collapsible sections |
| Avatar | `UIAvatar` | Control | Circular avatar with initials and status |
| Divider | `UIDivider` | Control | Horizontal/vertical line with optional label |
| Tag | `UITag` | PanelContainer | Removable tag chips |
| Skeleton | `UISkeletonLoader` | PanelContainer | Animated loading placeholder |
| Table | `UITable` | VBoxContainer | Sortable + filterable data table |
| Toast | `UIToast` | Node | Auto-dismiss notifications (CanvasLayer 100) |
| Tooltip | `UITooltip` | Node | Hover-triggered floating hints (CanvasLayer 101) |
| Context Menu | `UIContextMenu` | Node | Right-click menus with destructive styling (CanvasLayer 102) |
| Pagination | `UIPagination` | HBoxContainer | Page navigation with ellipsis |
| Select | `UISelect` | VBoxContainer | Custom dropdown (CanvasLayer 103) |
| Switch | `UISwitch` | Control | Animated toggle switch |
| Checkbox | `UICheckbox` | HBoxContainer | Custom-drawn checkbox |
| Radio | `UIRadio` | HBoxContainer | Custom-drawn radio button |
| Radio Group | `UIRadioGroup` | VBoxContainer | Exclusive selection manager |
| Slider | `UISlider` | Control | Custom-drawn draggable range slider |
| Drawer | `UIDrawer` | Node | Slide-in side panel (CanvasLayer 104) |
| Empty State | `UIEmpty` | VBoxContainer | Placeholder for empty content areas |
| Steps | `UISteps` | VBoxContainer | Wizard step indicator |
| Breadcrumb | `UIBreadcrumb` | HBoxContainer | Path navigation with clickable segments |
| Chip | `UIChip` | PanelContainer | Selectable/filterable tag with toggled state |
| Notification Badge | `UINotificationBadge` | Control | Dot / count overlay for any control |
| Timeline | `UITimeline` | VBoxContainer | Vertical activity feed with icons and timestamps |
| Tree View | `UITreeView` | VBoxContainer | Collapsible tree list (file explorer style) |
| Color Picker | `UIColorPicker` | VBoxContainer | Swatch grid + hex input color selector |
| Date Picker | `UIDatePicker` | VBoxContainer | Calendar overlay date selector (CanvasLayer 105) |
| Command Palette | `UICommandPalette` | Node | Ctrl+K global search overlay (CanvasLayer 106) |

## Showcase Pages

**Overview** — Landing page with stats, category browser, and quick start guide

**Components** — Buttons, Cards, Form Inputs (with Radio & custom Slider), Badges & Tags, Alerts, Progress

**Interactive** — Navigation (Tabs/Accordion), Data & Display (Table with filter/sort, Avatar, Divider, Tag, Skeleton, Context Menu), Modals (Modal, Drawer, Toast), Form Validation

**Design** — Color Themes (5 palettes + 5 material styles + live token swatch), Shapes, Layouts, Animations

**Extended** — Breadcrumb, Chip (selectable + removable variants), Notification Badge (count + dot + interactive), Timeline (activity feed with icons)

**Advanced** — Tree View (file explorer + org chart), Color Picker (live preview + swatch grid), Date Picker (calendar overlay), Command Palette (Ctrl+K with keyboard navigation)

**Scenes** — Login Form (email/password validation + social login), Dashboard (metrics, charts, table, team cards), Settings (tabbed UI with switches, selects, radio groups, profile form)

## Quick Start

```gdscript
# 1. Copy component folder + theme to your project
#    components/drawer/ui_drawer.gd
#    scripts/theme.gd

# 2. Use in your scene
var drawer := UIDrawer.new()
drawer.title_text = "Settings"
add_child(drawer)
drawer.opened.connect(func():
    var body := drawer.get_body()
    if body.get_child_count() > 0: return
    body.add_child(my_settings_panel)
)
open_btn.pressed.connect(drawer.show_drawer)
```

## Theme Switching

```gdscript
# Switch between three built-in themes at runtime
UIThemePresets.apply_light()        # Light mode
UIThemePresets.apply_midnight()     # Deep blue-black
UIThemePresets.apply_dark_indigo()  # Default (Dark Indigo)
```

## Tech Stack

- **Engine**: Godot 4.6.1 (GL Compatibility renderer)
- **Language**: GDScript (static typing, `class_name`, `@export`)
- **Viewport**: 1440×900, `canvas_items` stretch, `expand` aspect
- **Styling**: All via `StyleBoxFlat` + `add_theme_*_override()` — no `.tres` files

## Project Structure

```
project.godot
scenes/main.tscn                 # Entry scene
scripts/
  theme.gd                       # UITheme — design tokens (colors/spacing/radius/fonts)
  theme_presets.gd               # UIThemePresets — runtime theme switching
  helpers.gd                     # UI — static factory functions
  main.gd                        # Sidebar navigation + content routing + theme switcher
  pages/                         # 20 showcase pages (class_name, extends RefCounted)
components/                      # 36 standalone components (one subdirectory each)
```

## AI-Assisted Development

This project was built with [Claude Code](https://claude.ai/code) using the [Godot MCP Server](https://github.com/Coding-Solo/godot-mcp) for direct engine integration — running projects, creating scenes, and inspecting debug output all from the CLI.

## Running

Open in Godot 4.6+ and run `scenes/main.tscn`, or via the Godot MCP server:

```
mcp__godot__run_project(projectPath="path/to/component_library")
```

## Roadmap

### Direction 1 — Missing Common Components ✅ Completed

| Component | Class | Status |
|-----------|-------|--------|
| Breadcrumb | `UIBreadcrumb` | ✅ Done |
| Chip | `UIChip` | ✅ Done |
| Notification Badge | `UINotificationBadge` | ✅ Done |
| Timeline | `UITimeline` | ✅ Done |
| Tree View | `UITreeView` | ✅ Done |
| Color Picker | `UIColorPicker` | ✅ Done |
| Date Picker | `UIDatePicker` | ✅ Done |
| Command Palette | `UICommandPalette` | ✅ Done |

### Direction 2 — Enhance Existing Components

| Component | Improvement |
|-----------|-------------|
| `UITable` | Virtual scroll for large datasets, column resize, multi-row select |
| `UIInput` | Textarea (multiline) mode, character counter, prefix/suffix icon |
| `UIButton` | Icon + text combo, icon-only circular variant |
| `UISelect` | Multi-select mode, search/filter inside dropdown |
| `UIModal` | Size variants (sm / md / lg / fullscreen) |

### Direction 3 — New Demo Scenes

| Scene | Description |
|-------|-------------|
| Chat UI | Message bubbles, input bar, contact list |
| E-commerce | Product cards, cart panel, pricing tags |
| Kanban Board | Column + card layout, drag simulation |
| Analytics | Complex chart mockups, KPI card grid |
| File Manager | List/grid view toggle, breadcrumb navigation |

### Direction 4 — Engineering Quality

| Area | Task |
|------|------|
| Accessibility | Keyboard navigation, consistent `focus_mode` |
| Godot AddOn | Package as `addons/ui_components/` plugin structure |
| Light theme polish | Improve contrast ratios for all components in Light mode |
| Performance | Lazy-build Overview page to reduce first-frame load |

## License

MIT
