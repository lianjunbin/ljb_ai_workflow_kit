# 管理后台 AI 开发工作流

> **变更 ID**: `add-admin-workflow`
> **创建日期**: 2026-02-10
> **更新日期**: 2026-02-11
> **版本**: 1.1.0
> **状态**: ✅ 已完成

---

## 概述

基于 Claude Code Skills 规范，为管理后台业务功能开发设计的 AI 工作流。聚焦于 **Jira 需求 + Apifox API 文档** 驱动的业务功能开发。

---

## 核心特性

### v1.1 新增特性（2026-02-11）

1. **8 阶段工作流**：拆分 EXECUTE 为 APPLY/END/ARCHIVE
2. **多轮迭代**：ANALYZE/DESIGN/REVIEW 三阶段均支持
3. **选择性回滚**：暂停后可选择保留已完成任务
4. **TSX + Vue 分离**：.tsx 负责 Model，.vue 负责 View
5. **解构赋值规范**：Hook 返回值必须支持解构
6. **人性化界面**：Banner、进度条、阶段卡片、白话文引导

### v1.0 基础特性

- 多代理协同
- 思考模式支持（think/think-hard/ultra-think）
- Apifox API 文档集成（可选）
- pix-component 组件复用
- 增量代码审查和简化

---

## 八阶段工作流

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  🎬 INIT ─→ 项目初始化                                              │
│     │       检测技术栈，生成配置文件                                 │
│     ↓                                                               │
│  📋 START ─→ 需求获取 + 代码探索                                    │
│     │        从 Jira 拉取需求，并行探索代码库                        │
│     ↓                                                               │
│  🔍 ANALYZE ─→ 业务分析 ←─────┐                                     │
│     │          分析现有功能   │ 🔄 可多轮迭代                       │
│     └─────── 满意? ──────────┘                                      │
│     ↓                                                               │
│  🎨 DESIGN ─→ 提案设计 ←──────┐                                     │
│     │         多方案架构设计  │ 🔄 可多轮迭代                       │
│     └─────── 满意? ──────────┘                                      │
│     ↓                                                               │
│  🔎 REVIEW ─→ 提案审查 ←──────┐                                     │
│     │         影响分析       │ 🔄 可多轮迭代                        │
│     └─────── 满意? ──────────┘                                      │
│     ↓                                                               │
│  ⚡ APPLY ─→ 应用代码                                               │
│     │        逐任务确认执行                                         │
│     │        └── 需要补充? → 暂停 + 选择性回滚 → 回到 DESIGN        │
│     ↓                                                               │
│  ✨ END ─→ 走查                                                     │
│     │      代码审查 + 增量简化 + Git 提交建议                        │
│     ↓                                                               │
│  📦 ARCHIVE ─→ 归档                                                 │
│               提案归档，更新索引                                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 各阶段职责

| 阶段 | 命令 | 核心任务 | 输出 |
|------|------|---------|------|
| **INIT** | `/admin:init` | 项目初始化、技术栈检测 | `openspec/` 结构 |
| **START** | `/admin:start <JIRA_KEY>` | Jira 需求获取、API 文档获取、代码探索 | `AI-PRD-*.md` |
| **ANALYZE** | `/admin:analyze` | 业务分析、可复用资源识别 | `before.md` |
| **DESIGN** | `/admin:design` | 多方案设计、用户选择 | `proposal.md` + `tasks.md` |
| **REVIEW** | `/admin:audit` | 影响分析 + 可行性审查 | 审查报告 |
| **APPLY** | `/admin:apply` | 逐任务确认执行 | 功能代码 |
| **END** | `/admin:end` | 代码审查 + 简化 + Git 建议 | 审查报告 |
| **ARCHIVE** | `/admin:archive` | 提案归档 | 更新索引 |

---

## 多代理协同

```
START 阶段
├── code-explorer × 1-3（并行探索）
└── api-parser × 1（可选）
         ↓
ANALYZE 阶段
└── brainstorming skill 🔄
         ↓
DESIGN 阶段
└── code-architect × 1-3（并行设计）🔄
         ↓
REVIEW 阶段
└── impact-analyzer × 1 🔄
         ↓
APPLY 阶段
└── 逐任务确认（可暂停 + 选择性回滚）
         ↓
END 阶段
├── code-reviewer × 1
└── code-simplifier × 1
         ↓
ARCHIVE 阶段
└── 归档 + 更新索引
```

---

## 编码规范

### TSX + Vue 分离

```tsx
// useUserDetail.tsx - Model 层
export function useUserDetail(userId: string) {
  const loading = ref(false)
  const userDetail = ref<UserDetail | null>(null)

  return {
    loading,
    userDetail,
    fetchDetail,
  }
}
```

```vue
<!-- index.vue - View 层 -->
<script setup lang="ts">
const { loading, userDetail, fetchDetail } = useUserDetail(props.userId)
</script>
```

---

## 验收标准

- [x] 8 阶段工作流完整实现
- [x] 多轮迭代支持（ANALYZE/DESIGN/REVIEW）
- [x] 选择性回滚能力
- [x] TSX + Vue 分离规范
- [x] 人性化输出风格
- [x] MCP 依赖检查
- [x] 自动化安装/卸载脚本

---

**文档版本**: v1.1
**最后更新**: 2026-02-11
