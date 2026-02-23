# Feature Specification: Nerd Font Installation

**Feature Branch**: `002-nerd-font-installation`  
**Created**: 2026-02-11  
**Status**: Merged  
**Input**: User requirement: Add nerd font installation for mac and ubuntu via dotfiles bootstrap

## User Scenarios & Testing

### User Story 1 - Install JetBrains Mono Nerd Font on macOS (Priority: P1)

Developers working on macOS need a nerd font installed to properly display glyphs and icons in their terminal, shell prompt (Powerlevel10k), and Neovim editor. The font should be installed automatically as part of the dotfiles bootstrap process.

**Why this priority**: P1 - Required for proper display of shell prompt icons and terminal aesthetics. Direct user experience impact. User has already specified the exact command.

**Independent Test**: Can be fully tested by running the bootstrap script on a clean macOS system and verifying that JetBrains Mono Nerd Font is installed and available in system fonts.

**Acceptance Scenarios**:

1. **Given** a fresh macOS machine without JetBrains Mono Nerd Font, **When** bootstrap script runs, **Then** the font is installed via Homebrew cask and available system-wide.
2. **Given** JetBrains Mono Nerd Font already installed, **When** bootstrap script runs, **Then** script completes successfully without errors (idempotent).
3. **Given** Homebrew not installed, **When** bootstrap script runs, **Then** Homebrew is installed first, then font tap and installation proceed.

---

### User Story 2 - Install Nerd Font on Ubuntu/Linux (Priority: P1)

Ubuntu users need the same nerd font installed but Ubuntu package managers don't have native nerd font casks. The font files are bundled directly in the repo (`.config/fonts/`) to eliminate network dependencies at deployment time. Bootstrap copies them to the user font directory and rebuilds the font cache.

**Why this priority**: P1 - Feature parity with macOS. Without this, Linux users don't get proper font rendering.

**Independent Test**: Can be fully tested by running the bootstrap script on a clean Ubuntu system (20.04+) and verifying that JetBrains Mono Nerd Font is installed and available.

**Acceptance Scenarios**:

1. **Given** a fresh Ubuntu machine, **When** bootstrap script runs, **Then** JetBrains Mono Nerd Font is copied from `.config/fonts/` to `~/.local/share/fonts/` and `fc-cache -fv` is run.
2. **Given** font already installed, **When** bootstrap script runs, **Then** files are overwritten (no idempotency check needed) and `fc-cache` refreshes.
3. **Given** `.config/fonts/` directory in the repo, **When** bootstrap runs, **Then** no network download is required.

---

### User Story 3 - Verify Shell Prompt Display (Priority: P2)

After font installation, shell prompt (Powerlevel10k) should render correctly with all glyphs and icons displayed properly on both platforms.

**Why this priority**: P2 - Validation/verification that the font installation actually solves the display problem.

**Independent Test**: Can be tested by opening a new terminal/shell and visually confirming that Powerlevel10k theme displays all icons without missing glyphs or replacements.

**Acceptance Scenarios**:

1. **Given** JetBrains Mono Nerd Font installed, **When** terminal loads Powerlevel10k, **Then** all prompt icons render correctly without boxes or missing characters.
2. **Given** Neovim open with nerd font available, **When** using icon-based plugins, **Then** icons display correctly.

---

### Edge Cases

- What happens if Homebrew cask fonts tap fails to install on macOS?
- How does script handle if user has restricted permissions to system font directories (Linux)?
- What if disk space is insufficient for font installation?
- Should script validate font installation by checking font file presence?

## Clarifications Resolved ✅

**Q1: Ubuntu installation method**
→ A: Bundle font .ttf files in repo at `.config/fonts/`. Bootstrap copies them to `~/.local/share/fonts/` and runs `fc-cache -fv`. No network download needed at deployment time.

**Q2: Idempotency / re-install behavior**
→ A: No idempotency check needed. Font files can be overwritten safely on re-run. Just copy and rebuild cache every time.

**Q3: macOS installation command**
→ A: Use modern `brew install --cask font-jetbrains-mono-nerd-font` (the `homebrew/cask-fonts` tap is deprecated and no longer needed).

**Q4: Font scope**
→ A: JetBrains Mono Nerd Font only. Not designed for extensible multi-font management.

## Requirements

### Functional Requirements

- **FR-001**: Bootstrap script MUST automatically install JetBrains Mono Nerd Font on macOS via `brew install --cask font-jetbrains-mono-nerd-font`
- **FR-002**: Bootstrap script MUST install JetBrains Mono Nerd Font on Ubuntu/Linux by copying bundled `.ttf` files from `.config/fonts/` to `~/.local/share/fonts/` and running `fc-cache -fv`
- **FR-003**: Font `.ttf` files MUST be committed to the repo under `.config/fonts/` to eliminate network dependency at deployment
- **FR-004**: Script MUST detect OS platform (Darwin vs Linux) and execute appropriate installation method
- **FR-005**: Script MUST handle case where required dependencies (brew) are not yet installed on macOS
- **FR-006**: Installation MUST complete successfully with exit code 0
- **FR-007**: Font MUST be available system-wide immediately after installation (no logout/login required for terminal font selection)
- **FR-008**: Re-running bootstrap MUST safely overwrite existing font files (no idempotency check needed)

### Non-Functional Requirements

- **NFR-001**: Installation should complete within 5 minutes on typical systems
- **NFR-002**: Script should provide clear feedback during installation (echo statements for progress)
- **NFR-003**: No manual user interaction required during installation

### Key Entities

- **JetBrains Mono Nerd Font**: A monospace font with Nerd Font glyphs for terminal/editor use
- **`.config/fonts/`**: Repository directory containing bundled font `.ttf` files
- **Homebrew (macOS)**: Package manager for font installation via casks (modern command, no tap needed)
- **`~/.local/share/fonts/` (Ubuntu)**: User font directory where `.ttf` files are copied

## Success Criteria

1. ✅ Bootstrap script includes JetBrains Mono Nerd Font installation for macOS (provided by user)
2. ✅ Bootstrap script includes JetBrains Mono Nerd Font installation for Ubuntu with verified method
3. ✅ Both installations are idempotent and non-destructive
4. ✅ Font is verified to exist after installation
5. ✅ Powerlevel10k prompt renders correctly with nerd font glyphs
6. ✅ Documentation updated with font requirements

## Notes

- User provided exact macOS command: `brew install --cask font-jetbrains-mono-nerd-font` (updated from deprecated tap approach)
- Ubuntu: Font files bundled in `.config/fonts/` in the repo, copied to `~/.local/share/fonts/` at bootstrap, `fc-cache -fv` run to rebuild font cache
- No idempotency check: overwrite is safe and simpler
- Only JetBrains Mono Nerd Font; not designed for extensible multi-font management

## Project Structure

### Source Code (repository changes)

```text
.config/
├── fonts/                 # NEW: Bundled JetBrains Mono Nerd Font .ttf files (~10MB)
│   └── JetBrainsMonoNerdFont-*.ttf
├── yadm/
│   └── bootstrap          # MODIFIED: Add font installation logic
```
- Ubuntu approach needs research/implementation assistance, suggesting `/speckit.clarify` for Ubuntu method decision
- JetBrains Mono Nerd Font recommended for consistency across platforms (good coding font + complete glyph coverage)
- Font installation should happen AFTER Homebrew/package managers are set up but before shell configuration loads
