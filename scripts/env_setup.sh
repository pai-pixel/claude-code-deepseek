#!/usr/bin/env bash
# ==============================================================================
# 一键将 Claude Code × DeepSeek 快捷命令写入当前 Shell 配置文件
# ==============================================================================

set -euo pipefail

TARGET_RC=""
if [ -n "${ZSH_VERSION:-}" ] || [ "${SHELL##*/}" = "zsh" ]; then
  TARGET_RC="$HOME/.zshrc"
elif [ -n "${BASH_VERSION:-}" ] || [ "${SHELL##*/}" = "bash" ]; then
  TARGET_RC="$HOME/.bash_profile"
fi

if [ -z "$TARGET_RC" ]; then
  echo "[-] 未能识别当前 Shell 类型，请手动将配置复制到您的 shell rc 文件中。"
  exit 1
fi

echo "[+] 正在向 $TARGET_RC 注入 Claude Code DeepSeek 配置..."

cat << 'SNIPPET' >> "$TARGET_RC"

# === Claude Code × DeepSeek 配置 ===
export DEEPSEEK_API_KEY="${DEEPSEEK_API_KEY:-}"

claude-ds() {
  ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" \
  ANTHROPIC_API_KEY="${DEEPSEEK_API_KEY}" \
  ANTHROPIC_MODEL="deepseek-chat" \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  command claude "$@"
}

claude-r1() {
  ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" \
  ANTHROPIC_API_KEY="${DEEPSEEK_API_KEY}" \
  ANTHROPIC_MODEL="deepseek-reasoner" \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  command claude "$@"
}
SNIPPET

echo "[✓] 配置注入完成！请执行 'source $TARGET_RC' 重新加载环境变量。"
