# 项目规范 - ljb_ai_workflow_kit

> **项目类型**: AI 工作流工具包
> **版本**: 1.2.0
> **更新日期**: 2026-02-11

---

## 项目概述

管理后台 AI 开发工作流工具包，为 TrueSightAI 团队的管理后台项目提供标准化的 AI 辅助开发流程。

**核心特性**:
- 9 阶段工作流（INIT → START → API → ANALYZE → DESIGN → REVIEW → APPLY → END → ARCHIVE）
- TSX + Vue 分离架构
- 多代理协同
- 多轮迭代支持
- 选择性回滚
- **分级质量门禁**（quick / standard / strict）

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
├── bin/                         # CLI 工具
│   └── admin-qa                 # 质量门禁 CLI
├── config/                      # 配置文件
│   └── qa-config.yaml           # 质量门禁配置
├── skills/                      # Claude Code Skills
│   └── admin-workflow/          # 管理后台工作流
│       ├── admin.md             # 主入口（/admin）
│       ├── init.md              # 初始化（/admin:init）
│       ├── start.md             # 需求获取（/admin:start）
│       ├── api.md               # API 文档获取（/admin:api）
│       ├── analyze.md           # 业务分析（/admin:analyze）
│       ├── design.md            # 提案设计（/admin:design）
│       ├── review.md            # 提案审查（/admin:audit）
│       ├── apply.md             # 应用代码（/admin:apply）
│       ├── end.md               # 走查（/admin:end）
│       ├── archive.md           # 归档（/admin:archive）
│       ├── style-guide.md       # 输出风格规范
│       └── coding-standards.md  # 编码规范
├── agents/                      # 代理定义
│   ├── code-explorer.md         # 代码探索
│   ├── code-architect.md        # 架构设计
│   ├── code-reviewer.md         # 代码审查
│   ├── code-simplifier.md       # 代码简化
│   ├── impact-analyzer.md       # 影响分析
│   ├── qa-arch-reviewer.md      # 架构合规审查
│   └── qa-security-reviewer.md  # 安全审查
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
│   └── admin-workflow/          # 12 个命令/配置文件
├── agents/
│   ├── code-explorer.md
│   ├── code-architect.md
│   ├── code-reviewer.md
│   ├── code-simplifier.md
│   ├── impact-analyzer.md
│   ├── qa-arch-reviewer.md
│   └── qa-security-reviewer.md
└── config/
    └── qa-config.yaml           # 质量门禁默认配置

~/.local/bin/ (或 /usr/local/bin/)
└── admin-qa                     # CLI 工具
```

---

## 质量门禁配置 (QA)

项目可通过以下方式自定义质量检查行为：

### 项目级配置

在项目根目录创建 `.admin-qa.yaml`：

```yaml
# .admin-qa.yaml - 项目级质量门禁配置

# 默认检查级别
default_level: standard

# 自定义规则
custom_rules:
  # 禁用的检查项
  disabled_checks:
    - comment_required  # 不强制要求注释

  # 阈值调整
  thresholds:
    script_setup_max_lines: 80      # 放宽 script setup 行数限制
    max_component_lines: 400        # 放宽组件行数限制
    complexity_threshold: 8         # 放宽圈复杂度阈值

# 排除目录（不检查）
exclude:
  - "src/legacy/**"
  - "src/generated/**"
  - "**/*.test.ts"
  - "**/*.spec.ts"

# 安全检查白名单
security:
  allowed_v_html:
    - "src/components/RichText.vue"  # 已有 DOMPurify 处理
```

### 检查级别说明

| 级别 | 适用场景 | 检查项 |
|------|---------|--------|
| **quick** | 快速验证、修复 Bug | 编译错误、类型错误 |
| **standard** | 日常开发 | + TSX 分离、解构、硬编码、注释 |
| **strict** | 重要功能、上线前 | + 架构检查、安全审查、交叉验证 |

### 门禁规则

| 门禁级别 | 说明 | CI 行为 |
|---------|------|---------|
| **BLOCKING** | 阻断性问题 | CI 失败 |
| **WARNING** | 警告性问题 | CI 通过，输出警告 |
| **SUGGESTION** | 建议性问题 | CI 通过，输出建议 |

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

遵循 Conventional Commits：

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `refactor`: 重构
- `chore`: 构建/工具变更

示例：
```
feat(admin:init): 添加技术栈检测功能
fix(apifox): 修复 LLMs.txt URL 构造逻辑
docs: 更新使用指南
feat(qa): 添加分级质量门禁支持
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

## CLI 工具

### qa（超简单）

质量门禁命令行工具，用数字记住检查级别：

```bash
qa        # 标准检查（日常用这个）
qa 1      # 快速检查 - 只看编译错误
qa 2      # 标准检查（同 qa）
qa 3      # 严格检查 - 含架构+安全
qa 3x     # 严格 + 交叉验证

qa -f     # 自动修复
qa 3 -c   # CI 模式
qa -h     # 查看帮助
```

**记忆口诀**: 1 快 2 标 3 严，加 x 交叉验

---

## 关联项目

- **pix-component**: 内部 UI 组件库
  - 位置: `/Users/lianjunbin/Documents/pix-component`
  - 用途: 管理后台 UI 组件复用

---

## 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| v1.2 | 2026-02-11 | 添加分级质量门禁、CLI 工具、架构/安全审查代理、Apifox API 文档获取 |
| v1.1 | 2026-02-11 | 拆分 APPLY/END/ARCHIVE，新增 TSX+Vue 分离规范 |
| v1.0 | 2026-02-10 | 初始版本 |
