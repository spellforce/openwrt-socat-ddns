#!/bin/sh
#############################################
# DDNS & Socat 一键安装脚本
# 用于 OpenWrt 系统
#############################################

VERSION="1.0.0"
REPO_URL="https://raw.githubusercontent.com/spellforce/openwrt-socat-ddns/main"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}"
cat << "BANNER"
╔════════════════════════════════════════╗
║  DDNS & Socat 自动化管理工具 安装程序  ║
║          OpenWrt IPv6 DDNS            ║
╚════════════════════════════════════════╝
BANNER
echo -e "${NC}"

echo -e "${BLUE}版本: v${VERSION}${NC}\n"

# 检查是否为 root
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}错误：请使用 root 用户运行此脚本${NC}"
    exit 1
fi

# 检查系统
check_system() {
    echo -e "${YELLOW}[1/6] 检查系统环境...${NC}"
    
    if [ ! -f /etc/openwrt_release ]; then
        echo -e "${RED}警告：当前系统可能不是 OpenWrt${NC}"
        echo -e "${YELLOW}是否继续安装？(y/n)${NC}"
        read -r answer < /dev/tty
        if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
            exit 1
        fi
    else
        . /etc/openwrt_release
        echo -e "  系统: ${GREEN}$DISTRIB_ID $DISTRIB_RELEASE${NC}"
    fi
    
    echo -e "${GREEN}✓ 系统检查完成${NC}\n"
}

# 检查依赖
check_dependencies() {
    echo -e "${YELLOW}[2/6] 检查依赖包...${NC}"
    
    local missing_packages=""
    
    # 检查 socat
    if ! command -v socat >/dev/null 2>&1; then
        missing_packages="$missing_packages socat"
    fi
    
    # 检查 curl
    if ! command -v curl >/dev/null 2>&1; then
        missing_packages="$missing_packages curl"
    fi
    
    if [ -n "$missing_packages" ]; then
        echo -e "${YELLOW}  缺少依赖包:$missing_packages${NC}"
        echo -e "${YELLOW}  正在安装依赖包...${NC}"
        
        opkg update
        for pkg in $missing_packages; do
            echo -e "  安装 ${BLUE}$pkg${NC}..."
            opkg install $pkg
        done
    fi
    
    echo -e "${GREEN}✓ 依赖检查完成${NC}\n"
}

# 下载脚本
download_scripts() {
    echo -e "${YELLOW}[3/6] 下载脚本文件...${NC}"
    
    # 如果是本地安装（当前目录有文件）
    if [ -f "./ddns-socat-manager" ]; then
        echo -e "${BLUE}  检测到本地安装模式${NC}"
        
        echo -e "  安装主管理脚本..."
        cp ./ddns-socat-manager /usr/bin/ddns-socat-manager
        chmod +x /usr/bin/ddns-socat-manager
        
        echo -e "  安装监控脚本..."
        cp ./ddns-socat-monitor /usr/bin/ddns-socat-monitor
        chmod +x /usr/bin/ddns-socat-monitor
        
    else
        # 从 GitHub 下载
        echo -e "${BLUE}  从 GitHub 下载...${NC}"
        
        echo -e "  下载主管理脚本..."
        if ! curl -fsSL "${REPO_URL}/ddns-socat-manager" -o /usr/bin/ddns-socat-manager; then
            echo -e "${RED}✗ 下载失败${NC}"
            echo -e "${YELLOW}请检查：${NC}"
            echo -e "  1. 网络连接是否正常"
            echo -e "  2. GitHub 是否可访问"
            echo -e "  3. URL 是否正确: ${REPO_URL}"
            exit 1
        fi
        chmod +x /usr/bin/ddns-socat-manager
        
        echo -e "  下载监控脚本..."
        if ! curl -fsSL "${REPO_URL}/ddns-socat-monitor" -o /usr/bin/ddns-socat-monitor; then
            echo -e "${RED}✗ 下载失败${NC}"
            exit 1
        fi
        chmod +x /usr/bin/ddns-socat-monitor
    fi
    
    echo -e "${GREEN}✓ 脚本安装完成${NC}\n"
}

# 创建配置文件
create_config() {
    echo -e "${YELLOW}[4/6] 创建配置文件...${NC}"
    
    # 调用管理脚本初始化配置
    /usr/bin/ddns-socat-manager config >/dev/null 2>&1 || true
    
    if [ -f /etc/ddns-socat.conf ]; then
        echo -e "${GREEN}✓ 配置文件已创建${NC}\n"
    else
        echo -e "${RED}✗ 配置文件创建失败${NC}\n"
        exit 1
    fi
}

# 配置向导
config_wizard() {
    echo -e "${YELLOW}[5/6] 配置向导${NC}"
    echo -e "${BLUE}是否现在配置？(y/n)${NC}"
    read -r answer < /dev/tty
    
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo ""
        echo -e "${GREEN}=== DDNS 配置 ===${NC}"
        
        echo -e "${BLUE}请输入 DNSPod ID:${NC}"
        read -r dnspod_id < /dev/tty
        
        echo -e "${BLUE}请输入 DNSPod Token:${NC}"
        read -r dnspod_token < /dev/tty
        
        echo -e "${BLUE}请输入域名 (例如: example.com):${NC}"
        read -r domain < /dev/tty
        
        echo -e "${BLUE}请输入子域名 (@ 表示根域名，留空默认 @):${NC}"
        read -r subdomain < /dev/tty
        subdomain=${subdomain:-@}
        
        echo ""
        echo -e "${GREEN}=== IPv6 配置 ===${NC}"
        
        echo -e "${BLUE}请输入 IPv6 接口名称 (留空默认 pppoe-wan):${NC}"
        read -r ipv6_interface < /dev/tty
        ipv6_interface=${ipv6_interface:-pppoe-wan}
        
        echo ""
        echo -e "${GREEN}=== 端口转发配置 ===${NC}"
        echo -e "${YELLOW}示例格式: 外部端口:内网IP:内网端口:描述${NC}"
        echo -e "${YELLOW}例如: 22:192.168.1.100:22:SSH${NC}"
        echo -e "${BLUE}请输入转发规则 (每行一个，输入空行结束):${NC}"
        
        forwards=""
        while true; do
            read -r forward_rule < /dev/tty
            if [ -z "$forward_rule" ]; then
                break
            fi
            forwards="${forwards}${forward_rule}\n"
        done
        
        # 写入配置文件
        cat > /etc/ddns-socat.conf << EOF
# ========================================
# DDNS & Socat 配置文件
# ========================================

# ---------- DDNS 配置 ----------
DDNS_ENABLE="true"
DDNS_PROVIDER="dnspod"
DDNS_ID="$dnspod_id"
DDNS_TOKEN="$dnspod_token"
DDNS_DOMAIN="$domain"
DDNS_SUBDOMAIN="$subdomain"
DDNS_INTERVAL="300"

# ---------- IPv6 配置 ----------
IPV6_INTERFACE="$ipv6_interface"
IPV6_PREFIX="2409"

# ---------- Socat 转发配置 ----------
SOCAT_ENABLE="true"

FORWARDS="
$(echo -e "$forwards")
"

# ---------- 防火墙配置 ----------
FIREWALL_ENABLE="true"
FIREWALL_ZONE="wan"

# ---------- 监控配置 ----------
MONITOR_ENABLE="true"
MONITOR_LOG_CHANGES="true"
EOF
        
        echo -e "\n${GREEN}✓ 配置已保存${NC}\n"
    else
        echo -e "${YELLOW}跳过配置，请稍后手动编辑：/etc/ddns-socat.conf${NC}\n"
    fi
}

# 完成安装
finish_installation() {
    echo -e "${YELLOW}[6/6] 完成安装...${NC}"
    
    echo -e "${GREEN}✓ 安装完成！${NC}\n"
    
    echo -e "${GREEN}=== 使用说明 ===${NC}"
    echo -e "1. 编辑配置文件："
    echo -e "   ${BLUE}ddns-socat-manager config${NC}\n"
    
    echo -e "2. 启动服务："
    echo -e "   ${BLUE}ddns-socat-manager start${NC}\n"
    
    echo -e "3. 查看状态："
    echo -e "   ${BLUE}ddns-socat-manager status${NC}\n"
    
    echo -e "4. 设置开机自启："
    echo -e "   ${BLUE}ddns-socat-manager enable${NC}\n"
    
    echo -e "5. 查看帮助："
    echo -e "   ${BLUE}ddns-socat-manager help${NC}\n"
    
    echo -e "${YELLOW}是否现在启动服务？(y/n)${NC}"
    read -r answer < /dev/tty
    
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo ""
        /usr/bin/ddns-socat-manager start
        echo ""
        
        echo -e "${YELLOW}是否设置开机自启？(y/n)${NC}"
        read -r answer2 < /dev/tty
        
        if [ "$answer2" = "y" ] || [ "$answer2" = "Y" ]; then
            /usr/bin/ddns-socat-manager enable
        fi
    fi
}

# 主函数
main() {
    check_system
    check_dependencies
    download_scripts
    create_config
    config_wizard
    finish_installation
    
    echo -e "\n${GREEN}感谢使用！${NC}"
}

# 运行安装
main

