# Feature Specification: CLI Tool Package Installation

**Feature Branch**: `005-cli-tool-package`  
**Created**: 2026-02-11  
**Status**: Merged  
**Input**: User requirement: Review and verify installation of 8 CLI tools (fd, ripgrep, bat, eza, zoxide, fzf, yazi, lsd) across macOS and Ubuntu

## User Scenarios & Testing

### User Story 1 - Install CLI Tools on macOS via Homebrew (Priority: P1)

Developers need a complete set of modern CLI tools installed for productivity. On macOS, this happens via Homebrew. The user has specified the exact brew install command for 8 tools: fd, ripgrep, bat, eza, zoxide, fzf, yazi, lsd.

**Why this priority**: P1 - Essential for bootstrap completeness. These tools are used daily in shell workflows (file search, text search, file viewing, directory listing, navigation, fuzzy finding, file management).

**Independent Test**: Can be fully tested by running `brew install fd ripgrep bat eza zoxide fzf yazi lsd` on a fresh macOS machine and verifying all binaries are available and functional.

**Acceptance Scenarios**:

1. **Given** fresh macOS machine, **When** bootstrap runs, **Then** all 8 tools are installed via Homebrew.
2. **Given** all tools installed, **When** checking binary locations, **Then** all are in PATH and executable.
3. **Given** tools already installed, **When** bootstrap runs again, **Then** it completes without errors (idempotent).

---

### User Story 2 - Install CLI Tools on Ubuntu/Linux (Priority: P1)

Ubuntu users need the same 8 tools installed for feature parity with macOS. Ubuntu package manager (apt) provides some but not all tools. Installation strategy must be determined for missing packages.

**Why this priority**: P1 - Feature parity across platforms. Without these tools on Linux, user experience differs significantly.

**Independent Test**: Can be tested by running installation commands on Ubuntu 20.04+ and verifying all 8 tools work correctly.

**Acceptance Scenarios**:

1. **Given** fresh Ubuntu machine, **When** bootstrap runs, **Then** all 8 tools are installed (via apt or alternative method).
2. **Given** all tools installed, **When** running each tool with `--version`, **Then** all execute successfully.
3. **Given** tools already installed, **When** bootstrap runs again, **Then** no errors or reinstallation.

---

### User Story 3 - Verify Tool Integration with Shell Config (Priority: P2)

After installation, tools should be immediately usable in shell. Some tools need shell integration (zoxide for `z`, fzf for keybindings). Integration should work without manual configuration.

**Why this priority**: P2 - Ensures tools are actually usable. Installation alone isn't enough if not integrated with shell.

**Acceptance Scenarios**:

1. **Given** zoxide installed, **When** terminal launches, **Then** `z` command is available.
2. **Given** fzf installed, **When** Ctrl+R is pressed, **Then** fuzzy history search works.
3. **Given** all tools installed, **When** shell configured, **Then** no errors from missing tools.

---

### Edge Cases

- What if a tool is already installed via alternative method? (e.g., user compiled from source)
- How to handle tools not available in Ubuntu (yazi, eza might be bleeding-edge)?
- What if apt installation is very outdated? (Should fallback to snap, cargo, or manual download?)
- How to handle architecture differences (ARM64 vs x86_64)?
- What if Homebrew or apt package has different binary name than expected?

## Requirements

### Functional Requirements

**macOS Installation**:
- **FR-001**: Bootstrap MUST run `brew install fd ripgrep bat eza zoxide fzf yazi lsd` (user-specified command)
- **FR-002**: Bootstrap MUST verify Homebrew tap `homebrew/cask-fonts` is available for font installation

**Ubuntu Installation** (User Preference: apt install):
- **FR-003**: Bootstrap MUST attempt to install all 8 tools via `apt install` on Ubuntu
- **FR-003a**: For tools in standard apt repos:
  - **fd**: Install as `fd-find`, create symlink `~/.local/bin/fd` → `/usr/bin/fdfind`
  - **ripgrep**: Install as `ripgrep`
  - **bat**: Install as `bat`, alias `batcat` → `bat` if needed
  - **fzf**: Install as `fzf`
  - **lsd**: Install as `lsd`
- **FR-003b**: For tools NOT in standard apt (`eza`, `zoxide`, `yazi`): [NEEDS CLARIFICATION - see questions below]

**Error Handling & Validation** (Clarified):
- **FR-004**: If `apt update` or primary `apt install` command FAILS → Bootstrap MUST halt and exit with error (strict about package manager)
- **FR-005**: If individual packages unavailable in apt (eza, zoxide, yazi) → Continue installation but track failures
- **FR-006**: At end of bootstrap → Display summary report showing what installed/what failed
- **FR-007**: Installation MUST be idempotent (can run multiple times safely)
- **FR-008**: All available tools MUST be in PATH after bootstrap
- **FR-009**: Binaries MUST have correct names (fd, ripgrep, bat, etc.) or aliased appropriately
- **FR-010**: Shell integration (z for zoxide, keybindings for fzf) MUST work for installed tools

### Non-Functional Requirements

- **NFR-001**: Total installation time <10 minutes on typical connections
- **NFR-002**: Installation MUST not require additional user interaction beyond bootstrap
- **NFR-003**: Tools MUST be latest/recent stable versions (not outdated)

### Tool Descriptions & Justifications

| Tool | Purpose | macOS Package | Ubuntu Package | Notes |
|------|---------|---------------|----------------|-------|
| **fd** | Fast file finder (find alternative) | `fd` | `fd-find` (symlink to fd) | Essential for searches |
| **ripgrep** | Fast regex search (grep alternative) | `ripgrep` | `ripgrep` | Used daily for code search |
| **bat** | Cat with syntax highlighting | `bat` | `bat` | Better code viewing |
| **eza** | Modern ls replacement | `eza` | **❓ Not in apt** | Directory listing with colors/icons |
| **zoxide** | Smart cd command (z) | `zoxide` | **❓ Not in apt** | Quick directory navigation |
| **fzf** | Fuzzy finder | `fzf` | `fzf` | Ctrl+R history, file fuzzy search |
| **yazi** | Terminal file manager | `yazi` | **❓ Bleeding-edge** | File browsing alternative |
| **lsd** | ls replacement with icons | `lsd` | `lsd` | Pretty directory listing |

## Success Criteria

1. ✅ All 8 tools specified by user are installed and verified on macOS
2. ✅ Installation method determined for all 8 tools on Ubuntu
3. ✅ Both installations are idempotent and handle re-runs correctly
4. ✅ All tools are in PATH and callable by their standard names
5. ✅ Shell integration (zoxide, fzf) works without additional configuration
6. ✅ Bootstrap script updated with tool installation commands
7. ✅ Documentation updated listing all installed tools and their purpose
8. ✅ Tested on macOS (Intel & Apple Silicon) and Ubuntu 20.04+

## Implementation Notes

### Ubuntu Package Status Research Needed

For the 3 questionable packages, recommend this priority order:

1. **eza** (ls replacement)
   - **Option A**: Cargo (`cargo install eza`) - latest, but slow (~2 min build)
   - **Option B**: GitHub releases (pre-built binaries) - fastest
   - **Option C**: Snap (`snap install eza`) - simple but containerized
   - **Recommendation**: GitHub releases with fallback to cargo

2. **zoxide** (smart navigation)
   - **Option A**: Cargo (`cargo install zoxide`) - recommended by maintainers
   - **Option B**: GitHub releases - faster
   - **Option C**: apt-python fallback - lighter weight
   - **Recommendation**: Cargo (official method)

3. **yazi** (file manager)
   - **Option A**: Cargo (`cargo install yazi`) - official method
   - **Option B**: GitHub releases - pre-built faster
   - **Recommendation**: GitHub releases with cargo fallback

### Ubuntu Implementation Strategy

**Phase 1: Essential packages (apt-available, MUST succeed)**
```bash
sudo apt update
sudo apt install -y fd-find ripgrep bat fzf lsd
# If this fails → bootstrap halts (exit 1)
```

**Phase 2: Create symlinks for renamed packages**
```bash
mkdir -p ~/.local/bin
ln -sf /usr/bin/fdfind ~/.local/bin/fd 2>/dev/null || true
ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
```

**Phase 3: Optional packages (apt-unavailable, non-blocking)**
```bash
# These may not exist in apt - collect failures but don't halt
MISSING=""
sudo apt install -y eza 2>/dev/null || MISSING="$MISSING eza"
sudo apt install -y zoxide 2>/dev/null || MISSING="$MISSING zoxide"
sudo apt install -y yazi 2>/dev/null || MISSING="$MISSING yazi"
```

**Phase 4: Report results**
```bash
echo ""
echo "✅ CLI Tools Installation Summary:"
echo "   Installed: fd, ripgrep, bat, fzf, lsd"
if [ ! -z "$MISSING" ]; then
  echo "   ⚠️  Not in apt repos:$MISSING"
  echo "      → Optional: cargo install eza zoxide yazi"
fi
```

## Clarifications Resolved ✅

**Q1: Ubuntu method preference**
→ A: `apt install` (as user specified)

**Q2: For packages not in apt (eza, zoxide, yazi)**
→ A: Continue but show failure report at end

**Q3: If apt command fails**
→ A: Bootstrap HALTS immediately (strict error handling)

**Q4: Validation approach**
→ A: Show summary report of what installed/failed (informational)

**Resolution**:
- Try `apt install fd-find ripgrep bat fzf lsd` → if fails, halt
- Try `apt install eza zoxide yazi` separately → if fails, log but continue
- At end: Print report showing which tools available
- User can manually install eza/zoxide/yazi later if needed
