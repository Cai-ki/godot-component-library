# Godot 代码食谱

> 完整、可复制的代码模式，覆盖 UI 组件库开发中最常见的任务。

---

## 食谱 1：自定义 PanelContainer 组件

```gdscript
class_name UIMyCard
extends PanelContainer

signal card_clicked

@export var title: String = "":
    set(v):
        title = v
        if is_inside_tree(): _apply_styles()

@export var subtitle: String = "":
    set(v):
        subtitle = v
        if is_inside_tree(): _apply_styles()

var _vbox: VBoxContainer
var _title_lbl: Label
var _subtitle_lbl: Label

func _ready() -> void:
    # 自身样式
    size_flags_horizontal = Control.SIZE_EXPAND_FILL
    mouse_filter = Control.MOUSE_FILTER_STOP
    mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

    # 内部布局
    _vbox = VBoxContainer.new()
    _vbox.add_theme_constant_override("separation", 8)
    add_child(_vbox)

    _title_lbl = Label.new()
    _title_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _vbox.add_child(_title_lbl)

    _subtitle_lbl = Label.new()
    _subtitle_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
    _vbox.add_child(_subtitle_lbl)

    # 点击事件
    gui_input.connect(func(event: InputEvent):
        if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            card_clicked.emit()
    )

    _apply_styles()

func _apply_styles() -> void:
    # 面板样式
    var s := StyleBoxFlat.new()
    s.bg_color = UITheme.SURFACE_2
    s.set_corner_radius_all(UITheme.RADIUS_MD)
    s.border_width_top = 1; s.border_width_bottom = 1
    s.border_width_left = 1; s.border_width_right = 1
    s.border_color = UITheme.BORDER
    s.content_margin_left = 24; s.content_margin_right = 24
    s.content_margin_top = 20; s.content_margin_bottom = 20
    add_theme_stylebox_override("panel", s)

    # 文字
    _title_lbl.text = title
    _title_lbl.add_theme_font_size_override("font_size", UITheme.FONT_LG)
    _title_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)

    _subtitle_lbl.text = subtitle
    _subtitle_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
    _subtitle_lbl.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
    _subtitle_lbl.visible = subtitle != ""
```

---

## 食谱 2：自定义 _draw() 组件

```gdscript
class_name UIStatusDot
extends Control

enum Status { ONLINE, AWAY, BUSY, OFFLINE }

@export var status: Status = Status.OFFLINE:
    set(v):
        status = v
        queue_redraw()

@export var dot_size: float = 12.0:
    set(v):
        dot_size = v
        custom_minimum_size = Vector2(dot_size, dot_size)
        queue_redraw()

func _ready() -> void:
    custom_minimum_size = Vector2(dot_size, dot_size)
    mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
    var center := size / 2.0
    var radius := dot_size / 2.0
    var color: Color
    match status:
        Status.ONLINE:  color = UITheme.SUCCESS
        Status.AWAY:    color = UITheme.WARNING
        Status.BUSY:    color = UITheme.DANGER
        Status.OFFLINE: color = UITheme.TEXT_MUTED
    draw_circle(center, radius, color)
```

---

## 食谱 3：Overlay 组件（CanvasLayer 模式）

```gdscript
class_name UIPopover
extends Node

signal closed

const LAYER_NAME := "_UIPopoverLayer"
const LAYER_INDEX := 107

var _panel: PanelContainer
var _backdrop: ColorRect

func show_at(target: Control, content: Control) -> void:
    var layer := _get_or_create_layer()
    _close_existing()

    # 全屏透明背景（点击关闭）
    _backdrop = ColorRect.new()
    _backdrop.color = Color(0, 0, 0, 0)
    _backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    _backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
    _backdrop.gui_input.connect(func(event: InputEvent):
        if event is InputEventMouseButton and event.pressed:
            hide_popover()
    )
    layer.add_child(_backdrop)

    # 内容面板
    _panel = PanelContainer.new()
    var s := StyleBoxFlat.new()
    s.bg_color = UITheme.SURFACE_3
    s.set_corner_radius_all(UITheme.RADIUS_MD)
    s.border_width_top = 1; s.border_width_bottom = 1
    s.border_width_left = 1; s.border_width_right = 1
    s.border_color = UITheme.BORDER
    s.shadow_size = 8
    s.shadow_color = Color(0, 0, 0, 0.3)
    s.content_margin_left = 16; s.content_margin_right = 16
    s.content_margin_top = 12; s.content_margin_bottom = 12
    _panel.add_theme_stylebox_override("panel", s)
    _panel.add_child(content)
    layer.add_child(_panel)

    # 定位到目标下方
    var rect := target.get_global_rect()
    var vp := get_viewport_rect().size
    var px := clampf(rect.position.x, 8.0, vp.x - 200.0)
    var py := rect.position.y + rect.size.y + 4.0
    _panel.position = Vector2(px, py)

    # 淡入动画
    _panel.modulate.a = 0.0
    var t := _panel.create_tween()
    t.tween_property(_panel, "modulate:a", 1.0, 0.15)

func hide_popover() -> void:
    if is_instance_valid(_panel):
        var t := _panel.create_tween()
        t.tween_property(_panel, "modulate:a", 0.0, 0.1)
        t.finished.connect(func():
            if is_instance_valid(_backdrop): _backdrop.queue_free()
            if is_instance_valid(_panel): _panel.queue_free()
        )
    closed.emit()

func _get_or_create_layer() -> CanvasLayer:
    var root := get_tree().root
    for child in root.get_children():
        if child.name == LAYER_NAME:
            return child as CanvasLayer
    var layer := CanvasLayer.new()
    layer.name = LAYER_NAME
    layer.layer = LAYER_INDEX
    root.add_child(layer)
    return layer

func _close_existing() -> void:
    if is_instance_valid(_backdrop): _backdrop.queue_free()
    if is_instance_valid(_panel): _panel.queue_free()

func _exit_tree() -> void:
    _close_existing()
```

---

## 食谱 4：带 Hover 效果的卡片列表

```gdscript
func _build_card_list(parent: Control, items: Array[Dictionary]) -> void:
    for item in items:
        var panel := PanelContainer.new()
        panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        panel.mouse_filter = Control.MOUSE_FILTER_STOP
        panel.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

        # 样式
        var normal_s := StyleBoxFlat.new()
        normal_s.bg_color = UITheme.SURFACE_2
        normal_s.set_corner_radius_all(UITheme.RADIUS_MD)
        normal_s.border_width_top = 1; normal_s.border_width_bottom = 1
        normal_s.border_width_left = 1; normal_s.border_width_right = 1
        normal_s.border_color = UITheme.BORDER
        normal_s.content_margin_left = 20; normal_s.content_margin_right = 20
        normal_s.content_margin_top = 16; normal_s.content_margin_bottom = 16

        var hover_s := normal_s.duplicate()
        hover_s.bg_color = UITheme.SURFACE_3
        hover_s.border_color = UITheme.PRIMARY

        panel.add_theme_stylebox_override("panel", normal_s)
        panel.mouse_entered.connect(func(): panel.add_theme_stylebox_override("panel", hover_s))
        panel.mouse_exited.connect(func(): panel.add_theme_stylebox_override("panel", normal_s))

        # 内容
        var vbox := VBoxContainer.new()
        vbox.add_theme_constant_override("separation", 4)
        vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
        panel.add_child(vbox)

        var title := Label.new()
        title.text = item.get("title", "")
        title.add_theme_font_size_override("font_size", UITheme.FONT_BASE)
        title.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
        title.mouse_filter = Control.MOUSE_FILTER_IGNORE
        vbox.add_child(title)

        var desc := Label.new()
        desc.text = item.get("desc", "")
        desc.add_theme_font_size_override("font_size", UITheme.FONT_SM)
        desc.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
        desc.mouse_filter = Control.MOUSE_FILTER_IGNORE
        vbox.add_child(desc)

        parent.add_child(panel)
```

---

## 食谱 5：设置行（Label + 控件 右对齐）

```gdscript
# 常见于 Settings 页面：左侧标签 + 右侧控件
func _setting_row(parent: Control, label_text: String, control: Control) -> HBoxContainer:
    var row := HBoxContainer.new()
    row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    row.add_theme_constant_override("separation", 12)
    parent.add_child(row)

    var lbl := Label.new()
    lbl.text = label_text
    lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
    lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
    row.add_child(lbl)

    control.size_flags_horizontal = Control.SIZE_SHRINK_END
    row.add_child(control)

    return row

# 用法：
var sw := UISwitch.new()
_setting_row(card_v, "Dark Mode", sw)
sw.toggled.connect(func(on: bool): print("dark mode: ", on))
```

---

## 食谱 6：Tab 式页面切换

```gdscript
func _build_tabs_demo(parent: Control) -> void:
    var tabs := UITabs.new()
    parent.add_child(tabs)

    # Tab 1
    var tab1 := VBoxContainer.new()
    tab1.add_theme_constant_override("separation", 12)
    tabs.add_tab("General", tab1)

    # Tab 2
    var tab2 := VBoxContainer.new()
    tab2.add_theme_constant_override("separation", 12)
    tabs.add_tab("Advanced", tab2)

    # ⚠️ 在 add_tab 之后填充内容（确保进入场景树）
    var lbl := Label.new()
    lbl.text = "General settings here"
    tab1.add_child(lbl)

    var lbl2 := Label.new()
    lbl2.text = "Advanced settings here"
    tab2.add_child(lbl2)

    tabs.tab_changed.connect(func(idx: int, name: String):
        print("Switched to: ", name)
    )
```

---

## 食谱 7：确认对话框

```gdscript
func _show_confirm(parent: Control, title: String, message: String, on_confirm: Callable) -> void:
    var modal := UIModal.new()
    modal.title_text = title
    modal.dialog_width = 400.0
    parent.add_child(modal)   # ⚠️ 必须 add_child 到 parent，不能加到 card_v

    var body := modal.get_body()
    var lbl := Label.new()
    lbl.text = message
    lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
    lbl.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
    body.add_child(lbl)

    var footer := modal.get_footer()
    var cancel_btn := UI.outline_btn(footer, "Cancel", UITheme.TEXT_SECONDARY)
    cancel_btn.pressed.connect(modal.hide_modal)

    var confirm_btn := UI.solid_btn(footer, "Confirm", UITheme.DANGER)
    confirm_btn.pressed.connect(func():
        on_confirm.call()
        modal.hide_modal()
    )

    modal.show_modal()
```

---

## 食谱 8：数据表格

```gdscript
func _build_table(parent: Control) -> void:
    var table := UITable.new()
    table.striped = true
    table.sortable = true
    table.filterable = true
    parent.add_child(table)

    table.set_data(
        PackedStringArray(["Name", "Role", "Status"]),
        [
            ["Alice", "Admin", "Active"],
            ["Bob", "Editor", "Active"],
            ["Charlie", "Viewer", "Inactive"],
        ]
    )
```

---

## 食谱 9：Toast 通知

```gdscript
func _setup_toast(parent: Control) -> UIToast:
    var toast := UIToast.new()
    parent.add_child(toast)
    return toast

# 使用
var toast := _setup_toast(parent)
toast.show_toast("Settings saved!", UIToast.ToastType.SUCCESS)
toast.show_toast("Network error", UIToast.ToastType.ERROR, 5.0)
```

---

## 食谱 10：右键上下文菜单

```gdscript
func _setup_context_menu(parent: Control, target: Control) -> void:
    var menu := UIContextMenu.new()
    parent.add_child(menu)

    menu.add_item("✎  Edit",      func(): print("edit"))
    menu.add_item("◈  Duplicate", func(): print("duplicate"))
    menu.add_separator()
    menu.add_item("✕  Delete",    func(): print("delete"), true)   # destructive

    menu.attach(target)   # 右键 target 时自动显示
```

---

## 食谱 11：滚动列表 + 分页

```gdscript
func _build_paginated_list(parent: Control, all_items: Array, page_size: int = 10) -> void:
    var list_container := VBoxContainer.new()
    list_container.add_theme_constant_override("separation", 8)

    var scroll := ScrollContainer.new()
    scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
    scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
    scroll.add_child(list_container)
    parent.add_child(scroll)

    var pagination := UIPagination.new()
    var total := ceili(all_items.size() / float(page_size))
    pagination.total_pages = maxi(total, 1)
    pagination.current_page = 1
    parent.add_child(pagination)

    # 渲染页面
    var render_page := func(page: int) -> void:
        for c in list_container.get_children():
            list_container.remove_child(c)
            c.queue_free()
        var start: int = (page - 1) * page_size
        var end: int = mini(start + page_size, all_items.size())
        for i in range(start, end):
            var lbl := Label.new()
            lbl.text = str(all_items[i])
            list_container.add_child(lbl)
        scroll.scroll_vertical = 0

    render_page.call(1)
    pagination.page_changed.connect(func(page: int): render_page.call(page))
```

---

## 食谱 12：表单验证

```gdscript
func _build_form(parent: Control) -> void:
    var name_input := UIInput.new()
    name_input.label_text = "Name"
    name_input.placeholder = "Enter your name"
    parent.add_child(name_input)

    var email_input := UIInput.new()
    email_input.label_text = "Email"
    email_input.placeholder = "you@example.com"
    parent.add_child(email_input)

    var submit := UIButton.new()
    submit.text = "Submit"
    submit.variant = UIButton.Variant.SOLID
    submit.color_scheme = UIButton.ColorScheme.PRIMARY
    parent.add_child(submit)

    submit.pressed.connect(func():
        var valid := true

        if name_input.text.strip_edges().is_empty():
            name_input.validation_state = UIInput.State.ERROR
            name_input.hint_text = "Name is required"
            valid = false
        else:
            name_input.validation_state = UIInput.State.SUCCESS
            name_input.hint_text = ""

        if not email_input.text.contains("@"):
            email_input.validation_state = UIInput.State.ERROR
            email_input.hint_text = "Invalid email format"
            valid = false
        else:
            email_input.validation_state = UIInput.State.SUCCESS
            email_input.hint_text = ""

        if valid:
            print("Form submitted: ", name_input.text, " / ", email_input.text)
    )
```

---

## 食谱 13：Drawer 侧边抽屉

```gdscript
func _open_drawer(parent: Control) -> void:
    var drawer := UIDrawer.new()
    drawer.title_text = "Detail Panel"
    drawer.drawer_width = 450.0
    parent.add_child(drawer)

    drawer.opened.connect(func():
        var body := drawer.get_body()
        if body.get_child_count() > 0: return   # ⚠️ 避免重复创建

        var info := VBoxContainer.new()
        info.add_theme_constant_override("separation", 16)
        body.add_child(info)

        var title := Label.new()
        title.text = "Item Details"
        title.add_theme_font_size_override("font_size", UITheme.FONT_XL)
        title.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
        info.add_child(title)

        var desc := Label.new()
        desc.text = "Detailed information goes here..."
        desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
        desc.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
        info.add_child(desc)
    )

    drawer.show_drawer()
```

---

## 食谱 14：_process 循环动画

```gdscript
# 脉冲发光效果
var _time: float = 0.0
var _glow_panel: PanelContainer
var _glow_style: StyleBoxFlat

func _process(delta: float) -> void:
    _time += delta
    var t := (sin(_time * 2.0) + 1.0) / 2.0   # [0, 1] 周期
    var glow_color := UITheme.PRIMARY.lerp(UITheme.PRIMARY_LIGHT, t)
    _glow_style.shadow_color = Color(glow_color, 0.3)
    _glow_panel.add_theme_stylebox_override("panel", _glow_style)
```

---

## 食谱 15：信号总线（全局事件）

```gdscript
# autoload/event_bus.gd — 添加为 Autoload
class_name EventBus
extends Node

signal theme_changed(theme_id: String)
signal notification_received(message: String, type: int)
signal user_logged_in(user_data: Dictionary)

# 使用（任何脚本中）：
# EventBus.theme_changed.emit("dark")
# EventBus.theme_changed.connect(func(id): _apply_theme(id))
```
