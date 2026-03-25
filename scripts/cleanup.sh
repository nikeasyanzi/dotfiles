#!/bin/bash
# cleanup.sh - Backup and remove existing dotfiles + symlinks for clean install

set -e

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
TARGETS=(
    "$HOME/.zshrc"
    "$HOME/.config/nvim"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.p10k.zsh"
)

echo "🧹 Starting cleanup..."
echo "📂 Backup directory: $BACKUP_DIR"

mkdir -p "$BACKUP_DIR"

for target in "${TARGETS[@]}"; do
    if [ -L "$target" ]; then
        echo "   Removing symlink: $target"
        rm "$target"
    elif [ -e "$target" ]; then
        echo "   Found existing: $target"
        rel_path="${target#$HOME/}"
        backup_path="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$backup_path")"
        mv "$target" "$backup_path"
        echo "   Moved to: $backup_path"
    else
        echo "   Skipping (not found): $target"
    fi
done

echo "✨ Cleanup complete."
