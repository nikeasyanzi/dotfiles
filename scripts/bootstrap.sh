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

install_fonts_macos() {
    echo "🔤 Installing JetBrains Mono Nerd Font..."
    if ! brew install --cask font-jetbrains-mono-nerd-font; then
        echo "⚠️  Font installation failed (non-blocking). Install manually:"
        echo "     brew install --cask font-jetbrains-mono-nerd-font"
    else
        echo "✅ JetBrains Mono Nerd Font installed via Homebrew"
    fi
}

install_fonts_ubuntu() {
    echo "🔤 Installing JetBrains Mono Nerd Font..."
    local FONT_SRC="$DOTFILES_DIR/.config/fonts"
    local FONT_DEST="$HOME/.local/share/fonts"
    local FONT_VERSION="v3.4.0"
    local FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/JetBrainsMono.tar.xz"

    # Download fonts if not bundled in repo
    if ! ls "$FONT_SRC"/*.ttf &>/dev/null; then
        echo "  Downloading JetBrains Mono Nerd Font ${FONT_VERSION}..."
        mkdir -p "$FONT_SRC"
        if curl -fsSL -o /tmp/JetBrainsMono.tar.xz "$FONT_URL"; then
            tar -xf /tmp/JetBrainsMono.tar.xz -C "$FONT_SRC"
            rm -f /tmp/JetBrainsMono.tar.xz
        else
            echo "⚠️  Font download failed (non-blocking). Run scripts/download-fonts.sh manually."
            return 0
        fi
    fi

    mkdir -p "$FONT_DEST"
    echo "  Copying font files to $FONT_DEST..."
    cp "$FONT_SRC"/*.ttf "$FONT_DEST/"
    echo "  Rebuilding font cache..."
    fc-cache -fv
    echo "✅ JetBrains Mono Nerd Font installed"
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
        # If zsh is in allowed shells
        ZSH_PATH=$(command -v zsh)
        if grep -q "$ZSH_PATH" /etc/shells; then
            chsh -s "$ZSH_PATH"
        else
            echo "Adding $ZSH_PATH to /etc/shells..."
            echo "$ZSH_PATH" | sudo tee -a /etc/shells
            chsh -s "$ZSH_PATH"
        fi
    fi
}

setup_shell

echo "🎉 Bootstrap complete!"
