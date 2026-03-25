#!/bin/bash
# link.sh - Symlink dotfiles from repo to $HOME
# Usage: ./scripts/link.sh [--unlink]

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Files/dirs to symlink: source (relative to repo) → target (relative to $HOME)
LINKS=(
    ".zshrc"
    ".gitconfig"
    ".tmux.conf"
    ".p10k.zsh"
)

# Directories to symlink
DIR_LINKS=(
    ".config/nvim"
)

unlink_all() {
    echo "🧹 Removing symlinks..."
    for item in "${LINKS[@]}" "${DIR_LINKS[@]}"; do
        target="$HOME/$item"
        if [ -L "$target" ]; then
            rm "$target"
            echo "   Removed: $target"
        fi
    done
    echo "✅ Unlinked."
}

link_all() {
    echo "🔗 Linking dotfiles from $DOTFILES_DIR → $HOME"

    for item in "${LINKS[@]}"; do
        src="$DOTFILES_DIR/$item"
        target="$HOME/$item"

        if [ ! -e "$src" ]; then
            echo "   Skipping (not in repo): $item"
            continue
        fi

        if [ -L "$target" ]; then
            rm "$target"
        elif [ -e "$target" ]; then
            echo "   ⚠️  $target exists and is not a symlink — skipping (back it up first)"
            continue
        fi

        mkdir -p "$(dirname "$target")"
        ln -s "$src" "$target"
        echo "   $item → $target"
    done

    for item in "${DIR_LINKS[@]}"; do
        src="$DOTFILES_DIR/$item"
        target="$HOME/$item"

        if [ ! -e "$src" ]; then
            echo "   Skipping (not in repo): $item"
            continue
        fi

        if [ -L "$target" ]; then
            rm "$target"
        elif [ -d "$target" ]; then
            echo "   ⚠️  $target exists and is not a symlink — skipping (back it up first)"
            continue
        fi

        mkdir -p "$(dirname "$target")"
        ln -s "$src" "$target"
        echo "   $item/ → $target"
    done

    echo "✅ Linked."
}

if [ "$1" = "--unlink" ]; then
    unlink_all
else
    link_all
fi
