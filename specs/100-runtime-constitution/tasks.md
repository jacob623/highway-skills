# Tasks: Revise the Runtime Skills Constitution

**Input**: Design documents from `specs/100-runtime-constitution/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/skills-constitution-amendment.md, quickstart.md

**Tests**: `.highway/tools/tests/constitution-inventory.test.sh` is in scope. The user included it so the inventory matches the amended constitution. No other test, validator, skill file, or development-constitution file is edited.

**Organization**: One constitution file and one test file. Story phases run in order because both files are shared. Update the test assertions for a story first, then edit the constitution until those assertions pass.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup

**Purpose**: Record the widened file boundary before editing.

- [X] T001 Update `specs/100-runtime-constitution/plan.md` Complexity Tracking and `specs/100-runtime-constitution/quickstart.md` so the allowed edits are `.highway/governance/constitution.md` and `.highway/tools/tests/constitution-inventory.test.sh`. Quickstart step 6 expects that test to exit 0. The D3.2 exception remains only for every other test. `.highway/skills/` and `.specify/memory/constitution.md` stay unchanged.

---

## Phase 2: Foundational

**Purpose**: Keep the rule table readable by the existing parser. No parser edit.

- [X] T002 Confirm `.highway/tools/lib/constitution.sh` reads a rule row as identifier, rule, observable, and tier. New and redefined rows in `.highway/governance/constitution.md` must use that shape. Do not edit the parser.

**Checkpoint**: Row shape is fixed. Story work can begin.

---

## Phase 3: User Story 1 - Runtime governance only (Priority: P1)

**Goal**: The Skills Constitution no longer contains the compliance review procedure, the skill authoring workflow, the merge decision, or the four development quality gates.

**Independent Test**: `constitution-inventory.test.sh` fails while those sections are still present, then passes those assertions after they are removed. Experience Standard compliance remains a reference. Historical sync-report mentions are not treated as current sections.

### Tests for User Story 1

- [X] T003 [US1] In `.highway/tools/tests/constitution-inventory.test.sh`, replace the assertions around the Compliance Review Protocol, `X2.5`, `X2.6`, and the governance sentence that requires both protocols. Require Experience Standard compliance by reference (`**Experience Standard**`, `X. Experience Compliance`, `P10.1`, `P10.2`, precedence rank 10). Fail if a current section heading for the Compliance Review Protocol, the Skill Authoring Workflow, or the merge decision is present. Add a comment that the replaced assertions described superseded behavior. Do not fail on a historical sync-report mention of those names.

### Implementation for User Story 1

- [X] T004 [US1] In `.highway/governance/constitution.md`, remove the Code Generation, Testing, Maintainability, and Performance gates, the Compliance Review Protocol, the Skill Authoring Workflow, and the merge decision, per `specs/100-runtime-constitution/contracts/skills-constitution-amendment.md`. State that the document is runtime governance and that development material is not a runtime skill dependency. Do not use the character sequences `.specify/` or `specs/`. Run `.highway/tools/tests/constitution-inventory.test.sh` and confirm the User Story 1 assertions pass. Leave the existing P12 block unchanged until User Story 2.

**Checkpoint**: Development-only procedures are gone from the current document. The inventory test agrees.

---

## Phase 4: User Story 2 - Common failure and owner completion (Priority: P1)

**Goal**: Per-step failure rules and post-write completion checks are replaced by the common failure model and the owner/orchestrator contract.

**Independent Test**: The inventory test requires current rows `P12.5` through `P12.12`, rejects current rows `P12.1` through `P12.4`, and rejects a current `N6` registration. Precedence rank 5 names owner-controlled completion.

### Tests for User Story 2

- [X] T005 [US2] In `.highway/tools/tests/constitution-inventory.test.sh`, replace the Feature 089 block that requires exactly `P12.1` through `P12.5`, a current `N6` registration, the `P12.1-P12.4` N6 mapping, and the precedence label `XII. Persistence and Completion Integrity`. Assert current rule rows for `P12.5` through `P12.12`, assert `P12.1` through `P12.4` are absent as current rows, assert `N6` has no current registration, and assert rank 5 names owner-controlled completion and orchestration. Keep the rank 11 and rank 6 checks. Match rule rows, not historical mentions. Comment that the old assertions described superseded behavior.

### Implementation for User Story 2

- [X] T006 [US2] In `.highway/governance/constitution.md`, retire `P5.1` through `P5.5` and `P12.1` through `P12.4`. Keep `P5.6`. Add `P5.7` through `P5.14` and `P12.6` through `P12.12`. Redefine `P1.7` and `P12.5`. Remove Persistence Verification, Verified Completion Claim, and `N6`. Rename Principle XII and replace the rank 5 reason. Follow the obligation text in `specs/100-runtime-constitution/contracts/skills-constitution-amendment.md`. Each row has one keyword, one obligation, and no more than 25 words. Run `.highway/tools/tests/constitution-inventory.test.sh` and confirm the User Story 2 assertions pass.

**Checkpoint**: The failure model and the owner/orchestrator contract are the current Principle V and Principle XII rules.

---

## Phase 5: User Story 3 - Cite shared governance (Priority: P2)

**Goal**: External citations, development checks, verification, templates, experience, and repository context match the redefined contract.

**Independent Test**: The inventory test requires the redefined rows and rejects the retired rows from this story as current rules.

### Tests for User Story 3

- [X] T007 [US3] In `.highway/tools/tests/constitution-inventory.test.sh`, add current-row assertions for the User Story 3 identifier map in `specs/100-runtime-constitution/contracts/skills-constitution-amendment.md`. Absent as current rows: `P3.1`, `P4.1`, `P4.3`, `P8.1`, `P11.5`. Present as current rows: `P3.3`, `P4.2`, `P4.4`, `P4.5`, `P4.6`, `P5.6` through `P5.14`, `P7.3`, `P8.2`, `P8.3`, `P8.4`, `P9.1`, `P11.1` through `P11.4`. Do not require the four removed development gates. Comment that any replaced assertion described superseded behavior.

### Implementation for User Story 3

- [X] T008 [US3] In `.highway/governance/constitution.md`, apply the retired and redefined rows for authority, quality gates, the Security Gate, verification, maintainability, shared output, experience compliance, and repository context from `specs/100-runtime-constitution/contracts/skills-constitution-amendment.md`. Keep the approved-source list closed and state that a later amendment may add an entry that names its provenance. Run `.highway/tools/tests/constitution-inventory.test.sh` and confirm the User Story 3 assertions pass.

**Checkpoint**: Citation, verification, template, experience, and context rules match the contract.

---

## Phase 6: User Story 4 - Major amendment is internally consistent (Priority: P2)

**Goal**: The version, amendment record, counts, and current-rule cross-references agree with the rules that remain.

**Independent Test**: The inventory test requires footer `4.0.0` and last amended `2026-09-29`, and still finds the historical `2.6.0 → 3.0.0` report and the single Principle XI bump rationale.

### Tests for User Story 4

- [X] T009 [US4] In `.highway/tools/tests/constitution-inventory.test.sh`, point the current-footer assertions at `**Version**: 4.0.0` and `**Last Amended**: 2026-09-29`, and require a sync impact report line for `3.0.1 → 4.0.0` as MAJOR. Keep the assertions for `Version change: 2.6.0 → 3.0.0 (MAJOR)`, `This changes constitutional conflict-resolution behavior`, and exactly one Principle XI bump rationale. Stop requiring `Compliance Review Protocol evidence: constitution-inventory.test.sh` as the current amendment. Comment that the footer assertions described the superseded version.

### Implementation for User Story 4

- [X] T010 [US4] In `.highway/governance/constitution.md`, prepend the 4.0.0 sync impact report listing every retired, redefined, and added identifier, the principle rename, the precedence reason, the removed sections, and the self-application review against `P1.1`, `P1.2`, `P1.3`, `P1.4`, `P6.4`, `P6.6`, and `P7.3`. Set the footer to version `4.0.0`, ratified `2026-09-06`, last amended `2026-09-29`. Keep the older reports. Remove current normative references to retired identifiers. Definitions and examples that only teach a removed obligation are removed or rewritten. Run `.highway/tools/tests/constitution-inventory.test.sh` and confirm it exits 0.

**Checkpoint**: The constitution and the inventory test describe the same current amendment.

---

## Phase 7: Polish

**Purpose**: Confirm the file boundary and the quickstart.

- [X] T011 Run `.highway/tools/tests/constitution-inventory.test.sh` from the repository root and record exit 0 in `specs/100-runtime-constitution/quickstart.md` results if that step is not already updated.
- [X] T012 Walk quickstart steps 1 through 5 in `specs/100-runtime-constitution/quickstart.md`. `git diff --name-only` for implementation files is limited to `.highway/governance/constitution.md` and `.highway/tools/tests/constitution-inventory.test.sh`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks the story phases.
- **User Story 1 (Phase 3)**: Depends on Foundational.
- **User Story 2 (Phase 4)**: Depends on User Story 1. Both edit the same two files.
- **User Story 3 (Phase 5)**: Depends on User Story 2.
- **User Story 4 (Phase 6)**: Depends on User Story 3. The version footer is last so earlier stories do not fight the old footer assertions.
- **Polish (Phase 7)**: Depends on User Story 4.

### User Story Dependencies

- **User Story 1 (P1)**: First constitution slice. No dependency on later stories.
- **User Story 2 (P1)**: Follows User Story 1 because the inventory test's P12 block is still the old contract until T005.
- **User Story 3 (P2)**: Follows User Story 2 so the new failure-model rows exist before the broader identifier assertions.
- **User Story 4 (P2)**: Follows User Story 3 so the sync report can name the finished identifier map.

### Within Each User Story

- The test task comes before the constitution edit.
- The test is expected to fail on the old constitution text before that story's constitution edit.
- Do not mark the story complete until its inventory assertions pass.

### Parallel Opportunities

- None. T003 through T010 edit two shared files in a fixed order. T001 edits spec artifacts and can finish before T002, but it does not overlap a story task.

---

## Parallel Example: User Story 1

```text
No parallel tasks. T003 edits the inventory test. T004 edits the constitution after T003.
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (T003, T004).
3. Stop and confirm the inventory assertions for the removed development procedures pass.

### Incremental Delivery

1. Setup and parser check.
2. User Story 1: development procedures leave the runtime constitution.
3. User Story 2: failure model and owner/orchestrator contract.
4. User Story 3: citation, verification, template, experience, and context rules.
5. User Story 4: version 4.0.0 and a report that matches the inventory test.
6. Polish: one-file-pair diff and quickstart steps 1 through 5.

### Parallel Team Strategy

One implementer. The constitution and the inventory test cannot be split across people without merge conflicts.

---

## Notes

- The 2026-09-29 clarification left skill text and development governance unchanged. This task list adds only `.highway/tools/tests/constitution-inventory.test.sh`, as requested afterward.
- Validators under `.highway/tools/lib/` and every test other than the inventory test stay unchanged. They may still encode retired rules until the deferred tooling change. Do not edit them here.
- Replacing an assertion is allowed only with a comment naming the superseded behavior. Do not delete a historical-report assertion that the kept sync reports still satisfy.
- Retired identifiers may appear in older sync reports. Assertions must target current rule rows and current section headings.
- Each new constitution row: one keyword, one obligation, 25 words or fewer, plus an observable and a tier.
