#!/bin/bash
# setup.sh - One-line deploy script for dotfiles
# Usage: curl -fsSL https://raw.githubusercontent.com/nikeasyanzi/dotfiles/main/setup.sh | bash
#   or:  bash setup.sh [repo-url]

set -e

REPO_URL="${1:-https://github.com/nikeasyanzi/dotfiles.git}"
DOTFILES_DIR="$HOME/.dotfiles"

echo "🚀 Starting Dotfiles Setup..."
echo "📦 Repo: $REPO_URL"

# --- Backup existing configs before overwriting ---
backup_existing() {
    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
    TARGETS=(
        "$HOME/.zshrc"
        "$HOME/.config/nvim"
        "$HOME/.tmux.conf"
        "$HOME/.gitconfig"
        "$HOME/.p10k.zsh"
    )

    echo "🧹 Checking for existing config files..."
    local found=0
    for target in "${TARGETS[@]}"; do
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            if [ "$found" -eq 0 ]; then
                mkdir -p "$BACKUP_DIR"
            fi
            found=1
            echo "   Found existing: $target"
            rel_path="${target#$HOME/}"
            backup_path="$BACKUP_DIR/$rel_path"
            mkdir -p "$(dirname "$backup_path")"
            mv "$target" "$backup_path"
        elif [ -L "$target" ]; then
            rm "$target"
        fi
    done

    if [ "$found" -ne 0 ]; then
        echo "✅ Backup created at: $BACKUP_DIR"
    fi
}

backup_existing

# --- Clone repo ---
if [ -d "$DOTFILES_DIR" ]; then
    echo "📥 Updating existing dotfiles..."
    git -C "$DOTFILES_DIR" pull --ff-only
else
    echo "📥 Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

# --- Link dotfiles ---
"$DOTFILES_DIR/scripts/link.sh"

# --- Run bootstrap ---
"$DOTFILES_DIR/scripts/bootstrap.sh"

# --- Install skills ---
"$DOTFILES_DIR/skills/install.sh"

echo "🎉 Setup complete! Restart your shell."
