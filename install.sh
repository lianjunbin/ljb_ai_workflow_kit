#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
#  管理后台 AI 开发工作流 - 安装器 v1.4
#
#  从 Jira 需求到代码交付，AI 全程协助
#  支持本地安装和远程安装
#
#  目录结构（v1.4 更新）:
#  ├── skills/admin-workflow/
#  │   ├── 00-admin.md ~ 07-archive.md  (7 阶段核心工作流)
#  │   └── other/                        (辅助文件)
#  └── agents/
#      ├── design/    (设计类)
#      ├── explore/   (探索类)
#      ├── audit/     (审计类)
#      └── review/    (审查类)
# ═══════════════════════════════════════════════════════════════════════════════

set -e

# ─────────────────────────────────────────────────────────────────────────────
# 配置
# ─────────────────────────────────────────────────────────────────────────────

VERSION="1.4.0"
REPO_URL="https://github.com/lianjunbin/ljb_ai_workflow_kit"
REPO_RAW_URL="https://raw.githubusercontent.com/lianjunbin/ljb_ai_workflow_kit/main"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
AGENTS_DIR="$CLAUDE_DIR/agents"
MCP_CONFIG="$CLAUDE_DIR/.mcp.json"
MANIFEST_FILE="$CLAUDE_DIR/admin-workflow-manifest.txt"
BACKUP_SUFFIX="backup.$(date +%Y%m%d%H%M%S)"

# 临时目录（远程安装时使用）
TEMP_DIR=""

# 安装模式
INSTALL_MODE="local"  # local 或 remote

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# ─────────────────────────────────────────────────────────────────────────────
# 文件列表（v1.3 更新：按新目录结构）
# ─────────────────────────────────────────────────────────────────────────────

# 核心工作流 Skills（7 阶段，按顺序）
CORE_SKILL_FILES=(
    "00-admin.md"
    "01-init.md"
    "02-start.md"
    "03-design.md"
    "04-audit.md"
    "05-apply.md"
    "06-review.md"
    "07-archive.md"
    "README.md"
)

# 辅助文件（放在 other/ 子目录）
OTHER_SKILL_FILES=(
    "coding-standards.md"
    "style-guide.md"
)

# Agents（按职能分组）
declare -A AGENT_GROUPS=(
    ["design"]="code-architect.md"
    ["explore"]="code-explorer.md"
    ["audit"]="impact-analyzer.md qa-arch-reviewer.md qa-security-reviewer.md"
    ["review"]="code-reviewer.md code-simplifier.md"
)

# ─────────────────────────────────────────────────────────────────────────────
# 辅助函数
# ─────────────────────────────────────────────────────────────────────────────

print_banner() {
    echo ""
    echo -e "${CYAN}╭──────────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│                                                                  │${NC}"
    echo -e "${CYAN}│     █████╗ ██████╗ ███╗   ███╗██╗███╗   ██╗                     │${NC}"
    echo -e "${CYAN}│    ██╔══██╗██╔══██╗████╗ ████║██║████╗  ██║                     │${NC}"
    echo -e "${CYAN}│    ███████║██║  ██║██╔████╔██║██║██╔██╗ ██║                     │${NC}"
    echo -e "${CYAN}│    ██╔══██║██║  ██║██║╚██╔╝██║██║██║╚██╗██║                     │${NC}"
    echo -e "${CYAN}│    ██║  ██║██████╔╝██║ ╚═╝ ██║██║██║ ╚████║                     │${NC}"
    echo -e "${CYAN}│    ╚═╝  ╚═╝╚═════╝ ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝                     │${NC}"
    echo -e "${CYAN}│                                                                  │${NC}"
    echo -e "${CYAN}│    🚀 管理后台 AI 开发工作流 v${VERSION}                           │${NC}"
    echo -e "${CYAN}│    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━   │${NC}"
    echo -e "${CYAN}│    从 Jira 需求到代码交付，AI 全程协助                            │${NC}"
    echo -e "${CYAN}│                                                                  │${NC}"
    echo -e "${CYAN}╰──────────────────────────────────────────────────────────────────╯${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${BLUE}─────────────────────────────────────────────────────────────────────────────${NC}"
    echo -e "${BOLD}  $1${NC}"
    echo -e "${BLUE}─────────────────────────────────────────────────────────────────────────────${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}  ✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}  ⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}  ❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}  ℹ️  $1${NC}"
}

print_step() {
    echo -e "  ${BOLD}→${NC} $1"
}

confirm() {
    local message="$1"
    local default="${2:-Y}"

    if [[ "$AUTO_YES" == "true" ]]; then
        return 0
    fi

    local prompt
    if [[ "$default" == "Y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi

    echo -en "  ${BOLD}?${NC} $message $prompt "
    read -r response

    if [[ -z "$response" ]]; then
        response="$default"
    fi

    case "$response" in
        [Yy]* ) return 0;;
        * ) return 1;;
    esac
}

select_option() {
    local prompt="$1"
    shift
    local options=("$@")

    echo -e "  ${BOLD}?${NC} $prompt"
    for i in "${!options[@]}"; do
        echo -e "    ${CYAN}$((i+1))${NC}) ${options[$i]}"
    done

    echo -en "  请选择 [1-${#options[@]}]: "
    read -r choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
        return $((choice-1))
    else
        return 0
    fi
}

# 清理函数
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT

# ─────────────────────────────────────────────────────────────────────────────
# 阶段 0: 检测安装模式
# ─────────────────────────────────────────────────────────────────────────────

detect_install_mode() {
    # 检查是否存在本地文件
    if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skills" ] && [ -d "$SCRIPT_DIR/agents" ]; then
        INSTALL_MODE="local"
        SOURCE_DIR="$SCRIPT_DIR"
        print_info "检测到本地安装模式"
    else
        INSTALL_MODE="remote"
        print_info "检测到远程安装模式，将从 GitHub 下载文件..."
        download_files
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# 远程下载（v1.3 更新：新目录结构）
# ─────────────────────────────────────────────────────────────────────────────

download_files() {
    TEMP_DIR=$(mktemp -d)
    SOURCE_DIR="$TEMP_DIR"

    print_step "创建临时目录: $TEMP_DIR"

    # 创建目录结构
    mkdir -p "$TEMP_DIR/skills/admin-workflow/other"
    mkdir -p "$TEMP_DIR/agents/design"
    mkdir -p "$TEMP_DIR/agents/explore"
    mkdir -p "$TEMP_DIR/agents/audit"
    mkdir -p "$TEMP_DIR/agents/review"

    print_step "下载核心 Skills 文件..."
    for file in "${CORE_SKILL_FILES[@]}"; do
        if curl -fsSL "$REPO_RAW_URL/skills/admin-workflow/$file" -o "$TEMP_DIR/skills/admin-workflow/$file" 2>/dev/null; then
            echo -e "    ${GREEN}✓${NC} $file"
        else
            print_error "下载失败: $file"
            exit 1
        fi
    done

    print_step "下载辅助 Skills 文件..."
    for file in "${OTHER_SKILL_FILES[@]}"; do
        if curl -fsSL "$REPO_RAW_URL/skills/admin-workflow/other/$file" -o "$TEMP_DIR/skills/admin-workflow/other/$file" 2>/dev/null; then
            echo -e "    ${GREEN}✓${NC} other/$file"
        else
            print_error "下载失败: other/$file"
            exit 1
        fi
    done

    print_step "下载 Agents 文件..."
    for group in "${!AGENT_GROUPS[@]}"; do
        for file in ${AGENT_GROUPS[$group]}; do
            if curl -fsSL "$REPO_RAW_URL/agents/$group/$file" -o "$TEMP_DIR/agents/$group/$file" 2>/dev/null; then
                echo -e "    ${GREEN}✓${NC} $group/$file"
            else
                print_error "下载失败: $group/$file"
                exit 1
            fi
        done
    done

    # 下载 agents README
    if curl -fsSL "$REPO_RAW_URL/agents/README.md" -o "$TEMP_DIR/agents/README.md" 2>/dev/null; then
        echo -e "    ${GREEN}✓${NC} agents/README.md"
    fi

    print_success "文件下载完成"
}

# ─────────────────────────────────────────────────────────────────────────────
# 阶段 1: 环境检测
# ─────────────────────────────────────────────────────────────────────────────

check_environment() {
    print_section "阶段 1: 环境检测"

    # 检查操作系统
    local os_name
    os_name="$(uname -s)"
    case "$os_name" in
        Darwin*)
            print_success "操作系统: macOS"
            ;;
        Linux*)
            print_success "操作系统: Linux"
            ;;
        *)
            print_error "不支持的操作系统: $os_name"
            exit 1
            ;;
    esac

    # 检查 Claude Code CLI（必需）
    if command -v claude &> /dev/null; then
        local claude_version
        claude_version=$(claude --version 2>/dev/null | head -1 || echo "未知")
        print_success "Claude Code CLI: $claude_version"
    else
        print_error "Claude Code CLI: 未安装（必需）"
        echo ""
        print_info "请先安装 Claude Code CLI:"
        echo ""
        echo -e "    ${CYAN}npm install -g @anthropic-ai/claude-code${NC}"
        echo ""
        echo "    或访问: https://claude.ai/download"
        echo ""

        if ! confirm "是否继续安装（稍后手动安装 Claude Code）?" "N"; then
            print_info "安装已取消。请先安装 Claude Code CLI 后重试。"
            exit 0
        fi

        CLAUDE_MISSING=true
    fi

    # 检查 Node.js（MCP 服务器需要）
    if command -v node &> /dev/null; then
        local node_version
        node_version=$(node -v)
        print_success "Node.js: $node_version"
    else
        print_warning "Node.js: 未安装"
        print_info "MCP 服务器（如 Jira）需要 Node.js"
        echo ""
        echo -e "    安装: ${CYAN}brew install node${NC} 或 ${CYAN}nvm install --lts${NC}"
        echo ""

        NODE_MISSING=true
    fi

    # 检查 npx
    if command -v npx &> /dev/null; then
        print_success "npx: 可用"
    else
        print_warning "npx: 未安装（随 Node.js 一起安装）"
        NPX_MISSING=true
    fi

    # 检查 ~/.claude/ 目录
    if [[ -d "$CLAUDE_DIR" ]]; then
        print_success "~/.claude/ 目录: 已存在"
    else
        print_info "~/.claude/ 目录: 将自动创建"
        mkdir -p "$CLAUDE_DIR"
    fi

    # 创建必要目录
    mkdir -p "$SKILLS_DIR"
    mkdir -p "$AGENTS_DIR"
}

# ─────────────────────────────────────────────────────────────────────────────
# 阶段 2: MCP 配置检测
# ─────────────────────────────────────────────────────────────────────────────

check_mcp_config() {
    print_section "阶段 2: MCP 服务配置检测"

    # 检查 MCP 配置文件
    if [[ ! -f "$MCP_CONFIG" ]]; then
        print_warning "MCP 配置文件不存在: $MCP_CONFIG"
        JIRA_MISSING=true
    else
        # 检查 Jira MCP（必需）
        if command -v jq &> /dev/null; then
            if jq -e '.mcpServers.jira' "$MCP_CONFIG" > /dev/null 2>&1; then
                local has_token has_site has_email
                has_token=$(jq -r '.mcpServers.jira.env.ATLASSIAN_API_TOKEN // empty' "$MCP_CONFIG" 2>/dev/null)
                has_site=$(jq -r '.mcpServers.jira.env.ATLASSIAN_SITE_URL // empty' "$MCP_CONFIG" 2>/dev/null)
                has_email=$(jq -r '.mcpServers.jira.env.ATLASSIAN_USER_EMAIL // empty' "$MCP_CONFIG" 2>/dev/null)

                if [[ -n "$has_token" ]] && [[ -n "$has_site" ]] && [[ -n "$has_email" ]]; then
                    print_success "Jira MCP: 已配置 ✓"
                else
                    print_warning "Jira MCP: 配置不完整"
                    JIRA_INCOMPLETE=true
                fi
            else
                print_warning "Jira MCP: 未配置"
                JIRA_MISSING=true
            fi

            # 检查可选 MCP
            if jq -e '.mcpServers["chrome-devtools"]' "$MCP_CONFIG" > /dev/null 2>&1; then
                print_success "Chrome DevTools MCP: 已配置（可选）"
            else
                print_info "Chrome DevTools MCP: 未配置（可选，用于 Apifox）"
            fi

            if jq -e '.mcpServers.context7' "$MCP_CONFIG" > /dev/null 2>&1; then
                print_success "Context7 MCP: 已配置（可选）"
            else
                print_info "Context7 MCP: 未配置（可选，用于文档查询）"
            fi
        else
            # 没有 jq，简单检查
            if grep -q '"jira"' "$MCP_CONFIG" 2>/dev/null; then
                print_success "Jira MCP: 检测到配置"
            else
                print_warning "Jira MCP: 未配置"
                JIRA_MISSING=true
            fi
        fi
    fi

    # 如果 Jira 未配置，显示配置指南
    if [[ "$JIRA_MISSING" == "true" ]] || [[ "$JIRA_INCOMPLETE" == "true" ]]; then
        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}📋 Jira MCP 配置指南（必需）${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "  ${BOLD}步骤 1:${NC} 获取 Atlassian API Token"
        echo -e "         ${CYAN}https://id.atlassian.com/manage-profile/security/api-tokens${NC}"
        echo ""
        echo -e "  ${BOLD}步骤 2:${NC} 创建或编辑配置文件"
        echo -e "         ${CYAN}$MCP_CONFIG${NC}"
        echo ""
        echo -e "  ${BOLD}步骤 3:${NC} 添加以下配置:"
        echo ""
        echo -e "${CYAN}"
        cat << 'EOF'
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
EOF
        echo -e "${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        if ! confirm "是否继续安装（稍后配置 Jira MCP）?" "Y"; then
            print_info "安装已取消。请配置 Jira MCP 后重试。"
            exit 0
        fi
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# 阶段 3: 安装 Skills 和 Agents（v1.3 更新）
# ─────────────────────────────────────────────────────────────────────────────

# 记录已安装文件到 manifest
record_file() {
    local file_path="$1"
    echo "$file_path" >> "$MANIFEST_FILE"
}

install_files() {
    print_section "阶段 3: 安装 Skills 和 Agents"

    # 初始化 manifest 文件
    echo "# Admin Workflow Manifest - $(date)" > "$MANIFEST_FILE"
    echo "# 此文件记录已安装的文件，用于安全卸载" >> "$MANIFEST_FILE"
    echo "# v1.3 目录结构：按顺序编号 + 职能分组" >> "$MANIFEST_FILE"
    echo "" >> "$MANIFEST_FILE"

    local workflow_target="$SKILLS_DIR/admin-workflow"

    # 检查是否已存在
    if [[ -d "$workflow_target" ]]; then
        print_warning "检测到已存在 ~/.claude/skills/admin-workflow/"

        select_option "请选择处理方式:" \
            "覆盖（备份现有文件）" \
            "合并（保留现有，添加缺失）" \
            "跳过"
        local choice=$?

        case $choice in
            0)  # 覆盖
                print_step "备份到 admin-workflow.$BACKUP_SUFFIX"
                mv "$workflow_target" "$workflow_target.$BACKUP_SUFFIX"
                ;;
            1)  # 合并
                MERGE_MODE=true
                ;;
            2)  # 跳过
                SKIP_INSTALL=true
                ;;
        esac
    fi

    # 安装 Skills
    if [[ "$SKIP_INSTALL" != "true" ]]; then
        # 创建目录结构
        mkdir -p "$workflow_target/other"
        record_file "$workflow_target"
        record_file "$workflow_target/other"

        if [[ "$MERGE_MODE" == "true" ]]; then
            print_step "合并 Skills..."

            # 合并核心文件
            for file in "${CORE_SKILL_FILES[@]}"; do
                local src="$SOURCE_DIR/skills/admin-workflow/$file"
                local dst="$workflow_target/$file"
                if [[ -f "$src" ]]; then
                    if [[ ! -f "$dst" ]]; then
                        cp "$src" "$dst"
                        record_file "$dst"
                        print_success "已添加: $file"
                    else
                        print_info "已跳过（已存在）: $file"
                    fi
                fi
            done

            # 合并辅助文件
            for file in "${OTHER_SKILL_FILES[@]}"; do
                local src="$SOURCE_DIR/skills/admin-workflow/other/$file"
                local dst="$workflow_target/other/$file"
                if [[ -f "$src" ]]; then
                    if [[ ! -f "$dst" ]]; then
                        cp "$src" "$dst"
                        record_file "$dst"
                        print_success "已添加: other/$file"
                    else
                        print_info "已跳过（已存在）: other/$file"
                    fi
                fi
            done
        else
            print_step "安装 Skills..."

            # 安装核心文件
            for file in "${CORE_SKILL_FILES[@]}"; do
                local src="$SOURCE_DIR/skills/admin-workflow/$file"
                if [[ -f "$src" ]]; then
                    cp "$src" "$workflow_target/"
                    record_file "$workflow_target/$file"
                fi
            done

            # 安装辅助文件
            for file in "${OTHER_SKILL_FILES[@]}"; do
                local src="$SOURCE_DIR/skills/admin-workflow/other/$file"
                if [[ -f "$src" ]]; then
                    cp "$src" "$workflow_target/other/"
                    record_file "$workflow_target/other/$file"
                fi
            done

            local skill_count
            skill_count=$(find "$workflow_target" -name "*.md" | wc -l | tr -d ' ')
            print_success "已安装 $skill_count 个 Skill 文件"
        fi

        # 安装 Agents（按职能分组）
        print_step "安装 Agents（按职能分组）..."
        local agent_count=0

        for group in "${!AGENT_GROUPS[@]}"; do
            local group_dir="$AGENTS_DIR/$group"
            mkdir -p "$group_dir"
            record_file "$group_dir"

            for file in ${AGENT_GROUPS[$group]}; do
                local src="$SOURCE_DIR/agents/$group/$file"
                if [[ -f "$src" ]]; then
                    cp "$src" "$group_dir/"
                    record_file "$group_dir/$file"
                    agent_count=$((agent_count + 1))
                fi
            done
        done

        # 安装 agents README
        if [[ -f "$SOURCE_DIR/agents/README.md" ]]; then
            cp "$SOURCE_DIR/agents/README.md" "$AGENTS_DIR/"
            record_file "$AGENTS_DIR/README.md"
        fi

        print_success "已安装 $agent_count 个 Agent 文件（4 个分组）"
    fi

    # 记录 manifest 文件本身
    record_file "$MANIFEST_FILE"
    print_success "已创建安装清单: $MANIFEST_FILE"
}

# ─────────────────────────────────────────────────────────────────────────────
# 阶段 4: 验证安装（v1.3 更新）
# ─────────────────────────────────────────────────────────────────────────────

verify_installation() {
    print_section "阶段 4: 验证安装"

    local all_ok=true

    # 验证 Skills（7 阶段编号格式）
    echo -e "  ${BOLD}验证核心工作流 Skills:${NC}"
    local skill_map=(
        "00-admin:admin"
        "01-init:init"
        "02-start:start"
        "03-design:design"
        "04-audit:audit"
        "05-apply:apply"
        "06-review:review"
        "07-archive:archive"
    )

    for item in "${skill_map[@]}"; do
        local file="${item%%:*}"
        local cmd="${item##*:}"
        if [[ -f "$SKILLS_DIR/admin-workflow/$file.md" ]]; then
            print_success "/admin:$cmd → $file.md"
        else
            print_error "/admin:$cmd 未找到"
            all_ok=false
        fi
    done

    # 验证 Agents（按分组）
    echo ""
    echo -e "  ${BOLD}验证 Agents（按职能分组）:${NC}"

    for group in "${!AGENT_GROUPS[@]}"; do
        for file in ${AGENT_GROUPS[$group]}; do
            if [[ -f "$AGENTS_DIR/$group/$file" ]]; then
                print_success "$group/$file"
            else
                print_error "$group/$file 未找到"
                all_ok=false
            fi
        done
    done

    if [[ "$all_ok" == "true" ]]; then
        echo ""
        print_success "所有核心文件验证通过！"
    else
        echo ""
        print_warning "部分验证失败，请检查上面的错误信息。"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────
# 阶段 5: 安装总结（v1.3 更新）
# ─────────────────────────────────────────────────────────────────────────────

print_summary() {
    print_section "安装完成！"

    echo -e "  ${GREEN}管理后台 AI 开发工作流 v$VERSION 已安装成功！${NC}"
    echo ""

    # 如果缺少依赖，显示警告
    if [[ "$CLAUDE_MISSING" == "true" ]] || [[ "$NODE_MISSING" == "true" ]] || [[ "$JIRA_MISSING" == "true" ]] || [[ "$JIRA_INCOMPLETE" == "true" ]]; then
        echo -e "  ${YELLOW}⚠️  缺少必需依赖，请先安装：${NC}"
        echo ""

        if [[ "$CLAUDE_MISSING" == "true" ]]; then
            echo -e "    ${BOLD}Claude Code CLI:${NC}"
            echo -e "    ${CYAN}npm install -g @anthropic-ai/claude-code${NC}"
            echo ""
        fi

        if [[ "$NODE_MISSING" == "true" ]]; then
            echo -e "    ${BOLD}Node.js:${NC}"
            echo -e "    ${CYAN}brew install node${NC} 或 ${CYAN}nvm install --lts${NC}"
            echo ""
        fi

        if [[ "$JIRA_MISSING" == "true" ]] || [[ "$JIRA_INCOMPLETE" == "true" ]]; then
            echo -e "    ${BOLD}Jira MCP 配置:${NC}"
            echo -e "    编辑 ${CYAN}~/.claude/.mcp.json${NC}，添加 Jira 配置"
            echo -e "    详见上方配置指南"
            echo ""
        fi
    fi

    echo -e "  ${BOLD}目录结构（v1.4）:${NC}"
    echo ""
    echo "    ┌──────────────────────────────────────────────────────────────────┐"
    echo "    │  ~/.claude/skills/admin-workflow/                                │"
    echo "    │  ├── 00-admin.md ~ 07-archive.md   7 阶段核心工作流             │"
    echo "    │  └── other/                        辅助文件                     │"
    echo "    │                                                                  │"
    echo "    │  ~/.claude/agents/                                               │"
    echo "    │  ├── design/    code-architect     (DESIGN 阶段)                │"
    echo "    │  ├── explore/   code-explorer      (START 阶段)                 │"
    echo "    │  ├── audit/     impact-analyzer... (AUDIT 阶段)                 │"
    echo "    │  └── review/    code-reviewer...   (REVIEW 阶段)                │"
    echo "    └──────────────────────────────────────────────────────────────────┘"
    echo ""
    echo -e "  ${BOLD}工作流阶段（7 阶段精简版）:${NC}"
    echo ""
    echo "    ┌─────────────────────────────────────────────────────────────────┐"
    echo "    │  📖 分析设计阶段（只读）          ✏️ 执行阶段（写入）           │"
    echo "    ├─────────────────────────────────────────────────────────────────┤"
    echo "    │  01-INIT → 02-START → 03-DESIGN   05-APPLY → 06-REVIEW         │"
    echo "    │  → 04-AUDIT                       → 07-ARCHIVE                 │"
    echo "    └─────────────────────────────────────────────────────────────────┘"
    echo ""
    echo -e "  ${BOLD}已安装命令:${NC}"
    echo ""
    echo "    /admin          → 🚀 显示工作流总览"
    echo "    /admin:init     → 🎬 初始化项目"
    echo "    /admin:start    → 📋 需求准备（Jira + API + 业务梳理）"
    echo "    /admin:design   → 🎨 提案设计（含权限配置）"
    echo "    /admin:audit    → 📑 提案审阅（代码逻辑预览）"
    echo "    /admin:apply    → ⚡ 应用代码（可选择性回滚）"
    echo "    /admin:review   → 🔍 代码走读（选择性优化+Git建议）"
    echo "    /admin:archive  → 📦 归档提案"
    echo ""
    echo -e "  ${BOLD}下一步操作:${NC}"
    echo ""
    echo -e "    1. ${CYAN}cd your-admin-project${NC}"
    echo "       进入你的管理后台项目目录"
    echo ""
    echo -e "    2. ${CYAN}claude${NC}"
    echo "       启动 Claude Code"
    echo ""
    echo -e "    3. ${CYAN}/admin:init${NC}"
    echo "       初始化项目的 OpenSpec 结构"
    echo ""
    echo -e "    4. ${CYAN}/admin:start PIX-1234${NC}"
    echo "       开始新需求开发"
    echo ""
    echo -e "  ${BOLD}文档:${NC}"
    echo ""
    echo "    • 项目地址:   $REPO_URL"
    echo "    • 设计原则:   docs/WORKFLOW-PRINCIPLES.md"
    echo "    • 问题反馈:   $REPO_URL/issues"
    echo ""
    echo -e "  ${BOLD}卸载:${NC}"
    echo ""
    if [[ "$INSTALL_MODE" == "local" ]]; then
        echo -e "    ${CYAN}./uninstall.sh${NC}"
    else
        echo -e "    ${CYAN}curl -fsSL $REPO_RAW_URL/uninstall.sh | bash${NC}"
    fi
    echo ""
}

# ─────────────────────────────────────────────────────────────────────────────
# 主函数
# ─────────────────────────────────────────────────────────────────────────────

main() {
    # 解析参数
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --yes|-y) AUTO_YES=true ;;
            --help|-h)
                echo "用法: ./install.sh [选项]"
                echo ""
                echo "安装方式:"
                echo "  本地安装:  git clone $REPO_URL && cd ljb_ai_workflow_kit && ./install.sh"
                echo "  远程安装:  curl -fsSL $REPO_RAW_URL/install.sh | bash"
                echo ""
                echo "选项:"
                echo "  --yes, -y     自动确认所有提示"
                echo "  --help, -h    显示帮助信息"
                exit 0
                ;;
            *)
                print_error "未知选项: $1"
                exit 1
                ;;
        esac
        shift
    done

    print_banner

    echo "  专为管理后台业务功能开发设计的 AI 工作流"
    echo "  7 阶段精简工作流 | 多代理协同 | TSX + Vue 分离 | 权限配置设计"
    echo ""

    # 运行安装阶段
    detect_install_mode
    check_environment
    check_mcp_config
    install_files
    verify_installation
    print_summary
}

# 运行主函数
main "$@"
