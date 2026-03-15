---
name: godot-development
description: |
  Godot 开发助手（偏 UI 组件库）。处理 GDScript、节点/生命周期、UI 布局、组件开发、页面开发、报错排查。
  当用户说“初始化 / init / 加载知识 / 导入知识 / 加载所有”时，必须加载 references 下全部 9 个文件。
---

# Godot Development Skill

## 1) 使用原则

- 目标：用最少上下文解决当前 Godot 问题，优先可执行步骤。
- 默认：按需加载（只读 1-3 个最相关参考文件）。
- 例外：用户明确要求 `init/初始化/加载知识/导入知识/加载所有` 时，执行全量加载。

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

当用户提到以下关键词之一，必须读取全部 references 文件：
- `初始化` / `init`
- `加载知识` / `导入知识`
- `加载所有` / `加载参考资料`

加载顺序：
1. `references/gdscript_cheatsheet.md`
2. `references/node_reference.md`
3. `references/ui_layout.md`
4. `references/2d_graphics.md`
5. `references/component_library_api.md`
6. `references/common_errors.md`
7. `references/godot_recipes.md`
8. `references/workflow_new_component.md`
9. `references/workflow_new_page.md`

完成后回复：`已加载所有 Godot 开发知识（9 个参考文件）`。

## 4) 执行检查清单

### 4.1 通用
- 优先静态类型和显式类型声明（尤其数组元素）。
- setter 中涉及重建时使用 `call_deferred()`，避免 locked object。
- 节点销毁使用 `remove_child(...) + queue_free()`，避免直接 `free()`。
- 异步回调前检查 `is_instance_valid(...)`。

### 4.2 UI/容器
- 容器内不要手动 `position/size`（会被布局覆盖）。
- 保证关键节点有 `custom_minimum_size`。
- `ScrollContainer` 只放一个直接子节点。

### 4.3 Overlay/动画
- Overlay 组件优先 CanvasLayer 架构。
- show/hide 设计为幂等，防止重复触发。
- Tween 挂在“仍在树中的节点”上；宿主可能离树时改挂叶子节点。

## 5) 最小调试流程

1. 先复现：运行项目并读取 debug 输出。
2. 定位：从报错文件行号 + 调用链回溯。
3. 修复：先保证正确性，再做样式/重构。
4. 回归：至少启动一次项目并复查 debug 输出。

## 6) 常用 MCP（最小集）

- `mcp__godot__run_project`
- `mcp__godot__get_debug_output`
- `mcp__godot__stop_project`
- `mcp__godot__launch_editor`（新增 `class_name` 后优先执行）

## 7) 参考文件清单

- `references/gdscript_cheatsheet.md`
- `references/node_reference.md`
- `references/ui_layout.md`
- `references/2d_graphics.md`
- `references/component_library_api.md`
- `references/common_errors.md`
- `references/godot_recipes.md`
- `references/workflow_new_component.md`
- `references/workflow_new_page.md`
