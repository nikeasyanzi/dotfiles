#!/bin/bash
# scripts/bootstrap.sh - Automated setup for packages, fonts, Oh My Zsh, shell
# Usage: ./scripts/bootstrap.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# OS Detection
OS="$(uname -s)"
echo "🚀 Bootstrapping on $OS..."

# Ensure Homebrew is installed on macOS before proceeding
if [ "$OS" = "Darwin" ] && ! command -v brew &> /dev/null; then
    echo "🍎 macOS detected. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# --- 1. CLI Tools Installation ---

install_tools_macos() {
    echo "📦 Installing CLI tools via Homebrew..."
    
    # All 8 tools as specified
    TOOLS=(
        fd
        ripgrep
        bat
        eza
        zoxide
        fzf
        yazi
        lsd
    )
    
    # Also install essentials together
    ESSENTIAL=(
        git
        neovim
        tmux
        zsh
    )
    
    # Combine and install
    brew update
    brew install "${ESSENTIAL[@]}" "${TOOLS[@]}"
    
    if [ $? -ne 0 ]; then
        echo "❌ Homebrew install failed!"
        return 1
    fi
    
    echo "✅ All tools installed via Homebrew"
    return 0
}

install_tools_ubuntu() {
    echo "📦 Installing CLI tools via apt..."
    
    # Add neovim unstable PPA for latest version
    echo "  Adding neovim unstable PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    
    # Phase 1: Essential packages that must succeed
    echo "  Phase 1: Installing essential packages..."
    ESSENTIAL_TOOLS=(
        git
        neovim
        tmux
        zsh
        fd-find
        ripgrep
        bat
        fzf
    )
    
    sudo apt update
    if ! sudo apt install -y "${ESSENTIAL_TOOLS[@]}"; then
        echo "❌ Essential apt packages failed! Bootstrap halting."
        return 1
    fi
    
    # Phase 2: Create symlinks for renamed packages
    echo "  Phase 2: Creating symlinks for renamed packages..."
    mkdir -p "$HOME/.local/bin"
    ln -sf /usr/bin/fdfind "$HOME/.local/bin/fd" 2>/dev/null || true
    ln -sf /usr/bin/batcat "$HOME/.local/bin/bat" 2>/dev/null || true
    
    # Phase 3: Optional packages (not blocking if unavailable)
    echo "  Phase 3: Attempting to install optional packages..."
    OPTIONAL_TOOLS=(
        eza
        zoxide
        yazi
        lsd
    )
    
    MISSING_TOOLS=""
    for tool in "${OPTIONAL_TOOLS[@]}"; do
        if ! sudo apt install -y "$tool" 2>/dev/null; then
            MISSING_TOOLS="$MISSING_TOOLS $tool"
        fi
    done
    
    # Phase 4: Report results
    echo ""
    echo "✅ CLI Tools Installation Summary:"
    echo "   Essential installed: fd, ripgrep, bat, fzf, git, neovim, tmux, zsh"
    if [ ! -z "$MISSING_TOOLS" ]; then
        echo "   ⚠️  Not in apt repos:$MISSING_TOOLS"
        echo "       (optional - you can install later: cargo install$MISSING_TOOLS)"
    fi
    
    # Ensure ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "       Add to PATH: export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
    
    return 0
}

# Install packages based on OS
if [ "$OS" = "Darwin" ]; then
    install_tools_macos || { echo "❌ macOS tool installation failed!"; exit 1; }
elif [ "$OS" = "Linux" ]; then
    install_tools_ubuntu || { echo "❌ Linux tool installation failed!"; exit 1; }
fi

# --- 2. Fonts ---
# Meslo Nerd Font files are bundled in the repo — no download needed.

install_fonts_macos() {
    echo "🔤 Installing Meslo Nerd Font..."
    local FONT_SRC="$DOTFILES_DIR/Meslo Nerd Font patched for Powerlevel10k"
    local FONT_DEST="$HOME/Library/Fonts"

    if ! ls "$FONT_SRC"/*.ttf &>/dev/null; then
        echo "❌ Font files not found in repo at: $FONT_SRC"
        return 1
    fi

    mkdir -p "$FONT_DEST"
    cp "$FONT_SRC"/*.ttf "$FONT_DEST/"
    echo "✅ Meslo Nerd Font installed to $FONT_DEST"
}

install_fonts_ubuntu() {
    echo "🔤 Installing Meslo Nerd Font..."
    local FONT_SRC="$DOTFILES_DIR/Meslo Nerd Font patched for Powerlevel10k"
    local FONT_DEST="$HOME/.local/share/fonts"

    if ! ls "$FONT_SRC"/*.ttf &>/dev/null; then
        echo "❌ Font files not found in repo at: $FONT_SRC"
        return 1
    fi

    mkdir -p "$FONT_DEST"
    cp "$FONT_SRC"/*.ttf "$FONT_DEST/"
    echo "  Rebuilding font cache..."
    fc-cache -fv
    echo "✅ Meslo Nerd Font installed to $FONT_DEST"
}

# Install fonts based on OS
if [ "$OS" = "Darwin" ]; then
    install_fonts_macos
elif [ "$OS" = "Linux" ]; then
    install_fonts_ubuntu
fi

# --- 3. Oh My Zsh ---
install_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "✅ Oh My Zsh already installed."
    fi
    
    # Install Plugins (zsh-autosuggestions, zsh-syntax-highlighting)
    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
        git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
    fi
    
    # Install Powerlevel10k
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    fi
}

install_omz

# --- 4. Shell Setup ---
setup_shell() {
    CURRENT_SHELL=$(basename "$SHELL")
    if [ "$CURRENT_SHELL" != "zsh" ]; then
        echo "Changing default shell to zsh..."
        # Use usermod instead of chsh to avoid interactive password prompt.
        # chsh uses PAM which prompts for password and halts in curl|bash.
        # usermod -s changes shell directly with no interactive prompt.
        ZSH_PATH=$(command -v zsh)
        if ! grep -q "$ZSH_PATH" /etc/shells; then
            echo "Adding $ZSH_PATH to /etc/shells..."
            echo "$ZSH_PATH" | sudo tee -a /etc/shells
        fi
        if ! sudo usermod -s "$ZSH_PATH" "$USER" 2>/dev/null; then
            echo "⚠️  Could not change default shell (sudo required)."
            echo "   Run manually: chsh -s $ZSH_PATH"
        fi
    fi
}

setup_shell

echo "🎉 Bootstrap complete!"
