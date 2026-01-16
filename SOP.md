# Obsidian + Git 自动备份 SOP

> 标准操作流程 - 新人完整指南

## 📋 目录

1. [系统概述](#系统概述)
2. [环境准备](#环境准备)
3. [配置步骤](#配置步骤)
4. [日常使用](#日常使用)
5. [故障排查](#故障排查)
6. [附录](#附录)

---

## 系统概述

### 什么是这个系统？

**一个自动备份 Obsidian 笔记到 GitHub 的完整方案**

### 工作原理

```
你在 Obsidian 编辑笔记
    ↓
运行备份脚本（手动或定时）
    ↓
Git 提交更改到本地仓库
    ↓
Git 推送到 GitHub 私有仓库
    ↓
✅ 笔记安全备份，保留完整历史
```

### 系统组成

| 组件 | 路径 | 说明 |
|------|------|------|
| **Obsidian 笔记库** | `/Users/ixu/Documents/obsidian` | 你的笔记存放位置 |
| **备份脚本** | `/Users/ixu/Documents/obsidian/backup.sh` | 一键备份脚本 |
| **Git 仓库** | `/Users/ixu/Documents/obsidian/.git` | Git 版本控制 |
| **GitHub 仓库** | https://github.com/wcy8822/obsidian-notes | 远程备份仓库 |

---

## 环境准备

### 前置要求

✅ 已安装 Git
✅ 已有 GitHub 账号
✅ 已配置 SSH 密钥
✅ 已安装 Obsidian

### 检查环境

**1. 检查 Git 是否安装**
```bash
git --version
# 应该输出：git version 2.x.x
```

**2. 检查 GitHub 连接**
```bash
ssh -T git@github.com
# 应该输出：Hi wcy8822! You've successfully authenticated...
```

**3. 检查 Obsidian 路径**
```bash
ls -la /Users/ixu/Documents/obsidian
# 应该看到你的笔记文件
```

---

## 配置步骤

### 第 1 步：创建 GitHub 仓库

**1. 访问 GitHub**
```
https://github.com/new
```

**2. 填写仓库信息**
```
Repository name: obsidian-notes
Description: Obsidian 笔记库
Visibility: ✅ Private（私有仓库）
✅ 不勾选任何初始化选项
```

**3. 点击 "Create repository"**

---

### 第 2 步：初始化 Git 仓库

**在终端执行：**

```bash
# 进入笔记目录
cd /Users/ixu/Documents/obsidian

# 创建 .gitignore 文件
cat > .gitignore << 'EOF'
# Obsidian 插件和缓存
.obsidian/plugins/
.obsidian/workspace
.obsidian/workspace-mobile
.obsidian/app.json
.obsidian/live-sync/

# 敏感信息文件（根据实际情况调整）
Clippings/ChatGPT-API-信息.md
Inbox/AI/API.md

# macOS
.DS_Store
.AppleDouble
.LSOverride

# 临时文件
*.tmp
*.bak
*~
*.base
未命名*

# 日志文件
livesync_log_*.md
EOF

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 首次提交
git commit -m "Initial: Obsidian 笔记库初始化"

# 添加远程仓库
git remote add origin git@github.com:wcy8822/obsidian-notes.git

# 设置主分支
git branch -M main

# 推送到 GitHub
git push -u origin main
```

---

### 第 3 步：创建备份脚本

**在终端执行：**

```bash
cat > /Users/ixu/Documents/obsidian/backup.sh << 'SCRIPT'
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
SCRIPT

# 添加执行权限
chmod +x /Users/ixu/Documents/obsidian/backup.sh
```

---

### 第 4 步：设置命令别名（可选但推荐）

**在终端执行：**

```bash
# 添加别名到 Shell 配置
echo 'alias obsidian-backup="/Users/ixu/Documents/obsidian/backup.sh"' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc
```

**验证别名：**
```bash
alias obsidian-backup
# 应该输出：alias obsidian-backup='/Users/ixu/Documents/obsidian/backup.sh'
```

---

### 第 5 步：测试备份

**在终端执行：**

```bash
# 使用完整路径
/Users/ixu/Documents/obsidian/backup.sh

# 或使用别名（如果已设置）
obsidian-backup
```

**预期输出：**
```
================================
  Obsidian 笔记备份工具
================================

📦 正在备份...
[main xxxxxxx] backup: 2026-01-16 20:27:53
 X files changed, X insertions(+), X deletions(-)

✅ 备份完成！

最近的备份：
xxxxxxx backup: 2026-01-16 20:27:53
xxxxxxx backup: 2026-01-16 20:22:19
```

---

## 日常使用

### 备份时机

#### 建议备份的时间点

✅ **编辑完重要笔记后**
✅ **每天工作结束时**
✅ **大量修改后**
✅ **删除重要内容前（作为保险）**

#### 不需要备份的情况

❌ 如果没有修改任何笔记（脚本会自动检测）

---

### 使用方法

#### 方法 1: 使用别名（最方便）

```bash
obsidian-backup
```

#### 方法 2: 使用完整路径

```bash
/Users/ixu/Documents/obsidian/backup.sh
```

#### 方法 3: 查看备份状态

```bash
# 查看最近 10 次备份
cd /Users/ixu/Documents/obsidian
git log --oneline -10
```

---

### 查看备份历史

#### 在终端查看

```bash
# 查看最近 5 次备份
cd /Users/ixu/Documents/obsidian
git log --oneline -5

# 查看详细历史
git log --oneline --graph --all
```

#### 在 GitHub 查看

访问：
```
https://github.com/wcy8822/obsidian-notes/commits/main
```

可以看到每次备份的时间戳和更改内容。

---

### 查看当前状态

```bash
cd /Users/ixu/Documents/obsidian
git status
```

**输出说明：**
- `nothing to commit, working tree clean` - 没有未备份的更改
- `Changes not staged for commit` - 有修改但未添加到备份
- `Untracked files` - 有新文件未备份

---

## 故障排查

### 问题 1: 备份失败

#### 症状
```bash
obsidian-backup
# 输出：fatal: unable to access 'https://github.com/...': Could not resolve host
```

#### 解决方法

**检查网络连接：**
```bash
ping github.com
```

**检查 Git 配置：**
```bash
git remote -v
# 应该显示：git@github.com:wcy8822/obsidian-notes.git
```

**检查 SSH 连接：**
```bash
ssh -T git@github.com
# 应该显示：Hi wcy8822! You've successfully authenticated...
```

---

### 问题 2: 推送被拒绝

#### 症状
```bash
git push
# 输出：! [rejected] main -> main (fetch first)
```

#### 解决方法

**先拉取远程更改：**
```bash
cd /Users/ixu/Documents/obsidian
git pull --rebase
git push
```

---

### 问题 3: 敏感信息被误提交

#### 症状
GitHub 检测到 API Key 或密码

#### 解决方法

**从 Git 中删除文件：**
```bash
cd /Users/ixu/Documents/obsidian
git rm --cached "敏感文件路径"
echo "敏感文件路径" >> .gitignore
git add .gitignore
git commit -m "chore: 移除敏感信息"
```

**从历史中完全删除（高级）：**
```bash
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch "敏感文件路径"' \
  --prune-empty --tag-name-filter cat -- --all
git push --force
```

---

### 问题 4: 脚本没有执行权限

#### 症状
```bash
/Users/ixu/Documents/obsidian/backup.sh
# 输出：zsh: permission denied: backup.sh
```

#### 解决方法

```bash
chmod +x /Users/ixu/Documents/obsidian/backup.sh
```

---

## 附录

### A. 完整路径汇总

| 项目 | 路径 |
|------|------|
| Obsidian 笔记库 | `/Users/ixu/Documents/obsidian` |
| 备份脚本 | `/Users/ixu/Documents/obsidian/backup.sh` |
| Git 配置 | `/Users/ixu/Documents/obsidian/.git` |
| 忽略文件 | `/Users/ixu/Documents/obsidian/.gitignore` |
| GitHub 仓库 | `https://github.com/wcy8822/obsidian-notes` |

---

### B. 常用命令速查

```bash
# 备份笔记
obsidian-backup

# 查看最近 5 次备份
cd /Users/ixu/Documents/obsidian && git log --oneline -5

# 查看当前状态
cd /Users/ixu/Documents/obsidian && git status

# 查看文件修改历史
git log --oneline -- README.md

# 恢复单个文件
git checkout <commit-hash> -- README.md

# 回滚整个仓库
git reset --hard <commit-hash>
git push --force
```

---

### C. .gitignore 模板

```gitignore
# Obsidian
.obsidian/plugins/
.obsidian/workspace
.obsidian/workspace-mobile
.obsidian/app.json
.obsidian/live-sync/

# 敏感信息（根据实际情况调整）
Clippings/ChatGPT-API-信息.md
Inbox/AI/API.md

# macOS
.DS_Store
.AppleDouble
.LSOverride

# 临时文件
*.tmp
*.bak
*~
*.base
未命名*

# 日志
livesync_log_*.md

# Python（如果有）
__pycache__/
*.pyc
*.pyo
```

---

### D. 自动备份（可选）

#### 设置定时任务（macOS）

```bash
# 编辑 crontab
crontab -e

# 添加每小时自动备份
0 * * * * /Users/ixu/Documents/obsidian/backup.sh >> /Users/ixu/Documents/obsidian/backup.log 2>&1
```

#### 查看定时任务

```bash
crontab -l
```

#### 删除定时任务

```bash
crontab -e
# 删除对应的行
```

---

### E. 性能优化建议

#### 如果笔记库很大（>100MB）

1. **使用 Git LFS（大文件存储）**
```bash
git lfs install
git lfs track "*.png"
git lfs track "*.pdf"
```

2. **排除不必要的文件夹**
```bash
# 在 .gitignore 中添加
Archive/
Excalidraw/
```

3. **定期清理 Git 历史**
```bash
git gc --aggressive --prune=now
```

---

### F. 相关文档

- **备份脚本使用指南**: `/Users/ixu/Documents/obsidian/BACKUP-GUIDE.md`
- **Obsidian Git 插件配置**: `/Users/ixu/Documents/obsidian/OBSIDIAN-GIT-SETUP.md`
- **GitHub 官方文档**: https://docs.github.com
- **Git 官方文档**: https://git-scm.com/doc

---

### G. 联系与支持

- **GitHub Issues**: https://github.com/wcy8822/obsidian-notes/issues
- **文档更新**: 2026-01-16

---

## ✅ 配置检查清单

完成配置后，请逐项检查：

- [ ] Git 已安装（`git --version`）
- [ ] GitHub 连接正常（`ssh -T git@github.com`）
- [ ] GitHub 仓库已创建
- [ ] Git 仓库已初始化（`git status`）
- [ ] 备份脚本已创建（`ls -la backup.sh`）
- [ ] 脚本有执行权限（`ls -l backup.sh` 显示 -rwxr-xr-x）
- [ ] 别名已设置（`alias obsidian-backup`）
- [ ] 首次备份成功（`obsidian-backup` 测试通过）
- [ ] GitHub 可以看到提交记录
- [ ] .gitignore 已配置

**全部勾选后，系统就可以正常使用了！**

---

## 🎯 快速开始（3 分钟）

```bash
# 1. 进入笔记目录
cd /Users/ixu/Documents/obsidian

# 2. 运行备份
obsidian-backup

# 3. 查看结果
# 应该显示 "✅ 备份完成！"
```

---

**最后更新**: 2026-01-16
**版本**: 1.0
**作者**: wcy8822
