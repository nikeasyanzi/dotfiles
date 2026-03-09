#!/usr/bin/env bash
# install.sh — Install my-skill scripts to ~/bin and add to PATH.
# Usage: ./install.sh [--uninstall]

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
TARGET_DIR="$HOME/bin"

SCRIPTS=(
    docker-nuke
    brew-maintain
    grab
    dc
    fmt-cpp
    git-kickstart
    git-squash
    blog-new
    uv-new
    ship
    run-bmc
)

install() {
    echo "${GREEN}Installing my-skill scripts...${NC}"
    echo ""

    mkdir -p "$TARGET_DIR"

    for script in "${SCRIPTS[@]}"; do
        SRC="$BIN_DIR/$script"
        DEST="$TARGET_DIR/$script"

        if [[ ! -f "$SRC" ]]; then
            echo "  ${YELLOW}SKIP${NC} $script (not found)"
            continue
        fi

        chmod +x "$SRC"
        ln -sf "$SRC" "$DEST"
        echo "  ${GREEN}✓${NC} $script → $DEST"
    done

    # Add ~/bin to PATH if not already present
    # Detect current shell and choose the right rc file
    case "$(basename "$SHELL")" in
        zsh)  RC_FILE="$HOME/.zshrc" ;;
        bash)
            if [[ -f "$HOME/.bash_profile" ]]; then
                RC_FILE="$HOME/.bash_profile"
            else
                RC_FILE="$HOME/.bashrc"
            fi
            ;;
        *)    RC_FILE="$HOME/.profile" ;;
    esac

    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$RC_FILE" 2>/dev/null; then
        echo "" >> "$RC_FILE"
        echo '# my-skill scripts' >> "$RC_FILE"
        echo 'export PATH="$HOME/bin:$PATH"' >> "$RC_FILE"
        echo ""
        echo "${GREEN}Added ~/bin to PATH in $RC_FILE${NC}"
        echo "${YELLOW}Run 'source $RC_FILE' or open a new terminal to use the scripts.${NC}"
    else
        echo ""
        echo "${GREEN}~/bin is already in PATH.${NC}"
    fi

    echo ""
    echo "${GREEN}✓ Installation complete!${NC}"
    echo ""
    echo "Available commands:"
    for script in "${SCRIPTS[@]}"; do
        [[ -f "$BIN_DIR/$script" ]] && echo "  $script"
    done
}

uninstall() {
    echo "${RED}Uninstalling my-skill scripts...${NC}"
    echo ""

    for script in "${SCRIPTS[@]}"; do
        DEST="$TARGET_DIR/$script"
        if [[ -L "$DEST" ]]; then
            rm "$DEST"
            echo "  ${RED}✗${NC} $script removed"
        fi
    done

    echo ""
    echo "${YELLOW}Note: ~/bin PATH entry in your shell rc file was not removed.${NC}"
    echo "${GREEN}✓ Uninstall complete.${NC}"
}

case "${1:-}" in
    --uninstall|-u) uninstall ;;
    --help|-h)
        echo "Usage: ./install.sh [--uninstall]"
        echo ""
        echo "Install my-skill scripts by symlinking bin/ to ~/bin/."
        echo "Use --uninstall to remove the symlinks."
        ;;
    *) install ;;
esac
