#!/bin/bash
set -e

# Variables from devcontainer-feature.json options
VERSION="${VERSION:-latest}"
SKIP_UPDATE="${SKIP_UPDATE:-false}"

echo "Starting Neovim Feature installation..."
echo "Running as user: $(whoami)"
echo "Installing Neovim version: $VERSION"

# Check for apt-get (Debian-based system)
if ! command -v apt-get >/dev/null 2>&1; then
  echo "Error: This Feature requires a Debian-based image with apt-get."
  exit 1
fi

# Update package index unless skipped
if [ "$SKIP_UPDATE" != "true" ]; then
  echo "Running apt-get update..."
  apt-get update
else
  echo "Skipping apt-get update as per option."
fi

# Install necessary packages for Mason and Neovim
echo "Installing packages: nodejs, npm, unzip, luarocks, curl, jq..."
apt-get install -y nodejs npm unzip luarocks curl jq

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    ARCH_SUFFIX="linux-x86_64"
    ;;
  aarch64)
    ARCH_SUFFIX="linux-aarch64"
    ;;
  *)
    echo "Error: Unsupported architecture: $ARCH"
    exit 1
    ;;
esac
echo "Detected architecture: $ARCH_SUFFIX"

# Determine the download URL based on VERSION
if [ "$VERSION" = "latest" ]; then
  echo "Fetching the latest Neovim release tag..."
  VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r .tag_name)
  if [ -z "$VERSION" ]; then
    echo "Error: Failed to fetch the latest Neovim version."
    exit 1
  fi
  echo "Latest version is: $VERSION"
  URL="https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-${ARCH_SUFFIX}.tar.gz"
else
  # Remove 'v' prefix if present for comparison
  VERSION_NUM=$(echo "$VERSION" | sed 's/^v//')
  # Compare version with 0.10.3
  if printf '%s\n' "0.10.3" "$VERSION_NUM" | sort -V | tail -n1 | grep -q "^$VERSION_NUM$"; then
    # VERSION > 0.10.3 or equal to a version after 0.10.3
    URL="https://github.com/neovim/neovim/releases/download/v${VERSION_NUM}/nvim-${ARCH_SUFFIX}.tar.gz"
  else
    # VERSION <= 0.10.3
    URL="https://github.com/neovim/neovim/releases/download/v${VERSION_NUM}/nvim-linux64.tar.gz"
  fi
fi

# Download the Neovim binary release
echo "Downloading Neovim from $URL..."
curl -L -o /tmp/nvim.tar.gz "$URL"

# Check if download was successful
if [ ! -s /tmp/nvim.tar.gz ]; then
  echo "Error: Downloaded file is empty or missing."
  exit 1
fi

# Extract to /opt/nvim
echo "Extracting Neovim to /opt/nvim..."
rm -rf /opt/nvim
mkdir -p /opt/nvim
tar -xzf /tmp/nvim.tar.gz -C /opt/nvim --strip-components=1

# Create symlink to make nvim accessible
ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

# Clean up temporary file
rm /tmp/nvim.tar.gz

# Verify installation
if command -v nvim >/dev/null 2>&1; then
  echo "Neovim installed successfully: $(nvim --version | head -n 1)"
else
  echo "Error: Neovim installation failed."
  exit 1
fi

echo "Neovim Feature installation complete."
