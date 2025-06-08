#!/bin/bash
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root or with sudo privileges."
    echo "Usage: sudo $0 <domain>"
    exit 1
fi

# Check if domain argument is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a valid domain."
    echo "Usage: sudo $0 <your.domain>"
    echo "Example: sudo $0 example.com"
    exit 1
fi

INPUT_DOMAIN="$1"

# Validate domain format
REGEX="^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+([a-zA-Z]{2,63})$"

if [[ ! "$INPUT_DOMAIN" =~ $REGEX ]]; then
    echo "Error: Please provide a valid domain format."
    echo "Example: www.example.com or example.com"
    exit 1
fi

echo "Starting SSL certificate deployment for domain: $INPUT_DOMAIN"

# Check if nginx is running
if ! systemctl is-active --quiet nginx; then
    echo "Error: Nginx is not running. Please start nginx service first."
    echo "Run: sudo systemctl start nginx"
    exit 1
fi

# Check if certbot is installed
if ! command -v certbot &> /dev/null; then
    echo "Error: Certbot is not installed. Please run install.sh first."
    exit 1
fi

SOURCE_CONF_PATH="/etc/nginx/sites-available/${INPUT_DOMAIN}"
TARGET_LINK_PATH="/etc/nginx/sites-enabled/${INPUT_DOMAIN}"

# Check if site config already exists
if [ -f "$SOURCE_CONF_PATH" ]; then
    echo "Error: Site configuration for $INPUT_DOMAIN already exists."
    echo "Config file: $SOURCE_CONF_PATH"
    echo "Please remove or backup the existing configuration before proceeding."
    exit 1
fi

# Create SSL Certificate
echo "Obtaining SSL certificate for $INPUT_DOMAIN..."
if ! certbot certonly --nginx -d "$INPUT_DOMAIN"; then
    echo "Error: Failed to obtain SSL certificate for $INPUT_DOMAIN"
    echo "Please check if:"
    echo "1. The domain points to this server"
    echo "2. Port 80 and 443 are open"
    echo "3. Nginx is properly configured"
    exit 1
fi

# Certificate paths
FULLCHAIN_PATH="/etc/letsencrypt/live/$INPUT_DOMAIN/fullchain.pem"
PRIVKEY_PATH="/etc/letsencrypt/live/$INPUT_DOMAIN/privkey.pem"

# Verify certificate files exist
if [ ! -f "$FULLCHAIN_PATH" ] || [ ! -f "$PRIVKEY_PATH" ]; then
    echo "Error: SSL certificate files not found after certbot execution."
    echo "Expected files:"
    echo "  - $FULLCHAIN_PATH"
    echo "  - $PRIVKEY_PATH"
    exit 1
fi

echo "Creating nginx configuration for $INPUT_DOMAIN..."
# Create nginx configuration file
cat << 'EOF_SITE' > "$SOURCE_CONF_PATH"
server {
    listen 80;
    server_name INPUT_DOMAIN_PLACEHOLDER;

    # Redirect all HTTP traffic to HTTPS
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name INPUT_DOMAIN_PLACEHOLDER;

    # SSL Configuration
    ssl_certificate FULLCHAIN_PATH_PLACEHOLDER;
    ssl_certificate_key PRIVKEY_PATH_PLACEHOLDER;

    # Include Let's Encrypt recommended SSL settings
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Document root
    root /var/www/html;

    # Index files
    index index.html index.htm index.nginx-debian.html;

    # Main location block
    location / {
        try_files $uri $uri/ =404;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Logging
    access_log /var/log/nginx/INPUT_DOMAIN_PLACEHOLDER_access.log;
    error_log /var/log/nginx/INPUT_DOMAIN_PLACEHOLDER_error.log;
}
EOF_SITE

# Replace placeholders with actual values
sed -i "s/INPUT_DOMAIN_PLACEHOLDER/$INPUT_DOMAIN/g" "$SOURCE_CONF_PATH"
sed -i "s|FULLCHAIN_PATH_PLACEHOLDER|$FULLCHAIN_PATH|g" "$SOURCE_CONF_PATH"
sed -i "s|PRIVKEY_PATH_PLACEHOLDER|$PRIVKEY_PATH|g" "$SOURCE_CONF_PATH"

echo "✓ Nginx configuration file created: $SOURCE_CONF_PATH"

# Create symbolic link to enable the site
if [ -L "$TARGET_LINK_PATH" ]; then
    echo "Warning: Symbolic link already exists: $TARGET_LINK_PATH"
else
    ln -s "$SOURCE_CONF_PATH" "$TARGET_LINK_PATH"
    echo "✓ Symbolic link created: $TARGET_LINK_PATH"
fi

# Test nginx configuration before reloading
echo "Testing nginx configuration..."
if nginx -t; then
    echo "✓ Nginx configuration test passed"
    
    echo "Reloading nginx service..."
    if systemctl reload nginx; then
        echo "✓ Nginx service reloaded successfully"
    else
        echo "✗ Error: Failed to reload nginx service"
        echo "Please check nginx error logs: sudo journalctl -u nginx"
        exit 1
    fi
else
    echo "✗ Error: Nginx configuration test failed!"
    echo "Please check the configuration file: $SOURCE_CONF_PATH"
    echo "You can also check nginx error logs: sudo nginx -t"
    
    # Clean up on configuration failure
    echo "Cleaning up failed configuration..."
    rm -f "$SOURCE_CONF_PATH"
    rm -f "$TARGET_LINK_PATH"
    exit 1
fi

echo ""
echo "🎉 SSL certificate deployment completed successfully!"
echo ""
echo "Domain: $INPUT_DOMAIN"
echo "SSL Certificate: $FULLCHAIN_PATH"
echo "Private Key: $PRIVKEY_PATH"
echo "Nginx Config: $SOURCE_CONF_PATH"
echo ""
echo "You can now access your site at: https://$INPUT_DOMAIN"
echo ""
echo "To modify the nginx configuration, edit: $SOURCE_CONF_PATH"
echo "After making changes, test with: sudo nginx -t"
echo "Then reload with: sudo systemctl reload nginx"
