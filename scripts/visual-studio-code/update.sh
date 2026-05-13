#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$SCRIPT_DIR/../common.sh"

PKG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../visual-studio-code" && pwd)"
PKGBUILD="$PKG_DIR/PKGBUILD"

get_current() {
    grep -o '^pkgver=\S*' "$PKGBUILD" 2>/dev/null | sed 's/^pkgver=//' || true
}

get_latest() {
    local ver
    ver="$(curl -sfL https://update.code.visualstudio.com/api/releases/stable |
        grep -o '"[0-9][0-9.]*"' |
        head -n1 |
        tr -d '"')"

    [[ -n "$ver" ]] && echo "$ver" || return 1
}

set_pkgver() {
    local ver="$1"
    sed -i "s/^pkgver=.*/pkgver=${ver}/" "$PKGBUILD"
    echo "==> visual-studio-code: pkgver updated to ${ver} in $PKGBUILD"
}

run_update_command "$@"
