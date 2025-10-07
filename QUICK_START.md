# 快速开始指南

## 📝 安装前准备

### 1. 确认运营商已分配 IPv6

```bash
# SSH 登录 OpenWrt 后执行
ip -6 addr show
```

如果看到类似 `2409:xxxx:xxxx:xxxx` 的地址，说明已获取到 IPv6。

### 2. 准备 DNSPod 账号

1. 注册 [DNSPod 账号](https://www.dnspod.cn/)
2. 添加你的域名
3. 获取 API Token（用户中心 -> 安全设置 -> API Token）

---

## 🚀 一键安装

### SSH 登录到 OpenWrt

```bash
ssh root@192.168.1.1
```

### 执行安装命令

```bash
wget -O - https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/install.sh | sh
```

或者使用 curl：

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/install.sh | sh
```

---

## ⚙️ 基础配置

### 1. 编辑配置文件

```bash
ddns-socat-manager config
```

### 2. 修改关键配置

按 `i` 进入编辑模式，修改以下内容：

```bash
# DNSPod 配置
DDNS_ID="你的ID"                    # 替换为实际的 DNSPod ID
DDNS_TOKEN="你的Token"              # 替换为实际的 DNSPod Token
DDNS_DOMAIN="yourdomain.com"       # 替换为你的域名

# IPv6 接口（根据第一步查到的接口名）
IPV6_INTERFACE="pppoe-wan"         # 可能需要修改

# 端口转发规则（根据实际需求修改）
FORWARDS="
22:192.168.1.100:22:SSH
80:192.168.1.100:80:Web
"
```

按 `ESC` 退出编辑，输入 `:wq` 保存退出。

---

## ▶️ 启动服务

```bash
ddns-socat-manager start
```

---

## ✅ 验证运行

### 查看状态

```bash
ddns-socat-manager status
```

输出应该类似：

```
=== 服务状态 ===

IPv6 地址：2409:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx

DDNS 状态：
  状态: 已启用
  域名: yourdomain.com
  上次更新: 2409:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx

端口转发状态：
  状态: 运行中
  进程数: 2

IP 监控状态：
  状态: 运行中 (PID: 12345)
```

### 查看日志

```bash
ddns-socat-manager logs
```

### 测试 DDNS

```bash
# 从外网 ping 你的域名（需要支持 IPv6 的网络）
ping6 yourdomain.com

# 或者使用在线工具查询 DNS 记录
# https://www.ipip.net/dns.html
```

---

## 🔄 设置开机自启

```bash
ddns-socat-manager enable
```

---

## 📱 常用场景配置

### 场景 1：群晖 NAS 外网访问

假设群晖 IP 是 `192.168.1.101`

```bash
FORWARDS="
5000:192.168.1.101:5000:DSM-HTTP
5001:192.168.1.101:5001:DSM-HTTPS
"
```

访问方式：
- HTTP: `http://[你的域名]:5000`
- HTTPS: `https://[你的域名]:5001`

### 场景 2：SSH 远程管理

```bash
FORWARDS="
22:192.168.1.100:22:SSH
"
```

访问方式：
```bash
ssh -6 user@yourdomain.com
```

### 场景 3：Web 服务器

```bash
FORWARDS="
80:192.168.1.100:80:HTTP
443:192.168.1.100:443:HTTPS
"
```

访问方式：
- HTTP: `http://[你的域名]`
- HTTPS: `https://[你的域名]`

---

## 🔧 常用命令

```bash
# 查看状态
ddns-socat-manager status

# 重启服务
ddns-socat-manager restart

# 查看日志
ddns-socat-manager logs

# 查看转发规则
ddns-socat-manager list-forwards

# 查看当前 IPv6
ddns-socat-manager show-ipv6

# 手动更新 DDNS
ddns-socat-manager update-ddns

# 编辑配置
ddns-socat-manager config

# 停止服务
ddns-socat-manager stop
```

---

## ❌ 卸载

```bash
wget https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/uninstall.sh
sh uninstall.sh
```

---

## ⚠️ 注意事项

1. **安全建议**
   - 不要开放所有端口，只开放必要的端口
   - SSH 建议修改默认端口 22
   - 建议使用密钥登录代替密码
   - 重要服务建议启用防暴力破解（如 fail2ban）

2. **运营商限制**
   - 部分运营商可能限制某些端口（如 80、443）
   - 如果无法访问，尝试更换端口

3. **IPv6 地址变化**
   - 运营商可能定期更换 IPv6 地址
   - 本工具会自动检测并更新 DDNS
   - 默认每 5 分钟检查一次

4. **防火墙**
   - 工具会自动管理防火墙规则
   - 如需手动管理，设置 `FIREWALL_ENABLE="false"`

---

## 🆘 遇到问题？

### 问题 1：无法获取 IPv6

```bash
# 检查接口名
ip -6 addr show

# 检查是否获取到 IPv6
ddns-socat-manager show-ipv6
```

解决：修改配置文件中的 `IPV6_INTERFACE` 和 `IPV6_PREFIX`

### 问题 2：DDNS 更新失败

```bash
# 查看详细日志
ddns-socat-manager logs

# 手动测试更新
ddns-socat-manager update-ddns
```

解决：检查 DNSPod ID/Token 是否正确

### 问题 3：端口无法访问

```bash
# 检查服务状态
ddns-socat-manager status

# 检查 socat 进程
ps | grep socat

# 检查防火墙
uci show firewall | grep DDNS-SOCAT
```

解决：
1. 确认内网服务已启动
2. 确认防火墙规则已添加
3. 确认运营商未限制端口

### 问题 4：服务没有自动启动

```bash
# 设置开机自启
ddns-socat-manager enable

# 检查自启脚本
ls -l /etc/init.d/ddns-socat
```

---

## 📚 更多帮助

- 完整文档：[README.md](README.md)
- 配置示例：[ddns-socat.conf.example](ddns-socat.conf.example)
- 提交问题：[GitHub Issues](https://github.com/yourusername/openwrt-socat-ddns/issues)

---

**恭喜！你已经完成了基本配置，现在可以通过 IPv6 访问内网服务了！** 🎉

