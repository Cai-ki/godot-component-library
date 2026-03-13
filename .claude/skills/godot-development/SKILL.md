---
name: godot-development
description: |
  Godot 游戏开发助手。当用户询问以下内容时使用：GDScript 语法问题（变量、函数、类、信号、类型提示等），
  Godot 节点类型（UI 容器、2D/3D 节点、物理节点、节点组合），UI 布局问题（容器、锚点、响应式布局），
  2D 游戏开发（Sprite、粒子、摄像机、物理），项目结构建议。
  当用户说"初始化"、"加载知识"、"导入知识"、"init"或需要完整知识库时，**必须**读取并加载所有 references 下的文件。
  强烈建议在处理任何 Godot 相关开发任务时使用此技能。
---

# Godot 开发技能

本技能提供 Godot 游戏开发相关知识的快速查询和指导。

---

## 强制加载知识（重要）

**当用户说以下关键词时，必须读取并加载所有 references 下的文件到上下文中：**
- "初始化" / "init"
- "加载知识" / "导入知识"
- "加载所有" / "加载参考资料"

**执行步骤：**
1. 读取 `references/gdscript_cheatsheet.md`
2. 读取 `references/node_reference.md`
3. 读取 `references/ui_layout.md`
4. 读取 `references/2d_graphics.md`
5. 读取 `references/component_library_api.md`
6. 告知用户"已加载所有 Godot 开发知识"

---

## 核心概念

### 1. 节点 (Node) 与场景 (Scene)
- **节点**：Godot 最基本的功能单元，每个节点有特定功能
- **场景**：节点的集合，可实例化、可嵌套、支持继承
- 场景树根节点始终是 Viewport；`_ready()` 采用**后序遍历**（子先于父）

### 2. 资源 (Resource)
- 数据容器，只加载一次（单例模式）
- `load()` 运行时加载，`preload()` 编译时加载（GDScript 专有）

### 3. 信号 (Signal)
- 节点间解耦通信：`signal_name.connect(callable)` / `signal_name.emit()`

### 4. 自动加载 (Autoload)
- 全局单例，通过 `Project > Project Settings > Autoload` 配置

---

## GDScript 核心回调

| 回调 | 触发时机 |
|------|----------|
| `_ready()` | 节点及子节点全部就绪 |
| `_process(delta)` | 每帧（帧率相关） |
| `_physics_process(delta)` | 物理步长（固定，推荐移动逻辑） |
| `_input(event)` | 所有输入事件 |
| `_unhandled_input(event)` | GUI 未捕获的输入（游戏逻辑推荐） |
| `_enter_tree()` / `_exit_tree()` | 进出场景树 |
| `_draw()` | 自定义绘制（继承 Node2D/Control 时） |

---

## 最佳实践

1. **单一职责** — 每个场景/脚本只负责一个功能
2. **避免循环依赖** — 父子节点通过信号通信
3. **静态类型** — `var speed: float = 10.0`，类型推断 `:=`
4. **setter 守卫** — `set(v): val = v; if is_inside_tree(): _apply()`
5. **延迟重建** — setter 触发 `_rebuild.call_deferred()` 避免 locked object

---

## UI 布局核心原则（重要）

1. **使用容器而非手动坐标** — 响应式布局的核心
2. **容器内子控件不能手动设置 position/size** — 会被忽略
3. **Expand vs Fill** — Expand 占用额外空间，Fill 填满自身区域

### 推荐布局结构
```
CanvasLayer (全屏)
└── Control (Anchors: Full Rect)
    └── [容器嵌套...]
```

### 最常用容器
- **HBoxContainer** / **VBoxContainer** — 水平/垂直排列，`separation` 控制间距
- **GridContainer** — 网格布局（设置 `columns`）
- **MarginContainer** — 内边距（`margin_left/right/top/bottom`）
- **CenterContainer** — 居中
- **ScrollContainer** — 可滚动（内部需一个子节点）
- **PanelContainer** — 带 StyleBox 的面板

### 常见错误（必须避免）
- ❌ 手动设置 `position.x/y` 而不用容器
- ❌ 忽略 `size_flags_horizontal/vertical`
- ❌ 不设置 `custom_minimum_size` 导致布局崩溃
- ❌ 忘记在根 Control 设置 Full Rect

---

## 调试技巧

```gdscript
print("调试信息")
push_error("错误信息")   # 红色，不中断
push_warning("警告信息")
```

---

## Godot MCP 工具（完整列表）

### 运行与调试
| 工具 | 用途 |
|------|------|
| `mcp__godot__run_project` | 运行 Godot 项目 |
| `mcp__godot__stop_project` | 停止运行的项目 |
| `mcp__godot__get_debug_output` | 查看运行时错误和调试输出 |
| `mcp__godot__launch_editor` | 启动 Godot 编辑器（新 class_name 后必须先执行） |

### 项目管理
| 工具 | 用途 |
|------|------|
| `mcp__godot__list_projects` | 列出目录中的 Godot 项目 |
| `mcp__godot__get_project_info` | 获取项目元数据信息 |
| `mcp__godot__get_godot_version` | 获取已安装的 Godot 版本 |

### 场景与资源
| 工具 | 用途 |
|------|------|
| `mcp__godot__create_scene` | 创建新的 Godot 场景文件 (.tscn) |
| `mcp__godot__add_node` | 向现有场景添加节点 |
| `mcp__godot__save_scene` | 保存场景文件 |
| `mcp__godot__get_uid` | 获取文件的 UID（Godot 4.4+） |
| `mcp__godot__update_project_uids` | 重新扫描并更新项目中的 UID 引用 |

---

## 按需查询详细文档

当用户询问特定主题时，读取对应的参考文件获取完整信息：

| 用户问题 | 参考文件 |
|---------|----------|
| GDScript 语法（变量、函数、类、信号、Tween） | `references/gdscript_cheatsheet.md` |
| 节点类型（UI 容器、控件、Timer） | `references/node_reference.md` |
| UI 布局（容器、锚点、StyleBox、override） | `references/ui_layout.md` |
| CanvasLayer / 自定义绘制 / 动画 | `references/2d_graphics.md` |
| UITheme 令牌 / UI helpers / 28 个组件 API | `references/component_library_api.md` |

---

## 外部资源

### 官方文档
- [Godot 4 中文文档](https://docs.godotengine.org/zh-cn/4.5/index.html)
- [UI 教程](https://docs.godotengine.org/zh-cn/4.5/tutorials/ui/index.html)
- [Best Practices](https://docs.godotengine.org/en/stable/tutorials/best_practices/index.html)
- [Custom GUI Controls](https://docs.godotengine.org/en/stable/tutorials/ui/custom_gui_controls.html)
- [GUI Skinning](https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html)

### 中文社区
- [Godot 中文社区](http://GodotCn.com)
- [Godot UI 疑难杂症（知乎）](https://zhuanlan.zhihu.com/p/457331899)
- [Godot 模拟网页布局（CSDN）](https://blog.csdn.net/graypigen1990/article/details/146028727)

### 示例项目
- [Godot Demo Projects](https://github.com/godotengine/godot-demo-projects)
- [Godot Asset Library](https://godotengine.org/asset-library)
