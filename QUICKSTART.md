# 快速開始指南

## 前置需求檢查

在開始之前，請確保：

```bash
# 檢查作業系統版本
lsb_release -a

# 檢查是否有 sudo 權限
sudo whoami

# 檢查網路連線
ping -c 3 google.com

# 檢查端口是否開放（可選）
sudo netstat -tlnp | grep ':80\|:443'
```

## 一鍵安裝腳本

如果您想要一次性執行所有步驟：

```bash
# 下載專案
git clone https://github.com/haunchen/certbot-deploy.git
cd certbot-deploy

# 設定執行權限
chmod +x install.sh deploy.sh

# 安裝 Certbot (需要 sudo)
sudo ./install.sh

# 部署 SSL 證書 (替換 your-domain.com)
sudo ./deploy.sh your-domain.com
```

## 逐步說明

### 步驟 1: 下載和準備

```bash
# 方法 1: 使用 git
git clone https://github.com/haunchen/certbot-deploy.git

# 方法 2: 下載 ZIP
wget https://github.com/haunchen/certbot-deploy/archive/main.zip
unzip main.zip
```

### 步驟 2: 安裝依賴

```bash
cd certbot-deploy
sudo ./install.sh
```

**這個腳本會:**
- 更新系統套件
- 安裝 Python3、venv、libaugeas-dev
- 安裝 Nginx
- 在虛擬環境中安裝 Certbot
- 創建 Certbot 符號連結

### 步驟 3: 部署 SSL

```bash
sudo ./deploy.sh example.com
```

**這個腳本會:**
- 驗證域名格式
- 檢查服務狀態
- 獲取 SSL 證書
- 配置 Nginx
- 測試和重載配置

## 驗證安裝

```bash
# 檢查 Certbot 版本
certbot --version

# 檢查 Nginx 狀態
sudo systemctl status nginx

# 檢查 SSL 證書
sudo certbot certificates

# 測試網站
curl -I https://your-domain.com
```

## 常見問題快速解決

### DNS 未正確設定
```bash
# 檢查 DNS 解析
nslookup your-domain.com
dig your-domain.com
```

### 防火牆問題
```bash
# Ubuntu/Debian 使用 ufw
sudo ufw allow 80
sudo ufw allow 443
sudo ufw status

# CentOS/RHEL 使用 firewalld
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### Nginx 配置錯誤
```bash
# 測試配置
sudo nginx -t

# 查看錯誤日誌
sudo tail -f /var/log/nginx/error.log

# 重啟服務
sudo systemctl restart nginx
```

## 自動更新設定

```bash
# 創建更新腳本
sudo crontab -e

# 添加每日檢查（凌晨 2 點）
0 2 * * * /usr/bin/certbot renew --quiet --no-self-upgrade

# 添加每週重載 Nginx（週日凌晨 3 點）
0 3 * * 0 /usr/bin/systemctl reload nginx
```

## 進階配置

### 自訂 Nginx 配置
編輯配置文件：
```bash
sudo nano /etc/nginx/sites-available/your-domain.com
sudo nginx -t
sudo systemctl reload nginx
```

### 多域名 SSL
```bash
# 為多個域名獲取證書
sudo ./deploy.sh domain1.com
sudo ./deploy.sh domain2.com
sudo ./deploy.sh subdomain.domain.com
```

### 備份和恢復
```bash
# 備份證書
sudo tar -czf ssl-backup-$(date +%Y%m%d).tar.gz /etc/letsencrypt/

# 備份 Nginx 配置
sudo tar -czf nginx-backup-$(date +%Y%m%d).tar.gz /etc/nginx/
```

需要幫助？查看 [故障排除指南](README.md#故障排除) 或 [提交 Issue](https://github.com/haunchen/certbot-deploy/issues/new)。

---

# English Version - Quick Start Guide

## Quick Start for SSL Certificate Deployment

This guide will help you quickly deploy SSL certificates using our automated scripts.

## Prerequisites

Before you begin, ensure you have:

- ✅ Ubuntu 18.04+ or Debian 9+ server
- ✅ Root access or sudo privileges
- ✅ Domain name pointing to your server
- ✅ Ports 80 and 443 open in firewall
- ✅ Basic command line knowledge

## Installation Methods

### Method 1: Git Clone (Recommended)

```bash
# Download project
git clone https://github.com/haunchen/certbot-deploy.git
cd certbot-deploy

# Set execution permissions
chmod +x install.sh deploy.sh
```

### Method 2: Direct Download

```bash
# Method 1: Using git
git clone https://github.com/haunchen/certbot-deploy.git

# Method 2: Download ZIP
wget https://github.com/haunchen/certbot-deploy/archive/main.zip
unzip main.zip
```

## Step-by-Step Deployment

### Step 1: Install Certbot

```bash
sudo ./install.sh
```

**What this script does:**
- Updates system packages
- Installs Python3 and virtual environment
- Installs Nginx web server
- Sets up Certbot in isolated environment
- Creates system-wide Certbot command

### Step 2: Deploy SSL Certificate

```bash
sudo ./deploy.sh your-domain.com
```

**Replace `your-domain.com` with your actual domain name**

**What this script does:**
- Validates domain format
- Checks system prerequisites
- Obtains SSL certificate from Let's Encrypt
- Configures Nginx with SSL
- Sets up automatic HTTP to HTTPS redirection
- Applies security headers

### Step 3: Verify Installation

```bash
./test-ssl.sh your-domain.com
```

## Real-World Examples

### Example 1: Blog Website
```bash
sudo ./deploy.sh blog.example.com
```

### Example 2: E-commerce Site
```bash
sudo ./deploy.sh shop.example.com
```

### Example 3: API Server
```bash
sudo ./deploy.sh api.example.com
```

## Post-Installation Steps

### 1. Verify SSL Configuration

Visit your website:
- `http://your-domain.com` → Should redirect to HTTPS
- `https://your-domain.com` → Should load with SSL certificate

### 2. Check SSL Rating

Test your SSL configuration:
- [SSL Labs Test](https://www.ssllabs.com/ssltest/)
- [Security Headers Test](https://securityheaders.com/)

### 3. Set Up Automatic Renewal

```bash
# Edit root crontab
sudo crontab -e

# Add automatic renewal (runs twice daily)
0 12 * * * /usr/bin/certbot renew --quiet
0 0 * * * /usr/bin/certbot renew --quiet
```

## Troubleshooting Common Issues

### Issue 1: Domain Not Accessible

**Problem:** Domain doesn't resolve or isn't accessible

**Solution:**
```bash
# Check DNS resolution
nslookup your-domain.com

# Check if ports are open
sudo ufw status
sudo netstat -tulpn | grep :80
sudo netstat -tulpn | grep :443
```

### Issue 2: Nginx Configuration Error

**Problem:** Nginx fails to restart after SSL configuration

**Solution:**
```bash
# Test Nginx configuration
sudo nginx -t

# Check Nginx status
sudo systemctl status nginx

# View Nginx error logs
sudo journalctl -u nginx -f
```

### Issue 3: Certificate Generation Failed

**Problem:** Let's Encrypt fails to issue certificate

**Solution:**
```bash
# Check Certbot logs
sudo cat /var/log/letsencrypt/letsencrypt.log

# Try manual certificate generation
sudo certbot certonly --nginx -d your-domain.com --dry-run
```

## Advanced Configuration

### Custom Nginx Configuration

If you need custom Nginx settings, modify the generated configuration:

```bash
# Edit the configuration file
sudo nano /etc/nginx/sites-available/your-domain.com

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

### Multiple Domains

Deploy SSL for multiple domains:

```bash
# Deploy for multiple subdomains
sudo ./deploy.sh www.example.com
sudo ./deploy.sh blog.example.com
sudo ./deploy.sh api.example.com
```

### Backup Configuration

Always backup your configuration before making changes:

```bash
# Backup Nginx configuration
sudo tar -czf nginx-backup-$(date +%Y%m%d).tar.gz /etc/nginx/
```

Need help? Check the [Troubleshooting Guide](README.md#troubleshooting) or [Submit an Issue](https://github.com/haunchen/certbot-deploy/issues/new).
