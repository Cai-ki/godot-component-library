# Godot UI Component Library

A production-ready UI component library for **Godot 4.6**, featuring 18 styled components and 15 interactive showcase pages. Built with the **Dark Indigo** design system — all styling is done purely in GDScript code, no `.tres` theme files.

> Goal: Push Godot's native UI as close to HTML/CSS design quality as possible.

## Features

- **18 Standalone Components** — Copy any component folder + `theme.gd` to your project
- **Pure Code Styling** — Every `StyleBoxFlat`, color, and shadow is set via GDScript
- **Dark Indigo Design System** — 5 surface layers, 6 status colors with 4 variants each
- **Interactive Showcase** — 15 pages demonstrating every component with live demos
- **Overlay System** — Toast, Tooltip, and Context Menu use layered `CanvasLayer` architecture
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
| Modal | `UIModal` | Control | Overlay dialog with header/body/footer |
| Tabs | `UITabs` | VBoxContainer | Tab navigation with content panels |
| Accordion | `UIAccordion` | VBoxContainer | Collapsible sections |
| Avatar | `UIAvatar` | Control | Circular avatar with initials and status |
| Divider | `UIDivider` | Control | Horizontal line with optional label |
| Tag | `UITag` | PanelContainer | Removable tag chips |
| Skeleton | `UISkeletonLoader` | PanelContainer | Animated loading placeholder |
| Table | `UITable` | VBoxContainer | Styled data table with headers |
| Toast | `UIToast` | Node | Auto-dismiss notifications (CanvasLayer 100) |
| Tooltip | `UITooltip` | Node | Hover-triggered floating hints (CanvasLayer 101) |
| Context Menu | `UIContextMenu` | Node | Right-click menus with destructive styling (CanvasLayer 102) |
| Pagination | `UIPagination` | HBoxContainer | Page navigation with ellipsis |

## Showcase Pages

**Overview** — Landing page with stats, category browser, and quick start guide

**Components** — Buttons, Cards, Form Inputs, Badges & Tags, Alerts, Progress

**Interactive** — Navigation (Tabs/Accordion), Data & Display (Table/Avatar/Divider/Tag/Skeleton/Context Menu), Modals (Modal/Toast), Form Validation

**Design** — Color Themes (5 palettes + 5 material styles), Shapes, Layouts (12 mini-mockups), Animation Patterns (Fade/Slide/Stagger/Easing/Counter)

## Quick Start

```gdscript
# 1. Copy component folder + theme to your project
#    components/toast/ui_toast.gd
#    scripts/theme.gd

# 2. Use in your scene
var toast := UIToast.new()
add_child(toast)
toast.show_toast("Saved!", UIToast.ToastType.SUCCESS)
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
  helpers.gd                     # UI — static factory functions
  main.gd                        # Sidebar navigation + content routing
  pages/                         # 15 showcase pages (class_name, extends RefCounted)
components/                      # 18 standalone components (one subdirectory each)
```

## Running

Open in Godot 4.6+ and run `scenes/main.tscn`, or via the Godot MCP server:

```
mcp__godot__run_project(projectPath="path/to/component_library")
```

## License

MIT
