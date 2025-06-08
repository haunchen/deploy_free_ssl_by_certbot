# Nginx 配置範例

這個目錄包含了各種常見用途的 Nginx 配置範例。

## 文件列表

- `basic-site.conf` - 基本靜態網站配置
- `php-site.conf` - PHP 應用配置（適用於 Laravel、WordPress 等）
- `nodejs-app.conf` - Node.js 應用反向代理配置
- `subdomain.conf` - 子域名配置範例
- `redirect.conf` - 域名重定向配置

## 使用方法

1. 複製適合的範例配置
2. 修改域名和路徑
3. 執行 `deploy.sh` 獲取 SSL 證書
4. 手動調整配置以符合您的需求

## 注意事項

- 這些配置需要在 `deploy.sh` 執行後手動應用
- 記得測試配置：`sudo nginx -t`
- 重載 Nginx：`sudo systemctl reload nginx`
