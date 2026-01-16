# 🚀 专属部署指南 - didi

> ✨ 我已经根据你的信息生成了一键部署脚本！你只需要3步操作。

---

## 📋 你的配置信息（已预填）

```yaml
NAS IP: 192.168.5.200（已修正）
SSH端口: 22
Vault路径: /Users/didi/Downloads/panth/sync/obsidian
CouchDB密码: K9#mL2$vN8@pQ4!x
加密: 不启用
需要同步的设备: Mac + iPad + Android + Windows
```

---

## 🎯 超级简单的3步部署

### 第1步：打开终端（2分钟）

**在Mac上操作：**

1. 按 `Command + 空格`
2. 输入 `terminal` 并按回车
3. 会打开一个黑色或白色的窗口（这就是终端）

### 第2步：运行部署脚本（12分钟）

**在终端中复制粘贴以下命令：**

```bash
cd /Users/didi/Downloads/panth/sync/obsidian/obsidian-sync-setup
bash deploy_didi.sh
```

**然后按回车键**

**脚本会自动完成：**
- ✅ 连接到你的NAS
- ✅ 上传所有需要的文件
- ✅ 安装Tailscale
- ✅ 部署CouchDB数据库
- ✅ 生成所有配置文件

**你只需要做1件事：**
当脚本提示你授权Tailscale时：
1. 复制显示的链接
2. 粘贴到浏览器打开
3. 用你的GitHub账号登录并授权
4. 回到终端按Enter

### 第3步：配置Obsidian（5分钟）

脚本完成后会自动打开配置指南，按照指南操作即可。

---

## 🔍 详细操作（带截图说明）

### 第1步详解：打开终端

```
1. 键盘按 Command(⌘) + 空格键
   → 会弹出Spotlight搜索框

2. 输入：terminal
   → 第一个结果应该是"终端.app"或"Terminal"

3. 按Enter键
   → 打开终端窗口
```

**长什么样？**
```
终端窗口会显示：
Last login: ...
didi@MacBook ~ %  ← 这是命令提示符
```

### 第2步详解：运行脚本

**复制第一条命令：**
```bash
cd /Users/didi/Downloads/panth/sync/obsidian/obsidian-sync-setup
```

**粘贴到终端：**
- 方法1：右键点击终端窗口 → 选择"粘贴"
- 方法2：按 Command + V

**按Enter键**

**复制第二条命令：**
```bash
bash deploy_didi.sh
```

**粘贴并按Enter**

### 第3步详解：授权Tailscale

当你看到类似这样的提示：
```
╔════════════════════════════════════════════════════╗
║  📱 需要你授权Tailscale                            ║
╚════════════════════════════════════════════════════╝

请复制以下链接到浏览器打开：
https://login.tailscale.com/a/xxxxxxxxxxxx

授权完成后按Enter继续...
```

**操作：**
1. 选中链接（鼠标拖动选中）
2. 按 Command + C 复制
3. 打开Safari浏览器
4. 在地址栏按 Command + V 粘贴
5. 按Enter访问
6. 用你的GitHub账号登录（wcy8822）
7. 点击"Authorize"授权
8. 回到终端，按Enter键

**然后等待脚本自动完成！**

---

## 🎉 脚本完成后

### 你会看到：

```
╔════════════════════════════════════════════════════╗
║           🎉 部署完成！                             ║
╚════════════════════════════════════════════════════╝

✅ NAS配置完成
✅ CouchDB运行正常
✅ Tailscale连接成功

📋 重要信息：
  Tailscale IP: 100.x.x.x
  CouchDB密码: K9#mL2$vN8@pQ4!x
  配置文件位置: /Users/didi/Downloads/panth/sync/obsidian/obsidian-sync-setup
```

### 自动打开的文件：

脚本会自动打开 `DEVICE_SETUP.md`，里面有每个设备的详细配置步骤。

---

## 📱 接下来配置设备

### Mac（你的主设备）

**1. 安装Tailscale（3分钟）**

在终端执行：
```bash
brew install --cask tailscale
```

安装完成后：
- 菜单栏会出现Tailscale图标
- 点击图标 → Sign in
- 用GitHub账号登录

**2. 配置Obsidian（5分钟）**

```
1. 打开Obsidian
2. 设置（齿轮图标）→ 社区插件
3. 点击"浏览"
4. 搜索"Self-hosted LiveSync"
5. 点击"安装"
6. 点击"启用"

7. 设置 → Self-hosted LiveSync
8. 填写以下信息：
   URI: http://[Tailscale IP]:5984  ← 从终端输出复制
   Username: admin
   Password: K9#mL2$vN8@pQ4!x
   Database: obsidian-vault

9. 点击"Test Database Connection"
   → 应该显示"✅ Connected"

10. 点击"Create Database"
    → 显示"Database created successfully"

11. 点击"Replicate" → "Replicate to remote"
    → 等待进度条完成（上传你的笔记）

12. 完成！LiveSync图标应该变成绿色✅
```

### iPad配置（5分钟）

**1. 安装Tailscale**
```
App Store → 搜索"Tailscale" → 安装
打开 → 用GitHub账号登录
允许添加VPN配置
```

**2. 配置Obsidian**
```
与Mac相同的步骤
但是：第11步选择"Replicate from remote"（从服务器下载）
```

**3. 系统设置**
```
iPad设置 → Obsidian → 后台App刷新 → 开启
iPad设置 → Tailscale → 后台App刷新 → 开启
```

### Android配置（5分钟）

与iPad类似，但系统设置改为：
```
设置 → 应用 → Obsidian → 电池 → 无限制
设置 → 应用 → Tailscale → 电池 → 无限制
```

### Windows配置（5分钟）

**1. 安装Tailscale**
```
浏览器访问：https://tailscale.com/download/windows
下载并安装
用GitHub账号登录
```

**2. 配置Obsidian**（与Mac相同）

---

## 🧪 测试同步

**在Mac上：**
1. 创建新笔记："测试同步.md"
2. 写入："这是测试，时间：[当前时间]"
3. 保存

**在iPad/手机上：**
1. 等待2秒
2. 应该能看到新笔记出现

**成功标志：**
- ✅ 所有设备LiveSync图标为绿色
- ✅ 修改能在2秒内同步
- ✅ 没有冲突文件

---

## ❓ 如果遇到问题

### 问题1：终端显示"Permission denied"

**解决方案：**
```bash
# 在命令前加sudo
sudo bash deploy_didi.sh
# 输入Mac的登录密码
```

### 问题2：无法连接到NAS

**检查清单：**
```
□ NAS是否开机？
□ Mac和NAS在同一WiFi网络？
□ NAS IP是否是 192.168.5.200？
□ 能ping通NAS吗？（终端执行：ping 192.168.5.200）
```

### 问题3：Tailscale授权失败

**解决方案：**
```
1. 确认使用的是GitHub账号 wcy8822
2. 如果链接打不开，重新运行脚本
3. 或者手动在NAS上执行：tailscale up
```

### 问题4：Obsidian连接失败

**检查：**
```
1. Tailscale是否在Mac上运行？（菜单栏有图标）
2. URI中的IP是否正确？（应该是100.x.x.x）
3. 密码是否正确？（K9#mL2$vN8@pQ4!x）
4. 用浏览器访问 http://[Tailscale IP]:5984/_utils
   能看到CouchDB界面吗？
```

### 更多问题？

查看完整故障排查手册：
```bash
open /Users/didi/Downloads/panth/sync/obsidian/obsidian-sync-setup/TROUBLESHOOTING.md
```

或运行监控脚本：
```bash
cd /Users/didi/Downloads/panth/sync/obsidian/obsidian-sync-setup
./monitor.sh -s
```

---

## 📞 需要帮助

如果实在搞不定，告诉我：
1. 你在哪一步卡住了
2. 终端显示的错误信息是什么
3. 截图发给我

我会继续帮你！

---

## ✅ 完成后的检查清单

**NAS端：**
- [ ] 脚本运行成功
- [ ] Tailscale已连接
- [ ] CouchDB容器运行中
- [ ] 能访问 http://192.168.5.200:5984/_utils

**Mac端：**
- [ ] Tailscale已安装并连接
- [ ] Obsidian插件配置成功
- [ ] 测试连接成功（绿色✅）
- [ ] 数据库已创建
- [ ] 笔记已上传到服务器

**其他设备：**
- [ ] Tailscale已安装并连接
- [ ] Obsidian已配置
- [ ] 能同步Mac上的笔记

**同步测试：**
- [ ] Mac修改→其他设备能看到（<2秒）
- [ ] 其他设备修改→Mac能看到（<2秒）
- [ ] 所有设备LiveSync图标为绿色✅

---

**🎉 全部完成后，你就拥有了一个完全免费、毫秒级同步的Obsidian系统！**

**年度成本：约¥30（NAS电费）vs 官方Sync $96/年**

享受你的知识管理之旅吧！ 📝✨

---

**现在就开始吧！打开终端，运行脚本！**

```bash
cd /Users/didi/Downloads/panth/sync/obsidian/obsidian-sync-setup
bash deploy_didi.sh
```