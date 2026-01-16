# Obsidian 笔记备份使用指南

> 一键备份脚本 - 无需任何插件

## 🚀 使用方法

### 方法 1: 终端命令（推荐）

**复制粘贴这个命令到终端：**
```bash
/Users/ixu/Documents/obsidian/backup.sh
```

### 方法 2: 创建别名（更方便）

**在终端运行一次：**
```bash
echo 'alias obsidian-backup="/Users/ixu/Documents/obsidian/backup.sh"' >> ~/.zshrc
source ~/.zshrc
```

**以后只需要输入：**
```bash
obsidian-backup
```

### 方法 3: 在 VSCode 中

打开终端（`Ctrl + ~` 或 `Cmd + ~`），然后输入：
```bash
/Users/ixu/Documents/obsidian/backup.sh
```

---

## 📋 备份时机建议

### 何时备份

- ✅ 编辑完重要笔记后
- ✅ 每天工作结束时
- ✅ 大量修改后
- ✅ 删除重要内容前（作为备份）

### 不需要备份的情况

- ❌ 如果没有修改任何笔记
- ❌ 脚本会自动检测并提示

---

## 💡 实际使用示例

### 示例 1: 刚写完一篇笔记

```bash
# 在终端运行
/Users/ixu/Documents/obsidian/backup.sh

# 输出：
# ================================================
#   Obsidian 笔记备份工具
# ================================================
#
# 📦 正在备份...
#
# ✅ 备份完成！
#
# 最近的备份：
# df9dec2 backup: 2026-01-16 20:27:53
# 993d911 backup: 2026-01-16 20:22:19
```

### 示例 2: 没有修改时运行

```bash
/Users/ixu/Documents/obsidian/backup.sh

# 输出：
# ✅ 没有需要备份的更改
#
# 最近的备份：
# df9dec2 backup: 2026-01-16 20:27:53
```

---

## 🔙 查看备份历史

### 查看最近 10 次备份

```bash
cd /Users/ixu/Documents/obsidian
git log --oneline -10
```

### 在 GitHub 查看

访问：
```
https://github.com/wcy8822/obsidian-notes/commits/main
```

---

## 📊 备份状态

### 查看当前状态

```bash
cd /Users/ixu/Documents/obsidian
git status
```

### 查看有哪些文件被修改

```bash
cd /Users/ixu/Documents/obsidian
git diff --name-only
```

---

## 🎯 快速参考

### 最常用的命令

```bash
# 备份笔记
/Users/ixu/Documents/obsidian/backup.sh

# 查看备份历史
cd /Users/ixu/Documents/obsidian && git log --oneline -5

# 查看当前状态
cd /Users/ixu/Documents/obsidian && git status
```

---

## ⚠️ 常见问题

### Q1: 备份失败怎么办？

**检查网络连接：**
```bash
ssh -T git@github.com
```

**手动重试：**
```bash
cd /Users/ixu/Documents/obsidian
git push
```

### Q2: 如何恢复旧版本？

**查看历史：**
```bash
cd /Users/ixu/Documents/obsidian
git log --oneline -10
```

**恢复单个文件：**
```bash
git checkout <commit-hash> -- 文件路径.md
```

**恢复整个仓库：**
```bash
git reset --hard <commit-hash>
git push --force
```

### Q3: 会备份敏感信息吗？

**不会。** 以下文件已被排除：
- `Clippings/ChatGPT-API-信息.md`
- `Inbox/AI/API.md`
- `.obsidian/plugins/`
- `.obsidian/workspace`
- 临时文件

---

## 📁 相关文件

- **备份脚本**: `/Users/ixu/Documents/obsidian/backup.sh`
- **配置指南**: `/Users/ixu/Documents/obsidian/OBSIDIAN-GIT-SETUP.md`
- **GitHub 仓库**: https://github.com/wcy8822/obsidian-notes

---

## ✅ 总结

**记住一个命令就够了：**

```bash
/Users/ixu/Documents/obsidian/backup.sh
```

**或者设置别名后：**

```bash
obsidian-backup
```

---

**最后更新**: 2026-01-16
**备份状态**: ✅ 正常运行
