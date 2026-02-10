# Quickstart: Deploying Dotfiles

**Feature**: YADM Dotfiles Setup
**Date**: 2026-02-10

## Prerequisites

- **Mac**: Xcode Command Line Tools (`xcode-select --install`)
- **Ubuntu**: `curl` and `git` installed (`sudo apt install curl git`)

## One-Line Deployment

Execute this command to backup existing configs, clean previous installs, and deploy the new setup:

```bash
# curl -fsSL https://raw.githubusercontent.com/<user>/dotfiles/main/setup.sh | bash
# (URL requires `setup.sh` to be public or token-authenticated)

# OR Clone manually for private repos:
git clone https://github.com/craigyang/dotfiles.git ~/.dotfiles-temp
bash ~/.dotfiles-temp/setup.sh
rm -rf ~/.dotfiles-temp
```

## Manual Steps

1.  **Install YADM**
    - Mac: `brew install yadm`
    - Ubuntu: `sudo apt install yadm`

2.  **Clone Repository**
    ```bash
    yadm clone https://github.com/craigyang/dotfiles.git --bootstrap
    ```

3.  **Verify Setup**
    - Restart your terminal.
    - Check shell theme (P10k).
    - Run `nvim` to check editor config.
