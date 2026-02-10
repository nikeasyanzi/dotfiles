# Research: YADM Dotfiles Setup

**Feature**: YADM Dotfiles Setup
**Date**: 2026-02-10

## Decisions & Rationale

### 1. Deployment Strategy: New `setup.sh` vs YADM Bootstrap
- **Context**: User Story 2 & 5 require handling existing dotfiles/cleaning up previous installs. `yadm clone` fails if destination files exist.
- **Decision**: Create a standalone `setup.sh` (hosted in the repo or gist) that:
    1.  Detects existing dotfiles/YADM repo.
    2.  Backs them up to `~/.dotfiles-backup-<timestamp>`.
    3.  Removes them to clear the path.
    4.  Runs `yadm clone <repo> --bootstrap`.
- **Rationale**: YADM's bootstrap runs *after* cloning. We need pre-clone cleanup to ensure `yadm clone` succeeds.
- **Alternatives**:
    - *Manual cleanup*: Violates "automated" requirement.
    - *`yadm clone --force`*: Might overwrite without backup (risky).

### 2. Platform Detection
- **Context**: Need to install different packages on Mac vs Ubuntu.
- **Decision**: Use `uname -s` in bootstrap script.
    - `Darwin` -> macOS (Homebrew)
    - `Linux` -> Ubuntu (apt)
- **Rationale**: Standard, reliable, no external deps.

### 3. Bootstrap Idempotency
- **Context**: Script must be re-runnable without errors.
- **Decision**: Check for existence before installing.
    - Mac: `brew bundle check` or `brew install <pkg> || true` (Homebrew is mostly idempotent, but `check` is cleaner).
    - Linux: `dpkg -s <pkg> >/dev/null 2>&1 || sudo apt install ...`
- **Rationale**: Prevents "already installed" errors and speeds up subsequent runs.

### 4. YADM Alternates vs Single File
- **Context**: Cross-platform shell configuration (US4).
- **Decision**: Use a single `.zshrc` with internal `uname -s` detection.
- **Rationale**: Avoids "loading order" issues and fragmentation. Conditionals inside one file are easier to reason about than multiple files being merged or swapped.
- **Note**: Alternates still available for non-logic files if needed, but `.zshrc` will be unified.

### 5. Clarification Decisions (Session 2026-02-10)
- **Secret Management**: Manual transfer. No encrypted secrets in repo to keep it simple.
- **Zsh Framework**: Oh My Zsh. Standard, feature-rich, installed via bootstrap.
- **GUI Applications**: Excluded from bootstrap. CLI tools only for speed and portability.

### 6. Phase 1 & 2 Implementation Decisions (Session 2026-02-10)
- **Setup Script Location**: Tracked in YADM repo root. First-time deployment via `curl https://raw.githubusercontent.com/user/repo/main/setup.sh | bash`.
- **Cleanup Behavior**: Fully automated. Backs up to `~/.dotfiles-backup-YYYYMMDDHHMMSS/` and removes without prompting. All actions logged to stdout.

## Open Questions Resolved


- **Q**: How to handle SSH keys?
- **A**: They are private. Users should manage `.ssh/id_rsa` manually 

- **Q**: How to handle "dirty" machine state?
- **A**: Addressed by the Backup & Cleanup strategy in `setup.sh`.
