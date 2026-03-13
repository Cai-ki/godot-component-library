# GDScript 语法速查

## 变量与常量

```gdscript
var health: int = 100
var speed := 10.0          # 类型推断
const MAX_SPEED = 500      # 编译期常量，不能引用 static var

# 枚举
enum State { IDLE, RUN, JUMP }
enum Direction { LEFT = -1, RIGHT = 1 }
```

## 数据类型

- 基本：`int`, `float`, `bool`, `String`
- 向量：`Vector2`, `Vector3`, `Vector2i`, `Vector4`
- 容器：`Array`, `Dictionary`, `PackedStringArray`, `PackedByteArray`
- Godot：`Color`, `NodePath`, `RID`, `Callable`

## 控制流

```gdscript
# 条件
if condition:
    pass
elif other:
    pass
else:
    pass

# for 循环
for i in range(10): print(i)
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
```

## 函数

```gdscript
func name(p1: int, p2: float = 1.0) -> String:
    return str(p1 + p2)

# 调用父类
func _ready():
    super()
func some_method():
    super.some_method()
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
```

## 信号

```gdscript
# 定义
signal health_changed(old_value: int, new_value: int)
signal died

# 发射
health_changed.emit(old, health)

# 连接
node.signal_name.connect(callable)
node.signal_name.connect(func(val): print(val))   # 匿名函数
node.signal_name.disconnect(callable)
if node.signal_name.is_connected(callable): pass
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
```

## 装饰器

```gdscript
@onready var sprite := $Sprite2D           # _ready 后赋值
@export var speed: float = 100.0           # Inspector 可编辑
@export_enum("One","Two","Three") var choice: int
@export_group("Movement")
@export_subgroup("Speed")
```

## 类型提示与转换

```gdscript
var pos: Vector2 = Vector2.ZERO
func get_vel() -> Vector2: return Vector2.ZERO

var i: int   = int(some_float)
var f: float = float(some_int)
var s: String = str(some_value)

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

# 资源
load("res://path.tscn")       # 运行时
preload("res://path.tscn")    # 编译时

# 数学
randi()                       # 随机整数
randf()                       # 随机 [0, 1)
lerp(a, b, t)
clamp(value, min, max)
clampf(value, min, max)       # float 版本
clampi(value, min, max)       # int 版本
move_toward(from, to, delta)
maxi(a, b) / mini(a, b)       # int 版本的 max/min
maxf(a, b) / minf(a, b)       # float 版本

# 字符串
"Hello %s, you are %d" % [name, age]
str(value)
```

## 节点获取

```gdscript
$NodeName                     # 直接子节点简写
$Parent/Child                 # 路径
get_node("../Sibling")        # 相对路径
get_parent()
get_children()                # Array[Node]
find_child("Name", true)      # 递归搜索
```

## 场景实例化

```gdscript
var scene: PackedScene = preload("res://my.tscn")
var inst := scene.instantiate()
add_child(inst)
```

---

## Tween 动画

```gdscript
# ⚠️ create_tween() 只能在 Node 上调用，RefCounted 没有此方法
# 在页面（extends RefCounted）中，调用被动画节点自身的 create_tween()
var t := node.create_tween()

# 链式配置（先配置，再添加步骤）
t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
t.set_loops()                             # 循环
t.set_parallel(true)                      # 并行播放多个步骤

# 步骤
t.tween_property(node, "modulate:a", 1.0, 0.3)     # 属性动画
t.tween_property(node, "position:x", 200.0, 0.5)   # 子属性 (x/y/r/g/b/a)
t.tween_callback(some_callable)                      # 回调
t.tween_interval(0.5)                               # 延迟

# 常用 Trans/Ease 组合
# TRANS_CUBIC  + EASE_OUT     → 自然感（最常用）
# TRANS_SINE   + EASE_IN_OUT  → 平滑
# TRANS_BOUNCE + EASE_OUT     → 弹跳
# TRANS_BACK   + EASE_OUT     → 超出后回弹
# TRANS_LINEAR + EASE_IN_OUT  → 匀速

# 等待完成
await t.finished

# 停止
t.kill()
```

---

## 延迟调用 (call_deferred)

```gdscript
# 在当前帧结束后执行，避免修改正在迭代的场景树
some_func.call_deferred()
some_func.bind(arg1, arg2).call_deferred()

# ⚠️ 重要场景：setter 中触发 _rebuild() 时必须用 deferred
# 否则如果 setter 被按钮回调触发，_rebuild 会 free() 正在执行的按钮（locked object 崩溃）
@export var data: Array:
    set(v): data = v; if is_inside_tree(): _rebuild.call_deferred()
```

---

## 安全检查

```gdscript
# 检查节点是否仍然存在（异步回调、Timer、Tween 回调中必须用）
if is_instance_valid(node):
    node.do_something()

# 错误用法：直接调用可能已释放的节点会崩溃
# timer.timeout.connect(func(): node.text = "done")   # ❌
# timer.timeout.connect(func():                        # ✅
#     if is_instance_valid(node): node.text = "done"
# )
```

---

## Lambda 与闭包

```gdscript
# 基本 lambda
btn.pressed.connect(func(): print("clicked"))

# 捕获变量（值捕获，不是引用）
var idx := 3
btn.pressed.connect(func(): print(idx))   # 捕获 idx=3 的快照

# 带参数的信号
slider.value_changed.connect(func(v: float): label.text = str(v))

# bind() 预绑定参数（信号没有该参数时使用）
btn.pressed.connect(_on_btn_pressed.bind(idx))
func _on_btn_pressed(index: int) -> void: pass
```
