# Direction 5: 基础设施增强

## 目标

提升组件库的整体体验质量和专业度，包括动画、响应式、可访问性等基础能力。

## 增强项清单

### 5.1 统一动画系统
- **目标**: 为组件提供一致的进入/退出/过渡动画
- **实现方式**: 新建 `scripts/animation.gd` — `class_name UIAnimation`
- **核心 API**:
  ```gdscript
  # 进入动画
  UIAnimation.fade_in(node, duration)
  UIAnimation.slide_in(node, direction, duration)
  UIAnimation.scale_in(node, duration)
  UIAnimation.bounce_in(node, duration)

  # 退出动画
  UIAnimation.fade_out(node, duration, then_free)
  UIAnimation.slide_out(node, direction, duration)

  # 过渡
  UIAnimation.crossfade(old_node, new_node, duration)

  # 列表动画 (stagger)
  UIAnimation.stagger(nodes: Array[Control], animation: StringName, delay: float)
  ```
- **设计令牌** (theme.gd 新增):
  ```gdscript
  const DURATION_FAST := 0.15
  const DURATION_NORMAL := 0.25
  const DURATION_SLOW := 0.4
  const EASE_DEFAULT := Tween.EASE_OUT
  const TRANS_DEFAULT := Tween.TRANS_CUBIC
  ```
- **应用场景**:
  - 页面切换时内容淡入
  - Modal / Drawer / Toast 的出现/消失
  - 列表项依次进入（stagger 效果）
  - 主题切换过渡

### 5.2 响应式布局系统
- **目标**: 根据窗口尺寸自动调整布局
- **实现方式**: 新建 `scripts/responsive.gd` — `class_name UIResponsive`
- **断点定义**:
  ```gdscript
  const BREAKPOINT_SM := 640
  const BREAKPOINT_MD := 1024
  const BREAKPOINT_LG := 1440
  const BREAKPOINT_XL := 1920
  ```
- **核心功能**:
  - `UIResponsive.watch(callback: Callable)` — 窗口尺寸变化时回调
  - `UIResponsive.current_breakpoint() -> String` — 返回 "sm" / "md" / "lg" / "xl"
  - 自动隐藏/显示侧边栏（小屏幕时折叠为汉堡菜单）
  - 网格列数自适应
- **对 main.gd 的影响**:
  - 小屏: 侧边栏折叠，点击汉堡按钮弹出 UIDrawer
  - 中屏: 侧边栏收窄（只显示图标）
  - 大屏: 完整侧边栏（当前状态）

### 5.3 Focus 管理与键盘导航
- **目标**: 提升无障碍访问和键盘操作体验
- **实现内容**:
  - Tab 键在表单元素间切换焦点
  - 焦点环样式统一（2px PRIMARY 色外框）
  - Escape 键关闭所有 Overlay 组件
  - Enter 键触发默认按钮
  - 方向键在列表/菜单中导航
- **影响范围**: UIInput, UISelect, UIButton, UIModal, UIDrawer, UIContextMenu, UICommandPalette
- **实现**: 各组件内部增强 `_gui_input()` / `_unhandled_key_input()`

### 5.4 主题定制器
- **目标**: 运行时可视化调整主题颜色
- **实现**: 新建组件 `components/theme_editor/ui_theme_editor.gd`
- **功能**:
  - 左侧: 颜色分类面板（品牌色 / 状态色 / 背景色 / 文字色）
  - 每个颜色: UIColorPicker 选择 + 预览色块
  - 右侧: 实时预览（几个示例组件）
  - 导出: 生成 GDScript 代码片段
  - 重置: 恢复到预设主题
- **关联页面**: 可以集成到现有 Themes 页面，或新建独立页面

### 5.5 国际化框架 (i18n)
- **目标**: 为组件内置文本提供多语言支持
- **实现**: 新建 `scripts/i18n.gd` — `class_name UIi18n`
- **范围**:
  - 组件内置文本: "Cancel" / "OK" / "Search..." / "No results" 等
  - 日期格式: UIDatePicker 的月份名、星期名
  - 数字格式: 千位分隔符
- **方式**: Dictionary 映射，支持运行时切换语言
- **注意**: 这是轻量级方案，不是完整的翻译系统

## 实现策略

### 阶段 1: 动画系统（独立，无依赖）
- 实现 UIAnimation 静态工具类
- 将现有 Overlay 组件的硬编码动画迁移过来
- 新增 Animations 页面 demo 增强

### 阶段 2: 响应式系统（需要改动 main.gd）
- 实现断点检测
- 改造侧边栏响应式行为
- 页面内容区网格自适应

### 阶段 3: 键盘导航（逐组件增强）
- 统一焦点环样式
- 逐个组件添加键盘支持
- 测试 Tab 序列

### 阶段 4: 主题定制器 + i18n（锦上添花）
- 依赖 UIColorPicker 已完成（已有）
- i18n 可以最后做

## 风险点

1. **响应式改造 main.gd**: 影响面大，需要仔细测试各断点
2. **键盘导航**: 需要统一 focus 行为，可能与现有鼠标交互冲突
3. **动画性能**: stagger 大量节点时需注意 Tween 数量
4. **i18n**: Godot 有内置 TranslationServer，但与我们的纯代码架构不太搭

## 优先级

| 项目 | 难度 | 影响面 | 优先级 |
|------|------|--------|--------|
| 动画系统 | 中 | 高 | P0 — 体验提升最明显 |
| 响应式 | 高 | 高 | P1 — demo 亮点 |
| 键盘导航 | 中 | 中 | P2 |
| 主题定制器 | 中 | 低 | P2 |
| i18n | 低 | 低 | P3 |
