# 管理后台 AI 开发工作流

> 专为管理后台业务功能开发设计的 AI 工作流
> 从 Jira 需求到代码交付，AI 全程协助

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
│    🚀 管理后台 AI 开发工作流 v1.3                                 │
│    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │
│    从 Jira 需求到代码交付，AI 全程协助                            │
│                                                                  │
╰──────────────────────────────────────────────────────────────────╯
```

---

## 📖 目录

- [谁需要这个工作流？](#-谁需要这个工作流)
- [核心设计原则](#-核心设计原则)
- [5 分钟快速体验](#-5-分钟快速体验)
- [完整安装指南](#-完整安装指南)
- [工作流全貌](#-工作流全貌)
- [命令速查表](#-命令速查表)
- [典型使用场景](#-典型使用场景)
- [常见问题 FAQ](#-常见问题-faq)
- [故障排除](#-故障排除)

---

## 🎯 谁需要这个工作流？

如果你是前端开发者，经常需要：

- ✅ 从 Jira 获取需求，然后开发管理后台功能
- ✅ 对接后端 API，希望接口参数不要写错
- ✅ 复用已有的组件和代码，不想重复造轮子
- ✅ 代码质量有保障，但不想花太多时间审查
- ✅ Git 提交规范，但记不住那些 commit 格式
- ✅ **权限配置不要漏掉**（接口权限、按钮权限、路由权限）

**那这个工作流就是为你设计的！** 🎉

---

## 🏛️ 核心设计原则

> **APPLY 之前，只做分析设计，不动一行代码**

```
┌─────────────────────────────────────────────────────────────────────┐
│          📖 分析设计阶段（只读）         │    ✏️ 执行阶段（写入）     │
├─────────────────────────────────────────────────────────────────────┤
│ INIT → START → API → BEFORE → DESIGN   │  APPLY → REVIEW → ARCHIVE │
│ → AUDIT                                 │                           │
├─────────────────────────────────────────────────────────────────────┤
│ ✅ 读取代码    ❌ 禁止写入              │  ✅ 写入代码               │
│ ✅ 分析结构    ❌ 禁止修改              │  ✅ 创建/修改文件          │
│ ✅ 生成文档                             │  ✅ 执行命令               │
└─────────────────────────────────────────────────────────────────────┘
```

**为什么这样设计？**

1. **充分思考再动手** - 避免边写边改的低效模式
2. **可回退的决策点** - AUDIT 是最后的确认关卡，不满意可以重新设计
3. **清晰的责任边界** - 分析阶段 AI 思考，人决策；执行阶段 AI 实现，人验收

详见：[docs/WORKFLOW-PRINCIPLES.md](docs/WORKFLOW-PRINCIPLES.md)

---

## ⚡ 5 分钟快速体验

### 前提条件

确保你已安装 [Claude Code CLI](https://claude.ai/download)：

```bash
# 检查是否安装
claude --version
```

### 一键安装

```bash
# 克隆并安装
git clone https://github.com/lianjunbin/ljb_ai_workflow_kit.git
cd ljb_ai_workflow_kit
./install.sh
```

### 开始使用

```bash
# 1. 进入你的管理后台项目
cd your-admin-project

# 2. 启动 Claude Code
claude

# 3. 初始化项目（只需一次）
/admin:init

# 4. 开始一个需求
/admin:start PIX-1234
```

**就这么简单！** 每一步都会告诉你下一步该做什么 😊

---

## 📦 完整安装指南

### 系统要求

| 必需 | 说明 |
|------|------|
| Claude Code CLI | AI 助手运行环境 |
| Node.js | MCP 服务器运行时 |
| Jira 账号 | 获取 API Token |

| 推荐 | 说明 |
|------|------|
| Apifox 分享链接 | 获取后端 API 文档 |
| pix-component | 内部 UI 组件库 |

### 安装步骤

#### 步骤 1: 安装 Claude Code CLI

```bash
npm install -g @anthropic-ai/claude-code

# 验证安装
claude --version
```

#### 步骤 2: 配置 Jira MCP（必需）

1. 获取 Atlassian API Token:
   - 访问 https://id.atlassian.com/manage-profile/security/api-tokens
   - 点击「Create API token」
   - 复制生成的 Token

2. 配置 MCP:

   编辑 `~/.claude/.mcp.json`：

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

#### 步骤 3: 安装工作流

```bash
# 方式一：克隆仓库（推荐）
git clone https://github.com/lianjunbin/ljb_ai_workflow_kit.git
cd ljb_ai_workflow_kit
./install.sh

# 方式二：远程安装
curl -fsSL https://raw.githubusercontent.com/lianjunbin/ljb_ai_workflow_kit/main/install.sh | bash
```

#### 步骤 4: 验证安装

```bash
# 重启 Claude Code
claude

# 输入以下命令查看工作流总览
/admin
```

如果看到工作流总览界面，恭喜安装成功！ 🎉

---

## 🔄 工作流全貌

```
┌─────────────────────────────────────────────────────────────────────┐
│  📖 分析设计阶段（只读）                                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  🎬 INIT ─→ 项目初始化                                              │
│     │       检测技术栈，生成配置文件                                 │
│     ↓                                                               │
│  📋 START ─→ 需求获取 + 代码探索                                    │
│     │        从 Jira 拉取需求，并行探索代码库                        │
│     ↓                                                               │
│  📡 API ─→ 获取 API 文档 ←───┐                                      │
│     │      从 Apifox 获取    │ 🔄 多轮迭代添加接口                  │
│     └─────── 完成? ─────────┘                                       │
│     ↓                                                               │
│  🗺️ BEFORE ─→ 业务逻辑梳理 ←──┐                                     │
│     │         分析改动前逻辑  │ 🔄 可多轮迭代                       │
│     └─────── 满意? ──────────┘                                      │
│     ↓                                                               │
│  🎨 DESIGN ─→ 提案设计 ←──────┐                                     │
│     │         ┌────────────────────────────────────┐                │
│     │         │ 🔬 自动评估复杂度                  │                │
│     │         │ 🔐 权限配置设计（接口/按钮/路由）  │ ← v1.3 新增    │
│     │         │ 🎯 智能策略推荐                    │                │
│     │         └────────────────────────────────────┘                │
│     └─────── 满意? ──────────┘                                      │
│     ↓                                                               │
│  📑 AUDIT ─→ 提案审阅 ←──────┐                                      │
│     │         代码逻辑预览   │ 🔄 可多轮迭代                        │
│     │         影响范围分析   │                                      │
│     └─────── 满意? ──────────┘                                      │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  ✏️ 执行阶段（写入）                                                 │
├─────────────────────────────────────────────────────────────────────┤
│     ↓                                                               │
│  ⚡ APPLY ─→ 应用代码                                               │
│     │        逐任务确认执行                                         │
│     │        └── 需要补充? → 暂停 + 选择性回滚 → 回到 DESIGN        │
│     ↓                                                               │
│  🔍 REVIEW ─→ 代码走读 ←─────┐                                      │
│     │        更新任务状态     │ 🔄 支持多轮迭代                       │
│     │        逐文件走读优化   │                                      │
│     │        Git 提交建议     │                                      │
│     └────── 满意? ───────────┘                                      │
│     ↓                                                               │
│  📦 ARCHIVE ─→ 归档                                                 │
│               提案归档，更新索引                                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

💡 核心特性：API / BEFORE / DESIGN / AUDIT / REVIEW 都支持多轮迭代！
```

---

## 📋 命令速查表

### 工作流命令

| 命令 | 描述 | 说明 |
|------|------|------|
| `/admin` | 🚀 显示工作流总览 | 随时可用 |
| `/admin:init` | 🎬 初始化项目 | 只需执行一次 |
| `/admin:start PIX-xxx` | 📋 从 Jira 拉取需求 | 加 `-c` 一键到设计 |
| `/admin:api` | 📡 获取 API 文档 | 支持多轮添加 |
| `/admin:before` | 🗺️ 业务逻辑梳理 | 生成思维导图 |
| `/admin:design` | 🎨 提案设计 | **含权限配置设计** |
| `/admin:audit` | 📑 提案审阅 | 代码逻辑预览 + 影响分析 |
| `/admin:apply` | ⚡ 应用代码 | 加 `-c` 继续 |
| `/admin:review` | 🔍 代码走读 | 支持多轮迭代，仅审阅本次改动 |
| `/admin:archive` | 📦 归档提案 | - |

### 💡 核心使用技巧

**`/admin:design` 支持交互式选择！**

```
/admin:design   ← 显示菜单让你选择方案数量
```

如果已经知道要什么，可以直接带参数跳过菜单：

```bash
# 提案设计
/admin:design quick      # 🚀 快速 - 1个方案
/admin:design standard   # ⭐ 标准 - 2个方案（推荐）
/admin:design deep       # 💎 深度 - 3个方案

# 走查
/admin:review            # 完整走查流程（多轮迭代）
```

### 简写参数

| 完整 | 简写 | 说明 |
|------|------|------|
| `quick` | `-q` | 快速模式（design） |
| `standard` | `-s` | 标准模式（design） |
| `deep` | `-d` | 深度模式（design） |
| `--continue` | `-c` | 继续执行（apply） |
| `--auto` | `-a` | 自动选择（design） |

---

## 🔐 权限配置设计（v1.3 新增）

在 `/admin:design` 阶段，系统会自动检测需求是否涉及权限配置：

```
🔐 权限配置设计
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📡 接口权限（API Permission）
  ┌──────────────────────────────────────────────────────────────┐
  │ 接口                      │ 权限码                │ 说明     │
  ├──────────────────────────────────────────────────────────────┤
  │ GET  /api/user/logs       │ user:log:list        │ 查看日志 │
  └──────────────────────────────────────────────────────────────┘

  🔘 按钮权限（Button Permission）
  🛤️ 路由权限（Route Permission）
  📋 菜单配置（Menu Config）

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**权限命名规范：** `{模块}:{资源}:{动作}`

示例：`user:log:list`, `order:detail:edit`

---

## 🎬 典型使用场景

### 场景 1: 新功能开发（完整流程）

```bash
# 1. 开始需求
/admin:start PIX-1234

# 2. 获取 API 文档（可选但推荐）
/admin:api https://apifox.truesightai.com/xxx

# 3. 业务逻辑梳理
/admin:before

# 4. 提案设计（含权限配置）
/admin:design

# 5. 提案审阅
/admin:audit

# 6. 应用代码
/admin:apply

# 7. 代码走读
/admin:review

# 8. 归档
/admin:archive
```

### 场景 2: 快速验证一个小改动

```bash
# 直接开始，跳过分析
/admin:start PIX-1234
/admin:design quick -a   # 快速+自动选择
/admin:apply
/admin:review
```

### 场景 3: 接口对接

```bash
# 专注于 API 文档获取
/admin:api https://apifox.truesightai.com/xxx

# 多轮添加接口
# AI: 请告诉我你要获取哪个接口？
# 你: 获取标签列表
# AI: ✅ 已获取，继续添加？
# 你: 新建标签
# AI: ✅ 已获取，继续添加？
# 你: done
# AI: ✅ 已保存 2 个接口到 api.md
```

---

## ❓ 常见问题 FAQ

### Q: 我需要按顺序执行所有阶段吗？

**A:** 不需要！你可以：
- 跳过 `/admin:api`（如果不需要对接 API）
- 跳过 `/admin:before`（如果需求很简单）
- 直接从任意阶段开始（如果已经准备好了）

### Q: 工作流执行到一半，想修改怎么办？

**A:** 每个阶段都支持多轮迭代！
- 在 `/admin:design` 时，选择「不满意，我想调整」
- 在 `/admin:apply` 时，输入 `P` 暂停并回滚

### Q: 权限配置会自动生成代码吗？

**A:** 在 DESIGN 阶段只生成权限配置清单，供你确认。
实际的权限代码会在 APPLY 阶段写入（如果选择执行）。

### Q: 没有 Jira 可以用吗？

**A:** 暂时需要 Jira。后续版本可能支持：
- 手动输入需求
- GitHub Issues
- 其他需求管理工具

### Q: 生成的代码不满意怎么办？

**A:** 多种方式调整：
- 在 `/admin:design` 阶段选择其他方案
- 直接编辑生成的提案文件（`openspec/changes/xxx/`）
- 在 `/admin:apply` 时暂停并修改

### Q: Git 提交是自动的吗？

**A:** 不是！工作流只提供建议：
- 推荐的 commit message
- 推荐的文件分组
- 你需要手动执行 `git add` 和 `git commit`

---

## 🔧 故障排除

### 问题: `/admin` 命令无响应

**解决方案:**
```bash
# 检查 Skills 是否安装
ls ~/.claude/skills/admin-workflow/

# 如果为空，重新安装
cd ljb_ai_workflow_kit
./install.sh
```

### 问题: Jira 需求获取失败

**解决方案:**
1. 检查 MCP 配置：
   ```bash
   cat ~/.claude/.mcp.json | grep jira
   ```
2. 验证 API Token 是否有效
3. 确认 Site URL 格式正确（`https://xxx.atlassian.net`）

### 问题: API 文档获取卡住

**解决方案:**
- 检查 chrome-devtools MCP 是否配置
- 或直接使用手动模式粘贴 Markdown

### 问题: 代码应用后编译失败

**解决方案:**
```bash
# 快速检查错误
/admin:review

# 如果还有问题，暂停并回滚
/admin:apply  # 然后输入 P
```

---

## 🖼️ 可视化流程图

想要更直观地了解工作流？打开交互式流程图：

```bash
# 在浏览器中打开
open docs/workflow-diagram.html
```

或直接访问：[workflow-diagram.html](docs/workflow-diagram.html)

---

## 📁 项目结构（v1.3）

```
ljb_ai_workflow_kit/
├── README.md                           # 本文件
├── VERSION                             # 版本号 (1.3.0)
├── install.sh                          # 安装脚本
├── uninstall.sh                        # 卸载脚本
│
├── docs/
│   ├── workflow-diagram.html           # 交互式流程图
│   └── WORKFLOW-PRINCIPLES.md          # 设计原则文档
│
├── skills/admin-workflow/              # 工作流命令
│   ├── 00-admin.md                     # 工作流入口
│   ├── 01-init.md ~ 09-archive.md      # 核心工作流（按顺序）
│   ├── README.md                       # 目录说明
│   └── other/                          # 辅助文件
│       ├── coding-standards.md
│       └── style-guide.md
│
├── agents/                             # AI 代理（按职能分组）
│   ├── design/                         # 设计类
│   │   └── code-architect.md
│   ├── explore/                        # 探索类
│   │   └── code-explorer.md
│   ├── audit/                          # 审计类
│   │   ├── impact-analyzer.md
│   │   ├── qa-arch-reviewer.md
│   │   └── qa-security-reviewer.md
│   ├── review/                         # 审查类
│   │   ├── code-reviewer.md
│   │   └── code-simplifier.md
│   └── README.md
│
└── openspec/                           # OpenSpec 规范
```

---

## 🤝 反馈与贡献

- **问题反馈**: [GitHub Issues](https://github.com/lianjunbin/ljb_ai_workflow_kit/issues)
- **功能建议**: 欢迎提交 Issue 或 PR

---

## 📜 许可证

MIT

---

<p align="center">
  <sub>Made with ❤️ for TrueSightAI Team</sub>
</p>
