# Implementation Plan: Clarification Contract Consistency

**Branch**: `074-clarification-contract-consistency` | **Date**: 2026-09-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/074-clarification-contract-consistency/spec.md`

## Summary

Align the Clarification skill, clarification-record template, generated copies, and contract tests
around the separated `evidence-gap`/`Unknown` and `conflict`/`Escalate for Decision` states. The
implementation will update canonical Markdown inputs, add explicit validation and fixture coverage,
regenerate derived catalogs/adapters, and verify that no retired combined state or contradictory
Evidence Sources structure remains.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2.57-compatible shell scripts; Markdown contract artifacts

**Primary Dependencies**: Existing `.highway/tools/` validators, generators, and Bash contract tests

**Storage**: Repository files only; no runtime persistence changes

**Testing**: `.highway/tools/tests/highway-clarify.test.sh`, `output-template.test.sh`, generator tests, validators, and `run-all.sh`

**Target Platform**: macOS and distributed Highway trees using the declared shell/toolchain

**Project Type**: Distributed Markdown skill suite with Bash validation and generation tooling

**Performance Goals**: Preserve existing bounded contract-test and generator execution behavior; no new runtime path

**Constraints**: Bash 3.2 compatibility, ASCII-first edits, no new dependencies, no partial writes, source immutability, and generated-artifact synchronization

**Scale/Scope**: One canonical skill, one shared output template, their generated adapters/catalogs, and focused/full contract tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

* **D1.5 / D5.3 PASS**: The plan names the governing rules for changes to canonical skill/library
  artifacts and lists every contract surface changed by this feature.
* **D2.1-D2.4 PASS**: No new scripts or runtime dependencies are introduced; existing Bash/toolchain
  and platform constraints remain in force.
* **D3.1-D3.4 PASS**: The implementation will begin and end with the existing suite, add/amend focused
  tests for the behavioral contract, and evaluate generated/source/disposable fixture classes.
* **D4.1-D4.7 PASS**: Canonical inputs are changed first, then declared catalogs/adapters are regenerated
  and compared for correspondence; generated files are not hand-edited.
* **D6.1-D6.2 PASS**: The Clarification skill, shared template, tests, and generated copies are updated
  together, and all plan references resolve within the repository.
* **D8.1 PASS**: The dependent `highway-clarify` skill will be revalidated against the changed shared
  output template.
* **P1.5, P7.3, P9.1 PASS**: The Clarification skill's dependencies are declared, its normative contract
  remains actionable, and it cites the complete shared clarification-record output template.

No constitution violations or complexity exceptions are expected.

## Project Structure

### Documentation (this feature)

```text
specs/074-clarification-contract-consistency/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── clarification-contract-consistency.md
├── checklists/requirements.md
└── tasks.md             # Created by /speckit-tasks
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
.highway/
├── skills/highway-clarify/SKILL.md                 # canonical skill
├── library/templates/output/clarification-record.md # canonical record contract
├── catalog/                                         # generated catalogs
└── tools/tests/                                     # focused and suite tests
.github/skills/highway-clarify/SKILL.md              # generated adapter
.claude/skills/highway-clarify/SKILL.md              # generated adapter
.cursor/rules/highway-clarify.mdc                   # generated adapter
specs/074-clarification-contract-consistency/       # development design artifacts
```

**Structure Decision**: Keep the existing canonical-input and generated-output boundaries. The
Clarification skill and shared output template are edited in `.highway/`; focused tests assert the
contract and disposable behavior; catalogs and agent adapters are regenerated from canonical inputs;
Feature 074 design artifacts remain under `specs/074-clarification-contract-consistency/`.

## Complexity Tracking

No violations. No additional abstraction, dependency, service, or persistence layer is introduced.
