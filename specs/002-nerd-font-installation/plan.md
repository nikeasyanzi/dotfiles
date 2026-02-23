# Implementation Plan: Nerd Font Installation

**Branch**: `002-nerd-font-installation` | **Date**: 2026-02-23 | **Spec**: [spec.md](spec.md)

## Summary

Add JetBrains Mono Nerd Font installation to the dotfiles bootstrap for both macOS and Ubuntu. On macOS, install via `brew install --cask font-jetbrains-mono-nerd-font`. On Ubuntu, bundle `.ttf` files in the repo at `.config/fonts/` and copy them to `~/.local/share/fonts/` at bootstrap time with `fc-cache -fv`. No idempotency checks — overwrite is safe.

**Technical approach**: Add an `install_fonts_macos()` and `install_fonts_ubuntu()` function to `.config/yadm/bootstrap`, called after CLI tool installation. Download the JetBrains Mono Nerd Font release once and commit the `.ttf` files to `.config/fonts/` in the repo.

## Technical Context

**Language/Version**: Bash 4+ (macOS/Ubuntu standard)
**Primary Dependencies**: Homebrew (macOS), `fc-cache` / `fontconfig` (Ubuntu — pre-installed)
**Storage**: ~10MB of `.ttf` files committed to `.config/fonts/`
**Testing**: Manual verification — `fc-list | grep JetBrains` on Ubuntu, Font Book on macOS
**Target Platform**: macOS (Intel & Apple Silicon), Ubuntu 20.04+
**Project Type**: Shell scripts / Dotfiles bootstrap
**Constraints**: No network dependency at deployment on Ubuntu; safe to re-run

## Constitution Check

✅ **Simplicity**: macOS uses a single `brew install --cask` command; Ubuntu copies files and runs `fc-cache`
✅ **Platform Agnostic**: OS detection already exists in bootstrap; adds platform-specific font functions
✅ **Idempotency**: `brew install` skips existing casks; file copy + `fc-cache` is always safe
✅ **Minimal Scope**: Only JetBrains Mono; no extensible font management system
✅ **No Network on Deploy (Ubuntu)**: Font files bundled in repo — zero download at bootstrap time

**Status**: ✅ PASS

## Project Structure

### New Files

```text
.config/
├── fonts/                              # NEW: Bundled font files (~10MB)
│   └── JetBrainsMonoNerdFont-*.ttf     # All weight variants
```

### Modified Files

```text
.config/yadm/
└── bootstrap          # MODIFIED: Add install_fonts_macos() and install_fonts_ubuntu()
README.md              # MODIFIED: Document font requirement
```

## Implementation Strategy

### Phase 1: Bundle Font Files
- Download JetBrains Mono Nerd Font release (latest `.ttf` files)
- Place in `.config/fonts/` directory
- Commit to repo (~10MB)

### Phase 2: macOS Bootstrap
- Add `install_fonts_macos()` function to bootstrap
- Single command: `brew install --cask font-jetbrains-mono-nerd-font`
- Progress message: `echo "🔤 Installing JetBrains Mono Nerd Font..."`

### Phase 3: Ubuntu Bootstrap
- Add `install_fonts_ubuntu()` function to bootstrap
- Create `~/.local/share/fonts/` if needed
- Copy `.config/fonts/*.ttf` to `~/.local/share/fonts/`
- Run `fc-cache -fv`
- Progress message: `echo "🔤 Installing JetBrains Mono Nerd Font..."`

### Phase 4: Integration
- Call font install functions in bootstrap after CLI tools, before Oh My Zsh
- Ordering: Homebrew setup → CLI tools → **Fonts** → Oh My Zsh → Shell setup
- Update README.md with font info

### Phase 5: Validation
- macOS: Verify font in Font Book or `brew list --cask | grep font`
- Ubuntu: Verify with `fc-list | grep -i "JetBrains"`
- Visual: Powerlevel10k prompt renders icons correctly
