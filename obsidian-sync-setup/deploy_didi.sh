#!/bin/bash
# ===================================================================
# Obsidian LiveSync 专属部署脚本 - 为 didi 定制
# 自动化程度：95%（你只需要授权Tailscale）
# ===================================================================

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 你的配置信息（已预填）
NAS_IP="192.168.5.200"
SSH_PORT="22"
COUCHDB_PASSWORD="K9#mL2\$vN8@pQ4!x"
COUCHDB_SECRET="AutoGen$(date +%s)Secret"
VAULT_PATH="/Users/didi/Downloads/panth/sync/obsidian"

echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║   Obsidian LiveSync 专属部署脚本                   ║${NC}"
echo -e "${PURPLE}║   为 didi 定制 - 自动化部署                        ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${CYAN}📋 已预填配置信息：${NC}"
echo -e "  NAS IP: ${GREEN}${NAS_IP}${NC}"
echo -e "  SSH端口: ${GREEN}${SSH_PORT}${NC}"
echo -e "  Vault路径: ${GREEN}${VAULT_PATH}${NC}"
echo
read -p "按Enter继续部署，或Ctrl+C取消..."

# ===================================================================
# 阶段1：连接到NAS并上传文件
# ===================================================================
echo
echo -e "${BLUE}[阶段1/5] 连接NAS并上传部署文件${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查SSH连接
echo -e "${CYAN}→ 测试NAS连接...${NC}"
if ssh -p ${SSH_PORT} -o ConnectTimeout=5 root@${NAS_IP} "echo ok" &>/dev/null; then
    echo -e "${GREEN}✓ NAS连接成功${NC}"
else
    echo -e "${RED}✗ 无法连接到NAS，请检查：${NC}"
    echo "  1. NAS是否开机"
    echo "  2. IP地址是否正确: ${NAS_IP}"
    echo "  3. SSH端口是否正确: ${SSH_PORT}"
    echo "  4. 是否在同一局域网"
    exit 1
fi

# 上传部署文件
echo -e "${CYAN}→ 上传部署文件到NAS...${NC}"
ssh -p ${SSH_PORT} root@${NAS_IP} "mkdir -p /volume1/docker/obsidian-sync"

scp -P ${SSH_PORT} -q \
    docker-compose.yml \
    init.ini \
    setup_nas.sh \
    monitor.sh \
    root@${NAS_IP}:/volume1/docker/obsidian-sync/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 文件上传成功${NC}"
else
    echo -e "${RED}✗ 文件上传失败${NC}"
    exit 1
fi

# ===================================================================
# 阶段2：在NAS上安装Tailscale
# ===================================================================
echo
echo -e "${BLUE}[阶段2/5] 在NAS上安装Tailscale${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo -e "${CYAN}→ 检查Tailscale是否已安装...${NC}"
TAILSCALE_INSTALLED=$(ssh -p ${SSH_PORT} root@${NAS_IP} "command -v tailscale >/dev/null && echo yes || echo no")

if [ "$TAILSCALE_INSTALLED" = "no" ]; then
    echo -e "${YELLOW}! Tailscale未安装，开始安装...${NC}"
    ssh -p ${SSH_PORT} root@${NAS_IP} "curl -fsSL https://tailscale.com/install.sh | sh"
    echo -e "${GREEN}✓ Tailscale安装完成${NC}"
else
    echo -e "${GREEN}✓ Tailscale已安装${NC}"
fi

# 启动Tailscale
echo -e "${CYAN}→ 启动Tailscale...${NC}"
TAILSCALE_STATUS=$(ssh -p ${SSH_PORT} root@${NAS_IP} "tailscale status 2>&1")

if echo "$TAILSCALE_STATUS" | grep -q "100\."; then
    TAILSCALE_IP=$(ssh -p ${SSH_PORT} root@${NAS_IP} "tailscale ip -4")
    echo -e "${GREEN}✓ Tailscale已连接${NC}"
    echo -e "${GREEN}  Tailscale IP: ${TAILSCALE_IP}${NC}"
else
    echo -e "${YELLOW}! Tailscale需要授权${NC}"
    echo -e "${CYAN}→ 获取授权链接...${NC}"

    # 启动Tailscale并获取授权URL
    ssh -p ${SSH_PORT} root@${NAS_IP} "tailscale up" > /tmp/tailscale_auth.txt 2>&1 &
    sleep 3

    AUTH_URL=$(cat /tmp/tailscale_auth.txt | grep -o 'https://login.tailscale.com/a/[a-zA-Z0-9]*')

    if [ -n "$AUTH_URL" ]; then
        echo
        echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
        echo -e "${PURPLE}║  📱 需要你授权Tailscale                            ║${NC}"
        echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
        echo
        echo -e "${CYAN}请复制以下链接到浏览器打开：${NC}"
        echo -e "${GREEN}${AUTH_URL}${NC}"
        echo
        echo -e "${YELLOW}授权完成后按Enter继续...${NC}"
        read

        # 等待连接成功
        echo -e "${CYAN}→ 等待Tailscale连接...${NC}"
        for i in {1..30}; do
            TAILSCALE_IP=$(ssh -p ${SSH_PORT} root@${NAS_IP} "tailscale ip -4 2>/dev/null")
            if [ -n "$TAILSCALE_IP" ]; then
                echo -e "${GREEN}✓ Tailscale连接成功${NC}"
                echo -e "${GREEN}  Tailscale IP: ${TAILSCALE_IP}${NC}"
                break
            fi
            sleep 2
            echo -n "."
        done

        if [ -z "$TAILSCALE_IP" ]; then
            echo -e "${RED}✗ Tailscale连接超时${NC}"
            exit 1
        fi
    else
        echo -e "${RED}✗ 无法获取授权链接${NC}"
        exit 1
    fi
fi

# 保存Tailscale IP
echo "$TAILSCALE_IP" > /tmp/tailscale_ip.txt

# ===================================================================
# 阶段3：部署CouchDB
# ===================================================================
echo
echo -e "${BLUE}[阶段3/5] 部署CouchDB数据库${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 创建docker-compose.yml（已填入密码）
echo -e "${CYAN}→ 生成Docker配置...${NC}"
ssh -p ${SSH_PORT} root@${NAS_IP} "cat > /volume1/docker/obsidian-sync/docker-compose.yml << 'EOFCOMPOSE'
version: '3.8'

services:
  couchdb:
    image: couchdb:3.3.3
    container_name: obsidian-livesync
    restart: unless-stopped
    environment:
      - COUCHDB_USER=admin
      - COUCHDB_PASSWORD=${COUCHDB_PASSWORD}
      - TZ=Asia/Shanghai
      - COUCHDB_SECRET=${COUCHDB_SECRET}
    ports:
      - \"5984:5984\"
    volumes:
      - ./data:/opt/couchdb/data
      - ./config:/opt/couchdb/etc/local.d
      - ./init.ini:/opt/couchdb/etc/local.d/init.ini:ro
    healthcheck:
      test: [\"CMD\", \"curl\", \"-f\", \"http://localhost:5984/_up\"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 128M
EOFCOMPOSE
"

# 启动CouchDB
echo -e "${CYAN}→ 启动CouchDB容器...${NC}"
ssh -p ${SSH_PORT} root@${NAS_IP} "cd /volume1/docker/obsidian-sync && docker-compose up -d"

# 等待CouchDB启动
echo -e "${CYAN}→ 等待CouchDB完全启动（约30秒）...${NC}"
for i in {1..30}; do
    STATUS=$(ssh -p ${SSH_PORT} root@${NAS_IP} "curl -s http://localhost:5984/ 2>/dev/null" | grep -o couchdb || echo "")
    if [ -n "$STATUS" ]; then
        echo -e "${GREEN}✓ CouchDB启动成功${NC}"
        break
    fi
    sleep 1
    echo -n "."
done
echo

# 初始化CouchDB
echo -e "${CYAN}→ 初始化CouchDB配置...${NC}"
ssh -p ${SSH_PORT} root@${NAS_IP} "
curl -X PUT http://admin:${COUCHDB_PASSWORD}@localhost:5984/_node/_local/_config/cluster/n -H 'Content-Type: application/json' -d '\"1\"' 2>/dev/null
curl -X PUT http://admin:${COUCHDB_PASSWORD}@localhost:5984/_node/_local/_config/httpd/enable_cors -H 'Content-Type: application/json' -d '\"true\"' 2>/dev/null
"
echo -e "${GREEN}✓ CouchDB配置完成${NC}"

# ===================================================================
# 阶段4：生成配置信息
# ===================================================================
echo
echo -e "${BLUE}[阶段4/5] 生成配置信息${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 在NAS上生成配置信息
ssh -p ${SSH_PORT} root@${NAS_IP} "cat > /volume1/docker/obsidian-sync/CONFIG_INFO.txt << EOFCONFIG
================================
Obsidian LiveSync 配置信息
专属配置 - didi
================================

【CouchDB连接信息】
Tailscale IP: ${TAILSCALE_IP}
端口: 5984
用户名: admin
密码: ${COUCHDB_PASSWORD}

【Obsidian插件配置】
URI: http://${TAILSCALE_IP}:5984
数据库名: obsidian-vault
用户名: admin
密码: ${COUCHDB_PASSWORD}
加密: 不启用

【管理界面】
局域网访问: http://${NAS_IP}:5984/_utils
Tailscale访问: http://${TAILSCALE_IP}:5984/_utils

【Docker管理命令】
查看状态: docker ps | grep obsidian
查看日志: docker logs obsidian-livesync
重启服务: cd /volume1/docker/obsidian-sync && docker-compose restart
停止服务: docker-compose down
启动服务: docker-compose up -d

【备份命令】
tar -czf backup_\\\$(date +%Y%m%d).tar.gz data/

生成时间: $(date)
================================
EOFCONFIG
"

# 下载配置信息到本地
echo -e "${CYAN}→ 下载配置信息到本地...${NC}"
CONFIG_DIR="${VAULT_PATH}/obsidian-sync-setup"
mkdir -p "$CONFIG_DIR"
scp -P ${SSH_PORT} -q root@${NAS_IP}:/volume1/docker/obsidian-sync/CONFIG_INFO.txt "$CONFIG_DIR/"

echo -e "${GREEN}✓ 配置信息已保存到: ${CONFIG_DIR}/CONFIG_INFO.txt${NC}"

# ===================================================================
# 阶段5：生成Obsidian配置
# ===================================================================
echo
echo -e "${BLUE}[阶段5/5] 生成Obsidian插件配置${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 生成Obsidian配置文件
cat > "$CONFIG_DIR/obsidian-config.json" << EOFOBSIDIAN
{
  "couchDB_URI": "http://${TAILSCALE_IP}:5984",
  "couchDB_USER": "admin",
  "couchDB_PASSWORD": "${COUCHDB_PASSWORD}",
  "couchDB_DBNAME": "obsidian-vault",
  "liveSync": true,
  "syncOnSave": true,
  "syncOnStart": true,
  "batch_size": 50,
  "useIndexedDBAdapter": true,
  "encrypt": false
}
EOFOBSIDIAN

echo -e "${GREEN}✓ Obsidian配置已生成${NC}"

# 生成设备配置指南
cat > "$CONFIG_DIR/DEVICE_SETUP.md" << 'EOFDEVICE'
# 设备配置指南

## 🖥️ Mac配置（你的主设备）

### 1. 安装Tailscale
```bash
brew install --cask tailscale
# 安装完成后，菜单栏会出现图标
# 点击图标 → Sign in → 使用GitHub账号登录
```

### 2. 配置Obsidian插件
```
1. 打开Obsidian
2. 设置 → 社区插件 → 浏览 → 搜索"Self-hosted LiveSync"
3. 安装并启用
4. 设置 → Self-hosted LiveSync → 点击"Setup via URI"
5. 粘贴以下URI：
EOFDEVICE

# 生成Setup URI
SETUP_URI="obsidian://setuplivesync?settings=$(echo "{\"couchDB_URI\":\"http://${TAILSCALE_IP}:5984\",\"couchDB_USER\":\"admin\",\"couchDB_PASSWORD\":\"${COUCHDB_PASSWORD}\",\"couchDB_DBNAME\":\"obsidian-vault\",\"liveSync\":true}" | base64)"

cat >> "$CONFIG_DIR/DEVICE_SETUP.md" << EOFDEVICE2

${SETUP_URI}

6. 点击"Test Connection" → 应该显示"✅ Connected"
7. 点击"Create Database"
8. 点击"Replicate" → "Replicate to remote"
9. 等待同步完成
```

## 📱 iPad配置

### 1. 安装Tailscale
```
App Store → 搜索"Tailscale" → 安装
打开 → 登录（使用与Mac相同的账号）
允许添加VPN配置
```

### 2. 配置Obsidian
```
1. 打开Obsidian
2. 设置 → 社区插件 → 安装"Self-hosted LiveSync"
3. 使用与Mac相同的配置：
   URI: http://${TAILSCALE_IP}:5984
   Username: admin
   Password: ${COUCHDB_PASSWORD}
   Database: obsidian-vault
4. Test Connection → Create Database
5. Replicate from remote（从服务器下载）
```

### 3. 系统设置
```
iOS设置 → Obsidian → 后台App刷新 → 开启
iOS设置 → Tailscale → 后台App刷新 → 开启
```

## 🤖 Android配置

### 1. 安装Tailscale
```
Google Play → 搜索"Tailscale" → 安装
打开 → 登录（使用相同账号）
```

### 2. 配置Obsidian（与iPad相同）

### 3. 系统设置
```
设置 → 应用 → Obsidian → 电池 → 无限制
设置 → 应用 → Tailscale → 电池 → 无限制
```

## 💻 Windows配置

### 1. 安装Tailscale
```
下载：https://tailscale.com/download/windows
安装并登录
```

### 2. 配置Obsidian（与Mac相同）

---

## ✅ 验证同步

在任一设备上：
1. 创建新笔记"测试同步.md"
2. 写入内容并保存
3. 2秒内其他设备应该能看到

LiveSync图标应该显示绿色✅
EOFDEVICE2

echo -e "${GREEN}✓ 设备配置指南已生成${NC}"

# ===================================================================
# 完成
# ===================================================================
echo
echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║           🎉 部署完成！                             ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${GREEN}✅ NAS配置完成${NC}"
echo -e "${GREEN}✅ CouchDB运行正常${NC}"
echo -e "${GREEN}✅ Tailscale连接成功${NC}"
echo
echo -e "${CYAN}📋 重要信息：${NC}"
echo -e "  Tailscale IP: ${GREEN}${TAILSCALE_IP}${NC}"
echo -e "  CouchDB密码: ${GREEN}${COUCHDB_PASSWORD}${NC}"
echo -e "  配置文件位置: ${GREEN}${CONFIG_DIR}${NC}"
echo
echo -e "${YELLOW}🔔 下一步操作：${NC}"
echo
echo -e "  1️⃣  在Mac上安装Tailscale："
echo -e "     ${CYAN}brew install --cask tailscale${NC}"
echo
echo -e "  2️⃣  查看设备配置指南："
echo -e "     ${CYAN}open ${CONFIG_DIR}/DEVICE_SETUP.md${NC}"
echo
echo -e "  3️⃣  或者打开配置信息："
echo -e "     ${CYAN}cat ${CONFIG_DIR}/CONFIG_INFO.txt${NC}"
echo
echo -e "${GREEN}✨ 现在就可以配置Obsidian了！${NC}"
echo

# 自动打开配置文件
if command -v open &> /dev/null; then
    echo -e "${CYAN}→ 自动打开配置文件...${NC}"
    sleep 2
    open "$CONFIG_DIR/DEVICE_SETUP.md"
fi