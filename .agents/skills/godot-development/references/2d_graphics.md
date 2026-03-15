# Godot 绘制、CanvasLayer 与动画

> 本文档聚焦于 UI 组件库实际使用的内容：CanvasLayer Overlay 模式、自定义 _draw() 控件、Tween 动画、输入处理。

---

## CanvasLayer

### 基础概念

- `CanvasLayer` 拥有独立的 2D 渲染层，**不受摄像机/父节点变换影响**
- `layer` 属性决定渲染顺序，数值越大越在上层（覆盖低层级）
- UI 的 CanvasLayer 通常设 layer = 1~10；Overlay 浮层用更高值

### Overlay 组件模式（UIToast/UITooltip/UIContextMenu）

```gdscript
# 在 get_tree().root 按需创建具名 CanvasLayer（避免重复）
func _get_or_create_layer() -> CanvasLayer:
    var root := get_tree().root
    for child in root.get_children():
        if child.name == LAYER_NAME:        # ⚠️ 用 == 比较，不要用 &LAYER_NAME
            return child as CanvasLayer
    var layer := CanvasLayer.new()
    layer.name  = LAYER_NAME
    layer.layer = 100            # 高层级确保在所有 UI 之上
    root.add_child(layer)
    return layer
```

### 本项目层级约定

| 组件 | CanvasLayer 名 | layer |
|------|---------------|-------|
| UIToast | `_UIToastLayer` | 100 |
| UITooltip | `_UITooltipLayer` | 101 |
| UIContextMenu | `_UIContextMenuLayer` | 102 |
| UISelect | `_UISelectLayer` | 103 |
| UIDrawer | `_UIDrawerLayer` | 104 |
| UIDatePicker | `_UIDatePickerLayer` | 105 |
| UICommandPalette | `_UICommandPaletteLayer` | 106 |

### 关键注意事项

- Overlay 组件本身留在原场景树（`extends Node`），随页面销毁自动清理
- `show_xxx()` 时在 CanvasLayer 中**动态创建**内容面板
- 内容面板位置用 `get_global_rect()` + 视口边界 clamp 防止超出屏幕
- 不用时 `queue_free()` 内容面板即可，不需要删除 CanvasLayer（复用）

### CanvasLayer 属性

```gdscript
var cl := CanvasLayer.new()
cl.layer = 100                   # 渲染层级
cl.follow_viewport_enabled = false  # 不跟随视口变换
cl.offset = Vector2.ZERO           # 偏移
cl.rotation = 0.0                  # 旋转
cl.scale = Vector2.ONE             # 缩放
cl.visible = true                  # 可见性（隐藏整个层）
```

---

## 坐标系统

- 原点 `(0, 0)` 在左上角，X 向右，Y 向下
- `global_position` — 全局坐标（相对于视口）
- `position` — 局部坐标（相对于父节点）

```gdscript
var world_pos := to_global(local_pos)
var local_pos := to_local(world_pos)

# 获取控件在屏幕上的矩形
var rect := control.get_global_rect()   # Rect2(position, size)

# 获取视口尺寸
var viewport_size := get_viewport_rect().size   # Vector2

# 将全局坐标 clamp 到屏幕内（Overlay 定位常用）
var x := clampf(global_x, 0.0, viewport_size.x - panel_width)
var y := clampf(global_y, 0.0, viewport_size.y - panel_height)
```

---

## 自定义绘制 (_draw)

### 适用场景

- 圆形控件（UIAvatar — 圆形头像 + 状态点）
- 自定义线条控件（UIDivider — 带文字的分割线）
- 进度环（UIProgressRing — draw_arc 圆弧）
- 复选框（UICheckbox — 方框 + 勾号）
- 单选按钮（UIRadio — 圆圈 + 内点）
- 滑块（UISlider — 轨道 + 旋钮）
- 开关（UISwitch — 圆角矩形 + 圆形滑块）
- 任何 StyleBoxFlat 无法实现的形状

### 基本用法

```gdscript
class_name MyWidget
extends Control   # 或 Node2D

func _ready() -> void:
    custom_minimum_size = Vector2(100, 100)  # 必须设置，否则尺寸为 0

func _draw() -> void:
    var center := size / 2.0                 # size 是当前控件尺寸
    # 在这里调用 draw_* 方法
```

### draw_* 完整 API

```gdscript
# === 基础形状 ===

# 矩形（填充）
draw_rect(Rect2(Vector2.ZERO, size), Color("#1C1F2E"))

# 矩形（描边）
draw_rect(Rect2(Vector2.ZERO, size), Color("#2A2D3E"), false, 1.0)
# draw_rect(rect, color, filled=true, width=-1.0, antialiased=true)

# 圆形（填充）
draw_circle(center, 40.0, Color("#6C63FF"))
# draw_circle(position, radius, color)

# 线条
draw_line(Vector2(0, h/2), Vector2(w, h/2), Color("#2A2D3E"), 1.0)
# draw_line(from, to, color, width=1.0, antialiased=true)

# === 圆弧（UIProgressRing 必用）===

# draw_arc(center, radius, start_angle, end_angle, point_count, color, width, antialiased)
# 角度单位：弧度。0 = 右侧，PI/2 = 下方，PI = 左侧，3PI/2 = 上方
# Godot 的 Y 轴向下，所以顺时针方向 = 正角度

# 完整圆环（背景轨道）
draw_arc(center, radius, 0.0, TAU, 64, track_color, thickness, true)

# 进度圆弧（从顶部顺时针）
var start := -PI / 2.0                          # 顶部
var end := start + TAU * progress               # 按进度计算终点
draw_arc(center, radius, start, end, 64, fill_color, thickness, true)

# 半圆弧
draw_arc(center, radius, 0.0, PI, 32, color, 2.0)

# === 多边形 ===

# 填充多边形
var points := PackedVector2Array([
    Vector2(0, 10),
    Vector2(10, 0),
    Vector2(20, 10)
])
draw_colored_polygon(points, Color.WHITE)
# draw_colored_polygon(points, color, uvs=[], texture=null)

# 描边多边形（自动闭合）
draw_polyline(points, Color.WHITE, 1.0, true)
# draw_polyline(points, color, width=1.0, antialiased=true)
# ⚠️ polyline 不自动闭合，需手动在 points 末尾添加首点

# === 多条独立线段 ===
var lines := PackedVector2Array([
    Vector2(0, 0), Vector2(10, 10),     # 第一条线
    Vector2(20, 0), Vector2(30, 10),     # 第二条线
])
draw_multiline(lines, Color.WHITE, 1.0)
# 每两个点组成一条线段

# === 文字 ===
var font := ThemeDB.fallback_font
var font_size := 14
var text := "AB"
var tsz := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
var pos := center + Vector2(-tsz.x * 0.5, tsz.y * 0.3)   # 垂直居中修正
draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)
# draw_string(font, pos, text, alignment, width, font_size, color)

# 文字描边
draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, 2, Color.BLACK)
# 参数多了一个 outline_size

# === 纹理 ===
draw_texture(texture, Vector2.ZERO)
# draw_texture(texture, position, modulate=Color.WHITE)

draw_texture_rect(texture, Rect2(Vector2.ZERO, Vector2(64, 64)), false)
# draw_texture_rect(texture, rect, tile, modulate=Color.WHITE, transpose=false)

# === 圆角矩形（无内建方法，用 StyleBoxFlat 或 draw 组合实现）===
# 方式一：用 StyleBoxFlat draw
var sb := StyleBoxFlat.new()
sb.bg_color = color
sb.set_corner_radius_all(radius)
sb.draw(get_canvas_item(), Rect2(Vector2.ZERO, size))

# 方式二：draw_rect + 四角 draw_circle（近似）
```

### 触发重绘

```gdscript
# 属性改变时触发重绘
@export var bg_color: Color = Color.RED:
    set(v): bg_color = v; queue_redraw()   # 标记下一帧重绘

# 也可以直接调用
queue_redraw()

# 尺寸变化时 _draw 自动重新调用（无需手动 queue_redraw）
```

### _draw 的 size

- `size` 是控件当前实际尺寸（由容器或锚点决定）
- `custom_minimum_size` 设置最小尺寸，_draw 中用 `size` 而非 `custom_minimum_size`
- 控件 resize 时 `_draw` 自动重新调用

### _draw 常见模式

```gdscript
# 模式一：圆形头像（UIAvatar）
func _draw() -> void:
    var r := size.x / 2.0
    var c := Vector2(r, r)
    # 背景圆
    draw_circle(c, r, bg_color)
    # 文字居中
    var font := ThemeDB.fallback_font
    var tsz := font.get_string_size(initials, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
    draw_string(font, c + Vector2(-tsz.x/2, tsz.y*0.3), initials, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color.WHITE)
    # 状态点（右下角）
    if status != StatusType.NONE:
        var dot_r := r * 0.25
        var dot_pos := c + Vector2(r * 0.65, r * 0.65)
        draw_circle(dot_pos, dot_r + 2, UITheme.BG)       # 外圈（背景色描边）
        draw_circle(dot_pos, dot_r, status_color)           # 内圈

# 模式二：进度环（UIProgressRing）
func _draw() -> void:
    var c := size / 2.0
    var r := ring_size / 2.0 - thickness / 2.0
    # 背景轨道
    draw_arc(c, r, 0, TAU, 64, UITheme.SURFACE_3, thickness, true)
    # 进度弧
    var start := -PI / 2.0
    var end := start + TAU * value
    if value > 0.0:
        draw_arc(c, r, start, end, 64, progress_color, thickness, true)

# 模式三：复选框勾号
func _draw() -> void:
    var s := 20.0
    if checked:
        draw_rect(Rect2(Vector2.ZERO, Vector2(s, s)), accent_color)
        # 勾号
        var check := PackedVector2Array([
            Vector2(4, 10), Vector2(8, 14), Vector2(16, 6)
        ])
        draw_polyline(check, Color.WHITE, 2.0, true)
    else:
        draw_rect(Rect2(Vector2.ZERO, Vector2(s, s)), UITheme.BORDER, false, 2.0)

# 模式四：开关（UISwitch）
func _draw() -> void:
    var w := 44.0; var h := 24.0
    var r := h / 2.0
    var bg := accent_color if toggled_on else UITheme.SURFACE_3
    # 背景胶囊（用 StyleBoxFlat draw）
    var sb := StyleBoxFlat.new()
    sb.bg_color = bg
    sb.set_corner_radius_all(int(r))
    sb.draw(get_canvas_item(), Rect2(Vector2.ZERO, Vector2(w, h)))
    # 圆形滑块
    var knob_x := w - r if toggled_on else r    # 动画中间值
    draw_circle(Vector2(knob_x, r), r - 3, Color.WHITE)
```

---

## _gui_input 拖拽模式

```gdscript
# 用于自定义滑块、颜色选择器等需要拖拽的控件
var _dragging := false

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:
                _dragging = true
                _update_value(event.position)
                accept_event()
            else:
                _dragging = false
                accept_event()

    elif event is InputEventMouseMotion:
        if _dragging:
            _update_value(event.position)
            accept_event()

func _update_value(pos: Vector2) -> void:
    # 根据鼠标位置计算值
    var ratio := clampf(pos.x / size.x, 0.0, 1.0)
    var new_value := lerpf(min_value, max_value, ratio)
    if step > 0.0:
        new_value = snapped(new_value, step)
    if new_value != value:
        value = new_value
        value_changed.emit(value)
        queue_redraw()

# ⚠️ 别忘了设置 mouse_filter
func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_STOP   # 拦截鼠标事件
    mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
```

### 拖拽排序模式

```gdscript
# Control 内置拖放 API
func _get_drag_data(at_position: Vector2) -> Variant:
    # 开始拖拽时调用，返回拖拽数据
    var preview := Label.new()
    preview.text = "Dragging..."
    set_drag_preview(preview)
    return {"type": "item", "index": index}

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
    # 是否接受放置
    return data is Dictionary and data.get("type") == "item"

func _drop_data(at_position: Vector2, data: Variant) -> void:
    # 放置时调用
    var from_index: int = data["index"]
    print("Dropped from ", from_index)
```

---

## 点击外部关闭（Overlay 常用）

```gdscript
# 在 CanvasLayer 中添加全屏背景拦截点击
func _show_overlay() -> void:
    var layer := _get_or_create_layer()

    # 全屏透明背景（拦截点击）
    var backdrop := ColorRect.new()
    backdrop.color = Color(0, 0, 0, 0.0)          # 完全透明
    # 或半透明遮罩: Color(0, 0, 0, 0.4)
    backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
    backdrop.gui_input.connect(func(event: InputEvent):
        if event is InputEventMouseButton and event.pressed:
            _close()                                # 点击背景关闭
    )
    layer.add_child(backdrop)

    # 内容面板
    var panel := PanelContainer.new()
    # ... 设置内容
    layer.add_child(panel)
```

---

## Tween 动画

> 详细 API 见 `gdscript_cheatsheet.md`。此处补充 UI 组件库常见用法。

### Fade In / Out

```gdscript
# Fade in（常用于 Toast/ContextMenu 出现）
node.modulate.a = 0.0
var t := node.create_tween()
t.tween_property(node, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE)

# Fade out 后自动销毁
var t_out := node.create_tween()
t_out.tween_property(node, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
t_out.finished.connect(func(): if is_instance_valid(node): node.queue_free())
```

### 进度条动画

```gdscript
# UIProgress.animate_to() 的实现模式
func animate_to(target: float, duration: float = 0.5) -> void:
    var t := create_tween()
    t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
    t.tween_property(self, "value", clampf(target, 0.0, 1.0), duration)
```

### 滑入动画

```gdscript
# 从下方滑入
node.position.y += 20.0
node.modulate.a = 0.0
var t := node.create_tween()
t.set_parallel(true)
t.tween_property(node, "position:y", original_y, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
t.tween_property(node, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE)

# 从右侧滑入（UIDrawer 模式）
panel.position.x = viewport_width                # 起始在屏幕外
var t := panel.create_tween()
t.tween_property(panel, "position:x", target_x, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

# 从顶部下拉（UISelect dropdown 模式）
dropdown.modulate.a = 0.0
dropdown.position.y -= 8.0
var t := dropdown.create_tween()
t.set_parallel(true)
t.tween_property(dropdown, "modulate:a", 1.0, 0.15)
t.tween_property(dropdown, "position:y", target_y, 0.15).set_trans(Tween.TRANS_CUBIC)
```

### 缩放动画

```gdscript
# 弹出效果（scale 从小到大）
node.scale = Vector2(0.8, 0.8)
node.modulate.a = 0.0
var t := node.create_tween()
t.set_parallel(true)
t.tween_property(node, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
t.tween_property(node, "modulate:a", 1.0, 0.15)
# ⚠️ scale 动画需要设 pivot_offset 为中心：
node.pivot_offset = node.size / 2.0
```

### 颜色过渡（Skeleton shimmer 模式）

```gdscript
# _process 中用 sin 实现循环颜色动画
var _t: float = 0.0

func _process(delta: float) -> void:
    _t += delta * 1.4
    var brightness := (sin(_t) + 1.0) * 0.5   # [0, 1] 循环
    _style.bg_color = COLOR_A.lerp(COLOR_B, brightness)
    add_theme_stylebox_override("panel", _style)
```

### 数值动画（计数器效果）

```gdscript
# 数字从 0 跳到目标值
var label := Label.new()
var t := label.create_tween()
t.tween_method(func(v: float):
    label.text = str(int(v))
, 0.0, 1234.0, 1.0)
t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
```

### 序列动画（逐个出现）

```gdscript
# 子节点依次淡入
for i in range(container.get_child_count()):
    var child := container.get_child(i)
    child.modulate.a = 0.0
    var t := child.create_tween()
    t.tween_interval(i * 0.05)                                    # 每个延迟 50ms
    t.tween_property(child, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE)
```

---

## z_index 渲染顺序

```gdscript
# Node2D 和 Control 都有 z_index
node.z_index = 10            # 数值越大越在上层
node.z_as_relative = true    # 相对于父节点的 z_index（默认）
node.z_as_relative = false   # 绝对 z_index

# Control 没有 z_index，用 CanvasLayer 或节点顺序控制层级
# 同一父节点下，后面的子节点渲染在上方
parent.move_child(node, parent.get_child_count() - 1)   # 移到最上层
parent.move_child(node, 0)                               # 移到最下层
```

---

## 实用技巧

### 屏幕边界 Clamp（Overlay 定位）

```gdscript
# 确保弹出面板不超出屏幕
func _clamp_to_viewport(panel_pos: Vector2, panel_size: Vector2) -> Vector2:
    var vp := get_viewport_rect().size
    var margin := 8.0   # 边缘留白
    return Vector2(
        clampf(panel_pos.x, margin, vp.x - panel_size.x - margin),
        clampf(panel_pos.y, margin, vp.y - panel_size.y - margin)
    )
```

### 获取控件全局中心

```gdscript
var rect := control.get_global_rect()
var center := rect.position + rect.size / 2.0
```

### 动态设置控件的锚点居中

```gdscript
# 在 CanvasLayer 中居中放置弹窗
func _center_in_viewport(panel: Control, w: float, h: float) -> void:
    var vp := get_viewport_rect().size
    panel.position = Vector2(
        (vp.x - w) / 2.0,
        (vp.y - h) / 2.0
    )
    panel.custom_minimum_size = Vector2(w, h)
```
