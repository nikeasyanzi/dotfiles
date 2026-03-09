# Dotfiles

Managed via [YADM](https://yadm.io/).

## Structure

**Dotfiles (tracked by YADM):**
- **.zshrc**: Main shell configuration (cross-platform, single file with OS detection).
- **.gitconfig**: Git configuration.
- **.tmux.conf**: Tmux configuration.
- **.p10k.zsh**: Powerlevel10k prompt theme.
- **.config/nvim/**: Neovim configuration.
- **.config/yadm/bootstrap**: Package installation script (Brew/Apt).
- **.config/fonts/**: Nerd Font files for Ubuntu.

**Tooling:**
- **setup.sh**: One-line deployment script.
- **scripts/cleanup.sh**: Backup and cleanup utility.
- **scripts/download-fonts.sh**: Download Nerd Font files.
- **skills/**: Personal CLI tools (see below).

## Skills (CLI Tools)

The `skills/` directory contains personal shell scripts extracted from common command patterns. Installed automatically to `~/bin` via `skills/install.sh`.

| Command | Description |
|---------|-------------|
| `docker-nuke` | Stop & remove all containers, prune system |
| `brew-maintain` | Full Homebrew maintenance cycle |
| `grab` | Pick recent file from ~/Downloads → current dir |
| `dc` | Docker Compose wrapper with auto file detection |
| `fmt-cpp` | Run clang-format on C/C++ files |
| `git-kickstart` | Init repo → first commit → set remote → push |
| `git-squash` | Interactive rebase with smart commit count |
| `blog-new` | Create bilingual Hugo post (tw + en) |
| `uv-new` | Scaffold Python project with uv |
| `ship` | Tar + SCP + cleanup in one command |
| `run-bmc` | Launch QEMU with OpenBMC image |

```bash
# Install manually (also run by setup.sh bootstrap)
cd ~/skills && ./install.sh

# Uninstall
./skills/install.sh --uninstall
```

## CLI Tools Installed

The bootstrap process automatically installs modern CLI tools for productivity:

| Tool | Purpose | macOS | Ubuntu |
|------|---------|-------|--------|
| **fd** | Fast file finder (find alternative) | ✅ | ✅ (symlink: fdfind→fd) |
| **ripgrep** | Fast regex search (grep alternative) | ✅ | ✅ |
| **bat** | Cat with syntax highlighting | ✅ | ✅ (symlink: batcat→bat) |
| **eza** | Modern ls replacement with colors/icons | ✅ | ⚠️ Optional (not in apt) |
| **zoxide** | Smart directory navigation (z command) | ✅ | ⚠️ Optional (not in apt) |
| **fzf** | Fuzzy finder for commands/history | ✅ | ✅ |
| **yazi** | Terminal file manager | ✅ | ⚠️ Optional (not in apt) |
| **lsd** | Modern ls with icons | ✅ | ✅ |

**Note**: On Ubuntu, optional tools (eza, zoxide, yazi) not available in standard apt repos. You can install manually later:
```bash
cargo install eza zoxide yazi
```

## Font

The bootstrap installs **JetBrains Mono Nerd Font** — a developer-friendly monospace font patched with icon glyphs for Powerlevel10k and terminal tools.

| Platform | Method |
|----------|--------|
| **macOS** | `brew install --cask font-jetbrains-mono-nerd-font` |
| **Ubuntu** | Bundled `.ttf` files copied to `~/.local/share/fonts/` |

Font files for Ubuntu are stored in `.config/fonts/`. To download them:
```bash
./scripts/download-fonts.sh
```

## Quickstart

### Mac / Ubuntu

```bash
# 1. Clone & Install
curl -fsSL https://raw.githubusercontent.com/craigyang/dotfiles/main/setup.sh | bash
```

*(Note: automatic backup of existing dotfiles is performed before installation)*

## Manual Usage

**Update dotfiles:**
```bash
yadm pull
yadm bootstrap
```

**Add new file:**
```bash
yadm add <file>
yadm commit -m "Add new config"
yadm push
```

## Maintenance

- **Adding OS-specific config**: Edit `.zshrc` in the marked Darwin/Linux blocks.
- **Adding/modifying packages**: Edit `.config/yadm/bootstrap` in the `install_tools_macos()` or `install_tools_ubuntu()` functions.
- **Adding a new CLI skill**: Add script to `skills/bin/`, update the `SCRIPTS` array in `skills/install.sh`, then re-run `./skills/install.sh`.
- **Missing optional tools on Ubuntu**: If eza, zoxide, or yazi are missing, manually install via cargo (requires Rust):
  ```bash
  cargo install eza zoxide yazi
  ```
- **Troubleshooting bootstrap**: Re-run `yadm bootstrap` or execute `~/.config/yadm/bootstrap` directly for detailed output.

## Future Work

See [FUTURE.md](FUTURE.md) for planned improvements and backlog items.
