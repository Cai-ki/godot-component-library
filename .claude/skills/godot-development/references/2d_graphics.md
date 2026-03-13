# Godot 绘制、CanvasLayer 与动画

> 本文档聚焦于 UI 组件库实际使用的内容：CanvasLayer Overlay 模式、自定义 _draw() 控件、Tween 动画。

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
        if child.name == &"_MyLayer":
            return child as CanvasLayer
    var layer := CanvasLayer.new()
    layer.name  = "_MyLayer"
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

### 关键注意事项

- Overlay 组件本身留在原场景树（`extends Node`），随页面销毁自动清理
- `show_xxx()` 时在 CanvasLayer 中**动态创建**内容面板
- 内容面板位置用 `get_global_rect()` + 视口边界 clamp 防止超出屏幕
- 不用时 `queue_free()` 内容面板即可，不需要删除 CanvasLayer（复用）

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
```

---

## 自定义绘制 (_draw)

### 适用场景

- 圆形控件（UIAvatar — 圆形头像 + 状态点）
- 自定义线条控件（UIDivider — 带文字的分割线）
- 任何 StyleBoxFlat 无法实现的形状

### 基本用法

```gdscript
class_name MyWidget
extends Control   # 或 Node2D

func _ready() -> void:
    custom_minimum_size = Vector2(100, 100)  # 必须设置，否则尺寸为 0

func _draw() -> void:
    var center := size / 2.0                 # size 是当前控件尺寸

    # 圆形
    draw_circle(center, 40.0, Color("#6C63FF"))

    # 矩形（filled）
    draw_rect(Rect2(Vector2.ZERO, size), Color("#1C1F2E"))

    # 矩形（outline）
    draw_rect(Rect2(Vector2.ZERO, size), Color("#2A2D3E"), false, 1.0)

    # 线条
    draw_line(Vector2(0, size.y/2), Vector2(size.x, size.y/2), Color("#2A2D3E"), 1.0)

    # 文字
    var font := ThemeDB.fallback_font
    var font_size := 14
    var text := "AB"
    var tsz := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
    var pos := center + Vector2(-tsz.x * 0.5, tsz.y * 0.3)   # 垂直居中修正
    draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)
```

### 触发重绘

```gdscript
# 属性改变时触发重绘
@export var bg_color: Color = Color.RED:
    set(v): bg_color = v; queue_redraw()   # 标记下一帧重绘

# 也可以直接调用
queue_redraw()
```

### _draw 的 size

- `size` 是控件当前实际尺寸（由容器或锚点决定）
- `custom_minimum_size` 设置最小尺寸，_draw 中用 `size` 而非 `custom_minimum_size`
- 控件 resize 时 `_draw` 自动重新调用

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
```
