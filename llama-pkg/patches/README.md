# llama.cpp out-of-tree patches

Patches here are applied by `llama-pkg/PKGBUILD` in `prepare()`, in filename
order, on top of the `bNNNNN` tarball named by `pkgver`. They carry features
that are not in llama.cpp master yet, so every one of them is temporary.

## Selecting patches at build time

```bash
./scripts/llama-pkg/install                        # auto: apply all *.patch
LLAMA_PATCHES=off ./scripts/llama-pkg/install      # stock upstream build
LLAMA_PATCHES='0001-*' ./scripts/llama-pkg/install # only matching patches
```

A patch can also be parked by renaming it so it no longer ends in `.patch`
(for example `0001-qwen4exp-mtp.patch.disabled`).

If a patch turns out to be already contained in the tarball -- which is what
happens once upstream merges it -- `prepare()` detects that and skips it
instead of failing the build. That is the signal to delete the file.

## Patch format

Each patch is a plain `patch -p1` diff prefixed with a header that records
where it came from, so it can be regenerated rather than rebased by hand:

```
# Patch:  short title
# Repo:   https://github.com/<owner>/llama.cpp
# Branch: <branch>
# Head:   <commit sha the diff was cut from>
# Base:   b<pkgver the diff applies to>
#
# free-form description
```

`Repo`/`Branch` are the fork the work lives on; `Base` is the upstream tag the
diff was generated against.

## Managing patches

```bash
./scripts/llama-pkg/patches list     # patches, their branch, and whether Base matches pkgver
./scripts/llama-pkg/patches check    # dry-run each patch against the current pkgver tarball
./scripts/llama-pkg/patches refresh  # regenerate every patch from its branch against pkgver
```

`refresh` asks GitHub for `compare/b<pkgver>...<owner>:<repo>:<branch>`, which
is the branch diff excluding anything upstream already has. It rewrites the
diff body and the `Head`/`Base` header lines, keeping the description. Set
`GITHUB_TOKEN` if you hit API rate limits.

`check` caches the upstream source tree under `~/.cache/pkgs/llama-src`.

## Adding a patch

1. Create `patches/NNNN-short-name.patch` with the header above, an empty diff
   body, and the fork's `Repo`/`Branch`.
2. Run `./scripts/llama-pkg/patches refresh NNNN-short-name.patch` to
   fill in the diff.
3. Run `./scripts/llama-pkg/patches check`.

For a one-off diff with no upstream branch, just drop the file in with a
`Base:` line and skip `refresh`.
