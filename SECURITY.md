# Security Policy

## 支援的版本

我們會為以下版本提供安全更新：

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## 回報安全漏洞

如果您發現了安全漏洞，請**不要**在公開的 GitHub Issues 中回報。

### 如何回報

請透過以下方式私下回報安全問題：

1. **電子郵件**：發送詳細資訊到專案維護者
2. **GitHub Private Vulnerability Reporting**：使用 GitHub 的私人漏洞回報功能

### 回報內容

請在您的回報中包含：

- 漏洞的詳細描述
- 重現步驟
- 潛在影響
- 建議的修復方法（如果有）
- 您的聯絡資訊

### 回應時間

- 我們會在 **48 小時**內確認收到您的回報
- 我們會在 **7 天**內提供初步評估
- 我們會在 **30 天**內發布修復（視漏洞複雜程度而定）

### 負責任的揭露

- 請給我們合理的時間來修復漏洞
- 請不要在修復發布前公開漏洞細節
- 我們會在修復發布後公開致謝貢獻者

## 安全最佳實踐

### 對於使用者

1. **定期更新**：保持腳本和系統為最新版本
2. **權限管理**：只以必要權限執行腳本
3. **環境隔離**：在測試環境中先行測試
4. **備份配置**：在修改前備份重要配置文件
5. **監控日誌**：定期檢查系統和應用程式日誌

### 對於開發者

1. **程式碼審查**：所有修改都必須經過審查
2. **輸入驗證**：驗證所有外部輸入
3. **錯誤處理**：適當處理錯誤情況
4. **權限檢查**：確保適當的權限驗證
5. **安全測試**：定期進行安全測試

## 已知安全考量

### 權限要求

這些腳本需要 root 權限來：
- 安裝系統套件
- 修改 nginx 配置
- 管理 SSL 證書

### 檔案系統存取

腳本會存取以下敏感位置：
- `/etc/nginx/` - Nginx 配置
- `/etc/letsencrypt/` - SSL 證書
- `/opt/certbot/` - Certbot 安裝

### 網路通訊

腳本會進行以下網路通訊：
- 與 Let's Encrypt ACME 伺服器通訊
- 下載 Python 套件

## 更新通知

我們會透過以下方式通知安全更新：

- GitHub Releases
- README.md 更新
- CHANGELOG.md 記錄

訂閱我們的 GitHub repository 以獲取最新的安全更新通知。

---

# English Version - Security Policy

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting Security Vulnerabilities

If you discover a security vulnerability, please **do not** report it in public GitHub Issues.

### How to Report

Please report security issues privately through the following methods:

1. **Email**: Send detailed information to the project maintainer
2. **GitHub Private Vulnerability Reporting**: Use GitHub's private vulnerability reporting feature

### Report Content

Please include in your report:

- Detailed description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)
- Your contact information

### Response Times

- We will acknowledge receipt of your report within **48 hours**
- We will provide initial assessment within **7 days**
- We will release a fix within **30 days** (depending on vulnerability complexity)

### Responsible Disclosure

- Please give us reasonable time to fix the vulnerability
- Please do not publicly disclose vulnerability details before the fix is released
- We will publicly acknowledge contributors after the fix is released

## Security Best Practices

### For Users

1. **Regular Updates**: Keep scripts and system up to date
2. **Permission Management**: Run scripts with only necessary permissions
3. **Environment Isolation**: Test in test environment first
4. **Backup Configuration**: Backup important configuration files before modifications
5. **Monitor Logs**: Regularly check system and application logs

### For Developers

1. **Code Review**: All changes must be reviewed
2. **Input Validation**: Validate all external inputs
3. **Error Handling**: Properly handle error conditions
4. **Permission Checks**: Ensure appropriate permission verification
5. **Security Testing**: Conduct regular security testing

## Known Security Considerations

### Permission Requirements

These scripts require root privileges to:
- Install system packages
- Modify nginx configuration
- Manage SSL certificates

### File System Access

Scripts access the following sensitive locations:
- `/etc/nginx/` - Nginx configuration
- `/etc/letsencrypt/` - SSL certificates
- `/opt/certbot/` - Certbot installation

### Network Communications

Scripts perform the following network communications:
- Communicate with Let's Encrypt ACME servers
- Download Python packages

## Update Notifications

We notify security updates through the following methods:

- GitHub Releases
- README.md updates
- CHANGELOG.md records

Subscribe to our GitHub repository to get the latest security update notifications.
