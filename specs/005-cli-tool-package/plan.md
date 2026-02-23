# Implementation Plan: CLI Tool Package Installation

**Branch**: `005-cli-tool-package` | **Date**: 2026-02-11 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/005-cli-tool-package/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Install 8 modern CLI tools (fd, ripgrep, bat, eza, zoxide, fzf, yazi, lsd) across macOS and Ubuntu via platform-native package managers (Homebrew for macOS, apt for Ubuntu). Enhance dotfiles bootstrap with tool installation that provides feature parity on both platforms. For tools unavailable in Ubuntu apt repos (eza, zoxide, yazi), bootstrap will attempt apt install but continue gracefully if unavailable, displaying a summary report.

**Technical approach**: Extend `.config/yadm/bootstrap` script with conditional OS detection and platform-specific package manager calls. Implement symlinks for renamed packages on Ubuntu (fd-find→fd, batcat→bat).

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 4+ (macOS/Ubuntu standard)
**Primary Dependencies**: Homebrew 4.x (macOS), apt package manager (Ubuntu 20.04+)
**Storage**: N/A (package-based, no persistent data)
**Testing**: Manual verification on macOS and Ubuntu test machines
**Target Platform**: macOS (Intel & Apple Silicon), Ubuntu 20.04+
**Project Type**: Shell scripts / Dotfiles bootstrap
**Performance Goals**: Total install time <10 minutes on typical systems
**Constraints**: Must work offline git clone; idempotent (safe to re-run); minimal external dependencies
**Scale/Scope**: Single developer, 2 target machines (Mac + Ubuntu), 8 CLI tools

## Constitution Check

*GATE: Must pass before proceeding to Phase 0.*

✅ **Simplicity**: Using standard package managers (brew/apt), no complex wrappers
✅ **Platform Agnostic**: OS detection via `uname -s` with separate installation paths
✅ **Idempotency**: Install commands are safe to re-run (apt update idempotent, symlinks use -sf)
✅ **Minimal Scope**: CLI tools only, no system-level configurations changed
✅ **Clear Error Handling**: Halt on package manager failure, graceful skip on unavailable packages

**Status**: ✅ PASS - No constitution violations

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
.config/yadm/
├── bootstrap          # MODIFIED: Add tool installation functions
└── bootstrap.d/       # Optional: Could refactor tools into separate file

scripts/
├── cleanup.sh         # Existing: Cleanup function
└── install-tools.sh   # Optional: Could extract tools logic here

.zshrc               # Existing: Shell config with OS detection
.gitconfig           # Existing: Git config
.tmux.conf           # Existing: Tmux config
.p10k.zsh            # Existing: Powerlevel10k config
.config/nvim/        # Existing: Neovim config
```

**Structure Decision**: Modify existing `.config/yadm/bootstrap` script to add tool installation functions. Keep all tool installation in one orchestrator script (bootstrap). No new files required; follows existing pattern.

## Implementation Strategy

### Phase 0: Investigation
✅ Already completed: Ubuntu package availability researched
- Confirm Homebrew taps for all 8 tools on macOS
- Document tool purposes and shell integrations needed

### Phase 1: Design
- Bash function signature for macOS tool installation
- Bash function signature for Ubuntu tool installation
- Error handling flow (halt on apt failure, continue on missing packages)
- Symlink strategy for renamed packages

### Phase 2: Implementation
- Add `install_tools_macos()` function to bootstrap
- Add `install_tools_ubuntu()` function to bootstrap
- Add symlink creation logic
- Add failure summary report
- Integrate into existing bootstrap orchestration

### Phase 3: Validation
- Test on macOS (Intel & Apple Silicon)
- Test on Ubuntu 20.04+
- Verify idempotency (re-run bootstrap multiple times)
- Validate all tools in PATH

### Complexity Notes

✅ **Low complexity**: Simple package manager integration, no build steps
⚠️ **Known complexity**: Handling missing packages gracefully without external dependencies
✅ **Reuse existing patterns**: Follows same OS detection as shell config
