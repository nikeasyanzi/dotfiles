# Dotfiles

Managed via [YADM](https://yadm.io/).

## structure

- **.zshrc**: Main shell configuration (Cross-platform).
- **.config/yadm/bootstrap**: Installation script (Brew/Apt).
- **scripts/cleanup.sh**: Backup and cleanup utility.
- **setup.sh**: One-line deployment script.

## Quickstart

### Mac / Ubuntu

```bash
# 1. Clone & Install
curl -fLo setup.sh https://raw.githubusercontent.com/craigyang/dotfiles/main/setup.sh
bash setup.sh
```

*(Note: automatic backup of existing dotfiles is performed before installation)*

## Manual Usage

**Update dotfiles:**
```bash
yadm pull
yadm bootstrap
```

**Add new file:**
```bash
yadm add <file>
yadm commit -m "Add new config"
yadm push
```

## Maintenance

- **Adding OS-specific config**: Edit `.zshrc` in the marked Darwin/Linux blocks.
- **Adding packages**: Edit `.config/yadm/bootstrap` in `install_packages()`.
