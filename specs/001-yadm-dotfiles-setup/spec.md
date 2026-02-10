# Feature Specification: YADM Dotfiles Setup

**Feature Branch**: `001-yadm-dotfiles-setup`  
**Created**: 2026-02-10  
**Status**: Draft  
**Input**: User description: "Set up YADM to manage dotfiles across Mac and Ubuntu with cross-platform bootstrap automation"

## Clarifications

### Session 2026-02-10

- Q: Secret Management Strategy? -> A: **Manual Transfer** (User manually copies `id_rsa` or uses separate channel; no encrypted secrets in repo).
- Q: Zsh Framework? -> A: **Oh My Zsh** (Required by specs, confirmed by user).
- Q: GUI Apps (Homebrew Casks)? -> A: **CLI Only** (Bootstrap script installs only command-line tools; GUI apps like iTerm2 are manual).
- Q: Setup Script Location? -> A: **In YADM Repo** (Tracked in repo root; deployed via curl from GitHub raw URL on first-time setup).
- Q: Cleanup Script Behavior? -> A: **Fully Automated** (Backs up to timestamped directory and removes without prompting; logs all actions).
- Q: SSH Config? -> A: **Excluded** (User manages SSH config manually; simpler security model).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Initial Dotfiles Backup (Priority: P1)

As a developer on my primary Mac, I want to back up all my configuration files under version control so that I never lose my carefully tuned environment setup.

**Why this priority**: This is the foundational step — without capturing existing configs, no cross-platform sync or automation is possible. It delivers immediate value by providing a safety net for the current environment.

**Independent Test**: Can be fully tested by running `yadm status` and `yadm list` on the Mac and verifying all target config files are tracked and committed. Delivers the value of a versioned backup of the developer's environment.

**Acceptance Scenarios**:

1. **Given** YADM is installed and initialized on Mac, **When** the user adds all target config files (`.zshrc`, `.config/nvim`, `.tmux.conf`, `.gitconfig`, `.p10k.zsh`, `.ssh/config`), **Then** `yadm list` shows all files tracked and `yadm status` reports a clean working tree after commit.
2. **Given** tracked files are committed and pushed, **When** the user modifies a config file, **Then** `yadm diff` shows the change and the user can commit and push the update.
3. **Given** `~/.ssh/config` contains sensitive host information, **When** the file is added to YADM, **Then** the file is stored in a private remote repository, never exposed publicly.

---

### User Story 2 - Deploy Configs on a New or Existing Machine (Priority: P1)

As a developer setting up a new Mac or Ubuntu machine (or re-provisioning an existing one), I want to clone my dotfiles and have all configurations automatically applied so that I can start working in my familiar environment within minutes — even if the machine already has stale or conflicting dotfiles.

**Why this priority**: This delivers the core cross-platform value — a machine goes from any state to fully configured with a single command. Equally critical to the backup story as it completes the round-trip.

**Independent Test**: Can be fully tested by cloning the dotfiles repo on a machine (fresh or with existing configs) and verifying all config files appear in the correct home directory locations and the shell, editor, and terminal multiplexer load correctly.

**Acceptance Scenarios**:

1. **Given** a new Mac with only Homebrew and YADM installed, **When** the user runs `yadm clone <repo-url>`, **Then** all tracked config files are placed in their correct home directory locations.
2. **Given** a new Ubuntu machine with YADM installed, **When** the user runs `yadm clone <repo-url>`, **Then** all tracked config files are placed in their correct home directory locations.
3. **Given** configs have been cloned, **When** the user opens a new terminal, **Then** the Zsh shell loads with Powerlevel10k theme, aliases, and integrations (zoxide, fzf, etc.) functioning correctly.
4. **Given** a machine already has existing dotfiles in target locations (e.g., a default `.zshrc`, old `.gitconfig`), **When** the deployment script runs, **Then** it detects the existing files, backs them up (or removes them), and replaces them with the managed versions from the repository.
5. **Given** a machine has a previous YADM installation with outdated configs, **When** the deployment script runs, **Then** it resets to a clean state and re-applies the latest configs from the remote repository.

---

### User Story 3 - Automated Bootstrap on New Machine (Priority: P2)

As a developer setting up a new machine, I want a bootstrap script to automatically install all required packages and tools so that I don't need to manually install each dependency.

**Why this priority**: Reduces setup from hours of manual package installation to a single automated step. Depends on the clone story (P1) but adds significant time savings.

**Independent Test**: Can be tested by running `yadm clone <repo-url> --bootstrap` on a fresh machine and verifying that all required packages (neovim, tmux, zsh, fd, ripgrep, bat, eza, zoxide, fzf, yazi, lsd) are installed and available on PATH.

**Acceptance Scenarios**:

1. **Given** a new Mac without development tools, **When** the user runs `yadm clone <repo-url> --bootstrap`, **Then** Homebrew is installed (if missing) and all listed packages are installed via `brew install`.
2. **Given** a new Ubuntu machine, **When** the bootstrap runs, **Then** all listed packages are installed via `apt`, Cargo, or from external repositories as appropriate.
3. **Given** bootstrap has completed, **When** the user runs `command -v neovim tmux zsh fd rg bat eza zoxide fzf yazi lsd`, **Then** all commands resolve to valid executables.
4. **Given** a package is already installed, **When** the bootstrap runs, **Then** it skips the package without error (idempotent execution).

---

### User Story 4 - Single Source of Truth for Shell Config (Priority: P2)

As a developer who works on both Mac and Ubuntu, I want a single `.zshrc` that automatically detects the OS and applies the correct settings so that I don't have to maintain fragmented configuration files or worry about loading order.

**Why this priority**: Enables the "write once, use everywhere" promise. Using a single file with conditionals is more robust than splitting logic across multiple alternate files which can have unpredictable loading behavior.

**Independent Test**: Can be tested by inspecting `.zshrc` for `if [[ $(uname -s) == "Darwin" ]]` blocks, and verifying that Mac-specific aliases load on Mac and Linux-specific aliases load on Ubuntu from the exact same file.

**Acceptance Scenarios**:

1.  **Given** a single `.zshrc` file in the repo, **When** the shell starts on Mac, **Then** it detects "Darwin" and loads Homebrew paths and Mac-specific aliases.
2.  **Given** the same `.zshrc` file, **When** the shell starts on Ubuntu, **Then** it detects "Linux" and loads apt paths and Linux-specific aliases.
3.  **Given** common aliases (e.g., `ll`, `g`), **When** the shell starts on either platform, **Then** they are available and work identically.

---

### User Story 5 - Clean Up Previous YADM Installation (Priority: P1)

As a developer whose machine already has a previous YADM setup (possibly outdated or broken), I want the deployment script to detect and fully remove the old YADM installation and its managed files so that I can start fresh without remnants of the old setup causing conflicts.

**Why this priority**: Without cleanup, re-deploying on a machine with an existing YADM installation leads to conflicts, stale symlinks, and unpredictable behavior. This is a prerequisite for reliable re-provisioning.

**Independent Test**: Can be tested by installing YADM and cloning an old repo, then running the cleanup script and verifying that YADM's repo directory (`~/.local/share/yadm`), tracked files, and any YADM configuration are removed, leaving the system in a clean state ready for a fresh `yadm clone`.

**Acceptance Scenarios**:

1. **Given** a machine has a previous YADM installation with tracked dotfiles, **When** the cleanup script runs, **Then** the YADM repository (`~/.local/share/yadm`) is removed.
2. **Given** a machine has YADM-managed dotfiles in the home directory, **When** the cleanup script runs, **Then** the managed dotfiles are backed up to a timestamped directory (e.g., `~/.dotfiles-backup-<date>`) and then removed from their original locations.
3. **Given** YADM is installed via Homebrew or apt, **When** the cleanup script runs, **Then** YADM itself remains installed (only the repo and managed files are removed), so `yadm clone` can be run immediately after.
4. **Given** no previous YADM installation exists, **When** the cleanup script runs, **Then** it completes successfully with a message indicating nothing to clean up (no-op).

---

### Edge Cases

- What happens when `yadm clone` is run on a machine that already has existing config files in the target locations? (The deployment script detects existing dotfiles, backs them up to a timestamped directory like `~/.dotfiles-backup-<date>`, then removes them so YADM can cleanly apply the managed versions.)
- How does the system handle a missing internet connection during bootstrap? (Bootstrap fails gracefully with a clear error message indicating which packages could not be installed.)
- What happens when a package name differs between Mac and Ubuntu (e.g., `fd` vs `fd-find`, `bat` vs `batcat`)? (Bootstrap handles OS-specific package names and creates compatibility symlinks where needed.)
- What happens when the user's default shell is not Zsh? (Bootstrap sets Zsh as the default shell via `chsh`.)
- How does the system handle SSH config files that contain machine-specific hostnames or keys? (Machine-specific SSH entries can use YADM hostname alternates `##hostname.<name>`, or the user keeps a shared base config.)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST track and version-control the following config files: `.zshrc`, `.config/nvim/` (directory), `.tmux.conf`, `.gitconfig`, `.p10k.zsh`, `.ssh/config`.
- **FR-002**: System MUST store all configs in a private Git repository accessible from both Mac and Ubuntu machines.
- **FR-003**: System MUST support cloning configs to a new machine with a single command (`yadm clone`).
- **FR-004**: System MUST provide a bootstrap script that installs all required packages automatically based on the detected operating system (macOS or Ubuntu Linux).
- **FR-005**: Bootstrap MUST be idempotent — running it multiple times on the same machine produces the same result without errors or duplicate installations.
- **FR-006**: System MUST use a single `.zshrc` file with internal OS detection (`uname -s`) to handle platform-specific shell configuration.
- **FR-007**: Configs MUST use portable patterns — `$HOME` instead of hardcoded paths, `command -v` checks before sourcing tool-specific integrations.
- **FR-008**: Bootstrap MUST install Oh My Zsh if not already present.
- **FR-009**: Bootstrap MUST install the following packages: neovim, tmux, zsh, fd, ripgrep, bat, eza, zoxide, fzf, yazi, lsd.
- **FR-010**: On Ubuntu, bootstrap MUST create compatibility symlinks for tools with different binary names (`fdfind` → `fd`, `batcat` → `bat`).
- **FR-011**: System MUST support the standard YADM workflow for pushing local changes: `yadm add`, `yadm commit`, `yadm push`.
- **FR-012**: Deployment script MUST detect existing dotfiles in target locations and clean them up (backup + remove) before applying managed configs, ensuring a clean-state installation.

### Key Entities

- **Config File**: A dotfile or configuration directory managed by YADM. Key attributes: path (relative to `$HOME`), OS scope (shared, Darwin, Linux), sensitivity level (public, private).
- **Bootstrap Script**: An executable script at `~/.config/yadm/bootstrap` that detects the OS and installs dependencies. Key attributes: target OS, package list, idempotency.
- **Alternate File**: An OS-specific variant of a config file using YADM's naming convention (`##os.Darwin`, `##os.Linux`). Key attributes: base file, OS selector, priority.
- **Package**: A tool or dependency installed by the bootstrap script. Key attributes: name, Mac install method (Homebrew), Ubuntu install method (apt/cargo/manual), binary name per OS.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A developer can go from a bare Mac or Ubuntu machine to a fully configured development environment in under 15 minutes using only `yadm clone <repo> --bootstrap`.
- **SC-002**: All 6 target config files/directories are tracked and correctly deployed on both macOS and Ubuntu after cloning.
- **SC-003**: All 11 required packages are installed and available on PATH after bootstrap completes on both platforms.
- **SC-004**: Bootstrap can be run 3 consecutive times on the same machine without errors or side effects (idempotency).
- **SC-005**: Deployment on a machine with pre-existing dotfiles completes successfully — existing files are backed up and replaced without manual intervention.
- **SC-006**: Shell opens with the correct theme (Powerlevel10k), aliases, and tool integrations (zoxide, fzf) functional on both platforms after setup.
- **SC-007**: No hardcoded, platform-specific paths (e.g., `/Users/...` or `/home/...`) remain in any shared config files.

## Assumptions

- The user has a GitHub (or similar) account and can create a private repository for storing dotfiles.
- Both Mac and Ubuntu machines have internet access during initial setup and bootstrap.
- The user has `sudo` access on Ubuntu for installing system packages and changing the default shell.
- Homebrew is the package manager on macOS; APT is the primary package manager on Ubuntu.
- Oh My Zsh is the Zsh framework of choice (with Powerlevel10k theme).
- The user's current Mac already has all target config files in place and working.
