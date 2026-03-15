# UI Layout (Condensed)

## 1) Core Rules

- 在容器中布局，不靠手动 `position/size`。
- 关键控件设置 `custom_minimum_size`。
- `ScrollContainer` 只放一个直接子节点。
- `SIZE_EXPAND_FILL` 用于占据剩余空间。

## 2) High-Frequency Containers

- `HBoxContainer` / `VBoxContainer`：主力布局。
- `GridContainer`：固定列网格。
- `MarginContainer`：统一内边距。
- `CenterContainer`：居中包裹。
- `PanelContainer`：承载 `StyleBox`。
- `ScrollContainer`：滚动区域。

## 3) Canonical Page Structure

```gdscript
var page := VBoxContainer.new()
page.size_flags_horizontal = Control.SIZE_EXPAND_FILL

UI.section(page, "Section")
var card_v := UI.card(page, 24, 20)
var row := UI.hbox(card_v, 12)
```

## 4) Anchors Presets

```gdscript
root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
center.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
```

- 全屏遮罩/背景用 `FULL_RECT`。
- 弹窗容器常用 `CenterContainer` 包裹。

## 5) Size Flags Quick Use

```gdscript
left.size_flags_horizontal = Control.SIZE_FILL
middle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
right.size_flags_horizontal = Control.SIZE_FILL
```

## 6) StyleBox Essentials

```gdscript
var s := StyleBoxFlat.new()
s.bg_color = UITheme.SURFACE_2
s.set_corner_radius_all(UITheme.RADIUS_MD)
s.border_width_left = 1
s.border_width_top = 1
s.border_width_right = 1
s.border_width_bottom = 1
s.border_color = UITheme.BORDER
node.add_theme_stylebox_override("panel", s)
```

按钮三态：

```gdscript
btn.add_theme_stylebox_override("normal", normal_s)
btn.add_theme_stylebox_override("hover", hover_s)
btn.add_theme_stylebox_override("pressed", pressed_s)
```

## 7) Hover Patterns

非按钮：

```gdscript
panel.mouse_entered.connect(func(): panel.add_theme_stylebox_override("panel", hover_s))
panel.mouse_exited.connect(func(): panel.add_theme_stylebox_override("panel", normal_s))
```

## 8) Form Layout Pattern

```gdscript
var form := UI.vbox(parent, 12)
var input := UIInput.new()
form.add_child(input)
```

- `UIInput/UISelect` 等依赖 `_ready` 的属性，建议在 `add_child` 后赋值。

## 9) Overlay Layout Pattern

```gdscript
var overlay := UI.glass_backdrop(layer, 2.0, Color(0, 0, 0, 0.45))
overlay.mouse_filter = Control.MOUSE_FILTER_STOP
```

- 弹层面板放在 overlay 内部。
- 定位后先 clamp 到屏幕，再开入场动画。

## 10) Fast Layout Checklist

- 看起来不对：先打印 `size` 与 `custom_minimum_size`。
- 子节点挤压：检查 `SIZE_EXPAND_FILL` 与 `separation`。
- 不滚动：检查 `ScrollContainer` 是否只有 1 个直接子节点。
- 交互被挡：检查上层节点 `mouse_filter`。
