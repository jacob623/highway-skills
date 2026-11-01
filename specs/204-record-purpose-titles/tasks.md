---

description: "Task list for record purpose titles"
---

# Tasks: Record Purpose Titles

**Input**: Design documents from `/specs/204-record-purpose-titles/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/record-titles.md, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before the skill edits.

**Organization**: Tasks are grouped by user story so each story can be checked on its own.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

---

## Phase 1: Setup

**Purpose**: Confirm a green suite before any edit (D3.1)

- [X] T001 Run `bash .highway/tools/tests/run-all.sh > /tmp/204-baseline.txt 2>&1; echo "EXIT:$?" >> /tmp/204-baseline.txt` with all permissions, then copy the `Summary:` and `EXIT:` lines into specs/204-record-purpose-titles/baseline.txt. Stop if any test fails

---

## Phase 2: Foundational

**Purpose**: The failing test and the template headings that every story relies on

- [X] T002 Create .highway/tools/tests/record-purpose-titles.test.sh (mode 644) in the house style: the `# Instrument class: static-document-contract`, `# Artifact classes: source-document`, and `# Seeded failure probe:` header lines, then `require` and `reject` helpers using `grep -Fq`. Assert in `.highway/skills/highway-architecture/SKILL.md`: reject `The architecture title is the ADR title unless`; require `**Title:** [Purpose title.]`, `The architecture title is the purpose in the ADR title`, `the first " for "`, `ask for a purpose title`, `for a different ADR: go to`, and `version: 5.0.0`. Assert in `.highway/skills/highway-implementation/SKILL.md`: reject `The implementation title is the architecture title unless`; require `**Title:** [Product title.]`, `The implementation title is the product in the title of the decision this realization came from`, `the first " for "`, `under a different architecture: the title becomes "[Product] for [purpose]"`, `under this architecture: use the existing record`, and `version: 5.0.0`. Assert in `.highway/library/templates/output/architecture-record.md`: require `# <purpose title>` and `version: 2.1.0`. Assert in `.highway/library/templates/output/implementation-record.md`: require `# <product title>` and `version: 2.1.0`. End with `PASS: record purpose and product titles`
- [X] T003 Run `bash .highway/tools/tests/record-purpose-titles.test.sh > specs/204-record-purpose-titles/probe-fail.txt 2>&1; echo "EXIT:$?" >> specs/204-record-purpose-titles/probe-fail.txt` and confirm it fails with FAIL lines and a nonzero exit (D3.6)
- [X] T004 [P] In .highway/library/templates/output/architecture-record.md, change the heading placeholder `# <deterministic architecture title>` to `# <purpose title>`, add one sentence saying the title is the decision's purpose and names no product, and bump `version: 2.0.0` to `version: 2.1.0`
- [X] T005 [P] In .highway/library/templates/output/implementation-record.md, change `# <deterministic implementation title>` to `# <product title>`, add one sentence saying the title is the product or named mechanism, followed by "for" and the purpose only when that product title is taken, and bump `version: 2.0.0` to `version: 2.1.0`. Leave `Title: <accepted architecture title>` under Architecture Reference unchanged

**Checkpoint**: The new test fails only on skill strings and skill versions

---

## Phase 3: User Story 1 - Name the architecture by its purpose (Priority: P1)

**Goal**: An architecture is titled by the decision's purpose, shown on the proposal, with no "Adopt" and no product

**Independent Test**: Read the architecture proposal and `identifier`. "Adopt Notion for teacher scheduling" yields **Title:** Teacher scheduling. A product named in a title edit is left out

- [X] T006 [US1] In the `start` proposal block of .highway/skills/highway-architecture/SKILL.md, add `**Title:** [Purpose title.]` as the first line after `**Here is a proposed starting point for your architecture:**`. In the `edit` bullet, say that an edit to the title is a supplied title and that a product it names is left out under the existing product rule
- [X] T007 [US1] In `identifier` of .highway/skills/highway-architecture/SKILL.md, replace `The architecture title is the ADR title unless the person supplied a title.` with the rule from contracts/record-titles.md: `The architecture title is the purpose in the ADR title, unless the person supplied a title that names no product.`, then remove a leading "Adopt" without regard to case, take the text after `the first " for "`, capitalize its first letter, and keep every other word
- [X] T008 [US1] In the id comparison bullets of `identifier` in .highway/skills/highway-architecture/SKILL.md, reuse the existing record only when the same title's catalog row lists this ADR, and add `The same title already has that id for a different ADR: go to `title`.`

**Checkpoint**: The architecture title rules for US1 are present

---

## Phase 4: User Story 2 - Name the implementation by its product (Priority: P1)

**Goal**: An implementation is titled by the decision's product, shown on the proposal

**Independent Test**: Read the implementation proposal and `identifier`. "Adopt Notion for teacher scheduling" yields **Title:** Notion

- [X] T009 [US2] In the `start` proposal block of .highway/skills/highway-implementation/SKILL.md, add `**Title:** [Product title.]` as the first line after the proposal opening, and say in the `edit` bullet that an edit to the title is a supplied title
- [X] T010 [US2] In `identifier` of .highway/skills/highway-implementation/SKILL.md, replace `The implementation title is the architecture title unless the person supplied a title.` with `The implementation title is the product in the title of the decision this realization came from, unless the person supplied a title.`, then remove a leading "Adopt" without regard to case, take the text before `the first " for "`, capitalize its first letter, and keep every other word, so joined products and named mechanisms stay whole
- [X] T011 [US2] In the id comparison bullets of `identifier` in .highway/skills/highway-implementation/SKILL.md, change the reuse bullet to `The same title already has that id under this architecture: use the existing record.`

**Checkpoint**: The implementation title rules for US2 are present

---

## Phase 5: User Story 3 - Keep a title clear when the product is not one name (Priority: P1)

**Goal**: Joined products, named mechanisms, a missing " for ", an empty purpose, and a taken product title each yield a clear title

**Independent Test**: Use the worked examples in data-model.md. "Time Machine and Google Drive" and "Local MacBook design apps" stay whole. A second "Notion" under a different architecture becomes "Notion for [purpose]"

- [X] T012 [US3] In `identifier` of .highway/skills/highway-implementation/SKILL.md, add `The same title already has that id under a different architecture: the title becomes "[Product] for [purpose]". Derive the id again.`, then keep `The id is taken for a different title: go to `title`.`
- [X] T013 [US3] In `identifier` of .highway/skills/highway-implementation/SKILL.md, add the no-" for " case: use the decision's Selected Option name when it appears in the title, otherwise the title without a leading "Adopt"
- [X] T014 [US3] In `identifier` of .highway/skills/highway-architecture/SKILL.md, add the no-" for " case, which removes the Selected Option name when it appears in the title, and add: when the title would be empty or would name a product, `ask for a purpose title` before deriving the id, and write nothing until one is given

**Checkpoint**: `bash .highway/tools/tests/record-purpose-titles.test.sh` passes once Polish T015 sets the versions

---

## Phase 6: Polish and Cross-Cutting Concerns

- [X] T015 Bump `version: 4.0.0` to `version: 5.0.0` in .highway/skills/highway-architecture/SKILL.md and .highway/skills/highway-implementation/SKILL.md
- [X] T016 Add Verification bullets to .highway/skills/highway-architecture/SKILL.md (the title is the decision's purpose, shown on the proposal, and never names a product) and .highway/skills/highway-implementation/SKILL.md (the title is the product, shown on the proposal, and gains "for" and the purpose only when taken under a different architecture)
- [X] T017 Run `bash .highway/tools/tests/record-purpose-titles.test.sh` and confirm `PASS: record purpose and product titles`
- [X] T018 Measure the word count of each changed `###` section in .highway/skills/highway-architecture/SKILL.md and .highway/skills/highway-implementation/SKILL.md and confirm each is at or under 400 words (P7.5), counting MUST rules to confirm 12 or fewer (P7.4)
- [X] T019 With all permissions, run `bash .highway/tools/validate-skill.sh` on .highway/skills/highway-architecture, .highway/skills/highway-implementation, .highway/skills/highway-adr, and .highway/skills/highway-onboarding (D8.1), and `bash .highway/tools/validate-library.sh` on both templates
- [X] T020 With all permissions, run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh` (D4.5–D4.7)
- [X] T021 Confirm no changed shipped file references `.specify/` or `specs/` (D1.1, D1.2) and that .highway/skills/highway-onboarding/SKILL.md still defers titles to `highway-architecture` and `highway-implementation` (FR-011)
- [X] T022 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and confirm `0 failed` and `EXIT:0` (D3.2)
- [X] T023 Walk the manual scenarios in specs/204-record-purpose-titles/quickstart.md against the skill text

---

## Dependencies and Execution Order

### Phase Dependencies

- Setup runs first
- Foundational depends on Setup. T003 depends on T002. T004 and T005 can run in parallel after T003
- US1, US2, and US3 depend on Foundational
- US3 edits the same two skills as US1 and US2, so it follows them
- Polish depends on all stories

### User Story Dependencies

- US1 and US2 are independent. US1 edits only highway-architecture and US2 edits only highway-implementation
- US3 extends both `identifier` sections and follows US1 and US2

### Parallel Opportunities

- T004 and T005 edit different templates
- Phase 3 (US1) and Phase 4 (US2) edit different skills and can run side by side
- Do not parallelize two tasks that edit the same skill

---

## Parallel Example: User Story 1 and User Story 2

```text
Task: "T006–T008 Architecture title rules in .highway/skills/highway-architecture/SKILL.md"
Task: "T009–T011 Implementation title rules in .highway/skills/highway-implementation/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and read the architecture proposal. It shows **Title:** Teacher scheduling for the Notion decision

### Incremental Delivery

1. User Story 1 titles architectures by purpose
2. User Story 2 titles implementations by product
3. User Story 3 handles joined products, mechanisms, a missing " for ", an empty purpose, and a taken product title
4. Polish bumps versions, validates, regenerates, and requires a green suite

The new test passes only after all three stories and the version bumps.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Existing records are not converted (FR-012)
- Do not commit unless asked
