# Implementation Plan: YADM Dotfiles Setup

**Branch**: `001-yadm-dotfiles-setup` | **Date**: 2026-02-10 | **Spec**: [spec.md](file:///Users/craigyang/workplace/dotfile/specs/001-yadm-dotfiles-setup/spec.md)
**Input**: Feature specification from `/specs/001-yadm-dotfiles-setup/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Implement a cross-platform dotfiles management system using YADM for Mac and Ubuntu.
**Approach**:
1.  Initialize YADM repo with tracked configs (`.zshrc`, `.config/nvim`, etc.).
2.  Use internal OS detection (`if [[ $(uname -s) == "Darwin" ]]`) in `.zshrc` for platform-specifics, rather than alternate files.
3.  Create a `bootstrap` script to install packages (Homebrew/apt) and setup shell.
4.  Add a `cleanup` script to remove previous YADM installs for clean re-deployment.

## Technical Context

**Language/Version**: Bash 4+ (standard on Mac/Ubuntu), Zsh 5+
**Primary Dependencies**: YADM 3.x, Git, Homebrew (Mac), Apt (Ubuntu)
**Storage**: Git repository (GitHub private repo)
**Testing**: Manual verification (shell load, package checks), Idempotency tests
**Target Platform**: macOS (Apple Silicon/Intel), Ubuntu Linux (20.04+)
**Project Type**: Dotfiles / Shell Scripts
**Performance Goals**: Bootstrap < 15 mins
**Constraints**: Must run on bare systems with minimal deps (curl/git)
**Scale/Scope**: Single developer, 2 machines, ~10 core config files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Core Principles Checked**:
1.  **Simplicity**: Using standard tools (YADM, Bash) without complex frameworks.
2.  **Platform Agnostic**: Using `uname -s` for runtime detection ensures portability.
3.  **Idempotency**: Bootstrap/Cleanup scripts designed to be re-runnable.

## Project Structure

### Documentation (this feature)

```text
specs/001-yadm-dotfiles-setup/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # File inventory
├── quickstart.md        # Usage guide
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
.
├── .config/
│   ├── nvim/           # Neovim config
│   └── yadm/
│       └── bootstrap   # Bootstrap script
├── scripts/
│   └── cleanup.sh      # Cleanup script (new)
├── .zshrc              # Single Shared Zsh config (with OS checks)
├── .tmux.conf          # Tmux config
├── .gitconfig          # Git config
├── .p10k.zsh           # Powerlevel10k config
```

**Structure Decision**: Standard YADM layout with dotfiles at root (mimicking $HOME) and helper scripts in `.config/yadm` or `scripts/`.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | | |
