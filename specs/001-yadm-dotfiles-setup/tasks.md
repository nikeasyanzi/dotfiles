# Tasks: YADM Dotfiles Setup

**Input**: Design documents from `specs/001-yadm-dotfiles-setup/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md
**Organization**: Tasks grouped by User Story phases

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project directories: `.config/yadm`, `scripts`
- [ ] T002 Initialize empty `bootstrap` and `cleanup.sh` scripts

---

## Phase 2: Foundational & US5 (Cleanup/Setup Script) - Deployment Infrastructure

**Purpose**: Core deployment logic (Cleanup + Install) needed for any reliable deployment.
**Stories**: [US5] (Cleanup), [US2] (Deploy) - these are tightly coupled via `setup.sh`.

- [ ] T003 [US5] Implement `scripts/cleanup.sh`: logic to detect and remove `~/.local/share/yadm`
- [ ] T004 [US5] Add logic to `scripts/cleanup.sh`: detect existing dotfiles, backup to timestamped dir, and remove originals
- [ ] T005 [US2] Create root `setup.sh`: Orchestrator that runs `cleanup.sh` then `yadm clone --bootstrap`
- [ ] T006 [US2] Add platform detection (`uname -s`) to logic to ensure correct yadm install command (brew vs apt)

**Checkpoint**: `setup.sh` can be run on a "dirty" machine and result in a clean slate ready for YADM.

---

## Phase 3: User Story 1 - Initial Dotfiles Backup (Priority: P1)

**Goal**: Capture current Mac configuration into the repo.

- [ ] T007 [US1] Initialize YADM repo on local machine (`yadm init`) if not already done
- [ ] T008 [US1] Audit existing `.zshrc` for secrets before adding
- [ ] T009 [US1] Create/Update `.zshrc`: Add skeleton with `uname -s` detection blocks (Preparation for US4)
- [ ] T010 [US1] Add `.config/nvim/` tree (ensure no sensitive data)
- [ ] T011 [US1] Add `.tmux.conf`
- [ ] T012 [US1] Add `.gitconfig`
- [ ] T013 [US1] Add `.p10k.zsh`
- [ ] T015 [US1] Commit all initial config files to YADM repo

**Checkpoint**: Repo contains all core config files. `yadm status` on Mac is clean.

---

## Phase 4: User Story 4 - Single Source Shell Config (Priority: P2)

**Goal**: Make `.zshrc` portable across Mac and Ubuntu using internal logic.

- [ ] T016 [US4] Implement Mac (Darwin) specific block in `.zshrc` (Homebrew paths, aliases)
- [ ] T017 [US4] Implement Ubuntu (Linux) specific block in `.zshrc` (apt paths)
- [ ] T018 [US4] Verify common aliases work in both blocks (or outside if shared)

**Checkpoint**: `.zshrc` is valid on both platforms without manual changes.

---

## Phase 5: User Story 3 - Automated Bootstrap (Priority: P2)

**Goal**: Automate package installation.

- [ ] T019 [US3] Implement `~/.config/yadm/bootstrap`: Shebang, execution permission, OS detection
- [ ] T020 [US3] Add macOS (Homebrew) installation logic: Check for brew, install packages (neovim, tmux, etc.)
- [ ] T021 [US3] Add Ubuntu (apt) installation logic: sudo apt install packages
- [ ] T022 [US3] Add Cargo/alternative installs for tools missing in older apt repos (eza, zoxide) if needed
- [ ] T023 [US3] Add Oh My Zsh installation (idempotent check)
- [ ] T024 [US3] Add symlink logic for Ubuntu (`fdfind` -> `fd`, `batcat` -> `bat`)
- [ ] T025 [US3] Implement `chsh -s $(which zsh)` to set default shell

**Checkpoint**: Running `~/.config/yadm/bootstrap` installs all tools and returns 0 exit code.

---

## Phase 6: Polish & Verification

- [ ] T026 Create `README.md` with usage instructions (from `quickstart.md`)
- [ ] T027 Final end-to-end test on local execution
- [ ] T028 Update project `files` list in `tasks.md` or similar to track progress
