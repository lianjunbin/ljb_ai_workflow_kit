# 团队成员上手指南

> 新人拿到这份清单，10 分钟就能跑通第一个需求。

---

## 上手清单

### 第零步：全局安装工作流（3 分钟，仅首次）

> 工作流安装到 `~/.claude/` 目录下，安装一次后**所有项目**都能使用。

**方式 A：团队负责人给了你仓库地址**

```bash
# 1. 克隆工作流仓库
git clone https://github.com/lianjunbin/ljb_ai_workflow_kit.git

# 2. 进入目录执行安装
cd ljb_ai_workflow_kit
./install.sh

# 3. 安装完成后看到 "✅ 所有核心文件验证通过！" 就成功了
```

**方式 B：团队负责人给了你安装脚本文件**

```bash
# 直接执行
./install.sh
```

**安装后检查：**

```bash
ls ~/.claude/skills/admin-workflow/ | wc -l
# 期望: 9（8 个 skill 文件 + README = 成功！）
```

---

### 第一步：环境检查（2 分钟）

逐项检查，全部 ✅ 才能继续：

```bash
# 1. Claude Code CLI
claude --version
# ✅ 期望: claude-code x.x.x

# 2. Node.js
node --version
# ✅ 期望: v18.x.x 或更高

# 3. 工作流是否安装
ls ~/.claude/skills/admin-workflow/ | wc -l
# ✅ 期望: 9（8 个 skill 文件 + README）
```

**有未通过的？**

| 问题 | 解决 |
|------|------|
| `claude: command not found` | `npm install -g @anthropic-ai/claude-code` |
| `node: command not found` | 安装 Node.js: https://nodejs.org/ |
| 工作流文件不存在 | 回到第零步执行安装 |

### 第二步：配置 Jira（3 分钟，可选）

> 没有 Jira 也能用！v1.5 支持直接描述需求。但如果团队用 Jira，推荐配置。

1. 获取 API Token:
   - 打开 https://id.atlassian.com/manage-profile/security/api-tokens
   - 点击「Create API token」→ 输入标签名（如 "Claude Code"）→ 复制 Token

2. 配置 MCP（问团队负责人要站点地址）:

```bash
# 编辑配置文件（如果文件不存在会自动创建）
vi ~/.claude/.mcp.json
```

```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-atlassian@latest"],
      "env": {
        "ATLASSIAN_SITE_URL": "https://tssoft.atlassian.net",
        "ATLASSIAN_USER_EMAIL": "你的邮箱@truesightai.com",
        "ATLASSIAN_API_TOKEN": "你的API Token"
      },
      "type": "stdio"
    }
  }
}
```

3. 验证:

```bash
# 测试 Jira 连接
curl -s --user "你的邮箱:你的Token" \
  "https://tssoft.atlassian.net/rest/api/3/myself" | head -c 100
# ✅ 期望: 返回你的用户信息 JSON
```

### 第三步：初始化项目（1 分钟，仅首次）

```bash
cd 你的管理后台项目目录
claude
/admin:init
```

看到 `✅ 已生成配置文件` 就成功了。

### 第四步：跑通第一个需求（5 分钟）

选一个简单的 Jira 任务试试：

```bash
# 有 Jira
/admin:start PIX-xxxx

# 没有 Jira，直接描述
/admin:start
# 选 [2]，输入: 测试需求-在首页添加一个公告栏

# 然后跟着提示走
/admin:design -q -a       # 快速模式
/admin:audit               # 审阅
/admin:apply               # 应用代码
/admin:review              # 走读
```

**恭喜，你已经跑通了完整流程！**

---

## 常用命令速记卡

打印出来贴在工位上：

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│  📋 Admin Workflow 速记卡                            │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                                      │
│  /admin              查看所有命令                    │
│  /admin:init         初始化（只需一次）              │
│  /admin:start XXX    从 Jira 开始                    │
│  /admin:start        手动描述需求                    │
│  /admin:design       设计方案                        │
│  /admin:audit        审阅提案                        │
│  /admin:apply        应用代码                        │
│  /admin:review       走读 + 提交建议                 │
│  /admin:archive      归档                            │
│                                                      │
│  快捷参数:                                           │
│  -q  快速模式     -s  标准模式                       │
│  -d  深度模式     -a  自动选择                       │
│  -c  继续执行     -r  修改提案                       │
│  P   暂停回滚     S   跳过任务                       │
│                                                      │
│  简单需求:                                           │
│  start → design -q -a → apply → review               │
│                                                      │
│  复杂需求:                                           │
│  start -f → design -d → audit → apply → review       │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

## 团队负责人 Checklist

如果你是团队负责人，安排新人使用工作流时：

- [ ] 确认新人已安装 Claude Code CLI
- [ ] 确认新人有 Jira API Token（或告知可跳过）
- [ ] 给新人发送安装脚本 `install.sh`
- [ ] 给新人一个简单的 Jira 任务练手
- [ ] 分享本文档链接
- [ ] 首次使用时在旁协助（预计 10 分钟）

---

## 常见新人问题

### "我输入 /admin 没反应"

Skills 没安装成功。执行：

```bash
ls ~/.claude/skills/admin-workflow/
# 如果为空，重新安装
./install.sh
# 然后重启 claude
```

### "Jira 获取超时"

1. 检查网络是否能访问公司 Jira
2. 检查 API Token 是否正确
3. **快速解决：** 跳过 Jira，用 `/admin:start` 选 [2] 手动描述

### "AI 生成的代码不符合项目风格"

第一次用 `/admin:init` 时 AI 会学习项目的架构模式。如果发现不准确：
1. 检查 `openspec/project.md` 中的技术栈是否正确
2. 在 `/admin:design` 时告诉 AI 具体的风格要求
3. 在 `/admin:review` 时提出修改建议

### "不知道什么时候用什么命令"

简单记忆：**START → DESIGN → APPLY → REVIEW**

- START: 告诉 AI 你要做什么
- DESIGN: AI 出方案，你选择
- APPLY: AI 写代码，你确认
- REVIEW: AI 检查代码，建议 Git 提交

其他命令按需使用，不用每次都全跑一遍。

---

## 卸载工作流

不需要了？一键卸载，干干净净：

```bash
# 方式 1：仓库还在
cd ljb_ai_workflow_kit
./uninstall.sh

# 方式 2：仓库已删除
curl -fsSL https://raw.githubusercontent.com/lianjunbin/ljb_ai_workflow_kit/main/uninstall.sh | bash
```

**卸载是安全的：**
- 只删除工作流自己安装的文件（基于安装清单）
- 不会删除 MCP 配置（`~/.claude/.mcp.json`）
- 不会删除全局配置（`~/.claude/CLAUDE.md`）
- 不会删除项目中的 `openspec/` 目录
- 不会影响其他 AI 工具

**卸载后想重装？**

```bash
./install.sh
# 随时可以重新安装
```
