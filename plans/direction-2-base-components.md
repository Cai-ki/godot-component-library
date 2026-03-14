# Direction 2: 缺失的基础组件 ✅ 已交付

> **交付日期**: 2026-03-14 | **新增组件**: 7 个 | **累计组件数**: 43

## 交付清单

| 组件 | 状态 | Demo 位置 |
|------|------|----------|
| UINumberInput | ✅ | Form Inputs |
| UITextArea | ✅ | Form Inputs |
| UISegmentedControl | ✅ | Form Inputs |
| UIRating | ✅ | Form Inputs |
| UIDropdown | ✅ | Navigation |
| UIPopover | ✅ | Navigation |
| UICarousel | ✅ | Data & Display |

## 目标

补齐常见 UI 组件库中有但本项目尚缺的基础组件，提升库的完整度。

## 新增组件清单

### 2.1 UIDropdown
- **类型**: 通用下拉菜单（区别于 UISelect 的表单选择器）
- **继承**: Node（Overlay 架构）
- **CanvasLayer**: `_UIDropdownLayer` (107)
- **功能**:
  - 挂载到任意 Control，点击触发下拉
  - 支持 item 分组、分隔线、图标前缀
  - 支持嵌套子菜单（可选）
  - 键盘导航（上下箭头 + Enter）
- **信号**: `item_selected(id: String)`
- **与 UIContextMenu 区别**: Dropdown 绑定到特定触发器，ContextMenu 由右键触发

### 2.2 UIPopover
- **类型**: 气泡弹出框
- **继承**: Node（Overlay 架构）
- **CanvasLayer**: `_UIPopoverLayer` (108)
- **功能**:
  - 挂载到任意 Control，点击/悬停触发
  - 弹出位置自动计算（top/bottom/left/right），避免超出屏幕
  - 可放置任意 Control 内容（比 Tooltip 更重）
  - 带小三角箭头指向触发器
  - 点击外部自动关闭
- **信号**: `opened`, `closed`
- **与 UITooltip 区别**: Popover 可放交互内容（按钮、表单），Tooltip 只放文字

### 2.3 UINumberInput
- **类型**: 数字输入框
- **继承**: HBoxContainer
- **功能**:
  - 带 -/+ 按钮的数字输入
  - @export: min_value, max_value, step, value, disabled
  - 长按按钮持续增减
  - 支持直接键盘输入数字
  - 可选前缀/后缀标签（如 "¥", "%"）
- **信号**: `value_changed(new_value: float)`

### 2.4 UITextArea
- **类型**: 多行文本输入
- **继承**: PanelContainer
- **功能**:
  - 内部使用 TextEdit
  - @export: placeholder, text, max_lines, readonly, disabled
  - 样式与 UIInput 保持一致（同系列设计语言）
  - 焦点态边框高亮
  - 可选字符计数器
- **信号**: `text_changed(new_text: String)`

### 2.5 UISegmentedControl
- **类型**: 分段选择器（类似 iOS 风格 / 按钮组单选）
- **继承**: PanelContainer
- **功能**:
  - 水平排列的多选一按钮组
  - @export: items (PackedStringArray), selected_index
  - 选中项带平滑滑块动画
  - 支持 disabled 单项或整体
  - 多尺寸: SM / MD / LG
- **信号**: `selection_changed(index: int)`
- **与 UITabs 区别**: SegmentedControl 是嵌入式表单控件，Tabs 是页面级容器

### 2.6 UIRating
- **类型**: 星级评分
- **继承**: HBoxContainer
- **功能**:
  - @export: value (float), max_stars (int), readonly, size
  - 支持半星评分（可选）
  - 悬停预览效果
  - 使用 `_draw()` 绘制星形，或 Unicode ★☆
  - 可自定义图标（心形等）
- **信号**: `rating_changed(new_value: float)`

### 2.7 UICarousel
- **类型**: 轮播图 / 内容滑动器
- **继承**: Control
- **功能**:
  - 水平滑动切换子 Control
  - @export: auto_play, interval, show_indicators, show_arrows
  - 滑动过渡动画（Tween）
  - 底部圆点指示器
  - 左右箭头按钮
  - 支持无限循环
- **信号**: `slide_changed(index: int)`

## Demo 页面规划

### 方案 A: 一页展示
- 新增 `scripts/pages/extra_components_page.gd`
- 侧边栏 EXTENDED 分区新增 "Extra" 入口
- 7 个组件各一个 section 展示

### 方案 B: 两页展示
- `scripts/pages/inputs_extra_page.gd` — NumberInput / TextArea / SegmentedControl / Rating
- `scripts/pages/overlays_page.gd` — Dropdown / Popover / Carousel
- 侧边栏分别放入 COMPONENTS 和 INTERACTIVE 分区

## 依赖关系
- 所有组件仅依赖 `UITheme`
- Overlay 类组件遵循现有 CanvasLayer 架构
- 与现有组件无耦合

## 风险点
- UICarousel 的滑动手势在 Godot 中实现较复杂
- UIPopover 箭头定位计算需要考虑边界情况
- UIDropdown 嵌套子菜单增加复杂度，可首版跳过
