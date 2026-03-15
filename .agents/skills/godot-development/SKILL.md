---
name: godot-development
description: |
  Godot 开发助手（偏 UI 组件库）。处理 GDScript、节点/生命周期、UI 布局、组件开发、页面开发、报错排查。
  当用户说“初始化 / init / 加载知识 / 导入知识 / 加载所有”时，必须加载 references 下全部 9 个文件。
---

# Godot Development Skill

## 1) 使用原则

- 目标：最少上下文，优先可执行步骤。
- 默认：按需加载（只读 1-3 个 references）。
- 例外：命中 init 关键词时，强制全量加载 9 个 references。

## 2) 按需路由（默认）

| 用户意图 | 加载文件 |
|---|---|
| GDScript 语法/类型/信号 | `references/gdscript_cheatsheet.md` |
| 创建新组件 | `references/workflow_new_component.md` + `references/component_library_api.md` |
| 创建新页面 | `references/workflow_new_page.md` + `references/component_library_api.md` |
| UI 布局/容器/锚点 | `references/ui_layout.md` + `references/node_reference.md` |
| 节点生命周期/基类选择 | `references/node_reference.md` |
| 绘制/动画/CanvasLayer | `references/2d_graphics.md` |
| 组件 API 查询 | `references/component_library_api.md` |
| 报错排查 | `references/common_errors.md` |
| 常见代码模式 | `references/godot_recipes.md` |

## 3) 全量加载（init）

触发关键词：`初始化` / `init` / `加载知识` / `导入知识` / `加载所有` / `加载参考资料`

顺序：
1. `references/gdscript_cheatsheet.md`
2. `references/node_reference.md`
3. `references/ui_layout.md`
4. `references/2d_graphics.md`
5. `references/component_library_api.md`
6. `references/common_errors.md`
7. `references/godot_recipes.md`
8. `references/workflow_new_component.md`
9. `references/workflow_new_page.md`

完成后必须告知：`已加载所有 Godot 开发知识（9 个参考文件）`。

## 4) 执行检查清单

### 通用
- setter 涉及重建时使用 `call_deferred()`。
- 删除节点使用 `remove_child(...) + queue_free()`。
- 异步回调前检查 `is_instance_valid(...)`。
- Array 元素访问尽量显式类型声明。

### UI/布局
- 容器内不手动改 `position/size`。
- 保证关键节点有 `custom_minimum_size`。
- `ScrollContainer` 仅一个直接子节点。

### Overlay/动画
- Overlay 统一 CanvasLayer 架构。
- show/hide 做幂等保护，防重入。
- Tween 挂在稳定在树中的节点上。

## 5) 最小调试流程

1. `run_project` 复现。
2. `get_debug_output` 定位。
3. 最小修复。
4. 再次运行回归。

## 6) 最小 MCP 工具集

- `mcp__godot__run_project`
- `mcp__godot__get_debug_output`
- `mcp__godot__stop_project`
- `mcp__godot__launch_editor`（新增 `class_name` 后优先）
