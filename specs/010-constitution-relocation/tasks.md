---

description: "Task list template for feature implementation"
---

# Tasks: Constitution Relocation and Shipped-Tree Independence

**Input**: Design documents from `/specs/010-constitution-relocation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md (all present)

**Tests**: No new automated coverage was requested beyond the check this feature exists to add.
That check is a deliverable, not optional scaffolding, and appears as User Story 3.

**Organization**: Tasks are grouped by user story (spec.md P1/P1/P2) to enable independent
implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Every task names its exact file path

## Path Conventions

Single project. All paths are repository-root-relative. `.highway/` is the framework root,
distinct from the true repository root; agent adapter targets (`.github/`, `.claude/`, `.cursor/`)
live at the true repository root.

**Provenance form** (contracts/shipped-tree-independence-contract.md): every design-record
citation becomes `feature NNN (short-name)`, for example
`per feature 003 (constitution enforcement)`. No path, no link. The form is identical in every
file.

**Scope note**: Phase 3 fully cleans each file it opens, including that file's design-record
citations, rather than editing the same file again in Phase 4. Both stories remain independently
testable; Phase 4's scope is the files Phase 3 does not touch.

---

## Phase 1: Setup

**Purpose**: Establish a known-good baseline before any change.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and confirm every test
      passes, so any later failure is attributable to this feature.

**Checkpoint**: Baseline confirmed green.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish the new location. Every subsequent task reads or writes it.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T002 Create `.highway/governance/` and move the constitution:
      `git mv .specify/memory/constitution.md .highway/governance/constitution.md`. If the file is
      untracked, use `mv`. Rule text, rule IDs, Observables, and tier tags are byte-unchanged.
      Per contracts/governance-location-contract.md and research.md R1.
- [X] T003 In `.highway/governance/constitution.md`, rewrite the three development-path citations
      inside the Sync Impact Report HTML comment (`.specify/templates/`, `specs/001-…`,
      `specs/002-…`) to the provenance form. Do not increment the constitution's version: no
      Observable changes and the edited text states no rule. Per research.md R7.
- [X] T004 Write a placeholder at `.specify/memory/constitution.md` recording that the Highway
      Skills Constitution moved to `.highway/governance/constitution.md` and that
      development-process rules will replace this file. It MUST state no rule and define no rule
      id. Per contracts/governance-location-contract.md.

**Checkpoint**: `.highway/governance/constitution.md` exists with unchanged rule text;
`.specify/memory/constitution.md` holds a rule-free placeholder. The suite is expected to be red
until Phase 3 completes.

---

## Phase 3: User Story 1 — The governance document ships with the framework it governs (Priority: P1)

**Goal**: Every consumer resolves the constitution at its new location, anchored at the framework
root, so validation succeeds in a tree with no development directories.

**Independent Test**: Copy `.highway/` alone into an empty directory and run the skill validator;
it completes rather than failing to locate its governance document.

- [X] T005 [US1] In `.highway/tools/lib/constitution.sh`, change the fallback branch of
      `con_file()` from `$repo_root/.specify/memory/constitution.md` to
      `$highway_root/governance/constitution.md`, renaming the parameter accordingly. Leave the
      `CONSTITUTION_FILE` override and its precedence unchanged. Also rewrite this file's
      design-record citation to the provenance form. Per research.md R2.
- [X] T006 [US1] In `.highway/tools/validate-skill.sh`, change `con_file "$REPO_ROOT"` to
      `con_file "$HIGHWAY_ROOT"`, remove the now-unused `REPO_ROOT` assignment, update the header
      comment's constitution location, and rewrite its design-record citation to the provenance
      form (depends on T005).
- [X] T007 [US1] Apply the same four changes to `.highway/tools/validate-library.sh`: `con_file`
      argument, unused `REPO_ROOT` removal, header comment location, design-record citation
      (depends on T005).
- [X] T008 [P] [US1] In `.highway/tools/tests/authoring-standard.test.sh`, change `CONSTITUTION`
      to `"$HIGHWAY_ROOT/governance/constitution.md"` and remove `REPO_ROOT` if it becomes unused.
- [X] T009 [P] [US1] Apply the same change to
      `.highway/tools/tests/constitution-inventory.test.sh`.
- [X] T010 [P] [US1] Apply the same change to `.highway/tools/tests/coverage-summary.test.sh`.
- [X] T011 [P] [US1] In `.highway/skills/_authoring-standard.md`, retarget the constitution link
      from `../../.specify/memory/constitution.md` to `../governance/constitution.md` and update
      the surrounding sentence to name the new location.
- [X] T012 [US1] In `.highway/tools/README.md`, update the constitution location it documents, and
      rewrite all five design-record links to the provenance form.
- [X] T013 [US1] Run `.highway/tools/tests/run-all.sh` and confirm it passes. Then execute
      quickstart.md Scenario 3: copy `.highway/` alone to a temporary directory and confirm the
      validator exits 0 with no development directories present.

**Checkpoint**: The constitution resolves without an override, validation succeeds in a
development-directory-free tree, and the suite is green again.

---

## Phase 4: User Story 2 — No distributed file points at something the user does not have (Priority: P1)

**Goal**: Zero references to a development-only location across the distributed path set, with
design-record provenance preserved in name-only form.

**Independent Test**: Search every distributed file for the prohibited tokens and find none;
follow every cross-reference and confirm each resolves inside the distributed tree.

- [X] T014 [P] [US2] Rewrite the three design-record links in `.highway/catalog/README.md` to the
      provenance form.
- [X] T015 [P] [US2] Rewrite the three design-record citations in the header comment of
      `.highway/tools/generate-catalog.sh` to the provenance form.
- [X] T016 [P] [US2] Rewrite the two design-record citations in the header comment of
      `.highway/tools/generate-agent-adapters.sh` to the provenance form.
- [X] T017 [P] [US2] Rewrite the design-record citation in the header comment of
      `.highway/tools/generate-library-catalog.sh` to the provenance form.
- [X] T018 [P] [US2] Rewrite the single design-record citation in each of
      `.highway/tools/lib/body-scan.sh`, `.highway/tools/lib/dependency-check.sh`, and
      `.highway/tools/lib/schema-validate.sh` to the provenance form.
- [X] T019 [P] [US2] Rewrite the design-record citation in
      `.highway/tools/tests/dependency-check.test.sh` to the provenance form.
- [X] T020 [P] [US2] Rewrite the design-record citation in
      `.highway/tools/tests/generate-agent-adapters.test.sh` to the provenance form.
- [X] T021 [P] [US2] Rewrite the design-record citation in
      `.highway/tools/tests/new-agent-extensibility.test.sh` to the provenance form.
- [X] T022 [P] [US2] Rewrite the design-record citation in
      `.highway/tools/tests/validate-library.test.sh` to the provenance form.
- [X] T023 [US2] In `.highway/skills/highway-help/SKILL.md`, replace the contract link in
      `## Outputs` and the quickstart link in `## Verification` with the provenance form, and
      change `metadata.version` from `3.0.0` to `3.0.1`. Change no declared input, no output
      field, and no verification criterion. Per data-model.md and research.md R6 (PATCH).
- [X] T024 [US2] Run `.highway/tools/generate-catalog.sh` and confirm `.highway/catalog/index.json`
      and `index.md` record version `3.0.1` (depends on T023 and on Phase 3, since the generator
      validates every skill first).
- [X] T025 [US2] Run `.highway/tools/generate-agent-adapters.sh` and confirm all three adapters and
      `.highway/tools/.adapter-manifest` are regenerated, with no adapter retaining a
      development-path reference (depends on T023, T024).
- [X] T026 [US2] Confirm the provenance form is byte-consistent across every file changed in
      Phases 2–4: `grep -rn "feature [0-9][0-9][0-9] (" .highway/` and check every hit uses the
      same shape. Satisfies FR-007a.
- [X] T027 [US2] Run `.highway/tools/tests/run-all.sh` and confirm it passes.

**Checkpoint**: Searching the distributed path set for `.specify/` or `specs/` returns nothing,
and every generated artifact is current.

---

## Phase 5: User Story 3 — The boundary cannot be crossed again without failing (Priority: P2)

**Goal**: An automated check makes the boundary self-enforcing, and proves itself capable of
failing.

**Independent Test**: Add a development-only reference to a distributed file, run the suite, and
confirm it fails and names that file.

- [X] T028 [US3] Create `.highway/tools/tests/shipped-tree-independence.test.sh`. It declares the
      distributed path set once (`.highway/`, `.github/skills/highway-*`,
      `.claude/skills/highway-*`, `.cursor/rules/highway-*`), searches every file in that set for
      `.specify/` and `specs/`, excludes its own filename, reports each violation as
      `<file>:<line>: <text>`, and exits non-zero when any is found. It scans fixtures with no
      exemption. It ends with a self-probe that seeds a violation, confirms detection, and removes
      it. Bash 3.2 compatible; no GNU-only flags. Model the structure on
      `.highway/tools/tests/path-integrity.test.sh`. Per
      contracts/shipped-tree-independence-contract.md and research.md R5, R8.
- [X] T029 [US3] Execute quickstart.md Scenarios 7 and 8: confirm the check fails and names the
      file when a violation is seeded into `.highway/catalog/README.md`, that the file is restored
      afterwards, and that the check passes while `governance-plan.md`, `specs/`, and
      `.specify/memory/constitution.md` all still contain the prohibited tokens (depends on T028).

**Checkpoint**: The check passes on the clean tree, fails on a seeded violation, and ignores
development artifacts.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Whole-feature validation.

- [X] T030 Run `.highway/tools/tests/run-all.sh` and confirm every test passes, including the new
      check, with no test removed or weakened.
- [X] T031 Re-run `.highway/tools/generate-catalog.sh` and
      `.highway/tools/generate-agent-adapters.sh` and confirm neither produces a diff, proving the
      generators were run after the source edits (quickstart.md Scenario 10).
- [X] T032 Execute quickstart.md Scenarios 1, 2, 4, 5, 6, 9, 11, and 12 and confirm each matches
      its stated expected result. Scenario 12 confirms the help skill's six-field output is
      unchanged except for the version, which is what makes the increment a PATCH.

**Checkpoint**: Feature complete; full regression green; every quickstart scenario verified.

---

## Dependencies

- **Phase 1** (T001) has no dependencies.
- **Phase 2** (T002–T004) depends on T001 and blocks every later task. T002 blocks T003 (the file
  must be at its new location before it is edited there). T004 is independent of T003.
- **Phase 3** (US1, T005–T013) depends on Phase 2. T005 blocks T006 and T007, which consume the
  changed resolution. T008–T011 are mutually parallel and independent of T005–T007. T012 is
  independent. T013 depends on all of T005–T012.
- **Phase 4** (US2, T014–T027) depends on Phase 3, because T024 and T025 invoke generators that
  validate every skill first, and validation must already resolve the constitution. T014–T022 are
  mutually parallel. T023 blocks T024, which blocks T025. T026 depends on T014–T023. T027 depends
  on all of Phase 4.
- **Phase 5** (US3, T028–T029) depends on Phase 4 being complete. Adding the check earlier would
  make the suite red for reasons the feature has not yet fixed, and would conceal genuine
  regressions during Phases 3 and 4. T028 blocks T029.
- **Phase 6** (T030–T032) depends on all prior phases.

### Ordering hazards

- **T024/T025 before Phase 3 completes** would fail: both generators run `validate-skill.sh`
  against every skill and abort on any failure, and the validator cannot resolve the constitution
  until T005–T007 land.
- **T025 before T023** would regenerate adapters from an unedited source, leaving the development
  path references in all three agent trees while the source appears clean.
- **T028 before Phase 4 completes** would produce a red suite for 34 known violations, making a
  genuine regression indistinguishable from expected noise.
- **Hand-editing an adapter** instead of regenerating is refused by the generator, which compares
  each target against its recorded hash.

## Parallel Execution Examples

**Phase 3** — after T005 lands, four independent edits:

```text
T008  .highway/tools/tests/authoring-standard.test.sh
T009  .highway/tools/tests/constitution-inventory.test.sh
T010  .highway/tools/tests/coverage-summary.test.sh
T011  .highway/skills/_authoring-standard.md
```

**Phase 4** — nine independent files, no shared state:

```text
T014  .highway/catalog/README.md
T015  .highway/tools/generate-catalog.sh
T016  .highway/tools/generate-agent-adapters.sh
T017  .highway/tools/generate-library-catalog.sh
T018  .highway/tools/lib/{body-scan,dependency-check,schema-validate}.sh
T019  .highway/tools/tests/dependency-check.test.sh
T020  .highway/tools/tests/generate-agent-adapters.test.sh
T021  .highway/tools/tests/new-agent-extensibility.test.sh
T022  .highway/tools/tests/validate-library.test.sh
```

## Implementation Strategy

**MVP is Phase 2 plus Phase 3.** At that point the defect that motivated the feature is fixed: the
governance document ships with the tooling that reads it, and validation succeeds in a tree
without development directories. The feature is deliverable there if interrupted.

**Phase 4 completes the user-visible surface**, removing the references that would render as
dangling links in a distributed copy — including the two in the help skill, which are duplicated
into three agent trees.

**Phase 5 makes the outcome durable.** It is last by design: it delivers no value until the
violations it detects have been removed, and it is the only phase whose value is entirely about
preventing future regressions rather than fixing present defects.

**Next phase after this feature**: ratify the development constitution with
`/speckit.constitution`, replacing the placeholder written in T004. See `governance-plan.md`
Phase 2.
