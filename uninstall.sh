#!/bin/bash

# ============================================================
# 管理后台 AI 开发工作流 - 卸载脚本 v1.6
#
# 特性：
# - 基于 manifest 的安全卸载（只删除本工作流安装的文件）
# - 命名空间隔离：agents 安装在 admin-workflow/ 子目录下
# - commands 清理：删除 commands/admin/ 斜杠命令目录
# - 不影响其他 AI 工具的配置（绝不删除非本工具的文件）
# - 向后兼容旧版安装（v1.3/v1.4/v1.5 扁平结构 + 分组结构）
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Claude Code 配置目录
CLAUDE_CONFIG_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_CONFIG_DIR/skills"
AGENTS_DIR="$CLAUDE_CONFIG_DIR/agents"
AGENTS_WORKFLOW_DIR="$AGENTS_DIR/admin-workflow"  # 命名空间隔离目录
COMMANDS_DIR="$CLAUDE_CONFIG_DIR/commands"
COMMANDS_ADMIN_DIR="$COMMANDS_DIR/admin"  # /admin:* 斜杠命令目录
MANIFEST_FILE="$CLAUDE_CONFIG_DIR/admin-workflow-manifest.txt"

# v1.3 Agent 分组
AGENT_GROUPS=("design" "explore" "audit" "review")


print_banner() {
    echo -e "${CYAN}"
    echo "╭──────────────────────────────────────────────────────────────────╮"
    echo "│                                                                  │"
    echo "│     █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗                     │"
    echo "│    ██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║                     │"
    echo "│    ███████║██║  ██║██╔████╔██║██║██╔██╗ ██║                     │"
    echo "│    ██╔══██║██║  ██║██║╚██╔╝██║██║██║╚██╗██║                     │"
    echo "│    ██║  ██║██████╔╝██║ ╚═╝ ██║██║██║ ╚████║                     │"
    echo "│    ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝                     │"
    echo "│                                                                  │"
    echo "│    🗑️  安全卸载程序 v1.6                                         │"
    echo "│                                                                  │"
    echo "╰──────────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
}

log_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

log_info() {
    echo -e "  ${BLUE}ℹ${NC} $1"
}

log_error() {
    echo -e "  ${RED}✗${NC} $1"
}

print_banner

# ============================================================
# 检测卸载模式
# ============================================================

USE_MANIFEST=false
if [[ -f "$MANIFEST_FILE" ]]; then
    USE_MANIFEST=true
    echo -e "${GREEN}✅ 检测到安装清单，将使用安全卸载模式${NC}"
    echo ""
    echo -e "   ${BOLD}安全卸载${NC}：只删除本工作流安装的文件"
    echo -e "   ${BOLD}不会影响${NC}：其他 AI 工具、MCP 配置、项目文件"
    echo ""
else
    echo -e "${YELLOW}⚠️  未检测到安装清单，将使用传统卸载模式${NC}"
    echo ""
    echo -e "   将删除以下已知的工作流文件（不会影响其他工具）"
    echo ""
fi

# ============================================================
# 显示将要删除的内容
# ============================================================

if [[ "$USE_MANIFEST" == "true" ]]; then
    echo -e "${BOLD}将删除以下文件（来自安装清单）:${NC}"
    echo ""

    file_count=0
    while IFS= read -r line; do
        # 跳过注释和空行
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        if [[ -e "$line" ]]; then
            echo -e "  • $line"
            file_count=$((file_count + 1))
        fi
    done < "$MANIFEST_FILE"

    echo ""
    echo -e "  ${BOLD}共 $file_count 个文件/目录${NC}"
else
    echo -e "  ${BOLD}Commands（/admin:* 斜杠命令）:${NC}"
    if [[ -d "$COMMANDS_ADMIN_DIR" ]]; then
        echo -e "  • $COMMANDS_ADMIN_DIR/"
    else
        echo -e "  ${YELLOW}(未检测到 commands/admin/ 目录)${NC}"
    fi
    echo ""
    echo -e "  ${BOLD}Skills（v1.4 目录结构）:${NC}"
    echo -e "  • $SKILLS_DIR/admin-workflow/"
    echo -e "    ├── 00-admin.md ~ 07-archive.md"
    echo -e "    └── other/"
    echo ""
    echo -e "  ${BOLD}Agents（命名空间隔离）:${NC}"
    if [[ -d "$AGENTS_WORKFLOW_DIR" ]]; then
        echo -e "  • $AGENTS_WORKFLOW_DIR/"
        for group in "${AGENT_GROUPS[@]}"; do
            echo -e "    ├── $group/"
        done
    else
        # 兼容旧版非命名空间安装
        echo -e "  ${YELLOW}(旧版安装，将只删除已知的 agent 文件)${NC}"
        for group in "${AGENT_GROUPS[@]}"; do
            echo -e "  • $AGENTS_DIR/$group/ (仅删除已知文件)"
        done
    fi
fi

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}以下内容不会被删除:${NC}"
echo -e "  • ~/.claude/.mcp.json（MCP 配置）"
echo -e "  • ~/.claude/CLAUDE.md（全局配置）"
echo -e "  • 项目中的 openspec/ 目录"
echo -e "  • 其他 AI 工具的文件"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "确定要卸载吗？ (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}已取消卸载${NC}"
    exit 0
fi

echo ""

# ============================================================
# 执行卸载
# ============================================================

if [[ "$USE_MANIFEST" == "true" ]]; then
    # 基于 manifest 的安全卸载
    echo -e "${YELLOW}[1/2]${NC} ${BOLD}删除已安装文件...${NC}"

    deleted_count=0
    skipped_count=0

    # 先删除文件，再删除目录
    declare -a dirs_to_delete

    while IFS= read -r line; do
        # 跳过注释和空行
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue

        if [[ -d "$line" ]]; then
            # 目录稍后处理
            dirs_to_delete+=("$line")
        elif [[ -f "$line" ]]; then
            rm "$line"
            log_success "删除 $line"
            deleted_count=$((deleted_count + 1))
        else
            skipped_count=$((skipped_count + 1))
        fi
    done < "$MANIFEST_FILE"

    # 删除目录（逆序，先删除子目录）
    for ((i=${#dirs_to_delete[@]}-1; i>=0; i--)); do
        dir="${dirs_to_delete[i]}"
        if [[ -d "$dir" ]]; then
            # 检查目录是否为空
            if [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
                rmdir "$dir"
                log_success "删除空目录 $dir"
                deleted_count=$((deleted_count + 1))
            else
                # 仅对 admin-workflow 或 commands/admin 命名空间内的目录执行强制删除
                # 绝不删除通用目录（如 agents/、skills/、commands/），避免影响其他工具
                if [[ "$dir" == *"/admin-workflow"* ]] || [[ "$dir" == *"/commands/admin"* ]]; then
                    rm -rf "$dir"
                    log_success "删除目录 $dir"
                    deleted_count=$((deleted_count + 1))
                else
                    log_warning "目录非空，跳过（可能包含其他工具文件）: $dir"
                fi
            fi
        fi
    done

    echo ""
    echo -e "${YELLOW}[2/2]${NC} ${BOLD}清理完成${NC}"

    # 删除 manifest 文件
    if [[ -f "$MANIFEST_FILE" ]]; then
        rm "$MANIFEST_FILE"
        log_success "删除安装清单"
    fi

    echo ""
    log_info "已删除 $deleted_count 个文件/目录"
    if [[ $skipped_count -gt 0 ]]; then
        log_info "跳过 $skipped_count 个不存在的文件"
    fi

else
    # 传统卸载模式（v1.6 目录结构）
    echo -e "${YELLOW}[1/4]${NC} ${BOLD}删除 Commands（/admin:* 斜杠命令）...${NC}"

    if [ -d "$COMMANDS_ADMIN_DIR" ]; then
        rm -rf "$COMMANDS_ADMIN_DIR"
        log_success "删除 commands/admin/ (斜杠命令目录)"
    else
        log_info "commands/admin/ 不存在，跳过"
    fi

    echo -e "${YELLOW}[2/4]${NC} ${BOLD}删除 Skills...${NC}"

    if [ -d "$SKILLS_DIR/admin-workflow" ]; then
        rm -rf "$SKILLS_DIR/admin-workflow"
        log_success "删除 admin-workflow"
    else
        log_info "admin-workflow 不存在，跳过"
    fi

    # 删除备份目录
    for backup in "$SKILLS_DIR"/admin-workflow.backup.*; do
        if [ -d "$backup" ]; then
            rm -rf "$backup"
            log_success "删除备份: $(basename "$backup")"
        fi
    done

    echo -e "${YELLOW}[3/4]${NC} ${BOLD}删除 Agents...${NC}"

    # 优先删除命名空间目录（v1.5+ 安装方式，安全删除）
    if [ -d "$AGENTS_WORKFLOW_DIR" ]; then
        rm -rf "$AGENTS_WORKFLOW_DIR"
        log_success "删除 agents/admin-workflow/ (命名空间目录)"
    else
        log_info "agents/admin-workflow/ 不存在"
    fi

    # 兼容旧版本（v1.3~v1.4）：逐文件删除分组目录中的已知 agent 文件
    # 重要：不使用 rm -rf 删除整个分组目录，避免误删其他工具的文件
    KNOWN_AGENTS=(
        "design/code-architect.md"
        "explore/code-explorer.md"
        "audit/impact-analyzer.md"
        "audit/qa-arch-reviewer.md"
        "audit/qa-security-reviewer.md"
        "review/code-reviewer.md"
        "review/code-simplifier.md"
    )

    for agent_path in "${KNOWN_AGENTS[@]}"; do
        if [ -f "$AGENTS_DIR/$agent_path" ]; then
            rm "$AGENTS_DIR/$agent_path"
            log_success "删除旧版 $agent_path"
        fi
    done

    # 兼容更早版本：删除扁平结构的 agent 文件
    OLD_FLAT_AGENTS=(
        "code-explorer.md"
        "code-architect.md"
        "code-reviewer.md"
        "code-simplifier.md"
        "impact-analyzer.md"
        "qa-arch-reviewer.md"
        "qa-security-reviewer.md"
    )

    for agent in "${OLD_FLAT_AGENTS[@]}"; do
        if [ -f "$AGENTS_DIR/$agent" ]; then
            rm "$AGENTS_DIR/$agent"
            log_success "删除旧版(扁平) $agent"
        fi
    done

    # 删除旧版 README（仅在 agents/ 根目录下的）
    if [ -f "$AGENTS_DIR/README.md" ]; then
        rm "$AGENTS_DIR/README.md"
        log_success "删除 agents/README.md"
    fi

    # 清理空的旧版分组目录（仅当目录为空时才删除）
    for group in "${AGENT_GROUPS[@]}"; do
        if [ -d "$AGENTS_DIR/$group" ] && [ -z "$(ls -A "$AGENTS_DIR/$group" 2>/dev/null)" ]; then
            rmdir "$AGENTS_DIR/$group"
            log_success "清理空目录 agents/$group/"
        fi
    done

    echo -e "${YELLOW}[4/4]${NC} ${BOLD}清理完成${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                        🎉 卸载完成！                               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BOLD}📝 注意事项${NC}"
echo -e "   • 项目级配置文件（openspec/）未被删除"
echo -e "   • MCP 配置（~/.claude/.mcp.json）未被修改"
echo -e "   • 如需完全清理，请手动删除项目中的 openspec/ 目录"
echo ""

echo -e "${BOLD}🔄 重新安装${NC}"
echo -e "   ${CYAN}./install.sh${NC}"
echo ""
