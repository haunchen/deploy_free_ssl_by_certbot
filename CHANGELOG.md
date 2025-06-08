# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-06-08

### Added
- 初始版本發布
- 自動安裝 Certbot 和 Nginx (`install.sh`)
- 自動部署 SSL 證書和配置 Nginx (`deploy.sh`)
- 完整的錯誤處理和驗證機制
- 安全的 Nginx 配置模板
- 自動 HTTP 到 HTTPS 重定向
- 安全標頭配置
- 詳細的使用文檔和故障排除指南

### Features
- 支援 Ubuntu 18.04+ 和 Debian 9+
- 域名格式驗證
- 自動創建和清理配置文件
- Nginx 配置語法測試
- 證書文件存在性驗證
- 服務狀態檢查

### Security
- Root 權限檢查
- 安全的 SSL 配置
- 現代安全標頭
- 失敗時自動清理機制
