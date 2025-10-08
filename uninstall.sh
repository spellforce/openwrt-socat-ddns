#!/bin/sh
#############################################
# DDNS & Socat 卸载脚本
# 用于 OpenWrt 系统
#############################################

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}"
cat << "BANNER"
╔════════════════════════════════════════╗
║  DDNS & Socat 自动化管理工具 卸载程序  ║
╚════════════════════════════════════════╝
BANNER
echo -e "${NC}\n"

# 检查是否为 root
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}错误：请使用 root 用户运行此脚本${NC}"
    exit 1
fi

# 确认卸载
echo -e "${RED}警告：此操作将完全卸载 DDNS & Socat 管理工具${NC}"
echo -e "${YELLOW}是否继续？(y/n)${NC}"
read -r answer < /dev/tty

if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
    echo -e "${GREEN}已取消卸载${NC}"
    exit 0
fi

echo ""
echo -e "${YELLOW}开始卸载...${NC}\n"

# 停止服务
echo -e "${YELLOW}[1/5] 停止服务...${NC}"
if [ -f /usr/bin/ddns-socat-manager ]; then
    /usr/bin/ddns-socat-manager stop 2>/dev/null
fi
echo -e "${GREEN}✓ 服务已停止${NC}\n"

# 禁用开机自启
echo -e "${YELLOW}[2/5] 禁用开机自启...${NC}"
if [ -f /etc/init.d/ddns-socat ]; then
    /etc/init.d/ddns-socat disable 2>/dev/null
    rm -f /etc/init.d/ddns-socat
fi
echo -e "${GREEN}✓ 开机自启已禁用${NC}\n"

# 删除脚本文件
echo -e "${YELLOW}[3/5] 删除脚本文件...${NC}"
rm -f /usr/bin/ddns-socat-manager
rm -f /usr/bin/ddns-socat-monitor
rm -f /var/run/ddns-socat-monitor.pid
rm -f /var/run/ddns-socat-last-ip
echo -e "${GREEN}✓ 脚本文件已删除${NC}\n"

# 询问是否删除配置文件
echo -e "${YELLOW}[4/5] 是否删除配置文件？${NC}"
echo -e "${BLUE}删除配置文件后无法恢复，请确认 (y/n)${NC}"
read -r answer < /dev/tty

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    rm -f /etc/ddns-socat.conf
    echo -e "${GREEN}✓ 配置文件已删除${NC}\n"
else
    echo -e "${YELLOW}保留配置文件：/etc/ddns-socat.conf${NC}\n"
fi

# 清理防火墙规则
echo -e "${YELLOW}[5/5] 清理防火墙规则...${NC}"
if command -v uci >/dev/null 2>&1; then
    while uci show firewall 2>/dev/null | grep -q "name='DDNS-SOCAT-"; do
        rule_index=$(uci show firewall | grep "name='DDNS-SOCAT-" | head -1 | cut -d'.' -f2 | cut -d'=' -f1)
        if [ -n "$rule_index" ]; then
            uci delete firewall.${rule_index} 2>/dev/null
        fi
    done
    
    if uci commit firewall 2>/dev/null; then
        /etc/init.d/firewall reload >/dev/null 2>&1
        echo -e "${GREEN}✓ 防火墙规则已清理${NC}\n"
    else
        echo -e "${YELLOW}⚠ 防火墙配置提交失败，可能需要手动清理${NC}\n"
    fi
else
    echo -e "${YELLOW}⚠ UCI 命令不存在，跳过防火墙清理${NC}\n"
fi

echo -e "${GREEN}=== 卸载完成 ===${NC}\n"

echo -e "${YELLOW}可选：是否卸载依赖包？${NC}"
echo -e "${BLUE}注意：这些包可能被其他程序使用${NC}"
echo -e "  - socat"
echo -e "  - curl"
echo -e "${YELLOW}是否卸载？(y/n)${NC}"
read -r answer < /dev/tty

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    opkg remove socat curl 2>/dev/null
    echo -e "${GREEN}✓ 依赖包已卸载${NC}\n"
fi

echo -e "${GREEN}感谢使用！${NC}"

