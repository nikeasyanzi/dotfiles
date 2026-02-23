# Tasks: Future Work Document

**Input**: Design documents from `specs/003-future-work-document/`
**Prerequisites**: plan.md, spec.md
**Organization**: Tasks grouped by implementation phases

## Phase 1: Create FUTURE.md

**Purpose**: Create the document with correct structure

- [x] T001 [US1] Create `FUTURE.md` at repository root
- [x] T002 [US1] Add `# Future Work` heading
- [x] T003 [US1] Add `## Backlog` section
- [x] T004 [US1] Add `## Completed` section (empty initially)

**Checkpoint**: FUTURE.md exists with two sections.

---

## Phase 2: Seed Backlog Items

**Purpose**: Populate with all known future work from existing specs

- [x] T005 [US2] Add item: **Lazy Loading for Zsh** — Defer plugin loading to optimize shell startup time [Medium]
- [x] T006 [US2] Add item: **Nerd Font Installation** — Add JetBrains Mono Nerd Font to bootstrap for macOS and Ubuntu [Low]
- [x] T007 [US2] Review all specs/README for any other identified improvements to add
- [x] T008 [US2] Verify each item uses format: `- **Title** - One-liner [Complexity]`

**Checkpoint**: Backlog seeded with all known items in lightweight format.

---

## Phase 3: README Integration

**Purpose**: Reference FUTURE.md from README

- [x] T009 Update README.md: add link to FUTURE.md (e.g., "See [FUTURE.md](FUTURE.md) for planned improvements")

**Checkpoint**: README links to FUTURE.md.

---

## Phase 4: Validation

**Purpose**: Verify document meets spec requirements

- [x] T010 Verify FUTURE.md exists at repo root
- [x] T011 Verify "Lazy Loading for Zsh" is present as a backlog item
- [x] T012 Verify all items have complexity tags (Low/Medium/High)
- [x] T013 Verify README.md references FUTURE.md

**Checkpoint**: All success criteria met.

---

## File Modifications Summary

**New files**:
- `FUTURE.md` — Future work backlog document

**Files to modify**:
- `README.md` — Add reference/link to FUTURE.md
