---

description: "Task list for the final governance amendment"
---

# Tasks: Final Governance Amendment

**Input**: Design documents from `specs/102-final-governance-amendment/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/constitution-size-rule.md, contracts/experience-standard-amendment.md, quickstart.md

**Tests**: Required. FR-018 and D3.6 require each updated test to fail on the current text before the governance edit that makes it pass. D3.1 requires `.highway/tools/tests/run-all.sh` to exit 0 before the first edit of this feature.

**Organization**: The Skills Constitution and the Experience Standard are shared files, so story phases that edit the same file run in order. User Story 1 uses different files from User Stories 2 and 3.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup

**Purpose**: Keep the redefined rows readable by the existing parser.

- [X] T001 Confirm `.highway/tools/lib/constitution.sh` reads a rule row as identifier, rule, observable, and tier. The redefined rows in `.highway/governance/constitution.md` and `.highway/governance/experience-standard.md` must keep that shape, including a tier. Do not edit the parser. Do not edit `.highway/tools/lib/rule-checks.sh`. P7.6 stays `[agent-checkable]`.

---

## Phase 2: Foundational

**Purpose**: Start from a green suite.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0 before any edit in this feature. If it fails, update only the failing files under `.highway/tools/tests/` until the suite exits 0, and comment each replaced assertion with the superseded behavior. Do not edit `.highway/governance/constitution.md` or `.highway/governance/experience-standard.md` in this task.

**Checkpoint**: Suite exits 0. Story work can begin.

---

## Phase 3: User Story 1 - An oversized skill is reduced, not split (Priority: P1) 🎯 MVP

**Goal**: A skill over the existing size limits is reduced until that same skill satisfies both limits. The constitution is 5.0.0. Live authoring guidance no longer requires a split.

**Independent Test**: `.highway/tools/tests/constitution-inventory.test.sh` requires the current P7.6 reduction sentence, footer 5.0.0, and the older constitution reports, and exits 0. `.highway/skills/_authoring-standard.md` cites P7.6 and does not require additional skills.

### Tests for User Story 1

- [X] T003 [US1] In `.highway/tools/tests/constitution-inventory.test.sh`, require footer `**Version**: 5.0.0`, ratified 2026-09-06, and last amended 2026-09-29. Comment that the 4.1.0 footer assertion described the prior amendment. Still require `4.0.0 → 4.1.0 (MINOR)`, `3.0.1 → 4.0.0 (MAJOR)`, `2.6.0 → 3.0.0 (MAJOR)`, and the Principle XI bump rationale. Require the current P7.6 row from `specs/102-final-governance-amendment/contracts/constitution-size-rule.md`, and require that current row not to be the split sentence. Run the test with unrestricted filesystem access and confirm it fails before `.highway/governance/constitution.md` is edited.

### Implementation for User Story 1

- [X] T004 [US1] In `.highway/governance/constitution.md`, redefine P7.6 per `specs/102-final-governance-amendment/contracts/constitution-size-rule.md`. Keep one keyword, one obligation, and 14 words. Keep P7.3, P7.4, P7.5, every other current rule, and the precedence table. Prepend the 4.1.0 to 5.0.0 major sync report, including the self-application review of P1.1, P1.2, P1.3, P1.4, P6.4, P6.6, and P7.3. Keep every older report. Set the footer to 5.0.0, ratified 2026-09-06, last amended 2026-09-29. Do not introduce `.specify/` or `specs/`. Re-run `.highway/tools/tests/constitution-inventory.test.sh` with unrestricted filesystem access and confirm it exits 0.
- [X] T005 [P] [US1] In `.highway/skills/_authoring-standard.md`, replace "split the skill rather than exceeding either" with a paraphrase that the skill is reduced until both limits hold, still citing **P7.4, P7.5, P7.6**, per `specs/102-final-governance-amendment/contracts/constitution-size-rule.md`. Do not copy the P7.6 rule sentence. Do not edit any `SKILL.md`. Run `.highway/tools/tests/authoring-standard.test.sh` and confirm it exits 0.

**Checkpoint**: The current size remedy is reduction, and the authoring citation matches it.

---

## Phase 4: User Story 2 - Decision Context says why it matters (Priority: P1)

**Goal**: When Decision Context applies, the prompt uses `**Why it matters:**`, a concise explanation, and one question. The label is absent when Decision Context is not needed.

**Independent Test**: `.highway/tools/tests/highway-ux-alignment.test.sh` requires the new X2.9 sentence in `.highway/governance/experience-standard.md` and exits 0 for that assertion.

### Tests for User Story 2

- [X] T006 [US2] In `.highway/tools/tests/highway-ux-alignment.test.sh`, replace the required X2.9 sentence with the rule from `specs/102-final-governance-amendment/contracts/experience-standard-amendment.md`. Leave the X2.25 assertion and the Repository Context history assertion for later stories. Leave the `Why it matters:` assertion on `.highway/skills/highway-objectives/SKILL.md` unchanged. Run the test and confirm it fails before X2.9 is edited.

### Implementation for User Story 2

- [X] T007 [US2] In `.highway/governance/experience-standard.md`, redefine X2.9 per `specs/102-final-governance-amendment/contracts/experience-standard-amendment.md`. Keep the tier column. Do not change X2.25 or the opening history comment in this task. Do not introduce `.specify/` or `specs/`. Re-run `.highway/tools/tests/highway-ux-alignment.test.sh` and confirm the X2.9 assertion passes.

**Checkpoint**: Decision Context requires the Why it matters label.

---

## Phase 5: User Story 3 - Recommendations share a meaning, not one layout (Priority: P1)

**Goal**: Profile enrichment, Objectives, Controls, and Non-Functional Requirements use the shared recommendation model. A numbered list is allowed and is not required.

**Independent Test**: `.highway/tools/tests/highway-ux-alignment.test.sh` requires the new X2.25 sentence and exits 0. The five-choice cap and selection-as-acceptance rows are still present.

### Tests for User Story 3

- [X] T008 [US3] In `.highway/tools/tests/highway-ux-alignment.test.sh`, replace the required X2.25 sentence with the rule from `specs/102-final-governance-amendment/contracts/experience-standard-amendment.md`. Run the test and confirm it fails before X2.25 is edited.

### Implementation for User Story 3

- [X] T009 [US3] In `.highway/governance/experience-standard.md`, redefine X2.25 and add the non-normative recommendation illustration per `specs/102-final-governance-amendment/contracts/experience-standard-amendment.md`. The illustration must state that it is not a required layout. Do not change X2.16 through X2.22 or X2.27 through X2.31. Do not edit any `SKILL.md`. Re-run `.highway/tools/tests/highway-ux-alignment.test.sh` and confirm the X2.25 assertion passes.

**Checkpoint**: The shared recommendation model is current, and numbering is not required.

---

## Phase 6: User Story 4 - The current standard stands on its current record (Priority: P2)

**Goal**: The Experience Standard contains one sync impact report, for 3.0.0 to 4.0.0. The Skills Constitution keeps its older reports.

**Independent Test**: `.highway/tools/tests/experience-standard-amendment.test.sh` requires exactly one `Sync Impact Report` and `3.0.0 → 4.0.0 (MAJOR)`, and exits 0. The removed history tokens are absent from `.highway/governance/experience-standard.md`.

### Tests for User Story 4

- [X] T010 [P] [US4] In `.highway/tools/tests/experience-standard-amendment.test.sh`, stop requiring `1.6.1 -> 2.0.0 (MAJOR)` and comment that this superseded token was removed from the runtime document. Require `3.0.0 → 4.0.0 (MAJOR)`, exactly one `Sync Impact Report` heading, the X2.3 observable sentence `Every user-visible response excludes Implementation details unless requested.`, and the new X2.9 and X2.25 rows from `specs/102-final-governance-amendment/contracts/experience-standard-amendment.md`. Keep the other current-row assertions already in the test. Run the test and confirm it fails before the Experience Standard history comment is replaced.
- [X] T011 [P] [US4] In `.highway/tools/tests/highway-ux-alignment.test.sh`, stop requiring exactly one `Bump rationale: adds Repository Context definitions, Contextual Guidance, and X2.7-X2.8 without`. Comment that this superseded history check required that rationale to remain in the runtime document. Require `3.0.0 → 4.0.0 (MAJOR)` and require that old rationale to be absent. Run the test and confirm it fails before the Experience Standard history comment is replaced.

### Implementation for User Story 4

- [X] T012 [US4] In `.highway/governance/experience-standard.md`, replace the opening HTML comment with only the 3.0.0 to 4.0.0 sync report per `specs/102-final-governance-amendment/contracts/experience-standard-amendment.md`. Do not name a test file, a feature number, or the development constitution in that report. Set the footer to `**Version**: 4.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-09-29`. Do not remove current rule text. Do not edit `.highway/governance/constitution.md` in this task. Re-run `.highway/tools/tests/experience-standard-amendment.test.sh` and `.highway/tools/tests/highway-ux-alignment.test.sh` and confirm both exit 0.

**Checkpoint**: The Experience Standard has one current amendment record. The constitution history is intact.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Confirm the whole amendment and the unchanged boundaries.

- [X] T013 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0.
- [X] T014 [P] Walk steps 3 through 6 of `specs/102-final-governance-amendment/quickstart.md`. Confirm the diff is limited to `.highway/governance/constitution.md`, `.highway/governance/experience-standard.md`, `.highway/skills/_authoring-standard.md`, and the three tests named above. Confirm no `SKILL.md` diff, no shared-template diff, no generator diff, and no diff in `.specify/memory/constitution.md`. Confirm neither governance file contains `.specify/` or `specs/`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational. Uses the constitution, the inventory test, and the authoring standard.
- **User Story 2 (Phase 4)**: Depends on Foundational. Uses the Experience Standard and `highway-ux-alignment.test.sh`.
- **User Story 3 (Phase 5)**: Depends on User Story 2 because both edit those same two files.
- **User Story 4 (Phase 6)**: Depends on User Stories 2 and 3 so the new X2.9 and X2.25 rows exist before the history assertions require them.
- **Polish (Phase 7)**: Depends on the desired user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on User Stories 2, 3, or 4.
- **User Story 2 (P1)**: No dependency on User Story 1.
- **User Story 3 (P1)**: Follows User Story 2.
- **User Story 4 (P2)**: Follows User Stories 2 and 3. Does not edit the constitution.

### Within Each User Story

- The test task runs and fails before the matching document edit.
- T005 can run alongside T004 because they edit different files.
- T010 and T011 can run together. T012 waits until both have been observed failing.

### Parallel Opportunities

- After Phase 2, User Story 1 and User Story 2 can proceed together.
- T005 is independent of T004.
- T010 and T011 edit different tests.
- T013 and T014 can run together after the story phases.
- User Story 3 stays after User Story 2, and User Story 4 stays after User Story 3, because they share `.highway/governance/experience-standard.md` and `.highway/tools/tests/highway-ux-alignment.test.sh`.

---

## Parallel Example: User Story 1 and User Story 4

```text
T004 .highway/governance/constitution.md
T005 .highway/skills/_authoring-standard.md

T010 .highway/tools/tests/experience-standard-amendment.test.sh
T011 .highway/tools/tests/highway-ux-alignment.test.sh
```

T012 replaces the Experience Standard history comment only after T010 and T011 have failed.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (T003, T004, T005).
3. Stop and confirm `.highway/tools/tests/constitution-inventory.test.sh` exits 0 and the authoring citation no longer requires a split.

### Incremental Delivery

1. Setup and a green suite.
2. User Story 1: P7.6 requires reduction, constitution 5.0.0, authoring citation updated.
3. User Story 2: X2.9 requires `**Why it matters:**`.
4. User Story 3: X2.25 uses the shared recommendation model.
5. User Story 4: Experience Standard history is only the 4.0.0 report.
6. Polish: full suite and quickstart.

### Parallel Team Strategy

One implementer can take the constitution and the authoring citation while another takes X2.9. After X2.9, the same Experience Standard implementer continues with X2.25 and then the history replacement. T010 can be done by either person once X2.9 and X2.25 exist.

---

## Notes

- The 2026-09-29 clarification updates tests and live citations of the superseded rules. It does not rewrite Profile, Objectives, Controls, Non-Functional Requirements, or Setup.
- A replaced assertion needs a comment naming the superseded behavior.
- Constitution history stays. Experience Standard history is replaced. Assertions against the Experience Standard must not require a removed report to remain.
- Do not chmod every test. `.highway/tools/tests/run-all.sh` invokes each test with bash.
- Run the full suite and `constitution-inventory.test.sh` with unrestricted filesystem access. A sandboxed run can fail regeneration probes without a defect in this amendment.
