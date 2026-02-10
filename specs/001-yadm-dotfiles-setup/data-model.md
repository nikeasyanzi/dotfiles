# Data Model: YADM Dotfiles Inventory

**Feature**: YADM Dotfiles Setup
**Date**: 2026-02-10

## Core Configuration Files

| File Path | Description | Platform Strategy |
|-----------|-------------|-------------------|
| `~/.zshrc` | Primary Zsh configuration | Shared (Internal OS detection) |
| `~/.config/nvim/` | Neovim configuration directory | Shared (lazy.nvim handles plugins) |
| `~/.tmux.conf` | Tmux configuration | Shared |
| `~/.gitconfig` | Git global configuration | Shared |
| `~/.p10k.zsh` | Powerlevel10k theme settings | Shared |
| `~/.ssh/config` | SSH host aliases | Shared (Secrets excluded) |

## Helper Scripts

| Script Path | Purpose | Execution |
|-------------|---------|-----------|
| `~/.config/yadm/bootstrap` | Installs system packages & tools | Auto-run by `yadm clone --bootstrap` |
| `setup.sh` (or curl-pipe) | Detects existing dotfiles, cleans up, installs YADM | Pre-deployment step |
