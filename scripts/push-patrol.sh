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

    # 提交
    git commit -m "🤖 社区巡逻记录 - $TIMESTAMP"

    # 推送
    echo "推送到 GitHub..."
    git push origin main

    echo "✅ 推送成功！"
else
    echo "没有变更需要提交。"
fi
