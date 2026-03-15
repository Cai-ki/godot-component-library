# GDScript 语法速查

## 变量与常量

```gdscript
var health: int = 100
var speed := 10.0          # 类型推断
const MAX_SPEED = 500      # 编译期常量，不能引用 static var

# 静态变量（类级别共享，可运行时修改）
static var instance_count: int = 0

# 枚举
enum State { IDLE, RUN, JUMP }
enum Direction { LEFT = -1, RIGHT = 1 }

# 枚举用法
var current: State = State.IDLE
match current:
    State.IDLE: pass
    State.RUN:  pass
```

## 数据类型

### 基本类型
- `int` — 64 位整数
- `float` — 64 位浮点
- `bool` — `true` / `false`
- `String` — UTF-8 字符串（不可变）
- `StringName` — 内部化字符串，比较更快（用于节点名、方法名）

```gdscript
# String vs StringName
var s: String = "hello"           # 普通字符串
var sn: StringName = &"hello"     # StringName 字面量（& 前缀）
# 节点名比较推荐用 StringName：node.name == &"MyNode"

# ⚠️ & 只能修饰字面量，不能用于变量
const NAME := "test"
# node.name == &NAME      # ❌ 语法错误
# node.name == NAME       # ✅ String 比较也可以
```

### 向量类型
- `Vector2(x, y)` / `Vector2i(x, y)` — 2D 向量（float / int）
- `Vector3(x, y, z)` / `Vector3i`
- `Vector4(x, y, z, w)`
- `Rect2(position, size)` — 2D 矩形，`position: Vector2`, `size: Vector2`
- `Transform2D` — 2D 变换矩阵

```gdscript
# Vector2 常用
Vector2.ZERO               # (0, 0)
Vector2.ONE                # (1, 1)
Vector2.UP / DOWN / LEFT / RIGHT
var v := Vector2(3, 4)
v.length()                 # 5.0
v.normalized()             # 单位向量
v.distance_to(other)       # 到另一点的距离
v.angle_to(other)          # 到另一向量的角度（弧度）
v.lerp(target, 0.5)        # 线性插值

# Rect2 常用
var r := Rect2(Vector2(10, 20), Vector2(100, 50))
r.has_point(Vector2(50, 30))   # 点是否在矩形内
r.intersects(other_rect)       # 矩形是否相交
r.merge(other_rect)            # 合并两个矩形
r.grow(10)                     # 各边扩大 10
```

### 容器类型

```gdscript
# --- Array ---
var arr: Array = [1, "two", 3.0]          # Variant 数组
var typed: Array[int] = [1, 2, 3]         # 类型化数组（推荐）
var nodes: Array[Node] = []               # 节点数组

arr.append(value)                 # 尾部添加
arr.insert(0, value)              # 指定位置插入
arr.erase(value)                  # 按值删除（第一个匹配）
arr.remove_at(index)              # 按索引删除
arr.pop_back()                    # 弹出尾部
arr.pop_front()                   # 弹出头部
arr.find(value)                   # 查找索引，-1 = 未找到
arr.has(value)                    # 是否包含
arr.size()                        # 长度
arr.is_empty()                    # 是否为空
arr.clear()                       # 清空
arr.sort()                        # 原地排序
arr.reverse()                     # 原地反转
arr.duplicate()                   # 浅拷贝
arr.slice(begin, end)             # 切片 [begin, end)

# 函数式方法（Godot 4）
arr.filter(func(x): return x > 0)           # 过滤
arr.map(func(x): return x * 2)              # 映射
arr.reduce(func(acc, x): return acc + x, 0) # 归约
arr.any(func(x): return x > 10)             # 任一满足
arr.all(func(x): return x > 0)              # 全部满足
arr.sort_custom(func(a, b): return a > b)   # 自定义排序（降序）

# ⚠️ Array 元素类型推断陷阱
var data: Array = [[1, 2], [3, 4]]
var bad := data[0]           # Variant，可能报类型错误
var ok: Array = data[0]      # ✅ 显式声明类型
var ok2: int = data[0][0]    # ✅ 显式声明最终类型

# --- Dictionary ---
var dict: Dictionary = {"name": "Alice", "age": 25}
var typed_dict: Dictionary = {}   # Godot 4 暂无 typed Dictionary 语法

dict["key"] = value               # 设置
dict.get("key", default)          # 获取（带默认值）
dict.has("key")                   # 是否包含键
dict.erase("key")                 # 删除键
dict.keys()                       # 所有键 Array
dict.values()                     # 所有值 Array
dict.size()                       # 键值对数量
dict.is_empty()                   # 是否为空
dict.clear()                      # 清空
dict.merge(other_dict)            # 合并（相同键被覆盖）
dict.duplicate()                  # 浅拷贝

# 遍历
for key in dict:
    print(key, dict[key])
for key in dict.keys():           # 等价写法
    pass

# --- Packed 数组（高性能，类型固定）---
var ints: PackedInt32Array = PackedInt32Array([1, 2, 3])
var floats: PackedFloat32Array = PackedFloat32Array()
var strings: PackedStringArray = PackedStringArray(["a", "b"])
var bytes: PackedByteArray = PackedByteArray()
var colors: PackedColorArray = PackedColorArray()
var vec2s: PackedVector2Array = PackedVector2Array()

# PackedStringArray 常用于 UI 组件的 @export
@export var options: PackedStringArray = PackedStringArray(["Option A", "Option B"])
```

### Godot 特殊类型

```gdscript
# Color
var c := Color("#6C63FF")              # 从 HEX
var c2 := Color(0.42, 0.39, 1.0, 1.0) # RGBA float
var c3 := Color.WHITE                  # 预设常量
c.lerp(Color.BLACK, 0.5)              # 颜色插值
c.lightened(0.2)                       # 变亮
c.darkened(0.3)                        # 变暗
Color(c, 0.5)                          # 改 alpha（保留 RGB）
c.to_html(false)                       # → "6C63FF"（无 alpha）

# Callable（函数引用）
var cb: Callable = my_func             # 引用函数
var cb2 := func(): print("lambda")     # 匿名函数
cb.call()                              # 调用
cb.bind(arg1, arg2)                    # 绑定参数，返回新 Callable
cb.call_deferred()                     # 延迟到帧尾调用

# NodePath
var path: NodePath = ^"Parent/Child"   # ^"" 字面量
get_node(path)
```

## 控制流

```gdscript
# 条件
if condition:
    pass
elif other:
    pass
else:
    pass

# 三元表达式
var result := "yes" if condition else "no"

# for 循环
for i in range(10): print(i)          # 0~9
for i in range(2, 10): print(i)       # 2~9
for i in range(0, 10, 2): print(i)    # 0,2,4,6,8
for item in array: print(item)
for key in dict:   print(key, dict[key])

# while
while condition:
    pass

# match（类似 switch，支持模式匹配）
match value:
    1:       print("one")
    2, 3:    print("two or three")
    "hello": print("string")
    _:       print("other")

# match 高级模式
match [x, y]:
    [0, 0]:          print("origin")
    [var a, var b]:  print("coords: ", a, b)

match dict:
    {"type": "circle", "radius": var r}:
        print("circle r=", r)

# is 类型检查
if node is Button:
    node.text = "Clicked"       # 自动类型收窄

if node is Control:
    var ctrl: Control = node    # 安全转换

# as 类型转换（失败返回 null）
var btn := node as Button
if btn:
    btn.text = "OK"

# in 操作符
if "key" in dict: pass          # Dictionary 查键
if value in array: pass         # Array 查值
```

## 函数

```gdscript
func name(p1: int, p2: float = 1.0) -> String:
    return str(p1 + p2)

# 无返回值
func do_something() -> void:
    pass

# 静态函数（不需要实例，通过类名调用）
static func create_default() -> MyClass:
    var inst := MyClass.new()
    return inst

# 调用：MyClass.create_default()

# 调用父类
func _ready():
    super()
func some_method():
    super.some_method()

# 可变参数（不直接支持，用 Array）
func log_all(messages: Array) -> void:
    for msg in messages:
        print(msg)
```

## 类与继承

```gdscript
class_name MyClass
extends BaseClass

var health: int = 100

class InnerClass:
    var value: int = 0

func _init():
    print("Created")

# 实例化
var obj := MyClass.new()

# 检查类型
obj is MyClass           # true
obj is BaseClass         # true（继承链）
obj.get_class()          # 返回内置类名字符串
```

### static var 与 const 的区别

```gdscript
# const：编译期常量，不能引用 static var，不能运行时修改
const MAX_HP = 100                     # ✅
const COLOR := Color("#FF0000")        # ✅ 字面量可以
# const REF := UITheme.PRIMARY         # ❌ static var 不能赋给 const

# static var：类级别变量，所有实例共享，可运行时修改
static var theme_color: Color = Color("#6C63FF")
static var count: int = 0

# 引用方式
MyClass.theme_color                    # 通过类名直接访问
UITheme.PRIMARY                        # UI 组件库的设计令牌全部用 static var
```

## 信号

```gdscript
# 定义
signal health_changed(old_value: int, new_value: int)
signal died

# 发射
health_changed.emit(old, health)
died.emit()

# 连接
node.signal_name.connect(callable)
node.signal_name.connect(func(val): print(val))   # 匿名函数
node.signal_name.disconnect(callable)
if node.signal_name.is_connected(callable): pass

# 一次性连接（触发一次后自动断开）
node.signal_name.connect(callable, CONNECT_ONE_SHOT)

# 延迟连接（信号在下一帧处理）
node.signal_name.connect(callable, CONNECT_DEFERRED)

# 内置信号示例
tree_entered.connect(func(): print("entered tree"))
tree_exiting.connect(func(): print("leaving tree"))
ready.connect(func(): print("ready"))
```

## 属性 Getter/Setter

```gdscript
var _health: int = 100

var health: int:
    get: return _health
    set(v):
        _health = max(0, v)
        if is_inside_tree(): _refresh()   # 守卫：避免 _ready 前调用

# 只读
var readonly: int:
    get: return 42

# @export + setter 组合（组件常用模式）
@export var label_text: String = "":
    set(v):
        label_text = v
        if is_inside_tree(): _apply_styles()

# setter 触发重建（涉及 free 子节点时必须 deferred）
@export var items: PackedStringArray:
    set(v):
        items = v
        if is_inside_tree(): _rebuild.call_deferred()
```

## 装饰器（注解）

```gdscript
# --- 基础 ---
@onready var sprite := $Sprite2D           # _ready 后赋值
@export var speed: float = 100.0           # Inspector 可编辑

# --- @export 变体 ---
@export var name: String                    # 字符串
@export var count: int = 0                  # 整数
@export var color: Color = Color.WHITE      # 颜色选择器
@export var node_ref: Node                  # 节点引用

@export_range(0, 100, 1) var hp: int = 100           # 范围滑块
@export_range(0.0, 1.0, 0.01) var opacity: float     # 浮点范围
@export_enum("Walk", "Run", "Fly") var mode: int     # 枚举下拉
@export_file("*.gd") var script_path: String          # 文件选择
@export_dir var save_dir: String                       # 目录选择
@export_multiline var description: String              # 多行文本框
@export_color_no_alpha var tint: Color                 # 无 alpha 的颜色

# @export 分组（Inspector 中折叠显示）
@export_group("Movement")
@export var speed: float = 100.0
@export var jump_force: float = 300.0

@export_subgroup("Advanced")
@export var acceleration: float = 50.0

@export_category("Combat")     # 新分类标题（粗体）
@export var damage: int = 10

# --- @tool ---
# 让脚本在编辑器中也运行（用于编辑器插件或实时预览）
@tool
class_name MyWidget
extends Control

func _ready() -> void:
    if Engine.is_editor_hint():
        # 仅在编辑器中执行
        pass
    else:
        # 仅在游戏中执行
        pass

# --- 警告抑制 ---
@warning_ignore("unused_variable")
var _temp := 0

@warning_ignore("integer_division")
var half: int = 10 / 3

@warning_ignore("unused_parameter")
func _on_event(_data: Dictionary) -> void:
    pass
```

## 类型提示与转换

```gdscript
var pos: Vector2 = Vector2.ZERO
func get_vel() -> Vector2: return Vector2.ZERO

# 类型转换函数
var i: int   = int(some_float)        # 截断（不四舍五入）
var f: float = float(some_int)
var s: String = str(some_value)       # 任意类型转字符串
var b: bool  = bool(some_value)       # 0/""/null → false

# 四舍五入
var rounded: int = roundi(3.7)        # 4
var floored: int = floori(3.7)        # 3
var ceiled: int  = ceili(3.2)         # 4

# snapped（对齐到步长）— ⚠️ 不要用 snapped 做变量名（内建函数名冲突）
var aligned: float = snappedi(17, 5)  # 15（对齐到 5 的倍数）

# ⚠️ Array 元素类型推断失败
var bad := array[i]           # Variant 数组中可能报错
var ok: int = array[i]        # 显式声明类型
var ok2: Array = array[i]     # 嵌套 Array 时用这个
```

## 常用内置函数

```gdscript
# 节点操作
get_node("Path/To/Node")      # 等价于 $Path/To/Node
add_child(node)
remove_child(node)
queue_free()                  # 延迟释放（安全）
get_tree()                    # 获取场景树
is_inside_tree()              # 是否在场景树中

# 资源
load("res://path.tscn")       # 运行时加载（返回 Resource）
preload("res://path.tscn")    # 编译时加载（GDScript 专有，更快）
# ⚠️ preload 路径必须是字面量，不能用变量

# 数学
randi()                       # 随机 int（全范围）
randf()                       # 随机 [0, 1)
randi_range(1, 10)            # 随机 [1, 10] 整数
randf_range(0.0, 1.0)         # 随机 [0, 1] 浮点
lerp(a, b, t)                 # 线性插值（t=0→a, t=1→b）
lerpf(a, b, t)                # float 版本
inverse_lerp(a, b, v)         # 反向插值：v 在 [a,b] 中的比例
remap(v, a1, b1, a2, b2)      # 重映射：v 从 [a1,b1] 映射到 [a2,b2]
clamp(value, min_val, max_val)
clampf(value, min_val, max_val)  # float 版本
clampi(value, min_val, max_val)  # int 版本
move_toward(from, to, delta)  # 向目标移动固定量
maxi(a, b) / mini(a, b)      # int 版本的 max/min
maxf(a, b) / minf(a, b)      # float 版本
abs(x) / absf(x) / absi(x)
sign(x) / signf(x) / signi(x)  # 返回 -1/0/1
wrap(value, min_val, max_val)   # 循环 wrap（超出 max 回到 min）
wrapi(value, min_val, max_val)  # int 版本
wrapf(value, min_val, max_val)  # float 版本
floori(x)                       # 向下取整 → int（避免整数除法警告）
ceili(x)                        # 向上取整 → int
roundi(x)                       # 四舍五入 → int
fmod(a, b)                      # 浮点取模
pow(base, exp)                  # 幂运算
sqrt(x)                         # 平方根
sin(x) / cos(x) / tan(x)       # 三角函数（弧度）
deg_to_rad(deg)                 # 角度 → 弧度
rad_to_deg(rad)                 # 弧度 → 角度

# 字符串
"Hello %s, you are %d" % [name, age]     # 格式化
str(value)                                # 转字符串
"hello".to_upper()                        # "HELLO"
"HELLO".to_lower()                        # "hello"
"hello world".capitalize()                # "Hello World"
"a,b,c".split(",")                        # ["a", "b", "c"] → PackedStringArray
",".join(PackedStringArray(["a","b"]))    # "a,b"
"hello".begins_with("he")                 # true
"hello".ends_with("lo")                   # true
"hello".contains("ell")                   # true（Godot 4.3+）
"hello".find("ll")                        # 2（未找到返回 -1）
"hello".replace("l", "r")                 # "herro"
"hello".substr(1, 3)                      # "ell"
"hello".length()                          # 5
"  hello  ".strip_edges()                 # "hello"（去首尾空白）
"hello".left(3)                           # "hel"
"hello".right(2)                          # "lo"
String.num(3.14159, 2)                    # "3.14"（数字转字符串，指定小数位）
"FF".hex_to_int()                         # 255
"#6C63FF".is_valid_html_color()           # true

# 打印/调试
print("message")                           # 标准输出
prints("a", "b", "c")                     # 用空格分隔
printt("a", "b", "c")                     # 用 tab 分隔
print_rich("[color=red]Error[/color]")     # 富文本打印
push_error("错误信息")                      # 红色错误（不中断）
push_warning("警告信息")                    # 黄色警告
printerr("stderr message")                # 输出到 stderr
assert(condition, "message")              # 断言（Debug 模式）
```

## 节点获取

```gdscript
$NodeName                     # 直接子节点简写
$Parent/Child                 # 路径
get_node("../Sibling")        # 相对路径
get_parent()                  # 父节点
get_children()                # Array[Node] 所有子节点
get_child(0)                  # 第 N 个子节点
get_child_count()             # 子节点数量
find_child("Name", true)      # 递归搜索（第二个参数=recursive）
has_node("NodeName")           # 是否有该子节点路径

# 安全获取（不存在时返回 null，不报错）
get_node_or_null("MaybeNode")

# 场景树工具
get_tree().root               # 根 Viewport
get_tree().current_scene      # 当前主场景
get_tree().get_nodes_in_group("enemies")   # 获取组中所有节点
get_tree().call_group("enemies", "die")     # 调用组中所有节点的方法
```

## 场景实例化

```gdscript
# 预加载（编译时，推荐静态场景）
var scene: PackedScene = preload("res://my.tscn")
var inst := scene.instantiate()
add_child(inst)

# 运行时加载（动态路径）
var scene2: PackedScene = load("res://scenes/" + name + ".tscn")
if scene2:
    var inst2 := scene2.instantiate()
    add_child(inst2)

# 带类型实例化
var inst3: MyClass = scene.instantiate() as MyClass
if inst3:
    inst3.setup(data)
    add_child(inst3)

# 复制节点
var copy := original_node.duplicate()
parent.add_child(copy)
```

---

## await 异步

```gdscript
# 等待信号
await button.pressed                     # 等待按钮被按下
await get_tree().create_timer(1.0).timeout   # 等待 1 秒

# 等待 Tween 完成
var t := create_tween()
t.tween_property(self, "modulate:a", 0.0, 0.5)
await t.finished
queue_free()

# 在 await 之后检查节点是否仍有效
await get_tree().create_timer(2.0).timeout
if not is_inside_tree():
    return                               # 节点已被销毁，提前返回

# await 与函数返回值
func async_load() -> Resource:
    await get_tree().process_frame       # 等一帧
    return load("res://data.tres")

var res: Resource = await async_load()
```

---

## Tween 动画

```gdscript
# ⚠️ create_tween() 只能在 Node 上调用，RefCounted 没有此方法
# 在页面（extends RefCounted）中，调用被动画节点自身的 create_tween()
var t := node.create_tween()

# 链式配置（先配置，再添加步骤）
t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
t.set_loops()                             # 无限循环
t.set_loops(3)                            # 循环 3 次
t.set_parallel(true)                      # 并行播放多个步骤

# 步骤
t.tween_property(node, "modulate:a", 1.0, 0.3)     # 属性动画
t.tween_property(node, "position:x", 200.0, 0.5)   # 子属性 (x/y/r/g/b/a)
t.tween_callback(some_callable)                      # 回调
t.tween_interval(0.5)                               # 延迟
t.tween_method(func(v: float): label.text = str(v), 0.0, 100.0, 1.0)  # 方法插值

# from 修饰符（从指定值开始）
t.tween_property(node, "modulate:a", 1.0, 0.3).from(0.0)

# 相对值（在当前值基础上变化）
t.tween_property(node, "position:x", 100.0, 0.5).as_relative()

# 常用 Trans/Ease 组合
# TRANS_CUBIC  + EASE_OUT     → 自然感（最常用）
# TRANS_SINE   + EASE_IN_OUT  → 平滑
# TRANS_BOUNCE + EASE_OUT     → 弹跳
# TRANS_BACK   + EASE_OUT     → 超出后回弹
# TRANS_LINEAR + EASE_IN_OUT  → 匀速
# TRANS_EXPO   + EASE_OUT     → 快速减速
# TRANS_ELASTIC + EASE_OUT    → 弹性

# Ease 类型
# EASE_IN      → 慢→快（加速）
# EASE_OUT     → 快→慢（减速，最自然）
# EASE_IN_OUT  → 慢→快→慢

# 等待完成
await t.finished

# 停止
t.kill()

# 检查是否运行中
t.is_running()
t.is_valid()
```

---

## 延迟调用 (call_deferred)

```gdscript
# 在当前帧结束后执行，避免修改正在迭代的场景树
some_func.call_deferred()
some_func.bind(arg1, arg2).call_deferred()

# 常用延迟方法
node.set_deferred("visible", true)                    # 延迟设置属性
node.add_child.call_deferred(child)                   # 延迟添加子节点
node.queue_free()                                      # queue_free 本身就是延迟的

# ⚠️ 重要场景：setter 中触发 _rebuild() 时必须用 deferred
# 否则如果 setter 被按钮回调触发，_rebuild 会 free() 正在执行的按钮（locked object 崩溃）
@export var data: Array:
    set(v): data = v; if is_inside_tree(): _rebuild.call_deferred()

# _rebuild 中安全删除子节点
func _rebuild() -> void:
    for child in get_children():
        remove_child(child)
        child.queue_free()      # ✅ 安全：remove 后 queue_free
    # ... 重新创建子节点
```

---

## 安全检查

```gdscript
# 检查节点是否仍然存在（异步回调、Timer、Tween 回调中必须用）
if is_instance_valid(node):
    node.do_something()

# 检查是否在场景树中
if is_inside_tree():
    get_tree().root   # 安全调用

# 安全的 Timer 回调
var timer := get_tree().create_timer(2.0)
timer.timeout.connect(func():
    if is_instance_valid(label):       # ✅ 先检查
        label.text = "done"
)

# 安全的信号断开
if node.signal_name.is_connected(my_callback):
    node.signal_name.disconnect(my_callback)

# null 检查
var result = dict.get("key")   # 可能返回 null
if result != null:
    use(result)
```

---

## Lambda 与闭包

```gdscript
# 基本 lambda
btn.pressed.connect(func(): print("clicked"))

# 多行 lambda
btn.pressed.connect(func():
    print("line 1")
    print("line 2")
)

# 捕获变量（值捕获，不是引用）
var idx := 3
btn.pressed.connect(func(): print(idx))   # 捕获 idx=3 的快照

# ⚠️ 循环中捕获变量的陷阱
for i in range(5):
    var captured_i := i    # 每次循环创建新变量
    buttons[i].pressed.connect(func(): print(captured_i))   # ✅ 正确
    # buttons[i].pressed.connect(func(): print(i))          # ❌ 都会打印 4

# 带参数的信号
slider.value_changed.connect(func(v: float): label.text = str(v))

# bind() 预绑定参数（信号没有该参数时使用）
btn.pressed.connect(_on_btn_pressed.bind(idx))
func _on_btn_pressed(index: int) -> void: pass

# bind 在循环中使用
for i in range(5):
    buttons[i].pressed.connect(_handle.bind(i))   # ✅ bind 不受闭包限制
```

---

## 定时器 (Timer)

```gdscript
# 方式一：代码创建 Timer 节点
var timer := Timer.new()
timer.wait_time = 2.0
timer.one_shot = true          # true = 单次，false = 循环
timer.autostart = false
add_child(timer)
timer.timeout.connect(func(): print("timeout"))
timer.start()

# 方式二：SceneTree 一次性定时器（最简洁）
await get_tree().create_timer(1.5).timeout
print("1.5 秒后")

# 方式三：SceneTree 定时器 + 回调（不阻塞）
get_tree().create_timer(1.0).timeout.connect(func():
    if is_instance_valid(self):
        print("安全的定时回调")
)

# 停止定时器
timer.stop()
```

---

## 输入处理

```gdscript
# 回调优先级：_input → _gui_input → _unhandled_input

# _input：最先收到，所有输入
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_ESCAPE:
            get_viewport().set_input_as_handled()   # 阻止传播

# _gui_input：仅 Control 节点，仅鼠标/触摸在控件范围内
func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
            print("left click on this control")
            accept_event()    # 阻止传播给父控件

# _unhandled_input：GUI 未消费的输入（推荐用于游戏逻辑）
func _unhandled_input(event: InputEvent) -> void:
    pass

# 输入事件类型
# InputEventMouseButton — 鼠标按下/释放
#   .button_index: MOUSE_BUTTON_LEFT / RIGHT / MIDDLE / WHEEL_UP / WHEEL_DOWN
#   .pressed: bool
#   .double_click: bool
#   .position: Vector2（相对控件）
#   .global_position: Vector2

# InputEventMouseMotion — 鼠标移动
#   .position / .global_position: Vector2
#   .relative: Vector2（相对上次的偏移）
#   .button_mask: int（当前按下的按钮）

# InputEventKey — 键盘
#   .keycode: Key（KEY_A, KEY_ESCAPE, KEY_ENTER, KEY_SPACE, ...）
#   .pressed: bool
#   .echo: bool（按住重复）
#   .ctrl_pressed / .shift_pressed / .alt_pressed / .meta_pressed: bool

# 快捷键检查
if event is InputEventKey and event.pressed:
    if event.keycode == KEY_K and (event.ctrl_pressed or event.meta_pressed):
        print("Ctrl+K / Cmd+K")
```

---

## 进程帧等待

```gdscript
# 等待一帧（常用于确保布局计算完成）
await get_tree().process_frame

# 等待物理帧
await get_tree().physics_frame

# 等待多帧
for i in range(3):
    await get_tree().process_frame
```
