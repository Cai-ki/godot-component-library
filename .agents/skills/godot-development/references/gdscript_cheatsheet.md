# GDScript Cheatsheet (Condensed)

## 1) Types & Variables

```gdscript
const MAX_HP := 100
var speed: float = 10.0
var tags: PackedStringArray = []
var options: Array[String] = []
var meta: Dictionary = {}
```

- 组件代码优先显式类型。
- `const` 不能依赖运行时值（如 `UITheme` 的 `static var` 颜色）。
- 避免变量名与内建函数冲突（如 `snapped`, `wrap`）。

## 2) Common Control Flow

```gdscript
if cond:
	pass
elif other:
	pass
else:
	pass

for i in range(10):
	pass

match state:
	0: pass
	_: pass
```

- 三元表达式仅用于表达式，不用于 `connect()` 这类语句。

## 3) Functions / Class / Signal

```gdscript
class_name MyWidget
extends PanelContainer

signal submitted(value: String)

func set_value(v: String) -> void:
	submitted.emit(v)
```

- 公共 API 用无下划线方法。
- 内部方法与字段用 `_` 前缀。

## 4) Export + Setter Pattern

```gdscript
@export var title_text: String = "":
	set(v):
		title_text = v
		if _title_lbl:
			_title_lbl.text = v
```

重建型 setter（防 locked object）：

```gdscript
@export var options: PackedStringArray = []:
	set(v):
		options = v
		if is_inside_tree():
			_rebuild.call_deferred()
```

## 5) Safe Rebuild Pattern

```gdscript
func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()
	_build()
```

## 6) Node Lifecycle

- `_init()`：对象创建。
- `_enter_tree()`：入树（父先子）。
- `_ready()`：就绪（子先父）。
- `_process(delta)`：每帧。
- `_exit_tree()`：离树。

## 7) Tween Essentials

```gdscript
var t := node.create_tween()
t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
t.tween_property(node, "modulate:a", 1.0, 0.2)
```

- `create_tween()` 只能在 `Node` 上调用。
- 宿主可能离树时，把 tween 挂在叶子节点。
- 新 tween 前先 kill 旧 tween（同一属性动画）。

## 8) Async / Deferred

```gdscript
await get_tree().process_frame
call_deferred("_rebuild")

if is_instance_valid(node):
	node.queue_free()
```

## 9) Input Quick Pattern

```gdscript
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			_on_click()
```

## 10) Frequent Pitfalls

- `@export var size` 与 `Button.size` 冲突，改 `button_size`。
- Array 元素推断失败时显式声明：`var x: int = arr[i]`。
- 整数除法警告：用 `floori(v / 100.0)` 表达意图。
- Overlay 组件中 show/hide 要幂等。

## 11) Debug Snippets

```gdscript
print("debug", value)
push_warning("warn")
push_error("error")
```

```gdscript
# 初始化后再读布局尺寸
await get_tree().process_frame
print(node.size, node.get_combined_minimum_size())
```
