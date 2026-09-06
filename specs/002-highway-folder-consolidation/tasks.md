---

description: "Task list template for feature implementation"
---

# Tasks: Consolidate Skill Suite Support Files into `.highway/`

**Input**: Design documents from `/specs/002-highway-folder-consolidation/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [quickstart.md](./quickstart.md)

**Tests**: Not explicitly requested in the feature spec. This feature relocates existing,
already-tested directories and updates path-resolution logic and documentation; verification is
done by running the existing (relocated) test suite and the quickstart walkthrough, not by
writing new tests.

**Organization**: Tasks are grouped by user story to enable independent implementation and
testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Single project, repository root. All paths below are relative to the repository root unless
otherwise noted.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the destination directory for the relocation

- [X] T001 Create the `.highway/` directory at the repository root (`mkdir -p .highway`)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Perform the actual relocation. No user story's tasks can begin until this phase is
complete — US1's success criteria depend on it directly, and US2/US3 need the files to already
exist at their new location before their path references can be fixed.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Move `skills/` to `.highway/skills/` (`mv skills .highway/skills`); per research.md
      Decision 2, a plain `mv` is sufficient (nothing under the old path is committed to git yet)
- [X] T003 Move `tools/` to `.highway/tools/` (`mv tools .highway/tools`), including
      `tools/.adapter-manifest` and `tools/tests/` with all its contents
- [X] T004 Move `catalog/` to `.highway/catalog/` (`mv catalog .highway/catalog`)
- [X] T005 Confirm no top-level `skills/`, `tools/`, or `catalog/` directories remain anywhere in
      the repository after T002-T004 (FR-009 — no duplicate copies left at the old paths)

**Checkpoint**: Foundation ready — user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Clean, single-purpose repository root (Priority: P1) 🎯 MVP

**Goal**: Listing the repository root shows a single `.highway/` folder for all skill-suite
support content, alongside the three unchanged agent adapter folders.

**Independent Test**: List the repository root and confirm `skills/`, `tools/`, and `catalog/`
no longer exist there, and that `.highway/` contains equivalent content.

- [X] T006 [US1] Verify the repository root listing (`ls -1 .`) contains exactly `.highway/`
      (for skill-suite content) plus the unchanged `.github/`, `.claude/`, `.cursor/`,
      `.specify/`, `specs/`, `.git/`, `.gitignore`, and root `README.md` — no top-level
      `skills/`, `tools/`, or `catalog/` entries remain (SC-001; per quickstart.md Section 1)
      (depends on T002-T005)

**Checkpoint**: At this point, User Story 1 is fully satisfied and independently verifiable

---

## Phase 4: User Story 2 - Author, validate, and regenerate from the new location (Priority: P1)

**Goal**: The exact same authoring/validation/generation workflow works from the new
`.highway/`-relative locations, with agent adapters still written to their unchanged locations.

**Independent Test**: Author a sample skill under `.highway/skills/`, run validation,
catalog-generation, and adapter-generation from their new location, and confirm identical
success/failure behavior and outputs to before the move.

### Implementation for User Story 2

- [X] T007 [P] [US2] Update root resolution in `.highway/tools/generate-catalog.sh`: introduce
      `HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"` and derive `SKILLS_DIR`/`CATALOG_DIR` from
      it instead of the old single `REPO_ROOT` (per research.md Decision 1 / data-model.md Root
      Variables) (depends on T003)
- [X] T008 [P] [US2] Update root resolution in `.highway/tools/generate-agent-adapters.sh`:
      introduce `HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"` for `SKILLS_DIR` and `MANIFEST`,
      and redefine `REPO_ROOT` as `"$(cd "$HIGHWAY_ROOT/.." && pwd)"`, used only for the three
      agent adapter target paths (`.github/skills/`, `.claude/skills/`, `.cursor/rules/`)
      (depends on T003)
- [X] T009 [P] [US2] Update the header comment in `.highway/tools/validate-skill.sh` to
      reference the new paths (no path-resolution logic change needed — it has no
      `.github/`/`.claude/`/`.cursor/`-writing dependency, so `SCRIPT_DIR`-relative sourcing of
      `lib/frontmatter.sh` and `lib/schema-validate.sh` keeps working unchanged) (depends on T003)
- [X] T010 [P] [US2] Update `.highway/tools/tests/validate-skill.test.sh`: rename its existing
      `REPO_ROOT` variable (which after the move points at `.highway/`) to `HIGHWAY_ROOT`, and
      update its `skills/`/`tools/`-relative paths accordingly (depends on T003)
- [X] T011 [P] [US2] Update `.highway/tools/tests/generate-catalog.test.sh`: rename its existing
      `REPO_ROOT` variable to `HIGHWAY_ROOT` and update its `skills/`/`tools/`/`catalog/`-relative
      paths accordingly (depends on T003)
- [X] T012 [P] [US2] Update `.highway/tools/tests/generate-agent-adapters.test.sh`: rename its
      existing `REPO_ROOT` variable to `HIGHWAY_ROOT` for `tools/`/`skills/`/`.adapter-manifest`
      paths, and add a new `REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"` for its
      `.github/`/`.claude/`/`.cursor/` target and `speckit-*` sentinel paths (depends on T003)
- [X] T013 [P] [US2] Update `.highway/tools/tests/new-agent-extensibility.test.sh`: apply the
      same dual-root rename/split as T012, including its sed-based generator-config edit path
      and its skills-snapshot path (depends on T003)
- [X] T014 [US2] Run `.highway/tools/tests/run-all.sh` and fix any failures until the full suite
      passes, with no change to what any test asserts (only path references changed) (depends on
      T007, T008, T009, T010, T011, T012, T013)
- [X] T015 [US2] Execute quickstart.md Section 2 end-to-end (author `sample-echo` under
      `.highway/skills/`, validate, generate catalog, generate adapters, confirm byte-identical
      output at `.github/skills/`, `.claude/skills/`, `.cursor/rules/`), then remove the fixture
      (SC-002, SC-003) (depends on T014)

**Checkpoint**: At this point, User Story 2 is fully functional and testable independently

---

## Phase 5: User Story 3 - Accurate documentation after the move (Priority: P2)

**Goal**: Every doc that mentions a skill-suite file path reflects the new `.highway/`-relative
path.

**Independent Test**: Search all tracked documentation for the old top-level paths (`skills/`,
`tools/`, `catalog/`) and confirm zero remaining references outside of
`specs/001-multi-agent-skill-suite/*` (excluded per research.md Decision 4).

### Implementation for User Story 3

- [X] T016 [P] [US3] Update path references in root `README.md` to the new `.highway/`-relative
      paths (per data-model.md Documentation Reference table) (depends on T002, T003, T004)
- [X] T017 [P] [US3] Update path references in `.highway/tools/README.md` to the new
      `.highway/`-relative paths, including its "Adding a New Agent" section (depends on T003)
- [X] T018 [P] [US3] Update path references in `.highway/catalog/README.md` to the new
      `.highway/`-relative paths (depends on T004)
- [X] T019 [P] [US3] Update path references in `.highway/skills/_authoring-standard.md` to the
      new `.highway/`-relative paths, including its Manual Overlap Review section (depends on
      T002)
- [X] T020 [US3] Run the grep check from quickstart.md Section 5 across all 4 updated docs and
      confirm zero remaining old-path references (SC-004) (depends on T016, T017, T018, T019)

**Checkpoint**: At this point, User Story 3 is fully satisfied and independently verifiable

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T021 [P] Run `.highway/tools/tests/run-all.sh` one final time for a full-suite
      confirmation across all changes (depends on T014, T020)
- [X] T022 Execute the complete quickstart.md walkthrough end-to-end (all 5 sections) and fix
      any discrepancy found (depends on T015, T020)
- [X] T023 Confirm no stray artifacts or duplicate copies remain at the old top-level `skills/`,
      `tools/`, or `catalog/` paths anywhere in the working tree (final FR-009 check) (depends on
      T022)

---

## Dependencies & Execution Order

- **Setup (T001)**: No dependencies — start immediately.
- **Foundational (T002-T005)**: Depends on T001. Blocks all user stories.
- **User Story 1 (T006)**: Depends only on Foundational (T002-T005).
- **User Story 2 (T007-T015)**: Depends only on Foundational (T002-T005). Independent of US1 and
  US3 — can proceed in parallel with US3.
- **User Story 3 (T016-T020)**: Depends only on Foundational (T002-T005). Independent of US1 and
  US2 — can proceed in parallel with US2.
- **Polish (T021-T023)**: Depends on both US2 (T014/T015) and US3 (T020) being complete.

### User Story Dependency Graph

```text
Setup (T001)
   ↓
Foundational (T002-T005)
   ↓
   ├── US1 (T006) ─────────────────────┐
   ├── US2 (T007-T015) ────────────────┤
   └── US3 (T016-T020) ────────────────┤
                                        ↓
                              Polish (T021-T023)
```

## Parallel Execution Examples

Within User Story 2, after Foundational is complete, these can run together (different files):

```text
T007 [P] [US2] .highway/tools/generate-catalog.sh
T008 [P] [US2] .highway/tools/generate-agent-adapters.sh
T009 [P] [US2] .highway/tools/validate-skill.sh
T010 [P] [US2] .highway/tools/tests/validate-skill.test.sh
T011 [P] [US2] .highway/tools/tests/generate-catalog.test.sh
T012 [P] [US2] .highway/tools/tests/generate-agent-adapters.test.sh
T013 [P] [US2] .highway/tools/tests/new-agent-extensibility.test.sh
```

Within User Story 3, after Foundational is complete, these can run together (different files):

```text
T016 [P] [US3] README.md
T017 [P] [US3] .highway/tools/README.md
T018 [P] [US3] .highway/catalog/README.md
T019 [P] [US3] .highway/skills/_authoring-standard.md
```

User Story 2 and User Story 3 can also be worked on entirely in parallel with each other, since
neither's tasks touch the other's files.

## Implementation Strategy

**MVP first**: Complete Setup → Foundational → User Story 1 → User Story 2, in that order.
Although US1 alone satisfies its own independent test (repository root is decluttered) once
Foundational completes, shipping the move without also completing US2 would leave the
framework's tooling broken (wrong paths). Treat **Foundational + US1 + US2 together** as the
practical MVP: the root is clean AND the framework still works end-to-end.

**Incremental delivery**: User Story 3 (documentation accuracy) can be delivered immediately
after Foundational, in parallel with User Story 2 — it does not depend on US2's script changes,
only on the files already being at their new location. Polish tasks close out the feature once
both US2 and US3 are done.
