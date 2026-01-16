#!/bin/bash
# Obsidian 笔记一键备份脚本

cd /Users/ixu/Documents/obsidian

echo "================================"
echo "  Obsidian 笔记备份工具"
echo "================================"
echo ""

# 检查是否有更改
if git diff --quiet && git diff --cached --quiet; then
    echo "✅ 没有需要备份的更改"
    echo ""
    echo "最近的备份："
    git log --oneline -3
    exit 0
fi

echo "📦 正在备份..."

# 添加所有更改
git add -A

# 提交
COMMIT_MSG="backup: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG"

# 推送到 GitHub
git push

echo ""
echo "✅ 备份完成！"
echo ""
echo "最近的备份："
git log --oneline -3
