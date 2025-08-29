#!/bin/bash

NVCURSOR_VERSION="1.0.0"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Help function
show_help() {
    echo -e "${GREEN}Cursor Updater${NC}"
    echo ""
    echo -e "${BLUE}USAGE:${NC}"
    echo "  nvcursor [OPTIONS]"
    echo ""
    echo -e "${BLUE}OPTIONS:${NC}"
    echo -e "  ${YELLOW}-h, --help${NC}      Show this help message"
    echo -e "  ${YELLOW}-v, --version${NC}   Show current Cursor version"
    echo -e "  ${YELLOW}-f, --force${NC}     Force update even if already up to date"
    echo ""
    echo -e "${BLUE}DESCRIPTION:${NC}"
    echo "  This script automatically downloads and installs the latest version"
    echo "  of Cursor IDE for Linux. It checks the current version against the"
    echo "  latest available version and only updates if necessary."
    echo ""
    echo ""
    echo -e "${GREEN}▶ ${BLUE}EXAMPLES:${NC}"
    echo -e "  ${GREEN}nvcursor${NC}                 ${YELLOW}# Install Cursor if not present, or update to latest version${NC}"
    echo -e "  ${GREEN}nvcursor --version${NC}       ${YELLOW}# Show current installed version${NC}"
    echo -e "  ${GREEN}nvcursor --force${NC}         ${YELLOW}# Force update regardless of current version${NC}"
    echo ""
    echo ""
    echo -e "${BLUE}NOTES:${NC}"
    echo "  - Requires sudo privileges for installation"
    echo "  - Follows XDG Base Directory Specification for cache storage"
    echo "  - Version information stored in: \$XDG_CACHE_HOME/cursor-updater/version"
    echo "  - GitHub repository: https://github.com/novecento/cursor-updater"
    echo ""
    echo -e "${BLUE}AUTHOR:${NC}"
    echo "  Tamirlan Akanov <akanovtt@gmail.com>"
    echo "  GitHub: https://github.com/novecento050795"
    echo ""
}

# Check for help flag
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi


# File to store the current version (following XDG Base Directory Specification)
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
VERSION_FILE="$XDG_CACHE_HOME/cursor-updater/version"

if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo -e "${GREEN}NVCursor version: $NVCURSOR_VERSION${NC}"
    if [ -f "$VERSION_FILE" ]; then
        echo -e "${GREEN}Cursor version: $(cat $VERSION_FILE)${NC}"
    else
        echo -e "${YELLOW}No version file found.${NC}"
    fi
    exit 0
fi

FORCE_UPDATE=false
if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
    FORCE_UPDATE=true
    echo -e "${YELLOW}Force update mode enabled${NC}"
fi

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Don't run this script as root directly. It will request sudo when needed.${NC}"
    exit 1
fi

# Request sudo password upfront and keep it alive
echo -e "${YELLOW}This script requires sudo privileges to install Cursor.${NC}"
sudo -v

# Keep sudo alive (update timestamp every 5 minutes until script exits)
while true; do sudo -n true; sleep 300; kill -0 "$$" || exit; done 2>/dev/null &

# Create cache directory if it doesn't exist
mkdir -p "$(dirname "$VERSION_FILE")"

echo -e "${BLUE}Checking for Cursor updates...${NC}"

response=$(curl -s 'https://cursor.com/api/download?platform=linux-x64&releaseTrack=stable')

url=$(echo $response | jq -r '.downloadUrl')
version=$(echo $response | jq -r '.version')

# Read current version from file if it exists
if [ -f "$VERSION_FILE" ]; then
    current_version=$(cat "$VERSION_FILE")
    echo -e "${YELLOW}Current version: $current_version${NC}"
    echo -e "${YELLOW}Latest version: $version${NC}"
    
    # Compare versions
   if [ "$current_version" = "$version" ] && [ "$FORCE_UPDATE" = false ]; then
       echo -e "${GREEN}Cursor is already up to date (version $version)${NC}"
       exit 0
   fi
    
    echo -e "${BLUE}New version available! Updating...${NC}"
else
    echo -e "${YELLOW}No version file found. Installing Cursor version: $version${NC}"
fi

echo -e "${BLUE}Downloading Cursor...${NC}"
wget $url

# Check if old Cursor file exists before removing
old_cursor_exists=false
if [ -f "/opt/cursor/cursor.AppImage" ]; then
    old_cursor_exists=true
    echo -e "${YELLOW}Found existing Cursor installation${NC}"
else
    echo -e "${YELLOW}No existing Cursor installation found${NC}"
fi

if [ "$old_cursor_exists" = true ]; then
    echo -e "${YELLOW}Removing old Cursor...${NC}"
    sudo rm -f /opt/cursor/cursor.AppImage
fi

echo -e "${BLUE}Moving new Cursor to /opt/cursor/...${NC}"
sudo mkdir -p /opt/cursor
sudo mv Cursor-*.AppImage /opt/cursor/cursor.AppImage

echo -e "${YELLOW}Making Cursor executable...${NC}"
sudo chmod +x /opt/cursor/cursor.AppImage

# Use the old_cursor_exists variable for additional logic
if [ "$old_cursor_exists" = true ]; then
    echo -e "${GREEN}Cursor updated to: $version${NC}"
else
    echo -e "${BLUE}Downloading Cursor icon...${NC}"
    sudo wget -O /opt/cursor/logo.svg "https://mintcdn.com/cursor/E7JVsKUF5L-IiJRB/images/logo/app-logo.svg?maxW=100&auto=format&n=E7JVsKUF5L-IiJRB&q=85&s=e775fba4801b751c88adc6cc6f1dcc23"

    echo -e "${BLUE}Creating desktop file...${NC}"
    sudo tee /usr/share/applications/cursor.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Cursor
Exec=/opt/cursor/cursor.AppImage --no-sandbox
Icon=/opt/cursor/logo.svg
Type=Application
Categories=Development;IDE;
StartupNotify=true
EOF

    echo -e "${BLUE}Making desktop file executable...${NC}"
    sudo chmod +x /usr/share/applications/cursor.desktop
    update-desktop-database ~/.local/share/applications/
    echo -e "${GREEN}Cursor installed successfully! Version: $version${NC}"
fi

# Save the new version to file
echo "$version" > "$VERSION_FILE"
echo -e "${GREEN}Version saved for future checks${NC}"

