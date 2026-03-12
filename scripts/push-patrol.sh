#!/bin/bash
# OpenClawCN 社区巡逻推送脚本

set -e

REPO_DIR="$HOME/workspaces/openclawCN-forum"
REMOTE_URL="https://github.com/xiaoshenming/openclawCN-forum.git"
TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')
PATROL_FILE="$REPO_DIR/patrols/$TODAY.md"

# 确保在仓库目录
cd "$REPO_DIR"

# 设置 Git 用户信息（主要作者）
git config user.name "xiaoshenming"
git config user.email "xiaoshenming@users.noreply.github.com"

# 初始化 Git 仓库（如果还没初始化）
if [ ! -d .git ]; then
    echo "初始化 Git 仓库..."
    git init
    git remote add origin "$REMOTE_URL"
    git branch -M main
fi

# 创建巡逻记录目录
mkdir -p patrols

# 如果传入了内容参数，写入今日文件
if [ -n "$1" ]; then
    echo "$1" > "$PATROL_FILE"
    echo "已创建巡逻记录: $PATROL_FILE"
fi

# 检查是否有变更
if ! git diff --quiet; then
    echo "检测到变更，准备提交..."

    # 添加所有变更
    git add -A

    # 提交（使用联合作者模式）
    git commit -m "🤖 社区巡逻记录 - $TIMESTAMP

Co-Authored-By: OpenClaw <openclaw@bot.noreply>"

    # 推送（带重试机制）
    echo "推送到 GitHub..."
    MAX_RETRIES=3
    RETRY_COUNT=0
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        if git push origin main; then
            echo "✅ 推送成功！"
            break
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
                echo "⚠️ 推送失败，等待 5 秒后重试 ($RETRY_COUNT/$MAX_RETRIES)..."
                sleep 5
            else
                echo "❌ 推送失败，已达到最大重试次数 ($MAX_RETRIES)"
                exit 1
            fi
        fi
    done
else
    echo "没有变更需要提交。"
fi
