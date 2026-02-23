# Implementation Plan: Future Work Document

**Branch**: `003-future-work-document` | **Date**: 2026-02-23 | **Spec**: [spec.md](spec.md)

## Summary

Create a `FUTURE.md` document at the repository root that tracks planned improvements and completed work. Minimal structure: **Backlog** and **Completed** sections. Each item uses lightweight format: `**Title** - One-liner [Complexity]`. Seed with all known future work from existing specs (lazy-zsh, nerd fonts, etc.).

**Technical approach**: Create a single markdown file. Reference it from README.md. No automation, no unique IDs — just a human-maintained list.

## Technical Context

**Language/Version**: Markdown (plain text)
**Dependencies**: None
**Testing**: Visual inspection — file exists with correct structure and items
**Target Platform**: N/A (documentation only)
**Project Type**: Documentation
**Constraints**: Keep it minimal — two sections, lightweight items, no tooling

## Constitution Check

✅ **Simplicity**: Plain markdown, two sections, no automation
✅ **Minimal Scope**: Lightweight items, no IDs or dependency graphs
✅ **Maintainable**: Easy to add/remove/move items manually

**Status**: ✅ PASS

## Project Structure

### New Files

```text
FUTURE.md              # NEW: Future work backlog document
```

### Modified Files

```text
README.md              # MODIFIED: Add reference to FUTURE.md
```

## Implementation Strategy

### Phase 1: Create FUTURE.md
- Create file at repository root with two sections: `## Backlog` and `## Completed`
- Each backlog item format: `- **Title** - One-liner description [Complexity]`
- Complexity tags: Low (<4 hours), Medium (1-3 days), High (1+ weeks)

### Phase 2: Seed Backlog Items
- Gather all known future work from existing specs:
  - **Lazy Loading for Zsh** — from spec 004 (deferred)
  - **Nerd Font Installation** — from spec 002 (if not yet implemented when this runs)
  - Any other identified improvements from working with the dotfiles
- Add items with appropriate complexity tags

### Phase 3: Update README.md
- Add brief reference/link to FUTURE.md in README
- One line: link to the file for contributors/future self

### Phase 4: Validation
- Verify FUTURE.md exists and has correct structure
- Verify at least "Lazy Loading for Zsh" is present as backlog item
- Verify README.md links to FUTURE.md
