# YADM Dotfiles Management Setup

A cross-platform dotfiles management system using YADM to backup, version control, and deploy configurations across Mac and Ubuntu Linux systems.

## Files to Manage

| File/Directory    | Purpose                          |
| ----------------- | -------------------------------- |
| `~/.zshrc`        | Zsh shell configuration          |
| `~/.config/nvim/` | Neovim configuration             |
| `~/.tmux.conf`    | Tmux terminal multiplexer config |
| `~/.gitconfig`    | Git configuration                |
| `~/.p10k.zsh`     | Powerlevel10k theme config       |
| `~/.ssh/config`   | SSH client configuration         |

---

## Proposed Setup

### Phase 1: Initial YADM Setup (Mac - Current Machine)

#### Step 1: Install YADM

```bash
# Mac
brew install yadm

# Ubuntu
sudo apt install yadm
```

#### Step 2: Initialize YADM Repository

```bash
yadm init
yadm remote add origin <your-git-repo-url>
```

> [!IMPORTANT]
> You'll need to create a **private** GitHub/GitLab repository (e.g., `github.com/craigyang/dotfiles`) to store your configurations.

#### Step 3: Add Configuration Files
```bash
yadm add ~/.zshrc
yadm add ~/.config/nvim
yadm add ~/.tmux.conf
yadm add ~/.gitconfig
yadm add ~/.p10k.zsh
yadm add ~/.ssh/config
yadm commit -m "Initial dotfiles backup"
yadm push -u origin main
```

---

### Phase 2: Cleanup and Migration (Cross-Platform Strategy)

To ensure configs work seamlessly on both Mac and Ubuntu, we will implement a "Clean Once, Apply Everywhere" strategy.

#### 1. Universal Portability (Mac & Ubuntu)
We will audit and refactor all config files to remove local assumptions:
- **Paths**: Replace `/Users/craigyang/` (Mac) or `/home/craigyang/` (Ubuntu) with `$HOME`.
- **Binaries**: Use `command -v <tool>` checks before sourcing tool-specific configs (e.g., `zoxide`, `fzf`).
- **Shell Integration**: Wrap Mac-specific terminal settings (Ghostty/iTerm2) in `[[ "$OSTYPE" == "darwin"* ]]` blocks.

#### 2. Modular Configuration (The "Common" approach)
Instead of one massive `.zshrc`, we will structure it for easy maintenance:
- `~/.zshrc`: Shell entry point (shared).
- `~/.zshrc##os.Darwin`: Mac-specific overrides (Homebrew paths, Mac aliases).
- `~/.zshrc##os.Linux`: Ubuntu-specific overrides (Snap/Apt paths, Linux aliases).

#### 3. Migration Workflow
1. **The "Dirty" Push**: Backup existing Mac configs as is (Phase 1).
2. **The Cleanup**: 
    - Edit `.zshrc` on Mac to be portable.
    - Test on Mac.
    - Commit and Push.
3. **The Linux Test**: 
    - Clone on Ubuntu.
    - YADM will automatically link `~/.zshrc##os.Linux`.
    - Fix any Ubuntu-specific issues and Push back.
4. **The Cycle**: Any improvement made on one platform becomes available to the other via `yadm pull`.

---

### Phase 3: Cross-Platform Configuration with Alternates (YADM Mechanics)

YADM supports **alternate files** for platform-specific configurations using a naming convention:

```
~/.config/nvim/init.lua##os.Darwin    → Mac-specific
~/.config/nvim/init.lua##os.Linux     → Linux-specific
~/.config/nvim/init.lua                → Shared/default
```

#### Alternate File Structure

```
~/.zshrc##os.Darwin           # Mac-specific zshrc
~/.zshrc##os.Linux            # Ubuntu-specific zshrc
~/.zshrc##default             # Fallback/shared config
```

> [!TIP]
> You can also use `##class.personal` or `##hostname.myserver` for more granular control.

---

### Phase 4: Bootstrap Script

Create a bootstrap script that automatically installs dependencies based on OS.

#### Packages Installed

| Package | Description |
|---------|-------------|
| `neovim` | Modern Vim-based editor |
| `tmux` | Terminal multiplexer |
| `zsh` | Z shell |
| `fd` | Fast file finder |
| `ripgrep` | Fast grep replacement |
| `bat` | Cat with syntax highlighting |
| `eza` | Modern ls replacement |
| `zoxide` | Smart cd command |
| `fzf` | Fuzzy finder |
| `yazi` | Terminal file manager |
| `lsd` | LSDeluxe - fancy ls |

#### [NEW] `~/.config/yadm/bootstrap`

```bash
#!/bin/bash
set -e

SYSTEM_TYPE=$(uname -s)

echo "🚀 Bootstrapping dotfiles for $SYSTEM_TYPE..."

if [ "$SYSTEM_TYPE" = "Darwin" ]; then
    # Mac Setup
    echo "📦 Installing Homebrew packages..."

    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install essential packages
    brew install neovim tmux zsh \
        fd ripgrep bat eza zoxide fzf yazi lsd

    # Install Oh My Zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.ohmyz.sh/master/tools/install.sh)" "" --unattended
    fi

elif [ "$SYSTEM_TYPE" = "Linux" ]; then
    # Ubuntu Setup
    echo "📦 Installing apt packages..."
    sudo apt update
    sudo apt install -y neovim tmux zsh fd-find ripgrep bat fzf

    # eza (modern ls replacement)
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update && sudo apt install -y eza

    # Install zoxide, lsd, yazi via cargo
    if ! command -v cargo &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | xargs -0 -I{} sh -c '{} -y'
        source "$HOME/.cargo/env"
    fi
    cargo install zoxide lsd yazi-fm

    # Create symlinks for fd and bat (Ubuntu uses different names)
    mkdir -p ~/.local/bin
    ln -sf $(which fdfind) ~/.local/bin/fd 2>/dev/null || true
    ln -sf $(which batcat) ~/.local/bin/bat 2>/dev/null || true

    # Install Oh My Zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.ohmyz.sh/master/tools/install.sh)" "" --unattended
    fi

    # Set zsh as default shell
    chsh -s $(which zsh)
fi

echo "✅ Bootstrap complete!"
```

---

## Workflow Commands

### 🔄 Backup Current Config (Mac or Ubuntu)

```bash
# Add any changed files
yadm add -u

# Or add specific new files
yadm add ~/.config/nvim/lua/plugins/new-plugin.lua

# Commit and push
yadm commit -m "Update configs"
yadm push
```

### 📥 Apply Config on New Mac

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install YADM
brew install yadm

# 3. Clone your dotfiles (this also runs bootstrap)
yadm clone <your-git-repo-url> --bootstrap
```

### 📥 Apply Config on New Ubuntu

```bash
# 1. Install YADM
sudo apt update && sudo apt install -y yadm

# 2. Clone your dotfiles (this also runs bootstrap)
yadm clone <your-git-repo-url> --bootstrap
```

---

## Verification Plan

### Manual Verification Steps

1. **Test on current Mac:**
   - Run `yadm status` to verify tracking
   - Run `yadm list` to see tracked files
   - Verify files are committed with `yadm log`

2. **Test on new Ubuntu (VM or fresh install):**
   - Clone repository and verify files appear in correct locations
   - Run `source ~/.zshrc` and verify shell works
   - Open `nvim` and verify configuration loads
   - Start `tmux` and verify configuration applies

3. **Test on new Mac:**
   - Same steps as Ubuntu verification
