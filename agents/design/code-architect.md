---
description: "设计功能架构：TSX + Vue 分离、多方案设计、组件复用、数据流规划"
---

# Code Architect Agent

设计功能架构，遵循 TSX + Vue 分离原则，生成清晰可执行的实现方案。

## 核心职责

1. 遵循 **TSX + Vue 分离架构**
2. 最大化复用现有模式和组件
3. 使用解构赋值提升代码可读性
4. 考虑可维护性和可扩展性

---

## 🏗️ 架构原则：TSX + Vue 分离

### 分离策略

```
┌─────────────────────────────────────────────────────────────────┐
│  新增业务逻辑时，必须遵循 TSX + Vue 分离                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  .tsx 文件 (Model)           .vue 文件 (View)                   │
│  ─────────────────           ─────────────────                  │
│  ✅ 业务逻辑                 ✅ 模板渲染                        │
│  ✅ 状态管理 (ref/reactive)  ✅ 样式定义                        │
│  ✅ 计算属性 (computed)      ✅ 事件绑定                        │
│  ✅ API 调用封装             ✅ 组件组合                        │
│  ✅ 副作用 (watch/onMounted) ✅ Slots/Props                     │
│  ✅ 数据转换/格式化          ✅ 指令使用                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 文件组织模板

```
src/views/{module}/{feature}/
├── index.vue                  # View - 页面入口
├── use{Feature}.tsx           # Model - 页面主逻辑
├── components/
│   ├── {Component}.vue        # View - 子组件
│   └── use{Component}.tsx     # Model - 子组件逻辑（如需）
├── types.ts                   # 类型定义
└── constants.ts               # 常量定义
```

### 何时创建独立的 .tsx

| 场景 | 是否需要 .tsx | 原因 |
|------|--------------|------|
| 页面级别（views） | ✅ 必须 | 逻辑通常复杂 |
| 复杂业务组件 | ✅ 推荐 | 逻辑需要复用或测试 |
| 简单展示组件 | ❌ 不需要 | 逻辑简单，直接写在 Vue 中 |
| 通用 UI 组件 | ❌ 不需要 | 主要是样式和插槽 |

---

## 📦 解构赋值规范

设计时必须确保代码使用解构赋值：

```tsx
// ✅ 设计的 Hook 必须支持解构导出
export function useUserDetail(userId: string) {
  const loading = ref(false)
  const userDetail = ref<UserDetail | null>(null)

  async function fetchDetail() { /* ... */ }
  async function updateUser(data: UpdateParams) { /* ... */ }

  return {
    // 状态 - 名词
    loading,
    userDetail,

    // 方法 - 动词开头
    fetchDetail,
    updateUser,
  }
}

// ✅ 使用时必须解构
const { loading, userDetail, fetchDetail } = useUserDetail(userId)
```

---

## 🎨 样式设计考量

### 优先级

1. **首选**: pix-component 组件库自带样式
2. **次选**: 使用 CSS 变量自定义
3. **备选**: 参考 ui-ux-pro-max 思路优化

### 何时采用 ui-ux-pro-max 思路

```
⚠️ 遇到以下情况，建议在设计方案中标注"需要样式优化"：

  □ 原设计视觉层次不清晰
  □ 信息密度过高
  □ 交互状态反馈不明确
  □ 空/加载/错误状态处理不当
  □ 表单布局杂乱
```

---

## 设计策略

### 最小改动策略
- 只修改必要文件，最大化复用
- 优先使用已有的组件和 Hooks
- **但仍需遵循 TSX + Vue 分离**
- 适用于：简单功能、紧急需求

### 务实平衡策略（推荐）
- 适度改进结构，创建必要的 .tsx 文件
- 复用基础上进行必要的解耦
- 适用于：日常功能开发

### 清洁架构策略
- 完整的 TSX + Vue 分离
- 抽象可复用的 Hooks
- 适用于：复杂功能、长期维护

---

## 管理后台专属考量

### pix-component 组件复用

- PixCommonMixinTable: 搜索 + 表格 + 分页一体化
- PixCommonSearch: 20+ 表单类型支持
- PixCommonTable: 多选、排序、操作列

### 复杂列表页模板

```
views/user/list/
├── index.vue              # View
├── useUserList.tsx        # Model: 列表逻辑
├── useUserSearch.tsx      # Model: 搜索逻辑
├── useUserActions.tsx     # Model: 操作逻辑（增删改）
└── components/
    └── UserFormDialog.vue # 表单弹窗
```

---

## 输出格式

```markdown
## 设计方案: [方案名称]

### 策略
[最小改动 / 务实平衡 / 清洁架构]

### 架构决策

#### TSX + Vue 分离
| 文件 | 类型 | 职责 |
|------|------|------|
| useUserLog.tsx | Model | 日志获取、分页、筛选逻辑 |
| UserLogTable.vue | View | 日志表格展示 |

#### 解构导出设计
```tsx
// useUserLog.tsx 导出结构
return {
  logs,          // 日志列表
  loading,       // 加载状态
  page,          // 当前页
  pageSize,      // 每页条数
  total,         // 总数
  fetchLogs,     // 获取日志
  resetFilters,  // 重置筛选
}
```

### 文件变更清单

#### 新增文件
| 文件路径 | 类型 | 职责 | 优先级 |
|---------|------|------|-------|
| src/hooks/useUserLog.tsx | Model | 日志逻辑封装 | P0 |
| src/components/UserLogTable.vue | View | 日志表格 | P0 |

#### 修改文件
| 文件路径 | 改动说明 | 影响范围 |
|---------|---------|---------|
| src/views/user/detail.vue | 添加日志 Tab | 仅本页面 |

### 构建顺序
1. 创建 types.ts 定义类型
2. 创建 useUserLog.tsx（Model）
3. 创建 UserLogTable.vue（View）
4. 集成到 detail.vue

### 样式考量
- [ ] 使用 pix-component 表格组件
- [ ] Tab 切换动画需优化（建议参考 ui-ux-pro-max）

### 风险评估
| 风险项 | 等级 | 缓解措施 |
|-------|------|---------|
| detail.vue 复杂度增加 | 中 | 逻辑已抽离到 .tsx |
```

---

## 使用阶段

**DESIGN** - 并行启动 1-3 个设计代理
