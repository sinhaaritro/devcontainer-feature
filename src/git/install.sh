#!/bin/bash
set -e

# Get options from devcontainer-feature.json
VERSION=${VERSION:-latest}
SKIP_UPDATE=${SKIP_UPDATE:-false}

# Detect OS and install Git accordingly
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot detect OS. Exiting."
    exit 1
fi

case "$OS" in
    "debian" | "ubuntu")
        if [ "$SKIP_UPDATE" = "false" ]; then
            apt-get update
        fi
        if [ "$VERSION" = "latest" ]; then
            apt-get install -y git
        else
            apt-get install -y git="$VERSION"
        fi
        rm -rf /var/lib/apt/lists/*
        ;;
    "arch")
        if [ "$SKIP_UPDATE" = "false" ]; then
            pacman -Syu --noconfirm
        fi
        if [ "$VERSION" = "latest" ]; then
            pacman -S --noconfirm git
        else
            pacman -S --noconfirm git="$VERSION"
        fi
        ;;
    "alpine")
        if [ "$SKIP_UPDATE" = "false" ]; then
            apk update
        fi
        if [ "$VERSION" = "latest" ]; then
            apk add git
        else
            apk add git="$VERSION"
        fi
        ;;
    *)
        echo "Unsupported OS: $OS. Exiting."
        exit 1
        ;;
esac

echo "Git installed successfully."
