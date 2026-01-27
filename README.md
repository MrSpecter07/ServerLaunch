# 🚀 ServerLaunch v2.0

**Universal Minecraft Server Manager with Graphical Interface**

ServerLaunch is a powerful Windows application designed to simplify the management of Minecraft servers. With an intuitive tabbed interface, automatic backups, PlayIT integration, and multi-language support, managing your server has never been easier.

---

## ✨ Features

- 🎮 **Universal Server Manager**: Compatible with any Minecraft server (Forge, Fabric, Paper, Vanilla, etc.)
- 🌐 **PlayIT Integration**: Automatic IP detection for Minecraft and Voicechat
- 💾 **Automatic Backups**: Schedule periodic backups to protect your world
- 🔄 **Auto-Restart**: Configure operating hours and auto-shutdown on idle
- 🖥️ **Real-time Console**: Monitor server logs with auto-scroll and auto-clear
- 👥 **Player Tracking**: See who's online in real-time
- 🌍 **Multi-language**: Support for Spanish and English
- 🎨 **Modern UI**: Dark theme with tabbed interface

---

## 📥 Installation

### Prerequisites

- **Windows 10/11** (PowerShell 5.1 or higher)
- **Java** (required by your Minecraft server)
- **Minecraft Server** (Forge, Fabric, Paper, Vanilla, etc.)
- **PlayIT** (optional, for tunneling)

### Steps

1. **Download ServerLaunch**
   - Download the latest release and extract it to a folder (e.g., `C:\ServerLaunch`)

2. **Install Dependencies**
   - Ensure Java is installed and accessible from command line
   - If using PlayIT, install it from [playit.gg](https://playit.gg/)

3. **Run ServerLaunch**
   - Double-click `run.bat` to start the application
   - The graphical interface will open automatically

4. **First Configuration**
   - Click **Browse** next to "Server" and select your server folder (where `run.bat` is located)
   - (Optional) Select your PlayIT installation folder
   - Click **Start** to start your server

---

## 📖 User Guide

### 🏠 Principal Tab

This is the main control panel for your server.

- **Server**: Select your Minecraft server folder (must contain `run.bat` or `start.bat`)
- **PlayIT (Optional)**: Select PlayIT installation folder for tunneling
- **Server Control**:
  - **Start**: Start the server and PlayIT (if configured)
  - **Stop**: Graceful server shutdown (no corruption)
  - **Restart**: Stop and start the server
  - **Kill**: Force terminate (use only if necessary)
- **Backups**: Restore previous backups from the dropdown menu
- **Status**: Shows current server status
- **Console**: Real-time server logs with auto-scroll
- **Players Online**: List of connected players

### 🌐 PlayIT Tab

Manage your server's public IPs for remote access.

- **Server IP**: Minecraft server IP (automatically detected from PlayIT logs)
- **Voicechat IP**: Voice chat IP for mods like Simple Voice Chat
- **Copy Buttons**: Click to copy IPs to clipboard
- **Open PlayIT Panel**: Open PlayIT web dashboard
- **Status**: PlayIT connection status

### ⚙️ Configuracion Tab

Customize ServerLaunch behavior.

#### Auto-Shutdown
- **Enable**: Automatically stop server when idle (no players for X minutes)
- **Idle minutes**: Number of minutes without players before server stops
- **Shutdown PC**: Optional - automatically shutdown your computer after server closes
- **Only shutdown outside operating hours**: Prevents auto-shutdown during your configured operating hours (prevents interruption during playtime)

Example: If set to 30 minutes with "Only shutdown outside hours" enabled, the server will stop if no one is playing for 30 minutes, but ONLY between 23:00-08:00 (if those are your off-hours).

#### Operating Hours
- **Enable Operating Hours**: Check to enable scheduled operation. If disabled, server runs 24/7 until you manually stop it
- **Start server on PC boot**: Auto-start server when Windows starts
- **Start time / End time**: When enabled, server automatically starts at start time and stops at end time
- **Input limits**: Hours (0-23), Minutes (0-59) - invalid values are automatically corrected

#### Auto-Backup
- **Enable**: Create periodic backups while server is running
- **Interval (min)**: Backup frequency in minutes

#### Console
- **Auto-clear console**: Auto-clear console logs
- **Every (min)**: Clear interval in minutes
- **Line limit**: Maximum console lines before auto-clear
- **Enable console logging**: Records all console messages to timestamped log files in the `logs/` folder for debugging and monitoring

#### Language
- **Spanish / English**: Change interface language

---

## 🔧 Advanced Configuration

### Server Requirements

Your Minecraft server folder must contain:
- `run.bat` or `start.bat` (launch script)
- `server.jar` or modded server files
- Standard Minecraft server structure (`world`, `config`, etc.)

### PlayIT Setup

1. Install PlayIT from [playit.gg](https://playit.gg/)
2. Run PlayIT and configure tunnels:
   - **Minecraft**: TCP tunnel on port 25565
   - **Voicechat** (optional): UDP tunnel on mod's port (usually 24454)
3. In ServerLaunch, select PlayIT folder (usually `C:\Program Files\playit_gg\bin`)
4. Start server - IPs will appear automatically in PlayIT tab

### Backup Management

- Backups are stored in: `ServerLaunch\backups\[ServerName]\[Timestamp]`
- Includes: `world`, `world_nether`, `world_the_end`, and `config` folder
- Restore: Select backup from dropdown and click **Restore**
- **Warning**: Server must be stopped before restoring

---

## 🐛 Troubleshooting

### Server won't start
- Verify Java is installed: `java -version` in CMD
- Check server folder has `run.bat` or `start.bat`
- Review console for error messages

### PlayIT IPs not detected
- Ensure PlayIT is installed correctly
- Start server with PlayIT path configured
- Check PlayIT is running (green status in PlayIT tab)
- IPs appear after PlayIT establishes tunnels (~10-30 seconds)

### Console not showing logs
- Restart ServerLaunch
- Verify server's `run.bat` outputs to console

### UI not translating
- Reload ServerLaunch after changing language
- Check `config\language.txt` exists

---

## 🎯 Tips & Best Practices

1. **Always use Stop** instead of Kill to avoid world corruption
2. **Enable Auto-Backup** before making major server changes
3. **Test backups** regularly by restoring to a test folder
4. **Monitor console** for warnings and errors
5. **Use Operating Hours** to save resources when no one plays
6. **Copy PlayIT IPs** and share with friends for multiplayer

---

## 📁 File Structure

```
ServerLaunch/
├── run.bat                    # Launch application
├── ServerLaunch.ps1           # Main script (do not edit)
├── README.md                  # This file
├── modules/
│   ├── BackupManager.ps1      # Backup system
│   ├── ServerManager.ps1      # Server control
│   └── ScheduleManager.ps1    # Scheduling system
├── config/
│   ├── language.txt           # Language preference
│   └── last_server.txt        # Last used server path
├── backups/
│   └── [ServerName]/          # Backup storage
│       └── [Timestamp]/       # Individual backups
└── logs/                      # Application logs
```

---

## 🌟 Support the Project

If ServerLaunch has been helpful for you, consider buying me a coffee! ☕

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-yellow?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/mrspecter07)

**Donation Link**: https://buymeacoffee.com/mrspecter07

Your support helps me maintain and improve ServerLaunch with new features!

---

## 📋 Changelog

### Version 2.1
- ✅ **Shutdown PC Option**: New option to shutdown computer after server closes
- ✅ **Operating Hours Toggle**: Enable/disable scheduled hours (24/7 mode when disabled)
- ✅ **Operating Hours Priority**: Prevent auto-shutdown during configured operating hours (don't interrupt playtime)
- ✅ **Auto-Shutdown on Inactivity**: Configurable idle timeout (X minutes without players)
- ✅ **Console Logging**: Optional console logging to files for debugging and monitoring
- ✅ **Server Load Detection**: 2-flag system detects when server is fully loaded (30-second timeout fallback)
- ✅ **Multi-Language UI**: Complete Spanish/English translation support with persistent language preference
- ✅ **Persistent Configuration**: Settings saved to JSON (auto-shutdown, operating hours, intervals, language, etc.)
- ✅ **PlayIT Optional**: LAN-only mode when PlayIT path not configured (no forced dependency)
- ✅ **Real-Time Status Updates**: Status changes translate correctly when switching languages
- ✅ **Player Count Updates**: Players Online list updates with correct language translations
- ✅ **Input Validation**: Hours and minutes automatically limited to valid ranges (0-23 and 0-59)
- ✅ **Optimized Shutdown**: Fast application close without hanging processes
- ✅ **Enhanced Console**: Real-time timestamped logging to files with auto-clear options
- ✅ **Better Explanations**: Added helpful text for each feature
- ✅ **24/7 Mode**: Server runs continuously when operating hours are disabled

### Version 2.0
- ✅ Complete UI overhaul with tabbed interface
- ✅ PlayIT integration with automatic IP detection
- ✅ Multi-language support (Spanish/English)
- ✅ Graceful server shutdown (no corruption)
- ✅ Real-time player tracking
- ✅ Automatic backup system
- ✅ Console auto-scroll and auto-clear
- ✅ Operating hours and auto-shutdown
- ✅ Modern dark theme

---

## ❓ FAQ

**Q: Does it work with modded servers?**  
A: Yes! ServerLaunch works with Forge, Fabric, Paper, Spigot, and any server that uses a batch file to start.

**Q: Can I run multiple servers?**  
A: One instance manages one server at a time. Switch servers by selecting a different folder.

**Q: Does it require administrator privileges?**  
A: No, unless your server folder is in a protected location (e.g., `C:\Program Files`).

**Q: Is my data safe?**  
A: ServerLaunch never collects or transmits your data. All operations are local.

**Q: Can I use it on Linux/Mac?**  
A: Currently Windows-only (PowerShell/WPF). Linux/Mac versions may come in the future.

---

## 📜 License

ServerLaunch is free software. You may use, modify, and distribute it freely.

**Credits**: Developed with ❤️ by MrSpecter07

---

## 🔗 Links

- **Donate**: https://buymeacoffee.com/mrspecter07
- **PlayIT**: https://playit.gg/
- **Minecraft**: https://www.minecraft.net/

---

**Thank you for using ServerLaunch! 🎮✨**
