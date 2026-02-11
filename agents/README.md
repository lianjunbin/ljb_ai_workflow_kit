# Agents 目录结构

按职能分组的 AI Agent 集合，配合工作流各阶段使用。

## 目录结构

```
agents/
├── design/          # 设计类 Agent
│   └── code-architect.md    → DESIGN 阶段使用
├── explore/         # 探索类 Agent
│   └── code-explorer.md     → START 阶段使用
├── audit/           # 审计类 Agent
│   ├── impact-analyzer.md   → AUDIT 阶段使用
│   ├── qa-arch-reviewer.md  → AUDIT 阶段使用
│   └── qa-security-reviewer.md → AUDIT 阶段使用
└── review/          # 审查类 Agent
    ├── code-reviewer.md     → REVIEW 阶段使用
    └── code-simplifier.md   → REVIEW 阶段使用
```

## Agent 与工作流阶段对应

| 工作流阶段 | 使用的 Agent | 职责 |
|-----------|-------------|------|
| 02-START | explore/code-explorer | 代码库探索、模式识别 |
| 05-DESIGN | design/code-architect | 架构设计、方案生成 |
| 06-AUDIT | audit/* | 影响分析、架构审查、安全审查 |
| 08-REVIEW | review/* | 代码走读、代码简化 |

## 如何使用

在工作流的各阶段，系统会自动调用对应的 Agent。也可以手动指定：

```bash
# 示例：使用架构设计 Agent
Task(design/code-architect, "设计用户管理模块")

# 示例：使用代码审查 Agent
Task(review/code-reviewer, "审查本次改动")
```
