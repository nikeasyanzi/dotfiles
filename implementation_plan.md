# YADM Dotfiles Management Setup

**Status**: Ready for Implementation
**Detailed Plan**: [specs/001-yadm-dotfiles-setup/plan.md](file:///Users/craigyang/workplace/dotfile/specs/001-yadm-dotfiles-setup/plan.md)
**Tasks**: [specs/001-yadm-dotfiles-setup/tasks.md](file:///Users/craigyang/workplace/dotfile/specs/001-yadm-dotfiles-setup/tasks.md)

## Goal
Implement a cross-platform dotfiles management system using YADM for Mac and Ubuntu, featuring a standalone cleanup/deployment script and automated bootstrap.

## Key Decisions (Clarified)
- **Secret Management**: Manual transfer of keys (no repo encryption).
- **Shell**: Single `.zshrc` with internal OS detection; Oh My Zsh framework.
- **Scope**: CLI tools only (no GUI apps in bootstrap).

## Execution Strategy
The work is broken down into 6 phases in `tasks.md`:
1.  **Setup**: Project directories.
2.  **Foundational**: `cleanup.sh` and `setup.sh` orchestrator.
3.  **US1 (Backup)**: Initial config files (zshrc, nvim, tmux, git, p10k, ssh).
4.  **US4 (Shell)**: Single source `.zshrc` logic.
5.  **US3 (Bootstrap)**: Package installation script.
6.  **Polish**: Documentation.

## Verification
Verification steps are defined in the specific [spec.md](file:///Users/craigyang/workplace/dotfile/specs/001-yadm-dotfiles-setup/spec.md) and [quickstart.md](file:///Users/craigyang/workplace/dotfile/specs/001-yadm-dotfiles-setup/quickstart.md).
Primary validation:
- Run `setup.sh` on a "dirty" machine -> Clean state -> Fresh install.
- Verify shell loads correctly on Mac and Ubuntu.

