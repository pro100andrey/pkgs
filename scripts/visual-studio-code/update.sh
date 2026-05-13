#!/bin/bash
# Update script for visual-studio-code
set -e

PKG_DIR="$(dirname "$0")/../../visual-studio-code"
PKGBUILD="$PKG_DIR/PKGBUILD"

# Example: fetch latest version (stub)
LATEST_VER="$(curl -s https://update.code.visualstudio.com/api/releases/stable | grep -o '"[0-9.]*"' | head -1 | tr -d '"')"

if [[ -z "$LATEST_VER" ]]; then
    echo "Failed to fetch latest version."
    exit 1
fi

echo "Latest VSCode version: $LATEST_VER"

# Update PKGBUILD (simple sed, real logic may be more complex)
sed -i "s/^pkgver=.*/pkgver=$LATEST_VER/" "$PKGBUILD"
echo "PKGBUILD updated to version $LATEST_VER"
