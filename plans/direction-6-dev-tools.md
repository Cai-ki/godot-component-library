# Direction 6: 开发者工具

## 目标

为组件库的使用者提供更好的开发体验，包括交互式 Playground、代码生成和 API 文档。

## 工具清单

### 6.1 组件 Playground
- **文件**: `scripts/pages/playground_page.gd`
- **目标**: 实时调整组件属性，即时预览效果
- **布局**:
  ```
  ┌──────────────────────────────────────────┐
  │  [组件选择器 UISelect]                     │
  ├────────────────────┬─────────────────────┤
  │                    │  属性面板            │
  │   预览区           │  ├ variant: [select] │
  │   (组件实时渲染)    │  ├ size: [select]    │
  │                    │  ├ text: [input]     │
  │                    │  ├ disabled: [switch]│
  │                    │  ├ color: [picker]   │
  │                    │  └ ...               │
  ├────────────────────┴─────────────────────┤
  │  生成代码 (只读文本区)                      │
  └──────────────────────────────────────────┘
  ```
- **支持的组件**: 先支持简单组件（UIButton, UIBadge, UIAlert, UIAvatar, UIProgress）
- **功能**:
  - 选择组件后，属性面板动态生成对应的 @export 属性编辑器
  - 修改属性 → 预览区实时更新 → 底部代码自动更新
  - 代码一键复制（UIToast 提示 "Copied!"）
- **技术挑战**:
  - 需要反射获取组件的 @export 属性列表
  - Godot 的 `get_property_list()` 可以获取属性元数据
  - 根据属性类型动态创建编辑控件

### 6.2 代码生成器
- **文件**: `scripts/pages/code_generator_page.gd`
- **目标**: 选择组件组合，自动生成页面搭建代码
- **功能**:
  - 左侧: 组件列表（拖拽或点击添加）
  - 中间: 页面结构预览（树形展示组件层级）
  - 右侧: 生成的 GDScript 代码
  - 支持的布局: VBox / HBox / Grid + Card 包裹
  - 可调整属性和顺序
- **生成代码示例**:
  ```gdscript
  func build(parent: Control) -> void:
      UI.page_header(parent, "My Page", "Generated page description")
      UI.section(parent, "Section 1")
      var card_v := UI.card(parent, 24, 20)
      var btn := UIButton.new()
      btn.text = "Click Me"
      btn.variant = UIButton.Variant.PRIMARY
      card_v.add_child(btn)
  ```
- **复杂度**: 较高，可简化为"模板选择器"（预设几种常见布局模板）

### 6.3 API 文档页面
- **文件**: `scripts/pages/api_docs_page.gd`
- **目标**: 每个组件的 API 参考文档，内嵌在展示应用中
- **布局**:
  ```
  ┌──────────────────────────────────────────┐
  │  [组件选择 UISelect]  [搜索 UIInput]       │
  ├──────────────────────────────────────────┤
  │  UIButton                                │
  │  继承: PanelContainer                     │
  │                                          │
  │  Properties                              │
  │  ┌──────────┬──────────┬───────────────┐ │
  │  │ Name     │ Type     │ Default       │ │
  │  ├──────────┼──────────┼───────────────┤ │
  │  │ text     │ String   │ ""            │ │
  │  │ variant  │ Variant  │ DEFAULT       │ │
  │  │ ...      │ ...      │ ...           │ │
  │  └──────────┴──────────┴───────────────┘ │
  │                                          │
  │  Signals                                 │
  │  • pressed() — 按钮被点击时触发             │
  │                                          │
  │  Examples                                │
  │  [内嵌代码块 + 预览]                        │
  └──────────────────────────────────────────┘
  ```
- **数据来源**: 硬编码的 Dictionary 数据结构，或解析 `get_property_list()`
- **搜索**: 组件名 / 属性名模糊搜索

## 侧边栏结构

新增 DEV TOOLS 分区（或放入 DESIGN 分区）:
```
DEV TOOLS (或 DESIGN 扩展)
├── Playground
├── Code Generator
└── API Docs
```

## 实现策略

### 阶段 1: Playground (核心价值最高)
- 先支持 5 个简单组件
- 属性面板使用现有组件（UIInput, UISelect, UISwitch）
- 代码生成用字符串拼接

### 阶段 2: API 文档
- 硬编码组件元数据（不依赖反射）
- 使用 UITable 展示属性列表
- 每个组件一个 section

### 阶段 3: 代码生成器 (可选)
- 工作量最大，可以先做简版"模板选择器"
- 提供 3-5 种常见页面模板
- 选择后生成完整代码

## 技术挑战

1. **反射 / 属性发现**: `get_property_list()` 返回所有属性（含继承的），需要过滤
2. **动态编辑控件**: 根据属性类型（String/int/float/bool/enum/Color）创建不同编辑器
3. **代码生成**: 字符串拼接容易出错，需要良好的模板系统
4. **数据维护**: API 文档的数据需要与组件代码保持同步

## 优先级

| 工具 | 难度 | 价值 | 优先级 |
|------|------|------|--------|
| Playground | 高 | 高 | P1 — 核心 demo 亮点 |
| API Docs | 中 | 中 | P1 — 对使用者有用 |
| Code Generator | 高 | 中 | P2 — 可简化为模板选择器 |
