# 贡献指南

感谢你对本项目的关注！我们欢迎任何形式的贡献。

## 📝 如何贡献

### 报告 Bug

如果你发现了 Bug，请：

1. 检查 [Issues](https://github.com/yourusername/openwrt-socat-ddns/issues) 确认是否已有相同问题
2. 如果没有，创建新的 Issue，包含：
   - 清晰的标题
   - 详细的问题描述
   - 复现步骤
   - 预期行为和实际行为
   - 系统环境信息（OpenWrt 版本等）
   - 相关日志

### 功能建议

如果你有新功能的想法：

1. 先在 [Discussions](https://github.com/yourusername/openwrt-socat-ddns/discussions) 讨论
2. 说明功能的使用场景和价值
3. 如果得到认可，可以创建 Feature Request Issue

### 提交代码

#### 开发流程

1. **Fork 项目**
   ```bash
   # 在 GitHub 上 Fork 本仓库
   ```

2. **克隆到本地**
   ```bash
   git clone https://github.com/your-username/openwrt-socat-ddns.git
   cd openwrt-socat-ddns
   ```

3. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或
   git checkout -b fix/your-bug-fix
   ```

4. **进行修改**
   - 遵循代码风格
   - 添加必要的注释
   - 更新相关文档

5. **测试**
   ```bash
   # 在 OpenWrt 环境中测试你的修改
   sh install.sh
   ddns-socat-manager start
   ```

6. **提交修改**
   ```bash
   git add .
   git commit -m "feat: 添加新功能说明"
   # 或
   git commit -m "fix: 修复某个问题"
   ```

7. **推送到 GitHub**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **创建 Pull Request**
   - 在 GitHub 上创建 PR
   - 填写 PR 模板
   - 等待 Review

#### 提交信息规范

使用语义化的提交信息：

- `feat:` 新功能
- `fix:` 修复 Bug
- `docs:` 文档更新
- `style:` 代码格式调整（不影响功能）
- `refactor:` 重构（不添加功能也不修复 Bug）
- `test:` 添加测试
- `chore:` 构建过程或辅助工具的变动

示例：
```
feat: 添加阿里云 DNS 支持
fix: 修复 IPv6 地址获取失败的问题
docs: 更新安装文档
```

## 🎨 代码规范

### Shell 脚本规范

1. **使用 POSIX 兼容的 shell 语法**
   ```bash
   #!/bin/sh
   # 不要使用 bash 特有语法
   ```

2. **变量命名**
   ```bash
   # 全局变量使用大写
   CONFIG_FILE="/etc/ddns-socat.conf"
   
   # 局部变量使用小写
   local ipv6=$(get_ipv6)
   ```

3. **函数定义**
   ```bash
   # 函数名使用小写，使用下划线分隔
   function_name() {
       local param=$1
       # 函数体
   }
   ```

4. **错误处理**
   ```bash
   # 检查命令执行结果
   if ! command -v socat >/dev/null 2>&1; then
       echo "Error: socat not found"
       return 1
   fi
   ```

5. **注释**
   ```bash
   # 单行注释说明下面的代码
   
   # 多行注释说明复杂逻辑
   # 第二行
   # 第三行
   ```

### 文档规范

1. **使用中文文档**
   - 主要文档使用简体中文
   - 代码注释可以使用英文或中文

2. **Markdown 格式**
   - 使用标准 Markdown 语法
   - 代码块指定语言
   - 适当使用表格和列表

3. **示例代码**
   - 提供完整可运行的示例
   - 添加注释说明

## 🧪 测试

### 测试环境

推荐的测试环境：

- OpenWrt 19.07 或更高版本
- 真实的 IPv6 网络环境
- DNSPod 测试账号

### 测试清单

在提交 PR 前，请确保：

- [ ] 代码在 OpenWrt 环境中正常运行
- [ ] 安装脚本测试通过
- [ ] DDNS 更新功能正常
- [ ] 端口转发功能正常
- [ ] 防火墙规则正确添加/删除
- [ ] 监控进程正常工作
- [ ] 日志记录正确
- [ ] 卸载脚本清理完整
- [ ] 文档更新完整

## 📚 开发建议

### 添加新的 DDNS 提供商

1. 在 `ddns-socat-manager` 中添加新的提供商支持
2. 参考 DNSPod 的实现方式
3. 添加配置项到配置文件模板
4. 更新文档说明

示例结构：
```bash
case "$DDNS_PROVIDER" in
    dnspod)
        # DNSPod 实现
        ;;
    aliyun)
        # 阿里云实现
        ;;
    cloudflare)
        # Cloudflare 实现
        ;;
esac
```

### 优化建议

- 保持脚本简洁高效
- 避免不必要的依赖
- 充分利用 OpenWrt 内置工具
- 考虑低配置设备的性能
- 添加详细的错误处理

## 🤝 行为准则

- 尊重所有贡献者
- 保持友好和专业的沟通
- 接受建设性的批评
- 关注项目的整体利益

## 📧 联系方式

- GitHub Issues: [提交问题](https://github.com/yourusername/openwrt-socat-ddns/issues)
- GitHub Discussions: [参与讨论](https://github.com/yourusername/openwrt-socat-ddns/discussions)

## 🎉 贡献者

感谢所有为本项目做出贡献的开发者！

<!-- 
贡献者列表会自动生成
Contributors list will be auto-generated
-->

---

再次感谢你的贡献！

