#!/bin/bash
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root or with sudo privileges."
    echo "Usage: sudo $0"
    exit 1
fi

echo "Starting Certbot installation..."

# Update package list
echo "Updating package list..."
apt update

# Install required packages
echo "Installing required packages..."
apt install -y python3 python3-venv libaugeas-dev nginx

# Remove any existing certbot packages to avoid conflicts
echo "Removing existing certbot packages..."
apt remove -y certbot || true

# Create Python virtual environment for Certbot
echo "Creating Python virtual environment for Certbot..."
if [ -d "/opt/certbot" ]; then
    echo "Warning: /opt/certbot already exists. Removing..."
    rm -rf /opt/certbot
fi

python3 -m venv /opt/certbot
/opt/certbot/bin/pip install --upgrade pip

# Install Certbot and nginx plugin
echo "Installing Certbot and nginx plugin..."
/opt/certbot/bin/pip install certbot certbot-nginx

# Create symlink for global access
echo "Creating Certbot symlink..."
if [ -L "/usr/bin/certbot" ]; then
    rm /usr/bin/certbot
fi
ln -s /opt/certbot/bin/certbot /usr/bin/certbot

# Verify installation
echo "Verifying Certbot installation..."
if /usr/bin/certbot --version; then
    echo "✓ Certbot installation completed successfully!"
    echo "✓ Certbot version: $(/usr/bin/certbot --version)"
else
    echo "✗ Error: Certbot installation failed!"
    exit 1
fi

# Check nginx status
echo "Checking nginx service..."
if systemctl is-active --quiet nginx; then
    echo "✓ Nginx is running"
else
    echo "Starting nginx service..."
    systemctl start nginx
    systemctl enable nginx
    echo "✓ Nginx started and enabled"
fi

echo ""
echo "Installation completed successfully!"
echo "You can now run the deploy.sh script to obtain SSL certificates."
