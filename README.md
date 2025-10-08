# OpenWrt IPv6 DDNS & Socat 管理工具

一键配置 OpenWrt 外网 IPv6 访问内网服务。

## 功能

- 自动 DDNS（DNSPod）- 自动更新 IPv6 地址到域名
- 端口转发 - 使用 Socat 实现 IPv6 到内网 IPv4 转发
- 防火墙联动 - 自动管理防火墙规则
- IP 监控 - 自动检测 IPv6 变化并更新
- 开机自启

## 要求

- OpenWrt 18.06+
- 公网 IPv6 地址
- DNSPod 账号

## 安装

### 在线安装

```bash
wget -O - https://raw.githubusercontent.com/spellforce/openwrt-socat-ddns/main/install.sh | sh
```

or

```bash
curl -fsSL https://raw.githubusercontent.com/spellforce/openwrt-socat-ddns/main/install.sh | sh
```

### 本地安装

```bash
# 上传文件到路由器
scp -r openwrt-socat-ddns root@192.168.1.1:/tmp/

# SSH 登录并安装
ssh root@192.168.1.1
cd /tmp/openwrt-socat-ddns
sh install.sh
```

## 配置

```bash
# 编辑配置
ddns-socat-manager config
```

主要配置项：

```bash
DDNS_ID="你的DNSPod ID"
DDNS_TOKEN="你的DNSPod Token"
DDNS_DOMAIN="example.com"
IPV6_INTERFACE="pppoe-wan"

FORWARDS="
22:192.168.1.100:22:SSH
5000:192.168.1.101:5000:DSM
"
```

启动：

```bash
ddns-socat-manager start
ddns-socat-manager enable  # 开机自启
```

## 使用

```bash
ddns-socat-manager status        # 查看状态
ddns-socat-manager start         # 启动
ddns-socat-manager stop          # 停止
ddns-socat-manager restart       # 重启
ddns-socat-manager logs          # 查看日志
ddns-socat-manager update-ddns   # 手动更新 DDNS
ddns-socat-manager enable        # 开机自启
```

## 关键配置

配置文件：`/etc/ddns-socat.conf`

### 获取 DNSPod Token

1. 登录 [DNSPod 控制台](https://console.dnspod.cn/)
2. "用户中心" -> "安全设置" -> "API Token"
3. 记录 ID 和 Token

### 查找 IPv6 接口名

```bash
ip -6 addr show  # 查看所有接口
```

常见接口名：`pppoe-wan`、`eth0.2`、`wan6`

### 转发规则格式

```bash
外部端口:内网IP:内网端口:描述
```

示例：
- SSH: `22:192.168.1.100:22:SSH`
- NAS: `5000:192.168.1.101:5000:DSM`
- Web: `80:192.168.1.100:80:HTTP`

## 常见问题

### 无法获取 IPv6？
```bash
ip -6 addr show  # 查看接口名
ddns-socat-manager config  # 修改配置
```

### DDNS 更新失败？
```bash
ddns-socat-manager update-ddns  # 手动更新测试
ddns-socat-manager logs  # 查看错误日志
```

### 端口无法访问？
```bash
ddns-socat-manager status  # 检查服务状态
ps | grep socat  # 检查进程
uci show firewall | grep DDNS-SOCAT  # 检查防火墙
```

### 卸载
```bash
sh uninstall.sh
```

---

## License

MIT License
