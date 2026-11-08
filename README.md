# Package Workspace

This repository contains local Arch Linux package recipes and helper scripts for:

- `visual-studio-code` (official binary package recipe)
- `claude-desktop` (official binary package recipe, repackaged from the upstream `.deb`)

## Repository Layout

- `scripts/`: operational helpers (status checks, version bumps, installs)
- `visual-studio-code/`: package recipe and desktop templates
- `claude-desktop/`: package recipe

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
./scripts/claude-desktop/install

# Optional cleanup (destructive, asks for confirmation)
./scripts/visual-studio-code/install cleanup
```

## Claude Desktop

`claude-desktop/PKGBUILD` repackages the official Debian package from Anthropic's
apt repository (`downloads.claude.ai`). The download link advertised on
claude.ai redirects into that same pool but is behind a Cloudflare challenge,
so the pool URL is used directly; version checks read the apt index.

Cowork runs its sandbox in a QEMU virtual machine. That stack is optional here,
so install it explicitly if Cowork is needed:

```bash
sudo pacman -S --asdeps qemu-system-x86 edk2-ovmf
```

The bash sandbox of the built-in Claude Code additionally uses `bubblewrap` and
`socat`.

llama.cpp is no longer packaged here: it is built locally in `~/llm`
(`config/llama-build.sh`, `run update`), with no system install or service.
