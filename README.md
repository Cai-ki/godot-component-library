# Godot UI Component Library

A production-ready UI component library for **Godot 4.6**, featuring **28 styled components** and 15 interactive showcase pages. Built with the **Dark Indigo** design system — all styling is done purely in GDScript code, no `.tres` theme files. Supports runtime **theme switching** (Dark Indigo / Light / Midnight).

> Goal: Push Godot's native UI as close to HTML/CSS design quality as possible.

## Features

- **28 Standalone Components** — Copy any component folder + `theme.gd` to your project
- **Pure Code Styling** — Every `StyleBoxFlat`, color, and shadow is set via GDScript
- **Dark Indigo Design System** — 5 surface layers, 6 status colors with 4 variants each
- **Runtime Theme Switching** — Dark Indigo / Light / Midnight, instant full-page rebuild
- **Interactive Showcase** — 15 pages demonstrating every component with live demos
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

## Showcase Pages

**Overview** — Landing page with stats, category browser, and quick start guide

**Components** — Buttons, Cards, Form Inputs (with Radio & custom Slider), Badges & Tags, Alerts, Progress

**Interactive** — Navigation (Tabs/Accordion), Data & Display (Table with filter/sort, Avatar, Divider, Tag, Skeleton, Context Menu), Modals (Modal, Drawer, Toast), Form Validation

**Design** — Color Themes (5 palettes + 5 material styles + live token swatch), Shapes, Layouts, Animations

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
  pages/                         # 15 showcase pages (class_name, extends RefCounted)
components/                      # 28 standalone components (one subdirectory each)
```

## Running

Open in Godot 4.6+ and run `scenes/main.tscn`, or via the Godot MCP server:

```
mcp__godot__run_project(projectPath="path/to/component_library")
```

## License

MIT
