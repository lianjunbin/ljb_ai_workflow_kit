---
description: "管理后台编码规范 - TSX + Vue 分离架构"
---

# 编码规范

> 本文档定义了管理后台开发的核心编码规范，所有代理在生成代码时必须遵循。

---

## 🏗️ 核心架构：TSX + Vue 分离

### 设计理念

```
┌─────────────────────────────────────────────────────────────────┐
│                    TSX + Vue 分离架构                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────┐     ┌─────────────────────┐           │
│  │      .tsx 文件       │     │      .vue 文件       │           │
│  │      (Model)        │     │      (View)         │           │
│  ├─────────────────────┤     ├─────────────────────┤           │
│  │ • 业务逻辑          │     │ • 模板渲染          │           │
│  │ • 状态管理          │────→│ • 样式定义          │           │
│  │ • 数据处理          │     │ • 事件绑定          │           │
│  │ • API 调用封装      │     │ • 组件组合          │           │
│  │ • Hooks 导出        │     │ • Slots 定义        │           │
│  └─────────────────────┘     └─────────────────────┘           │
│                                                                 │
│  优势:                                                          │
│  ✅ 逻辑与视图分离，单一职责                                     │
│  ✅ .tsx 可独立测试                                              │
│  ✅ .vue 更专注于 UI 表现                                        │
│  ✅ 复杂逻辑不污染模板                                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 文件组织

```
src/views/user/
├── detail/
│   ├── index.vue              # View - 页面入口
│   ├── useUserDetail.tsx      # Model - 页面逻辑
│   ├── components/
│   │   ├── UserLogTable.vue   # View - 子组件
│   │   └── useUserLog.tsx     # Model - 子组件逻辑
│   └── types.ts               # 类型定义
```

### 代码示例

**❌ 不推荐：逻辑混在 Vue 中**

```vue
<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getUserDetail, getUserLogs } from '@/api/user'

const loading = ref(false)
const userDetail = ref(null)
const logs = ref([])
const page = ref(1)
const pageSize = ref(20)
const total = ref(0)

const hasMore = computed(() => logs.value.length < total.value)

async function fetchUserDetail(id: string) {
  loading.value = true
  try {
    userDetail.value = await getUserDetail(id)
  } finally {
    loading.value = false
  }
}

async function fetchLogs(id: string) {
  const res = await getUserLogs(id, { page: page.value, pageSize: pageSize.value })
  logs.value = res.list
  total.value = res.total
}

// ... 更多逻辑
</script>
```

**✅ 推荐：TSX + Vue 分离**

```tsx
// useUserDetail.tsx - Model 层
import { ref, computed } from 'vue'
import { getUserDetail, getUserLogs } from '@/api/user'
import type { UserDetail, OperationLog, PageParams } from './types'

export function useUserDetail(userId: string) {
  // 状态
  const loading = ref(false)
  const userDetail = ref<UserDetail | null>(null)

  // 操作
  async function fetchDetail() {
    loading.value = true
    try {
      userDetail.value = await getUserDetail(userId)
    } finally {
      loading.value = false
    }
  }

  return {
    // 解构导出
    loading,
    userDetail,
    fetchDetail,
  }
}

export function useUserLog(userId: string) {
  const { logs, page, pageSize, total, loading, fetchLogs, hasMore } = useLogList(() =>
    getUserLogs(userId, { page: page.value, pageSize: pageSize.value })
  )

  return {
    logs,
    page,
    pageSize,
    total,
    loading,
    hasMore,
    fetchLogs,
  }
}
```

```vue
<!-- index.vue - View 层 -->
<script setup lang="ts">
import { useUserDetail, useUserLog } from './useUserDetail'
import UserLogTable from './components/UserLogTable.vue'

const props = defineProps<{ userId: string }>()

// 解构赋值，清晰明了
const { loading, userDetail, fetchDetail } = useUserDetail(props.userId)
const { logs, page, pageSize, total, fetchLogs } = useUserLog(props.userId)

fetchDetail()
</script>

<template>
  <div class="user-detail">
    <UserInfo :user="userDetail" :loading="loading" />

    <UserLogTable
      :logs="logs"
      :loading="loading"
      v-model:page="page"
      v-model:pageSize="pageSize"
      :total="total"
      @refresh="fetchLogs"
    />
  </div>
</template>
```

---

## 📦 解构赋值规范

### 基本原则

1. **Hook 返回值必须使用解构赋值**
2. **Props 接收使用解构赋值**
3. **API 响应使用解构赋值**
4. **对象参数使用解构赋值**

### 示例

```tsx
// ✅ 推荐：Hook 返回解构
const { loading, data, error, refresh } = useRequest(fetchData)

// ✅ 推荐：API 响应解构
const { list, total, page } = await getPagedData(params)

// ✅ 推荐：Props 解构
const { userId, readonly = false } = defineProps<{
  userId: string
  readonly?: boolean
}>()

// ✅ 推荐：函数参数解构
function handlePageChange({ page, pageSize }: PageParams) {
  // ...
}

// ❌ 不推荐：不解构
const result = useRequest(fetchData)
console.log(result.loading, result.data)
```

### 重命名解构

```tsx
// 避免命名冲突时使用重命名
const { data: userList, loading: userLoading } = useUserList()
const { data: roleList, loading: roleLoading } = useRoleList()
```

---

## 🎨 样式规范

### 基本原则

1. **优先使用 pix-component 组件样式**
2. **遇到设计不佳时，参考 ui-ux-pro-max 思路优化**
3. **使用 CSS 变量保持一致性**
4. **响应式设计优先**

### ui-ux-pro-max 思路应用场景

```
┌──────────────────────────────────────────────────────────────┐
│  🎨 何时采用 ui-ux-pro-max 思路？                             │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ✅ 适用场景：                                                │
│     • 原设计视觉层次不清晰                                   │
│     • 信息密度过高，用户难以快速获取关键信息                  │
│     • 交互反馈不明确（hover、active、disabled 状态）         │
│     • 空状态、加载状态、错误状态处理不当                      │
│     • 表单布局杂乱，视觉引导不足                              │
│                                                              │
│  🎯 优化方向：                                                │
│     • 使用卡片布局增强视觉分组                                │
│     • 添加适当的间距和分隔线                                  │
│     • 使用图标和颜色增强信息层次                              │
│     • 添加过渡动画提升交互体验                                │
│     • 优化响应式断点                                          │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### 样式示例

```vue
<style scoped lang="scss">
// 使用 CSS 变量保持一致性
.user-detail {
  padding: var(--spacing-lg);

  // 卡片式布局
  &__card {
    background: var(--bg-secondary);
    border-radius: var(--radius-md);
    padding: var(--spacing-md);
    margin-bottom: var(--spacing-md);

    // 优雅的过渡效果
    transition: box-shadow 0.2s ease;

    &:hover {
      box-shadow: var(--shadow-md);
    }
  }

  // 响应式适配
  @media (max-width: 768px) {
    padding: var(--spacing-sm);
  }
}
</style>
```

---

## 📝 命名规范

### 文件命名

| 类型 | 格式 | 示例 |
|------|------|------|
| Vue 组件 | PascalCase | `UserLogTable.vue` |
| TSX Hook | camelCase + use前缀 | `useUserDetail.tsx` |
| 类型定义 | camelCase | `types.ts` |
| 工具函数 | camelCase | `formatDate.ts` |

### Hook 命名

```tsx
// ✅ 推荐：use + 名词/动词
useUserDetail()    // 获取用户详情
useUserLog()       // 获取用户日志
usePagedList()     // 分页列表逻辑
useForm()          // 表单逻辑
useDialog()        // 弹窗控制

// ❌ 不推荐
getUserDetailHook()  // 不需要 Hook 后缀
user()              // 缺少 use 前缀
```

### 解构导出命名

```tsx
// ✅ 推荐：语义化命名
return {
  // 状态
  loading,
  userDetail,

  // 计算属性
  hasPermission,
  displayName,

  // 方法（动词开头）
  fetchDetail,
  updateUser,
  deleteUser,
}
```

---

## 🔄 代码审查检查项

code-reviewer 在审查时会检查：

### TSX + Vue 分离

- [ ] 复杂逻辑是否抽离到 .tsx 文件
- [ ] .vue 文件是否只关注视图层
- [ ] Hook 是否正确导出和使用

### 解构赋值

- [ ] Hook 返回值是否使用解构
- [ ] Props 是否使用解构
- [ ] API 响应是否使用解构

### 样式规范

- [ ] 是否优先使用 pix-component
- [ ] 视觉层次是否清晰
- [ ] 是否使用 CSS 变量
- [ ] 是否考虑响应式

---

## 📚 参考资源

- [Vue 3 Composition API](https://vuejs.org/guide/extras/composition-api-faq.html)
- [TSX in Vue](https://vuejs.org/guide/extras/render-function.html)
- [pix-component 组件库](内部文档)
- [ui-ux-pro-max Skill](Claude Code 内置)
