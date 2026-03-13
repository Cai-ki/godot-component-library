# Godot 节点类型速查

> 本文档聚焦于 UI 组件库开发所需节点，已移除 3D/物理/音频等无关内容。

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

> **容器重要原则**：子节点无法手动设置 position/size，由容器控制；通过 Size Flags 和 `custom_minimum_size` 影响布局。

### 显示控件

| 节点 | 用途 | 常用属性 |
|------|------|----------|
| **Label** | 文本显示 | `text`, `autowrap_mode`, `horizontal_alignment` |
| **RichTextLabel** | 富文本（BBCode） | `bbcode_enabled`, `text` |
| **TextureRect** | 图片显示 | `texture`, `stretch_mode` |
| **ColorRect** | 颜色矩形 | `color`, `custom_minimum_size` |
| **ProgressBar** | 原生进度条 | `value`, `min_value`, `max_value` |

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

## 组件基类选择指南

| 场景 | 推荐基类 |
|------|----------|
| 需要自动适配内容尺寸 | `PanelContainer` 或 `VBoxContainer` |
| 需要自定义绘制 (`_draw()`) | `Control`（设置 `custom_minimum_size`） |
| 逻辑节点，无视觉 | `Node` |
| 继承 Button 行为 | `Button` 或 `BaseButton` |
| **不要用裸 `Control` 做布局容器** | 尺寸不自动计算 |

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
