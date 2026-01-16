#!/bin/bash
# ===================================================================
# Obsidian LiveSync 监控脚本
# 功能：监控CouchDB状态、同步性能、资源占用
# 用法：./monitor.sh [options]
# ===================================================================

# 配置项（请根据实际情况修改）
COUCHDB_HOST="localhost"
COUCHDB_PORT="5984"
COUCHDB_USER="admin"
COUCHDB_PASSWORD=""  # 从配置文件读取或命令行参数提供
COUCHDB_DBNAME="obsidian-vault"
CONTAINER_NAME="obsidian-livesync"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# 读取配置文件中的密码
read_config() {
    if [ -f "CONFIG_INFO.txt" ]; then
        COUCHDB_PASSWORD=$(grep "密码:" CONFIG_INFO.txt | head -1 | awk '{print $2}')
    fi

    if [ -z "$COUCHDB_PASSWORD" ]; then
        echo -e "${YELLOW}未找到配置文件，请手动输入密码${NC}"
        read -sp "CouchDB密码: " COUCHDB_PASSWORD
        echo
    fi
}

# 打印分隔线
print_separator() {
    echo -e "${BLUE}============================================${NC}"
}

# 检查容器状态
check_container() {
    echo -e "${CYAN}📦 Docker容器状态${NC}"
    print_separator

    if docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep "$CONTAINER_NAME" > /dev/null; then
        echo -e "${GREEN}✅ 容器运行中${NC}"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep "$CONTAINER_NAME"

        # 显示容器运行时间
        UPTIME=$(docker inspect -f '{{.State.StartedAt}}' $CONTAINER_NAME)
        echo -e "启动时间: $UPTIME"
    else
        echo -e "${RED}❌ 容器未运行${NC}"
        return 1
    fi
    echo
}

# 检查CouchDB连接
check_couchdb() {
    echo -e "${CYAN}🔌 CouchDB连接状态${NC}"
    print_separator

    RESPONSE=$(curl -s -w "\n%{http_code}" http://${COUCHDB_HOST}:${COUCHDB_PORT}/)
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | sed '$d')

    if [ "$HTTP_CODE" -eq 200 ]; then
        echo -e "${GREEN}✅ CouchDB可访问${NC}"
        echo "$BODY" | jq -r '"\(.couchdb) - 版本 \(.version)"'
    else
        echo -e "${RED}❌ CouchDB无法访问 (HTTP $HTTP_CODE)${NC}"
        return 1
    fi
    echo
}

# 检查Tailscale状态
check_tailscale() {
    echo -e "${CYAN}🔗 Tailscale状态${NC}"
    print_separator

    if command -v tailscale &> /dev/null; then
        TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)
        if [ -n "$TAILSCALE_IP" ]; then
            echo -e "${GREEN}✅ Tailscale已连接${NC}"
            echo "Tailscale IP: $TAILSCALE_IP"

            # 显示在线设备数量
            DEVICE_COUNT=$(tailscale status | grep -v "^#" | wc -l)
            echo "在线设备数: $DEVICE_COUNT"
        else
            echo -e "${YELLOW}⚠️  Tailscale未连接${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  未安装Tailscale${NC}"
    fi
    echo
}

# 检查数据库状态
check_database() {
    echo -e "${CYAN}💾 数据库状态${NC}"
    print_separator

    DB_INFO=$(curl -s http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@${COUCHDB_HOST}:${COUCHDB_PORT}/${COUCHDB_DBNAME})

    if echo "$DB_INFO" | jq -e . >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 数据库连接成功${NC}"
        echo

        # 提取关键信息
        DOC_COUNT=$(echo "$DB_INFO" | jq -r '.doc_count')
        DOC_DEL_COUNT=$(echo "$DB_INFO" | jq -r '.doc_del_count')
        DISK_SIZE=$(echo "$DB_INFO" | jq -r '.disk_size')
        DATA_SIZE=$(echo "$DB_INFO" | jq -r '.data_size')

        # 转换字节为人类可读格式
        DISK_SIZE_HR=$(numfmt --to=iec-i --suffix=B $DISK_SIZE 2>/dev/null || echo "${DISK_SIZE} bytes")
        DATA_SIZE_HR=$(numfmt --to=iec-i --suffix=B $DATA_SIZE 2>/dev/null || echo "${DATA_SIZE} bytes")

        # 计算碎片率
        if [ "$DISK_SIZE" -gt 0 ]; then
            FRAGMENT_RATIO=$(echo "scale=2; (1 - $DATA_SIZE / $DISK_SIZE) * 100" | bc 2>/dev/null || echo "0")
        else
            FRAGMENT_RATIO="0"
        fi

        echo "文档数量: $DOC_COUNT"
        echo "已删除文档: $DOC_DEL_COUNT"
        echo "磁盘占用: $DISK_SIZE_HR"
        echo "实际数据: $DATA_SIZE_HR"
        echo "碎片率: ${FRAGMENT_RATIO}%"

        # 碎片率警告
        if (( $(echo "$FRAGMENT_RATIO > 30" | bc -l 2>/dev/null) )); then
            echo -e "${YELLOW}⚠️  碎片率较高，建议运行压缩${NC}"
            echo "执行: curl -X POST http://admin:密码@localhost:5984/${COUCHDB_DBNAME}/_compact"
        fi
    else
        echo -e "${RED}❌ 数据库不存在或无法访问${NC}"
        echo "错误信息: $DB_INFO"
        return 1
    fi
    echo
}

# 检查资源占用
check_resources() {
    echo -e "${CYAN}📊 资源占用${NC}"
    print_separator

    # Docker容器资源
    STATS=$(docker stats $CONTAINER_NAME --no-stream --format "{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}")

    if [ -n "$STATS" ]; then
        echo -e "${GREEN}✅ 资源监控${NC}"
        echo "$STATS" | awk -F'\t' '{
            print "CPU使用: " $1
            print "内存使用: " $2
            print "网络IO: " $3
        }'

        # CPU使用率警告
        CPU_USAGE=$(echo "$STATS" | awk -F'\t' '{print $1}' | sed 's/%//')
        if (( $(echo "$CPU_USAGE > 80" | bc -l 2>/dev/null) )); then
            echo -e "${RED}⚠️  CPU使用率过高${NC}"
        fi
    fi
    echo
}

# 检查磁盘空间
check_disk_space() {
    echo -e "${CYAN}💿 磁盘空间${NC}"
    print_separator

    WORK_DIR="/volume1/docker/obsidian-sync"
    if [ -d "$WORK_DIR" ]; then
        echo "工作目录: $WORK_DIR"

        # 总磁盘空间
        df -h "$WORK_DIR" | tail -1 | awk '{print "总空间: " $2 "\n已用: " $3 " (" $5 ")\n可用: " $4}'

        # data目录大小
        DATA_SIZE=$(du -sh "$WORK_DIR/data" 2>/dev/null | awk '{print $1}')
        echo "数据目录: $DATA_SIZE"

        # 磁盘使用率警告
        DISK_USAGE=$(df "$WORK_DIR" | tail -1 | awk '{print $5}' | sed 's/%//')
        if [ "$DISK_USAGE" -gt 85 ]; then
            echo -e "${RED}⚠️  磁盘使用率过高（${DISK_USAGE}%）${NC}"
        fi
    fi
    echo
}

# 检查网络延迟
check_network_latency() {
    echo -e "${CYAN}🌐 网络延迟测试${NC}"
    print_separator

    # 本地延迟
    echo "本地CouchDB响应时间:"
    for i in {1..3}; do
        TIME=$(curl -s -w "%{time_total}s\n" -o /dev/null http://${COUCHDB_HOST}:${COUCHDB_PORT}/)
        echo "  尝试 $i: $TIME"
    done

    # Tailscale延迟
    if command -v tailscale &> /dev/null; then
        TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)
        if [ -n "$TAILSCALE_IP" ]; then
            echo
            echo "Tailscale网络延迟:"
            ping -c 3 $TAILSCALE_IP | tail -1 | awk '{print "  平均延迟: " $4 " ms"}'
        fi
    fi
    echo
}

# 查看最近日志
check_logs() {
    echo -e "${CYAN}📝 最近日志（最后20行）${NC}"
    print_separator

    docker logs --tail 20 $CONTAINER_NAME 2>&1 | sed 's/^/  /'
    echo

    # 检查错误日志
    ERROR_COUNT=$(docker logs --tail 100 $CONTAINER_NAME 2>&1 | grep -i error | wc -l)
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  最近100行日志中发现 $ERROR_COUNT 个错误${NC}"
        echo "查看完整错误: docker logs $CONTAINER_NAME 2>&1 | grep -i error"
    fi
    echo
}

# 健康检查总结
health_summary() {
    echo -e "${PURPLE}╔════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║     Obsidian LiveSync 健康检查报告     ║${NC}"
    echo -e "${PURPLE}╚════════════════════════════════════════╝${NC}"
    echo

    ISSUES=0

    # 检查各项状态
    if ! docker ps | grep -q "$CONTAINER_NAME"; then
        echo -e "${RED}❌ 容器未运行${NC}"
        ((ISSUES++))
    fi

    if ! curl -s http://${COUCHDB_HOST}:${COUCHDB_PORT}/ > /dev/null; then
        echo -e "${RED}❌ CouchDB无法访问${NC}"
        ((ISSUES++))
    fi

    if command -v tailscale &> /dev/null; then
        if ! tailscale ip -4 &> /dev/null; then
            echo -e "${YELLOW}⚠️  Tailscale未连接${NC}"
            ((ISSUES++))
        fi
    fi

    # 总结
    if [ $ISSUES -eq 0 ]; then
        echo -e "${GREEN}✅ 所有检查通过，系统运行正常！${NC}"
    else
        echo -e "${YELLOW}⚠️  发现 $ISSUES 个问题，请查看详细信息${NC}"
    fi
    echo
}

# 一键修复常见问题
quick_fix() {
    echo -e "${CYAN}🔧 一键修复${NC}"
    print_separator

    echo "1. 重启容器"
    echo "2. 压缩数据库"
    echo "3. 清理日志"
    echo "4. 重启Tailscale"
    echo "5. 全部执行"
    echo "0. 取消"
    echo
    read -p "请选择操作 [0-5]: " choice

    case $choice in
        1)
            echo "重启容器..."
            docker-compose restart
            echo -e "${GREEN}✅ 容器已重启${NC}"
            ;;
        2)
            echo "压缩数据库..."
            curl -X POST http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@${COUCHDB_HOST}:${COUCHDB_PORT}/${COUCHDB_DBNAME}/_compact
            echo -e "${GREEN}✅ 数据库压缩已启动${NC}"
            ;;
        3)
            echo "清理日志..."
            docker logs $CONTAINER_NAME > /dev/null 2>&1
            echo -e "${GREEN}✅ 日志已清理${NC}"
            ;;
        4)
            echo "重启Tailscale..."
            sudo systemctl restart tailscaled
            echo -e "${GREEN}✅ Tailscale已重启${NC}"
            ;;
        5)
            echo "执行全部修复..."
            docker-compose restart
            curl -X POST http://${COUCHDB_USER}:${COUCHDB_PASSWORD}@${COUCHDB_HOST}:${COUCHDB_PORT}/${COUCHDB_DBNAME}/_compact
            sudo systemctl restart tailscaled
            echo -e "${GREEN}✅ 全部修复完成${NC}"
            ;;
        0)
            echo "已取消"
            ;;
        *)
            echo -e "${RED}无效选择${NC}"
            ;;
    esac
    echo
}

# 导出监控报告
export_report() {
    REPORT_FILE="monitor_report_$(date +%Y%m%d_%H%M%S).txt"

    {
        echo "======================================"
        echo "Obsidian LiveSync 监控报告"
        echo "生成时间: $(date)"
        echo "======================================"
        echo

        check_container
        check_couchdb
        check_tailscale
        check_database
        check_resources
        check_disk_space
        check_logs

    } > "$REPORT_FILE"

    echo -e "${GREEN}✅ 报告已导出到: $REPORT_FILE${NC}"
}

# 显示使用帮助
show_help() {
    cat << EOF
用法: $0 [选项]

选项:
  -h, --help          显示此帮助信息
  -f, --full          完整检查（默认）
  -s, --summary       仅显示健康检查总结
  -c, --container     仅检查容器状态
  -d, --database      仅检查数据库状态
  -r, --resources     仅检查资源占用
  -l, --logs          查看最近日志
  -w, --watch         持续监控模式（每10秒刷新）
  -x, --fix           一键修复
  -e, --export        导出监控报告
  -p, --password      指定CouchDB密码

示例:
  $0                  # 完整检查
  $0 -s              # 快速健康检查
  $0 -w              # 持续监控
  $0 -p mypassword   # 使用指定密码
  $0 -e              # 导出报告

EOF
}

# 持续监控模式
watch_mode() {
    while true; do
        clear
        echo -e "${PURPLE}持续监控模式（每10秒刷新，按Ctrl+C退出）${NC}"
        echo
        health_summary
        check_container
        check_resources
        sleep 10
    done
}

# 主函数
main() {
    # 解析命令行参数
    FULL_CHECK=true

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -s|--summary)
                FULL_CHECK=false
                health_summary
                exit 0
                ;;
            -c|--container)
                FULL_CHECK=false
                read_config
                check_container
                exit 0
                ;;
            -d|--database)
                FULL_CHECK=false
                read_config
                check_database
                exit 0
                ;;
            -r|--resources)
                FULL_CHECK=false
                check_resources
                exit 0
                ;;
            -l|--logs)
                FULL_CHECK=false
                check_logs
                exit 0
                ;;
            -w|--watch)
                read_config
                watch_mode
                exit 0
                ;;
            -x|--fix)
                read_config
                quick_fix
                exit 0
                ;;
            -e|--export)
                read_config
                export_report
                exit 0
                ;;
            -p|--password)
                COUCHDB_PASSWORD="$2"
                shift
                ;;
            *)
                echo "未知选项: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done

    # 执行完整检查
    if [ "$FULL_CHECK" = true ]; then
        read_config
        health_summary
        check_container
        check_couchdb
        check_tailscale
        check_database
        check_resources
        check_disk_space
        check_network_latency
        check_logs
    fi
}

# 运行主函数
main "$@"