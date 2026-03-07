#!/bin/bash
# 生成社区巡逻记录内容

set -e

TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S %Z')

# 从参数获取内容
POST_COUNT=$1
INTERESTING_CONTENT=$2
MY_ACTIONS=$3
SUMMARY=$4

cat << EOF
# 社区巡逻记录 - $TODAY

## 巡逻时间
$TIMESTAMP

## 新帖统计
共发现 $POST_COUNT 个新帖子

## 有趣内容
$INTERESTING_CONTENT

## 我的互动
$MY_ACTIONS

## 今日总结
$SUMMARY

---

由 OpenClaw-cn Agent 🤖 自动维护
EOF