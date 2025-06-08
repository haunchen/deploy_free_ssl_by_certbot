# Free SSL Certificate Deployment with Certbot

[![Shell Script Validation](https://github.com/haunchen/certbot-deploy/actions/workflows/validation.yml/badge.svg)](https://github.com/haunchen/certbot-deploy/actions/workflows/validation.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

這是一個簡單易用的腳本集合，用於在 Ubuntu/Debian 系統上安裝 Certbot 並自動部署 Let's Encrypt SSL 證書到 Nginx。

## 功能特點

- ✅ 自動安裝 Certbot 和必要依賴
- ✅ 支援 Nginx 自動配置
- ✅ 安全的 SSL 配置（包含安全標頭）
- ✅ 自動 HTTP 到 HTTPS 重定向
- ✅ 完整的錯誤檢查和驗證
- ✅ 清理失敗的配置

## 系統需求

- Ubuntu 18.04+ 或 Debian 9+
- Root 權限或 sudo 權限
- 已配置的域名指向伺服器
- 開放的 80 和 443 端口

## 📋 文檔目錄

- [快速開始指南](QUICKSTART.md) - 一步一步的詳細安裝指南
- [配置範例](examples/) - 各種用途的 Nginx 配置範例
- [貢獻指南](CONTRIBUTING.md) - 如何參與專案開發
- [安全政策](SECURITY.md) - 安全問題回報指南
- [變更日誌](CHANGELOG.md) - 版本更新記錄

## 🚀 快速開始

### 方法一：一鍵部署
```bash
# 下載專案
git clone https://github.com/haunchen/certbot-deploy.git
cd certbot-deploy

# 一次性完成安裝和部署
sudo ./install.sh && sudo ./deploy.sh your-domain.com
```

### 方法二：分步執行

#### 1. 安裝 Certbot

首先運行安裝腳本來安裝 Certbot 和 Nginx：

```bash
sudo ./install.sh
```

這個腳本將會：
- 更新系統包列表
- 安裝 Python3、venv 和其他必要依賴
- 安裝 Nginx
- 在虛擬環境中安裝 Certbot
- 創建 Certbot 的全域符號連結

### 2. 部署 SSL 證書

安裝完成後，為您的域名部署 SSL 證書：

```bash
sudo ./deploy.sh your-domain.com
```

這個腳本將會：
- 驗證域名格式
- 檢查 Nginx 和 Certbot 是否正常運行
- 獲取 Let's Encrypt SSL 證書
- 創建優化的 Nginx 配置
- 測試並重載 Nginx 配置

## 使用範例

```bash
# 安裝 Certbot
sudo ./install.sh

# 為 www.example.com 部署 SSL
sudo ./deploy.sh www.example.com

# 為 blog.example.com 部署 SSL
sudo ./deploy.sh blog.example.com
```

## 🧪 測試和驗證

部署完成後，使用我們提供的測試腳本驗證 SSL 配置：

```bash
./test-ssl.sh your-domain.com
```

這個腳本會檢查：
- DNS 解析
- 端口連通性  
- HTTP 重定向
- SSL 證書有效性
- HTTPS 連接
- 安全標頭
- Nginx 配置

## 📁 專案結構

```
certbot-deploy/
├── install.sh              # Certbot 安裝腳本
├── deploy.sh               # SSL 部署腳本  
├── test-ssl.sh             # SSL 測試腳本
├── QUICKSTART.md           # 快速開始指南
├── examples/               # 配置範例
│   ├── basic-site.conf     # 靜態網站配置
│   ├── php-site.conf       # PHP 應用配置
│   └── nodejs-app.conf     # Node.js 應用配置
├── .github/                # GitHub 配置
│   ├── workflows/          # CI/CD 工作流程
│   └── ISSUE_TEMPLATE/     # Issue 模板
└── docs/                   # 文檔
```

## 生成的 Nginx 配置

腳本會自動生成包含以下功能的 Nginx 配置：

- HTTP 到 HTTPS 自動重定向
- 現代 SSL 配置
- 安全標頭（X-Frame-Options, XSS Protection 等）
- 訪問和錯誤日誌
- Let's Encrypt 推薦的 SSL 設定

配置文件位置：
- 主配置：`/etc/nginx/sites-available/your-domain.com`
- 符號連結：`/etc/nginx/sites-enabled/your-domain.com`

## 證書自動更新

Let's Encrypt 證書每 90 天到期。您可以設置 cron 任務來自動更新：

```bash
# 編輯 crontab
sudo crontab -e

# 添加以下行（每天檢查兩次）
0 12 * * * /usr/bin/certbot renew --quiet
0 0 * * * /usr/bin/certbot renew --quiet
```

## 故障排除

### 常見問題

1. **域名無法驗證**
   - 確保域名已指向您的伺服器
   - 檢查防火牆設置（需要開放 80 和 443 端口）
   - 確認 Nginx 正在運行

2. **Nginx 配置測試失敗**
   - 檢查語法錯誤：`sudo nginx -t`
   - 查看錯誤日誌：`sudo journalctl -u nginx`

3. **證書文件不存在**
   - 重新運行 certbot：`sudo certbot certonly --nginx -d your-domain.com`
   - 檢查 Let's Encrypt 日誌：`sudo cat /var/log/letsencrypt/letsencrypt.log`

### 手動檢查證書

```bash
# 檢查證書狀態
sudo certbot certificates

# 測試證書更新（不實際更新）
sudo certbot renew --dry-run

# 查看證書詳細信息
openssl x509 -in /etc/letsencrypt/live/your-domain.com/cert.pem -text -noout
```

## 安全注意事項

- 腳本需要 root 權限運行
- 建議在測試環境中先行測試
- 定期備份您的 Nginx 配置
- 監控證書到期日期

## 貢獻

歡迎提交 Issue 和 Pull Request 來改進這個專案！請先閱讀我們的 [貢獻指南](CONTRIBUTING.md)。

### 開發者

- 檢查程式碼風格：我們使用 ShellCheck 進行靜態分析
- 測試：請在 Ubuntu/Debian 環境中測試您的修改
- 文檔：更新相關文檔

## 版本歷史

查看 [CHANGELOG.md](CHANGELOG.md) 了解詳細的版本歷史。

## 安全性

如果您發現安全問題，請查看我們的 [安全政策](SECURITY.md)。

## 授權

本專案使用 MIT 授權 - 查看 [LICENSE](LICENSE) 文件了解詳情。

## 致謝

- [Let's Encrypt](https://letsencrypt.org/) - 提供免費 SSL 證書
- [Certbot](https://certbot.eff.org/) - 優秀的 ACME 客戶端
- [Nginx](https://nginx.org/) - 高性能 web 伺服器

## 作者

👨‍💻 **Frank Chen (haunchen)**

- 🌐 部落格：[https://blog.frankchen.tw](https://blog.frankchen.tw)
- 💻 GitHub：[@haunchen](https://github.com/haunchen)

## 星星歷史

[![Star History Chart](https://api.star-history.com/svg?repos=haunchen/certbot-deploy&type=Date)](https://star-history.com/#haunchen/certbot-deploy&Date)

---

**⭐ 如果這個專案對您有幫助，請給它一個星星！**

## 相關資源

- [Let's Encrypt 官網](https://letsencrypt.org/)
- [Certbot 文檔](https://certbot.eff.org/)
- [Nginx SSL 配置指南](https://nginx.org/en/docs/http/configuring_https_servers.html)

---

# English Version

A simple and easy-to-use script collection for installing Certbot and automatically deploying Let's Encrypt SSL certificates to Nginx on Ubuntu/Debian systems.

## Features

- ✅ Automatic Certbot and dependency installation
- ✅ Nginx automatic configuration support
- ✅ Secure SSL configuration (including security headers)
- ✅ Automatic HTTP to HTTPS redirection
- ✅ Complete error checking and validation
- ✅ Failed configuration cleanup

## System Requirements

- Ubuntu 18.04+ or Debian 9+
- Root privileges or sudo access
- Configured domain pointing to server
- Open ports 80 and 443

## 📋 Documentation Index

- [Quick Start Guide](QUICKSTART.md) - Step-by-step detailed installation guide
- [Configuration Examples](examples/) - Nginx configuration examples for various purposes
- [Contributing Guide](CONTRIBUTING.md) - How to participate in project development
- [Security Policy](SECURITY.md) - Security issue reporting guide
- [Changelog](CHANGELOG.md) - Version update history

## 🚀 Quick Start

### Method 1: One-Click Deployment
```bash
# Download project
git clone https://github.com/haunchen/certbot-deploy.git
cd certbot-deploy

# Complete installation and deployment in one go
sudo ./install.sh && sudo ./deploy.sh your-domain.com
```

### Method 2: Step-by-Step Execution

#### 1. Install Certbot

First run the installation script to install Certbot and Nginx:

```bash
sudo ./install.sh
```

This script will:
- Update system package list
- Install Python3, venv and other necessary dependencies
- Install Nginx
- Install Certbot in a virtual environment
- Create global symbolic link for Certbot

#### 2. Deploy SSL Certificate

After installation, deploy SSL certificate for your domain:

```bash
sudo ./deploy.sh your-domain.com
```

This script will:
- Validate domain format
- Check if Nginx and Certbot are running properly
- Obtain Let's Encrypt SSL certificate
- Create optimized Nginx configuration
- Test and reload Nginx configuration

## Usage Examples

```bash
# Install Certbot
sudo ./install.sh

# Deploy SSL for www.example.com
sudo ./deploy.sh www.example.com

# Deploy SSL for blog.example.com
sudo ./deploy.sh blog.example.com
```

## 🧪 Testing and Validation

After deployment, use our provided test script to validate SSL configuration:

```bash
./test-ssl.sh your-domain.com
```

This script checks:
- DNS resolution
- Port connectivity
- HTTP redirection
- SSL certificate validity
- HTTPS connection
- Security headers
- Nginx configuration

## 📁 Project Structure

```
certbot-deploy/
├── install.sh              # Certbot installation script
├── deploy.sh               # SSL deployment script
├── test-ssl.sh             # SSL testing script
├── QUICKSTART.md           # Quick start guide
├── examples/               # Configuration examples
│   ├── basic-site.conf     # Static website configuration
│   ├── php-site.conf       # PHP application configuration
│   └── nodejs-app.conf     # Node.js application configuration
├── .github/                # GitHub configuration
│   ├── workflows/          # CI/CD workflows
│   └── ISSUE_TEMPLATE/     # Issue templates
└── docs/                   # Documentation
```

## Generated Nginx Configuration

The script automatically generates Nginx configuration with the following features:

- Automatic HTTP to HTTPS redirection
- Modern SSL configuration
- Security headers (X-Frame-Options, XSS Protection, etc.)
- Access and error logs
- Let's Encrypt recommended SSL settings

Configuration file locations:
- Main configuration: `/etc/nginx/sites-available/your-domain.com`
- Symbolic link: `/etc/nginx/sites-enabled/your-domain.com`

## Automatic Certificate Renewal

Let's Encrypt certificates expire every 90 days. You can set up cron jobs for automatic renewal:

```bash
# Edit crontab
sudo crontab -e

# Add the following lines (check twice daily)
0 12 * * * /usr/bin/certbot renew --quiet
0 0 * * * /usr/bin/certbot renew --quiet
```

## Troubleshooting

### Common Issues

1. **Domain validation failed**
   - Ensure domain points to your server
   - Check firewall settings (ports 80 and 443 must be open)
   - Confirm Nginx is running

2. **Nginx configuration test failed**
   - Check syntax errors: `sudo nginx -t`
   - View error logs: `sudo journalctl -u nginx`

3. **Certificate files do not exist**
   - Re-run certbot: `sudo certbot certonly --nginx -d your-domain.com`
   - Check Let's Encrypt logs: `sudo cat /var/log/letsencrypt/letsencrypt.log`

### Manual Certificate Verification

```bash
# Check certificate status
sudo certbot certificates

# Test certificate renewal (dry run)
sudo certbot renew --dry-run

# View certificate details
openssl x509 -in /etc/letsencrypt/live/your-domain.com/cert.pem -text -noout
```

## Security Considerations

- Scripts require root privileges to run
- Recommended to test in test environment first
- Regularly backup your Nginx configuration
- Monitor certificate expiration dates

## Contributing

Welcome to submit Issues and Pull Requests to improve this project! Please read our [Contributing Guide](CONTRIBUTING.md) first.

### For Developers

- Code style check: We use ShellCheck for static analysis
- Testing: Please test your changes in Ubuntu/Debian environment
- Documentation: Update relevant documentation

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## Security

If you discover security issues, please see our [Security Policy](SECURITY.md).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Let's Encrypt](https://letsencrypt.org/) - Providing free SSL certificates
- [Certbot](https://certbot.eff.org/) - Excellent ACME client
- [Nginx](https://nginx.org/) - High-performance web server

## Author

👨‍💻 **Frank Chen (haunchen)**

- 🌐 Blog: [https://blog.frankchen.tw](https://blog.frankchen.tw)
- 💻 GitHub: [@haunchen](https://github.com/haunchen)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=haunchen/certbot-deploy&type=Date)](https://star-history.com/#haunchen/certbot-deploy&Date)

---

**⭐ If this project helps you, please give it a star!**

## Related Resources

- [Let's Encrypt Official Website](https://letsencrypt.org/)
- [Certbot Documentation](https://certbot.eff.org/)
- [Nginx SSL Configuration Guide](https://nginx.org/en/docs/http/configuring_https_servers.html)
