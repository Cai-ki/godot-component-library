# Node Reference (Condensed)

## 1) Lifecycle Order

- `_enter_tree()`：父 -> 子
- `_ready()`：子 -> 父
- `_exit_tree()`：子 -> 父

常见用法：
- `_ready()`：构建 UI、连信号、应用样式。
- `_exit_tree()`：清理 overlay/timer/tween 引用。

## 2) Base Class Selection

- `PanelContainer`：有内容容器 + 主题样式。
- `VBoxContainer/HBoxContainer`：线性布局组件。
- `Control + _draw()`：需要自绘（进度环、开关、评分等）。
- `Node`：无视觉 overlay 管理器（Toast/Drawer/Popover）。

## 3) Control Essentials

- `mouse_filter`:
  - `STOP`：拦截输入。
  - `PASS`：继续传递。
  - `IGNORE`：忽略输入。
- `custom_minimum_size`：参与容器布局的最小尺寸。
- `size_flags_horizontal/vertical`：扩展与填充。

## 4) Container Essentials

- 容器会覆盖子控件 `position/size`。
- `HBox/VBox`：`separation` 控间距。
- `ScrollContainer`：直接子节点必须唯一。

## 5) Signal Pattern

```gdscript
button.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	pass
```

- 多次构建时避免重复连接。
- 销毁前可检查连接状态再断开（需要时）。

## 6) SceneTree Utilities

```gdscript
var root := get_tree().root
var vp_size := root.get_visible_rect().size
await get_tree().process_frame
```

## 7) Groups Quick Use

```gdscript
add_to_group("themeables")
get_tree().call_group("themeables", "refresh")
```

## 8) Overlay Node Pattern

```gdscript
func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == "_MyLayer":
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name = "_MyLayer"
	layer.layer = 104
	root.add_child(layer)
	return layer
```

## 9) Safety Pattern

```gdscript
if is_instance_valid(node):
	node.queue_free()
```

- 异步回调/动画回调中必做有效性检查。

## 10) Common Node Pitfalls

- `add_child` 失败：节点已有父节点，先 `remove_child`。
- `Node not found`：路径相对关系错误，优先 `get_node_or_null`。
- class_name 初次使用报错：先启动编辑器触发扫描。
