# 🚀 快速上手指南

> 30分钟完成Obsidian LiveSync部署！

---

## 📦 文件清单

确认你已下载以下所有文件：

```
obsidian-sync-setup/
├── README.md                              # 完整文档（详细指南）
├── QUICKSTART.md                          # 本文件（快速上手）
├── TROUBLESHOOTING.md                     # 故障排查手册
├── docker-compose.yml                     # CouchDB容器配置
├── init.ini                               # CouchDB初始化配置
├── setup_nas.sh                           # 一键部署脚本（可执行）
├── monitor.sh                             # 监控脚本（可执行）
└── obsidian-livesync-config-template.json # Obsidian插件配置模板
```

---

## ⏱️ 30分钟部署流程

### 阶段1：NAS部署（15分钟）

#### Step 1: 上传文件到NAS（2分钟）

```bash
# 方法1：使用scp上传
scp -r obsidian-sync-setup root@你的NAS_IP:/volume1/docker/

# 方法2：使用绿联云文件管理器
# 在Web界面上传整个文件夹到 /volume1/docker/
```

#### Step 2: SSH连接到NAS（1分钟）

```bash
ssh root@你的NAS_IP -p 922
# 输入密码后登录
```

#### Step 3: 运行一键部署脚本（12分钟）

```bash
cd /volume1/docker/obsidian-sync-setup
sudo bash setup_nas.sh
```

脚本会自动完成：
- ✅ 检查系统环境
- ✅ 安装Tailscale
- ✅ 获取Tailscale IP（记录下来！）
- ✅ 设置CouchDB密码（需要你输入）
- ✅ 部署CouchDB容器
- ✅ 初始化配置
- ✅ 生成CONFIG_INFO.txt

**重要**：
1. 脚本会提示你访问Tailscale授权链接，复制链接到浏览器完成授权
2. 记录下Tailscale IP（格式：100.x.x.x）
3. 设置一个强密码并记住（至少16位）

---

### 阶段2：客户端配置（10分钟）

#### Step 4: 安装Tailscale到所有设备（5分钟）

**Mac:**
```bash
brew install --cask tailscale
# 打开Tailscale并登录（使用与NAS相同的账号）
```

**iPhone/iPad:**
```
App Store → 搜索"Tailscale" → 安装 → 登录
```

**Android:**
```
Google Play → 搜索"Tailscale" → 安装 → 登录
```

**验证连接:**
```bash
# 在任意设备终端执行（Mac/Linux）
ping 100.x.x.x  # 替换为NAS的Tailscale IP

# 或在浏览器访问
http://100.x.x.x:5984/_utils
# 应该看到CouchDB管理界面
```

#### Step 5: 配置Obsidian插件（5分钟）

**1. 安装插件**
```
Obsidian设置 → 社区插件 → 浏览 → 搜索"Self-hosted LiveSync"
→ 安装 → 启用
```

**2. 配置连接**
```
插件设置 → Remote Database Configuration:
  URI: http://100.x.x.x:5984  ← 替换为你的NAS Tailscale IP
  Username: admin
  Password: 你设置的CouchDB密码
  Database name: obsidian-vault
```

**3. 测试连接**
```
点击"Test Database Connection"
→ 显示"✅ Connected"
→ 点击"Create Database"
→ 显示"Database created"
```

**4. 启用加密（可选但推荐）**
```
插件设置 → Encryption:
  ✅ Enable End-to-End Encryption
  Passphrase: 设置一个新密码（至少20位）
  Passphrase (verify): 再次输入
```

**5. 初始化同步**
```
首台设备:
  点击"Replicate" → "Replicate to remote" → 等待完成

其他设备:
  点击"Replicate" → "Replicate from remote" → 等待完成
```

---

### 阶段3：验证测试（5分钟）

#### Step 6: 测试实时同步

```
1. 在桌面端创建新笔记：测试同步.md
2. 输入内容并保存
3. 观察LiveSync图标（应该在2秒内变绿✅）
4. 在手机端打开Obsidian
5. 应该立即看到新笔记
```

**成功标志：**
- ✅ 所有设备都能看到最新内容
- ✅ LiveSync图标为绿色
- ✅ 修改能在2秒内同步到其他设备

---

## 🎯 配置速查表

### NAS配置信息

**查看配置信息：**
```bash
cd /volume1/docker/obsidian-sync-setup
cat CONFIG_INFO.txt
```

**常用管理命令：**
```bash
# 查看容器状态
docker ps | grep obsidian

# 查看日志
docker logs obsidian-livesync

# 重启服务
cd /volume1/docker/obsidian-sync-setup
docker-compose restart

# 停止服务
docker-compose down

# 启动服务
docker-compose up -d
```

### Obsidian插件配置

**最小配置（必填）：**
```yaml
URI: http://100.x.x.x:5984
Username: admin
Password: 你的密码
Database: obsidian-vault
```

**推荐配置：**
```yaml
Sync Settings:
  ✅ LiveSync enabled
  ✅ Sync on Save
  ✅ Sync on Start

Encryption:
  ✅ Enable E2E Encryption
  Passphrase: 你的加密密码

Advanced:
  batch_size: 50
  ✅ Use IndexedDB Adapter
```

---

## ❗ 常见错误速查

| 错误信息 | 原因 | 解决方案 |
|---------|------|---------|
| `Network Error` | Tailscale未连接 | 检查Tailscale是否运行 |
| `Unauthorized` | 密码错误 | 检查CONFIG_INFO.txt中的密码 |
| `Database not found` | 未创建数据库 | 点击"Create Database" |
| `Connection timeout` | 防火墙阻止 | 检查NAS防火墙设置 |
| `Sync very slow` | 批处理太大 | 降低batch_size到25 |

**万能修复命令：**
```bash
# 在NAS上执行
cd /volume1/docker/obsidian-sync-setup
docker-compose restart
tailscale up
```

---

## 📱 移动端特别注意

### iOS设置

**必须开启：**
```
iOS设置 → Obsidian → 后台App刷新 → 开启
iOS设置 → Tailscale → 后台App刷新 → 开启
```

### Android设置

**必须设置：**
```
设置 → 应用 → Obsidian → 电池 → 无限制
设置 → 应用 → Tailscale → 电池 → 无限制
```

---

## 🆘 求助清单

**如果遇到问题，按以下顺序排查：**

### 1. 检查基础连接

```bash
# 在NAS上执行
docker ps | grep obsidian-livesync  # 容器是否运行？
tailscale status                    # Tailscale是否连接？
curl http://localhost:5984/         # CouchDB是否响应？
```

### 2. 检查客户端连接

```bash
# 在客户端设备执行（Mac/Linux）
ping 100.x.x.x                      # 能ping通NAS吗？
curl http://100.x.x.x:5984/         # 能访问CouchDB吗？
```

### 3. 查看详细日志

```bash
# 在NAS上执行
docker logs --tail 100 obsidian-livesync

# 查找错误
docker logs obsidian-livesync 2>&1 | grep -i error
```

### 4. 使用监控脚本

```bash
cd /volume1/docker/obsidian-sync-setup
./monitor.sh -s  # 快速健康检查
```

### 5. 查看完整故障排查

如果以上都无法解决，请查看：[TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 📚 下一步

### 完成部署后

- ✅ **设置GitHub备份**：参考README.md中的"配置GitHub自动备份"
- ✅ **性能优化**：根据使用情况调整插件配置
- ✅ **定期维护**：每月压缩数据库，备份数据

### 学习更多

- **完整文档**：[README.md](README.md)
- **故障排查**：[TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **监控工具**：`./monitor.sh --help`

---

## ✅ 部署完成检查清单

完成以下所有项目说明部署成功：

**NAS端：**
- [ ] Tailscale已安装并连接
- [ ] CouchDB容器正常运行
- [ ] 能访问 http://localhost:5984/_utils
- [ ] CONFIG_INFO.txt已生成

**客户端：**
- [ ] 所有设备安装了Tailscale并连接
- [ ] 能访问 http://100.x.x.x:5984/_utils
- [ ] Obsidian安装了LiveSync插件
- [ ] 插件连接测试成功
- [ ] 数据库已创建

**同步测试：**
- [ ] 桌面端创建笔记能同步到手机
- [ ] 手机端修改能同步到桌面
- [ ] LiveSync图标为绿色✅
- [ ] 同步延迟<2秒

---

**🎉 恭喜！你已成功完成Obsidian LiveSync部署！**

现在你拥有：
- ✅ 毫秒级实时同步
- ✅ 完全免费的方案
- ✅ 数据完全掌控
- ✅ 企业级稳定性

享受你的知识管理之旅吧！ 📝

---

**需要帮助？**
- 详细文档：[README.md](README.md)
- 故障排查：[TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- 健康检查：`./monitor.sh`