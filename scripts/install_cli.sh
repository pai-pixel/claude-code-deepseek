#!/usr/bin/env bash
set -euo pipefail

echo "[+] 检查 Node.js 环境..."
if ! command -v node >/dev/null 2>&1; then
  echo "[-] 未检测到 Node.js，请先安装 Node.js (>= 18.0) 后再试。"
  exit 1
fi

echo "[+] 正在全局安装 @anthropic-ai/claude-code..."
npm install -g @anthropic-ai/claude-code

echo "[✓] 安装成功！当前版本："
claude --version || true
