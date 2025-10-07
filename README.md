# OpenWrt DDNS & Socat 自动化管理工具

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-OpenWrt-orange)

**一键配置 OpenWrt 外网 IPv6 访问内网服务**

[功能特性](#功能特性) • [快速开始](#快速开始) • [使用文档](#使用文档) • [配置说明](#配置说明) • [常见问题](#常见问题)

</div>

---

## 📋 目录

- [功能特性](#功能特性)
- [系统要求](#系统要求)
- [快速开始](#快速开始)
- [使用文档](#使用文档)
- [配置说明](#配置说明)
- [进阶使用](#进阶使用)
- [常见问题](#常见问题)
- [更新日志](#更新日志)
- [开源协议](#开源协议)

---

## ✨ 功能特性

### 🚀 核心功能

- **一键安装** - 从 GitHub 直接下载并安装，支持本地安装
- **自动 DDNS** - 支持腾讯云 DNSPod，自动更新 IPv6 地址到域名
- **端口转发** - 使用 Socat 实现 IPv6 到内网 IPv4 的端口转发
- **防火墙联动** - 自动添加/删除防火墙规则，与端口转发同步
- **IP 监控** - 后台守护进程，自动检测 IPv6 变化并更新
- **配置管理** - 简单的配置文件，支持多个转发规则
- **日志记录** - 完整的系统日志，方便故障排查
- **开机自启** - 支持设置开机自动启动服务

### 🎯 适用场景

- 家庭 NAS 外网访问（群晖、威联通等）
- 内网服务器远程管理（SSH、HTTP/HTTPS）
- IoT 设备远程控制
- 自建服务外网发布（博客、网盘等）
- 开发环境远程调试

---

## 📦 系统要求

### 必需条件

- **系统**: OpenWrt 18.06 或更高版本
- **网络**: 运营商分配公网 IPv6 地址
- **权限**: root 用户权限

### 依赖软件

以下软件包会在安装时自动安装：

- `socat` - 端口转发工具
- `curl` - HTTP 请求工具

---

## 🚀 快速开始

### 方法一：在线安装（推荐）

SSH 登录到 OpenWrt 路由器，执行以下命令：

```bash
# 下载并运行安装脚本
wget -O - https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/install.sh | sh
```

或者使用 curl：

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/install.sh | sh
```

### 方法二：本地安装

```bash
# 1. 下载项目
git clone https://github.com/yourusername/openwrt-socat-ddns.git
cd openwrt-socat-ddns

# 2. 上传到 OpenWrt（在你的电脑上执行）
scp -r openwrt-socat-ddns root@192.168.1.1:/tmp/

# 3. SSH 登录路由器并安装
ssh root@192.168.1.1
cd /tmp/openwrt-socat-ddns
sh install.sh
```

### 安装后配置

安装完成后，编辑配置文件：

```bash
ddns-socat-manager config
```

主要配置项：

```bash
# DNSPod 配置
DDNS_ID="你的DNSPod ID"
DDNS_TOKEN="你的DNSPod Token"
DDNS_DOMAIN="yourdomain.com"
DDNS_SUBDOMAIN="@"

# IPv6 接口（根据实际情况修改）
IPV6_INTERFACE="pppoe-wan"

# 端口转发规则（格式：外部端口:内网IP:内网端口:描述）
FORWARDS="
22:192.168.1.100:22:SSH-Server
80:192.168.1.100:80:Web-Server
443:192.168.1.100:443:HTTPS-Server
5000:192.168.1.101:5000:DSM-HTTP
5001:192.168.1.101:5001:DSM-HTTPS
"
```

启动服务：

```bash
ddns-socat-manager start
```

---

## 📖 使用文档

### 命令列表

```bash
ddns-socat-manager <命令>
```

| 命令 | 说明 |
|------|------|
| `config` | 编辑配置文件 |
| `status` | 查看服务状态 |
| `start` | 启动所有服务 |
| `stop` | 停止所有服务 |
| `restart` | 重启所有服务 |
| `enable` | 设置开机自启 |
| `disable` | 禁用开机自启 |
| `update-ddns` | 立即更新 DDNS |
| `show-ipv6` | 显示当前 IPv6 地址 |
| `logs` | 查看最近日志 |
| `list-forwards` | 列出所有转发规则 |
| `version` | 显示版本信息 |
| `help` | 显示帮助信息 |

### 常用操作

#### 1. 查看服务状态

```bash
ddns-socat-manager status
```

输出示例：
```
=== 服务状态 ===

IPv6 地址：2409:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx

DDNS 状态：
  状态: 已启用
  域名: example.com
  上次更新: 2409:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx

端口转发状态：
  状态: 运行中
  进程数: 5

IP 监控状态：
  状态: 运行中 (PID: 12345)

防火墙规则：
  规则数: 5
```

#### 2. 查看转发规则

```bash
ddns-socat-manager list-forwards
```

#### 3. 查看日志

```bash
ddns-socat-manager logs
```

#### 4. 手动更新 DDNS

```bash
ddns-socat-manager update-ddns
```

#### 5. 重启服务

```bash
ddns-socat-manager restart
```

---

## ⚙️ 配置说明

配置文件位置：`/etc/ddns-socat.conf`

### DDNS 配置

```bash
# 是否启用 DDNS
DDNS_ENABLE="true"

# DDNS 提供商（目前仅支持 dnspod）
DDNS_PROVIDER="dnspod"

# DNSPod ID（在 DNSPod 控制台获取）
DDNS_ID="your_id"

# DNSPod Token（在 DNSPod 控制台获取）
DDNS_TOKEN="your_token"

# 主域名
DDNS_DOMAIN="example.com"

# 子域名（@ 表示根域名，* 表示泛域名）
DDNS_SUBDOMAIN="@"

# IP 检查间隔（秒），默认 300 秒（5 分钟）
DDNS_INTERVAL="300"
```

### 如何获取 DNSPod Token？

1. 登录 [DNSPod 控制台](https://console.dnspod.cn/)
2. 进入 "用户中心" -> "安全设置" -> "API Token"
3. 点击 "创建 API Token"
4. 记录 ID 和 Token

### IPv6 配置

```bash
# IPv6 接口名称（通常是 WAN 口的接口名）
IPV6_INTERFACE="pppoe-wan"

# IPv6 地址前缀（用于筛选地址，通常是运营商分配的前缀）
IPV6_PREFIX="2409"
```

### 如何查找 IPv6 接口名？

```bash
# 方法 1：查看所有接口
ip -6 addr show

# 方法 2：查看网络接口
ifconfig

# 常见接口名：
# - pppoe-wan (PPPoE 拨号)
# - eth0.2 (静态 IPv6)
# - wan6 (IPv6 WAN)
```

### 端口转发配置

```bash
# 是否启用端口转发
SOCAT_ENABLE="true"

# 转发规则
# 格式：外部端口:内网IP:内网端口:描述
# 每行一条规则，空行会被忽略
FORWARDS="
22:192.168.1.100:22:SSH-Server
80:192.168.1.100:80:Web-Server
443:192.168.1.100:443:HTTPS-Server
3389:192.168.1.200:3389:RDP-Windows
5000:192.168.1.101:5000:DSM-HTTP
5001:192.168.1.101:5001:DSM-HTTPS
8080:192.168.1.102:8080:Custom-Service
"
```

### 转发规则示例

| 场景 | 配置示例 |
|------|---------|
| SSH 服务器 | `22:192.168.1.100:22:SSH` |
| Web 服务器 | `80:192.168.1.100:80:HTTP` |
| HTTPS 服务器 | `443:192.168.1.100:443:HTTPS` |
| 群晖 NAS | `5000:192.168.1.101:5000:DSM-HTTP`<br>`5001:192.168.1.101:5001:DSM-HTTPS` |
| 远程桌面 (Windows) | `3389:192.168.1.200:3389:RDP` |
| 远程桌面 (VNC) | `5900:192.168.1.200:5900:VNC` |
| 自定义服务 | `8080:192.168.1.102:8080:Custom` |

### 防火墙配置

```bash
# 是否自动管理防火墙规则
FIREWALL_ENABLE="true"

# 防火墙区域（通常是 wan）
FIREWALL_ZONE="wan"
```

### 监控配置

```bash
# 是否启用 IP 监控
MONITOR_ENABLE="true"

# IP 变化时是否记录日志
MONITOR_LOG_CHANGES="true"
```

---

## 🔧 进阶使用

### 自定义 DDNS 检查间隔

编辑配置文件，修改 `DDNS_INTERVAL` 参数：

```bash
# 每 1 分钟检查一次
DDNS_INTERVAL="60"

# 每 10 分钟检查一次
DDNS_INTERVAL="600"
```

修改后重启服务：

```bash
ddns-socat-manager restart
```

### 禁用某个功能

在配置文件中设置对应的 `ENABLE` 参数为 `false`：

```bash
# 禁用 DDNS，只使用端口转发
DDNS_ENABLE="false"

# 禁用端口转发，只使用 DDNS
SOCAT_ENABLE="false"

# 禁用防火墙自动管理
FIREWALL_ENABLE="false"

# 禁用 IP 监控
MONITOR_ENABLE="false"
```

### 查看详细日志

```bash
# 查看所有相关日志
logread | grep ddns-socat

# 实时查看日志
logread -f | grep ddns-socat

# 查看 DDNS 更新日志
logread | grep "DDNS updated"

# 查看端口转发日志
logread | grep "Started forward"
```

### 测试端口转发

从外网测试端口是否开放：

```bash
# 使用 telnet 测试
telnet [你的IPv6地址] 端口号

# 使用 nc (netcat) 测试
nc -zv -6 你的IPv6地址 端口号

# 使用在线工具
# https://www.yougetsignal.com/tools/open-ports/
# https://ipv6.test-ipv6.com/
```

### 手动管理防火墙规则

如果禁用了自动防火墙管理，可以手动添加规则：

```bash
# 添加规则
uci add firewall rule
uci set firewall.@rule[-1].name="MyRule"
uci set firewall.@rule[-1].src="wan"
uci set firewall.@rule[-1].dest_port="端口号"
uci set firewall.@rule[-1].target="ACCEPT"
uci set firewall.@rule[-1].proto="tcp"
uci set firewall.@rule[-1].family="ipv6"

# 提交并重启防火墙
uci commit firewall
/etc/init.d/firewall reload
```

---

## ❓ 常见问题

### 1. DDNS 更新失败怎么办？

**可能原因：**
- DNSPod ID/Token 不正确
- 域名未在 DNSPod 添加
- 网络连接问题

**解决方法：**
```bash
# 检查配置
ddns-socat-manager config

# 手动测试 DDNS 更新
ddns-socat-manager update-ddns

# 查看错误日志
ddns-socat-manager logs
```

### 2. 获取不到 IPv6 地址？

**可能原因：**
- 运营商未分配 IPv6
- 接口名称配置错误
- IPv6 前缀配置错误

**解决方法：**
```bash
# 查看所有 IPv6 地址
ip -6 addr show

# 检查当前 IPv6
ddns-socat-manager show-ipv6

# 修改配置中的接口名和前缀
ddns-socat-manager config
```

### 3. 端口转发不工作？

**可能原因：**
- 防火墙规则未生效
- Socat 进程未启动
- 内网服务未启动

**解决方法：**
```bash
# 查看服务状态
ddns-socat-manager status

# 检查 Socat 进程
ps | grep socat

# 检查防火墙规则
uci show firewall | grep DDNS-SOCAT

# 测试内网服务
telnet 内网IP 端口号
```

### 4. 如何更换端口转发规则？

**步骤：**
```bash
# 1. 编辑配置文件
ddns-socat-manager config

# 2. 修改 FORWARDS 部分
# 3. 保存退出

# 4. 重启服务
ddns-socat-manager restart
```

### 5. IPv6 地址变化后没有自动更新？

**可能原因：**
- 监控进程未运行
- 检查间隔设置过长

**解决方法：**
```bash
# 检查监控进程
ddns-socat-manager status

# 查看监控日志
logread | grep ddns-socat-monitor

# 重启服务
ddns-socat-manager restart
```

### 6. 如何完全卸载？

```bash
# 下载卸载脚本
wget https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/uninstall.sh

# 运行卸载
sh uninstall.sh
```

或者手动卸载：
```bash
# 停止并禁用服务
ddns-socat-manager stop
ddns-socat-manager disable

# 删除文件
rm -f /usr/bin/ddns-socat-manager
rm -f /usr/bin/ddns-socat-monitor
rm -f /etc/ddns-socat.conf
rm -f /etc/init.d/ddns-socat

# 清理防火墙规则（在管理脚本删除前执行）
# ddns-socat-manager 会自动清理
```

### 7. 开机后服务没有自动启动？

```bash
# 设置开机自启
ddns-socat-manager enable

# 检查自启动脚本
ls -l /etc/init.d/ddns-socat

# 手动测试启动
/etc/init.d/ddns-socat start
```

### 8. 如何使用多个域名？

目前每个实例只支持一个域名，如需多个域名，可以：

1. 在 DNSPod 设置 CNAME 记录指向主域名
2. 或者修改脚本支持多域名（需要自行修改）

### 9. 支持其他 DDNS 提供商吗？

当前版本仅支持腾讯云 DNSPod，后续版本计划支持：
- 阿里云 DNS
- Cloudflare
- 华为云 DNS
- AWS Route53

如需其他提供商，可以参考代码自行添加。

---

## 📝 更新日志

### v1.0.0 (2024-01-XX)

**首次发布**

- ✅ 支持 DNSPod DDNS 自动更新
- ✅ Socat 端口转发功能
- ✅ 自动防火墙规则管理
- ✅ IPv6 地址变化监控
- ✅ 一键安装/卸载脚本
- ✅ 完整的配置管理
- ✅ 系统日志记录
- ✅ 开机自启支持

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发计划

- [ ] 支持更多 DDNS 提供商
- [ ] Web UI 管理界面
- [ ] IPv4 DDNS 支持
- [ ] 多域名支持
- [ ] 邮件/Telegram 通知
- [ ] 访问统计功能

---

## 📄 开源协议

本项目采用 [MIT License](LICENSE) 开源协议。

---

## 🙏 致谢

- [OpenWrt](https://openwrt.org/) - 开源路由器系统
- [Socat](http://www.dest-unreach.org/socat/) - 多功能网络工具
- [DNSPod](https://www.dnspod.cn/) - 域名解析服务

---

## 📧 联系方式

- 提交 Issue: [GitHub Issues](https://github.com/yourusername/openwrt-socat-ddns/issues)
- 讨论区: [GitHub Discussions](https://github.com/yourusername/openwrt-socat-ddns/discussions)

---

<div align="center">

**如果这个项目对你有帮助，请给一个 ⭐ Star！**

Made with ❤️ by [Your Name]

</div>
