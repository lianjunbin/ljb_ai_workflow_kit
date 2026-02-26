# 项目规范 - ljb_ai_workflow_kit

> **项目类型**: AI 工作流工具包
> **版本**: 1.5.0
> **更新日期**: 2026-02-26

---

## 项目概述

管理后台 AI 开发工作流工具包，为 TrueSightAI 团队的管理后台项目提供标准化的 AI 辅助开发流程。

**核心特性**:
- 7 阶段工作流（INIT → START → DESIGN → AUDIT → APPLY → REVIEW → ARCHIVE）
- TSX + Vue 分离架构
- 多代理协同（支持 Agent Teams 实验性团队模式）
- 灵活需求入口（Jira 获取 或 直接描述）
- Apifox 接口文档自动化获取（Playwright/WebFetch）
- 多模型策略配置（Opus/Sonnet/Haiku 按阶段分配）
- 多轮迭代支持
- 选择性回滚
- **Plugin 系统**（.claude-plugin/plugin.json）

---

## 技术栈

- **运行环境**: Claude Code (CLI)
- **依赖 MCP**:
  - jira（必需）
  - context7（可选）
  - chrome-devtools（可选）

---

## 目录结构约定

```
ljb_ai_workflow_kit/
├── README.md                    # 项目说明
├── VERSION                      # 版本号
├── install.sh                   # 安装脚本
├── uninstall.sh                 # 卸载脚本
├── .claude-plugin/              # Plugin 系统
│   └── plugin.json              # 插件清单
├── skills/                      # Claude Code Skills
│   └── admin-workflow/          # 管理后台工作流
│       ├── 00-admin.md          # 主入口（/admin）
│       ├── 01-init.md           # 初始化（/admin:init）
│       ├── 02-start.md          # 需求准备（/admin:start）
│       ├── 03-design.md         # 提案设计（/admin:design）
│       ├── 04-audit.md          # 提案审阅（/admin:audit）
│       ├── 05-apply.md          # 应用代码（/admin:apply）
│       ├── 06-review.md         # 代码走读（/admin:review）
│       ├── 07-archive.md        # 归档（/admin:archive）
│       └── README.md            # Skills 说明
├── agents/                      # 代理定义（按阶段分组）
│   ├── explore/                 # START 阶段
│   │   └── code-explorer.md     # 代码探索
│   ├── design/                  # DESIGN 阶段
│   │   └── code-architect.md    # 架构设计
│   ├── audit/                   # AUDIT 阶段
│   │   ├── impact-analyzer.md   # 影响分析
│   │   ├── qa-arch-reviewer.md  # 架构合规审查
│   │   └── qa-security-reviewer.md # 安全审查
│   ├── review/                  # REVIEW 阶段
│   │   ├── code-reviewer.md     # 代码审查
│   │   └── code-simplifier.md   # 代码简化
│   └── README.md                # 代理说明
├── templates/                   # 模板文件
│   └── openspec/
│       └── workflow.config.json # 工作流配置模板
└── openspec/                    # OpenSpec 目录
    ├── project.md               # 项目规范（本文件）
    ├── AGENTS.md                # 代理配置
    └── changes/                 # 变更管理
        └── <change-id>/         # 活跃变更
```

---

## 安装位置

安装后文件位于 Claude Code 用户配置目录：

```
~/.claude/
├── skills/
│   └── admin-workflow/          # 8 个 Skill 文件 + README
└── agents/
    └── admin-workflow/          # 命名空间隔离，避免冲突
        ├── explore/
        │   └── code-explorer.md
        ├── design/
        │   └── code-architect.md
        ├── audit/
        │   ├── impact-analyzer.md
        │   ├── qa-arch-reviewer.md
        │   └── qa-security-reviewer.md
        └── review/
            ├── code-reviewer.md
            └── code-simplifier.md
```

---

## 开发规范

### Skill 文件规范

- 位置: `skills/admin-workflow/`
- 命名: 使用 kebab-case，如 `init.md`
- 结构: 包含 description 头、触发条件、执行流程、输出说明

### 代理文件规范

- 位置: `agents/<agent-name>.md`
- 命名: 使用 kebab-case，如 `code-explorer.md`
- 结构: 包含 description 头、职责说明、输入输出、使用阶段

### 编码规范（生成代码时遵循）

- **TSX + Vue 分离**: .tsx 负责 Model，.vue 负责 View
- **解构赋值**: Hook 返回值必须使用解构
- **组件复用**: 优先使用 pix-component
- 详见 `skills/admin-workflow/coding-standards.md`

---

## 代码提交规范

采用【Tag】格式，Tag 首字母大写：

| 标签 | 说明 | 示例 |
|------|------|------|
| `【Feature】` | 新功能 | 【Feature】新增用户日志功能 |
| `【Bugfix】` | 修复 Bug | 【Bugfix】修复分页数据错误 |
| `【Optimize】` | 优化代码 | 【Optimize】优化日志查询逻辑 |
| `【Perf】` | 性能优化 | 【Perf】减少不必要的 API 调用 |
| `【Test】` | 增加测试 | 【Test】添加日志组件单元测试 |
| `【Build】` | 构建工具变动 | 【Build】升级 Vite 版本 |
| `【Revert】` | 撤销提交 | 【Revert】撤销上一次错误提交 |
| `【Chore】` | 辅助工具变动 | 【Chore】更新 Lint 配置 |
| `【Docs】` | 文档改变 | 【Docs】添加 API 注释 |
| `【Style】` | 样式改变 | 【Style】调整按钮样式 |

**格式要求**：
- Tag 后描述首字母大写
- 描述简洁明了，说明"做了什么"
- 多行时第二行起用 `- ` 列表说明细节

示例：
```
【Feature】用户详情页-新增操作日志 Tab

- 新增用户操作日志 API 及类型定义
- 新增 useUserLog Hook 封装日志逻辑
- 新增 UserLogTable 组件展示日志列表
- 用户详情页添加操作日志 Tab
```

```
【Bugfix】修复用户列表分页数据错误

- 修复 pageSize 参数未传递的问题
- 修复翻页后筛选条件丢失的问题
```

```
【Optimize】优化用户日志查询性能

- 添加查询条件缓存，避免重复请求
- 使用 debounce 优化搜索触发频率
```

---

## 质量标准

### Skill 质量

- [ ] 参数说明完整
- [ ] 执行流程清晰
- [ ] 错误处理明确
- [ ] 输出格式规范
- [ ] 人性化提示友好

### 代理质量

- [ ] 职责单一明确
- [ ] 输入输出定义清晰
- [ ] 使用阶段正确
- [ ] 范围限制明确
- [ ] 分级模式支持

### 文档质量

- [ ] 结构清晰
- [ ] 示例完整
- [ ] 更新及时

---

## 关联项目

- **pix-component**: 内部 UI 组件库
  - 位置: `/Users/lianjunbin/Documents/pix-component`
  - 用途: 管理后台 UI 组件复用

---

## 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| v1.5 | 2026-02-26 | 命名空间隔离、Plugin 系统、Agent Teams、多模型策略、灵活需求入口、清理未实现的 QA CLI 文档 |
| v1.2 | 2026-02-11 | 架构/安全审查代理、Apifox API 文档获取 |
| v1.1 | 2026-02-11 | 拆分 APPLY/END/ARCHIVE，新增 TSX+Vue 分离规范 |
| v1.0 | 2026-02-10 | 初始版本 |
