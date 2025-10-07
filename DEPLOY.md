# 部署指南

本文档介绍如何将项目部署到 GitHub 并让用户可以直接在线安装。

---

## 📦 GitHub 部署步骤

### 1. 创建 GitHub 仓库

1. 登录 GitHub
2. 点击右上角 "+" -> "New repository"
3. 填写仓库信息：
   - 仓库名：`openwrt-socat-ddns`
   - 描述：OpenWrt IPv6 DDNS & Socat 自动化管理工具
   - 选择 Public（公开）
   - 添加 README（已有，可跳过）
   - 选择 MIT License

### 2. 初始化本地仓库

```bash
cd /path/to/openwrt-socat-ddns

# 初始化 git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "feat: 初始版本发布"

# 添加远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/yourusername/openwrt-socat-ddns.git

# 推送到 GitHub
git push -u origin main
```

### 3. 更新安装脚本中的 URL

编辑 `install.sh` 和 `README.md`，将所有 URL 中的 `yourusername` 替换为你的 GitHub 用户名：

```bash
# 在 install.sh 中
REPO_URL="https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main"

# 在 README.md 和其他文档中
https://github.com/yourusername/openwrt-socat-ddns
```

替换为：

```bash
REPO_URL="https://raw.githubusercontent.com/实际用户名/openwrt-socat-ddns/main"
https://github.com/实际用户名/openwrt-socat-ddns
```

### 4. 提交更新

```bash
git add .
git commit -m "docs: 更新项目 URL"
git push
```

---

## 🏷️ 发布版本

### 创建第一个 Release

1. 在 GitHub 仓库页面，点击 "Releases"
2. 点击 "Create a new release"
3. 填写信息：
   - Tag: `v1.0.0`
   - Title: `v1.0.0 - 首次发布`
   - Description: 复制 CHANGELOG.md 中的内容

4. 点击 "Publish release"

---

## 📝 完善 GitHub 仓库

### 1. 添加 Topics

在仓库页面点击 "Add topics"，添加相关标签：

```
openwrt
ipv6
ddns
socat
port-forwarding
dnspod
shell
nas
homelab
```

### 2. 设置仓库描述

在仓库设置中添加描述：

```
一键配置 OpenWrt 外网 IPv6 访问内网服务 - 支持 DDNS 自动更新、端口转发、防火墙联动
```

### 3. 添加项目主页

如果有文档站点，可以添加到项目主页。

### 4. 启用 Discussions（可选）

在仓库设置中启用 Discussions，方便用户讨论。

### 5. 设置 Issue 模板

创建 `.github/ISSUE_TEMPLATE/bug_report.md`：

```markdown
---
name: Bug 报告
about: 报告一个问题
title: '[BUG] '
labels: bug
assignees: ''
---

**问题描述**
简洁明了地描述问题。

**复现步骤**
1. 执行 '...'
2. 点击 '....'
3. 看到错误

**预期行为**
描述你期望发生什么。

**实际行为**
描述实际发生了什么。

**环境信息**
- OpenWrt 版本：
- 运营商：
- 路由器型号：
- 脚本版本：

**日志**
```
粘贴相关日志
```

**截图**
如果适用，添加截图。
```

创建 `.github/ISSUE_TEMPLATE/feature_request.md`：

```markdown
---
name: 功能建议
about: 建议一个新功能
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

**功能描述**
你希望添加什么功能？

**使用场景**
这个功能在什么情况下有用？

**替代方案**
你考虑过的其他解决方案。

**其他信息**
其他相关信息。
```

---

## 🚀 用户安装方式

部署完成后，用户可以通过以下方式安装：

### 方式 1：一键在线安装（推荐）

```bash
wget -O - https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/install.sh | sh
```

或

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/openwrt-socat-ddns/main/install.sh | sh
```

### 方式 2：下载后安装

```bash
# 下载整个项目
wget https://github.com/yourusername/openwrt-socat-ddns/archive/refs/heads/main.zip
unzip main.zip
cd openwrt-socat-ddns-main
sh install.sh
```

### 方式 3：Git 克隆安装

```bash
# 需要先安装 git
opkg update
opkg install git

# 克隆仓库
git clone https://github.com/yourusername/openwrt-socat-ddns.git
cd openwrt-socat-ddns
sh install.sh
```

---

## 📊 添加徽章

在 README.md 顶部添加徽章（已在 README.md 中）：

```markdown
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-OpenWrt-orange)
![Stars](https://img.shields.io/github/stars/yourusername/openwrt-socat-ddns)
![Forks](https://img.shields.io/github/forks/yourusername/openwrt-socat-ddns)
![Issues](https://img.shields.io/github/issues/yourusername/openwrt-socat-ddns)
```

---

## 🔄 持续维护

### 1. 处理 Issues

- 及时回复用户问题
- 标记 Issue 类型（bug、enhancement、question 等）
- 关闭已解决的 Issue

### 2. 审查 Pull Requests

- 检查代码质量
- 测试功能
- 及时合并或反馈

### 3. 更新文档

- 根据反馈完善文档
- 添加更多使用示例
- 更新常见问题

### 4. 发布新版本

```bash
# 修改代码并测试

# 更新版本号
# 在 ddns-socat-manager 和 install.sh 中更新 VERSION

# 更新 CHANGELOG.md

# 提交
git add .
git commit -m "feat: 添加新功能"
git push

# 创建 tag
git tag v1.1.0
git push origin v1.1.0

# 在 GitHub 创建 Release
```

---

## 📢 推广项目

### 1. 社区分享

分享到相关社区：

- [OpenWrt 论坛](https://forum.openwrt.org/)
- [恩山论坛](https://www.right.com.cn/forum/)
- V2EX
- Reddit r/openwrt
- 知乎
- 博客园

### 2. 撰写教程

- 写详细的使用教程
- 录制视频教程
- 发布到 YouTube/B站

### 3. 申请收录

申请收录到：

- [Awesome OpenWrt](https://github.com/topics/openwrt)
- OpenWrt 软件包列表

---

## 🔐 安全注意事项

### 1. 保护敏感信息

- 不要在代码中硬编码密码/Token
- 配置文件示例不要包含真实凭据
- .gitignore 中排除配置文件

### 2. 代码审查

- 定期审查代码安全性
- 检查是否有注入漏洞
- 验证用户输入

### 3. 依赖安全

- 关注依赖包的安全更新
- 及时更新文档

---

## 📈 监控项目

### GitHub Insights

定期查看：

- Star 数量趋势
- Fork 数量
- Issue 关闭率
- PR 合并情况
- 流量统计

### 用户反馈

收集和分析：

- Issue 中的问题
- Discussion 中的讨论
- 社区反馈

---

## ✅ 部署检查清单

部署前检查：

- [ ] 所有文档中的 URL 已更新
- [ ] LICENSE 文件存在
- [ ] README.md 完整且格式正确
- [ ] CHANGELOG.md 已更新
- [ ] .gitignore 配置正确
- [ ] 所有脚本可以正常执行
- [ ] 配置示例不包含敏感信息
- [ ] 版本号统一

部署后检查：

- [ ] GitHub 仓库可访问
- [ ] README 正确显示
- [ ] 在线安装脚本可用
- [ ] Release 创建成功
- [ ] Topics 已添加
- [ ] Issue 模板可用

---

**完成以上步骤后，你的项目就可以让全世界的用户使用了！** 🎉

