# Obsidian LiveSync 故障排查手册

> 🔧 遇到问题？按照本手册逐步排查，99%的问题都能快速解决！

---

## 📋 快速诊断清单

在开始详细排查前，先运行这个快速检查：

```bash
# 在NAS上执行
cd /volume1/docker/obsidian-sync

# 1. 检查容器状态
docker ps | grep obsidian-livesync

# 2. 检查Tailscale连接
tailscale status

# 3. 检查CouchDB健康状态
curl -s http://localhost:5984/_up

# 4. 测试CouchDB认证
curl -s http://admin:你的密码@localhost:5984/
```

如果以上命令都返回正常，问题可能在客户端配置。

---

## 🚨 常见问题分类

### 问题1：Tailscale连接问题

#### 症状A：`tailscale status`显示"not running"

**原因**：Tailscale服务未启动

**解决方案**：
```bash
# 启动Tailscale服务
sudo systemctl start tailscaled

# 设置开机自启
sudo systemctl enable tailscaled

# 连接到Tailscale网络
tailscale up

# 验证状态
tailscale status
```

#### 症状B：设备列表中看不到NAS

**原因**：NAS未加入Tailscale网络或授权过期

**解决方案**：
```bash
# 重新授权
tailscale up

# 会显示一个授权链接，访问该链接完成授权
# 示例：https://login.tailscale.com/a/xxxxxxxxxxxx

# 授权后验证
tailscale ip -4  # 应该显示100.x.x.x的IP
```

#### 症状C：其他设备ping不通NAS的Tailscale IP

**原因**：防火墙阻止或Tailscale配置问题

**解决方案**：
```bash
# 检查防火墙（UGOS Pro）
iptables -L -n | grep 5984

# 如果没有规则，添加允许规则
iptables -A INPUT -p tcp --dport 5984 -j ACCEPT

# 永久保存规则（UGOS Pro）
iptables-save > /etc/iptables/rules.v4

# 重启Tailscale
sudo systemctl restart tailscaled
```

---

### 问题2：CouchDB容器问题

#### 症状A：容器无法启动

**检查日志**：
```bash
cd /volume1/docker/obsidian-sync
docker-compose logs couchdb
```

**常见错误及解决方案**：

**错误1**：`Permission denied`
```bash
# 修复权限
sudo chown -R 5984:5984 data/ config/
sudo chmod -R 755 data/ config/

# 重启容器
docker-compose restart
```

**错误2**：`Address already in use` (端口冲突)
```bash
# 检查端口占用
netstat -tuln | grep 5984

# 如果端口被占用，修改docker-compose.yml中的端口映射
# 将 "5984:5984" 改为 "5985:5984"
# 然后重启
docker-compose down
docker-compose up -d
```

**错误3**：`invalid reference format`
```bash
# 检查docker-compose.yml格式
# 确保没有制表符（Tab），只使用空格缩进
# 使用以下命令验证格式
docker-compose config

# 如果有错误，会显示具体行号
```

#### 症状B：容器一直重启

**原因**：可能是配置错误或资源不足

**解决方案**：
```bash
# 查看完整日志
docker logs --tail 100 obsidian-livesync

# 检查容器健康状态
docker inspect obsidian-livesync | grep -A 10 Health

# 如果是内存不足，调整docker-compose.yml中的资源限制
# 将memory从512M增加到1G

# 重新部署
docker-compose down
docker-compose up -d
```

#### 症状C：无法访问CouchDB Web界面

**浏览器访问`http://100.x.x.x:5984/_utils`失败**

**排查步骤**：
```bash
# 1. 确认容器运行
docker ps | grep obsidian-livesync

# 2. 确认端口映射
docker port obsidian-livesync
# 应该显示：5984/tcp -> 0.0.0.0:5984

# 3. 本地测试
curl http://localhost:5984/_utils/index.html
# 应该返回HTML内容

# 4. Tailscale IP测试
TAILSCALE_IP=$(tailscale ip -4)
curl http://$TAILSCALE_IP:5984/
# 应该返回：{"couchdb":"Welcome",...}

# 5. 如果本地可以但Tailscale不行，检查防火墙
sudo iptables -I INPUT -i tailscale0 -j ACCEPT
```

---

### 问题3：Obsidian插件连接问题

#### 症状A："Test Connection"失败，错误：Network Error

**原因**：网络不通或URL配置错误

**解决方案**：

**步骤1**：验证Tailscale连接
```bash
# 在客户端设备（Mac/手机）上执行
ping 100.x.x.x  # 替换为NAS的Tailscale IP

# 如果ping不通，检查Tailscale是否在后台运行
# Mac: 顶部菜单栏应该有Tailscale图标
# iOS: 设置→VPN应该显示已连接
# Android: 通知栏应该有Tailscale图标
```

**步骤2**：测试CouchDB可访问性
```bash
# 使用curl测试（Mac终端）
curl http://100.x.x.x:5984/

# 应该返回：
# {"couchdb":"Welcome","version":"3.3.3"}
```

**步骤3**：检查插件配置
```
URI格式检查：
✅ 正确：http://100.64.1.2:5984
❌ 错误：https://100.64.1.2:5984  (不要用https)
❌ 错误：http://100.64.1.2:5984/  (不要加尾部斜杠)
❌ 错误：http://192.168.1.100:5984  (不要用局域网IP)
```

#### 症状B："Test Connection"成功，但"Create Database"失败

**原因**：用户名密码错误或权限不足

**解决方案**：
```bash
# 在NAS上验证密码
cd /volume1/docker/obsidian-sync
cat CONFIG_INFO.txt  # 查看正确的密码

# 手动测试创建数据库
curl -X PUT http://admin:你的密码@localhost:5984/test_db
# 应该返回：{"ok":true}

# 删除测试数据库
curl -X DELETE http://admin:你的密码@localhost:5984/test_db

# 如果密码错误，需要修改docker-compose.yml
# 然后重启容器
docker-compose down
docker-compose up -d
```

#### 症状C：同步很慢或卡住

**原因1**：网络延迟高

**排查**：
```bash
# 检查网络延迟
ping -c 10 $(tailscale ip -4 | xargs echo)

# 如果延迟>200ms，可能需要优化Tailscale
tailscale netcheck  # 查看当前使用的DERP服务器

# 查看Tailscale路由
tailscale status
# 如果显示"relay"表示在用中继，速度会慢
# 如果显示"direct"表示P2P直连，速度最快
```

**原因2**：CouchDB数据库过大

**解决方案**：
```bash
# 压缩数据库（清理旧版本）
curl -X POST http://admin:密码@localhost:5984/obsidian-vault/_compact \
  -H "Content-Type: application/json"

# 查看压缩进度
curl http://admin:密码@localhost:5984/obsidian-vault | jq '.compact_running'

# 压缩完成后，数据库会小很多
```

**原因3**：插件配置不当

**优化配置**：
```json
// 在Obsidian LiveSync设置中调整
{
  "batch_size": 25,  // 从50降低到25
  "savingDelay": 500,  // 从200增加到500ms
  "useIndexedDBAdapter": true  // 启用IndexedDB（性能更好）
}
```

---

### 问题4：同步冲突问题

#### 症状：频繁出现"Conflicted"文件

**原因**：多设备同时编辑同一文件

**预防措施**：
```
1. 启用LiveSync的自动合并功能
   设置 → Self-hosted LiveSync →
   ✅ Merge conflicted files automatically

2. 不要在多设备同时编辑同一笔记
   - 编辑前先等待同步完成（图标变绿）
   - 编辑完成后等待同步完成再切换设备

3. 启用版本历史
   设置 → Self-hosted LiveSync →
   ✅ Keep old revisions
```

**解决冲突**：
```
方法1：使用插件自带的冲突解决器
1. 打开冲突文件（文件名会有.conflicted后缀）
2. 插件会显示对比视图
3. 选择保留哪个版本或手动合并

方法2：手动合并
1. 找到.conflicted文件
2. 比较两个版本的差异
3. 手动合并到主文件
4. 删除.conflicted文件
```

---

### 问题5：移动端特有问题

#### iOS问题

**症状A**：同步断断续续

**原因**：iOS后台限制

**解决方案**：
```
1. 保持Tailscale前台运行
   iOS设置 → Tailscale → 后台App刷新 → 开启

2. 保持Obsidian后台运行
   iOS设置 → Obsidian → 后台App刷新 → 开启

3. 关闭低电量模式
   iOS低电量模式会限制后台网络

4. 使用蜂窝数据
   iOS设置 → Obsidian → 蜂窝数据 → 开启
   （Tailscale流量很小，不用担心）
```

**症状B**：无法连接到NAS

**解决方案**：
```
1. 确认Tailscale已连接
   打开Tailscale app，顶部应该显示"Connected"

2. 确认NAS在线
   在Tailscale app中查看设备列表

3. 测试连接
   iOS Safari浏览器访问：http://100.x.x.x:5984
   应该看到CouchDB欢迎页面

4. 如果还是不行，尝试重启Tailscale
   Tailscale app → Settings → Logout → 重新登录
```

#### Android问题

**症状A**：同步后电量消耗大

**原因**：后台持续同步

**解决方案**：
```
1. 优化电池设置
   设置 → 应用 → Tailscale → 电池 → 无限制
   设置 → 应用 → Obsidian → 电池 → 无限制

2. 调整同步频率
   Obsidian LiveSync设置：
   - 关闭"Sync on save"（保存时同步）
   - 改用定时同步：每5分钟一次

3. 仅WiFi同步（可选）
   Obsidian LiveSync设置：
   ✅ Sync only on WiFi
```

**症状B**：通知栏一直显示Tailscale

**解决方案**：
```
Android设置 → 应用 → Tailscale → 通知 →
关闭"VPN已激活"通知（不影响功能）
```

---

### 问题6：数据安全问题

#### 症状A：担心数据泄露

**加固方案**：
```
1. 启用端到端加密（强烈推荐）
   Obsidian LiveSync设置：
   ✅ Enable encryption
   设置一个强密码（至少20位）

2. 定期备份到GitHub
   安装obsidian-git插件
   每天自动推送到GitHub私有仓库

3. 定期导出NAS数据
   每月备份一次：
   tar -czf backup_$(date +%Y%m%d).tar.gz \
     /volume1/docker/obsidian-sync/data
```

#### 症状B：NAS硬盘故障导致数据丢失

**恢复方案**：
```
前提：有GitHub备份或本地其他设备有完整数据

方法1：从GitHub恢复
1. 在新NAS上重新部署CouchDB
2. 从GitHub克隆仓库
3. 将vault复制到Obsidian
4. 重新配置LiveSync并上传

方法2：从其他设备恢复
1. 在新NAS上重新部署CouchDB
2. 从任一设备（手机/电脑）重新同步
3. LiveSync会自动上传所有数据到新CouchDB
```

---

## 🔍 高级诊断工具

### 工具1：CouchDB日志分析

```bash
# 实时查看CouchDB日志
docker logs -f obsidian-livesync

# 过滤错误日志
docker logs obsidian-livesync 2>&1 | grep -i error

# 保存最近1000行日志到文件
docker logs --tail 1000 obsidian-livesync > couchdb_debug.log
```

### 工具2：网络连通性测试

```bash
# 在NAS上创建测试脚本
cat > /usr/local/bin/test_connectivity.sh << 'EOF'
#!/bin/bash
echo "=== CouchDB连通性测试 ==="
echo "1. 本地访问测试"
curl -s http://localhost:5984/ | jq .

echo -e "\n2. Tailscale IP访问测试"
TAILSCALE_IP=$(tailscale ip -4)
curl -s http://$TAILSCALE_IP:5984/ | jq .

echo -e "\n3. 认证测试"
read -sp "输入CouchDB密码: " PASSWORD
curl -s http://admin:$PASSWORD@localhost:5984/_all_dbs

echo -e "\n\n4. CORS配置检查"
curl -s http://localhost:5984/_node/_local/_config/cors
EOF

chmod +x /usr/local/bin/test_connectivity.sh

# 运行测试
/usr/local/bin/test_connectivity.sh
```

### 工具3：性能监控

```bash
# 查看CouchDB资源占用
docker stats obsidian-livesync

# 查看数据库大小
curl -s http://admin:密码@localhost:5984/obsidian-vault | jq '{doc_count, disk_size, data_size}'

# 查看活跃连接数
netstat -an | grep :5984 | wc -l
```

---

## 📞 获取帮助

### 自助资源

1. **官方文档**
   - LiveSync: https://github.com/vrtmrz/obsidian-livesync
   - CouchDB: https://docs.couchdb.org
   - Tailscale: https://tailscale.com/kb

2. **社区论坛**
   - Obsidian中文论坛: https://forum-zh.obsidian.md
   - Reddit: r/ObsidianMD
   - Discord: Obsidian官方Discord

3. **日志收集**（提问时请提供）
   ```bash
   # 收集诊断信息
   cd /volume1/docker/obsidian-sync

   # 创建诊断包
   tar -czf diagnosis_$(date +%Y%m%d_%H%M%S).tar.gz \
     docker-compose.yml \
     init.ini \
     CONFIG_INFO.txt \
     <(docker logs --tail 500 obsidian-livesync) \
     <(tailscale status) \
     <(curl -s http://localhost:5984/)

   # 下载该文件并在提问时附上
   ```

---

## ✅ 预防性维护清单

### 每周检查
- [ ] 查看容器运行状态：`docker ps`
- [ ] 检查磁盘空间：`df -h`
- [ ] 检查Tailscale连接：`tailscale status`
- [ ] 测试同步速度：创建测试笔记并观察同步时间

### 每月维护
- [ ] 压缩CouchDB数据库（释放空间）
- [ ] 备份data目录到外部存储
- [ ] 检查是否有软件更新（CouchDB/Tailscale）
- [ ] 查看错误日志并处理

### 季度审查
- [ ] 评估同步性能，必要时调整配置
- [ ] 清理过期备份
- [ ] 更新文档和密码（如有需要）
- [ ] 测试灾难恢复流程

---

**最后更新**：2025-09-30
**版本**：v1.0
**维护者**：Claude Code

如果本手册未能解决你的问题，请查看README.md中的联系方式获取帮助。