# Direction 4: 更多 Scene 示例

## 目标

通过更多完整的应用场景页面，展示组件库的组合能力和实际应用价值。
Scene 页面不新增组件，而是用现有组件搭建接近真实应用的 UI。

## 当前已有 Scenes
- **Login Form** — 登录表单
- **Dashboard** — 数据仪表盘
- **Settings** — 设置页

## 新增 Scene 清单

### 4.1 E-commerce Scene
- **文件**: `scripts/pages/ecommerce_scene_page.gd`
- **内容**:
  - 顶部: 搜索栏 + 购物车图标（UINotificationBadge）
  - 商品网格: 卡片布局（UICard + 图片占位 + 价格 + UIRating）
  - 侧边筛选: UICheckbox 分类筛选 + UISlider 价格区间
  - 商品详情弹窗: UIModal 内展示详情
  - 底部: UIPagination 分页
- **使用组件**: UICard, UIButton, UIBadge, UIInput, UICheckbox, UISlider, UIModal, UIPagination, UINotificationBadge

### 4.2 Chat UI Scene
- **文件**: `scripts/pages/chat_scene_page.gd`
- **内容**:
  - 左侧: 会话列表（UIAvatar + 名称 + 最后消息 + 时间）
  - 右侧: 消息区
    - 消息气泡: 区分自己/对方，不同背景色
    - 时间戳分隔线
    - 底部: 输入框 + 发送按钮 + 附件按钮
  - 顶部: 对方头像 + 名称 + 在线状态（绿色圆点）
- **使用组件**: UIAvatar, UIInput, UIButton, UIDivider, UIBadge, UIToast
- **交互**: 输入消息后点发送，消息出现在聊天区

### 4.3 File Manager Scene
- **文件**: `scripts/pages/file_manager_scene_page.gd`
- **内容**:
  - 左侧: 文件夹树（UITreeView）
  - 顶部: 面包屑导航（UIBreadcrumb）+ 视图切换（网格/列表）
  - 中间: 文件列表（UITable）或文件网格
  - 右键菜单: UIContextMenu（新建/重命名/删除）
  - 底部状态栏: 文件数量 + 已选中数量
- **使用组件**: UITreeView, UIBreadcrumb, UITable, UIContextMenu, UIButton, UIModal (确认删除)

### 4.4 Kanban Board Scene
- **文件**: `scripts/pages/kanban_scene_page.gd`
- **内容**:
  - 水平滚动的多列看板: To Do / In Progress / Review / Done
  - 每列: 标题 + 计数 + 任务卡片列表
  - 任务卡片: 标题 + UITag 标签 + UIAvatar 负责人 + 优先级色条
  - 添加任务: UIModal + UIInput + UISelect (列选择)
  - 顶部: 项目名 + 筛选下拉
- **使用组件**: UICard, UITag, UIAvatar, UIButton, UIModal, UIInput, UISelect, UIBadge

### 4.5 Calendar App Scene
- **文件**: `scripts/pages/calendar_scene_page.gd`
- **内容**:
  - 左侧: 迷你月历 + 日程列表
  - 中间: 完整月视图（或周视图），日期格子内显示事件色条
  - 添加事件: UIDrawer 侧边抽屉 + 表单（UIInput 标题 + UIDatePicker 日期 + UISelect 类型）
  - 事件详情: UIModal 弹窗
- **使用组件**: UIDatePicker, UIDrawer, UIModal, UIInput, UISelect, UIButton, UITag
- **依赖**: 如果 D3 的 UICalendar 已完成则直接使用，否则内联实现简版

### 4.6 Data Dashboard Pro Scene
- **文件**: `scripts/pages/dashboard_pro_scene_page.gd`
- **内容**:
  - 顶部: 4 个统计卡片（总用户/收入/订单/转化率）
  - 中间: 图表区（如果 D3 UIChart 已完成）或占位图表
  - 左下: 最近订单表格（UITable）
  - 右下: 活动时间线（UITimeline）
  - 顶部筛选: UISelect 时间范围 + UISegmentedControl 视图切换
- **使用组件**: UITable, UITimeline, UISelect, UICard, UIBadge, UIAvatar, UIProgress
- **注意**: 比现有 Dashboard 更复杂，是其"Pro"版

## 侧边栏结构

SCENES 分区扩展:
```
SCENES
├── Login Form        (已有)
├── Dashboard         (已有)
├── Settings          (已有)
├── E-commerce        (新增)
├── Chat              (新增)
├── File Manager      (新增)
├── Kanban            (新增)
├── Calendar          (新增)
└── Dashboard Pro     (新增)
```

## 实现策略

1. **优先做与现有组件契合度最高的**: Chat UI 和 File Manager 几乎完全用现有组件
2. **有 D3 依赖的放后面**: Calendar App 和 Dashboard Pro 依赖图表/日历组件
3. **每个 Scene 控制在 300-500 行**: 不需要真实数据，mock 数据即可
4. **保持交互性**: 每个 Scene 至少有 2-3 个可交互的地方

## 优先级

| Scene | 难度 | 组件覆盖率 | 优先级 |
|-------|------|-----------|--------|
| Chat UI | 中 | 高 | P0 |
| File Manager | 中 | 高 | P0 |
| E-commerce | 中 | 高 | P1 |
| Kanban Board | 中 | 中 | P1 |
| Calendar App | 高 | 中 | P2 (依赖 D3) |
| Dashboard Pro | 高 | 高 | P2 (依赖 D3) |
