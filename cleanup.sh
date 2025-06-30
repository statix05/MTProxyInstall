#!/bin/bash

# MTProxy Complete Cleanup Script

echo "=== MTProxy Complete Cleanup ==="

# Stop all services
echo "Stopping services..."
docker stop mtproxy 2>/dev/null && echo "Docker container stopped"
systemctl stop mtg 2>/dev/null
systemctl stop mtproxy 2>/dev/null

# Remove Docker
echo "Removing Docker containers and data..."
docker rm mtproxy 2>/dev/null && echo "Docker container removed"
docker volume rm mtproxy-data 2>/dev/null && echo "Docker volume removed"
docker rmi telegrammessenger/proxy:latest 2>/dev/null && echo "Docker image removed"

# Remove systemd services
echo "Removing systemd services..."
systemctl disable mtg 2>/dev/null
systemctl disable mtproxy 2>/dev/null
rm -f /etc/systemd/system/mtg.service
rm -f /etc/systemd/system/mtproxy.service
systemctl daemon-reload

# Remove files
echo "Removing files and directories..."
rm -rf /opt/MTProxy
rm -rf /etc/mtg
rm -rf /etc/mtproxy
rm -f /usr/local/bin/mtg*
rm -f /usr/local/bin/mtproxy*
rm -rf ~/MTProxy
rm -rf /tmp/mtg*
rm -rf /tmp/MTProxy

# Close firewall ports
echo "Closing ports..."
for port in 443 993 8443 8888 8889 4997; do
    ufw delete allow $port/tcp 2>/dev/null
done

echo -e "\n✓ Cleanup completed!"
echo "You can now run a fresh installation."