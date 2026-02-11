# Tasks - 管理后台 AI 开发工作流

> **变更 ID**: `add-admin-workflow`
> **版本**: 1.1.0
> **状态**: ✅ 已完成

---

## 完成状态

### Phase 1: 基础框架 ✅

- [x] 项目目录结构
- [x] README.md
- [x] VERSION
- [x] install.sh（支持远程安装 + MCP 检查）
- [x] uninstall.sh

### Phase 2: Skills 实现 ✅

- [x] admin.md - 主入口
- [x] init.md - 项目初始化
- [x] start.md - 需求获取
- [x] analyze.md - 业务分析（多轮迭代）
- [x] design.md - 提案设计（多轮迭代）
- [x] review.md - 提案审查（多轮迭代）
- [x] apply.md - 应用代码（选择性回滚）
- [x] end.md - 走查
- [x] archive.md - 归档
- [x] style-guide.md - 输出风格规范
- [x] coding-standards.md - 编码规范

### Phase 3: Agents 定义 ✅

- [x] code-explorer.md
- [x] code-architect.md（TSX + Vue 分离）
- [x] code-reviewer.md（TSX + Vue 分离检查）
- [x] code-simplifier.md
- [x] impact-analyzer.md

### Phase 4: 配置文档 ✅

- [x] openspec/project.md
- [x] openspec/AGENTS.md

---

## v1.1 新增任务 ✅

### 命令拆分

- [x] 将 `/admin:execute` 拆分为：
  - `/admin:apply` - 纯应用代码
  - `/admin:end` - 走查（审查+简化+Git建议）
  - `/admin:archive` - 归档

### 多轮迭代

- [x] ANALYZE 阶段支持多轮迭代
- [x] DESIGN 阶段支持多轮迭代
- [x] REVIEW 阶段支持多轮迭代

### 选择性回滚

- [x] APPLY 阶段暂停后可选择保留哪些任务
- [x] 依赖检查：回滚任务时检查依赖关系

### 编码规范

- [x] TSX + Vue 分离架构规范
- [x] 解构赋值规范
- [x] code-architect 支持 TSX + Vue 分离设计
- [x] code-reviewer 支持 TSX + Vue 分离检查

### 人性化输出

- [x] 统一输出风格规范（style-guide.md）
- [x] Banner 设计
- [x] 进度条和阶段卡片
- [x] 白话文引导

### 自动化脚本

- [x] 安装脚本支持远程安装（curl | bash）
- [x] MCP 配置检查和引导
- [x] 可选依赖不阻塞安装
- [x] 安装验证和备份

---

## 验收清单 ✅

### 功能验收

- [x] `/admin:init` 能正确检测 Vue 3 项目
- [x] `/admin:start` 能从 Jira 拉取需求
- [x] `/admin:analyze` 能生成业务分析报告（多轮）
- [x] `/admin:design` 能并行启动多个 architect（多轮）
- [x] `/admin:audit` 能执行影响分析（多轮）
- [x] `/admin:apply` 能逐任务执行（选择性回滚）
- [x] `/admin:end` 能执行代码审查和简化
- [x] `/admin:archive` 能归档提案

### 技术验收

- [x] 所有命令文件符合 Skills 规范
- [x] 所有代理定义完整可用
- [x] 安装/卸载脚本正常工作
- [x] MCP 依赖检查不阻塞安装

### 文档验收

- [x] README.md 完整
- [x] 输出风格规范完整
- [x] 编码规范完整

---

**最后更新**: 2026-02-11
