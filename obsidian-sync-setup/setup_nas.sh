#!/bin/bash
# ===================================================================
# Obsidian LiveSync on 绿联云NAS - 一键部署脚本
# 适用于：UGOS Pro系统
# 作者：Claude Code
# 版本：v1.0
# ===================================================================

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为root用户
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "请使用root权限运行此脚本"
        print_info "执行：sudo bash setup_nas.sh"
        exit 1
    fi
}

# 检查系统环境
check_system() {
    print_info "检查系统环境..."

    # 检查是否为Linux
    if [ "$(uname)" != "Linux" ]; then
        print_error "此脚本仅支持Linux系统"
        exit 1
    fi

    # 检查Docker是否安装
    if ! command -v docker &> /dev/null; then
        print_error "未检测到Docker，请先安装Docker"
        exit 1
    fi

    # 检查Docker Compose是否安装
    if ! command -v docker-compose &> /dev/null; then
        print_error "未检测到Docker Compose，请先安装Docker Compose"
        exit 1
    fi

    print_success "系统环境检查通过"
}

# 安装Tailscale
install_tailscale() {
    print_info "检查Tailscale安装状态..."

    if command -v tailscale &> /dev/null; then
        print_success "Tailscale已安装"
        TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "未连接")
        print_info "当前Tailscale IP: $TAILSCALE_IP"
        return 0
    fi

    print_warning "Tailscale未安装，开始安装..."

    # 下载并安装Tailscale
    curl -fsSL https://tailscale.com/install.sh | sh

    if [ $? -eq 0 ]; then
        print_success "Tailscale安装成功"
        print_warning "请执行以下命令连接到Tailscale网络："
        print_info "  tailscale up"
        print_info "然后访问显示的链接进行授权"
        read -p "按Enter继续（确保已完成Tailscale连接）..."
    else
        print_error "Tailscale安装失败"
        exit 1
    fi
}

# 获取Tailscale IP
get_tailscale_ip() {
    print_info "获取Tailscale IP地址..."

    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)

    if [ -z "$TAILSCALE_IP" ]; then
        print_error "无法获取Tailscale IP，请确保Tailscale已连接"
        print_info "执行：tailscale status"
        exit 1
    fi

    print_success "Tailscale IP: $TAILSCALE_IP"
}

# 创建工作目录
create_directories() {
    print_info "创建工作目录..."

    WORK_DIR="/volume1/docker/obsidian-sync"

    # 检查目录是否存在
    if [ -d "$WORK_DIR" ]; then
        print_warning "目录已存在：$WORK_DIR"
        read -p "是否删除并重新创建？(y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$WORK_DIR"
            print_info "已删除旧目录"
        else
            print_info "保留现有目录"
            cd "$WORK_DIR"
            return 0
        fi
    fi

    mkdir -p "$WORK_DIR"/{data,config}
    cd "$WORK_DIR"

    print_success "工作目录创建完成：$WORK_DIR"
}

# 生成强密码
generate_password() {
    if command -v openssl &> /dev/null; then
        openssl rand -base64 24 | tr -d "=+/" | cut -c1-20
    else
        date +%s | sha256sum | base64 | head -c 20
    fi
}

# 配置CouchDB密码
configure_passwords() {
    print_info "配置CouchDB密码..."

    echo
    print_warning "请设置CouchDB管理员密码（至少16位，包含大小写字母、数字、特殊字符）"
    read -sp "输入密码: " COUCHDB_PASSWORD
    echo
    read -sp "确认密码: " COUCHDB_PASSWORD_CONFIRM
    echo

    if [ "$COUCHDB_PASSWORD" != "$COUCHDB_PASSWORD_CONFIRM" ]; then
        print_error "两次输入的密码不一致"
        exit 1
    fi

    if [ ${#COUCHDB_PASSWORD} -lt 16 ]; then
        print_error "密码长度至少16位"
        exit 1
    fi

    # 生成随机secret
    COUCHDB_SECRET=$(generate_password)

    print_success "密码配置完成"
}

# 创建docker-compose.yml
create_docker_compose() {
    print_info "创建docker-compose.yml配置文件..."

    cat > docker-compose.yml << EOF
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
      - "5984:5984"

    volumes:
      - ./data:/opt/couchdb/data
      - ./config:/opt/couchdb/etc/local.d
      - ./init.ini:/opt/couchdb/etc/local.d/init.ini:ro

    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5984/_up"]
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
EOF

    print_success "docker-compose.yml创建完成"
}

# 创建init.ini
create_init_ini() {
    print_info "创建CouchDB初始化配置..."

    cat > init.ini << 'EOF'
[couchdb]
single_node=true

[chttpd]
enable_cors = true
max_http_request_size = 104857600

[cors]
origins = *
credentials = true
methods = GET, PUT, POST, HEAD, DELETE
headers = accept, authorization, content-type, origin, referer, x-requested-with

[httpd]
bind_address = 0.0.0.0
enable_xframe_options = false

[couch_httpd_auth]
timeout = 604800
allow_persistent_cookies = true

[log]
level = info

[replicator]
max_replication_retry_count = 10
EOF

    print_success "init.ini创建完成"
}

# 启动CouchDB
start_couchdb() {
    print_info "启动CouchDB容器..."

    docker-compose up -d

    if [ $? -eq 0 ]; then
        print_success "CouchDB容器启动成功"
    else
        print_error "CouchDB容器启动失败"
        exit 1
    fi

    # 等待CouchDB启动
    print_info "等待CouchDB完全启动（约30秒）..."
    sleep 30

    # 检查容器状态
    if docker ps | grep -q obsidian-livesync; then
        print_success "CouchDB运行正常"
    else
        print_error "CouchDB容器未正常运行"
        print_info "查看日志：docker logs obsidian-livesync"
        exit 1
    fi
}

# 初始化CouchDB
initialize_couchdb() {
    print_info "初始化CouchDB配置..."

    # 配置为单节点
    curl -X PUT http://admin:${COUCHDB_PASSWORD}@localhost:5984/_node/_local/_config/cluster/n \
        -H "Content-Type: application/json" \
        -d '"1"' 2>/dev/null

    # 启用CORS
    curl -X PUT http://admin:${COUCHDB_PASSWORD}@localhost:5984/_node/_local/_config/httpd/enable_cors \
        -H "Content-Type: application/json" \
        -d '"true"' 2>/dev/null

    # 验证配置
    COUCHDB_STATUS=$(curl -s http://admin:${COUCHDB_PASSWORD}@localhost:5984/ | grep -o '"couchdb":"Welcome"')

    if [ -n "$COUCHDB_STATUS" ]; then
        print_success "CouchDB初始化完成"
    else
        print_warning "CouchDB可能未完全初始化，请手动检查"
    fi
}

# 生成配置信息
generate_config_info() {
    print_info "生成配置信息文件..."

    cat > CONFIG_INFO.txt << EOF
================================
Obsidian LiveSync 配置信息
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

【管理界面】
局域网访问: http://$(hostname -I | awk '{print $1}'):5984/_utils
Tailscale访问: http://${TAILSCALE_IP}:5984/_utils

【Docker管理命令】
查看状态: docker ps | grep obsidian
查看日志: docker logs obsidian-livesync
重启服务: docker-compose restart
停止服务: docker-compose down
启动服务: docker-compose up -d

【目录位置】
工作目录: ${WORK_DIR}
数据目录: ${WORK_DIR}/data
配置目录: ${WORK_DIR}/config

【备份命令】
tar -czf backup_\$(date +%Y%m%d).tar.gz data/

【注意事项】
1. 请妥善保管此文件，包含敏感信息
2. 首次使用需在Obsidian中创建数据库
3. 建议启用端到端加密
4. 定期备份data目录

生成时间: $(date)
================================
EOF

    chmod 600 CONFIG_INFO.txt
    print_success "配置信息已保存到：${WORK_DIR}/CONFIG_INFO.txt"
}

# 显示下一步操作
show_next_steps() {
    echo
    print_success "========================================="
    print_success "  Obsidian LiveSync 部署完成！"
    print_success "========================================="
    echo
    print_info "📋 配置信息已保存到：${WORK_DIR}/CONFIG_INFO.txt"
    echo
    print_info "🔗 下一步操作："
    echo
    echo "  1️⃣  在所有设备上安装Tailscale并连接到同一网络"
    echo "     iOS/Android: App Store/Google Play搜索\"Tailscale\""
    echo "     Mac: brew install --cask tailscale"
    echo
    echo "  2️⃣  在Obsidian中安装\"Self-hosted LiveSync\"插件"
    echo "     设置 → 社区插件 → 浏览 → 搜索LiveSync"
    echo
    echo "  3️⃣  配置LiveSync插件："
    echo "     URI: http://${TAILSCALE_IP}:5984"
    echo "     用户名: admin"
    echo "     密码: ${COUCHDB_PASSWORD}"
    echo "     数据库: obsidian-vault"
    echo
    echo "  4️⃣  点击\"Test Connection\"测试连接"
    echo "     成功后点击\"Create Database\"创建数据库"
    echo
    echo "  5️⃣  开启同步并测试"
    echo
    print_info "🛠️  管理命令："
    echo "  查看日志: docker logs -f obsidian-livesync"
    echo "  重启服务: cd ${WORK_DIR} && docker-compose restart"
    echo "  访问管理: http://${TAILSCALE_IP}:5984/_utils"
    echo
    print_info "📚 完整文档请查看 README.md"
    echo
}

# 主函数
main() {
    clear
    echo "==========================================="
    echo "  Obsidian LiveSync on 绿联云NAS"
    echo "  一键部署脚本 v1.0"
    echo "==========================================="
    echo

    check_root
    check_system
    install_tailscale
    get_tailscale_ip
    create_directories
    configure_passwords
    create_docker_compose
    create_init_ini
    start_couchdb
    initialize_couchdb
    generate_config_info
    show_next_steps
}

# 执行主函数
main