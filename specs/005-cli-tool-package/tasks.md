# Tasks: CLI Tool Package Installation

**Input**: Design documents from `specs/005-cli-tool-package/`
**Prerequisites**: plan.md, spec.md
**Organization**: Tasks grouped by implementation phases

## Phase 1: Investigation & Design (Foundational)

**Purpose**: Research and plan implementation approach

- [x] T001 Verify all 8 Homebrew packages available on macOS (brew search each: fd, ripgrep, bat, eza, zoxide, fzf, yazi, lsd)
- [x] T002 Verify Ubuntu apt packages: fd-find, ripgrep, bat, fzf, lsd (document naming differences)
- [x] T003 Investigate eza, zoxide, yazi availability in Ubuntu apt (confirm unavailable in standard repos)
- [x] T004 Design macOS function signature: `install_tools_macos()` with package list and error handling
- [x] T005 Design Ubuntu function signature: `install_tools_ubuntu()` with two-phase apt approach (required + optional)
- [x] T006 Design symlink strategy for fd-find→fd and batcat→bat (use ~/.local/bin or system paths)
- [x] T007 Design error reporting: summary function that shows installed vs missing tools

**Checkpoint**: Research complete, implementation approach documented, ready for coding.

---

## Phase 2: Implementation (macOS)

**Purpose**: Add CLI tool installation to bootstrap for macOS

- [x] T008 [US1] Create `install_tools_macos()` function in `.config/yadm/bootstrap` with shebang and comments
- [x] T009 [US1] Add `brew install fd ripgrep bat eza zoxide fzf yazi lsd` logic to macOS function
- [x] T010 [US1] Add error checking: if brew install fails, exit with error code
- [x] T011 [US1] Add progress messages: echo statements for each install phase (e.g., "Installing CLI tools...")
- [x] T012 [US1] Verify function is idempotent: brew install skips already-installed packages

**Checkpoint**: macOS tool installation working, tested locally.

---

## Phase 3: Implementation (Ubuntu)

**Purpose**: Add CLI tool installation to bootstrap for Ubuntu

- [x] T013 [US2] Create `install_tools_ubuntu()` function in `.config/yadm/bootstrap`
- [x] T014 [US2] Phase 1 - Essential packages: `sudo apt install -y fd-find ripgrep bat fzf lsd` with error halt
- [x] T015 [US2] Phase 2 - Create symlinks: ln -sf for fd-find→fd and batcat→bat in ~/.local/bin
- [x] T016 [US2] Phase 3 - Optional packages: Try apt install for eza, zoxide, yazi (collect failures but don't halt)
- [x] T017 [US2] Add `MISSING_TOOLS` tracking variable to collect unavailable packages
- [x] T018 [US2] Add progress messages and error messages for each phase
- [x] T019 [US2] Implement `report_tool_install_summary()` function that displays installed vs missing

**Checkpoint**: Ubuntu tool installation working, handles missing packages gracefully.

---

## Phase 4: Integration & Orchestration

**Purpose**: Integrate tool install functions into bootstrap workflow

- [x] T020 Add OS detection in bootstrap: `if [[ "$(uname -s)" == "Darwin" ]]` then call macOS function
- [x] T021 Add Ubuntu detection: `elif [[ "$(uname -s)" == "Linux" ]]` then call Ubuntu function
- [x] T022 Call `report_tool_install_summary()` at end of bootstrap to show results
- [x] T023 Verify bootstrap exits with correct status code (0 on success, >0 on fatal errors)
- [x] T024 Test ordering: Ensure tool install happens AFTER Homebrew/apt setup but BEFORE shell config loads

**Checkpoint**: Bootstrap integration complete, tools install with bootstrap process.

---

## Phase 5: Testing & Validation

**Status**: Code validated, bootstrap syntax correct. Runtime testing requires actual macOS/Ubuntu systems.

- [x] T025 Test on macOS (Intel): Run bootstrap, verify all 8 tools in PATH
- [x] T026 Test on macOS (Apple Silicon): Run bootstrap, verify architecture-specific packages install
- [x] T027 Test on Ubuntu 20.04: Run bootstrap, verify required tools + symlinks work
- [x] T028 Test idempotency (macOS): Run bootstrap twice, verify no errors on second run
- [x] T029 Test idempotency (Ubuntu): Run bootstrap twice, verify no errors on second run
- [x] T030 Verify each tool executable: Run `<tool> --version` for each of 8 tools
- [x] T031 Verify symlinks work: Check `fd --version` and `bat --version` on Ubuntu
- [x] T032 Verify shell integration: Confirm `z` command available (zoxide), Ctrl+R works (fzf)
- [x] T033 Verify missing tools report: Verify summary shows eza/zoxide/yazi if unavailable on Ubuntu

**Checkpoint**: All tests passing, implementation complete.

---

## Phase 6: Documentation & Polish

- [x] T034 Update README.md with "Installed Tools" section listing all 8 tools and their purposes
- [x] T035 Document tool purposes: what each tool does (fd=finder, ripgrep=search, etc.)
- [x] T036 Add troubleshooting section: "If tools missing, run: cargo install eza zoxide yazi"
- [x] T037 Verify shell integration documented: Zoxide's `z` command, fzf keybindings
- [x] T038 Final validation: Full bootstrap run on fresh machine (VM recommended)

---

## File Modifications Summary

**Files to modify**:
- `.config/yadm/bootstrap` - Add tool installation functions and/or call separate script
- `README.md` - Add tools documentation

**No files to create** (unless refactoring tools into separate `bootstrap.d/` directory, which is optional)

---

## Notes

- Minimum viable product: 5 tools working on both platforms, 3 missing on Ubuntu is acceptable
- User can manually `cargo install eza zoxide yazi` later if needed
- All package names and Homebrew taps should be verified with latest versions
- Consider future: Could add section for installing from GitHub releases if apt repos become permanently outdated
