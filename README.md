# Package Workspace

This repository contains local Arch Linux package recipes and helper scripts for:

- `visual-studio-code` (official binary package recipe)
- `claude-desktop` (official binary package recipe, repackaged from the upstream `.deb`)
- `llama-cpp` (optimized local build recipe + optional systemd service)

## Repository Layout

- `scripts/`: operational helpers (status checks, version bumps, installs)
- `visual-studio-code/`: package recipe and desktop templates
- `claude-desktop/`: package recipe
- `llama-pkg/`: package recipe, model presets, benchmark notes, service files
- `llama-pkg/patches/`: out-of-tree llama.cpp patches applied at build time

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
./scripts/llama-pkg/install

# Refresh llama preset file only
./scripts/llama-pkg/install config

# Inspect / verify / regenerate the llama.cpp out-of-tree patches
./scripts/llama-pkg/patches list
./scripts/llama-pkg/patches check
./scripts/llama-pkg/patches refresh

# Optional cleanup (destructive, asks for confirmation)
./scripts/visual-studio-code/install cleanup
./scripts/llama-pkg/install cleanup
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

## Llama Service

Use the service manager script to install or manage `llama-server` as a systemd service:

```bash
sudo ./llama-pkg/service install
sudo ./llama-pkg/service status
```

## Llama Build Profiles

`llama-pkg/PKGBUILD` supports build-time selectors via environment variables.

- `LLAMA_GPU_BACKEND`:
	- `auto` (default): NVIDIA -> CUDA, otherwise Vulkan
	- `cuda`, `vulkan`, `both`, `cpu`
- CPU profile:
	- fixed to `native` (optimized for the local build host)
- `LLAMA_CUDA_ARCH` (used when CUDA is enabled):
	- `auto` (default): detect from `nvidia-smi` when available; fallback to CMake default detection
	- `native`
	- explicit list like `86;89`

Examples:

```bash
# Default fast-local autodetect (recommended for one machine)
./scripts/llama-pkg/install

# Force CUDA
LLAMA_GPU_BACKEND=cuda ./scripts/llama-pkg/install

# Pin CUDA architectures explicitly
LLAMA_GPU_BACKEND=cuda LLAMA_CUDA_ARCH="86;89" ./scripts/llama-pkg/install
```

## Llama Patches

`llama-pkg/patches/` holds `patch -p1` diffs applied to the upstream tarball in
`prepare()`, in filename order. They carry features that have not landed in
llama.cpp master yet, so each one is meant to be dropped again later.

Currently shipped:

- `0001-qwen4exp-mtp.patch`: the qwen4exp NextN/MTP draft head from
  [`danielhanchen/llama.cpp qwen4exp/mtp`](https://github.com/danielhanchen/llama.cpp/tree/qwen4exp/mtp)

`LLAMA_PATCHES` selects what gets applied:

```bash
# Default: apply every patches/*.patch
./scripts/llama-pkg/install

# Stock upstream build, no patches
LLAMA_PATCHES=off ./scripts/llama-pkg/install

# Only some patches (names or globs, space- or comma-separated)
LLAMA_PATCHES='0001-*' ./scripts/llama-pkg/install
```

A patch can also be parked by renaming it so it no longer ends in `.patch`.
Once a patch is merged upstream, `prepare()` notices it is already in the
tarball and skips it rather than failing the build.

Patches are cut against a specific `bNNNNN` tag, so a version bump can make
them stale; `./scripts/llama-pkg/update set <ver>` says so, and
`./scripts/llama-pkg/patches refresh` regenerates them from their fork branch.
See `llama-pkg/patches/README.md` for the patch header format.