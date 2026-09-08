# Claude Code × DeepSeek Configuration (Claude Code 接入 DeepSeek)

A production-ready setup and configuration guide for running Anthropic's **Claude Code CLI** (`claude`) natively backed by **DeepSeek (V3 / R1)** models or custom Anthropic API proxies.

无需官方 Claude Pro / Team 昂贵订阅，通过原生环境变量劫持与协议映射，实现极低成本、高并发、强大的终端自动化 Agent 体验。

---

## 🌟 核心特性 (Features)

1. **原生零侵入接入**：无需修改 Claude Code 源码，仅通过官方原生支持的环境变量配置即可无缝桥接 DeepSeek API。
2. **多模型自由切换**：支持一键在 `deepseek-chat` (V3 极速编程)、`deepseek-reasoner` (R1 深度推理) 以及第三方兼容中转服务之间快捷切换。
3. **自动化权限白名单**：预置高频开发工具（Git、Python、curl、测试等）免交互确认白名单模板，消除频繁按 `Y` 确认的痛点。
4. **低噪静默与遥测优化**：内置 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` 与属性头净化，降低网络延迟与非必要数据上报。

---

## 🚀 快速上手 (Quickstart)

### 1. 前置依赖 (Prerequisites)

确保本地已安装 Node.js (>= 18.0) 以及全局安装官方 Claude Code CLI：

```bash
# 全局安装 Claude Code CLI
npm install -g @anthropic-ai/claude-code

# 验证安装
claude --version
```

### 2. 获取 DeepSeek API Key

访问 [DeepSeek 开放平台](https://platform.deepseek.com/) 获取你的 API Key：
```bash
# 格式如：sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export DEEPSEEK_API_KEY="your-deepseek-api-key"
```

### 3. 配置 Shell 函数与别名

将以下函数直接添加到你的 `~/.zshrc` 或 `~/.bash_profile` 中：

```bash
# === 1. DeepSeek 通用对话/编程模式 (V3) ===
claude-ds() {
  ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" \
  ANTHROPIC_API_KEY="${DEEPSEEK_API_KEY}" \
  ANTHROPIC_MODEL="deepseek-chat" \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  command claude "$@"
}

# === 2. DeepSeek 深度推理模式 (R1) ===
claude-r1() {
  ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" \
  ANTHROPIC_API_KEY="${DEEPSEEK_API_KEY}" \
  ANTHROPIC_MODEL="deepseek-reasoner" \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  command claude "$@"
}

# === 3. 第三方兼容中转代理模式 (示例：orcai / OneAPI) ===
claude-proxy() {
  ANTHROPIC_BASE_URL="https://your-proxy-endpoint.com" \
  ANTHROPIC_AUTH_TOKEN="your-proxy-token" \
  CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 \
  CLAUDE_CODE_ATTRIBUTION_HEADER=0 \
  command claude "$@"
}
```

重新加载配置文件：
```bash
source ~/.zshrc  # 或 source ~/.bash_profile
```

### 4. 启动与使用

```bash
# 启动 DeepSeek 驱动的 Claude Code CLI
claude-ds

# 启动 DeepSeek R1 深度推理模式
claude-r1

# 直接执行单次任务
claude-ds "检查当前目录下的 git 状态并生成修改说明"
```

---

## ⚙️ 配置文件说明 (Configuration)

### 1. 自动化权限配置 (`settings.local.json`)

默认情况下，Claude Code 执行任何终端命令（如 `git`、`python3`、`curl`）都会暂停请求用户输入确认。

将项目 `config/settings.local.json` 复制到用户目录下的项目工作空间或 `~/.claude/settings.local.json`，即可自动放行常用只读与测试命令：

```json
{
  "permissions": {
    "allow": [
      "Bash(python3 *)",
      "Bash(sqlite3 *)",
      "Bash(grep *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git push *)",
      "WebSearch",
      "WebFetch(domain:github.com)"
    ]
  }
}
```

### 2. 环境变量清单 (Environment Variables)

| 变量名 | 默认值 / 示例 | 说明 |
| :--- | :--- | :--- |
| `ANTHROPIC_BASE_URL` | `https://api.deepseek.com/anthropic` | 兼容 Anthropic 协议的 API 根地址 |
| `ANTHROPIC_API_KEY` | `sk-...` | DeepSeek 或中转服务商提供的 API 密钥 |
| `ANTHROPIC_MODEL` | `deepseek-chat` / `deepseek-reasoner` | 后端执行调用的模型映射名称 |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | `1` | 禁用非必要遥测与统计数据上报 |
| `CLAUDE_CODE_ATTRIBUTION_HEADER` | `0` | 移除客户端归因头，提高反代兼容性 |

---

## 🛡️ 安全注意事项 (Security)

1. **绝不硬编码私钥**：在公开仓库或共享环境中，切勿直接在脚本中写入真实 API Key。推荐统一存储在本地 `~/.env` 并通过 `source ~/.env` 读取。
2. **高危命令拦截**：即便配置了权限白名单，系统对包含 `rm -rf`、`dd`、`mkfs` 等破坏性指令依然具备底线拦截。

---

## 📄 开源许可 (License)

本项目基于 [MIT License](LICENSE) 开源发布。
