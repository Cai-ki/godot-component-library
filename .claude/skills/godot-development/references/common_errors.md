# Godot / GDScript 常见错误速查

> 格式：错误信息 → 原因 → 修复方案

---

## 运行时错误

### "Invalid call. Nonexistent function 'create_tween' in base 'RefCounted'"
**原因**: `create_tween()` 只在 `Node` 及其子类上可用，`RefCounted`（包括 extends RefCounted 的页面类）没有此方法。
**修复**: 调用被动画节点自身的 `create_tween()`：
```gdscript
# ❌ 在 RefCounted 中
var t := create_tween()

# ✅ 用目标节点的
var t := some_node.create_tween()
```

### "Invalid set index 'text' (on base: 'Nil') with value of type 'String'"
**原因**: 尝试设置 `null` 对象的属性。常见于 UIInput/UISelect 在 `_ready()` 之前赋值，内部控件尚未创建。
**修复**: 确保节点进入场景树后再赋值：
```gdscript
# ❌ _ready 还没触发
var inp := UIInput.new()
inp.text = "hello"              # _input 为 null

# ✅ 加入场景树后赋值
parent.add_child(inp)           # 触发 _ready
inp.text = "hello"              # 安全
```

### "Attempt to call function 'xxx' in base 'previously freed' on a null instance"
**原因**: 节点已被 `queue_free()` 或 `free()` 释放，但回调（Timer/Tween/信号）仍试图访问它。
**修复**: 在回调中检查 `is_instance_valid()`：
```gdscript
timer.timeout.connect(func():
    if is_instance_valid(node):
        node.text = "done"
)
```

### "Cannot convert argument X from 'Nil' to 'Object'"
**原因**: 传入的参数为 `null`，但函数期望非空对象。
**修复**: 添加 null 检查或确保参数在调用前已初始化。

### "Stack overflow" / 无限递归
**原因**: setter 内修改同一属性导致递归，或两个信号互相触发。
**修复**:
```gdscript
# ❌ setter 内赋值同一属性 → 无限递归
var value: float:
    set(v): value = v; self.value = clamp(v, 0, 1)

# ✅ 赋值给底层变量
var value: float:
    set(v): value = clamp(v, 0.0, 1.0)
```

### "Object is locked (cannot free while iterating)"
**原因**: 在 setter/信号回调中直接 `free()` 正在执行的节点（如按钮回调中重建包含该按钮的容器）。
**修复**: 使用 `call_deferred()` + `queue_free()`：
```gdscript
# ❌ 直接在回调中 free
btn.pressed.connect(func(): _rebuild())
func _rebuild():
    for c in get_children(): c.free()    # 崩溃！btn 正在执行

# ✅ 延迟重建 + 安全释放
btn.pressed.connect(func(): _rebuild.call_deferred())
func _rebuild():
    for c in get_children():
        remove_child(c)
        c.queue_free()
    # 重新创建子节点...
```

### "Can't change this state while flushing queries"
**原因**: 在物理回调中修改物理世界（添加/删除碰撞体）。
**修复**: 使用 `call_deferred()` 延迟修改。

---

## 编译/解析错误

### "Identifier 'xxx' shadows a built-in function"
**原因**: 变量名与 GDScript 内建函数同名（如 `snapped`, `lerp`, `clamp`, `print`）。
**修复**: 更换变量名：
```gdscript
# ❌
var snapped := snap_value(v)

# ✅
var snapped_v := snap_value(v)
var new_v := snapped(v, step)    # 注意：snapped() 是内建函数
```

### "The variable 'xxx' is already declared in this scope"
**原因**: 同一函数作用域内用 `var` 声明了同名变量（包括 for 循环内）。
**修复**: 在外层声明一次，内层只赋值：
```gdscript
# ❌ for 循环内重复声明
for item in list:
    var captured_id := item.id        # 第二次循环报错（同一作用域）

# ✅ 每次循环变量自动是新作用域（实际上 for 变量 OK，问题通常在嵌套 lambda 中）
# 或提前声明
var captured_id: String
for item in list:
    captured_id = item.id
```

### "Cannot use 'const' with a non-constant expression"
**原因**: `const` 要求编译期常量，不能引用 `static var`。
**修复**: 用局部变量或直接引用：
```gdscript
# ❌
const BG := UITheme.BG            # UITheme.BG 是 static var

# ✅
var bg := UITheme.BG               # 局部变量
# 或直接使用 UITheme.BG
```

### "Expected type 'int' but got 'float'"
**原因**: 整数除法产生 float，但赋值给 int 变量。
**修复**: 使用 `floori()` 或 `int()`：
```gdscript
# ❌
var k: int = y / 100              # WARNING: integer division

# ✅
var k: int = floori(y / 100.0)    # 明确意图
```

### "@export var size" 与原生属性冲突
**原因**: Godot 4.6 中 `@export var size` 与 `Control.size` / `Button.size` 等原生属性冲突。
**修复**: 重命名属性：
```gdscript
# ❌
@export var size: Size = Size.MD

# ✅
@export var button_size: Size = Size.MD
```

---

## 警告 (WARNING)

### "Integer division, use 'floori/ceili' if intended"
**原因**: `int / int` 产生截断，Godot 认为可能不是本意。
**修复**: `floori(a / float(b))` 或 `a / b`（加 `@warning_ignore("integer_division")`）。

### "The local variable 'xxx' is declared but never used"
**修复**: 添加 `@warning_ignore("unused_variable")` 或删除变量。

### "The parameter 'xxx' is never used"
**修复**: 参数名前加下划线 `_xxx`，或添加 `@warning_ignore("unused_parameter")`。

### "Narrowing conversion from 'float' to 'int'"
**原因**: 将 float 隐式转为 int。
**修复**: 显式转换 `int(value)` 或 `roundi(value)`。

### "Return value of 'xxx' is discarded"
**原因**: 调用了有返回值的函数但没有使用返回值。
**修复**: 用 `@warning_ignore("return_value_discarded")` 或用变量接收。

---

## 场景树/节点错误

### "Node not found: 'xxx'"
**原因**: `$NodeName` 或 `get_node()` 路径错误，节点不存在或还未加入场景树。
**修复**: 使用 `get_node_or_null()` 安全获取，或确保在 `_ready()` 后访问。

### "add_child: Can't add child, already has a parent"
**原因**: 尝试将已有父节点的子节点添加到另一个父节点。
**修复**: 先 `remove_child()`：
```gdscript
# ❌
new_parent.add_child(node)       # node 已有 old_parent

# ✅
old_parent.remove_child(node)
new_parent.add_child(node)
```

### "Parent node is busy setting up children, add_child() failed"
**原因**: 在 `_init()` 中调用 `add_child()`。
**修复**: 将 `add_child()` 移到 `_ready()` 中。

### class_name 未注册（首次运行报错）
**原因**: 新脚本的 `class_name` 需要 Godot 编辑器扫描才能注册。
**修复**: 先启动编辑器：
```
1. mcp__godot__launch_editor()   ← 等待 ~8 秒
2. mcp__godot__run_project()
```

---

## 样式/UI 错误

### 容器内子节点 position/size 无效
**原因**: 容器（HBox/VBox/PanelContainer 等）会覆盖子控件的定位。
**修复**: 用 `size_flags_*` 和 `custom_minimum_size` 控制布局。

### PanelContainer 样式不显示
**原因**: 未调用 `add_theme_stylebox_override("panel", style)`。
**修复**: 确保在 `_ready()` 或创建后立即设置样式。

### Hover 效果不生效
**原因**:
1. `mouse_filter = MOUSE_FILTER_IGNORE` 导致不接收鼠标事件
2. 子节点的 `mouse_filter = MOUSE_FILTER_STOP` 吞掉了事件
**修复**: 确保目标节点 `mouse_filter = STOP` 或 `PASS`，子节点按需设 `IGNORE`。

### ScrollContainer 内容不滚动
**原因**:
1. 内容节点没有设置 `SIZE_EXPAND_FILL`
2. 内容实际高度没有超过 ScrollContainer
3. 放了多个直接子节点
**修复**: 内部只放一个 VBoxContainer，并确保内容超出容器尺寸。

### Label 文字被截断但不换行
**原因**: 未设置 `autowrap_mode`。
**修复**: `label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART`

---

## 信号相关

### 信号参数数量不匹配
**原因**: 连接的回调函数参数数量与信号定义不一致。
**修复**: 确保回调参数匹配，或用 lambda 包装：
```gdscript
signal my_signal(a: int, b: String)

# ❌ 参数数量不匹配
my_signal.connect(func(): pass)

# ✅ 参数匹配
my_signal.connect(func(a: int, b: String): pass)
# 或忽略参数
my_signal.connect(func(_a: int, _b: String): pass)
```

### 信号连接后多次触发
**原因**: 同一信号被多次 `connect()`（例如在 `_process` 或被重复调用的函数中）。
**修复**: 连接前检查，或使用 `CONNECT_ONE_SHOT`：
```gdscript
if not signal_name.is_connected(callback):
    signal_name.connect(callback)
```

---

## 主题/样式切换

### 主题切换后颜色不更新
**原因**: 节点在创建时读取了 UITheme 的颜色值并缓存在 StyleBoxFlat 中，切换主题只修改了 static var，不会自动更新已创建的 StyleBox。
**修复**: 重建页面（本项目的做法：`_navigate_to()` 重新创建页面内容）。

### StyleBoxFlat 阴影只有一个方向
**原因**: Godot 的 StyleBoxFlat 只支持单方向阴影，无法像 CSS box-shadow 多层。
**修复**: 用 `shadow_color` 设置彩色实现发光效果，或用 `shadow_offset = Vector2.ZERO` 实现均匀阴影。
