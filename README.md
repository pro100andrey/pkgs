# Package Workspace

This repository contains local Arch Linux package recipes and helper scripts for:

- `visual-studio-code` (official binary package recipe)
- `llama-cpp` (optimized local build recipe + optional systemd service)

## Repository Layout

- `scripts/`: operational helpers (status checks, version bumps, installs)
- `visual-studio-code/`: package recipe and desktop templates
- `llama-pkg/`: package recipe, model presets, benchmark notes, service files

## Script Usage

```bash
# Show current vs upstream versions for all package recipes
./scripts/update

# Interactively bump outdated recipe versions
./scripts/update bump

# Show or bump a single recipe
./scripts/update visual-studio-code
./scripts/update visual-studio-code bump

# Build/install package only when local installed version differs from PKGBUILD
./scripts/visual-studio-code/install
./scripts/llama-pkg/install

# Refresh llama preset file only
./scripts/llama-pkg/install config

# Optional cleanup (destructive, asks for confirmation)
./scripts/visual-studio-code/install cleanup
./scripts/llama-pkg/install cleanup
```

## Llama Service

Use the service manager script to install or manage `llama-server` as a systemd service:

```bash
sudo ./llama-pkg/service install
sudo ./llama-pkg/service status
```