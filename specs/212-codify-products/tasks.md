---

description: "Task list for codify products"
---

# Tasks: Codify Products

**Input**: Design documents from `/specs/212-codify-products/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and replaced assertions move with D3.5 reasons in research R8.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and copy the `Summary:` and `EXIT:` lines into specs/212-codify-products/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/codify-products.test.sh (mode 644, static-document-contract header, PASS line `PASS: codify decides the product from the catalogs`). It reads .highway/skills/highway-codify/SKILL.md, .highway/skills/highway-adr/SKILL.md, and the five templates in plan.md. It requires the step order `### align`, `### project`, `### layout`, `### propose`, `### revise`, `### identifier`, and `### write`, `### index`, `### code`. It requires the `project` lines in contracts/product-steps.md, `Do not open a product folder.`, `**Proposed project:**`, `**Rationale:**`, `No arrow leaves a target.`, `.highway/features/`, `.highway/metadata.md`, `code/integrations.md`, `An edit that changes the proposed project uses that folder.`, the catalog columns `ID`, `Folder`, `Title`, `Summary`, `Implementations`, `Features`, `Status`, the integrations columns `From`, `To`, `Kind`, `Summary`, `Status`, codify `version: 10.0.0`, adr `version: 6.0.0`, catalog `version: 3.0.0`, record `version: 8.0.0`, tasks `version: 5.0.0`, and metadata and integrations `version: 1.0.0`. It rejects `code/[ID]/`, `Automation Path`, and `read \`codify.md\` at that row`. It counts every `###` section of highway-codify and fails when any exceeds 400 words.
- [X] T003 Run the new test, observe it fail, and save its output to specs/212-codify-products/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - A product folder can become a repo (Priority: P1) 🎯 MVP

**Goal**: A product is `code/<folder>/` with `.highway/metadata.md` and numbered feature directories

**Independent Test**: The templates and the `write`, `code`, `catalog`, and `close` steps name `code/<folder>/`, `.highway/metadata.md`, and `.highway/features/<number>-<action>/`. No shipped skill names `code/[ID]/`.

- [X] T004 [P] [US1] Create .highway/library/templates/output/codify-metadata.md version 1.0.0 with frontmatter `id: CDYXXXXXXXX`, per data-model.md Metadata. Say it is written once at `code/<folder>/.highway/metadata.md`, and that this product `.highway` holds `metadata.md` and `features/` only
- [X] T005 [P] [US1] Update .highway/library/templates/output/codify-catalog.md to version 3.0.0: columns ID, Folder, Title, Summary, Implementations, Features, Status; one row per product; Folder unique including removed rows; the Features gate from data-model.md; a removed row keeps its folder and recorded feature titles taken
- [X] T006 [P] [US1] Update .highway/library/templates/output/codify-record.md to version 8.0.0. Its path is `code/<folder>/.highway/features/<number>-<action>/codify.md`, frontmatter `id` is the product CDY, and the body adds **Proposed project:** and **Rationale:** after Tasks
- [X] T007 [P] [US1] Update .highway/library/templates/output/codify-tasks.md to version 5.0.0. The list sits beside `codify.md` in the feature directory, and `Files:` paths are relative to the product folder `code/<folder>/`. `README.md` is at the product folder root
- [X] T008 [US1] In .highway/skills/highway-codify/SKILL.md, update Inputs, Outputs, Entry step 5, `catalog`, `code`, and `close` to name `code/<folder>/`, `code/<folder>/README.md`, `code/<folder>/.highway/metadata.md`, and `code/<folder>/.highway/features/<number>-<action>/codify.md` and `codify-tasks.md`. Add `codify-metadata.md` and `codify-integrations.md` to Inputs and Outputs. `catalog` lists products by Title and reads progress from the open feature
- [X] T009 [US1] Rewrite `identifier` in .highway/skills/highway-codify/SKILL.md per research R9: derive the CDY from the product title, keep a joined product's CDY, reuse a matching product title, send a different title with that id to `title`, resume or close an existing action title in the joined product, and send a free id and a new action to `write`
- [X] T010 [US1] Rewrite `write` in .highway/skills/highway-codify/SKILL.md per contracts/product-steps.md: write `.highway/metadata.md` once, the next numbered feature directory, and the catalog row together; Folder unique including removed rows; one row per product; append Implementations; keep the earlier feature directories

---

## Phase 4: User Story 2 - The catalogs decide without opening the product (Priority: P1)

**Goal**: Dedup and join read `code/code.md` and `code/integrations.md` only, and Features stays a decision index

**Independent Test**: `codified` and `project` say `Do not open a product folder.` `write` applies the Features gate.

- [X] T011 [US2] Replace `codified` in .highway/skills/highway-codify/SKILL.md with the three lines in contracts/product-steps.md
- [X] T012 [US2] Add `### project` from contracts/product-steps.md to .highway/skills/highway-codify/SKILL.md between `align` and `layout`. Route `align` to `project`, and `project` to `layout`. Add `project` to the order sentence in Procedure
- [X] T013 [US2] Add `### index` after `write` with the catalog row and the Features gate from contracts/product-steps.md in .highway/skills/highway-codify/SKILL.md

---

## Phase 5: User Story 3 - An accepted proposal records its integration (Priority: P1)

**Goal**: Accepting a proposal that includes a pair writes one integrations row, and a repeated pair writes none

**Independent Test**: `code/integrations.md` is written by `write` without a second question, and a From, To, and Kind already accepted is not written again

- [X] T014 [P] [US3] Create .highway/library/templates/output/codify-integrations.md version 1.0.0 with the From, To, Kind, Summary, Status table at `code/integrations.md`, per data-model.md Integration. Kind is `composition` or `capability`. One row per From, To, and Kind. An empty baseline is `Version: 1.0.0` and the header
- [X] T015 [US3] In `index` of .highway/skills/highway-codify/SKILL.md, write the integrations row when the accepted proposal includes a pair that is not already accepted. Ask nothing more

---

## Phase 6: User Story 4 - The person sees why, and can change the project (Priority: P1)

**Goal**: `propose` shows the project and rationale, keeps every diagram rule, and `revise` handles the response

**Independent Test**: `propose` contains `No arrow leaves a target.`, `**Proposed project:**`, and `**Rationale:**`, then goes to `revise`. `revise` holds every edit line, plus the project edit line

- [X] T016 [US4] In .highway/skills/highway-codify/SKILL.md, add **Proposed project:** and **Rationale:** to `propose` before the closing question, then end `propose` with `Go to \`revise\`.`
- [X] T017 [US4] Move the `edit`, `accept`, `unknown`, `question`, and `decline` lines from `propose` into a new `### revise` step after `propose` in .highway/skills/highway-codify/SKILL.md. Change `Stay on \`propose\`` to `Stay on \`revise\``. Add `An edit that changes the proposed project uses that folder.` Add `revise` to the order sentence
- [X] T018 [US4] Update Verification and Error Handling in .highway/skills/highway-codify/SKILL.md for the product folder, the catalog-only decision, the Features gate, the single integrations row, the project and rationale lines, the standard override, and the person's edit. Set `metadata.version` to 10.0.0
- [X] T019 [US4] In .highway/skills/highway-adr/SKILL.md, update the Inputs line and span coverage per research R10. Set `metadata.version` to 6.0.0

---

## Phase 7: Polish

- [X] T020 Run the word count from plan.md on .highway/skills/highway-codify/SKILL.md and confirm every `###` section is at or under 400 words
- [X] T021 [P] Move the pins and replace the assertions in research R8, across codify-file-layout, codify-config-skill, codify-platform-catalog, codify-closing-guide, codify-write-refactor, propose-edit-lines, adr-span-progression, and codify-proposal-tasks under .highway/tools/tests/. Keep the onboarding pin in codify-platform-catalog.test.sh
- [X] T022 Run `validate-skill.sh` on highway-codify and highway-adr, and `validate-library.sh` on the five templates (D8.1)
- [X] T023 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T024 Run the full suite in the background, copy `Summary:` and `EXIT:` into specs/212-codify-products/final.txt, and require 0 failed (D3.2)
- [X] T025 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T007 and T014 edit separate templates and can run together
- T008 through T013 and T015 through T018 edit highway-codify, in task order
- T019 edits highway-adr and can run beside any highway-codify task
- T021 follows T018 and T019, because the pins name the new versions
- Phase 7 depends on all four stories

## Parallel Example

```text
T004 metadata, T005 catalog, T006 record, T007 tasks, T014 integrations
T019 highway-adr beside T016 propose
```

## Implementation Strategy

The MVP is US1: a product folder with metadata and numbered features. US2 decides join or start from the catalogs. US3 records the integration on acceptance. US4 shows the project and rationale and lets the person change it. The suite runs once at the start and once at the end.
