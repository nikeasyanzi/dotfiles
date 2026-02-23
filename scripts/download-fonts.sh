#!/bin/bash
# scripts/download-fonts.sh - Download JetBrains Mono Nerd Font files
# Run this once to populate .config/fonts/ with .ttf files for Ubuntu support.

set -e

FONT_DIR="$(cd "$(dirname "$0")/../.config/fonts" && pwd)"
FONT_VERSION="v3.4.0"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${FONT_VERSION}/JetBrainsMono.tar.xz"

echo "🔤 Downloading JetBrains Mono Nerd Font ${FONT_VERSION}..."

mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

# Download and extract
curl -fsSL -o JetBrainsMono.tar.xz "$FONT_URL"
tar -xf JetBrainsMono.tar.xz
rm -f JetBrainsMono.tar.xz

# Count ttf files
TTF_COUNT=$(find . -maxdepth 1 -name '*.ttf' | wc -l | tr -d ' ')
echo "✅ Downloaded ${TTF_COUNT} .ttf files to ${FONT_DIR}"
