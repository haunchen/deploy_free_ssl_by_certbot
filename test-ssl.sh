#!/bin/bash

# SSL 部署測試腳本
# 用於驗證 SSL 證書是否正確安裝和配置

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 輔助函數
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# 檢查參數
if [ -z "$1" ]; then
    print_error "請提供要測試的域名"
    echo "使用方法: $0 <domain>"
    echo "範例: $0 example.com"
    exit 1
fi

DOMAIN="$1"

echo "==================================="
echo "SSL 部署測試工具"
echo "測試域名: $DOMAIN"
echo "==================================="

# 1. 檢查 DNS 解析
print_info "1. 檢查 DNS 解析..."
if nslookup "$DOMAIN" > /dev/null 2>&1; then
    IP=$(nslookup "$DOMAIN" | grep "Address:" | tail -1 | awk '{print $2}')
    print_success "DNS 解析正常 -> $IP"
else
    print_error "DNS 解析失敗"
    exit 1
fi

# 2. 檢查端口連通性
print_info "2. 檢查端口連通性..."

# 檢查端口 80
if timeout 5 bash -c "echo >/dev/tcp/$DOMAIN/80" 2>/dev/null; then
    print_success "端口 80 (HTTP) 可達"
else
    print_error "端口 80 (HTTP) 不可達"
fi

# 檢查端口 443
if timeout 5 bash -c "echo >/dev/tcp/$DOMAIN/443" 2>/dev/null; then
    print_success "端口 443 (HTTPS) 可達"
else
    print_error "端口 443 (HTTPS) 不可達"
fi

# 3. 檢查 HTTP 重定向
print_info "3. 檢查 HTTP 到 HTTPS 重定向..."
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "http://$DOMAIN" || echo "000")
if [ "$HTTP_RESPONSE" = "301" ] || [ "$HTTP_RESPONSE" = "302" ]; then
    print_success "HTTP 重定向正常 (狀態碼: $HTTP_RESPONSE)"
else
    print_warning "HTTP 重定向異常 (狀態碼: $HTTP_RESPONSE)"
fi

# 4. 檢查 SSL 證書
print_info "4. 檢查 SSL 證書..."
if command -v openssl > /dev/null; then
    # 獲取證書信息
    CERT_INFO=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:443" 2>/dev/null | openssl x509 -noout -dates -subject 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        print_success "SSL 證書有效"
        
        # 提取證書詳細信息
        NOT_BEFORE=$(echo "$CERT_INFO" | grep "notBefore" | cut -d= -f2-)
        NOT_AFTER=$(echo "$CERT_INFO" | grep "notAfter" | cut -d= -f2-)
        SUBJECT=$(echo "$CERT_INFO" | grep "subject" | cut -d= -f2-)
        
        echo "  證書主體: $SUBJECT"
        echo "  有效期: $NOT_BEFORE 到 $NOT_AFTER"
        
        # 檢查證書是否即將過期（30天內）
        if command -v date > /dev/null; then
            EXPIRY_DATE=$(date -d "$NOT_AFTER" +%s 2>/dev/null || echo "0")
            CURRENT_DATE=$(date +%s)
            DAYS_UNTIL_EXPIRY=$(( (EXPIRY_DATE - CURRENT_DATE) / 86400 ))
            
            if [ "$DAYS_UNTIL_EXPIRY" -lt 30 ] && [ "$DAYS_UNTIL_EXPIRY" -gt 0 ]; then
                print_warning "證書將在 $DAYS_UNTIL_EXPIRY 天後過期"
            elif [ "$DAYS_UNTIL_EXPIRY" -le 0 ]; then
                print_error "證書已過期"
            else
                print_success "證書還有 $DAYS_UNTIL_EXPIRY 天過期"
            fi
        fi
    else
        print_error "無法獲取 SSL 證書信息"
    fi
else
    print_warning "未安裝 openssl，跳過證書詳細檢查"
fi

# 5. 檢查 HTTPS 連接
print_info "5. 檢查 HTTPS 連接..."
HTTPS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN" || echo "000")
if [ "$HTTPS_RESPONSE" = "200" ]; then
    print_success "HTTPS 連接正常 (狀態碼: $HTTPS_RESPONSE)"
elif [ "$HTTPS_RESPONSE" = "301" ] || [ "$HTTPS_RESPONSE" = "302" ]; then
    print_success "HTTPS 連接正常，有重定向 (狀態碼: $HTTPS_RESPONSE)"
else
    print_error "HTTPS 連接異常 (狀態碼: $HTTPS_RESPONSE)"
fi

# 6. 檢查安全標頭
print_info "6. 檢查安全標頭..."
HEADERS=$(curl -s -I "https://$DOMAIN" 2>/dev/null || echo "")

check_header() {
    local header_name="$1"
    local header_pattern="$2"
    
    if echo "$HEADERS" | grep -i "$header_pattern" > /dev/null; then
        print_success "找到 $header_name"
    else
        print_warning "缺少 $header_name"
    fi
}

check_header "X-Frame-Options" "x-frame-options"
check_header "X-XSS-Protection" "x-xss-protection"
check_header "X-Content-Type-Options" "x-content-type-options"
check_header "Strict-Transport-Security" "strict-transport-security"

# 7. 檢查本地 Nginx 配置（如果在伺服器上運行）
if [ -f "/etc/nginx/sites-available/$DOMAIN" ]; then
    print_info "7. 檢查本地 Nginx 配置..."
    
    if nginx -t > /dev/null 2>&1; then
        print_success "Nginx 配置語法正確"
    else
        print_error "Nginx 配置語法錯誤"
    fi
    
    if [ -L "/etc/nginx/sites-enabled/$DOMAIN" ]; then
        print_success "站點已啟用"
    else
        print_warning "站點未啟用"
    fi
else
    print_info "7. 本地配置檢查已跳過（非伺服器環境）"
fi

# 8. SSL Labs 評級建議
print_info "8. 建議進行 SSL Labs 測試..."
echo "   訪問: https://www.ssllabs.com/ssltest/analyze.html?d=$DOMAIN"
echo "   獲取詳細的 SSL 配置評級"

echo ""
echo "==================================="
echo "測試完成！"
echo "==================================="

# 9. 總結建議
print_info "改善建議："
echo "- 定期更新證書（建議設置自動更新）"
echo "- 監控證書過期時間"
echo "- 考慮添加 HSTS 標頭"
echo "- 定期檢查 SSL Labs 評級"
