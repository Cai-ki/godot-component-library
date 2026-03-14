# Godot 组件库 UI 美化与美术设计优化方向

这是一份关于当前拥有40余个基础组件（如Button, Modal, Input等）的Godot UI库的视觉与交互升级计划草案。我们可以在此基础上逐步完善这些细节。

## 1. 整体设计系统规范 (Design System)
*   **✅ 统一色彩管理 (Color Palette)**：定义了主色(Primary)、辅色(Secondary)以及功能色(Success, Warning, Error, Info)。已优化为更现代、更具“高级感”的配色方案。支持**亮/暗主题 (Light/Dark Mode) 无缝切换**。暗色模式采用深蓝黑底色(`#0B0C10`)，提升了视觉对比度与深度感。
*   **现代排版 (Typography)**：统一组件内的字体族 (Font Family)、字号阶梯式缩放和字重 (Weights)。建议默认打包一种现代无衬线字体（如 Inter, Roboto 或 霞鹜文楷/思源黑体等开源字体）。
*   **圆角与几何 (Shapes & Radiuses)**：从老派的直角风格转换为带有物理隐喻的圆角边缘 (如 4px, 6px, 8px)。保持大组件（Card、Modal）圆角大，内部小组件（Button、Tag）圆角小，遵循内嵌视觉规则。

## 2. 交互动效与反馈 (Micro-Interactions)
*   **缓动过渡 (State Transitions)**：拒绝原生的“瞬间切图”。Hover、Pressed 和 Focus 状态的切换应依赖于 Godot 的 `Tween` 实现透明度、颜色的毫秒级平滑过渡（推荐 `0.15s - 0.2s`）。
*   **物理隐喻反馈 (Tactile Feedback)**：✅ *(已在 UIButton 实现)* 通过微型形变（按下时 `scale` 至 `0.97`）或涟漪效果 (Ripple effect) 给用用户强烈的“按击实感”。防抖使用了像素取整与旧 Tween 拦截技术。
*   **展开与折叠 (Expand/Collapse)**：✅ 已优化。针对 `UIAccordion` (折叠面板)、`UIDropdown` (下拉菜单) 实现了基于 `Tween` 的像素级顺滑展开及透明度过渡，拒绝“瞬间闪现”。

### 🔥 下一步高优推荐方向 (Next High-Impact Steps)
如果我们想要马上看到显著的页面视觉或交互提升，我强烈建议在此基础上优先推进以下三个点：

1. **✅ 毛玻璃遮罩层 (Glassmorphism Overlay)**
   * *(已在 Modal、Drawer、Command Palette 中实现)* 通过注入屏幕空间着色器的 `UI.glass_backdrop` 方法，完美展现了高级半透明遮罩质感。

2. **✅ 表单输入框的“故障动效” (Form Error Shake)**
   * **当前问题**：`UIInput` 输入文本错误或密码错时，通常只有边框变红，不够生动。
   * **改造方案**：已在 `UI.shake()` 中实现，并在 `UIInput` (验证错误) 和 `UINumberInput` (非法输入) 中集成。

3. **✅ 引入全局现代字体 (Global Modern Font)**
   * **当前问题**：引擎内往往使用随附的普通系统字体渲染，缺少“网页”的干练感。
   * **改造方案**：已在 `theme.gd` 增加字体预留位，并更新了 `helpers.gd` 和核心组件。只需在入口脚本为 `UITheme.FONT_SANS` 赋值（如 `Inter` 字体），全库即可自动无缝应用。

## 3. 质感与空间层级 (Texture & Spatial/Depth)
*   **多维阴影体系 (Drop Shadows)**：基于 Z 轴高度的不同建立阴影规范。Card 处于较低层级（轻阴影），Popover / Dropdown 为中层级，Modal / Toast 位于最高层级（大范围柔和散布的深色阴影）。
*   **毛玻璃/亚克力材质 (Glassmorphism)**：可以利用 Godot 的 `BackBufferCopy` 和屏幕空间模糊 Shader，在 Context Menu、Drawer 或 Modal 的背景层使用半透明+背景模糊，大幅提升 UI 现代感和质感表现力。

## 4. 易用性与细节状态 (Accessibility & State)
*   **禁用模式 (Disabled States)**：统一的禁用滤镜/透明度降级，并更改鼠标光标为不可用。
*   **无障碍焦点 (Focus Rings)**：✅ 已实现。为了兼容手柄和键盘 UI 导航，`UIButton`, `UIInput`, `UIAccordion` 等所有可交互组件现已拥有一致的外发光圈 (Focus Ring) 视觉提示。
*   **错误振动 (Error Shake)**：对于 Input, Number Input 等组件，遇到校验错误时除了外框变红，可以搭配轻微的横向抖动特效。

## 5. 美术资源 (Art Assets)
*   **矢量化图标 (SVG Iconography)**：全库摒弃位图，改用统一风格的 SVG 图标库（建议从如 Phosphor Icons, Lucide 或 Material Symbols 引入），确保在任何 DPI（高分屏）下绝对清晰且可以轻松用 `modulate` 改色。
*   **统一光标 (Custom Cursors)**：对可以拖拽的 Slider、可以调整大小的区域等，显式地应用符合语境的鼠标光标类型。

---
*备注：本文件将作为后续 UI 改版的参考蓝图，后续具体实现时可细化至相关组件代码。*
