# 2D Graphics / Overlay / Tween (Condensed)

## 1) CanvasLayer Overlay Pattern

```gdscript
func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == "_UILayer":
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name = "_UILayer"
	layer.layer = 103
	root.add_child(layer)
	return layer
```

- overlay 组件内容统一挂 `CanvasLayer`。
- 关闭时清理 overlay 子树，保留 layer 可复用。

## 2) Glass Backdrop Pattern

```gdscript
var overlay := UI.glass_backdrop(layer, 2.0, Color(0, 0, 0, 0.4))
overlay.gui_input.connect(func(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		hide_overlay()
)
```

- 访问内部 blur 节点用名称查找，不用子索引。

## 3) Screen Clamp Pattern

```gdscript
var vp := get_tree().root.get_visible_rect().size
panel.position = Vector2(
	clampf(panel.position.x, 8.0, vp.x - panel_size.x - 8.0),
	clampf(panel.position.y, 8.0, vp.y - panel_size.y - 8.0)
)
```

- 入场动画前先 clamp，再计算最终目标位置。

## 4) _draw Basics

```gdscript
func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), UITheme.SURFACE_2)
	draw_circle(size * 0.5, minf(size.x, size.y) * 0.45, UITheme.PRIMARY)
```

常用：`draw_rect`, `draw_circle`, `draw_line`, `draw_arc`, `draw_string`。

## 5) Redraw Trigger

- 属性变化后调用 `queue_redraw()`。
- 尺寸变化时 `_draw()` 会自动再次调用。

## 6) Drag Input Pattern

```gdscript
var _dragging := false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			_dragging = mb.pressed
	elif event is InputEventMouseMotion and _dragging:
		_update_by_position((event as InputEventMouseMotion).position)
```

## 7) Tween Patterns

### Fade
```gdscript
node.modulate.a = 0.0
node.create_tween().tween_property(node, "modulate:a", 1.0, 0.2)
```

### Slide
```gdscript
var target_y := panel.position.y
panel.position.y = target_y - 10
var t := panel.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
t.tween_property(panel, "position:y", target_y, 0.25)
```

### Scale (防抖)
```gdscript
node.pivot_offset = (node.size / 2.0).round()
```

- 对同一属性重复动画前，先 kill 旧 tween。

## 8) Overlay Idempotency

```gdscript
var _is_open := false

func show_overlay() -> void:
	if _is_open: return
	_is_open = true

func hide_overlay() -> void:
	if not _is_open: return
	_is_open = false
```

## 9) Frequent Pitfalls

- Tween 宿主离树后，`finished` 可能不触发。
- overlay 面板入场动画目标值取在 clamp 之前会错位。
- CanvasLayer 内控件键盘事件不一定可靠。
