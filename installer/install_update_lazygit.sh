#!/bin/bash

# Function to get the system architecture
get_system_architecture() {
    case "$(uname -m)" in
        x86_64)
            echo "x86_64"
            ;;
        arm64)
            echo "arm64"
            ;;
        aarch64)
            echo "arm64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Default installation path
INSTALL_PATH="${HOME}/.local/bin"

# Parse command-line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
    --bin-dir)
        INSTALL_PATH="$2"
        shift 2
        ;;
    --bin-dir=*)
        INSTALL_PATH="${1#*=}"
        shift 1
        ;;
    -h | --help)
        echo "Usage: $0 [--bin-dir /path/to/install]"
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Path for downloading and extracting
DOWNLOAD_PATH="/tmp"

# Change to the download path
cd "$DOWNLOAD_PATH" || exit

# Get the latest LazyGit version
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')

# Get the system os & architecture
OS=$(uname)
ARCH=$(get_system_architecture)

# Download LazyGit
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_${OS}_${ARCH}.tar.gz"

# Extract LazyGit
tar xf lazygit.tar.gz lazygit

# Install LazyGit
mkdir -p -- "$INSTALL_PATH"
install lazygit -D -t "$INSTALL_PATH"

# Clean up downloaded files
rm -f lazygit.tar.gz lazygit

echo "LazyGit ${LAZYGIT_VERSION} has been successfully installed in $INSTALL_PATH!"
