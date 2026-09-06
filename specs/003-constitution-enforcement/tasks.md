---

description: "Task list for feature 003: Mechanical Enforcement of the Constitution"
---

# Tasks: Mechanical Enforcement of the Constitution

**Input**: Design documents from `/specs/003-constitution-enforcement/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md), [data-model.md](./data-model.md), [contracts/validation-output.md](./contracts/validation-output.md), [quickstart.md](./quickstart.md)

**Tests**: Test tasks are included. They are not a TDD preference — SC-002 states a measurable
outcome ("for each enforced rule, a seeded violation is detected and names that rule ID") that
can only be demonstrated by tests, and the repository already runs a shell test harness.

**Organization**: Tasks are grouped by user story. Note that the fixture rewrites, which deliver
part of User Story 3, sit in the Foundational phase: every check written later runs against
those fixtures, so they must conform first or the suite goes red mid-feature.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Single project. All tooling lives under `.highway/tools/`; the constitution is at
`.specify/memory/constitution.md`. Paths below are relative to the repository root.

---

## Phase 1: Setup

**Purpose**: Establish the baseline the tests assert against, and create the files the
Foundational phase fills in.

- [X] T001 Confirm `.specify/memory/constitution.md` is at version 2.0.1 or later, and record the current rule count and per-tier counts as the baseline values used by T007
- [X] T002 [P] Create `.highway/tools/lib/constitution.sh` with a header comment and no logic
- [X] T003 [P] Create `.highway/tools/lib/body-scan.sh` with a header comment and no logic
- [X] T004 [P] Create `.highway/tools/lib/rule-checks.sh` with a header comment and no logic

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The three shared libraries every check depends on, plus the fixture conformance
that every check will be run against.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

### Constitution parsing

- [X] T005 Implement rule inventory parsing in `.highway/tools/lib/constitution.sh`: read every four-column rule table row and emit one record per rule carrying id, text, observable, and tier (research.md Decision 1)
- [X] T006 Implement prohibited-token list parsing in `.highway/tools/lib/constitution.sh`: read the Prohibited Vagueness List block and the exclusions the constitution states for it (research.md Decision 5)
- [X] T007 Create `.highway/tools/tests/constitution-inventory.test.sh` asserting the parsed rule count and per-tier counts match the T001 baseline, and that a malformed table row fails loudly rather than shrinking the inventory

### Body scanning

- [X] T008 Implement the body scanner in `.highway/tools/lib/body-scan.sh`: emit one annotated record per line carrying line number, current section, fenced-block state, list-item flag, and ordered-item flag (research.md Decision 2, data-model.md Annotated Body Line)
- [X] T009 [P] Create `.highway/tools/tests/body-scan.test.sh` covering a fenced block containing a heading, a fenced block containing a normative keyword, nested lists, and an ordered list, asserting fence state is tracked across lines rather than per line

### Registry and reporting

- [X] T010 Implement the rule-ID-to-check registry in `.highway/tools/lib/rule-checks.sh`, including the validation that every registered rule ID exists in the parsed inventory (data-model.md Check Registry Entry)
- [X] T011 Implement coverage reporting and exit status in `.highway/tools/validate-skill.sh` per `contracts/validation-output.md`: five groups printed on every run, every rule ID in exactly one group, only failed checks affect exit status (research.md Decision 3)
- [X] T012 Create `.highway/tools/tests/coverage-summary.test.sh` asserting every constitution rule ID appears exactly once across the five groups, and that an empty group is printed rather than omitted

### Skill structure and fixture conformance

- [X] T013 Add `Purpose` to the required body section list in `.highway/tools/lib/schema-validate.sh`, raising the required set from six to seven (FR-010)
- [X] T014 Rewrite `.highway/tools/tests/fixtures/valid-skill/SKILL.md` to conform: add a `## Purpose` section of exactly one sentence, list two scenarios under `## When to use`, convert `## Error Handling` to list items each naming one of the four permitted next actions, and replace the pre-relocation `tools/` paths with `.highway/tools/`
- [X] T015 [P] Rewrite `.highway/tools/tests/fixtures/invalid-skill-missing-version/SKILL.md` so it conforms in every respect except the omitted version, preserving its single intended failure reason (FR-012)
- [X] T016 [P] Rewrite `.highway/tools/tests/fixtures/invalid-skill-long-description/SKILL.md` so its only failure is the over-length description (FR-012)
- [X] T017 [P] Rewrite `.highway/tools/tests/fixtures/invalid_skill_bad_id/SKILL.md` so its only failure is the invalid directory name (FR-012)
- [X] T018 Run `.highway/tools/tests/run-all.sh` and confirm green before any rule check is added

**Checkpoint**: Libraries in place, fixtures conform, suite green. Adding checks from here cannot red the suite.

---

## Phase 3: User Story 1 - An author is told which rule they violated (Priority: P1) 🎯 MVP

**Goal**: Validation reports each failure with the constitution rule ID that was violated and
the observable that decided it, so an author repairs the named rule without interpreting the
constitution.

**Independent Test**: Seed one deliberate violation per enforced rule, validate each, and
confirm the corresponding rule ID appears in the output.

### Implementation for User Story 1

- [X] T019 [US1] Register the two existing checks in `.highway/tools/lib/rule-checks.sh` so the version check reports as `P7.2` and the Verification-section check reports as `P8.3` (data-model.md Enforcement Map)
- [X] T020 [P] [US1] Implement the `P7.1` check in `.highway/tools/lib/rule-checks.sh`: a `## Purpose` section is present and holds exactly one sentence
- [X] T021 [P] [US1] Implement the `P1.1` check in `.highway/tools/lib/rule-checks.sh`: each normative line carries exactly one keyword, excluding the token `MUST-level` and excluding lines inside fenced blocks (FR-008, FR-009)
- [X] T022 [P] [US1] Implement the `P1.3` check in `.highway/tools/lib/rule-checks.sh`: each normative line is 25 words or fewer, reporting the counted value and the limit
- [X] T023 [P] [US1] Implement the `P7.4` check in `.highway/tools/lib/rule-checks.sh`: the count of MUST and MUST NOT lines is 12 or fewer
- [X] T024 [P] [US1] Implement the `P7.5` check in `.highway/tools/lib/rule-checks.sh`: each normative section is 400 words or fewer, recording not-applicable when the skill has no normative section
- [X] T025 [P] [US1] Implement the `P3.5` check in `.highway/tools/lib/rule-checks.sh`: each citation matches the constitution's Citation Format and resolves to AS-1 through AS-6, recording not-applicable when the skill contains no citation
- [X] T026 [P] [US1] Implement the `P5.3` check in `.highway/tools/lib/rule-checks.sh`: a numeral follows each retry instruction, recording not-applicable when the skill names no retry
- [X] T027 [P] [US1] Implement the `P8.1` check in `.highway/tools/lib/rule-checks.sh`: ordered list items are sequentially numbered, recording not-applicable when the skill contains no ordered list (FR-024)
- [X] T028 [P] [US1] Implement the `P5.2` check in `.highway/tools/lib/rule-checks.sh`: each list item in the Error Handling section names one of the four permitted next actions, recording not-applicable when that section contains no list (FR-025)
- [X] T029 [P] [US1] Implement the `P4.2` check in `.highway/tools/lib/rule-checks.sh`: the Verification section contains none of the three prohibited claim words (FR-026)
- [X] T030 [US1] Create `.highway/tools/tests/rule-checks.test.sh` with one seeded violation per enforced rule, asserting each is detected and reports its own rule ID (SC-002)
- [X] T031 [US1] Extend `.highway/tools/tests/rule-checks.test.sh` to assert the finding line format and the result line format match `contracts/validation-output.md`, matching on rule ID and counted value rather than on message wording
- [X] T032 [US1] Extend `.highway/tools/tests/rule-checks.test.sh` to assert that a not-applicable outcome names its permitted condition and does not affect exit status (FR-032)

**Checkpoint**: User Story 1 is complete and independently testable. Twelve rules are enforced by ID.

---

## Phase 4: User Story 2 - The authoring standard stops duplicating the constitution (Priority: P2)

**Goal**: The authoring standard cites rule IDs instead of restating rule text, so the two
documents cannot drift apart.

**Independent Test**: Inspect the authoring standard and confirm no constitution rule text is
restated and that its checklist references rule IDs.

### Implementation for User Story 2

- [X] T033 [US2] Rewrite the Constitution Compliance Checklist in `.highway/skills/_authoring-standard.md` so each item cites a rule ID rather than paraphrasing the rule (FR-022)
- [X] T034 [US2] Remove every restated constitution rule from `.highway/skills/_authoring-standard.md`, replacing each with a reference to the governing rule ID (P7.3)
- [X] T035 [US2] Update the documented directory layout and frontmatter example in `.highway/skills/_authoring-standard.md` to include the `## Purpose` section introduced by T013
- [X] T036 [US2] Create `.highway/tools/tests/authoring-standard.test.sh` asserting that no constitution rule text appears in the authoring standard and that the checklist cites rule IDs (SC-005, quickstart.md Section 7)

**Checkpoint**: User Stories 1 and 2 both work independently.

---

## Phase 5: User Story 3 - The repository's fixtures and examples conform (Priority: P3)

**Goal**: Every skill-shaped artifact in the repository passes the same validation an authored
skill must pass, and no file carries a pre-relocation path.

**Independent Test**: Run validation against every skill-shaped artifact and confirm each
passes; run the path check across every file under the tooling directory.

**Note**: The fixture rewrites this story depends on were completed in Phase 2 (T014 to T017)
because every check added in Phase 3 runs against them. What remains here is repository-wide
verification.

### Implementation for User Story 3

- [X] T037 [US3] Create `.highway/tools/tests/path-integrity.test.sh` checking every file beneath `.highway/` for pre-relocation path references, rather than an enumerated list of documents (FR-013)
- [X] T038 [US3] Repair any pre-relocation path reference T037 reports, anywhere beneath `.highway/` (FR-014)
- [X] T039 [US3] Extend `.highway/tools/tests/validate-skill.test.sh` to validate every skill-shaped artifact in the repository that is intended to be valid, asserting zero unintended failures (SC-001)
- [X] T040 [US3] Assert in `.highway/tools/tests/validate-skill.test.sh` that each intentionally invalid fixture still fails for its one stated reason and no other (FR-012)

**Checkpoint**: All three user stories are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T041 Run `.highway/tools/tests/run-all.sh` and confirm every test passes (SC-003)
- [X] T042 Execute every section of [quickstart.md](./quickstart.md) end to end and repair any discrepancy found
- [X] T043 Confirm validation of one skill completes in under 2 seconds on the reference platform (quickstart.md Section 8)
- [X] T044 Confirm the deferred and unchecked groups behave as designed: rule `P2.3` appears under `DEFERRED` or `UNCHECKED`, and rule `P6.4` appears under `UNCHECKED` pending constitution amendment 2.0.2 (research.md Decision 7)
- [X] T045 Update `.highway/tools/README.md` to document the new coverage summary output and the three new library files

---

## Deferred: Group B (blocked on constitution amendment 2.0.2)

Not part of this feature's completion criteria. Listed so the boundary is explicit rather than
forgotten. See research.md Decision 7.

- [ ] T046 [US1] Implement the `P6.4` check once amendment 2.0.2 defines the prohibited time, randomness, and preference token list in the constitution (FR-027, FR-033)
- [ ] T047 [US1] Confirm rule `P2.3` reports as deferred once amendment 2.0.2 retags it as judgment-requiring (FR-028)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies. T002 to T004 are parallel.
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story.
- **User Story 1 (Phase 3)**: Depends on Foundational. Independent of US2 and US3.
- **User Story 2 (Phase 4)**: Depends on Foundational only. Fully independent of US1 and US3; can run in parallel with either.
- **User Story 3 (Phase 5)**: Depends on Foundational, and T039/T040 depend on US1 checks existing to be meaningful.
- **Polish (Phase 6)**: Depends on US1, US2, and US3.

### Critical sequencing note

The fixture rewrites (T014 to T017) MUST precede every rule check in Phase 3. Adding a check
before the fixtures conform reds three test suites at once, because the catalog and adapter
suites both copy `valid-skill/SKILL.md` as their input. This is why the lowest-priority user
story has work in the Foundational phase.

### Within User Story 1

- T019 before T030, since the seeded-violation test asserts on registered rule IDs.
- T020 to T029 are mutually independent in logic but all edit the same file; they are marked [P]
  because each adds a separate function, though a single implementer should expect to serialize
  the writes.
- T030 to T032 depend on all checks being registered.

### Dependency graph

```text
Setup (T001-T004)
   │
   ▼
Foundational (T005-T018)
   ├── constitution.sh (T005, T006) ──► T007
   ├── body-scan.sh (T008) ──────────► T009
   ├── registry + reporting (T010, T011) ──► T012
   └── fixtures (T013-T017) ─────────► T018 green
   │
   ├──────────────► US1 (T019-T032) ──┐
   ├──────────────► US2 (T033-T036) ──┤
   └──────────────► US3 (T037-T040) ──┤
                                      ▼
                             Polish (T041-T045)
```

### Parallel Opportunities

- T002, T003, T004 in Setup.
- T015, T016, T017 in Foundational (three separate fixture files).
- T009 alongside T005 to T007 (different files).
- US2 (T033 to T036) in parallel with all of US1; they share no file.
- T020 to T029 are logically parallel, though they share one file.

---

## Parallel Example: Foundational fixtures

```bash
Task: "Rewrite .highway/tools/tests/fixtures/invalid-skill-missing-version/SKILL.md"
Task: "Rewrite .highway/tools/tests/fixtures/invalid-skill-long-description/SKILL.md"
Task: "Rewrite .highway/tools/tests/fixtures/invalid_skill_bad_id/SKILL.md"
```

## Parallel Example: User Story 2 alongside User Story 1

```bash
Task: "Rewrite the Constitution Compliance Checklist to cite rule IDs"
Task: "Implement the P7.1 check in rule-checks.sh"
```

---

## Implementation Strategy

### MVP scope

Setup + Foundational + User Story 1. That delivers rule-level feedback against twelve enforced
rules, which is the only part of this feature that helps while writing a skill. Stop and
validate there.

### Incremental delivery

1. Setup + Foundational → libraries exist, fixtures conform, suite green.
2. Add User Story 1 → validate independently → this is the MVP.
3. Add User Story 2 → the document an author reads is accurate and drift-proof.
4. Add User Story 3 → repository-wide verification.
5. Polish.

### A note on ordering versus priority

User Story 3 is the lowest-value story but has work in the Foundational phase. That is
deliberate and is not a priority error: value and sequence differ here. Treat the fixture
rewrites as infrastructure, not as story delivery.

### If amendment 2.0.2 is declined

Everything above still ships. Rule `P6.4` reports as unchecked and rule `P2.3` reports as
whatever tier the constitution then carries. The feature's completion criteria do not depend on
Group B.
