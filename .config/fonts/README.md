# Bundled Fonts

This directory contains JetBrains Mono Nerd Font .ttf files for Ubuntu installation.

On Ubuntu, the bootstrap copies these files to `~/.local/share/fonts/` and runs `fc-cache -fv`.
On macOS, fonts are installed via Homebrew cask instead (this directory is not used).

## Download Fonts

Run the following from the repo root to download the font files:

```bash
cd .config/fonts
curl -fsSL -o JetBrainsMono.tar.xz \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.tar.xz"
tar -xf JetBrainsMono.tar.xz
rm -f JetBrainsMono.tar.xz
# Remove non-ttf files if any were extracted
find . -maxdepth 1 -type f ! -name '*.ttf' ! -name 'README.md' -delete
```

## Source

- Font: [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono)
- Release: v3.4.0
- License: SIL Open Font License 1.1
