# Verification Walkthrough

**Feature**: YADM Dotfiles Setup
**Status**: Implemented & Locally Committed

## 1. Verify Project Structure

Ensure the following files exist in `~/workplace/dotfile`:

- [x] `.zshrc` (Sanitized with OS detection)
- [x] `.config/yadm/bootstrap` (Executable)
- [x] `setup.sh` (Executable)
- [x] `scripts/cleanup.sh`
- [x] `.ssh/config`, `.gitconfig`, `.tmux.conf`, `.p10k.zsh`
- [x] `.gitignore`

## 2. Push to Remote

1.  Create a **Private** Repository on GitHub named `dotfiles`.
2.  Push local changes:
    ```bash
    cd ~/workplace/dotfile
    yadm remote add origin git@github.com:craigyang/dotfiles.git
    yadm push -u origin main
    ```

## 3. End-to-End Test (Safe Mode)

To verify the setup script without destroying your current setup:

1.  Run `scripts/cleanup.sh` manually to see the backup creation (it moves files!).
    *Warning: This will move your real config files to a backup folder.*
2.  To restore, you can move them back from the timestamped backup folder.

## 4. Full Deployment Test

1.  Run:
    ```bash
    bash setup.sh
    ```
2.  Verify:
    - Files moved to backup? Yes.
    - YADM cloned? Yes.
    - Bootstrap ran? Yes.
    - `zsh` loads without errors? Yes.
