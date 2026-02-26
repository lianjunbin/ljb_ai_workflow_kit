# 完整教程：从零开始使用 Admin Workflow

> 本教程模拟一个真实需求的完整开发流程，从 Jira 需求到代码提交。
> 预计阅读时间：10 分钟 | 实操时间：15 分钟

---

## 准备工作

### 1. 确认环境

```bash
claude --version    # Claude Code CLI（必需）
node --version      # Node.js 18+（必需）
```

### 2. 全局安装工作流（如果还没装）

```bash
# 克隆并安装（安装到 ~/.claude/ 目录，所有项目通用）
git clone https://github.com/lianjunbin/ljb_ai_workflow_kit.git
cd ljb_ai_workflow_kit
./install.sh

# 安装完成标志: "✅ 所有核心文件验证通过！"
```

### 3. 确认安装成功

```bash
ls ~/.claude/skills/admin-workflow/
# 应看到 00-admin.md 到 07-archive.md（共 9 个文件）
```

> 已经安装过？直接跳到下面的「教程场景」。

---

## 教程场景

> **Jira 任务 PIX-8456**: 用户详情页 - 新增操作日志 Tab
>
> 需求描述：在用户详情页添加"操作日志"Tab，展示用户的登录、修改、操作等日志记录，支持按时间和操作类型筛选。

---

## 第一步：初始化项目（仅首次）

```bash
cd your-admin-project
claude
```

进入 Claude Code 后：

```
你: /admin:init
```

AI 会自动检测项目技术栈并生成配置：

```
AI: 🎬 项目初始化
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    📦 检测到的技术栈:
    ┌──────────────────────────────────────────┐
    │ 框架:    Vue 3 + TypeScript              │
    │ 构建:    Vite                            │
    │ UI 库:   pix-component                   │
    │ 状态:    Pinia                           │
    │ 路由:    Vue Router                      │
    └──────────────────────────────────────────┘

    📋 MCP 服务检测:
    ✅ jira - 已配置
    ⬚ context7 - 未配置（可选）
    ⬚ chrome-devtools - 未配置（可选）

    ✅ 已生成配置文件:
      📄 openspec/project.md
      📄 openspec/AGENTS.md
      📄 openspec/changes/archive/INDEX.md

    👉 下一步: /admin:start PIX-8456
```

> **注意：** `/admin:init` 只需执行一次。之后开始新需求直接用 `/admin:start`。

---

## 第二步：需求准备

### 方式 A：从 Jira 获取

```
你: /admin:start PIX-8456
```

```
AI: ┌─────────────────────────────────────────────────────┐
    │  📋 需求准备 - Step 0: 需求来源                      │
    │                                                      │
    │  检测到 Jira Issue Key: PIX-8456                     │
    │  [1] 📋 Jira Issue (自动获取)  ← 已自动选择          │
    │  [2] ✏️ 直接描述需求                                  │
    └─────────────────────────────────────────────────────┘

    ✅ 已从 Jira 获取需求
    ┌─────────────────────────────────────────────────────┐
    │  标题: 用户详情页 - 新增操作日志 Tab                  │
    │  类型: Story                                         │
    │  优先级: Medium                                      │
    │  工时: 3 days                                        │
    │  描述: 在用户详情页添加"操作日志"Tab，展示用户         │
    │       的登录、修改、操作等日志记录，支持按时间和        │
    │       操作类型筛选。                                   │
    │  验收标准:                                            │
    │    - 用户详情页新增"操作日志"Tab                      │
    │    - 支持按时间范围筛选                               │
    │    - 支持按操作类型筛选                               │
    │    - 分页展示日志列表                                 │
    └─────────────────────────────────────────────────────┘
```

### 方式 B：直接描述需求（无 Jira）

```
你: /admin:start
```

```
AI: ┌─────────────────────────────────────────────────────┐
    │  📋 需求准备 - Step 0: 需求来源                      │
    │                                                      │
    │  请选择需求来源:                                      │
    │  [1] 📋 Jira Issue (自动获取)                        │
    │  [2] ✏️ 直接描述需求 (手动输入)                       │
    └─────────────────────────────────────────────────────┘

你: 2

AI: 请输入需求标题:
你: 用户详情页 - 新增操作日志 Tab

AI: 请描述功能需求（越详细越好）:
你: 在用户详情页添加"操作日志"Tab，展示用户的操作日志记录，
    支持按时间和操作类型筛选，分页展示。

AI: 有验收标准吗？(可选，直接回车跳过)
你: [回车跳过]

AI: 有参考页面或设计稿吗？(可选)
你: 参考订单详情页的日志 Tab
```

### 引导性问题

无论哪种方式，AI 都会问几个引导性问题：

```
AI: 💡 几个引导性问题，帮我更好地理解需求:

    Q1: 操作日志的数据量大吗？需要虚拟滚动还是普通分页？
    Q2: 操作类型有哪些？是后端定义还是前端枚举？
    Q3: 有没有类似的功能可以参考？
    Q4: 是否涉及导出功能？

你: Q1 普通分页。Q2 后端返回操作类型枚举。
    Q3 参考订单日志页面。Q4 暂不需要导出。
```

### API 文档收集（可选）

```
AI: 📡 API 文档收集
    需要收集后端 API 文档吗？（可提升字段定义精度）

    [1] 🤖 智能获取 - 提供 Apifox 分享链接
    [2] 📋 手动提供 - 复制 Markdown / 截图
    [3] ⏭️ 跳过 - 后续再补充

你: 1

AI: 请输入 Apifox 分享链接:
你: https://apifox.truesightai.com/apidoc/shared/xxx

AI: 🤖 正在自动获取 API 文档...
    ✅ 已获取 2 个接口:
    ├── GET /api/user/{id}/logs - 获取用户操作日志列表
    └── GET /api/user/log-types - 获取操作类型枚举
```

> **提示：** 如果 API 还没定好，选 [3] 跳过，DESIGN 阶段会根据需求推测字段。

### 代码分析

```
AI: 🔍 Step 3: 业务上下文分析
    正在启动 code-explorer 分析代码库...

    ┌─ 探索结果 ─────────────────────────────────────────┐
    │                                                      │
    │ 📍 入口文件:                                         │
    │   src/views/user/UserDetail.vue                      │
    │   └── 使用 el-tabs 组件，目前有 3 个 Tab             │
    │                                                      │
    │ 🔍 类似功能:                                         │
    │   src/views/order/components/OrderLogTable.vue       │
    │   └── 订单日志表格，结构可复用                       │
    │                                                      │
    │ 📦 可复用组件:                                       │
    │   pix-table（标准表格）                               │
    │   pix-date-range-picker（日期范围选择器）             │
    │                                                      │
    │ 🏗️ 架构模式:                                        │
    │   TSX + Vue 分离                                     │
    │   useXxx Hook 封装逻辑                               │
    │   API 统一定义在 src/api/                            │
    │                                                      │
    └──────────────────────────────────────────────────────┘

    📊 复杂度评估: 42/100 (简单需求)
    ⏱️ 推荐设计策略: 快速模式（1 个方案）

    ✅ 已生成:
      📄 openspec/changes/PIX-8456/proposal.md
      📄 openspec/changes/PIX-8456/analysis.md

    👉 下一步: /admin:design
```

---

## 第三步：方案设计

```
你: /admin:design
```

```
AI: 🎨 提案设计
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    📊 基于复杂度评估 (42/100)，推荐快速模式。
    直接生成方案？

    [Y] 是，快速生成 1 个方案
    [N] 不，让我选择模式
        [1] 🚀 快速 - 1 个方案
        [2] ⭐ 标准 - 2 个方案对比
        [3] 💎 深度 - 3 个方案对比

你: Y
```

```
AI: 🎨 方案生成中...
    ├── 📐 分析数据流向
    ├── 📦 匹配可复用组件
    └── 🔐 检测权限需求

    ✅ 方案已生成

    ┌─ 方案概要 ─────────────────────────────────────────┐
    │                                                      │
    │ 📋 任务清单（4 个任务）                              │
    │                                                      │
    │ T1: 新增 API 类型定义                                │
    │   📁 新建 src/api/user-log.ts                       │
    │   📝 定义 UserLog 接口、请求参数、响应类型           │
    │                                                      │
    │ T2: 新增 useUserLog Hook                             │
    │   📁 新建 src/views/user/hooks/useUserLog.tsx        │
    │   📝 封装日志列表查询、筛选、分页逻辑               │
    │   💡 参考 useOrderLog 的实现                         │
    │                                                      │
    │ T3: 新增 UserLogTable 组件                           │
    │   📁 新建 src/views/user/components/UserLogTable.vue │
    │   📝 使用 pix-table + pix-date-range-picker          │
    │   💡 复用 OrderLogTable 的表格列配置                  │
    │                                                      │
    │ T4: 修改用户详情页                                   │
    │   📁 修改 src/views/user/UserDetail.vue              │
    │   📝 在 el-tabs 中添加"操作日志" Tab                 │
    │   📝 引入 UserLogTable 组件                          │
    │                                                      │
    │ ─────────────────────────────────────────────────── │
    │                                                      │
    │ 🔐 权限配置:                                        │
    │   接口权限: user:log:list (查看操作日志)             │
    │   路由权限: 无新增（复用用户详情页权限）             │
    │   按钮权限: 无新增                                   │
    │                                                      │
    │ 📊 统计:                                             │
    │   新增文件: 3 个                                     │
    │   修改文件: 1 个                                     │
    │   预计代码: ~150 行                                  │
    │   复用度: 高（参考 OrderLogTable）                   │
    │                                                      │
    └──────────────────────────────────────────────────────┘

    ✅ 已更新:
      📄 openspec/changes/PIX-8456/proposal.md
      📄 openspec/changes/PIX-8456/tasks.md

    👉 下一步: /admin:audit
```

> **如果不满意：** 直接告诉 AI 你的想法，或者 `/admin:design -r` 修改提案。

---

## 第四步：审阅提案

```
你: /admin:audit
```

```
AI: 📑 提案审阅
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    📋 提案概要:
    PIX-8456 - 用户详情页新增操作日志 Tab
    任务数: 4 | 新增: 3 文件 | 修改: 1 文件

    🔍 逐任务代码预览:
    ──────────────────────────────────────────────

    T1: src/api/user-log.ts (新建)
    ┌──────────────────────────────────────────┐
    │ export interface UserLog {                │
    │   id: number                             │
    │   userId: number                         │
    │   action: string                         │
    │   detail: string                         │
    │   createdAt: string                      │
    │ }                                        │
    │                                          │
    │ export function getUserLogs(params) {     │
    │   return request.get('/user/{id}/logs')  │
    │ }                                        │
    └──────────────────────────────────────────┘

    T2: src/views/user/hooks/useUserLog.tsx (新建)
    [代码预览...]

    T3: src/views/user/components/UserLogTable.vue (新建)
    [代码预览...]

    T4: src/views/user/UserDetail.vue (修改)
    [差异预览: + 添加 Tab + 引入组件]

    ──────────────────────────────────────────────

    📊 影响分析:
    ┌──────────────────────────────────────────┐
    │ 影响范围: 仅用户详情页模块               │
    │ 高风险项: 0                              │
    │ 中风险项: 0                              │
    │ 低风险项: 1 (新增 Tab 需确认路由配置)     │
    └──────────────────────────────────────────┘

    ✅ 审阅通过！

    确认进入 APPLY 阶段？(Y/n)
你: Y

    👉 下一步: /admin:apply
```

---

## 第五步：应用代码

```
你: /admin:apply
```

```
AI: ⚡ 应用代码
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    📋 待执行任务: 4 个
    ──────────────────────────────────────────────

    ⚡ 任务 1/4: 新建 src/api/user-log.ts
    [显示完整代码...]

    确认? (Y继续/S跳过/P暂停/?帮助)
你: Y

    ✅ 任务 1 完成

    ──────────────────────────────────────────────

    ⚡ 任务 2/4: 新建 src/views/user/hooks/useUserLog.tsx
    [显示完整代码...]

    确认? (Y/S/P/?)
你: Y

    ✅ 任务 2 完成

    ──────────────────────────────────────────────

    ⚡ 任务 3/4: 新建 src/views/user/components/UserLogTable.vue
    [显示完整代码...]

    确认? (Y/S/P/?)
你: Y

    ✅ 任务 3 完成

    ──────────────────────────────────────────────

    ⚡ 任务 4/4: 修改 src/views/user/UserDetail.vue
    [显示差异...]

    确认? (Y/S/P/?)
你: Y

    ✅ 任务 4 完成

    ──────────────────────────────────────────────

    ✅ 全部任务完成！

    📊 执行摘要:
    ┌──────────────────────────────────────────┐
    │ 已完成: 4/4                              │
    │ 已跳过: 0                                │
    │ 新增文件: 3 个                           │
    │ 修改文件: 1 个                           │
    └──────────────────────────────────────────┘

    👉 下一步: /admin:review
```

---

## 第六步：代码走读

```
你: /admin:review
```

```
AI: 🔍 代码走读
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    📋 本次改动文件 (4 个):

    1/4 src/api/user-log.ts
    ✅ 类型定义规范
    ✅ API 函数命名正确

    2/4 src/views/user/hooks/useUserLog.tsx
    ✅ Hook 解构导出正确
    ✅ TSX + Vue 分离规范

    3/4 src/views/user/components/UserLogTable.vue
    ⚠️ 【Optimize】建议添加空状态提示
        原: <pix-table :data="logList" />
        改: <pix-table :data="logList">
              <template #empty>暂无操作日志</template>
            </pix-table>
    ✅ 组件结构规范

    4/4 src/views/user/UserDetail.vue
    ✅ Tab 集成正确
    ✅ 组件引入规范

    ──────────────────────────────────────────────

    📊 走读总结:
    ┌──────────────────────────────────────────┐
    │ ✅ 通过: 3 个文件                        │
    │ ⚠️ 建议: 1 个优化项                     │
    │ ❌ 阻断: 0                               │
    └──────────────────────────────────────────┘

    是否采纳优化建议? (Y/n)
你: Y

    ✅ 已应用 1 个优化

    ──────────────────────────────────────────────

    📝 Git 提交建议:

    ┌──────────────────────────────────────────────────────┐
    │ 【Feature】用户详情页-新增操作日志 Tab                 │
    │                                                       │
    │ - 新增用户操作日志 API 及类型定义                      │
    │ - 新增 useUserLog Hook 封装日志逻辑                    │
    │ - 新增 UserLogTable 组件展示日志列表                   │
    │ - 用户详情页添加操作日志 Tab                           │
    └──────────────────────────────────────────────────────┘

    执行命令:
    git add src/api/user-log.ts \
            src/views/user/hooks/useUserLog.tsx \
            src/views/user/components/UserLogTable.vue \
            src/views/user/UserDetail.vue
    git commit -m "【Feature】用户详情页-新增操作日志 Tab

    - 新增用户操作日志 API 及类型定义
    - 新增 useUserLog Hook 封装日志逻辑
    - 新增 UserLogTable 组件展示日志列表
    - 用户详情页添加操作日志 Tab"

    ⚠️ 仅为建议，请确认后手动执行

    👉 下一步: /admin:archive（或手动 git commit）
```

---

## 第七步：归档

```
你: /admin:archive
```

```
AI: 📦 归档提案
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    确认归档以下提案？
    ┌──────────────────────────────────────────┐
    │ 提案: PIX-8456                           │
    │ 标题: 用户详情页新增操作日志 Tab          │
    │ 文件: proposal.md, tasks.md, analysis.md  │
    │ 目标: openspec/changes/archive/           │
    └──────────────────────────────────────────┘

    (Y/n)
你: Y

    ✅ 已归档至 openspec/changes/archive/PIX-8456/
    ✅ 已更新 archive/INDEX.md

    ──────────────────────────────────────────────

    🎉 工作流完成！

    📊 本次需求摘要:
    ┌──────────────────────────────────────────┐
    │ 需求: PIX-8456 用户操作日志              │
    │ 新增文件: 3 个                           │
    │ 修改文件: 1 个                           │
    │ 代码行数: ~150 行                        │
    │ 权限配置: user:log:list                  │
    │ 总耗时: ~13 分钟                         │
    └──────────────────────────────────────────┘
```

---

## 进阶技巧

### 1. 跳过分析，快速开发

对于非常简单的需求（改个文案、加个字段）：

```bash
/admin:start PIX-xxx -q     # 减少引导问题
/admin:design -q -a          # 快速模式 + 自动选择
/admin:apply                 # 应用
/admin:review                # 走读
```

### 2. 深度设计，多方案对比

对于复杂需求（新模块、大重构）：

```bash
/admin:start PIX-xxx -f     # 完整引导，收集更多上下文
/admin:design -d             # 深度模式，3 个方案对比
# 选择最佳方案后
/admin:audit                 # 详细审阅
/admin:apply                 # 应用
```

### 3. 中途暂停和回滚

```bash
/admin:apply
# 执行到第 3 个任务时发现问题
# 输入 P 暂停
# 选择保留任务 1-2，回滚任务 3
# 回到 DESIGN 修改方案
/admin:design -r             # 修改现有提案
/admin:apply -c              # 从暂停处继续
```

### 4. 不满意就重来

```bash
# DESIGN 阶段可以无限迭代
/admin:design                # 不满意？
/admin:design -r             # 告诉 AI 你的想法，重新设计
/admin:design -r             # 再调整...
# 直到满意为止
```

---

## 卸载工作流

不需要了？一键清除：

```bash
cd ljb_ai_workflow_kit
./uninstall.sh
```

安全卸载，只删除工作流自己的文件，不影响 MCP 配置和其他工具。详见 [README - 完全卸载](../README.md#️-完全卸载)。

---

## 下一步

- 遇到问题？查看 [故障排除](../README.md#-故障排除)
- 团队成员上手？查看 [ONBOARDING.md](ONBOARDING.md)
- 了解设计原则？查看 [WORKFLOW-PRINCIPLES.md](WORKFLOW-PRINCIPLES.md)
