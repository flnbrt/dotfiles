#!/bin/bash

# Function to get the system architecture
get_system_architecture() {
    case "$(uname -m)" in
        x86_64)
            echo "amd64"
            ;;
        aarch64)
            echo "arm64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Path for downloading and extracting
DOWNLOAD_PATH="/tmp"

# Change to the download path
cd "$DOWNLOAD_PATH" || exit

# Get the latest LazyGit version
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Get the system architecture
ARCH=$(get_system_architecture)

# Download LazyGit
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_$(uname)_${ARCH}.tar.gz"

# Extract LazyGit
tar xf lazygit.tar.gz lazygit

# Install LazyGit
sudo install lazygit -D -t /usr/local/bin/

# Clean up downloaded files
rm -f lazygit.tar.gz lazygit

echo "LazyGit ${LAZYGIT_VERSION} has been successfully installed!"

