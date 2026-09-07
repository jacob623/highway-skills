---

description: "Task list template for feature implementation"
---

# Tasks: Help Skill

**Input**: Design documents from `/specs/006-help-skill/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md (all present)

**Tests**: Included. This feature adds two new required registration fields (`usage`,
`## Example`) enforced by `.highway/tools/validate-skill.sh`; the existing
`.highway/tools/tests/*.test.sh` suite and its fixtures are the mechanism that proves the
enforcement works and that no currently-passing test regresses, so updating/adding them is
mandatory implementation work, not optional new TDD tests.

**Organization**: Tasks are grouped by user story (US1, US2, US3 — spec.md priorities P1, P1, P2).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: US1, US2, or US3 — maps to spec.md's user stories
- Setup, Foundational, and Polish tasks carry no story label

## Path Conventions

Single project. All paths are relative to the repository root, rooted at `.highway/` for
tooling/skills and `specs/006-help-skill/` for this feature's own documentation. Generated agent
adapters land at the true repository root (`.github/`, `.claude/`, `.cursor/`), not under
`.highway/` (see plan.md's Project Structure).

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the pre-change baseline this feature must not regress.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from repo root and confirm the full suite
      passes before any change begins (quickstart.md Prerequisites)

**Checkpoint**: Baseline confirmed green; safe to begin.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Extend the skill-authoring contract (`usage` field, `## Example` section) and its
enforcement so that both User Story 1 and User Story 2 have a real, valid `help` skill to test
against, and so User Story 3's enforcement mechanism exists. This phase MUST complete before any
user story phase, since authoring `.highway/skills/help/SKILL.md` (needed by US1 and US2) cannot
pass validation until these checks exist, and US3's fixtures exercise the same checks.

- [X] T002 [P] Extend `.highway/tools/lib/schema-validate.sh`: add `"Example"` to
      `SV_REQUIRED_SECTIONS` (and `"SCHEMA"` to the parallel `SV_SECTION_RULE_TAGS`, matching the
      tag already used for `When not to use`/`Outputs`); add a new `sv_validate_usage()` function
      mirroring `sv_validate_description()` (non-empty, <= 500 characters) (data-model.md
      Validation rules; research.md R7)
- [X] T003 Wire `sv_validate_usage` into `.highway/tools/validate-skill.sh`, calling it alongside
      the existing `sv_validate_description` call (depends on T002; research.md R7)
- [X] T004 [P] Update `.highway/skills/_authoring-standard.md`: add a `usage` row to the
      "Required frontmatter" table; change "Seven sections, each non-empty" to "Eight sections,
      each non-empty" and add an `## Example` row to the "Required body sections" table; update
      the opening "ships **framework only** ... no concrete skill topics" sentence to reflect
      that `.highway/skills/help/` is now the first authored skill, while keeping the framing
      accurate for any future skill (data-model.md; research.md R1/R2)
- [X] T005 [P] Update `.highway/tools/generate-catalog.sh`: read each skill's `usage` frontmatter
      field via `fm_get` and emit it as a required `"usage"` property in each JSON entry, and as
      an additional `Usage` column in the `index.md` table (data-model.md Catalog Entry;
      contracts/catalog.schema.json; research.md R4)
- [X] T006 [P] Update stale "seven" references to "eight": the comment in
      `.highway/tools/lib/schema-validate.sh` ("Seven required sections") and the line in
      `.highway/tools/README.md`'s Libraries table ("plus the seven required body sections")
      (depends on T002)
- [X] T007 [P] Update `.highway/catalog/README.md`: point the `index.json` schema reference at
      `specs/006-help-skill/contracts/catalog.schema.json` (the current superseding schema)
      instead of `specs/001-multi-agent-skill-suite/contracts/catalog.schema.json` (research.md
      R4)
- [X] T008 [P] Update `.highway/tools/tests/fixtures/valid-skill/SKILL.md`: add a `usage`
      frontmatter field and an `## Example` body section so this fixture remains fully
      conformant under the extended contract (used by validate-skill.test.sh,
      generate-catalog.test.sh, dependency-check.test.sh, generate-agent-adapters.test.sh,
      new-agent-extensibility.test.sh, coverage-summary.test.sh)
- [X] T009 [P] Update `.highway/tools/tests/fixtures/invalid-skill-missing-version/SKILL.md`: add
      a `usage` frontmatter field and an `## Example` body section so this fixture still fails
      for exactly its one intended reason (missing `metadata.version`)
- [X] T010 [P] Update `.highway/tools/tests/fixtures/invalid_skill_bad_id/SKILL.md`: add a
      `usage` frontmatter field and an `## Example` body section so this fixture still fails for
      exactly its one intended reason (invalid id)
- [X] T011 [P] Update `.highway/tools/tests/fixtures/invalid-skill-long-description/SKILL.md`:
      add a `usage` frontmatter field and an `## Example` body section so this fixture still
      fails for exactly its one intended reason (description length)
- [X] T012 Update `.highway/tools/tests/generate-catalog.test.sh`: add `usage` to the
      `for field in name description compatibility version source_path` assertion loop (depends
      on T005, T008)

> Note (discovered during implementation, not in original plan): `.highway/tools/tests/rule-checks.test.sh`
> has its own inline `write_base_skill()` fixture (independent of the `fixtures/` directory) that
> also needed a `usage` field and `## Example` section added, since it is used as a fully-conformant
> baseline for the not-applicable-rules assertion.

**Checkpoint**: Registration contract extended and enforced; every previously-passing test still
has a valid, updated fixture to run against. User story work can now begin.

---

## Phase 3: User Story 1 - Get help for one named skill (Priority: P1) 🎯 MVP

**Goal**: Author the `help` skill and confirm that requesting help for one named, existing skill
produces the exact six-field Single-Skill response.

**Independent Test**: Request help for one existing, fully registered skill (e.g. `help` itself)
and confirm the response contains exactly Name, Description, Dependencies, Version, Usage,
Example, in that order, each populated.

### Implementation for User Story 1

- [X] T013 [US1] Create `.highway/skills/help/SKILL.md`: frontmatter (`name`, `description`,
      `usage`, `compatibility: all`, `metadata.version: 1.0.0`); body sections `## Purpose`
      (one sentence), `## When to use` (>= 2 scenarios: naming one skill, naming none),
      `## When not to use`, `## Inputs` (names `.highway/catalog/index.json`, the target skill's
      own `SKILL.md` under `.highway/skills/<id>/`, and the optional skill-id input),
      `## Outputs` (both response shapes, citing
      [contracts/help-output-contract.md](./contracts/help-output-contract.md)), `## Verification`
      (names `.highway/tools/validate-skill.sh .highway/skills/help` and the quickstart.md
      scenarios as checks, and states the all-skills scan's cost as O(n) per research.md R9),
      `## Error Handling` (unrecognized identifier -> abort with the exact error line from
      contracts/help-output-contract.md; zero skills registered -> state the exact empty-state
      line, never a fallback listing), `## Example` (a copy-able example invoking the skill for
      one named skill, e.g. `/help help`) (spec.md FR-001 through FR-005, FR-010; data-model.md;
      plan.md Constitution Check)
- [X] T014 [US1] Run `.highway/tools/validate-skill.sh .highway/skills/help` and resolve every
      `ERROR:` line until it exits 0 (depends on T013, T003)
- [X] T015 [US1] Verify the Single-Skill mode response for the `help` skill matches
      [contracts/help-output-contract.md](./contracts/help-output-contract.md) exactly: six
      fields in order, `Dependencies:` reads `none` (the `help` skill declares no
      `metadata.dependencies`) (depends on T014; quickstart.md scenario 5; spec.md US1 Acceptance
      Scenario 1)
- [X] T016 [US1] Verify the unrecognized-identifier error path: requesting help for an id that
      matches no registered skill produces exactly one `ERROR: no skill registered with id
      '<id>'` line, with no all-skills listing following it (depends on T014; quickstart.md
      scenario 6; spec.md FR-007, US1 Acceptance Scenario 3)

**Checkpoint**: User Story 1 is fully functional and independently testable — a single skill's
help renders correctly end to end, including its error path.

---

## Phase 4: User Story 2 - Discover all registered skills at once (Priority: P1) 🎯 MVP

**Goal**: Confirm that requesting help with no skill declared produces one consistent row per
currently registered skill, and that each row's Help command actually works.

**Independent Test**: Request help with no skill declared and confirm the response lists every
currently registered skill, each showing exactly Name, Usage, and a copy-able Help command, with
one entry per skill and none omitted.

### Implementation for User Story 2

- [X] T017 [US2] Run `.highway/tools/generate-catalog.sh` and confirm `.highway/catalog/index.json`
      contains a `help` entry with a non-empty `usage` field (depends on T005, T013; quickstart.md
      scenario 3)
- [X] T018 [US2] Verify the All-Skills mode response matches
      [contracts/help-output-contract.md](./contracts/help-output-contract.md): one
      Name/Usage/Help block per `catalog/index.json` entry (including `help` itself), in catalog
      entry order, each `Help:` line reading `/help <id>` (depends on T017; quickstart.md
      scenario 7; spec.md US2 Acceptance Scenario 1)
- [X] T019 [US2] Verify that copying the `Help:` command shown for one listed skill and running
      it verbatim reproduces that same skill's Single-Skill mode response from User Story 1
      (depends on T018, T015; quickstart.md scenario 7; spec.md SC-003, US2 Acceptance Scenario 2)
- [X] T020 [US2] Verify the zero-skills-registered empty state renders the exact line "No skills
      are registered yet." and never an empty table, per
      [contracts/help-output-contract.md](./contracts/help-output-contract.md) (quickstart.md
      scenario 8; spec.md FR-008, US2 Acceptance Scenario 3)

**Checkpoint**: User Story 2 is fully functional and independently testable — the all-skills
listing renders correctly and cross-verifies against User Story 1's format.

---

## Phase 5: User Story 3 - Registration is enforced when a skill is created or updated (Priority: P2)

**Goal**: Confirm that a skill missing `usage` or `## Example` fails validation, naming the
specific missing field, without needing the `help` skill to be invoked at all.

**Independent Test**: Validate a skill fixture that omits `usage` (and, separately, one that
omits `## Example`) and confirm validation fails, naming the specific missing field.

### Tests for User Story 3

- [X] T021 [P] [US3] Create fixture
      `.highway/tools/tests/fixtures/invalid-skill-missing-usage/SKILL.md`: fully conformant
      except the `usage` frontmatter field is absent (spec.md US3 Acceptance Scenario 1)
- [X] T022 [P] [US3] Create fixture
      `.highway/tools/tests/fixtures/invalid-skill-missing-example/SKILL.md`: fully conformant
      except the `## Example` body section is absent (spec.md US3 Acceptance Scenario 2)
- [X] T023 [US3] Update `.highway/tools/tests/validate-skill.test.sh`: add
      `assert_exit_nonzero_naming` and `assert_single_failure` assertions for both new fixtures,
      following the existing pattern used for `invalid-skill-missing-version` etc. (depends on
      T021, T022, T002, T003)

### Implementation for User Story 3

- [X] T024 [US3] Run `.highway/tools/tests/run-all.sh` and confirm the two new fixture
      assertions pass and no existing test regresses (depends on T023 and every Foundational
      task; spec.md US3 Acceptance Scenario 3, SC-004)

**Checkpoint**: User Story 3 is fully functional and independently testable — registration
enforcement is proven by fixture-driven tests alone.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Satisfy the explicit "implemented by all supported coding agents" instruction and
close out documentation/comment drift.

- [X] T025 Run `.highway/tools/generate-agent-adapters.sh` and confirm
      `.github/skills/help/SKILL.md`, `.claude/skills/help/SKILL.md`, and
      `.cursor/rules/help.mdc` are all created; re-run and confirm it reports no drift (depends
      on T014; quickstart.md scenario 4; research.md R8)
- [X] T026 [P] Update the stale comment in
      `.highway/tools/tests/generate-agent-adapters.test.sh` ("so skills/ is left empty
      (FR-011)") to reflect that `.highway/skills/help/` is now a real, permanent skill and only
      the test's own temporary fixture is created and cleaned up
- [X] T027 Run `.highway/tools/tests/run-all.sh` one final time and confirm exit 0 (depends on
      every prior task; quickstart.md scenario 9)

**Checkpoint**: Feature complete — full suite green, all three user stories independently
verified, skill materialized for all three supported agents.

---

## Dependencies & Execution Order

- **Setup (T001)** has no dependencies.
- **Foundational (T002-T012)** depends on Setup; MUST complete before any user story phase, since
  `help/SKILL.md` (T013) cannot pass validation until `usage`/`## Example` enforcement exists,
  and existing fixtures/tests must keep passing before new work is layered on.
- **User Story 1 (T013-T016)** depends on Foundational. T013 is the core deliverable; T014-T016
  depend on it in sequence.
- **User Story 2 (T017-T020)** depends on Foundational and on T013 (needs the `help` skill to
  exist in the catalog); T019 additionally depends on US1's T015.
- **User Story 3 (T021-T024)** depends on Foundational only (T002/T003) — independent of US1/US2,
  can proceed in parallel with them once Foundational is done.
- **Polish (T025-T027)** depends on T014 (a validating `help` skill) and, for T027, on every
  other task.

```text
Setup (T001)
   -> Foundational (T002-T012)
        -> US1 (T013-T016) --\
        -> US2 (T017-T020) ---+--> Polish (T025-T027)
        -> US3 (T021-T024) --/
```

## Parallel Execution Examples

**Within Foundational** (different files, no incomplete-task dependency):

```text
T002, T004, T005, T006, T007, T008, T009, T010, T011  (all [P])
then T003 (depends on T002), then T012 (depends on T005 + T008)
```

**Across user stories**, once Foundational is complete, US1, US2, and US3 can be staffed in
parallel: US1's T013 unblocks both US1's own T014-T016 and US2's T017; US3's T021-T024 needs
nothing from US1/US2 and can run fully concurrently with both.

## Implementation Strategy

**MVP first**: Complete Setup + Foundational + User Story 1 (T001-T016). This alone delivers a
working, validated `help` skill that answers "help for one named skill" correctly — independently
testable and demoable without User Story 2 or 3.

**Incremental delivery**: Add User Story 2 (T017-T020) next — same priority (P1) as US1, and the
other half of the feature's core value (discovery). Add User Story 3 (T021-T024) last (P2) — it
hardens the contract but is not required to demo either help mode. Finish with Polish
(T025-T027) to confirm multi-agent materialization and a fully green suite.
