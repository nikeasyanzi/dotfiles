# Dotfiles

Plain git repo + symlinks. No extra tools required.

## Structure

**Dotfiles** (symlinked to `$HOME` by `scripts/link.sh`):
- **.zshrc**: Main shell configuration (cross-platform, single file with OS detection).
- **.gitconfig**: Git configuration.
- **.tmux.conf**: Tmux configuration.
- **.p10k.zsh**: Powerlevel10k prompt theme.
- **.config/nvim/**: Neovim configuration (LazyVim).
- **Meslo Nerd Font patched for Powerlevel10k/**: Bundled font files.

**Scripts:**
- **setup.sh**: One-line deployment script.
- **scripts/link.sh**: Symlink dotfiles to `$HOME`.
- **scripts/bootstrap.sh**: Install packages, fonts, Oh My Zsh, shell setup.
- **scripts/cleanup.sh**: Backup and remove existing configs.
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
# Install manually (also run by setup.sh)
cd ~/.dotfiles/skills && ./install.sh

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
| **lsd** | Modern ls with icons | ✅ | ⚠️ Optional (not in apt) |

**Note**: On Ubuntu, optional tools (eza, zoxide, yazi, lsd) not available in standard apt repos. You can install manually later:
```bash
cargo install eza zoxide yazi lsd
```

## Font

The bootstrap installs **Meslo Nerd Font** (patched for Powerlevel10k) — font files are bundled in the repo, no download needed.

| Platform | Destination |
|----------|-------------|
| **macOS** | `~/Library/Fonts/` |
| **Ubuntu** | `~/.local/share/fonts/` |

## Bootstrap Details

The bootstrap (`scripts/bootstrap.sh`) performs these steps:

1. **CLI Tools** — installs fd, ripgrep, bat, eza, zoxide, fzf, yazi, lsd (+ git, neovim, tmux, zsh)
2. **Fonts** — installs Meslo Nerd Font
3. **Oh My Zsh** — installs Oh My Zsh, Powerlevel10k theme, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, zsh-history-substring-search
4. **Shell** — sets zsh as default shell (uses `usermod` instead of `chsh` to avoid interactive prompt when run via `curl | bash`)

## Quickstart

### Mac / Ubuntu

```bash
# 1. Clone & Install
curl -fsSL https://raw.githubusercontent.com/nikeasyanzi/dotfiles/main/setup.sh | bash
```

*(Automatic backup of existing dotfiles is performed before installation)*

## Manual Usage

**Update dotfiles:**
```bash
cd ~/.dotfiles && git pull
./scripts/link.sh
./scripts/bootstrap.sh
```

**Add new file:**
```bash
cd ~/.dotfiles
git add <file>
git commit -m "Add new config"
git push
```

## Maintenance

- **Adding OS-specific config**: Edit `.zshrc` in the marked Darwin/Linux blocks.
- **Adding/modifying packages**: Edit `scripts/bootstrap.sh` in the `install_tools_macos()` or `install_tools_ubuntu()` functions.
- **Adding a new dotfile**: Add symlink entry in `scripts/link.sh`, then re-run `./scripts/link.sh`.
- **Adding a new CLI skill**: Add script to `skills/bin/`, update the `SCRIPTS` array in `skills/install.sh`, then re-run `./skills/install.sh`.
- **Missing optional tools on Ubuntu**: If eza, zoxide, or yazi are missing, manually install via cargo (requires Rust):
  ```bash
  cargo install eza zoxide yazi
  ```
- **Troubleshooting bootstrap**: Re-run `./scripts/bootstrap.sh` for detailed output.

See [FUTURE.md](FUTURE.md) for planned improvements.
