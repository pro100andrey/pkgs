#!/bin/bash

# Shared command dispatcher for package update scripts.
# Requires functions in caller script:
# - get_current
# - get_latest
# - set_pkgver
run_update_command() {
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
        local current latest
        current="$(get_current)"
        latest="$(get_latest 2>/dev/null || echo error)"
        echo "current=$current latest=$latest"
        ;;
    *)
        echo "Usage: $0 {current|latest|set <ver>|status}"
        exit 1
        ;;
    esac
}
