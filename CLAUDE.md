# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Godot 4.6 UI 组件库，包含 **36 个**独立可复用组件 + **20 页**交互式展示应用。
Dark Indigo 设计系统，目标是超越 Godot 原生 UI 风格，尽可能接近 HTML/CSS 的设计效果。
支持运行时三主题切换（Dark Indigo / Light / Midnight）。

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
  theme_presets.gd            <- UIThemePresets: 三主题静态切换函数（dark_indigo/light/midnight）
  helpers.gd                  <- UI: 静态工厂函数（style/button/card/badge/alert/progress）
  main.gd                     <- 主场景：侧边栏导航 + 内容区路由 + 主题切换
  pages/                      <- 20 个展示页面（每页一个 class_name, extends RefCounted）
components/                   <- 36 个独立组件（每个组件一个子目录）
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
- `UI.style_left_border(bg, border_color, bw, radius)` — 左边框样式（用于 alert/compact 变体）
- `UI.solid_btn() / outline_btn() / soft_btn() / ghost_btn()` — 按钮工厂
- `UI.card(parent, pad_h, pad_v, elevation)` — 返回内部 **VBoxContainer**（PanelContainer 已内置 SIZE_EXPAND_FILL，勿再手动赋值）
- `UI.hoverable_card(parent, accent_color)` — 带 mouse_entered/exited 悬停效果的卡片，同样返回内部 VBoxContainer
- `UI.badge() / outline_badge() / soft_badge()` — 角标工厂
- `UI.styled_input() / progress_bar() / alert()` — 组件工厂
- `UI.hbox() / vbox() / spacer() / h_expand() / sep()` — 布局工具
- `UI.page_header() / section() / label()` — 页面结构（`section()` 渲染带 PRIMARY 色竖线的分区标题）

### Standalone Components (components/)
- 每个组件用 `class_name` 全局注册，可直接 `UIButton.new()` 实例化
- 使用 `@export` 暴露属性，支持编辑器 Inspector 配置
- 属性 setter 带 `if is_inside_tree(): _apply_styles()` 守卫，确保运行时和编辑器均可刷新
- 组件仅依赖 `UITheme`，不依赖 `UI` helpers
- 导入其他项目: 复制 `components/{name}/` + `scripts/theme.gd`

**Overlay 组件**（UIToast / UITooltip / UIContextMenu / UISelect / UIDrawer / UIDatePicker / UICommandPalette）共用同一套架构：
- 继承 `Node`（不是 Control，无视觉节点）或 `VBoxContainer`（UISelect）
- 在 `get_tree().root` 按需创建具名 `CanvasLayer`，层级依次为 100 / 101 / 102 / 103 / 104 / 105 / 106
- 内容面板加入该 CanvasLayer，确保渲染在所有 UI 之上
- 组件本身留在原场景树，随页面销毁自动清理

| 组件 | 继承 | CanvasLayer |
|------|------|-------------|
| UIToast | Node | `_UIToastLayer` (100) |
| UITooltip | Node | `_UITooltipLayer` (101) |
| UIContextMenu | Node | `_UIContextMenuLayer` (102) |
| UISelect | VBoxContainer | `_UISelectLayer` (103) |
| UIDrawer | Node | `_UIDrawerLayer` (104) |
| UIDatePicker | VBoxContainer | `_UIDatePickerLayer` (105) |
| UICommandPalette | Node | `_UICommandPaletteLayer` (106) |

### Showcase Pages (scripts/pages/)
- 每个页面: `class_name XxxPage extends RefCounted`
- 入口方法: `func build(parent: Control) -> void`
- 由 `main.gd._navigate_to()` 通过 `match page_id` 调用
- 侧边栏分 5 个分区 + 顶部 Overview 入口:
  - **Overview** (home): 首页，展示统计、分区导览、Recent Additions
  - **COMPONENTS**: Buttons, Cards, Form Inputs, Badges & Tags, Alerts, Progress
  - **INTERACTIVE**: Navigation, Data & Display, Modals, Form Validation
  - **DESIGN**: Themes, Shapes, Layouts, Animations
  - **EXTENDED**: Extended (Breadcrumb/Chip/NotificationBadge/Timeline), Advanced (TreeView/ColorPicker/DatePicker/CommandPalette)
  - **SCENES**: Login Form, Dashboard, Settings

**Cards 页特例**: Cards 页的内容本身就是卡片，若外套 `UI.card()` 会产生同背景色嵌套，
视觉混乱，是唯一合理省略 section 卡片包裹的页面。

**页面 Section 标准结构**（所有分区统一规范）:
```gdscript
# ✅ 正确: section 标签在外，内容包入卡片
UI.section(parent, "Section Title")
var card_v := UI.card(parent, 24, 20)
var row := UI.hbox(card_v, 12)   # 内容加到 card_v，不加到 parent
UI.some_component(row, ...)

# ❌ 错误: 内容直接加到 parent（视觉扁平无层次）
UI.section(parent, "Section Title")
var row := UI.hbox(parent, 12)
```

**组件优先原则**: 在页面 demo 中优先使用现有组件（`UIAvatar.new()`、`UITable.new()` 等），
而非手写等价的 PanelContainer/ColorRect 组合。

**UIModal 特例**: modal 对象本身必须 `parent.add_child(modal)`，不能加到 card_v，
因为 `show_modal()` 会将其 reparent 到 `get_tree().root`。
demo 卡片（说明文字 + 触发按钮）才加到 card_v。

## Styling Approach

所有样式通过代码实现，**不使用** .tres Theme 资源文件:
```gdscript
# 核心模式: StyleBoxFlat + add_theme_*_override
var style := StyleBoxFlat.new()
style.bg_color = UITheme.SURFACE_2
style.corner_radius_top_left = UITheme.RADIUS_MD
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
6. **UI.card() 内部已设 SIZE_EXPAND_FILL**: PanelContainer 在工厂函数内已赋值，勿再通过 `get_parent().get_parent()` 重复赋值
7. **Array 元素类型推断失败**: `var f := array[i]` 在 Variant 数组中会报错，改用 `var f: Array = array[i]` 或 `var f: int = array[i]` 显式声明类型
8. **create_tween() 只在 Node 上可用**: `RefCounted` 无此方法；在页面 (extends RefCounted) 里做动画时，调用被动画的节点自身的 `node.create_tween()` 即可
9. **setter 内调用 _rebuild() 导致 "locked object" 崩溃**: 若 setter 被按钮回调触发，_rebuild() 会 free() 正在执行的按钮（locked）。解法：setter 改用 `_rebuild.call_deferred()`，_rebuild 改用 `remove_child(child) + child.queue_free()` 代替直接 `free()`
10. **GDScript 变量名不能与内建函数同名**: 如 `var snapped := ...` 会触发 WARNING（内建有 `snapped()` 函数）。改用 `new_v` 等无冲突名称
11. **UIDrawer 的 get_body() 在 show_drawer() 之后才有效**: opened 信号内填充内容时先检查 `body.get_child_count() > 0` 避免重复创建
12. **UITable.add_row() 现在调用 _rebuild_body()**: filterable 模式下增量添加不可靠，改为全量重建。大数据量请用 `set_data()` 一次性传入
13. **主题切换后现有页面节点颜色不更新**: `_switch_theme()` 通过重建侧边栏 + `_navigate_to()` 重建页面实现全局刷新，不依赖动态绑定
14. **UIInput/UISelect 属性在 add_child 前赋值无效**: `text` / `selected_index` 等 setter 依赖 `_ready()` 创建的内部控件。若父节点不在场景树中，`_ready()` 不会触发。解法：在最终 `add_child()` 进入场景树后再赋值
15. **UIButton.size 已改名为 button_size**: Godot 4.6 中 `@export var size` 与原生 `Button.size` 冲突报错。统一使用 `btn.button_size = UIButton.Size.MD`
16. **CanvasLayer 具名查找不能用 `&LAYER_NAME`**: `const LAYER_NAME := "..."` 是 String，`child.name == &LAYER_NAME` 中 `&` 只能修饰字面量。应直接写 `child.name == LAYER_NAME`（String 比较）或 `child.name == &"_LayerName"`（StringName 字面量）
17. **整数除法警告用 floori() 代替**: `var k: int = y / 100` 仍会触发 "Integer division" WARNING。改用 `var k: int = floori(y / 100.0)` 明确表达意图并消除警告

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
- 提交规范: `feat:` / `fix:` / `refactor:` / `docs:` 前缀，HEREDOC 传 commit message
