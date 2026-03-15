# Workflow：创建新展示页面

> 完整的页面开发流程，从创建文件到注册导航。

---

## 步骤 1：创建页面文件

文件路径：`scripts/pages/{page_name}_page.gd`

### 页面骨架模板

```gdscript
class_name MyFeaturePage
extends RefCounted

func build(parent: Control) -> void:
    # 页面标题
    UI.page_header(parent, "My Feature", "Description of this page.")

    # ─── Section 1 ───
    UI.section(parent, "Basic Usage")
    var card1 := UI.card(parent, 24, 20)

    # 内容加到 card1（VBoxContainer），不加到 parent
    var row := UI.hbox(card1, 12)
    # ... 组件 demo

    # ─── Section 2 ───
    UI.section(parent, "Variants")
    var card2 := UI.card(parent, 24, 20)

    var row2 := UI.hbox(card2, 16)
    # ... 更多 demo

    # ─── Section 3（可选：交互 demo）───
    UI.section(parent, "Interactive")
    var card3 := UI.card(parent, 24, 20)
    # ...
```

---

## 步骤 2：填充 Section 内容

### 标准 Section 结构（必须遵守）

```gdscript
# ✅ 正确：section 标签在外，内容包入卡片
UI.section(parent, "Section Title")
var card_v := UI.card(parent, 24, 20)
var row := UI.hbox(card_v, 12)        # 内容加到 card_v
UIButton.new()  # 实例化组件后加到 row

# ❌ 错误 1：内容直接加到 parent（无层次感）
UI.section(parent, "Section Title")
var row := UI.hbox(parent, 12)         # 没有卡片包裹

# ❌ 错误 2：section 放在 card 里面
var card_v := UI.card(parent, 24, 20)
UI.section(card_v, "Title")            # section 应在 card 外面
```

### 组件优先原则

优先使用现有组件，而非手写等价结构：

```gdscript
# ✅ 用组件
var avatar := UIAvatar.new()
avatar.initials = "JD"
avatar.avatar_size = UIAvatar.AvatarSize.LG
row.add_child(avatar)

# ❌ 手写等价结构
var circle := Control.new()
circle.custom_minimum_size = Vector2(52, 52)
# ... 一堆 _draw 代码
```

### 常见 Demo 模式

#### 横排展示多个变体
```gdscript
UI.section(parent, "Button Variants")
var card_v := UI.card(parent, 24, 20)
var row := UI.hbox(card_v, 12)

var solid := UIButton.new()
solid.text = "Solid"
solid.variant = UIButton.Variant.SOLID
solid.color_scheme = UIButton.ColorScheme.PRIMARY
row.add_child(solid)

var outline := UIButton.new()
outline.text = "Outline"
outline.variant = UIButton.Variant.OUTLINE
outline.color_scheme = UIButton.ColorScheme.PRIMARY
row.add_child(outline)
```

#### 说明文字 + 交互组件
```gdscript
UI.section(parent, "Interactive Demo")
var card_v := UI.card(parent, 24, 20)

var desc := UI.label("Click the button to show a toast notification.")
desc.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
card_v.add_child(desc)

UI.spacer(card_v, 8)

var btn := UI.solid_btn(card_v, "Show Toast", UITheme.PRIMARY)
var toast := UIToast.new()
card_v.add_child(toast)
btn.pressed.connect(func():
    toast.show_toast("Hello!", UIToast.ToastType.SUCCESS)
)
```

#### Grid 展示（颜色/图标矩阵）
```gdscript
UI.section(parent, "Color Schemes")
var card_v := UI.card(parent, 24, 20)

var grid := GridContainer.new()
grid.columns = 4
grid.add_theme_constant_override("h_separation", 12)
grid.add_theme_constant_override("v_separation", 12)
card_v.add_child(grid)

for scheme in [UIButton.ColorScheme.PRIMARY, UIButton.ColorScheme.SUCCESS,
               UIButton.ColorScheme.WARNING, UIButton.ColorScheme.DANGER]:
    var btn := UIButton.new()
    btn.text = "Button"
    btn.color_scheme = scheme
    grid.add_child(btn)
```

---

## 步骤 3：注册到 main.gd

### 3.1 添加侧边栏按钮

在 `scripts/main.gd` 的 `_build_sidebar()` 函数中，找到对应分区，添加按钮：

```gdscript
# 在合适的分区下添加
_sidebar_btn(sidebar_vbox, "My Feature", "my_feature")
```

`_sidebar_btn` 的参数：`(parent, display_text, page_id)`

### 3.2 添加导航路由

在 `_navigate_to()` 的 `match` 语句中添加：

```gdscript
match page_id:
    # ... 已有路由 ...
    "my_feature":
        MyFeaturePage.new().build(content_vbox)
```

### 侧边栏分区

```
Overview (home)
─── COMPONENTS ───
  Buttons, Cards, Form Inputs, Badges & Tags, Alerts, Progress
─── INTERACTIVE ───
  Navigation, Data & Display, Modals, Form Validation
─── DESIGN ───
  Themes, Shapes, Layouts, Animations
─── EXTENDED ───
  Extended, Advanced
─── SCENES ───
  Login Form, Dashboard, Settings
```

---

## 步骤 4：运行验证

```
1. mcp__godot__launch_editor()     ← 如果有新 class_name
2. mcp__godot__run_project()
3. mcp__godot__get_debug_output()  ← 检查错误
4. 点击侧边栏按钮验证页面渲染
5. mcp__godot__stop_project()
```

---

## 特殊情况处理

### Cards 页（例外：不套 UI.card）

Cards 页的内容本身就是卡片展示，若外套 `UI.card()` 会产生同背景色嵌套。
这是唯一合理省略 section 卡片包裹的页面。

### UIModal Demo

```gdscript
# ⚠️ modal 必须 add_child 到 parent（不是 card_v）
# 因为 show_modal() 会将其 reparent 到 get_tree().root
var modal := UIModal.new()
modal.title_text = "Confirm"
parent.add_child(modal)           # ← parent，不是 card_v

# Demo 卡片（触发按钮）才加到 card_v
UI.section(parent, "Modal Demo")
var card_v := UI.card(parent, 24, 20)
var btn := UI.solid_btn(card_v, "Open Modal", UITheme.PRIMARY)
btn.pressed.connect(modal.show_modal)
```

### UIInput/UISelect 属性赋值时序

```gdscript
# ⚠️ text/selected_index 等属性需要 _ready() 后赋值
var inp := UIInput.new()
card_v.add_child(inp)              # 先加入场景树
inp.text = "Default Value"         # 再赋值

# 如果用 UITabs：
tabs.add_tab("Profile", tab_content)   # 先加 tab（触发 _ready）
inp.text = "Jordan"                     # 再赋值
```

### Overlay 组件（UIToast/UITooltip/UIDrawer 等）

```gdscript
# Overlay 组件加到 card_v 即可（自身是 Node/VBoxContainer，不影响）
# show 时会自动在 CanvasLayer 中创建内容
var toast := UIToast.new()
card_v.add_child(toast)            # 随 card_v 生命周期自动清理
toast.show_toast("Hello!")
```

---

## Checklist

- [ ] 文件放在 `scripts/pages/{name}_page.gd`
- [ ] `class_name {Name}Page extends RefCounted`
- [ ] 入口方法 `func build(parent: Control) -> void`
- [ ] 每个 section 使用标准结构：`UI.section()` + `UI.card()`
- [ ] 内容加到 `card_v`（UI.card 的返回值），不加到 `parent`
- [ ] 优先使用现有组件，不手写等价结构
- [ ] Modal 加到 `parent`，不加到 `card_v`
- [ ] UIInput/UISelect 在进入场景树后赋值
- [ ] 在 `main.gd` 的 `_build_sidebar()` 中添加按钮
- [ ] 在 `main.gd` 的 `_navigate_to()` 中添加路由
- [ ] 首次运行前 `launch_editor` 注册 class_name
