# 测试指南

在部署到生产环境之前，建议进行完整的测试。

## 🧪 测试环境要求

### 硬件要求
- OpenWrt 路由器（物理设备或虚拟机）
- 运营商分配的 IPv6 地址
- 内网测试设备

### 软件要求
- OpenWrt 18.06 或更高版本
- SSH 访问权限
- root 权限

---

## 📝 测试前准备

### 1. 语法检查（可选）

在本地检查脚本语法：

```bash
# 检查主脚本
sh -n ddns-socat-manager

# 检查监控脚本
sh -n ddns-socat-monitor

# 检查安装脚本
sh -n install.sh

# 检查卸载脚本
sh -n uninstall.sh
```

如果没有输出，说明语法正确。

### 2. 准备测试账号

- DNSPod 测试账号
- 测试域名
- 内网测试服务（如简单的 HTTP 服务器）

---

## 🔬 测试步骤

### 第一步：安装测试

#### 1.1 上传文件到 OpenWrt

```bash
# 在本地执行
scp -r ../openwrt-socat-ddns root@192.168.1.1:/tmp/
```

#### 1.2 SSH 登录并安装

```bash
# SSH 登录
ssh root@192.168.1.1

# 进入目录
cd /tmp/openwrt-socat-ddns

# 执行安装
sh install.sh
```

#### 1.3 验证安装

```bash
# 检查脚本是否安装
which ddns-socat-manager
# 预期输出: /usr/bin/ddns-socat-manager

# 检查版本
ddns-socat-manager version
```

### 第二步：配置测试

#### 2.1 编辑配置

```bash
ddns-socat-manager config
```

填入测试配置：

```bash
DDNS_ID="你的测试ID"
DDNS_TOKEN="你的测试Token"
DDNS_DOMAIN="test.example.com"
DDNS_SUBDOMAIN="@"
IPV6_INTERFACE="pppoe-wan"  # 根据实际修改
FORWARDS="
8080:192.168.1.100:80:Test-HTTP
"
```

#### 2.2 验证配置

```bash
# 查看配置文件
cat /etc/ddns-socat.conf

# 检查 IPv6 地址
ddns-socat-manager show-ipv6
```

### 第三步：功能测试

#### 3.1 DDNS 更新测试

```bash
# 手动更新 DDNS
ddns-socat-manager update-ddns

# 检查日志
ddns-socat-manager logs

# 验证 DNS 记录（从外网或使用在线工具）
# nslookup -type=AAAA test.example.com
```

预期结果：
- 显示 "DDNS 更新成功"
- 日志中有更新记录
- DNS 查询返回正确的 IPv6 地址

#### 3.2 端口转发测试

```bash
# 在内网启动测试服务
# 例如在 192.168.1.100 启动简单的 HTTP 服务器

# 启动服务
ddns-socat-manager start

# 检查 socat 进程
ps | grep socat

# 检查端口监听
netstat -tlnp | grep 8080
```

预期结果：
- socat 进程运行中
- 端口 8080 处于 LISTEN 状态

#### 3.3 防火墙测试

```bash
# 检查防火墙规则
uci show firewall | grep DDNS-SOCAT

# 查看状态
ddns-socat-manager status
```

预期结果：
- 防火墙规则已添加
- 状态显示规则数正确

#### 3.4 外网访问测试

从外网（或使用 IPv6 网络的设备）访问：

```bash
# 使用 IPv6 地址访问
curl -6 "http://[你的IPv6地址]:8080"

# 使用域名访问
curl -6 "http://test.example.com:8080"
```

预期结果：
- 能够访问内网服务
- 返回正确的内容

#### 3.5 监控进程测试

```bash
# 检查监控进程
ddns-socat-manager status

# 查看监控日志
logread | grep ddns-socat-monitor

# 手动触发 IP 变化（重启网络接口）
ifdown wan
sleep 5
ifup wan

# 等待 1-2 分钟后检查
ddns-socat-manager logs
```

预期结果：
- 监控进程正常运行
- 检测到 IP 变化
- 自动更新 DDNS
- 自动重启端口转发

### 第四步：服务管理测试

#### 4.1 启动/停止测试

```bash
# 停止服务
ddns-socat-manager stop

# 检查状态
ps | grep socat  # 应该没有进程
ddns-socat-manager status

# 启动服务
ddns-socat-manager start

# 再次检查
ddns-socat-manager status
```

#### 4.2 重启测试

```bash
# 重启服务
ddns-socat-manager restart

# 检查状态
ddns-socat-manager status
```

#### 4.3 开机自启测试

```bash
# 设置开机自启
ddns-socat-manager enable

# 检查自启脚本
ls -l /etc/init.d/ddns-socat

# 重启路由器
reboot

# 重启后检查服务状态
ddns-socat-manager status
```

### 第五步：卸载测试

```bash
# 下载卸载脚本（如果还没有）
cd /tmp/openwrt-socat-ddns

# 执行卸载
sh uninstall.sh

# 验证清理
which ddns-socat-manager  # 应该没有输出
ls /etc/ddns-socat.conf    # 如果选择删除配置，应该不存在
uci show firewall | grep DDNS-SOCAT  # 应该没有输出
```

---

## ✅ 测试检查清单

### 安装阶段
- [ ] 依赖包正确安装
- [ ] 脚本文件安装到正确位置
- [ ] 脚本具有执行权限
- [ ] 配置文件正确创建

### 配置阶段
- [ ] 配置文件可以正常编辑
- [ ] 配置项格式正确
- [ ] IPv6 接口名正确
- [ ] 能够获取 IPv6 地址

### DDNS 功能
- [ ] 能够连接 DNSPod API
- [ ] 能够创建 DNS 记录
- [ ] 能够修改 DNS 记录
- [ ] DNS 查询返回正确结果
- [ ] 日志记录正确

### 端口转发功能
- [ ] Socat 进程正常启动
- [ ] 端口正确监听
- [ ] 内网服务可访问
- [ ] 外网可以访问（通过 IPv6）
- [ ] 支持多个端口同时转发

### 防火墙功能
- [ ] 规则自动添加
- [ ] 规则格式正确
- [ ] 规则生效
- [ ] 停止服务时规则删除
- [ ] 重启后规则重新添加

### 监控功能
- [ ] 监控进程正常启动
- [ ] PID 文件正确创建
- [ ] 能够检测 IP 变化
- [ ] IP 变化时自动更新 DDNS
- [ ] IP 变化时自动重启转发
- [ ] 监控日志正确记录

### 服务管理
- [ ] start 命令正常工作
- [ ] stop 命令正常工作
- [ ] restart 命令正常工作
- [ ] status 命令正确显示状态
- [ ] logs 命令正确显示日志
- [ ] enable/disable 正常工作
- [ ] 开机自启正常工作

### 卸载功能
- [ ] 服务正确停止
- [ ] 脚本文件删除
- [ ] 配置文件处理正确
- [ ] 防火墙规则清理
- [ ] 临时文件清理

---

## 🐛 常见测试问题

### 问题 1：无法获取 IPv6 地址

**排查步骤：**
```bash
# 查看所有 IPv6 地址
ip -6 addr show

# 检查接口名
uci show network
```

### 问题 2：DDNS 更新失败

**排查步骤：**
```bash
# 手动测试 DNSPod API
curl -X POST https://dnsapi.cn/Record.List \
  -d "login_token=ID,Token" \
  -d "format=json" \
  -d "domain=example.com"

# 查看详细错误
ddns-socat-manager update-ddns
```

### 问题 3：端口无法访问

**排查步骤：**
```bash
# 检查 socat 进程
ps | grep socat

# 检查端口监听
netstat -tlnp | grep 端口号

# 检查内网服务
telnet 内网IP 端口号

# 检查防火墙
iptables -L -n -v | grep 端口号
```

---

## 📊 性能测试

### 资源占用测试

```bash
# 查看内存占用
top -n 1 | grep -E "ddns-socat|socat"

# 查看 CPU 占用
top -b -n 10 -d 1 | grep -E "ddns-socat|socat"
```

预期结果：
- 监控进程内存占用 < 5MB
- 每个 socat 进程内存占用 < 2MB
- CPU 占用基本为 0（空闲时）

### 稳定性测试

```bash
# 长时间运行测试
# 运行 24 小时后检查
ddns-socat-manager status
ddns-socat-manager logs

# 检查进程是否还在运行
ps | grep -E "ddns-socat|socat"
```

---

## 📝 测试报告模板

```
测试日期：YYYY-MM-DD
测试人员：XXX
测试环境：OpenWrt XX.XX

一、环境信息
- 路由器型号：
- OpenWrt 版本：
- 运营商：
- IPv6 地址段：

二、测试结果
1. 安装测试：[ ] 通过 [ ] 失败
2. DDNS 测试：[ ] 通过 [ ] 失败
3. 端口转发测试：[ ] 通过 [ ] 失败
4. 防火墙测试：[ ] 通过 [ ] 失败
5. 监控测试：[ ] 通过 [ ] 失败
6. 服务管理测试：[ ] 通过 [ ] 失败
7. 卸载测试：[ ] 通过 [ ] 失败

三、发现的问题
1. 问题描述
2. 复现步骤
3. 解决方案

四、建议和改进
...
```

---

## 🔄 持续测试

建议在以下情况下重新测试：

- 代码更新后
- OpenWrt 版本升级后
- 添加新功能后
- 修复 Bug 后
- 生产环境部署前

---

**测试完成后，欢迎反馈测试结果和建议！**

