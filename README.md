# nvcursor

_[Русский](README_ru.md) | English_

Automatic Cursor IDE updater for Linux

## Description

`nvcursor` is a bash script for automatic installation and updating of Cursor IDE on Linux systems. The script checks the current version, compares it with the latest available version, and updates when necessary.

## Features

- ✅ Automatic checking and downloading of the latest Cursor version
- ✅ Version comparison to avoid unnecessary updates
- ✅ Force update when needed
- ✅ Automatic creation of desktop file and icon
- ✅ Follows XDG Base Directory Specification
- ✅ Colored output for better UX
- ✅ Safe installation without running as root

## Requirements

- Linux system with AppImage support
- `curl` for API requests
- `jq` for JSON parsing
- `wget` for downloading files
- `sudo` privileges for installation

### Installing dependencies

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install curl jq wget
```

**CentOS/RHEL/Fedora:**

```bash
# Fedora
sudo dnf install curl jq wget

# CentOS/RHEL
sudo yum install curl jq wget
```

**Arch Linux:**

```bash
sudo pacman -S curl jq wget
```

## Installing nvcursor

### Method 1: Quick installation

```bash
# Download and install in one step
curl -fsSL https://raw.githubusercontent.com/novecento/cursor-updater/main/nvcursor.sh -o nvcursor.sh
chmod +x nvcursor.sh
sudo mv nvcursor.sh /usr/local/bin/nvcursor
```

### Method 2: Clone repository

```bash
git clone https://github.com/novecento/cursor-updater.git
cd cursor-updater
chmod +x nvcursor.sh
sudo cp nvcursor.sh /usr/local/bin/nvcursor
```

### Method 3: Manual installation

```bash
# Download script
wget https://raw.githubusercontent.com/novecento/cursor-updater/main/nvcursor.sh

# Make executable
chmod +x nvcursor.sh

# Move to system directory (optional)
sudo mv nvcursor.sh /usr/local/bin/nvcursor
```

## Usage

### Basic commands

```bash
# Install Cursor (if not installed) or update to latest version
nvcursor

# Show current version
nvcursor --version
nvcursor -v

# Force update (even if version is current)
nvcursor --force
nvcursor -f

# Show help
nvcursor --help
nvcursor -h
```

### Usage examples

```bash
# Initial Cursor installation
$ nvcursor
This script requires sudo privileges to install Cursor.
[sudo] password for user:
Checking for Cursor updates...
No version file found. Installing Cursor version: 0.42.0
Downloading Cursor...
...
Cursor installed successfully! Version: 0.42.0

# Check for updates (when version is current)
$ nvcursor
Current version: 0.42.0
Latest version: 0.42.0
Cursor is already up to date (version 0.42.0)

# Check current version
$ nvcursor --version
Cursor version: 0.42.0
```

## How it works

1. **Version check**: Script requests the latest version via Cursor API
2. **Comparison**: Compares with locally saved version
3. **Download**: Downloads new version if necessary
4. **Installation**: Installs Cursor to `/opt/cursor/`
5. **Integration**: Creates desktop file for system integration
6. **Saving**: Saves version information for future checks

## File locations

- **Executable file**: `/opt/cursor/cursor.AppImage`
- **Icon**: `/opt/cursor/logo.svg`
- **Desktop file**: `/usr/share/applications/cursor.desktop`
- **Version information**: `$XDG_CACHE_HOME/cursor-updater/version` (usually `~/.cache/cursor-updater/version`)

## Security

- ❌ Script does **NOT** run as root
- ✅ Requests sudo only for installation operations
- ✅ Automatically maintains sudo session during execution
- ✅ Checks access permissions before execution

## Author

**Tamirlan Akanov**

- Email: akanovtt@gmail.com
- GitHub: [@novecento050795](https://github.com/novecento050795)

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

If you encounter problems or have suggestions:

1. Create an issue in the [GitHub repository](https://github.com/novecento/cursor-updater)
2. Check that all dependencies are installed
3. Make sure you have sudo privileges
4. Run the script with the `--help` flag for detailed information
