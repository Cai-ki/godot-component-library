# Component Library API

> 项目：Godot 4.6 UI 组件库（Dark Indigo 设计系统，1440×900，18 页展示应用）
> 依赖：所有组件仅依赖 `scripts/theme.gd (UITheme)`，不依赖 `UI helpers`
> 导入方式：复制 `components/{name}/` + `scripts/theme.gd` 即可独立使用

---

## UITheme — 设计令牌

`class_name UITheme extends RefCounted`，全部为 `static var`（颜色）和 `const`（数值），直接 `UITheme.XXX` 引用。

> ⚠️ `const` 不能引用 `static var`，必须用局部变量或直接写 `UITheme.XXX`

### 背景层级（越大越亮）

| 令牌 | 值 | 用途 |
|------|----|------|
| `BG` | `#0D0F14` | 页面最底层背景 |
| `SURFACE_1` | `#141720` | 侧边栏 / 次级背景 |
| `SURFACE_2` | `#1C1F2E` | 卡片 / 面板默认背景 |
| `SURFACE_3` | `#252A3A` | hover 状态 / 输入框背景 / 斑马纹 |
| `SURFACE_4` | `#2E3347` | 强调高亮 / Tooltip 背景 |

### 边框颜色

| 令牌 | 值 |
|------|----|
| `BORDER` | `#2A2D3E` |
| `BORDER_LIGHT` | `#353849` |
| `BORDER_STRONG` | `#4A4D60` |

### 品牌色 / 状态色（各有 4 个变体）

| 基础令牌 | BASE | _DARK | _LIGHT | _SOFT（12% alpha） |
|----------|------|-------|--------|-------------------|
| `PRIMARY` | `#6C63FF` | `#5550DD` | `#9B93FF` | 半透明紫 |
| `SECONDARY` | `#4FC3F7` | `#039BE5` | `#81D4FA` | 半透明蓝 |
| `SUCCESS` | `#4ADE80` | `#22C55E` | `#86EFAC` | 半透明绿 |
| `WARNING` | `#FB923C` | `#EA580C` | `#FCA370` | 半透明橙 |
| `DANGER` | `#F87171` | `#EF4444` | `#FCA5A5` | 半透明红 |
| `INFO` | `#60A5FA` | `#3B82F6` | `#93C5FD` | 半透明蓝 |

### 文字颜色

| 令牌 | 值 | 用途 |
|------|----|------|
| `TEXT_PRIMARY` | `#E8E9F3` | 主要文字 |
| `TEXT_SECONDARY` | `#8B90A7` | 次要文字 |
| `TEXT_MUTED` | `#555A72` | 禁用 / 占位符 |
| `TEXT_INVERSE` | `#0D0F14` | 深色背景上的文字 |

### 字号 (const int)

| 令牌 | 值 | | 令牌 | 值 |
|------|----|--|------|----|
| `FONT_XS` | 11 | | `FONT_LG` | 18 |
| `FONT_SM` | 12 | | `FONT_XL` | 20 |
| `FONT_MD` | 14 | | `FONT_2XL` | 24 |
| `FONT_BASE` | 16 | | `FONT_3XL` | 30 |

### 圆角 (const int)

`XS:3  SM:6  MD:8  LG:12  XL:16  PILL:999`

### 间距 (const int)

`SP_1:4  SP_2:8  SP_3:12  SP_4:16  SP_5:20  SP_6:24  SP_8:32  SP_10:40  SP_12:48`

---

## UI Helpers — 工厂函数

`class_name UI extends RefCounted`，全部为 `static func`，无需实例化。

### StyleBox 工厂

```gdscript
# 核心工厂，返回 StyleBoxFlat
UI.style(
    bg: Color,
    radius: int = RADIUS_MD,       # 圆角
    bw: int = 0,                    # 边框宽度
    bc: Color = TRANSPARENT,        # 边框颜色
    shadow: int = 0,                # 阴影大小
    shadow_c: Color = ...,          # 阴影颜色
    shadow_off: Vector2 = ZERO,     # 阴影偏移（ZERO = 下方偏移）
    px: int = 0,                    # 水平内边距
    py: int = 0                     # 垂直内边距
) -> StyleBoxFlat

# 左边框样式（用于 Alert/compact 变体）
UI.style_left_border(bg, border_color, border_width=4, radius=RADIUS_MD) -> StyleBoxFlat
```

### 按钮工厂（返回 Button，已 add_child 到 parent）

```gdscript
UI.solid_btn(parent, text, color, font_color=WHITE, radius=RADIUS_MD, px=20, py=10, font_size=FONT_MD) -> Button
UI.outline_btn(parent, text, color, radius=RADIUS_MD, px=20, py=10, font_size=FONT_MD) -> Button
UI.soft_btn(parent, text, color, radius=RADIUS_MD, px=20, py=10, font_size=FONT_MD) -> Button
UI.ghost_btn(parent, text, color, radius=RADIUS_MD, px=20, py=10, font_size=FONT_MD) -> Button
```

### 布局工具（已 add_child 到 parent）

```gdscript
UI.hbox(parent, gap=12)  -> HBoxContainer
UI.vbox(parent, gap=12)  -> VBoxContainer
UI.spacer(parent, size=SP_4) -> Control      # 固定尺寸空白占位
UI.h_expand(parent)      -> Control          # 水平弹性占位（SIZE_EXPAND_FILL）
UI.sep(parent, margin_v=4) -> void           # BORDER 色 1px 水平分隔线
```

### 标签（⚠️ 不 add_child，需手动加）

```gdscript
UI.label(text, size=FONT_MD, color=TEXT_PRIMARY) -> Label
# 用法：var lbl := UI.label("Hello"); some_container.add_child(lbl)
```

### 页面结构

```gdscript
UI.page_header(parent, title, desc="") -> void
# 渲染：3XL 粗标题 + 可选次标题 + 分隔线

UI.section(parent, title) -> void
# 渲染：SP_4 间距 + PRIMARY 色 3px 竖线 + 小写→大写灰色标题
# 用于分区标题（不含内容）
```

### 卡片（返回内部 VBoxContainer）

```gdscript
UI.card(parent, pad_h=24, pad_v=20, elevation=0) -> VBoxContainer
# ⚠️ PanelContainer 内部已设 SIZE_EXPAND_FILL，勿再重复设置
# ⚠️ 内容加到返回的 VBoxContainer，不加到 parent

UI.hoverable_card(parent, accent_color=PRIMARY, pad_h=24, pad_v=20) -> VBoxContainer
# 带 mouse_entered/exited 悬停效果（SURFACE_3 + 高亮边框）
```

### 角标工厂

```gdscript
UI.badge(parent, text, bg_color, text_color=WHITE, radius=RADIUS_XS, px=10, py=4, font_size=FONT_SM) -> PanelContainer
UI.outline_badge(parent, text, color, radius=RADIUS_XS, px=10, py=4, font_size=FONT_SM) -> PanelContainer
UI.soft_badge(parent, text, color, radius=RADIUS_XS, px=10, py=4, font_size=FONT_SM) -> PanelContainer
```

### 其他组件工厂

```gdscript
UI.styled_input(parent, placeholder="", width=280) -> LineEdit
UI.progress_bar(parent, value=0.5, color=PRIMARY, height=8, radius=RADIUS_SM) -> Control
UI.alert(parent, icon_text, title, desc, color, show_close=false) -> PanelContainer
```

### 页面 Section 标准结构

```gdscript
# ✅ 正确：section 在外，内容包入 card
UI.section(parent, "Section Title")
var card_v := UI.card(parent, 24, 20)
var row := UI.hbox(card_v, 12)          # 内容加到 card_v

# ❌ 错误：内容直接加到 parent（无层次感）
UI.section(parent, "Section Title")
var row := UI.hbox(parent, 12)
```

---

## 组件 API（28 个）

### UIButton `extends Button`

```gdscript
enum Variant     { SOLID, OUTLINE, SOFT, GHOST }
enum ColorScheme { PRIMARY, SECONDARY, SUCCESS, WARNING, DANGER, INFO, NEUTRAL }
enum Size        { XS, SM, MD, LG, XL }

@export var variant: Variant
@export var color_scheme: ColorScheme
@export var size: Size
@export var pill_shape: bool
@export var is_loading: bool   # setter: 禁用按钮并在文字前加 ⟳

func set_loading(v: bool) -> void
```

### UICard `extends PanelContainer`

```gdscript
@export var elevation: int = 0    # 0~3，控制阴影深度
@export var hoverable: bool       # hover 时变 SURFACE_3 + 高亮边框
@export var accent_color: Color   # TRANSPARENT 时用标准边框，否则左边框高亮
@export var pad_h: int = 24
@export var pad_v: int = 20

func get_content() -> VBoxContainer   # 获取内部容器，内容加到这里
```

### UIInput `extends VBoxContainer`

```gdscript
signal text_changed(new_text: String)
signal text_submitted(new_text: String)

enum State { DEFAULT, SUCCESS, ERROR, WARNING }

@export var label_text: String      # 空字符串则隐藏标签
@export var placeholder: String
@export var hint_text: String       # 状态提示（颜色跟随 validation_state）
@export var password: bool
@export var disabled: bool
@export var validation_state: State

var text: String   # get/set 代理到内部 LineEdit

func clear() -> void
func grab_focus_input() -> void
```

### UIBadge `extends PanelContainer`

```gdscript
enum Variant     { FILLED, OUTLINE, SOFT }
enum ColorScheme { PRIMARY, SECONDARY, SUCCESS, WARNING, DANGER, INFO, NEUTRAL }

@export var badge_text: String
@export var variant: Variant
@export var color_scheme: ColorScheme
@export var pill_shape: bool
@export var font_size: int
```

### UIProgress `extends Control`

```gdscript
@export var value: float = 0.5           # [0.0, 1.0]
@export var progress_color: Color        # 默认 PRIMARY
@export var bar_height: int = 8
@export var show_label: bool             # 右侧百分比文字
@export var radius: int                  # 默认 RADIUS_SM

func animate_to(target: float, duration: float = 0.5) -> void
# 使用 EASE_OUT + TRANS_CUBIC 缓动
```

### UITabs `extends VBoxContainer`

```gdscript
signal tab_changed(index: int, name: String)

func add_tab(tab_name: String, content: Control) -> void
func set_active_tab(index: int) -> void
func get_active_tab() -> int
```

### UIAvatar `extends Control`

```gdscript
enum AvatarSize { XS(28), SM(36), MD(44), LG(52), XL(64) }
enum StatusType { NONE, ONLINE, AWAY, BUSY, OFFLINE }

@export var initials: String = "?"   # 最多 2 个字符，自动大写
@export var bg_color: Color          # 头像背景色
@export var avatar_size: AvatarSize
@export var status: StatusType       # 右下角状态点

# extends Control + _draw()，需设置 custom_minimum_size
```

### UISkeletonLoader `extends PanelContainer`

```gdscript
@export var min_width: float = 200.0
@export var min_height: float = 16.0
@export var radius: int               # 默认 RADIUS_SM
@export var animated: bool = true     # SURFACE_3 ↔ SURFACE_4 shimmer 动画
```

### UITable `extends VBoxContainer`

```gdscript
@export var striped: bool = true      # 斑马纹（奇行 SURFACE_3）
@export var show_border: bool = true
@export var sortable: bool = false    # 点击表头排序（▲/▼指示器）
@export var filterable: bool = false  # 顶部搜索框，实时过滤行

func set_columns(cols: PackedStringArray) -> void
func add_row(data: Array) -> void          # 调用 _rebuild_body()，filterable 时正确过滤
func clear_rows() -> void
func set_data(cols: PackedStringArray, rows: Array) -> void   # 一次设置全部（推荐）
```

### UIAlert `extends Control`

```gdscript
signal dismissed
signal action_pressed

enum AlertType { INFO, SUCCESS, WARNING, DANGER }

@export var alert_type: AlertType     # 自动设置图标和颜色
@export var title_text: String
@export var body_text: String         # 空字符串则隐藏
@export var dismissable: bool         # 显示 ✕ 关闭按钮，点击 emit dismissed + queue_free
@export var action_label: String      # 空字符串则隐藏操作按钮
```

### UIAccordion `extends VBoxContainer`

```gdscript
signal item_toggled(index: int, expanded: bool)

@export var allow_multiple: bool = false   # false = 手风琴模式（同时只展开一个）

func add_item(header: String, content: Control, expanded: bool = false) -> int
func expand_item(index: int) -> void
func collapse_item(index: int) -> void
func clear_items() -> void
```

### UIDivider `extends Control`

```gdscript
@export var divider_label: String = ""      # 空 = 纯线条；非空 = 两侧带线的居中文字
@export var divider_color: Color            # 默认 BORDER
@export var thickness: int = 1
@export var vertical: bool = false          # 垂直分割线

# extends Control + _draw()
```

### UIModal `extends Control`

```gdscript
signal closed
signal confirmed

@export var title_text: String
@export var show_close_button: bool = true
@export var dialog_width: float = 480.0

func show_modal() -> void    # ⚠️ 将自身 reparent 到 get_tree().root
func hide_modal() -> void    # 恢复原父节点并 emit closed
func get_body()   -> VBoxContainer    # 内容区
func get_footer() -> HBoxContainer   # 按钮区（默认右对齐）

# ⚠️ modal 对象本身必须 parent.add_child(modal)（不能加到 card_v）
# ⚠️ show_modal() 前必须保存好 get_tree() 引用
```

### UITag `extends PanelContainer`

```gdscript
signal removed(tag_text: String)

@export var tag_text: String
@export var tag_color: Color        # 默认 PRIMARY
@export var removable: bool = true  # 显示 ✕；点击 emit removed + queue_free
@export var pill_shape: bool
```

### UIToast `extends Node`

```gdscript
enum ToastType { INFO, SUCCESS, WARNING, ERROR }

@export var default_duration: float = 3.0

func show_toast(message: String, type: ToastType = INFO, duration: float = -1.0) -> void
# duration < 0 时使用 default_duration
# 自动在 CanvasLayer(100) 显示，淡入 → 等待 → 淡出 → 销毁

# 用法：
var toast := UIToast.new()
parent.add_child(toast)
toast.show_toast("保存成功", UIToast.ToastType.SUCCESS)
```

### UITooltip `extends Node`

```gdscript
@export var tip_text: String
@export_enum("Auto", "Below") var tip_position: int = 0
# Auto: 优先显示在控件上方，空间不足时显示下方
# Below: 强制下方

# 用法：作为任意 Control 的子节点
var tip := UITooltip.new()
tip.tip_text = "这是提示"
my_button.add_child(tip)
# 自动监听父控件的 mouse_entered/exited
```

### UIContextMenu `extends Node`

```gdscript
func add_item(label: String, callback: Callable, destructive: bool = false) -> void
# destructive=true 时文字为红色（DANGER），hover 背景也变红

func add_separator() -> void
func clear() -> void
func show_at(pos: Vector2) -> void        # 在指定全局坐标显示
func attach(target: Control) -> void      # 绑定到控件，右键自动显示

# 用法：
var menu := UIContextMenu.new()
add_child(menu)
menu.add_item("✎  Rename",  func(): _rename())
menu.add_item("◈  Duplicate", func(): _duplicate())
menu.add_separator()
menu.add_item("✕  Delete",  func(): _delete(), true)
menu.attach(my_node)
```

### UIPagination `extends HBoxContainer`

```gdscript
signal page_changed(page: int)

@export var total_pages: int = 1
@export var current_page: int = 1    # setter 触发 _rebuild.call_deferred()
@export var visible_count: int = 5   # 中间区域最多显示的页码按钮数（不含首尾和省略号）

# 设置 total_pages 后直接修改 current_page 即可切换
# 页码计算：1 ... [start~end] ... total_pages，自动添加 ··· 省略号
```

### UISelect `extends VBoxContainer`

```gdscript
signal selection_changed(index: int, value: String)

@export var label_text: String       # 空 = 隐藏标签
@export var placeholder: String = "Select..."
@export var options: PackedStringArray
@export var selected_index: int = -1  # -1 = 无选中
@export var disabled: bool

var selected_value: String   # 只读，返回当前选中项文本

func clear_selection() -> void

# Overlay 模式：CanvasLayer(103) _UISelectLayer
# 点击外部自动关闭，淡入+下滑动画
```

### UISwitch `extends Control`

```gdscript
signal toggled(value: bool)

@export var toggled_on: bool = false   # 滑块动画切换
@export var disabled: bool
@export var accent_color: Color        # 默认 PRIMARY

# extends Control + _draw()
# 44×24 尺寸，圆形滑块 0.2s EASE_OUT 动画
```

### UICheckbox `extends HBoxContainer`

```gdscript
signal toggled(value: bool)

@export var checked: bool = false
@export var label_text: String         # 空 = 隐藏标签
@export var disabled: bool
@export var accent_color: Color        # 默认 PRIMARY

# 内部 Control + _draw() 绘制 20×20 复选框 + ✓
```

### UIProgressRing `extends Control`

```gdscript
@export var value: float = 0.5         # [0.0, 1.0]
@export var progress_color: Color      # 默认 PRIMARY
@export var ring_size: float = 80.0    # 直径（像素）
@export var thickness: float = 6.0     # 环宽
@export var show_label: bool = true    # 中心百分比文字

func animate_to(target: float, duration: float = 0.5) -> void
# extends Control + _draw()，使用 draw_arc() 绘制圆弧
```

### UIEmpty `extends VBoxContainer`

```gdscript
signal action_pressed

@export var icon_text: String = "◇"        # 大号图标/emoji
@export var title_text: String = "No data"
@export var description_text: String       # 空 = 隐藏
@export var action_label: String           # 空 = 隐藏按钮
@export var accent_color: Color            # 操作按钮颜色，默认 PRIMARY
```

### UISteps `extends VBoxContainer`

```gdscript
signal step_clicked(index: int)

@export var steps: PackedStringArray       # 步骤名称列表
@export var current_step: int = 0          # setter 触发 _rebuild.call_deferred()
@export var clickable: bool = false        # 允许点击圆圈跳转

func next_step() -> void
func prev_step() -> void

# 状态：completed (< current) → ✓ 绿色，active (== current) → 数字蓝色，pending → 灰色
# 连接线颜色跟随左侧步骤状态
```

### UIRadio `extends HBoxContainer`

```gdscript
signal toggled(value: bool)   # 仅在 unchecked→checked 时 emit（不 toggle）

@export var checked: bool = false
@export var label_text: String
@export var disabled: bool
@export var accent_color: Color   # 默认 PRIMARY

# 内部 Control + draw_arc() 外圈 + draw_circle() 内点（20×20）
# 点击行为：只能 check，不能 uncheck（由 UIRadioGroup 管理取消）
```

### UIRadioGroup `extends VBoxContainer`

```gdscript
signal selection_changed(index: int)

@export var selected_index: int = -1   # setter 触发 _apply_selection()

func add_radio(radio: UIRadio) -> void   # add_child + 连接 toggled 信号

# 用法：
var group := UIRadioGroup.new()
group.selected_index = 0
for opt in ["Option A", "Option B", "Option C"]:
    var r := UIRadio.new()
    r.label_text = opt
    group.add_radio(r)
parent.add_child(group)
group.selection_changed.connect(func(i): print(i))
```

### UISlider `extends Control`

```gdscript
signal value_changed(v: float)

@export var value: float = 0.0       # setter: snap + clamp，不 emit
@export var min_value: float = 0.0
@export var max_value: float = 100.0
@export var step: float = 1.0        # 0.0 = 连续无 snap
@export var accent_color: Color      # 默认 PRIMARY
@export var disabled: bool
@export var show_value: bool = false # knob 上方显示数值文字

# extends Control + _draw()；custom_minimum_size = Vector2(120, 28)
# _gui_input(): MouseButton → 开始拖拽，MouseMotion → 更新值
```

### UIDrawer `extends Node`

```gdscript
signal opened
signal closed

@export var drawer_width: float = 400.0
@export var show_overlay: bool = true   # 半透明遮罩，点击关闭
@export var title_text: String

func show_drawer() -> void   # 从右侧滑入（0.3s TRANS_CUBIC）
func hide_drawer() -> void   # 滑出（0.25s），finished 后 queue_free
func get_body() -> VBoxContainer   # show_drawer() 后调用填充内容

# Overlay 模式：CanvasLayer(104) _UIDrawerLayer
# ⚠️ opened 信号内填充时先检查 body.get_child_count() > 0 避免重复

# 用法：
var drawer := UIDrawer.new()
drawer.title_text = "Settings"
parent.add_child(drawer)
drawer.opened.connect(func():
    var body := drawer.get_body()
    if body.get_child_count() > 0: return
    body.add_child(my_content)
)
UI.solid_btn(parent, "Open", UITheme.PRIMARY).pressed.connect(drawer.show_drawer)
```

### UIThemePresets (`scripts/theme_presets.gd`)

```gdscript
class_name UIThemePresets extends RefCounted

# 切换主题：重新赋值 UITheme 所有 surface/text/border static var
# 品牌色 PRIMARY/SUCCESS/DANGER 等保持不变

static func apply_dark_indigo() -> void   # 默认深紫色（#0D0F14 背景）
static func apply_light() -> void         # 浅色模式（#F0F2F8 背景，深色文字）
static func apply_midnight() -> void      # 更深蓝黑（#070A12 背景）

# main.gd 中的切换流程：
# 1. UIThemePresets.apply_xxx()
# 2. _bg.color = UITheme.BG
# 3. 重建侧边栏（remove + _build_sidebar）
# 4. _navigate_to(current_page) 重建当前页
```



### Overlay 组件共同特征

```
UIToast / UITooltip / UIContextMenu / UISelect / UIDrawer:
- extends Node（不是 Control，本身无视觉）或 VBoxContainer（UISelect）
- 在 get_tree().root 按需创建具名 CanvasLayer（层级 100/101/102/103/104）
- 组件留在原场景树，随页面销毁自动清理
- 内容面板动态创建在 CanvasLayer 中
```

### setter 守卫模式

```gdscript
@export var some_prop: SomeType:
    set(v):
        some_prop = v
        if is_inside_tree(): _apply_styles()   # 避免 _ready 前调用
        # 或者
        if is_inside_tree(): _rebuild.call_deferred()  # 涉及 free 子节点时用 deferred
```

### 首次 class_name 注册流程

```
1. 写完新组件脚本（含 class_name）
2. mcp__godot__launch_editor()  ← 让编辑器扫描注册 class_name
3. 等待 ~8 秒
4. mcp__godot__run_project()
```

### UIInput/UISelect 属性在 add_child 前赋值无效

```gdscript
# ❌ 错误：子树不在场景树中时，_ready() 未被调用，_input 为 null
var inp := UIInput.new()
inp.text = "Jordan"              # 静默丢弃！
container.add_child(inp)         # container 尚不在场景树中

# ✅ 正确：确保祖先节点已在场景树后再赋值
tabs.add_tab("Tab1", container)  # container 进入场景树，_ready() 触发
inp.text = "Jordan"              # _input 已创建，赋值生效
```
