# Component Library API (Condensed)

本文件是组件库 API 的精简索引版，目标是：
- 快速查“用什么组件/函数”；
- 减少上下文体积；
- 把细节查询交给源码定位（`components/*/*.gd`）。

## 1) Design Tokens (`scripts/theme.gd`)

`class_name UITheme`

### 颜色层级
- `BG`
- `SURFACE_1` ~ `SURFACE_4`
- `BORDER` / `BORDER_LIGHT` / `BORDER_STRONG`

### 状态色（含变体）
- `PRIMARY / SECONDARY / SUCCESS / WARNING / DANGER / INFO`
- 每种都有：`BASE / DARK / LIGHT / SOFT`

### 文本
- `TEXT_PRIMARY / TEXT_SECONDARY / TEXT_MUTED / TEXT_INVERSE`

### 尺寸 Token
- 字号：`FONT_XS` ~ `FONT_3XL`
- 圆角：`RADIUS_XS` ~ `RADIUS_PILL`
- 间距：`SP_1` ~ `SP_8`

## 2) Helper API (`scripts/helpers.gd`)

`class_name UI`

### 样式工厂
- `UI.style(...) -> StyleBoxFlat`
- `UI.style_left_border(...) -> StyleBoxFlat`

### 按钮工厂
- `UI.solid_btn(...)`
- `UI.outline_btn(...)`
- `UI.soft_btn(...)`
- `UI.ghost_btn(...)`

### 布局工具
- `UI.hbox(...)`
- `UI.vbox(...)`
- `UI.spacer(...)`
- `UI.h_expand(...)`
- `UI.sep(...)`

### 页面结构
- `UI.page_header(...)`
- `UI.section(...)`
- `UI.label(...)`（不自动 add_child）

### 卡片
- `UI.card(parent, ...) -> VBoxContainer`
- `UI.hoverable_card(parent, ...) -> VBoxContainer`

### 其他
- `UI.badge(...) / UI.outline_badge(...) / UI.soft_badge(...)`
- `UI.styled_input(...)`
- `UI.progress_bar(...)`
- `UI.alert(...)`
- `UI.glass_backdrop(parent, blur_amount, dimmed_color) -> ColorRect`

## 3) 页面结构约束

标准 section 结构：
```gdscript
UI.section(parent, "Section Title")
var card_v := UI.card(parent, 24, 20)
var row := UI.hbox(card_v, 12)
```

不要把内容直接挂到 `parent`（Cards 页面除外）。

## 4) 组件索引（43）

### 基础
- `UIButton` (`components/button/ui_button.gd`)
- `UICard` (`components/card/ui_card.gd`)
- `UIInput` (`components/input/ui_input.gd`)
- `UIBadge` (`components/badge/ui_badge.gd`)
- `UIAlert` (`components/alert/ui_alert.gd`)
- `UIProgress` / `UIProgressRing`

### 表单
- `UISelect`
- `UITextArea`
- `UINumberInput`
- `UISlider`
- `UICheckbox`
- `UIRadio` / `UIRadioGroup`
- `UISwitch`
- `UIRating`
- `UISegmentedControl`

### 导航/展示
- `UITabs`
- `UIAccordion`
- `UIPagination`
- `UIBreadcrumb`
- `UITimeline`
- `UICarousel`
- `UITable`
- `UITreeView`

### 视觉/信息
- `UIAvatar`
- `UIDivider`
- `UITag`
- `UIChip`
- `UINotificationBadge`
- `UISteps`
- `UIEmpty`
- `UISkeletonLoader`
- `UIColorPicker`

### Overlay（CanvasLayer）
- `UIToast` (100)
- `UITooltip` (101)
- `UIContextMenu` (102)
- `UISelect` (103)
- `UIDrawer` (104)
- `UIDatePicker` (105)
- `UICommandPalette` (106)
- `UIDropdown` (107)
- `UIPopover` (108)

### 场景级
- `UIModal`

## 5) 主题切换 API

`UIThemePresets` (`scripts/theme_presets.gd`)
- `apply_dark_indigo()`
- `apply_slate()`
- `apply_stone()`
- `apply_light()`
- `apply_midnight()`

建议在切换后重建当前页面节点（而不是依赖动态绑定）。

## 6) 常见实现约定

- setter 统一守卫：`if is_inside_tree(): _apply_styles()`。
- 重建型 setter 用 `call_deferred()`（防 locked object）。
- Overlay show/hide 需幂等。
- Overlay 定位先 clamp，再做入场动画。

## 7) 详情查询方式（替代超长文档）

当需要精确签名或行为细节时：
1. 先定位组件文件：`components/<name>/ui_<name>.gd`
2. 查看导出属性：`@export var`
3. 查看公共 API：`func`（非 `_` 开头）
4. 查看信号：`signal`
5. 查看 `_ready/_build/_apply_styles` 理解初始化与刷新时序

推荐命令：
```bash
rg -n "^class_name|^signal|^@export var|^func [a-zA-Z]" components/<name>/ui_<name>.gd
```
