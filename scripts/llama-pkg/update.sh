#!/bin/bash
set -euo pipefail

PKG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../llama-pkg" && pwd)"
PKGBUILD="$PKG_DIR/PKGBUILD"

get_current() {
    grep -o '^pkgver=\S*' "$PKGBUILD" 2>/dev/null | sed 's/^pkgver=//' || true
}

get_latest() {
    local tag
    tag="$(curl -sfL -H "User-Agent: pkgs-update-script" "https://api.github.com/repos/ggml-org/llama.cpp/releases/latest" |
        grep '"tag_name"' |
        sed -E 's/.*"tag_name"\s*:\s*"b?([0-9]+)".*/\1/' |
        head -n1)"

    [[ -n "$tag" ]] && echo "$tag" || return 1
}

set_pkgver() {
    local ver="$1"
    sed -i "s/^pkgver=.*/pkgver=${ver}/" "$PKGBUILD"
    echo "==> llama-pkg: pkgver updated to ${ver} in $PKGBUILD"
}

case "${1:-status}" in
current)
    get_current
    ;;
latest)
    get_latest
    ;;
set)
    [[ -n "${2:-}" ]] || {
        echo "Missing version"
        exit 1
    }
    set_pkgver "$2"
    ;;
status)
    current="$(get_current)"
    latest="$(get_latest 2>/dev/null || echo error)"
    echo "current=$current latest=$latest"
    ;;
*)
    echo "Usage: $0 {current|latest|set <ver>|status}"
    exit 1
    ;;
esac
