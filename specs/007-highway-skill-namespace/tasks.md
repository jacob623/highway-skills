---

description: "Task list template for feature implementation"
---

# Tasks: Highway Skill Namespace

**Input**: Design documents from `/specs/007-highway-skill-namespace/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md (all present)

**Tests**: Included. This feature changes the target paths `.highway/tools/generate-agent-adapters.sh`
writes to; the existing `.highway/tools/tests/generate-agent-adapters.test.sh` and
`new-agent-extensibility.test.sh` are the mechanism that proves the new namespaced paths are
produced correctly and that no currently-passing assertion regresses, so updating them is
mandatory implementation work, not optional new TDD tests.

**Organization**: Tasks are grouped by user story (US1, US2 — spec.md priorities P1, P1).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: US1 or US2 — maps to spec.md's user stories
- Setup, Foundational, and Polish tasks carry no story label

## Path Conventions

Single project. All paths are relative to the repository root, rooted at `.highway/` for
tooling and `specs/007-highway-skill-namespace/` for this feature's own documentation. Generated
adapters land at the true repository root (`.github/`, `.claude/`, `.cursor/`), not under
`.highway/` (plan.md Project Structure).

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the pre-change baseline this feature must not regress.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from repo root and confirm the full suite
      passes before any change begins (quickstart.md step 6, run early as a baseline; SC-003)

**Checkpoint**: Baseline confirmed green; safe to begin.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Change the one script both user stories depend on so it emits namespaced target
paths and cleans up the pre-namespace artifacts it replaces. Neither US1 (namespace visible) nor
US2 (nothing else regresses) can be verified until this phase is complete, since they exercise
the same generator run.

- [X] T002 In `.highway/tools/generate-agent-adapters.sh`, change `AGENT_TARGET_TEMPLATES` from
      `(".github/skills/%s/SKILL.md" ".claude/skills/%s/SKILL.md" ".cursor/rules/%s.mdc")` to
      `(".github/skills/highway.%s/SKILL.md" ".claude/skills/highway.%s/SKILL.md"
      ".cursor/rules/highway.%s.mdc")`; update the file's header comment (currently naming the
      old paths) to match (research.md R2; contracts/agent-adapter-contract.md target-path table;
      FR-001/FR-002)
- [X] T003 In `.highway/tools/generate-agent-adapters.sh`, add a parallel
      `AGENT_OLD_TARGET_TEMPLATES` array holding the pre-namespace path patterns
      (`".github/skills/%s/SKILL.md"` etc., the values `AGENT_TARGET_TEMPLATES` had before T002),
      declared next to `AGENT_TARGET_TEMPLATES` (depends on T002, same file; research.md R3)
- [X] T004 In `.highway/tools/generate-agent-adapters.sh`, add a `remove_stale_target()` function
      that, given an old rel_path: returns immediately (no-op) if the file does not exist; if it
      exists and `manifest_get` finds a tracked entry whose recorded hash matches the file's
      current hash, deletes the file and prunes its manifest row (reusing the existing
      `grep -vF`-based row-removal technique already used inside `manifest_set`); otherwise prints
      an `ERROR: [...]` naming the file and returns non-zero, matching `check_no_drift`'s existing
      refusal wording style (depends on T003; research.md R3; contracts/agent-adapter-contract.md
      "Stale non-namespaced artifact removal" section)
- [X] T005 In `.highway/tools/generate-agent-adapters.sh`'s main write loop, call
      `remove_stale_target()` for each (skill, agent) pair's old path (via
      `AGENT_OLD_TARGET_TEMPLATES`) immediately before the existing `write_target_from_file`/
      `write_target_from_content` call for that pair, and propagate any non-zero return the same
      way the existing drift-check loop already aborts the whole run (no partial adapter set)
      (depends on T004; research.md R3; FR-006)
- [X] T006 [P] Update `.highway/tools/tests/generate-agent-adapters.test.sh`: change
      `GH_TARGET`/`CLAUDE_TARGET`/`CURSOR_TARGET` (and any other path built from `$TMP_ID`) to
      the namespaced form (`.github/skills/highway.$TMP_ID/SKILL.md`, etc.); add an assertion
      that a pre-existing fixture file at the corresponding **old**, non-namespaced path is
      removed and its manifest row pruned after a run (depends on T005; research.md R3/R4)
- [X] T007 [P] Update `.highway/tools/tests/new-agent-extensibility.test.sh`: change its
      `$TMP_ID`-based target path assertions (github-copilot/claude-code/cursor) to the
      namespaced form; leave the `.mock-agent-4` extensibility assertion untouched, since that
      test's own `sed` substitution only appends a 4th row and does not reference the namespace
      (depends on T005; research.md R4)

**Checkpoint**: Generator produces namespaced paths and cleans up the old ones; both existing
adapter test files updated to match. User story verification can now begin.

---

## Phase 3: User Story 1 - A coding agent lists this project's skill distinctly (Priority: P1) 🎯 MVP

**Goal**: Confirm every generated adapter for the existing `help` skill identifies it as
`highway.help` to all three supported coding agents.

**Independent Test**: Generate the agent adapters for the `help` skill and confirm the
identifier each coding agent would display or invoke reads `highway.help`, not `help`.

### Implementation for User Story 1

- [X] T008 [US1] Run `.highway/tools/generate-agent-adapters.sh` from repo root and confirm exit
      0 with output lines naming the three new namespaced targets for `help` (quickstart.md step
      1; spec.md US1 Acceptance Scenarios 1-2)
- [X] T009 [P] [US1] Confirm `.github/skills/highway.help/SKILL.md` and
      `.claude/skills/highway.help/SKILL.md` exist and are byte-identical to
      `.highway/skills/help/SKILL.md` (quickstart.md step 2; contracts/agent-adapter-contract.md
      `identity-copy` guarantee)
- [X] T010 [P] [US1] Confirm `.cursor/rules/highway.help.mdc` exists with the transformed
      `description`/`alwaysApply: false` frontmatter and verbatim body per `mdc-transform`
      (quickstart.md step 2)
- [X] T011 [US1] Confirm the old, pre-namespace artifacts (`.github/skills/help/SKILL.md`,
      `.claude/skills/help/SKILL.md`, `.cursor/rules/help.mdc`) no longer exist after
      regeneration (quickstart.md step 2; research.md R3; SC-001/SC-002)

**Checkpoint**: US1 fully functional and independently verifiable — the namespace is visibly
applied end-to-end for the one existing skill, with no stale duplicate left behind.

---

## Phase 4: User Story 2 - Existing internal tooling and behavior keep working unchanged (Priority: P1)

**Goal**: Confirm the namespace change regresses nothing: internal ids, the catalog, the
`speckit-*` skills, idempotency, and the full test suite all behave exactly as before.

**Independent Test**: Run the full existing test suite
(`.highway/tools/tests/run-all.sh`) after the namespace change and confirm it still exits 0,
with the catalog's `id` field and every skill's directory name still unprefixed.

### Implementation for User Story 2

- [X] T012 [P] [US2] Confirm `.highway/skills/help/SKILL.md` is byte-unchanged from before this
      feature (source untouched) (quickstart.md step 3; FR-004)
- [X] T013 [P] [US2] Confirm `.highway/catalog/index.json`'s `help` entry still has `id`/
      `source_path` equal to the plain, unprefixed `help` (quickstart.md step 3; FR-003; spec.md
      US2 Acceptance Scenario 2)
- [X] T014 [P] [US2] Confirm `.github/skills/speckit-tasks/SKILL.md` (and the other `speckit-*`
      skills) were not read, written, or renamed by `generate-agent-adapters.sh` (quickstart.md
      step 4; FR-009)
- [X] T015 [US2] Re-run `.highway/tools/generate-agent-adapters.sh` a second consecutive time and
      confirm it reports zero drift for every namespaced target, with no attempt to re-remove an
      already-removed old path (quickstart.md step 5; FR-006; SC-004; spec.md US2 Acceptance
      Scenario 3)
- [X] T016 [US2] Run `.highway/tools/tests/run-all.sh` and confirm exit 0 with the same pass
      count as the Phase 1 baseline, no regression to any previously-passing assertion
      (quickstart.md step 6; FR-008; SC-003; spec.md US2 Acceptance Scenario 1)

**Checkpoint**: US1 and US2 both hold — the namespace is applied and nothing else broke.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Bring documentation in line with the new paths; no behavior change.

- [X] T017 [P] Update `.highway/tools/README.md`'s `generate-agent-adapters.sh` section: replace
      the documented target paths (`.github/skills/<id>/SKILL.md` etc.) with the namespaced form
      (`.github/skills/highway.<id>/SKILL.md` etc.) and point its contract link at
      `specs/007-highway-skill-namespace/contracts/agent-adapter-contract.md` (the current
      superseding contract) instead of `specs/001-multi-agent-skill-suite/...` (research.md R2;
      contracts/agent-adapter-contract.md)
- [X] T018 Run `.highway/tools/tests/run-all.sh` one final time after T017's documentation-only
      edit and confirm it still exits 0 (no behavior change expected)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS both user stories (same
  generator change underlies both)
- **User Story 1 (Phase 3)**: Depends on Foundational completion - no dependency on US2
- **User Story 2 (Phase 4)**: Depends on Foundational completion - no dependency on US1 (US2's
  checks are independent confirmations, not built on US1's verification steps)
- **Polish (Phase 5)**: Depends on both user stories being complete

### Within Each Phase

- T002 → T003 → T004 → T005 are strictly sequential (same file, each building on the last)
- T006, T007 depend on T005 but not on each other (different files) — parallelizable
- Within US1: T008 must run before T009/T010/T011 (they inspect its output); T009 and T010
  inspect different files so are parallelizable; T011 can run any time after T008
- Within US2: T012, T013, T014 are independent read-only checks — parallelizable; T015 must run
  after them (it mutates state via a second generator run); T016 must run last (exercises
  everything together)

### Parallel Opportunities

- T006 and T007 (different test files) once T005 is done
- T009 and T010 (different generated files) once T008 is done
- T012, T013, T014 (independent read-only checks, different files) once Foundational is done

---

## Parallel Example: Foundational

```bash
# After T005 completes, update both affected test files together:
Task: "Update generate-agent-adapters.test.sh target paths"
Task: "Update new-agent-extensibility.test.sh target paths"
```

## Parallel Example: User Story 2

```bash
# Independent read-only regression checks, run together:
Task: "Confirm .highway/skills/help/SKILL.md byte-unchanged"
Task: "Confirm catalog id/source_path still unprefixed"
Task: "Confirm speckit-* skills untouched"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (baseline confirmed green)
2. Complete Phase 2: Foundational (CRITICAL — the one script change both stories need)
3. Complete Phase 3: User Story 1 — namespace visibly applied for `help`
4. **STOP and VALIDATE**: Confirm `highway.help` appears in all three generated adapters
5. Ship if that alone is enough; add US2's regression checks before considering the feature done

### Incremental Delivery

1. Complete Setup + Foundational → generator produces namespaced paths, cleans up old ones
2. Add User Story 1 → verify namespace end-to-end (MVP!)
3. Add User Story 2 → verify zero regression
4. Polish → documentation catches up to the new paths

---

## Notes

- Both user stories are P1; there is no lower-priority story to defer. The split exists because
  they verify two distinct guarantees (visible namespace vs. no regression) from the same
  underlying change, not because one is optional.
- [P] tasks = different files, no dependencies
- Commit after each task or logical group
- Stop at either checkpoint to validate a story independently
- Avoid: vague tasks, same-file conflicts, cross-story dependencies that break independence
