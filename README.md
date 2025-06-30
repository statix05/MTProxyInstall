# MTProxy Docker Installation Script

A simple, reliable, and automated script for installing the Telegram MTProxy server using Docker. This script solves all the complexities of configuring the Telegram proxy server.

## 📋 Table of Contents

[Overview](#-overview)
- [Features](#features)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Installation Guide](#installation-guide)
- [Usage](#usage)
- [Management Commands](#management-commands)
- [Troubleshooting](#troubleshooting)
- [Uninstallation](#uninstallation)
- [Contributing](#contributing)
- [License](#license)

## 🔍 Overview

MTProxy is the official Telegram proxy server that allows users to bypass network restrictions while maintaining secure connections. This script automates the entire installation process using Docker, making it accessible even for users with minimal technical knowledge.

### What this script does:

1. **Checks system requirements** - Verifies root access and system compatibility
2. **Installs Docker** - Automatically installs Docker if not present
3. **Cleans up old installations** - Removes any existing MTProxy installations
4. **Configures the proxy** - Sets up MTProxy with your chosen port
5. **Manages firewall rules** - Opens necessary ports in UFW/firewalld
6. **Generates connection details** - Creates ready-to-use proxy links
7. **Creates management tools** - Installs the `mtproxy` command for easy management
8. **Sets up auto-updates** - Configures weekly automatic updates via cron

## ✨ Features

- 🚀 **One-line installation** - No complex configuration needed
- 🐳 **Docker-based** - Isolated, secure, and easy to manage
- 🔐 **Automatic secret generation** - Secure proxy credentials created automatically
- 🔧 **Custom port selection** - Choose any available port
- 🛡️ **Firewall auto-configuration** - Works with UFW and firewalld
- 📊 **Built-in management commands** - Easy control after installation
- 🔄 **Auto-updates** - Keeps your proxy server up-to-date
- 📱 **QR code generation** - Quick mobile setup (if qrencode installed)
- 💾 **Persistent configuration** - Settings saved across restarts

## 📦 Requirements

- **Operating System**: Ubuntu, Debian, CentOS, or any Linux distribution with systemd
- **Architecture**: x86_64 (amd64)
- **Access**: Root or sudo privileges
- **Network**: 
  - Public IP address
  - Open port (you choose during installation, default: 8443)
  - Stable internet connection
- **RAM**: Minimum 512MB
- **Disk Space**: Minimum 1GB free space

## 🚀 Quick Start

```bash
# Download and run the installation script
wget https://raw.githubusercontent.com/statix05/MTProxyInstall/main/install.sh
chmod +x install.sh
sudo ./install.sh
```

That's it! Follow the prompts and your proxy will be ready in minutes.

## 📖 Installation Guide

### Step 1: Download the Script

```bash
# Using wget
wget https://raw.githubusercontent.com/statix05/MTProxyInstall/main/install.sh

# Or using curl
curl -O https://raw.githubusercontent.com/statix05/MTProxyInstall/main/install.sh
```

### Step 2: Make it Executable

```bash
chmod +x install.sh
```

### Step 3: Run the Installation

```bash
sudo ./install.sh
```

### Step 4: Follow the Prompts

1. The script will ask for a port number (press Enter for default 8443)
2. Wait for the installation to complete
3. Copy the generated proxy links

### Step 5: Configure Your Telegram Client

Use one of the generated links to add the proxy to your Telegram:
- Direct link: `tg://proxy?server=YOUR_IP&port=YOUR_PORT&secret=YOUR_SECRET`
- Web link: `https://t.me/proxy?server=YOUR_IP&port=YOUR_PORT&secret=YOUR_SECRET`

## 💻 Usage

### During Installation

```bash
$ sudo ./install.sh
=== MTProxy Docker Installation ===

Cleaning up old installations...
Enter proxy port (default 8443): 9443
Starting MTProxy...
✓ MTProxy started successfully!

Connection details:
IP: 123.45.67.89
Port: 9443
Secret: abc123def456...

Connection links:
tg://proxy?server=123.45.67.89&port=9443&secret=abc123def456...
```

### After Installation

The script creates a `mtproxy` command for easy management:

```bash
# Check proxy status
mtproxy status

# View real-time logs
mtproxy logs

# Show connection information
mtproxy info
```

## 🛠️ Management Commands

| Command | Description |
|---------|-------------|
| `mtproxy status` | Check if proxy is running and show port |
| `mtproxy logs` | View real-time proxy logs (Ctrl+C to exit) |
| `mtproxy info` | Display connection links and proxy details |
| `mtproxy restart` | Restart the proxy server |
| `mtproxy stop` | Stop the proxy server |
| `mtproxy start` | Start the proxy server |
| `mtproxy update` | Update to the latest MTProxy version |

### Examples

```bash
# Check if proxy is running
$ mtproxy status
CONTAINER ID   IMAGE                      STATUS         PORTS
abc123def456   telegrammessenger/proxy   Up 2 hours     0.0.0.0:9443->443/tcp
Proxy port: 9443

# View logs
$ mtproxy logs
[*] Starting proxy...
[*] Secret: abc123def456...
[*] Listening on port 443

# Get connection info
$ mtproxy info
MTProxy Information:
===================
IP: 123.45.67.89
Port: 9443
Secret: abc123def456...

Connection links:
tg://proxy?server=123.45.67.89&port=9443&secret=abc123def456...
```

## 🔧 Troubleshooting

### Common Issues

**1. Permission Denied**
```bash
# Make sure to run with sudo
sudo ./install.sh
```

**2. Port Already in Use**
```bash
# Check what's using the port
sudo lsof -i :8443
# Choose a different port during installation
```

**3. Cannot Connect to Proxy**
```bash
# Check if container is running
docker ps | grep mtproxy

# Check firewall
sudo ufw status

# View logs for errors
mtproxy logs
```

**4. Docker Installation Failed**
```bash
# Install Docker manually
curl -fsSL https://get.docker.com | sudo sh
```

### Getting Help

- Check logs: `mtproxy logs`
- Verify status: `mtproxy status`
- Connection info saved in: `/etc/mtproxy/info.txt`

## 🗑️ Uninstallation

To completely remove MTProxy and all its data:

```bash
# Download cleanup script
wget https://raw.githubusercontent.com/statix05/MTProxyInstall/main/cleanup.sh
chmod +x cleanup.sh
sudo ./cleanup.sh
```

This will:
- Stop and remove Docker containers
- Delete all proxy data
- Remove systemd services
- Clean up configuration files
- Close firewall ports

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Telegram MTProxy](https://github.com/TelegramMessenger/MTProxy) - Official Telegram proxy server
- [Docker](https://www.docker.com/) - Container platform
- Community contributors

---

⭐ If this script helped you, please consider giving it a star on GitHub!
```

**Don't forget to:**
1. Replace `YOUR_USERNAME` with your actual GitHub username
2. Add a LICENSE file (MIT license is recommended)
3. Create the repository and upload the files:
   - `install.sh` - The main installation script
   - `cleanup.sh` - The cleanup script
   - `README.md` - This documentation
   - `LICENSE` - License file

This README provides comprehensive documentation that's both user-friendly and professional for your GitHub repository!
