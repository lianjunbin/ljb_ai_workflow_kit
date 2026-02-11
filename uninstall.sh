#!/bin/bash

# ============================================================
# 管理后台 AI 开发工作流 - 卸载脚本 v1.4
#
# 特性：
# - 基于 manifest 的安全卸载（只删除本工作流安装的文件）
# - 不影响其他 AI 工具的配置
# - 支持 v1.4 目录结构（7 阶段精简 + 职能分组）
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
    echo "│    🗑️  安全卸载程序 v1.4                                         │"
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
    echo -e "  ${BOLD}Skills（v1.4 目录结构）:${NC}"
    echo -e "  • $SKILLS_DIR/admin-workflow/"
    echo -e "    ├── 00-admin.md ~ 07-archive.md"
    echo -e "    └── other/"
    echo ""
    echo -e "  ${BOLD}Agents（按职能分组）:${NC}"
    for group in "${AGENT_GROUPS[@]}"; do
        echo -e "  • $AGENTS_DIR/$group/"
    done
    echo -e "  • $AGENTS_DIR/README.md"
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
            # 检查目录是否为空或只包含已删除的文件
            if [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
                rmdir "$dir"
                log_success "删除目录 $dir"
                deleted_count=$((deleted_count + 1))
            else
                # 目录非空，强制删除（如果是工作流目录）
                if [[ "$dir" == *"admin-workflow"* ]] || [[ "$dir" == *"/agents/"* ]]; then
                    rm -rf "$dir"
                    log_success "删除目录 $dir"
                    deleted_count=$((deleted_count + 1))
                else
                    log_warning "目录非空，跳过: $dir"
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
    # 传统卸载模式（v1.3 目录结构）
    echo -e "${YELLOW}[1/3]${NC} ${BOLD}删除 Skills...${NC}"

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

    echo -e "${YELLOW}[2/3]${NC} ${BOLD}删除 Agents（按分组）...${NC}"

    # 删除分组目录
    for group in "${AGENT_GROUPS[@]}"; do
        if [ -d "$AGENTS_DIR/$group" ]; then
            rm -rf "$AGENTS_DIR/$group"
            log_success "删除 agents/$group/"
        else
            log_info "agents/$group/ 不存在，跳过"
        fi
    done

    # 删除 agents README
    if [ -f "$AGENTS_DIR/README.md" ]; then
        rm "$AGENTS_DIR/README.md"
        log_success "删除 agents/README.md"
    fi

    # 兼容旧版本：删除扁平结构的 agent 文件
    OLD_AGENTS=(
        "code-explorer.md"
        "code-architect.md"
        "code-reviewer.md"
        "code-simplifier.md"
        "impact-analyzer.md"
        "qa-arch-reviewer.md"
        "qa-security-reviewer.md"
    )

    for agent in "${OLD_AGENTS[@]}"; do
        if [ -f "$AGENTS_DIR/$agent" ]; then
            rm "$AGENTS_DIR/$agent"
            log_success "删除旧版 $agent"
        fi
    done

    echo -e "${YELLOW}[3/3]${NC} ${BOLD}清理完成${NC}"
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
