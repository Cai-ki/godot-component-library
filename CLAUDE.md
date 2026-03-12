# Component Library — CLAUDE.md

## Project Overview

Godot 4.6 UI 组件库，包含 14 个独立可复用组件 + 12 页交互式展示应用。
Dark Indigo 设计系统，目标是超越 Godot 原生 UI 风格，尽可能接近 HTML/CSS 的设计效果。

## Tech Stack

- **Engine**: Godot 4.6.1 (GL Compatibility renderer)
- **Language**: GDScript (静态类型，class_name, @export)
- **Viewport**: 1440×900, canvas_items stretch, expand aspect

## Project Structure

```
project.godot
scenes/main.tscn              <- 入口场景，仅挂载 scripts/main.gd
scripts/
  theme.gd                    <- UITheme: 设计令牌（颜色/间距/圆角/字号）
  helpers.gd                  <- UI: 静态工厂函数（style/button/card/badge/alert/progress）
  main.gd                     <- 主场景：侧边栏导航 + 内容区路由
  pages/                      <- 12 个展示页面（每页一个 class_name, extends RefCounted）
components/                   <- 14 个独立组件（每个组件一个子目录）
  button/ui_button.gd         <- UIButton (extends Button)
  card/ui_card.gd             <- UICard (extends PanelContainer)
  input/ui_input.gd           <- UIInput (extends VBoxContainer)
  badge/ui_badge.gd           <- UIBadge (extends PanelContainer)
  alert/ui_alert.gd           <- UIAlert (extends Control)
  progress/ui_progress.gd     <- UIProgress (extends Control)
  modal/ui_modal.gd           <- UIModal (extends Control)
  tabs/ui_tabs.gd             <- UITabs (extends VBoxContainer)
  accordion/ui_accordion.gd   <- UIAccordion (extends VBoxContainer)
  avatar/ui_avatar.gd         <- UIAvatar (extends Control, _draw)
  divider/ui_divider.gd       <- UIDivider (extends Control, _draw)
  tag/ui_tag.gd               <- UITag (extends PanelContainer)
  skeleton/ui_skeleton.gd     <- UISkeletonLoader (extends PanelContainer)
  table/ui_table.gd           <- UITable (extends VBoxContainer)
```

## Architecture Patterns

### Design System (theme.gd)
- `class_name UITheme` — 所有设计令牌用 `static var` (颜色) 和 `const` (数值)
- 颜色层级: BG → SURFACE_1 → SURFACE_2 → SURFACE_3 → SURFACE_4
- 每种状态色有 4 个变体: BASE / DARK / LIGHT / SOFT
- 引用方式: `UITheme.PRIMARY`, `UITheme.RADIUS_MD`, `UITheme.FONT_SM`

### Helper Functions (helpers.gd)
- `class_name UI` — 全部为 `static func`
- `UI.style(bg, radius, bw, bc, shadow, ...)` — StyleBoxFlat 工厂，最核心的函数
- `UI.solid_btn() / outline_btn() / soft_btn() / ghost_btn()` — 按钮工厂
- `UI.card() / badge() / outline_badge() / soft_badge()` — 容器工厂
- `UI.styled_input() / progress_bar() / alert()` — 组件工厂
- `UI.hbox() / vbox() / spacer() / h_expand() / sep()` — 布局工具
- `UI.page_header() / section() / label()` — 页面结构

### Standalone Components (components/)
- 每个组件用 `class_name` 全局注册，可直接 `UIButton.new()` 实例化
- 使用 `@export` 暴露属性，支持编辑器 Inspector 配置
- 属性 setter 带 `if is_inside_tree(): _apply_styles()` 守卫，确保运行时和编辑器均可刷新
- 组件仅依赖 `UITheme`，不依赖 `UI` helpers
- 导入其他项目: 复制 `components/{name}/` + `scripts/theme.gd`

### Showcase Pages (scripts/pages/)
- 每个页面: `class_name XxxPage extends RefCounted`
- 入口方法: `func build(parent: Control) -> void`
- 由 `main.gd._navigate_to()` 通过 `match page_id` 调用
- 侧边栏分 3 个分区: COMPONENTS / INTERACTIVE / DESIGN

## Styling Approach

所有样式通过代码实现，**不使用** .tres Theme 资源文件:
```gdscript
# 核心模式: StyleBoxFlat + add_theme_*_override
var style := StyleBoxFlat.new()
style.bg_color = UITheme.SURFACE_2
style.corner_radius_top_left = UITheme.RADIUS_MD
# ... 设置 border/shadow/content_margin
node.add_theme_stylebox_override("panel", style)

# 按钮三态: normal / hover / pressed
btn.add_theme_stylebox_override("normal", normal_style)
btn.add_theme_stylebox_override("hover", hover_style)
btn.add_theme_stylebox_override("pressed", pressed_style)

# Hover 效果(非按钮): mouse_entered/mouse_exited 信号
panel.mouse_entered.connect(func(): panel.add_theme_stylebox_override("panel", hover_s))
panel.mouse_exited.connect(func():  panel.add_theme_stylebox_override("panel", normal_s))
```

## Conventions

- **文件名**: snake_case (`ui_button.gd`)
- **类名**: PascalCase (`UIButton`, `ButtonsPage`)
- **变量**: snake_case, 带类型 (`var speed: float = 10.0`)
- **私有方法/变量**: 前缀下划线 (`_build()`, `_lbl`)
- **未使用参数**: 前缀下划线 (`_bg: Color`)
- **组件基类选择**:
  - 需要自动适配内容尺寸 → 继承 `PanelContainer` 或 `VBoxContainer`
  - 需要自定义绘制 → 继承 `Control` + `_draw()` + `custom_minimum_size`
  - 不要用裸 `Control` 作为需要在容器中布局的组件基类（尺寸不会自动计算）

## Common Pitfalls

1. **新 class_name 脚本首次运行报错**: Godot 需要编辑器扫描才能注册 class_name。先 `launch_editor` 导入项目，再 `run_project`
2. **Container 内子节点 position/size 无效**: 容器会覆盖子控件的定位，用 Size Flags 和 custom_minimum_size 控制
3. **UIModal reparent**: `show_modal()` 会将自身从原父节点移到 `get_tree().root`，必须在 `remove_child` 之前保存 `get_tree()` 引用
4. **StyleBoxFlat 阴影**: 只有一个阴影方向，无法像 CSS box-shadow 那样多层。用 `shadow_color` 设彩色实现发光效果
5. **const 不能引用 static var**: `const S := UITheme` 会报错，因为 UITheme 的颜色是 `static var`。用局部变量或直接写 `UITheme.XXX`

## Running & Testing

```bash
# 通过 MCP 运行
mcp__godot__run_project(projectPath="D:\\workspace\\godot-project\\projects\\component_library")
mcp__godot__get_debug_output()
mcp__godot__stop_project()

# 首次运行或添加新 class_name 后需要先导入
mcp__godot__launch_editor(projectPath="...")  # 等待 8s
mcp__godot__run_project(projectPath="...")
```

## Git

- 仓库在项目根目录 `projects/component_library/`
- `.gitignore` 排除 `.godot/` 目录
- user: caiki <2875028086@qq.com>
- 提交规范: `feat:` / `fix:` 前缀，HEREDOC 传 commit message
