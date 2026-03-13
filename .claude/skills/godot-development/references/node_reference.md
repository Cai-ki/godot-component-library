# Godot 节点类型速查

> 本文档聚焦于 UI 组件库开发所需节点，已移除 3D/物理/音频等无关内容。

---

## 节点生命周期（核心）

### 回调顺序

```
节点进入场景树的完整流程:
1. _init()           → 对象创建（new() 调用时）
2. _enter_tree()     → 进入场景树（父先于子 — 自上而下）
3. _ready()          → 节点及所有子节点就绪（子先于父 — 自下而上）
4. _process(delta)   → 每帧调用（帧率相关）
5. _physics_process  → 每物理步调用（固定间隔）
6. _exit_tree()      → 离开场景树（子先于父）
7. free/queue_free   → 销毁

⚠️ 关键：_ready() 是自下而上的！
子节点的 _ready() 先于父节点的 _ready()
父节点的 _enter_tree() 先于子节点的 _enter_tree()
```

### 图示

```
add_child(parent)
  │
  ├─ parent._enter_tree()        ← 父先
  │    ├─ child_A._enter_tree()  ← 子按添加顺序
  │    │    └─ grandchild._enter_tree()
  │    │         └─ grandchild._ready()   ← 最深的先 ready
  │    └─ child_A._ready()
  │
  ├─ child_B._enter_tree()
  │    └─ child_B._ready()
  │
  └─ parent._ready()            ← 父最后 ready
```

### 各回调用途

| 回调 | 触发时机 | 典型用途 |
|------|----------|---------|
| `_init()` | `new()` 时 | 设置默认值，不要访问场景树 |
| `_enter_tree()` | 加入场景树时 | 获取 `get_tree()`，设置全局引用 |
| `_ready()` | 自身+所有子节点就绪 | 初始化 UI、连接信号、创建子节点 |
| `_process(delta)` | 每帧 | 动画更新、UI 刷新 |
| `_physics_process(delta)` | 每物理步 | 移动逻辑、碰撞检测 |
| `_input(event)` | 所有输入 | 全局快捷键（如 ESC 关闭） |
| `_gui_input(event)` | 控件范围内输入 | 控件交互（拖拽、点击） |
| `_unhandled_input(event)` | GUI 未消费的输入 | 游戏操作逻辑 |
| `_draw()` | 需要绘制时 | 自定义绘制（圆形、线条等） |
| `_exit_tree()` | 离开场景树 | 清理全局引用、断开外部信号 |
| `_notification(what)` | 各种系统通知 | 底层事件响应 |

### _notification 常用通知

```gdscript
func _notification(what: int) -> void:
    match what:
        NOTIFICATION_READY:              # 等同于 _ready()
            pass
        NOTIFICATION_PROCESS:            # 等同于 _process()
            pass
        NOTIFICATION_ENTER_TREE:         # 等同于 _enter_tree()
            pass
        NOTIFICATION_EXIT_TREE:          # 等同于 _exit_tree()
            pass
        NOTIFICATION_PREDELETE:          # 即将被释放（最后的清理机会）
            pass
        NOTIFICATION_RESIZED:            # Control 尺寸改变
            pass
        NOTIFICATION_VISIBILITY_CHANGED: # 可见性改变
            pass
        NOTIFICATION_THEME_CHANGED:      # 主题改变
            pass
        NOTIFICATION_WM_CLOSE_REQUEST:   # 窗口关闭请求
            pass
        NOTIFICATION_FOCUS_ENTER:        # Control 获得焦点
            pass
        NOTIFICATION_FOCUS_EXIT:         # Control 失去焦点
            pass
        NOTIFICATION_MOUSE_ENTER:        # 等同于 mouse_entered 信号
            pass
        NOTIFICATION_MOUSE_EXIT:         # 等同于 mouse_exited 信号
            pass
```

---

## 节点分组 (Groups)

```gdscript
# 添加到分组
node.add_to_group("enemies")
node.add_to_group("ui_refresh")       # 可用于主题切换批量刷新

# 从分组移除
node.remove_from_group("enemies")

# 检查
node.is_in_group("enemies")           # bool

# 获取组中所有节点
var enemies := get_tree().get_nodes_in_group("enemies")

# 调用组中所有节点的方法
get_tree().call_group("enemies", "take_damage", 10)

# 通知组中所有节点
get_tree().notify_group("enemies", Node.NOTIFICATION_PREDELETE)
```

---

## ProcessMode（处理模式）

```gdscript
# 控制节点在暂停时的行为
node.process_mode = Node.PROCESS_MODE_INHERIT    # 继承父节点（默认）
node.process_mode = Node.PROCESS_MODE_PAUSABLE   # 暂停时停止
node.process_mode = Node.PROCESS_MODE_WHEN_PAUSED  # 仅暂停时运行（暂停菜单用）
node.process_mode = Node.PROCESS_MODE_ALWAYS     # 始终运行
node.process_mode = Node.PROCESS_MODE_DISABLED   # 永不运行

# 暂停场景树
get_tree().paused = true
# 此时只有 ALWAYS 和 WHEN_PAUSED 模式的节点继续运行
```

---

## UI 控件与容器（核心）

### 布局容器

| 节点 | 用途 | 关键属性/行为 |
|------|------|--------------|
| **HBoxContainer** | 水平排列子节点 | `separation` 控制间距 |
| **VBoxContainer** | 垂直排列子节点 | `separation`, `alignment` |
| **GridContainer** | 网格布局 | `columns`（列数） |
| **MarginContainer** | 内边距 | `margin_left/right/top/bottom`（通过 override 设置） |
| **PanelContainer** | 带 StyleBox 的面板 | `add_theme_stylebox_override("panel", s)` |
| **CenterContainer** | 子节点居中 | 子节点保持最小尺寸 |
| **ScrollContainer** | 可滚动区域 | 内部只允许一个直接子节点 |
| **TabContainer** | 标签页切换 | 子节点名即 Tab 标题 |
| **SplitContainer** | 可拖动分割 | `split_offset` |
| **AspectRatioContainer** | 保持子节点比例 | `ratio`, `stretch_mode` |
| **FlowContainer** | 自动换行布局 | HFlowContainer / VFlowContainer |
| **SubViewportContainer** | 嵌入 SubViewport | `stretch = true` 自动匹配尺寸 |

> **容器重要原则**：子节点无法手动设置 position/size，由容器控制；通过 Size Flags 和 `custom_minimum_size` 影响布局。

### 容器详细行为

```gdscript
# HBoxContainer / VBoxContainer
var hbox := HBoxContainer.new()
hbox.add_theme_constant_override("separation", 12)   # 子节点间距
hbox.alignment = BoxContainer.ALIGNMENT_CENTER        # 子节点对齐
# ALIGNMENT_BEGIN（默认）/ ALIGNMENT_CENTER / ALIGNMENT_END

# GridContainer
var grid := GridContainer.new()
grid.columns = 3                                       # 每行 3 列
grid.add_theme_constant_override("h_separation", 8)   # 水平间距
grid.add_theme_constant_override("v_separation", 8)   # 垂直间距

# MarginContainer
var margin := MarginContainer.new()
margin.add_theme_constant_override("margin_left", 16)
margin.add_theme_constant_override("margin_right", 16)
margin.add_theme_constant_override("margin_top", 12)
margin.add_theme_constant_override("margin_bottom", 12)

# ScrollContainer
var scroll := ScrollContainer.new()
scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED  # 禁用水平滚动
scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO         # 自动显示垂直滚动
# SCROLL_MODE_DISABLED / SCROLL_MODE_AUTO / SCROLL_MODE_SHOW_ALWAYS / SCROLL_MODE_SHOW_NEVER
scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL                  # 通常需要设置
var content := VBoxContainer.new()
scroll.add_child(content)   # ScrollContainer 内只放一个直接子节点

# CenterContainer
var center := CenterContainer.new()
center.use_top_left = false    # false=居中，true=左上角（默认 false）

# FlowContainer（自动换行）
var flow := HFlowContainer.new()
flow.add_theme_constant_override("h_separation", 8)
flow.add_theme_constant_override("v_separation", 8)
# 子节点超出宽度时自动换行到下一行
```

### 显示控件

| 节点 | 用途 | 常用属性 |
|------|------|----------|
| **Label** | 文本显示 | `text`, `autowrap_mode`, `horizontal_alignment` |
| **RichTextLabel** | 富文本（BBCode） | `bbcode_enabled`, `text` |
| **TextureRect** | 图片显示 | `texture`, `stretch_mode` |
| **ColorRect** | 颜色矩形 | `color`, `custom_minimum_size` |
| **ProgressBar** | 原生进度条 | `value`, `min_value`, `max_value` |

#### Label 详细

```gdscript
var lbl := Label.new()
lbl.text = "Hello World"
lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER   # LEFT / CENTER / RIGHT
lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART        # 智能换行
# AUTOWRAP_OFF / AUTOWRAP_ARBITRARY / AUTOWRAP_WORD / AUTOWRAP_WORD_SMART

lbl.add_theme_font_size_override("font_size", 16)
lbl.add_theme_color_override("font_color", Color.WHITE)

# 文字裁剪（超出部分省略）
lbl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
lbl.clip_text = true                     # 裁剪超出部分

# Label 尺寸
lbl.custom_minimum_size.x = 100          # 最小宽度
lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL   # 自动填充
```

#### RichTextLabel 详细

```gdscript
var rtl := RichTextLabel.new()
rtl.bbcode_enabled = true
rtl.fit_content = true                    # 高度适配内容
rtl.scroll_active = false                 # 禁用内部滚动

# BBCode 标签
rtl.text = "[b]粗体[/b] [i]斜体[/i] [u]下划线[/u]"
rtl.text = "[color=red]红色文字[/color]"
rtl.text = "[font_size=20]大号文字[/font_size]"
rtl.text = "[center]居中[/center]"
rtl.text = "[url=https://example.com]链接[/url]"
rtl.text = "[code]代码[/code]"
rtl.text = "[indent]缩进文本[/indent]"
rtl.text = "[ol]有序列表项[/ol]"
rtl.text = "[ul]无序列表项[/ul]"
rtl.text = "[table=3][cell]A[/cell][cell]B[/cell][cell]C[/cell][/table]"

# 信号
rtl.meta_clicked.connect(func(meta): OS.shell_open(str(meta)))  # URL 点击
```

#### TextureRect 详细

```gdscript
var tex := TextureRect.new()
tex.texture = preload("res://icon.svg")
tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
# STRETCH_SCALE            — 拉伸填满（可能变形）
# STRETCH_TILE             — 平铺
# STRETCH_KEEP             — 保持原始尺寸
# STRETCH_KEEP_CENTERED    — 保持原始尺寸并居中
# STRETCH_KEEP_ASPECT      — 保持比例，左上对齐
# STRETCH_KEEP_ASPECT_CENTERED  — 保持比例，居中（最常用）
# STRETCH_KEEP_ASPECT_COVERED   — 保持比例，裁剪以填满

tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE   # 忽略纹理尺寸，使用控件尺寸
# EXPAND_KEEP_SIZE         — 保持纹理尺寸
# EXPAND_IGNORE_SIZE       — 使用控件尺寸（配合 custom_minimum_size）
# EXPAND_FIT_WIDTH / FIT_HEIGHT / FIT_WIDTH_PROPORTIONAL / FIT_HEIGHT_PROPORTIONAL
```

### 输入控件

| 节点 | 用途 | 关键信号 |
|------|------|----------|
| **Button** | 按钮 | `pressed`, `toggled(bool)` |
| **CheckBox** | 复选框 | `toggled(bool)` |
| **CheckButton** | 开关按钮 | `toggled(bool)` |
| **LineEdit** | 单行输入 | `text_changed(text)`, `text_submitted(text)` |
| **TextEdit** | 多行输入 | `text_changed()` |
| **HSlider / VSlider** | 滑块 | `value_changed(value)` |
| **SpinBox** | 数字输入 | `value_changed(value)` |
| **OptionButton** | 下拉选择 | `item_selected(index)` |

#### Button 详细

```gdscript
var btn := Button.new()
btn.text = "Click Me"
btn.icon = preload("res://icon.svg")    # 可选图标
btn.flat = true                          # 无背景按钮
btn.disabled = false
btn.toggle_mode = false                  # true = 可切换状态

btn.focus_mode = Control.FOCUS_NONE      # 禁用焦点（UI 组件库通用）
btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND  # 手形光标

# 按钮内容对齐
btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
btn.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT

# 信号
btn.pressed.connect(func(): print("clicked"))
btn.toggled.connect(func(on: bool): print(on))   # toggle_mode 时
btn.button_down.connect(func(): print("down"))    # 按下瞬间
btn.button_up.connect(func(): print("up"))        # 释放瞬间

# 样式 override（详见 ui_layout.md）
btn.add_theme_stylebox_override("normal", style)
btn.add_theme_stylebox_override("hover", hover_style)
btn.add_theme_stylebox_override("pressed", pressed_style)
btn.add_theme_color_override("font_color", Color.WHITE)
btn.add_theme_font_size_override("font_size", 14)
```

#### LineEdit 详细

```gdscript
var input := LineEdit.new()
input.placeholder_text = "Enter name..."
input.text = ""
input.max_length = 50                     # 最大字符数，0 = 无限制
input.editable = true                     # false = 只读
input.secret = true                       # 密码模式（显示 *）
input.clear_button_enabled = true         # 显示清除按钮
input.select_all_on_focus = true          # 聚焦时全选

input.focus_mode = Control.FOCUS_ALL      # 输入框需要焦点

# 信号
input.text_changed.connect(func(new_text: String): pass)
input.text_submitted.connect(func(submitted_text: String): pass)  # 按回车
input.focus_entered.connect(func(): pass)
input.focus_exited.connect(func(): pass)
```

### 弹出/菜单

| 节点 | 用途 |
|------|------|
| **PopupMenu** | 弹出菜单（原生） |
| **Popup** | 弹出窗口基类 |
| **Window** | 独立窗口 |

### 分隔与占位

| 节点 | 用途 |
|------|------|
| **HSeparator / VSeparator** | 水平/垂直原生分割线 |
| **Control**（空） | 占位 / 弹性空间 |

```gdscript
# 弹性空间（推开两侧元素）
var spacer := Control.new()
spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
hbox.add_child(spacer)

# 固定尺寸占位
var gap := Control.new()
gap.custom_minimum_size = Vector2(20, 0)
hbox.add_child(gap)
```

---

## 2D 节点（UI 库相关）

| 节点 | 用途 | 备注 |
|------|------|------|
| **CanvasLayer** | 独立渲染层，不受摄像机影响 | Overlay 组件必用，`layer` 属性控制层级 |
| **Node2D** | 2D 变换基类（位置/旋转/缩放） | |
| **ColorRect** | 颜色矩形（也是 Control） | 可用于遮罩层 |
| **Node** | 纯逻辑节点，无视觉 | Overlay 组件（UIToast/UITooltip/UIContextMenu）继承此类 |

---

## 工具节点

| 节点 | 用途 | 常用方法 |
|------|------|----------|
| **Timer** | 定时器 | `start()`, `stop()`, `timeout` 信号；`one_shot = true` 单次 |
| **Tween** | 补间动画 | 通过 `node.create_tween()` 创建，见 gdscript_cheatsheet |

---

## Control 基类重要属性

```gdscript
# 可见性
node.visible = true / false
node.show() / node.hide()
node.modulate = Color(1, 1, 1, 0.5)     # 半透明（影响子节点）
node.self_modulate = Color.RED            # 仅自身（不影响子节点）

# 鼠标过滤
node.mouse_filter = Control.MOUSE_FILTER_STOP    # 消费鼠标事件（默认）
node.mouse_filter = Control.MOUSE_FILTER_PASS    # 接收但不阻止传播
node.mouse_filter = Control.MOUSE_FILTER_IGNORE  # 完全忽略鼠标（穿透）
# ⚠️ 遮罩层/背景通常用 STOP 拦截点击
# ⚠️ 纯显示元素（Label 等）设 IGNORE 避免阻挡父节点

# 鼠标光标
node.mouse_default_cursor_shape = Control.CURSOR_ARROW          # 默认箭头
node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND  # 手形（可点击）
node.mouse_default_cursor_shape = Control.CURSOR_IBEAM          # 文本光标
node.mouse_default_cursor_shape = Control.CURSOR_MOVE           # 移动十字
node.mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN      # 禁止

# 尺寸
node.custom_minimum_size = Vector2(100, 50)   # 最小尺寸
node.size                                       # 当前实际尺寸（只读）
node.position                                   # 相对父节点位置（容器内被覆盖）
node.global_position                            # 全局位置

# 裁剪
node.clip_contents = true                       # 裁剪超出范围的子节点

# 常用信号
node.resized.connect(func(): pass)              # 尺寸变化
node.mouse_entered.connect(func(): pass)        # 鼠标进入
node.mouse_exited.connect(func(): pass)         # 鼠标离开
node.focus_entered.connect(func(): pass)        # 获得焦点
node.focus_exited.connect(func(): pass)         # 失去焦点
node.visibility_changed.connect(func(): pass)   # 可见性变化
node.gui_input.connect(func(event): pass)       # GUI 输入事件
```

---

## 组件基类选择指南

| 场景 | 推荐基类 | 原因 |
|------|----------|------|
| 需要自动适配内容尺寸 | `PanelContainer` 或 `VBoxContainer` | 自动计算 minimum_size |
| 需要自定义绘制 (`_draw()`) | `Control`（设置 `custom_minimum_size`） | 可用 draw_* API |
| 逻辑节点，无视觉（Overlay） | `Node` | 不参与布局，随场景树自动清理 |
| 继承 Button 行为 | `Button` 或 `BaseButton` | 自带 pressed/toggled 信号 |
| 需要背景面板 + 子节点 | `PanelContainer` | 有 StyleBox，子节点受 content_margin |
| 纯垂直排列多个子组件 | `VBoxContainer` | 自动排列，有 separation |
| 纯水平排列 | `HBoxContainer` | 自动排列 |
| **不要用裸 `Control` 做布局容器** | — | 尺寸不自动计算 |

---

## 常用节点组合

### 基础 UI 界面
```
CanvasLayer
└── Control (Full Rect)
    └── VBoxContainer
        ├── Label (标题)
        └── HBoxContainer
            ├── Button (取消)
            └── Button (确认)
```

### 侧边栏 + 内容区
```
Control (Full Rect)
└── HBoxContainer (Full Rect)
    ├── VBoxContainer (侧边栏，固定宽度)
    │   ├── Button (菜单1)
    │   └── Button (菜单2)
    └── VBoxContainer (内容区，SIZE_EXPAND_FILL)
        └── ScrollContainer
            └── VBoxContainer
```

### 可滚动列表
```
ScrollContainer (SIZE_EXPAND_FILL)
└── VBoxContainer
    ├── PanelContainer (项目1)
    └── PanelContainer (项目2)
```

### Overlay 组件（Toast/Tooltip/ContextMenu 模式）
```
[原场景中] Node (UIToast) — 随页面生命周期
    ↓ _ready / show_xxx() 时
[get_tree().root] CanvasLayer (layer=100/101/102)
    └── [动态创建的内容面板]
```

### 卡片列表（带 hoverable）
```
VBoxContainer
├── PanelContainer (card1)
│   └── VBoxContainer
│       ├── Label (标题)
│       └── Label (描述)
├── PanelContainer (card2)
│   └── VBoxContainer
│       └── ...
```

---

## SceneTree 工具方法

```gdscript
var tree := get_tree()

# 场景管理
tree.change_scene_to_file("res://main.tscn")           # 切换场景
tree.change_scene_to_packed(preloaded_scene)             # 用 PackedScene 切换
tree.reload_current_scene()                               # 重载当前场景
tree.root                                                 # 根 Viewport
tree.current_scene                                        # 当前主场景

# 暂停
tree.paused = true / false

# 退出
tree.quit()

# 延迟帧
await tree.process_frame                                  # 等一帧
await tree.physics_frame                                  # 等一个物理帧
await tree.create_timer(1.0).timeout                     # 等 N 秒

# 分组操作
tree.get_nodes_in_group("group_name")                    # Array[Node]
tree.call_group("group_name", "method_name", arg1)
tree.has_group("group_name")                              # bool

# 视口
tree.root.size                                            # 窗口尺寸 Vector2i
```
