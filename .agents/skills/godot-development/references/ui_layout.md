# Godot UI 布局知识

---

## Control 节点基础

所有 UI 控件继承自 `Control`，有三种尺寸模式：
- **Window Override** — 使用自定义尺寸（手动设置 size）
- **Container Sizing** — 由父容器控制（推荐）
- `custom_minimum_size` — 设置最小尺寸下限，容器会尊重它

---

## 锚点系统 (Anchors)

每个 Control 有 4 个锚点（left/right/top/bottom），值范围 0.0~1.0（相对父节点）。

### 常用锚点预设

| 预设 | 效果 | 代码常量 |
|------|------|----------|
| Full Rect | 填满整个父节点 | `Control.PRESET_FULL_RECT` |
| Top Left | 左上角 | `Control.PRESET_TOP_LEFT` |
| Center | 居中 | `Control.PRESET_CENTER` |
| Top Wide | 顶部水平填充 | `Control.PRESET_TOP_WIDE` |
| Left Wide | 左侧垂直填充 | `Control.PRESET_LEFT_WIDE` |
| Bottom Wide | 底部水平填充 | `Control.PRESET_BOTTOM_WIDE` |
| Right Wide | 右侧垂直填充 | `Control.PRESET_RIGHT_WIDE` |
| Center Top | 顶部居中 | `Control.PRESET_CENTER_TOP` |
| Center Bottom | 底部居中 | `Control.PRESET_CENTER_BOTTOM` |
| Center Left | 左侧居中 | `Control.PRESET_CENTER_LEFT` |
| Center Right | 右侧居中 | `Control.PRESET_CENTER_RIGHT` |

```gdscript
# 代码设置
node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

# 手动居中一个已知尺寸的控件
node.anchor_left   = 0.5; node.anchor_right  = 0.5
node.anchor_top    = 0.5; node.anchor_bottom = 0.5
node.offset_left   = -w / 2; node.offset_right  = w / 2
node.offset_top    = -h / 2; node.offset_bottom = h / 2

# 手动全屏填充
node.anchor_left   = 0.0; node.anchor_right  = 1.0
node.anchor_top    = 0.0; node.anchor_bottom = 1.0
node.offset_left   = 0;   node.offset_right  = 0
node.offset_top    = 0;   node.offset_bottom = 0
```

---

## Grow Direction（生长方向）

控件在锚点变化时向哪个方向生长。

```gdscript
# 水平生长方向
node.grow_horizontal = Control.GROW_DIRECTION_BEGIN   # 向左生长
node.grow_horizontal = Control.GROW_DIRECTION_END     # 向右生长（默认）
node.grow_horizontal = Control.GROW_DIRECTION_BOTH    # 两侧生长（居中效果）

# 垂直生长方向
node.grow_vertical = Control.GROW_DIRECTION_BEGIN     # 向上生长
node.grow_vertical = Control.GROW_DIRECTION_END       # 向下生长（默认）
node.grow_vertical = Control.GROW_DIRECTION_BOTH      # 上下生长（垂直居中）

# 典型用法：居中弹窗
# 锚点设为中心 (0.5, 0.5, 0.5, 0.5)
# grow_horizontal = BOTH, grow_vertical = BOTH
# offset 设为半宽半高的正负值
```

---

## 容器系统

### 核心规则

> **容器内的子控件不能手动设置 position/size**，父容器在每次 resize 时会覆盖它们。
> 只能通过 Size Flags 和 `custom_minimum_size` 影响布局。

### Size Flags

| Flag | 含义 | 值 |
|------|------|-----|
| `SIZE_FILL` | 填满分配给它的区域 | 1 |
| `SIZE_EXPAND` | 占用父容器的额外剩余空间 | 2 |
| `SIZE_EXPAND_FILL` | Expand + Fill（最常用） | 3 |
| `SIZE_SHRINK_BEGIN` | 收缩并靠起始端对齐 | 4 |
| `SIZE_SHRINK_CENTER` | 收缩并居中 | 4 + 0 (CENTER) |
| `SIZE_SHRINK_END` | 收缩并靠末端对齐 | 4 + 1 (END) |

```gdscript
node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
node.size_flags_vertical   = Control.SIZE_SHRINK_CENTER

# SIZE_EXPAND_FILL 的理解：
# - 一个 HBox 有 3 个子节点 A / B / C
# - 只有 B 设了 SIZE_EXPAND_FILL
# - A 和 C 保持最小尺寸，B 占满剩余空间

# stretch_ratio 控制 Expand 权重
node.size_flags_stretch_ratio = 2.0   # 占 2 份 Expand 空间
other.size_flags_stretch_ratio = 1.0  # 占 1 份 Expand 空间
```

### 常用容器

| 容器 | 关键特性 |
|------|----------|
| **HBoxContainer** | 水平排列；`separation` override 控制间距 |
| **VBoxContainer** | 垂直排列；`alignment` 控制对齐 |
| **GridContainer** | 需设置 `columns`；自动换行 |
| **MarginContainer** | 通过 override 设置 `margin_left/right/top/bottom` |
| **CenterContainer** | 子节点保持最小尺寸并居中 |
| **ScrollContainer** | 内部只允许一个直接子节点（通常是 VBoxContainer） |
| **PanelContainer** | 带 StyleBox；子节点受 content_margin 影响 |
| **FlowContainer** | 自动换行，HFlow / VFlow 两种方向 |
| **TabContainer** | 子节点名即 Tab 标题 |

### BoxContainer 对齐方式

```gdscript
# alignment 控制子节点在主轴上的对齐
var vbox := VBoxContainer.new()
vbox.alignment = BoxContainer.ALIGNMENT_BEGIN    # 顶部/左侧（默认）
vbox.alignment = BoxContainer.ALIGNMENT_CENTER   # 居中
vbox.alignment = BoxContainer.ALIGNMENT_END      # 底部/右侧
```

---

## 响应式布局模式

### 模式一：嵌套容器（推荐）
```
Control (Full Rect)
└── HBoxContainer
    ├── VBoxContainer (侧边栏，固定宽或 Expand)
    └── VBoxContainer (内容区，SIZE_EXPAND_FILL)
```

### 模式二：网页式居中卡片
```
PanelContainer (背景)
└── MarginContainer (边距)
    └── CenterContainer
        └── VBoxContainer
            ├── Label (标题)
            └── HBoxContainer (按钮行)
```

### 模式三：底部固定 + 内容滚动
```
Control (Full Rect)
└── VBoxContainer (Full Rect)
    ├── ScrollContainer (SIZE_EXPAND_FILL)  ← 内容区
    │   └── VBoxContainer
    └── HBoxContainer (底部工具栏，固定高度)
```

### 模式四：标签页
```
TabContainer (Full Rect)
├── Control (Tab: "首页")
└── Control (Tab: "设置")
```

### 模式五：固定宽度居中布局（网页常见）
```gdscript
# 类似 CSS 的 max-width + margin: auto
var outer := HBoxContainer.new()
outer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

var left_spacer := Control.new()
left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL

var center_content := VBoxContainer.new()
center_content.custom_minimum_size.x = 800
# 不设 SIZE_EXPAND，保持固定宽度

var right_spacer := Control.new()
right_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL

outer.add_child(left_spacer)
outer.add_child(center_content)
outer.add_child(right_spacer)
```

---

## 焦点与导航

```gdscript
button.focus_mode = Control.FOCUS_NONE   # 本项目组件全部使用 NONE
button.focus_mode = Control.FOCUS_ALL    # 接受所有焦点事件（Tab + 点击）
button.focus_mode = Control.FOCUS_CLICK  # 仅点击获取焦点

button.grab_focus()
button.grab_focus.call_deferred()         # 推荐，避免时序问题
button.has_focus()
button.release_focus()

# 焦点邻居（Tab/方向键导航）
button.focus_neighbor_top = button2.get_path()
button.focus_neighbor_bottom = button3.get_path()
button.focus_next = next_button.get_path()        # Tab 键下一个
button.focus_previous = prev_button.get_path()    # Shift+Tab 上一个
```

---

## 主题与样式

### StyleBoxFlat 完整常用属性

```gdscript
var s := StyleBoxFlat.new()

# 背景
s.bg_color = Color("#1C1F2E")

# 圆角（各角独立设置）
s.corner_radius_top_left     = 8
s.corner_radius_top_right    = 8
s.corner_radius_bottom_left  = 8
s.corner_radius_bottom_right = 8

# 快捷设置所有圆角
s.set_corner_radius_all(8)

# 只设顶部圆角（常见于卡片头部）
s.corner_radius_top_left     = 8
s.corner_radius_top_right    = 8
s.corner_radius_bottom_left  = 0
s.corner_radius_bottom_right = 0

# 边框（各边独立）
s.border_width_top    = 1; s.border_width_bottom = 1
s.border_width_left   = 1; s.border_width_right  = 1
s.border_color = Color("#2A2D3E")

# 只设左边框（Alert / 侧边标记常用）
s.border_width_left = 4
s.border_width_top = 0; s.border_width_bottom = 0; s.border_width_right = 0
s.border_color = Color("#6C63FF")

# 阴影（只有一个方向，用彩色实现发光效果）
s.shadow_size   = 8
s.shadow_color  = Color(0, 0, 0, 0.25)
s.shadow_offset = Vector2(0, 4)     # Vector2.ZERO 表示全方向均匀

# 发光效果（彩色阴影 + 0 偏移）
s.shadow_size   = 12
s.shadow_color  = Color(0.42, 0.39, 1.0, 0.3)   # 紫色发光
s.shadow_offset = Vector2.ZERO

# 内边距（影响子节点位置）
s.content_margin_left   = 16
s.content_margin_right  = 16
s.content_margin_top    = 12
s.content_margin_bottom = 12

# 抗锯齿
s.anti_aliasing = true                # 圆角抗锯齿（默认开启）
s.anti_aliasing_size = 1.0            # 抗锯齿宽度

# 绘制中心（false = 只画边框，不填充背景）
s.draw_center = true                  # 默认 true
```

### StyleBoxEmpty（无样式）

```gdscript
# 用于清除默认样式
var empty := StyleBoxEmpty.new()
btn.add_theme_stylebox_override("focus", empty)   # 移除焦点框
```

### 应用样式

```gdscript
# PanelContainer
panel.add_theme_stylebox_override("panel", style)

# Button 三态
btn.add_theme_stylebox_override("normal",   normal_style)
btn.add_theme_stylebox_override("hover",    hover_style)
btn.add_theme_stylebox_override("pressed",  pressed_style)
btn.add_theme_stylebox_override("focus",    normal_style)  # 通常同 normal
btn.add_theme_stylebox_override("disabled", disabled_style)

# LineEdit 三态
input.add_theme_stylebox_override("normal",    n_style)
input.add_theme_stylebox_override("focus",     f_style)
input.add_theme_stylebox_override("read_only", ro_style)
```

---

## add_theme_*_override 完整速查

### Button

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"normal"` / `"hover"` / `"pressed"` / `"focus"` / `"disabled"` | StyleBoxFlat | 各状态背景 |
| `"font_color"` | Color | 默认文字色 |
| `"font_hover_color"` | Color | hover 文字色 |
| `"font_pressed_color"` | Color | pressed 文字色 |
| `"font_disabled_color"` | Color | disabled 文字色 |
| `"font_focus_color"` | Color | 焦点文字色 |
| `"font_size"` | int | 字号 |
| `"icon_color"` | Color | 图标颜色 |
| `"icon_max_width"` | int | 图标最大宽度 |
| `"h_separation"` | int | 图标和文字之间的间距 |
| `"outline_size"` | int | 文字描边大小 |
| `"font_outline_color"` | Color | 文字描边颜色 |

### Label

| override 名 | 类型 |
|-------------|------|
| `"font_color"` | Color |
| `"font_size"` | int |
| `"font_shadow_color"` | Color |
| `"shadow_offset_x"` / `"shadow_offset_y"` | int |
| `"outline_size"` | int |
| `"font_outline_color"` | Color |
| `"line_spacing"` | int |

### PanelContainer

| override 名 | 类型 |
|-------------|------|
| `"panel"` | StyleBoxFlat |

### LineEdit

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"normal"` / `"focus"` / `"read_only"` | StyleBoxFlat | 各状态背景 |
| `"font_color"` | Color | 输入文字色 |
| `"font_placeholder_color"` | Color | 占位符色 |
| `"caret_color"` | Color | 光标色 |
| `"selection_color"` | Color | 选中背景色 |
| `"font_size"` | int | 字号 |
| `"font_uneditable_color"` | Color | 不可编辑时文字色 |
| `"minimum_character_width"` | int | 最小字符宽度 |

### TextEdit

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"normal"` / `"focus"` / `"read_only"` | StyleBoxFlat | 各状态背景 |
| `"font_color"` | Color | 文字色 |
| `"font_placeholder_color"` | Color | 占位符色 |
| `"caret_color"` | Color | 光标色 |
| `"selection_color"` | Color | 选中背景色 |
| `"current_line_color"` | Color | 当前行高亮色 |
| `"font_size"` | int | 字号 |
| `"line_spacing"` | int | 行间距 |

### HBoxContainer / VBoxContainer

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"separation"` | int | 子节点间距 |

### GridContainer

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"h_separation"` | int | 水平间距 |
| `"v_separation"` | int | 垂直间距 |

### MarginContainer

| override 名 | 类型 |
|-------------|------|
| `"margin_left"` / `"margin_right"` / `"margin_top"` / `"margin_bottom"` | int |

### TabContainer

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"tab_selected"` | StyleBoxFlat | 选中标签样式 |
| `"tab_unselected"` | StyleBoxFlat | 未选中标签样式 |
| `"tab_hovered"` | StyleBoxFlat | 悬停标签样式 |
| `"tab_disabled"` | StyleBoxFlat | 禁用标签样式 |
| `"tab_focus"` | StyleBoxFlat | 焦点标签样式 |
| `"panel"` | StyleBoxFlat | 内容区面板样式 |
| `"font_selected_color"` | Color | 选中标签文字色 |
| `"font_unselected_color"` | Color | 未选中标签文字色 |
| `"font_hovered_color"` | Color | 悬停标签文字色 |
| `"font_disabled_color"` | Color | 禁用标签文字色 |
| `"font_size"` | int | 标签字号 |
| `"icon_max_width"` | int | 图标最大宽度 |
| `"icon_separation"` | int | 图标与文字间距 |
| `"h_separation"` | int | 标签之间的间距 |

### ScrollContainer

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"panel"` | StyleBoxFlat | 滚动区域背景 |

```gdscript
# ScrollContainer 常用配置
var scroll := ScrollContainer.new()
scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL

# 滚动模式
scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
# SCROLL_MODE_DISABLED    — 禁用滚动
# SCROLL_MODE_AUTO        — 内容超出时自动显示滚动条
# SCROLL_MODE_SHOW_ALWAYS — 始终显示滚动条
# SCROLL_MODE_SHOW_NEVER  — 隐藏滚动条但仍可滚动

# 滚动条样式
var vbar := scroll.get_v_scroll_bar()
var grabber := StyleBoxFlat.new()
grabber.bg_color = Color(1, 1, 1, 0.15)
grabber.set_corner_radius_all(4)
vbar.add_theme_stylebox_override("grabber", grabber)
vbar.add_theme_stylebox_override("grabber_highlight", grabber)  # hover
vbar.add_theme_stylebox_override("grabber_pressed", grabber)

# 滚动条背景（轨道）
var scroll_bg := StyleBoxFlat.new()
scroll_bg.bg_color = Color.TRANSPARENT
vbar.add_theme_stylebox_override("scroll", scroll_bg)

# 滚动到指定位置
scroll.scroll_vertical = 0                     # 滚到顶部
scroll.scroll_vertical = 9999                  # 滚到底部
scroll.ensure_control_visible(child_node)      # 滚动直到子节点可见
```

### ProgressBar

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"background"` | StyleBoxFlat | 背景轨道样式 |
| `"fill"` | StyleBoxFlat | 填充条样式 |
| `"font_color"` | Color | 百分比文字色 |
| `"font_size"` | int | 字号 |
| `"font_outline_color"` | Color | 文字描边色 |
| `"outline_size"` | int | 描边大小 |

### HSlider / VSlider

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"slider"` | StyleBoxFlat | 滑块轨道背景 |
| `"grabber_area"` | StyleBoxFlat | 已填充区域 |
| `"grabber_area_highlight"` | StyleBoxFlat | 拖动时已填充区域 |

### CheckBox / CheckButton

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"normal"` / `"hover"` / `"pressed"` / `"disabled"` | StyleBoxFlat | 按钮区域样式 |
| `"font_color"` | Color | 文字色 |
| `"font_hover_color"` | Color | hover 文字色 |
| `"font_pressed_color"` | Color | pressed 文字色 |
| `"font_size"` | int | 字号 |
| `"h_separation"` | int | 图标和文字之间的间距 |
| `"check_v_offset"` | int | 复选框垂直偏移 |

### RichTextLabel

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"normal"` | StyleBoxFlat | 背景面板样式 |
| `"focus"` | StyleBoxFlat | 焦点样式 |
| `"default_color"` | Color | 默认文字色 |
| `"font_selected_color"` | Color | 选中文字色 |
| `"selection_color"` | Color | 选中背景色 |
| `"font_size"` | int | 字号 |
| `"normal_font_size"` | int | 正文字号 |
| `"bold_font_size"` | int | 粗体字号 |
| `"line_separation"` | int | 行间距 |
| `"table_h_separation"` | int | 表格水平间距 |
| `"table_v_separation"` | int | 表格垂直间距 |

### HSeparator / VSeparator

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"separator"` | StyleBoxFlat | 分隔线样式 |
| `"separation"` | int | 分隔线上下/左右的空间 |

---

## Hover 效果实现模式

```gdscript
# 模式一：信号 + StyleBox 切换（非 Button 控件）
var normal_s := StyleBoxFlat.new()
normal_s.bg_color = UITheme.SURFACE_2
var hover_s := StyleBoxFlat.new()
hover_s.bg_color = UITheme.SURFACE_3

panel.add_theme_stylebox_override("panel", normal_s)
panel.mouse_entered.connect(func():
    panel.add_theme_stylebox_override("panel", hover_s)
)
panel.mouse_exited.connect(func():
    panel.add_theme_stylebox_override("panel", normal_s)
)

# 模式二：Button 三态样式（推荐用于可点击元素）
btn.add_theme_stylebox_override("normal", normal_s)
btn.add_theme_stylebox_override("hover", hover_s)
btn.add_theme_stylebox_override("pressed", pressed_s)

# 模式三：modulate 变化（简单但粗糙）
panel.mouse_entered.connect(func(): panel.modulate = Color(1.2, 1.2, 1.2))
panel.mouse_exited.connect(func(): panel.modulate = Color.WHITE)
```

---

## 设计原则

### 核心规则
1. 根 Control 必须设置 Full Rect
2. 优先使用容器自动布局，不手动设 position
3. 设置 `custom_minimum_size` 防止布局崩溃
4. 理解 Expand vs Fill 的区别
5. PanelContainer 的 content_margin 影响子节点位置

### 常见错误
- ❌ 在容器内 `node.position = Vector2(x, y)`（会被容器覆盖）
- ❌ 不设置 `size_flags_horizontal = SIZE_EXPAND_FILL` 导致控件不撑开
- ❌ `custom_minimum_size` 忘记设置导致空节点不占空间
- ❌ `UI.card()` 返回的是内部 VBoxContainer，别再对它的父节点重设 SIZE_EXPAND_FILL
- ❌ ScrollContainer 内放了多个直接子节点（只应放一个）
- ❌ 在 CenterContainer 里设 SIZE_EXPAND_FILL（子节点会变成最小尺寸）
- ❌ 忘记给 ScrollContainer 设 SIZE_EXPAND_FILL 导致高度为 0
- ❌ mouse_filter 默认 STOP 导致纯显示 Label 吞掉鼠标事件

### 调试技巧
- 使用 Remote Scene Tree（运行时）查看实际布局
- 勾选 "Visible Collision Shapes" 查看控件边界
- `print(node.size, node.position)` 检查运行时尺寸
- 设置 `node.modulate = Color.RED` 临时高亮定位问题节点
- 在 ScrollContainer 出问题时，检查内容节点是否设了 SIZE_EXPAND_FILL
