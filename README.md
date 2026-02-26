# 管理后台 AI 开发工作流

> **从需求到代码，AI 全程协助。3 天的需求，1 天搞定。**

```
╭──────────────────────────────────────────────────────────────────╮
│                                                                  │
│     █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗                     │
│    ██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║                     │
│    ███████║██║  ██║██╔████╔██║██║██╔██╗ ██║                     │
│    ██╔══██║██║  ██║██║╚██╔╝██║██║██║╚██╗██║                     │
│    ██║  ██║██████╔╝██║ ╚═╝ ██║██║██║ ╚████║                     │
│    ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝                     │
│                                                                  │
│    🚀 管理后台 AI 开发工作流 v1.5                                 │
│    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│    从 Jira 需求到代码交付，AI 全程协助                            │
│                                                                  │
╰──────────────────────────────────────────────────────────────────╯
```

---

## 效果对标

| 指标 | 传统开发 | 使用工作流 | 提升 |
|------|---------|-----------|------|
| 需求分析 | 1-2 小时（读 Jira、翻代码、理逻辑） | 5 分钟（AI 自动完成） | **90%+** |
| 方案设计 | 2-4 小时（想架构、定文件、理依赖） | 10 分钟（多方案对比选择） | **85%+** |
| 权限配置 | 容易漏掉，上线才发现 | 自动检测，设计阶段就列清单 | **0 遗漏** |
| 代码编写 | 1-2 天 | 30 分钟（AI 写，你确认） | **80%+** |
| 代码审查 | 30 分钟-1 小时 | 5 分钟（AI 逐文件走读） | **80%+** |
| Git 提交 | 想半天 commit message | 自动生成规范格式 | **省心** |

---

## 目录

- [谁需要这个工作流？](#-谁需要这个工作流)
- [真实场景演示](#-真实场景演示一个需求从头到尾长什么样)
- [3 分钟快速上手](#-3-分钟快速上手)
- [完整安装指南](#-完整安装指南)
- [命令速查表](#-命令速查表)
- [更多使用场景](#-更多使用场景)
- [常见问题 FAQ](#-常见问题-faq)
- [故障排除](#-故障排除)
- [项目结构](#-项目结构)

---

## 🎯 谁需要这个工作流？

如果你是前端开发者，经常需要：

- ✅ 从 Jira 获取需求（或口头需求），然后开发管理后台功能
- ✅ 对接后端 API，希望接口参数不要写错
- ✅ 复用已有的组件和代码，不想重复造轮子
- ✅ 代码质量有保障，但不想花太多时间审查
- ✅ Git 提交规范，但记不住那些 commit 格式
- ✅ **权限配置不要漏掉**（接口权限、按钮权限、路由权限）

**那这个工作流就是为你设计的！**

---

## 🎬 真实场景演示：一个需求从头到尾长什么样？

> 假设你拿到 Jira 任务 **PIX-8456**：「用户详情页 - 新增操作日志 Tab」

### Step 1: 启动需求（2 分钟）

```
你: /admin:start PIX-8456

AI: ┌─────────────────────────────────────────────────────┐
    │  📋 需求准备 - Step 0: 需求来源                      │
    │                                                      │
    │  请选择需求来源:                                      │
    │  [1] 📋 Jira Issue (自动获取)                        │
    │  [2] ✏️ 直接描述需求 (手动输入)                       │
    └─────────────────────────────────────────────────────┘

你: 1

AI: ✅ 已从 Jira 获取需求
    ┌─────────────────────────────────────────────────────┐
    │  标题: 用户详情页 - 新增操作日志 Tab                  │
    │  优先级: Medium                                      │
    │  描述: 在用户详情页添加"操作日志"Tab，展示用户         │
    │       的登录、修改、操作等日志记录，支持按时间和        │
    │       操作类型筛选。                                   │
    └─────────────────────────────────────────────────────┘

    💡 几个引导性问题，帮我更好地理解需求:
    Q1: 操作日志需要支持导出吗？
    Q2: 日志数据量大吗？需要虚拟滚动吗？
    Q3: 有没有参考页面？比如已有的日志列表？

你: Q1不需要导出。Q2数据量一般，普通分页就行。Q3参考订单日志页。
```

### Step 2: API 文档收集（可选，1 分钟）

```
AI: 📡 需要收集 API 文档吗？（用于生成精确的字段定义）
    [1] 🤖 智能获取 - 提供 Apifox 分享链接，AI 自动下载
    [2] 📋 手动提供 - 复制 Markdown / 截图
    [3] ⏭️ 跳过 - 后续再补充

你: 3  （先跳过，API 还没定好）

AI: ✅ 已跳过，后续可随时补充
```

### Step 3: 代码分析 + 提案生成（3 分钟）

```
AI: 🔍 正在分析代码库...
    ├── 🔎 探索类似功能: 找到 OrderLogTable 组件（可复用）
    ├── 🔎 分析用户详情页: UserDetail.vue 使用 Tab 组件
    └── 🔎 识别架构模式: TSX + Vue 分离，Hook 封装

    ✅ 分析完成！
    ┌─────────────────────────────────────────────────────┐
    │  📊 复杂度评估: 42/100 (简单)                        │
    │  📁 预计改动: 4 个文件（2 新增 + 2 修改）             │
    │  ⏱️ 推荐策略: 快速模式（1 个方案）                    │
    │                                                      │
    │  ✅ 已生成:                                           │
    │    📄 openspec/changes/PIX-8456/proposal.md           │
    └─────────────────────────────────────────────────────┘

    👉 下一步: /admin:design
```

### Step 4: 方案设计（2 分钟）

```
你: /admin:design

AI: 🎨 基于分析结果，推荐快速模式。直接生成方案？
    [Y] 是，快速生成  [N] 不，我要选择模式

你: Y

AI: ✅ 方案已生成

    📋 方案概要:
    ┌──────────────────────────────────────────────────────┐
    │ 任务 1: 新增 API 类型定义                             │
    │   📁 src/api/user-log.ts (新建)                      │
    │                                                       │
    │ 任务 2: 新增 useUserLog Hook                          │
    │   📁 src/views/user/hooks/useUserLog.tsx (新建)       │
    │                                                       │
    │ 任务 3: 新增 UserLogTable 组件                        │
    │   📁 src/views/user/components/UserLogTable.vue (新建) │
    │   💡 复用 OrderLogTable 的表格结构                     │
    │                                                       │
    │ 任务 4: 修改用户详情页                                │
    │   📁 src/views/user/UserDetail.vue (修改)             │
    │   💡 添加"操作日志" Tab                               │
    │                                                       │
    │ 🔐 权限配置:                                          │
    │   • user:log:list - 查看操作日志                      │
    └──────────────────────────────────────────────────────┘

    👉 下一步: /admin:audit 审阅提案
```

### Step 5: 审阅 → 应用 → 走读（5 分钟）

```
你: /admin:audit
AI: ✅ 提案审阅通过，影响范围可控（4 个文件，0 个高风险项）
    👉 下一步: /admin:apply

你: /admin:apply
AI: ⚡ 任务 1/4: 新增 src/api/user-log.ts
    [代码预览...]
    确认? (Y/S跳过/P暂停): Y
    ✅ 完成

    ⚡ 任务 2/4: 新增 useUserLog.tsx
    ...✅ 完成

    ⚡ 任务 3/4: 新增 UserLogTable.vue
    ...✅ 完成

    ⚡ 任务 4/4: 修改 UserDetail.vue
    ...✅ 完成

    ✅ 全部任务完成！
    👉 下一步: /admin:review

你: /admin:review
AI: 🔍 逐文件走读...
    ✅ user-log.ts - 类型定义规范
    ✅ useUserLog.tsx - Hook 解构正确
    ⚠️ UserLogTable.vue - 建议添加空状态提示
    ✅ UserDetail.vue - Tab 集成正确

    是否采纳建议? (Y/n): Y
    ✅ 已优化

    📝 推荐 Git 提交:
    ┌──────────────────────────────────────────────────────┐
    │ 【Feature】用户详情页-新增操作日志 Tab                 │
    │                                                       │
    │ - 新增用户操作日志 API 及类型定义                      │
    │ - 新增 useUserLog Hook 封装日志逻辑                    │
    │ - 新增 UserLogTable 组件展示日志列表                   │
    │ - 用户详情页添加操作日志 Tab                           │
    └──────────────────────────────────────────────────────┘
```

### 结果

| 指标 | 值 |
|------|-----|
| 总耗时 | **~13 分钟** |
| 新增文件 | 3 个 |
| 修改文件 | 1 个 |
| 新增代码 | ~150 行 |
| 权限配置 | 1 个（user:log:list） |
| Git 提交 | 自动生成，复制即用 |

---

## ⚡ 3 分钟快速上手

### 第一步：检查前提条件

```bash
# 检查 Claude Code CLI（必需）
claude --version
# 期望输出: claude-code x.x.x

# 检查 Node.js（必需，MCP 服务运行时）
node --version
# 期望输出: v18.0.0+
```

> 没装 Claude Code？→ `npm install -g @anthropic-ai/claude-code`
> 没装 Node.js？→ https://nodejs.org/

### 第二步：全局安装工作流

> **什么是全局安装？** 工作流文件会安装到 `~/.claude/` 目录下（Claude Code 的用户配置目录），安装后**所有项目**都能使用 `/admin` 系列命令，无需每个项目单独安装。

```bash
# 克隆仓库
git clone https://github.com/lianjunbin/ljb_ai_workflow_kit.git
cd ljb_ai_workflow_kit

# 执行安装（自动检测环境、安装文件、验证结果）
./install.sh
```

**安装过程你会看到：**

```
╭──────────────────────────────────────────────────────────────────╮
│    🚀 管理后台 AI 开发工作流 v1.5                                 │
╰──────────────────────────────────────────────────────────────────╯

─── 阶段 1: 环境检测 ───
  ✅ 操作系统: macOS
  ✅ Claude Code CLI: claude-code 2.1.59
  ✅ Node.js: v22.13.1
  ✅ npx: 可用

─── 阶段 2: MCP 服务配置检测 ───
  ✅ Jira MCP: 已配置 ✓              ← 没配也没关系，可以跳过
  ℹ️ Chrome DevTools MCP: 未配置（可选）

─── 阶段 3: 安装 Skills 和 Agents ───
  → 安装 Skills...
  ✅ 已安装 9 个 Skill 文件
  → 安装 Agents（命名空间隔离）...
  ✅ 已安装 7 个 Agent 文件（4 个分组）
  ✅ 已创建安装清单: ~/.claude/admin-workflow-manifest.txt

─── 阶段 4: 验证安装 ───
  ✅ /admin:admin → 00-admin.md
  ✅ /admin:init → 01-init.md
  ✅ /admin:start → 02-start.md
  ✅ /admin:design → 03-design.md
  ✅ /admin:audit → 04-audit.md
  ✅ /admin:apply → 05-apply.md
  ✅ /admin:review → 06-review.md
  ✅ /admin:archive → 07-archive.md
  ✅ 所有核心文件验证通过！

─── 安装完成！───
  已安装命令:
    /admin          → 🚀 显示工作流总览
    /admin:init     → 🎬 初始化项目
    /admin:start    → 📋 需求准备
    /admin:design   → 🎨 提案设计
    /admin:audit    → 📑 提案审阅
    /admin:apply    → ⚡ 应用代码
    /admin:review   → 🔍 代码走读
    /admin:archive  → 📦 归档提案
```

**安装完成后文件位置：**

```
~/.claude/
├── skills/admin-workflow/           ← 8 个工作流命令
│   ├── 00-admin.md ~ 07-archive.md
│   └── README.md
├── agents/admin-workflow/           ← 7 个 AI 代理（命名空间隔离）
│   ├── explore/code-explorer.md
│   ├── design/code-architect.md
│   ├── audit/impact-analyzer.md, qa-arch-reviewer.md, qa-security-reviewer.md
│   └── review/code-reviewer.md, code-simplifier.md
└── admin-workflow-manifest.txt      ← 安装清单（卸载时用）
```

### 第三步：开始使用

```bash
# 1. 进入你的管理后台项目
cd your-admin-project

# 2. 启动 Claude Code
claude

# 3. 初始化项目（只需一次，约 1 分钟）
/admin:init
# 期望输出: ✅ 已生成 openspec/ 配置文件

# 4. 开始一个需求（二选一）
/admin:start PIX-1234          # 从 Jira 获取
/admin:start                   # 直接描述需求（无需 Jira）
```

**每一步都会告诉你下一步该做什么，跟着提示走就行！**

---

## 📦 完整安装指南

### 系统要求

| 类型 | 依赖 | 说明 | 检查命令 |
|------|------|------|---------|
| **必需** | Claude Code CLI | AI 助手运行环境 | `claude --version` |
| **必需** | Node.js 18+ | MCP 服务运行时 | `node --version` |
| 推荐 | Jira 账号 + API Token | 自动获取需求（也可手动输入） | — |
| 可选 | Apifox 分享链接 | AI 自动获取 API 文档 | — |
| 可选 | pix-component | 内部 UI 组件库 | — |

### 安装方式

#### 方式 1：克隆仓库安装（推荐）

```bash
git clone https://github.com/lianjunbin/ljb_ai_workflow_kit.git
cd ljb_ai_workflow_kit
./install.sh
```

#### 方式 2：一键远程安装

```bash
curl -fsSL https://raw.githubusercontent.com/lianjunbin/ljb_ai_workflow_kit/main/install.sh | bash
```

#### 方式 3：静默安装（跳过所有确认提示）

```bash
./install.sh -y
```

### 安装原理

安装脚本做了以下事情（不会影响你的其他配置）：

```
1. 检测环境（Claude Code CLI、Node.js、MCP 配置）
2. 复制 Skills 文件 → ~/.claude/skills/admin-workflow/
3. 复制 Agent 文件  → ~/.claude/agents/admin-workflow/   ← 命名空间隔离
4. 生成安装清单     → ~/.claude/admin-workflow-manifest.txt
5. 验证所有文件
```

**命名空间隔离**：所有 agent 文件都在 `admin-workflow/` 子目录下，卸载时只删除这个子目录，不会误删你安装的其他 AI 工具。

### 配置 Jira MCP（推荐，非必需）

> 没有 Jira？没关系，v1.5 支持直接描述需求，跳过此步即可。

1. 获取 Atlassian API Token:
   - 访问 https://id.atlassian.com/manage-profile/security/api-tokens
   - 点击「Create API token」
   - 复制生成的 Token

2. 编辑 `~/.claude/.mcp.json`：

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-atlassian@latest"],
      "env": {
        "ATLASSIAN_SITE_URL": "https://your-site.atlassian.net",
        "ATLASSIAN_USER_EMAIL": "your-email@company.com",
        "ATLASSIAN_API_TOKEN": "your-api-token"
      },
      "type": "stdio"
    }
  }
}
```

3. 重启 Claude Code 使配置生效。

### 安装验证

安装完后，快速检查：

```bash
# 一行命令验证全部（期望输出 3 个 ✅）
ls ~/.claude/skills/admin-workflow/*.md | wc -l && echo "✅ Skills OK" && \
ls ~/.claude/agents/admin-workflow/ && echo "✅ Agents OK" && \
cat ~/.claude/admin-workflow-manifest.txt | head -1 && echo "✅ Manifest OK"
```

或者直接在 Claude Code 中测试：

```bash
claude
/admin
# 期望: 看到工作流总览界面（ASCII Banner + 命令清单）
```

---

## 🗑️ 完全卸载

> 不需要了？一键卸载，干干净净，不影响你的其他配置。

### 方式 1：使用仓库脚本

```bash
cd ljb_ai_workflow_kit
./uninstall.sh
```

### 方式 2：远程卸载（没有保留仓库）

```bash
curl -fsSL https://raw.githubusercontent.com/lianjunbin/ljb_ai_workflow_kit/main/uninstall.sh | bash
```

### 卸载过程

```
╭──────────────────────────────────────────────────────────────────╮
│    🗑️  安全卸载程序 v1.5                                         │
╰──────────────────────────────────────────────────────────────────╯

✅ 检测到安装清单，将使用安全卸载模式

   安全卸载：只删除本工作流安装的文件
   不会影响：其他 AI 工具、MCP 配置、项目文件

将删除以下文件（来自安装清单）:
  • ~/.claude/skills/admin-workflow/00-admin.md
  • ~/.claude/skills/admin-workflow/01-init.md
  • ... (共 20+ 个文件)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
以下内容不会被删除:
  • ~/.claude/.mcp.json（MCP 配置）
  • ~/.claude/CLAUDE.md（全局配置）
  • 项目中的 openspec/ 目录
  • 其他 AI 工具的文件
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

确定要卸载吗？ (y/N) y

[1/2] 删除已安装文件...
  ✓ 删除 ~/.claude/skills/admin-workflow/00-admin.md
  ✓ 删除 ~/.claude/skills/admin-workflow/01-init.md
  ...
  ✓ 删除目录 ~/.claude/agents/admin-workflow/
[2/2] 清理完成
  ✓ 删除安装清单

╔════════════════════════════════════════════╗
║              🎉 卸载完成！                  ║
╚════════════════════════════════════════════╝

📝 注意事项
   • 项目级配置文件（openspec/）未被删除
   • MCP 配置（~/.claude/.mcp.json）未被修改
   • 如需完全清理，请手动删除项目中的 openspec/ 目录

🔄 重新安装
   ./install.sh
```

### 卸载后重装

想重新安装？直接执行：

```bash
./install.sh
# 脚本会检测到残留文件（如有），提供覆盖/合并/跳过三个选项
```

---

## 📋 命令速查表

### 核心命令（7 个）

| 命令 | 描述 | 常用参数 | 耗时 |
|------|------|---------|------|
| `/admin` | 显示工作流总览 | — | 即时 |
| `/admin:init` | 初始化项目（只需一次） | `--force` 强制覆盖 | ~1 分钟 |
| `/admin:start` | 需求准备（Jira 或 手动描述） | `PIX-xxx` / `-q` 快速 / `-f` 完整 | 2-5 分钟 |
| `/admin:design` | 方案设计 | `-q` 快速 / `-s` 标准 / `-d` 深度 | 3-10 分钟 |
| `/admin:audit` | 提案审阅 | — | 2-5 分钟 |
| `/admin:apply` | 应用代码 | `-c` 继续 / `-t 3` 从第3个任务 | 5-15 分钟 |
| `/admin:review` | 代码走读 + Git 提交建议 | — | 3-5 分钟 |
| `/admin:archive` | 归档提案 | — | 即时 |

### 参数速查

| 场景 | 命令 |
|------|------|
| 从 Jira 开始一个需求 | `/admin:start PIX-1234` |
| 没有 Jira，手动描述需求 | `/admin:start`（选择 [2] 直接描述） |
| 快速模式，1 个方案 | `/admin:design -q` |
| 标准模式，2 个方案对比 | `/admin:design -s` |
| 深度模式，3 个方案对比 | `/admin:design -d` |
| AI 自动选推荐方案 | `/admin:design -a` |
| 从上次暂停处继续应用 | `/admin:apply -c` |
| 从第 3 个任务开始应用 | `/admin:apply -t 3` |
| 应用时暂停并回滚 | 输入 `P` |

---

## 🎬 更多使用场景

### 场景 1: 完整的新功能开发

```bash
/admin:start PIX-1234      # 获取需求 + 代码分析
/admin:design               # 设计方案（含权限配置）
/admin:audit                # 审阅提案
/admin:apply                # 逐任务应用代码
/admin:review               # 代码走读 + Git 提交建议
/admin:archive              # 归档
```

### 场景 2: 没有 Jira，口头需求快速开发

```bash
/admin:start                # 选择 [2] 直接描述需求
# AI 会引导你输入：
#   - 需求标题
#   - 功能描述
#   - 验收标准（可选）
#   - 参考页面（可选）

/admin:design -q -a         # 快速模式 + 自动选择
/admin:apply                # 应用代码
/admin:review               # 走读
```

### 场景 3: 有 Apifox API 文档的开发

```bash
/admin:start PIX-1234       # 获取需求

# Step 2 时选择 API 文档收集
# AI: 请选择 API 获取方式？
# [1] 🤖 智能获取 - 提供 Apifox 分享链接
# 你: 1
# AI: 请输入 Apifox 分享链接
# 你: https://apifox.truesightai.com/apidoc/shared/xxx

# AI 自动打开链接，点击"下载 Markdown"按钮，解析接口
# ✅ 已获取 5 个接口定义

/admin:design               # 设计方案（字段定义更精确）
```

### 场景 4: 方案不满意，重新设计

```bash
/admin:design               # 看了方案，不满意
# AI: 选择方案？
# 你: 都不满意，我想要...（描述你的想法）

/admin:design -r            # 基于你的反馈修改提案
# 多轮迭代，直到满意
```

### 场景 5: 应用到一半发现问题

```bash
/admin:apply
# 任务 1/5: ✅ 完成
# 任务 2/5: ✅ 完成
# 任务 3/5: 确认? (Y/S/P)
# 你: P  （暂停！）

# AI: 选择要保留的任务:
#   [✓] 任务 1: src/api/xxx.ts
#   [✓] 任务 2: src/hooks/xxx.tsx
#   [ ] 其他: 回滚

# 回到 DESIGN 修改方案
/admin:design -r

# 修改后继续
/admin:apply -c             # 从暂停处继续
```

---

## 🏛️ 核心设计原则

> **APPLY 之前，只做分析设计，不动一行代码**

```
┌─────────────────────────────────────────────┬───────────────────────────┐
│    📖 分析设计阶段（只读）                    │    ✏️ 执行阶段（写入）      │
├─────────────────────────────────────────────┼───────────────────────────┤
│ INIT → START → DESIGN → AUDIT              │  APPLY → REVIEW → ARCHIVE │
│                                             │                           │
│ ✅ 读取代码    ❌ 禁止写入                    │  ✅ 写入代码               │
│ ✅ 分析结构    ❌ 禁止修改                    │  ✅ 创建/修改文件          │
│ ✅ 生成文档                                  │  ✅ 执行命令               │
└─────────────────────────────────────────────┴───────────────────────────┘
```

**为什么这样设计？**

1. **充分思考再动手** — 避免边写边改的低效模式
2. **可回退的决策点** — AUDIT 是最后的确认关卡，不满意可以重新设计
3. **清晰的责任边界** — 分析阶段 AI 思考，人决策；执行阶段 AI 实现，人验收

---

## ❓ 常见问题 FAQ

### Q: 没有 Jira 可以用吗？

**A: 完全可以！** v1.5 支持两种方式：
1. **从 Jira 获取** — `/admin:start PIX-1234`
2. **直接描述需求** — `/admin:start`，选择 [2]，手动输入需求标题和描述

### Q: 我需要按顺序执行所有阶段吗？

**A:** 不需要！可以灵活跳过：
- 需求简单？ `/admin:start` → `/admin:design -q -a` → `/admin:apply` → `/admin:review`
- API 文档没准备好？跳过 API 收集步骤，后续再补

### Q: 工作流执行到一半，想修改怎么办？

**A:** 每个阶段都支持多轮迭代！
- `/admin:design` → 不满意就重新设计
- `/admin:apply` → 输入 `P` 暂停并选择性回滚
- `/admin:review` → 建议可以选择性采纳

### Q: 权限配置会自动生成代码吗？

**A:** DESIGN 阶段生成权限清单（接口权限、按钮权限、路由权限、菜单配置），APPLY 阶段会将权限代码写入项目。

### Q: Git 提交是自动的吗？

**A: 不是！** 工作流只提供建议（提交消息 + 文件分组），需要你手动确认执行。

### Q: 生成的代码不满意怎么办？

**A:** 多种调整方式：
- `/admin:design -r` 修改提案
- `/admin:apply` 时跳过（`S`）或暂停（`P`）
- 直接编辑 `openspec/changes/xxx/` 下的提案文件

---

## 🔧 故障排除

### `/admin` 命令无响应

```bash
# 1. 检查 Skills 是否安装
ls ~/.claude/skills/admin-workflow/
# 如果为空 → 重新安装: ./install.sh

# 2. 重启 Claude Code
exit
claude
```

### `/admin:start PIX-xxx` 获取 Jira 失败

```bash
# 检查 MCP 配置
cat ~/.claude/.mcp.json

# 确认包含以下字段:
# - ATLASSIAN_SITE_URL: https://your-site.atlassian.net
# - ATLASSIAN_USER_EMAIL: your-email@company.com
# - ATLASSIAN_API_TOKEN: 有效的 API Token

# 验证 Jira 连接
curl -s --user "your-email:your-token" \
  "https://your-site.atlassian.net/rest/api/3/myself" | head -1
# 期望: 返回 JSON（你的用户信息）
```

**Token 过期？** → https://id.atlassian.com/manage-profile/security/api-tokens 重新生成

**不想配 Jira？** → 直接用 `/admin:start` 选择 [2] 手动描述需求

### `/admin:init` 第一次运行较慢

这是正常的（约 1 分钟）。AI 在检测技术栈、扫描项目结构、生成配置文件。完成后会看到：

```
✅ 已生成以下配置文件:
  - openspec/project.md
  - openspec/AGENTS.md
  - openspec/changes/archive/INDEX.md
```

### 代码应用后编译失败

```bash
# 1. 先用走读检查
/admin:review

# 2. 如果问题严重，回滚重来
/admin:apply    # 然后输入 P 暂停，选择性回滚

# 3. 或者用 git 回退
git diff                       # 看改了什么
git checkout -- src/xxx.vue    # 回滚某个文件
```

### Apifox 智能获取失败

Apifox 智能获取需要 Playwright MCP 或 chrome-devtools MCP。如果未配置：

```
# AI 会自动降级为手动模式:
# "Playwright 不可用，请手动提供 API 文档"
# 你可以: 复制 Markdown / 粘贴截图 / 直接描述接口
```

---

## 📁 项目结构（v1.5）

```
ljb_ai_workflow_kit/
├── README.md                           # 本文件
├── VERSION                             # 版本号 (1.5.0)
├── install.sh                          # 安装脚本
├── uninstall.sh                        # 卸载脚本
│
├── .claude-plugin/
│   └── plugin.json                     # 插件清单
│
├── docs/
│   ├── TUTORIAL.md                     # 完整教程
│   ├── ONBOARDING.md                   # 团队上手指南
│   └── WORKFLOW-PRINCIPLES.md          # 设计原则文档
│
├── skills/admin-workflow/              # 工作流命令（8 个）
│   ├── 00-admin.md                     # /admin 总览
│   ├── 01-init.md                      # /admin:init
│   ├── 02-start.md                     # /admin:start
│   ├── 03-design.md                    # /admin:design
│   ├── 04-audit.md                     # /admin:audit
│   ├── 05-apply.md                     # /admin:apply
│   ├── 06-review.md                    # /admin:review
│   └── 07-archive.md                   # /admin:archive
│
├── agents/                             # AI 代理（按阶段分组）
│   ├── explore/code-explorer.md        # 代码探索（START）
│   ├── design/code-architect.md        # 架构设计（DESIGN）
│   ├── audit/                          # 审计类（AUDIT）
│   │   ├── impact-analyzer.md
│   │   ├── qa-arch-reviewer.md
│   │   └── qa-security-reviewer.md
│   └── review/                         # 审查类（REVIEW）
│       ├── code-reviewer.md
│       └── code-simplifier.md
│
├── templates/openspec/
│   └── workflow.config.json            # 工作流配置模板
│
└── openspec/                           # 项目规范
    ├── project.md
    └── AGENTS.md
```

---

## 🤝 反馈与贡献

- **问题反馈**: [GitHub Issues](https://github.com/lianjunbin/ljb_ai_workflow_kit/issues)
- **功能建议**: 欢迎提交 Issue 或 PR
- **团队上手指南**: [docs/ONBOARDING.md](docs/ONBOARDING.md)
- **完整教程**: [docs/TUTORIAL.md](docs/TUTORIAL.md)

---

## 📜 许可证

MIT

---

<p align="center">
  <sub>Made with ❤️ for TrueSightAI Team</sub>
</p>
