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

```gdscript
# 代码设置
node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

# 手动居中一个已知尺寸的控件
node.anchor_left   = 0.5; node.anchor_right  = 0.5
node.anchor_top    = 0.5; node.anchor_bottom = 0.5
node.offset_left   = -w / 2; node.offset_right  = w / 2
node.offset_top    = -h / 2; node.offset_bottom = h / 2
```

---

## 容器系统

### 核心规则

> **容器内的子控件不能手动设置 position/size**，父容器在每次 resize 时会覆盖它们。
> 只能通过 Size Flags 和 `custom_minimum_size` 影响布局。

### Size Flags

| Flag | 含义 |
|------|------|
| `SIZE_FILL` | 填满分配给它的区域 |
| `SIZE_EXPAND` | 占用父容器的额外剩余空间（推开不展开的控件） |
| `SIZE_EXPAND_FILL` | 两者组合（最常用） |
| `SIZE_SHRINK_BEGIN` | 收缩并靠起始端对齐 |
| `SIZE_SHRINK_CENTER` | 收缩并居中 |
| `SIZE_SHRINK_END` | 收缩并靠末端对齐 |

```gdscript
node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
node.size_flags_vertical   = Control.SIZE_SHRINK_CENTER
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
| **PanelContainer** | 带 StyleBox；子节点受 margin 影响 |
| **FlowContainer** | 自动换行，HFlow / VFlow 两种方向 |

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

---

## 焦点与导航

```gdscript
button.focus_mode = Control.FOCUS_NONE   # 本项目组件全部使用 NONE
button.grab_focus()
button.grab_focus.call_deferred()         # 推荐，避免时序问题
button.has_focus()
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

# 边框（各边独立）
s.border_width_top    = 1; s.border_width_bottom = 1
s.border_width_left   = 1; s.border_width_right  = 1
s.border_color = Color("#2A2D3E")

# 阴影（只有一个方向，用彩色实现发光效果）
s.shadow_size   = 8
s.shadow_color  = Color(0, 0, 0, 0.25)
s.shadow_offset = Vector2(0, 4)     # Vector2.ZERO 表示全方向均匀

# 内边距（影响子节点位置）
s.content_margin_left   = 16
s.content_margin_right  = 16
s.content_margin_top    = 12
s.content_margin_bottom = 12
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

## add_theme_*_override 速查

### Button

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"normal"` / `"hover"` / `"pressed"` / `"focus"` / `"disabled"` | StyleBoxFlat | 各状态背景 |
| `"font_color"` | Color | 默认文字色 |
| `"font_hover_color"` | Color | hover 文字色 |
| `"font_pressed_color"` | Color | pressed 文字色 |
| `"font_disabled_color"` | Color | disabled 文字色 |
| `"font_size"` | int | 字号 |
| `"icon_color"` | Color | 图标颜色 |

### Label

| override 名 | 类型 |
|-------------|------|
| `"font_color"` | Color |
| `"font_size"` | int |
| `"font_shadow_color"` | Color |
| `"shadow_offset_x"` / `"shadow_offset_y"` | int |

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

### HBoxContainer / VBoxContainer

| override 名 | 类型 | 说明 |
|-------------|------|------|
| `"separation"` | int | 子节点间距 |

### MarginContainer

| override 名 | 类型 |
|-------------|------|
| `"margin_left"` / `"margin_right"` / `"margin_top"` / `"margin_bottom"` | int |

---

## 设计原则

### 核心规则
1. 根 Control 必须设置 Full Rect
2. 优先使用容器自动布局，不手动设 position
3. 设置 `custom_minimum_size` 防止布局崩溃
4. 理解 Expand vs Fill 的区别

### 常见错误
- ❌ 在容器内 `node.position = Vector2(x, y)`
- ❌ 不设置 `size_flags_horizontal = SIZE_EXPAND_FILL` 导致控件不撑开
- ❌ `custom_minimum_size` 忘记设置导致空节点不占空间
- ❌ `UI.card()` 返回的是内部 VBoxContainer，别再对它的父节点重设 SIZE_EXPAND_FILL

### 调试技巧
- 使用 Remote Scene Tree（运行时）查看实际布局
- 勾选 "Visible Collision Shapes" 查看控件边界
- `print(node.size, node.position)` 检查运行时尺寸
