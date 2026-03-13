# Workflow：创建新组件

> 完整的组件开发流程，从需求分析到注册运行。

---

## 步骤 0：决策树 — 选择基类

```
需要新组件？
│
├─ 需要背景面板 + 子内容？
│   └─ → extends PanelContainer
│      例：UICard, UIBadge, UIChip, UITag, UIAlert
│
├─ 需要垂直排列多个子组件？
│   └─ → extends VBoxContainer
│      例：UIInput, UISelect, UITabs, UIAccordion, UITable, UITimeline,
│          UIEmpty, UISteps, UIRadioGroup, UITreeView, UIColorPicker, UIDatePicker
│
├─ 需要水平排列？
│   └─ → extends HBoxContainer
│      例：UIBreadcrumb, UIRadio, UICheckbox, UIPagination
│
├─ 需要自定义绘制（圆形、弧线、线条）？
│   └─ → extends Control + _draw() + custom_minimum_size
│      例：UIAvatar, UIDivider, UIProgressRing, UISwitch, UISlider
│
├─ 继承按钮行为（pressed/toggled 信号）？
│   └─ → extends Button
│      例：UIButton
│
├─ 是 Overlay 浮层（需要渲染在所有 UI 之上）？
│   └─ → extends Node（无视觉，CanvasLayer 动态创建内容）
│      例：UIToast, UITooltip, UIContextMenu, UIDrawer, UICommandPalette
│      或 extends VBoxContainer（如果同时需要自身 UI + Overlay 弹出）
│      例：UISelect, UIDatePicker
│
└─ 纯逻辑/不确定？
    └─ → extends Node 或 extends RefCounted
```

---

## 步骤 1：创建文件结构

```
components/
  {component_name}/
    ui_{component_name}.gd
```

**命名规范**：
- 目录名：`snake_case`（如 `notification_badge`）
- 文件名：`ui_` 前缀 + `snake_case`（如 `ui_notification_badge.gd`）
- 类名：`UI` 前缀 + `PascalCase`（如 `UINotificationBadge`）

---

## 步骤 2：编写组件代码

### 模板 A：PanelContainer 组件

```gdscript
class_name UIMyWidget
extends PanelContainer

# --- 信号 ---
signal value_changed(new_value: String)

# --- 枚举 ---
enum Variant { DEFAULT, PRIMARY, DANGER }

# --- @export 属性（全部带 setter 守卫）---
@export var label_text: String = "":
    set(v):
        label_text = v
        if is_inside_tree(): _apply_styles()

@export var variant: Variant = Variant.DEFAULT:
    set(v):
        variant = v
        if is_inside_tree(): _apply_styles()

@export var disabled: bool = false:
    set(v):
        disabled = v
        if is_inside_tree(): _apply_styles()

# --- 私有变量 ---
var _label: Label

# --- 生命周期 ---
func _ready() -> void:
    size_flags_horizontal = Control.SIZE_EXPAND_FILL

    _label = Label.new()
    _label.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(_label)

    _apply_styles()

# --- 公共方法 ---
func get_value() -> String:
    return _label.text

# --- 私有方法 ---
func _apply_styles() -> void:
    # 面板样式
    var s := StyleBoxFlat.new()
    s.bg_color = UITheme.SURFACE_2
    s.set_corner_radius_all(UITheme.RADIUS_MD)
    s.content_margin_left = UITheme.SP_4
    s.content_margin_right = UITheme.SP_4
    s.content_margin_top = UITheme.SP_3
    s.content_margin_bottom = UITheme.SP_3
    add_theme_stylebox_override("panel", s)

    # 子控件
    _label.text = label_text
    _label.add_theme_font_size_override("font_size", UITheme.FONT_MD)
    _label.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
```

### 模板 B：Control + _draw() 组件

```gdscript
class_name UIMyShape
extends Control

signal clicked

@export var shape_color: Color = UITheme.PRIMARY:
    set(v):
        shape_color = v
        queue_redraw()

@export var shape_size: float = 40.0:
    set(v):
        shape_size = v
        custom_minimum_size = Vector2(shape_size, shape_size)
        queue_redraw()

func _ready() -> void:
    custom_minimum_size = Vector2(shape_size, shape_size)
    mouse_filter = Control.MOUSE_FILTER_STOP              # 如需点击
    mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

    gui_input.connect(func(event: InputEvent):
        if event is InputEventMouseButton and event.pressed:
            if event.button_index == MOUSE_BUTTON_LEFT:
                clicked.emit()
                accept_event()
    )

func _draw() -> void:
    var center := size / 2.0
    draw_circle(center, shape_size / 2.0, shape_color)
```

### 模板 C：Node Overlay 组件

```gdscript
class_name UIMyOverlay
extends Node

signal shown
signal hidden

const LAYER_NAME := "_UIMyOverlayLayer"
const LAYER_INDEX := 107              # ⚠️ 选择未被占用的层级

@export var default_message: String = ""

var _panel: PanelContainer
var _backdrop: ColorRect

func show_overlay(message: String = "") -> void:
    var layer := _get_or_create_layer()
    _close_existing()

    var msg := message if message != "" else default_message

    # 背景遮罩
    _backdrop = ColorRect.new()
    _backdrop.color = Color(0, 0, 0, 0.4)
    _backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
    _backdrop.gui_input.connect(func(event: InputEvent):
        if event is InputEventMouseButton and event.pressed:
            hide_overlay()
    )
    layer.add_child(_backdrop)

    # 内容面板
    _panel = PanelContainer.new()
    var s := StyleBoxFlat.new()
    s.bg_color = UITheme.SURFACE_2
    s.set_corner_radius_all(UITheme.RADIUS_LG)
    s.shadow_size = 16
    s.shadow_color = Color(0, 0, 0, 0.4)
    s.content_margin_left = 24; s.content_margin_right = 24
    s.content_margin_top = 20; s.content_margin_bottom = 20
    _panel.add_theme_stylebox_override("panel", s)
    layer.add_child(_panel)

    # 居中
    var vp := get_viewport_rect().size
    var w := 300.0; var h := 150.0
    _panel.position = Vector2((vp.x - w) / 2, (vp.y - h) / 2)
    _panel.custom_minimum_size = Vector2(w, h)

    # 内容
    var lbl := Label.new()
    lbl.text = msg
    lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
    _panel.add_child(lbl)

    # 动画
    _panel.modulate.a = 0.0
    _backdrop.modulate.a = 0.0
    var t := _panel.create_tween().set_parallel(true)
    t.tween_property(_panel, "modulate:a", 1.0, 0.2)
    t.tween_property(_backdrop, "modulate:a", 1.0, 0.15)

    shown.emit()

func hide_overlay() -> void:
    if is_instance_valid(_panel):
        var t := _panel.create_tween().set_parallel(true)
        t.tween_property(_panel, "modulate:a", 0.0, 0.15)
        t.tween_property(_backdrop, "modulate:a", 0.0, 0.1)
        t.finished.connect(func():
            if is_instance_valid(_backdrop): _backdrop.queue_free()
            if is_instance_valid(_panel): _panel.queue_free()
        )
    hidden.emit()

func _get_or_create_layer() -> CanvasLayer:
    var root := get_tree().root
    for child in root.get_children():
        if child.name == LAYER_NAME:
            return child as CanvasLayer
    var cl := CanvasLayer.new()
    cl.name = LAYER_NAME
    cl.layer = LAYER_INDEX
    root.add_child(cl)
    return cl

func _close_existing() -> void:
    if is_instance_valid(_backdrop): _backdrop.queue_free()
    if is_instance_valid(_panel): _panel.queue_free()

func _exit_tree() -> void:
    _close_existing()
```

### 模板 D：VBoxContainer 组件（含动态子节点重建）

```gdscript
class_name UIMyList
extends VBoxContainer

signal item_selected(index: int)

@export var items: PackedStringArray = PackedStringArray():
    set(v):
        items = v
        if is_inside_tree(): _rebuild.call_deferred()

var _selected: int = -1

func _ready() -> void:
    add_theme_constant_override("separation", 4)
    _rebuild()

func _rebuild() -> void:
    # 安全清除所有子节点
    for child in get_children():
        remove_child(child)
        child.queue_free()

    # 重新创建
    for i in range(items.size()):
        var btn := Button.new()
        btn.text = items[i]
        btn.flat = true
        btn.focus_mode = Control.FOCUS_NONE
        btn.alignment = HORIZONTAL_ALIGNMENT_LEFT

        var captured_i := i
        btn.pressed.connect(func():
            _selected = captured_i
            item_selected.emit(captured_i)
            _rebuild.call_deferred()
        )

        # 选中高亮
        var s := StyleBoxFlat.new()
        if i == _selected:
            s.bg_color = UITheme.PRIMARY_SOFT
        else:
            s.bg_color = Color.TRANSPARENT
        s.set_corner_radius_all(UITheme.RADIUS_SM)
        s.content_margin_left = 12; s.content_margin_right = 12
        s.content_margin_top = 8; s.content_margin_bottom = 8
        btn.add_theme_stylebox_override("normal", s)

        add_child(btn)
```

---

## 步骤 3：注册并运行

```
1. 保存文件
2. mcp__godot__launch_editor()     ← 新 class_name 必须先启动编辑器扫描
3. 等待 ~8 秒
4. mcp__godot__run_project()       ← 运行验证
5. mcp__godot__get_debug_output()  ← 检查错误
```

---

## Checklist

- [ ] 文件放在 `components/{name}/ui_{name}.gd`
- [ ] `class_name UI{Name}` 全局注册
- [ ] 选对基类（见决策树）
- [ ] `@export` 属性全部带 setter 守卫 `if is_inside_tree()`
- [ ] setter 涉及 `free()` 子节点时用 `_rebuild.call_deferred()`
- [ ] `_draw()` 组件设了 `custom_minimum_size`
- [ ] 仅依赖 `UITheme`，不依赖 `UI helpers`
- [ ] 子 Label 等显示控件设 `mouse_filter = IGNORE`
- [ ] Overlay 组件在 `_exit_tree()` 中清理 CanvasLayer 内容
- [ ] 首次运行前 `launch_editor` 注册 class_name
