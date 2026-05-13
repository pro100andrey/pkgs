#!/bin/bash
# Update script for llama-pkg
set -e

PKG_DIR="$(dirname "$0")/../../llama-pkg"
PKGBUILD="$PKG_DIR/PKGBUILD"

# Example: fetch latest version (stub)
LATEST_VER="$(curl -s https://api.github.com/repos/ggml-org/llama.cpp/releases/latest | grep '"tag_name"' | sed -E 's/.*"b?([0-9]+)".*/\1/')"

if [[ -z "$LATEST_VER" ]]; then
    echo "Failed to fetch latest version."
    exit 1
fi

echo "Latest llama-cpp version: $LATEST_VER"

# Update PKGBUILD (simple sed, real logic may be more complex)
sed -i "s/^pkgver=.*/pkgver=$LATEST_VER/" "$PKGBUILD"
echo "PKGBUILD updated to version $LATEST_VER"
