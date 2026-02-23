# Tasks: Nerd Font Installation

**Input**: Design documents from `specs/002-nerd-font-installation/`
**Prerequisites**: plan.md, spec.md
**Organization**: Tasks grouped by implementation phases

## Phase 1: Bundle Font Files

**Purpose**: Download and commit JetBrains Mono Nerd Font .ttf files to the repo

- [x] T001 Create `.config/fonts/` directory in repo
- [x] T002 Download JetBrains Mono Nerd Font release (latest .ttf files from GitHub releases)
- [x] T003 Place all `JetBrainsMonoNerdFont-*.ttf` weight variants in `.config/fonts/`
- [x] T004 Verify font files are valid .ttf and total size is reasonable (~10MB)
- [x] T005 Commit font files to repo

**Checkpoint**: `.config/fonts/` exists with all JetBrains Mono Nerd Font .ttf variants committed.

---

## Phase 2: macOS Bootstrap Function

**Purpose**: Add font installation via Homebrew cask

- [x] T006 [US1] Add `install_fonts_macos()` function to `.config/yadm/bootstrap`
- [x] T007 [US1] Implement `brew install --cask font-jetbrains-mono-nerd-font` inside the function
- [x] T008 [US1] Add progress message: `echo "🔤 Installing JetBrains Mono Nerd Font..."`
- [x] T009 [US1] Add error handling: if brew install fails, log warning but don't halt bootstrap

**Checkpoint**: `install_fonts_macos()` function exists and installs the font via Homebrew.

---

## Phase 3: Ubuntu Bootstrap Function

**Purpose**: Add font installation by copying bundled .ttf files

- [x] T010 [US2] Add `install_fonts_ubuntu()` function to `.config/yadm/bootstrap`
- [x] T011 [US2] Create `~/.local/share/fonts/` directory if it doesn't exist (`mkdir -p`)
- [x] T012 [US2] Copy `.config/fonts/*.ttf` to `~/.local/share/fonts/`
- [x] T013 [US2] Run `fc-cache -fv` to rebuild font cache
- [x] T014 [US2] Add progress messages for each step

**Checkpoint**: `install_fonts_ubuntu()` function copies bundled fonts and rebuilds cache.

---

## Phase 4: Bootstrap Integration

**Purpose**: Wire font functions into bootstrap flow at correct position

- [x] T015 Add OS detection call: Darwin → `install_fonts_macos()`, Linux → `install_fonts_ubuntu()`
- [x] T016 Ensure font install runs AFTER CLI tools section but BEFORE Oh My Zsh section
- [x] T017 Add section comment header: `# --- 2. Fonts ---` (renumber existing sections as needed)

**Checkpoint**: Bootstrap runs font installation in correct order on both platforms.

---

## Phase 5: Documentation & Validation

**Purpose**: Update docs and verify end-to-end

- [x] T018 Update README.md: add font info (which font, why, how it's installed)
- [x] T019 Test on macOS: run bootstrap, verify font available (`brew list --cask | grep font`)
- [x] T020 Test on Ubuntu: verify `fc-list | grep -i "JetBrains"` returns results
- [x] T021 Visual test: confirm Powerlevel10k prompt renders icons correctly

**Checkpoint**: Font installation working on both platforms, documented in README.

---

## File Modifications Summary

**New files**:
- `.config/fonts/JetBrainsMonoNerdFont-*.ttf` — Bundled font files

**Files to modify**:
- `.config/yadm/bootstrap` — Add font installation functions and integration
- `README.md` — Add font documentation
