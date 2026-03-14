# Direction 3: 数据展示增强

## 目标

通过纯 GDScript + `_draw()` 实现数据可视化组件，展示 Godot 原生绘图能力，
形成与 HTML/CSS 组件库的差异化竞争力。

## 新增组件清单

### 3.1 UIChart
- **类型**: 基础图表组件
- **继承**: Control（使用 `_draw()` 自定义绘制）
- **图表类型**:
  - **Bar Chart**: 垂直/水平柱状图
  - **Line Chart**: 折线图，支持多数据系列
  - **Pie Chart**: 饼图 / 环形图（Donut）
- **功能**:
  - `set_data(data: Array[Dictionary])` — 数据驱动
  - 自动计算坐标轴刻度
  - 可选: 网格线、图例、数据标签
  - 颜色自动分配（使用 UITheme 状态色）
  - 动画: 数据更新时的过渡动画（Tween + queue_redraw）
  - 悬停显示数值（结合 `_gui_input` 检测鼠标位置）
- **信号**: `point_clicked(series: int, index: int)`
- **示例**:
  ```gdscript
  var chart := UIChart.new()
  chart.chart_type = UIChart.Type.LINE
  chart.set_data([
      {"label": "Jan", "value": 120},
      {"label": "Feb", "value": 200},
      {"label": "Mar", "value": 150},
  ])
  ```

### 3.2 UICalendar
- **类型**: 完整日历视图
- **继承**: VBoxContainer
- **功能**:
  - 月视图: 7 列 × 5-6 行网格
  - 头部: 月份年份 + 前后月切换按钮
  - @export: selected_date, min_date, max_date
  - 日期单元格可自定义内容（事件标记）
  - 支持日期范围选择（可选）
  - 今天高亮 + 选中高亮
- **信号**: `date_selected(date: Dictionary)`, `month_changed(year: int, month: int)`
- **与 UIDatePicker 区别**: Calendar 是始终可见的视图组件，DatePicker 是表单控件

### 3.3 UIKanban
- **类型**: 看板视图
- **继承**: HBoxContainer
- **功能**:
  - 多列布局，每列一个状态分类
  - 列头: 标题 + 计数 + 添加按钮
  - 卡片: 标题 + 描述 + 标签 + 头像
  - 可选: 拖拽排序（Godot 拖放 API）
  - 可选: 列内滚动
- **信号**: `card_moved(card_id: String, from_column: String, to_column: String)`
- **复杂度较高**: 可考虑作为 Scene 示例而非独立组件

### 3.4 UIVirtualList
- **类型**: 虚拟滚动列表
- **继承**: Control
- **功能**:
  - 只渲染可视区域内的行，支持万级数据
  - `set_item_count(count: int)` + `item_renderer: Callable`
  - 固定行高模式（简单）和动态行高模式（复杂）
  - 滚动位置保持、跳转到指定索引
- **信号**: `item_visible(index: int)`, `item_clicked(index: int)`
- **技术难点**: 需要精确计算 ScrollContainer 偏移量

### 3.5 UIStatCard
- **类型**: 统计数据卡片
- **继承**: PanelContainer
- **功能**:
  - @export: title, value, subtitle, trend (UP/DOWN/NEUTRAL), trend_value
  - 大号数字 + 趋势箭头（绿上/红下）
  - 可选: 底部迷你折线图（sparkline，使用 `_draw()`）
  - 可选: 图标
  - 多布局: horizontal / vertical
- **用途**: Dashboard 场景中替代手写统计卡片

## Demo 页面规划

### 页面 1: Charts & Visualization
- `scripts/pages/charts_page.gd`
- 展示 UIChart 的三种图表类型
- 展示 UIStatCard 的各种变体
- 侧边栏: EXTENDED 或新建 DATA 分区

### 页面 2: Advanced Data
- `scripts/pages/advanced_data_page.gd`
- 展示 UICalendar + UIVirtualList
- UIKanban 如果作为组件也在此展示
- 或 UIKanban 作为 Scene 放入 SCENES 分区

## 技术挑战

1. **UIChart `_draw()`**: 坐标计算、反锯齿线条（`draw_line` 的 antialiased 参数）
2. **UIVirtualList**: ScrollContainer 内容区高度欺骗 + 动态创建/回收节点
3. **UIKanban 拖拽**: `_get_drag_data()` / `_can_drop_data()` / `_drop_data()` 实现
4. **性能**: Chart 动画中频繁 `queue_redraw()` 需要注意帧率

## 复杂度评估

| 组件 | 难度 | 工作量 | 优先级 |
|------|------|--------|--------|
| UIStatCard | 低 | 小 | P0 — 简单且实用 |
| UIChart (Bar) | 中 | 中 | P0 — 核心亮点 |
| UIChart (Line) | 中 | 中 | P0 |
| UIChart (Pie) | 中 | 中 | P1 |
| UICalendar | 中 | 中 | P1 |
| UIVirtualList | 高 | 大 | P2 |
| UIKanban | 高 | 大 | P2 — 可降级为 Scene |
