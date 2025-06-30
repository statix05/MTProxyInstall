#!/bin/bash

# MTProxy Docker Installation Script
# Simple and reliable way to install Telegram MTProxy

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${GREEN}=== MTProxy Docker Installation ===${NC}\n"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Please run as root: sudo ./install.sh${NC}"
   exit 1
fi

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo -e "${GREEN}Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    systemctl start docker
    systemctl enable docker
fi

# Stop and remove old containers
echo -e "${GREEN}Cleaning up old installations...${NC}"
docker stop mtproxy 2>/dev/null || true
docker rm mtproxy 2>/dev/null || true

# Ask for port
read -p "Enter proxy port (default 8443): " USER_PORT
PORT=${USER_PORT:-8443}

# Run MTProxy
echo -e "${GREEN}Starting MTProxy...${NC}"
docker run -d \
  --name mtproxy \
  --restart=unless-stopped \
  -p ${PORT}:443 \
  -v mtproxy-data:/data \
  telegrammessenger/proxy:latest

# Wait for startup
echo -e "${GREEN}Waiting for startup...${NC}"
sleep 5

# Check status
if docker ps | grep -q mtproxy; then
    echo -e "${GREEN}✓ MTProxy started successfully!${NC}"
else
    echo -e "${RED}✗ Failed to start${NC}"
    docker logs mtproxy
    exit 1
fi

# Open firewall port
if command -v ufw &> /dev/null; then
    ufw allow ${PORT}/tcp 2>/dev/null || true
fi

# Get connection details
echo -e "\n${GREEN}Getting proxy information...${NC}"
EXTERNAL_IP=$(curl -s -4 ifconfig.me || curl -s -4 icanhazip.com)
SECRET=$(docker logs mtproxy 2>&1 | grep -oP "Secret 1: \K[a-f0-9]{32}" | head -1)

if [[ -z "$SECRET" ]]; then
    echo -e "${YELLOW}Waiting for secret generation...${NC}"
    sleep 3
    SECRET=$(docker logs mtproxy 2>&1 | grep -oP "Secret 1: \K[a-f0-9]{32}" | head -1)
fi

# Create management script with correct port
cat > /usr/local/bin/mtproxy << EOF
#!/bin/bash

# Saved parameters
EXTERNAL_IP="${EXTERNAL_IP}"
PORT="${PORT}"
SECRET="${SECRET}"

case "\$1" in
    status)
        docker ps -a | grep mtproxy
        echo -e "\nProxy port: ${PORT}"
        ;;
    logs)
        docker logs -f mtproxy
        ;;
    restart)
        docker restart mtproxy
        ;;
    info)
        echo -e "MTProxy Information:"
        echo -e "==================="
        echo -e "IP: \${EXTERNAL_IP}"
        echo -e "Port: \${PORT}"
        echo -e "Secret: \${SECRET}\n"
        echo -e "Connection links:"
        echo -e "tg://proxy?server=\${EXTERNAL_IP}&port=\${PORT}&secret=\${SECRET}"
        echo -e "https://t.me/proxy?server=\${EXTERNAL_IP}&port=\${PORT}&secret=\${SECRET}"
        ;;
    stop)
        docker stop mtproxy
        ;;
    start)
        docker start mtproxy
        ;;
    update)
        docker pull telegrammessenger/proxy:latest
        docker stop mtproxy
        docker rm mtproxy
        docker run -d --name mtproxy --restart=unless-stopped -p \${PORT}:443 -v mtproxy-data:/data telegrammessenger/proxy:latest
        echo "MTProxy updated!"
        ;;
    *)
        echo "Usage: mtproxy {status|logs|restart|info|stop|start|update}"
        ;;
esac
EOF
chmod +x /usr/local/bin/mtproxy

# Show results
echo -e "\n${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ MTProxy installed successfully!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Connection details:${NC}"
echo -e "IP: ${GREEN}${EXTERNAL_IP}${NC}"
echo -e "Port: ${GREEN}${PORT}${NC} (important: use this port, not 443!)"
echo -e "Secret: ${GREEN}${SECRET}${NC}\n"

echo -e "${YELLOW}Connection links:${NC}"
echo -e "${GREEN}tg://proxy?server=${EXTERNAL_IP}&port=${PORT}&secret=${SECRET}${NC}"
echo -e "${GREEN}https://t.me/proxy?server=${EXTERNAL_IP}&port=${PORT}&secret=${SECRET}${NC}\n"

# QR code if qrencode is available
if command -v qrencode &> /dev/null 2>&1; then
    echo -e "${YELLOW}QR code for quick connection:${NC}"
    qrencode -t UTF8 "tg://proxy?server=${EXTERNAL_IP}&port=${PORT}&secret=${SECRET}"
    echo ""
fi

# Save information
mkdir -p /etc/mtproxy
cat > /etc/mtproxy/info.txt << EOL
MTProxy Information
===================
Installation date: $(date)
IP: ${EXTERNAL_IP}
Port: ${PORT}
Secret: ${SECRET}

IMPORTANT: Use port ${PORT}, not 443!

Connection links:
tg://proxy?server=${EXTERNAL_IP}&port=${PORT}&secret=${SECRET}
https://t.me/proxy?server=${EXTERNAL_IP}&port=${PORT}&secret=${SECRET}

Commands:
mtproxy status  - check status
mtproxy logs    - view logs
mtproxy restart - restart proxy
mtproxy info    - show this information
mtproxy update  - update MTProxy
EOL

echo -e "${YELLOW}Management commands:${NC}"
echo -e "  ${GREEN}mtproxy status${NC}  - proxy status"
echo -e "  ${GREEN}mtproxy logs${NC}    - view logs"
echo -e "  ${GREEN}mtproxy restart${NC} - restart proxy"
echo -e "  ${GREEN}mtproxy info${NC}    - proxy information"
echo -e "  ${GREEN}mtproxy update${NC}  - update MTProxy\n"

echo -e "${GREEN}Information saved to: /etc/mtproxy/info.txt${NC}"

# Add weekly auto-update to cron
(crontab -l 2>/dev/null | grep -v "mtproxy update"; echo "0 4 * * 0 /usr/local/bin/mtproxy update >/dev/null 2>&1") | crontab -
echo -e "${GREEN}Added weekly auto-update${NC}"

echo -e "\n${GREEN}Installation completed!${NC}"
echo -e "${YELLOW}Test the connection using the links above${NC}\n"