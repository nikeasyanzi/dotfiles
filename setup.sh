#!/bin/bash
# setup.sh - One-line deploy script for YADM dotfiles
# Usage: bash setup.sh

set -e

# Repository URL (User should update this after forking/creating repo)
# For now, we use a placeholder or detect if run from within repo?
# Since this is a template, we'll ask for it or assume a structure.
# But for the user's specific case, they know their repo.
# I'll use a variable REPO_URL that the user must set, or pass as arg.
REPO_URL="${1:-git@github.com:craigyang/dotfiles.git}"

echo "🚀 Starting Dotfiles Setup..."
echo "📦 Repo: $REPO_URL"

# --- Inline Cleanup Logic (copied from scripts/cleanup.sh to ensure standalone execution) ---
clean_existing() {
    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
    TARGETS=(
        "$HOME/.zshrc"
        "$HOME/.config/nvim"
        "$HOME/.tmux.conf"
        "$HOME/.gitconfig"
        "$HOME/.p10k.zsh"
        "$HOME/.ssh/config"
        "$HOME/.config/yadm"
        "$HOME/.local/share/yadm"
        "$HOME/.yadm"
    )

    echo "🧹 Checking for existing config files..."
    mkdir -p "$BACKUP_DIR"
    
    local found=0
    for target in "${TARGETS[@]}"; do
        if [ -e "$target" ]; then
            found=1
            echo "   Found existing: $target"
            rel_path="${target#$HOME/}"
            backup_path="$BACKUP_DIR/$rel_path"
            mkdir -p "$(dirname "$backup_path")"
            mv "$target" "$backup_path"
        fi
    done
    
    if [ "$found" -eq 0 ]; then
        rmdir "$BACKUP_DIR" 2>/dev/null || true
    else
        echo "✅ Backup created at: $BACKUP_DIR"
    fi
}
# -------------------------------------------------------------------------------------------

# 1. Run Cleanup
clean_existing

# 2. Install YADM if missing
SYSTEM_TYPE=$(uname -s)
if ! command -v yadm &> /dev/null; then
    echo "⬇️  Installing YADM..."
    if [ "$SYSTEM_TYPE" = "Darwin" ]; then
        if ! command -v brew &> /dev/null; then
             echo "Error: Homebrew not found. Please install Homebrew first."
             exit 1
        fi
        brew install yadm
    elif [ "$SYSTEM_TYPE" = "Linux" ]; then
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y yadm
        else
            echo "Error: Unsupported Linux distro (apt not found)."
            exit 1
        fi
    fi
else
    echo "✅ YADM already installed."
fi

# 3. Clone Dotfiles
echo "📥 Cloning dotfiles..."
yadm clone "$REPO_URL" --bootstrap

echo "🎉 Setup complete! Restart your shell."
