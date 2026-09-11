# Implementation Plan: Historical Coverage Reconstruction

**Branch**: `040-historical-coverage-reconstruction` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/040-historical-coverage-reconstruction/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Create honest `coverage.md` records for the 18 newly targeted completed features 001, 002, and
004-019, while recognizing Feature 020's existing record as the nineteenth below-021 record.
Extend `completion-coverage.test.sh` to discover every completed feature from 001 onward, retain
Feature 039's schema and identity checks, and reject `historical` outside Features 001-020. The
implementation remains limited to Markdown records and the existing Bash 3.2-compatible test
harness; no constitution, Experience Standard, or substantive completed spec is changed.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown; Bash 3.2-compatible shell scripts

**Primary Dependencies**: Existing `.highway/tools/tests/` harness and standard shell utilities

**Storage**: Markdown coverage records and disposable test fixtures; no new persistent storage

**Testing**: `completion-coverage.test.sh` and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and Linux environments with Bash-compatible core utilities

**Project Type**: Markdown governance repository with shell validation tooling

**Performance Goals**: Complete local validation without network access or new runtime dependencies

**Constraints**: Preserve substantive completed specs; only add permitted coverage records; keep the
test script Bash 3.2-compatible; do not amend either shipping governance document

**Scale/Scope**: 18 new records, 309 historical requirement rows, Feature 020's existing record,
and the completion checker’s full completed-feature discovery scope

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change touches `specs/`, `.highway/tools/tests/`, and adds historical coverage records. It
does not touch `.highway/skills/`, `.highway/library/`, generators, adapters, or either shipping
governance document.

| Gate | Trigger | Verdict | Evidence / action |
|---|---|---|---|
| Packaging Gate | No shipped path is modified | N/A | D1.1, D1.2, and D6.2 are not triggered. |
| Toolchain Gate | The completion test is modified | PASS | Use only the declared Bash 3.2-compatible toolchain. |
| Generator Gate | No generator is modified | N/A | No generated artifact is in scope. |
| Correspondence Gate | No skill, library, or generator input is modified | N/A | No generated output requires regeneration. |
| Validation Gate | An existing validation test is widened | PASS | Preserve Feature 039 assertions and add failure probes for historical scope. |
| Spec Record Gate | New coverage records are added under completed specs | PASS | The Feature 039 coverage-record exception permits accounting records only; no substantive spec content changes. |
| Skill Content Gate | No skill or library file is modified | N/A | No Highway Skills Constitution check is required. |

No constitution rule or principle is added or amended, so there is no complexity exception.

## Project Structure

### Documentation (this feature)

```text
specs/040-historical-coverage-reconstruction/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
└── quickstart.md        # Phase 1 output
```

### Source Code (repository root)

```text
.highway/tools/tests/
├── completion-coverage.test.sh       # Expanded completed-feature coverage check
└── run-all.sh                        # Full validation entry point

specs/
├── 001-*, 002-*, 004-* through 019-*/
│   └── coverage.md                   # New historical records
├── 020-*/coverage.md                 # Existing record retained
└── 040-historical-coverage-reconstruction/
    ├── spec.md
    ├── plan.md
    ├── research.md
    ├── data-model.md
    └── quickstart.md
```

**Structure Decision**: Keep the implementation in the existing development-record and test
paths. The coverage checker reads feature-local Markdown records and uses disposable fixtures for
negative assertions; no application source tree or external contract is introduced.

## Phase 0: Research Summary

- Use the Feature 039 coverage parser and schema as the authoritative implementation pattern.
- Treat `historical` as a closed-range outcome for feature numbers 001-020.
- Discover completed feature directories from the filesystem and exclude incomplete Feature 003,
  rather than requiring a `tasks.md` filter that omits historical records.

## Phase 1: Design Summary

- Model one coverage record per target feature with one row per declared functional requirement.
- Keep evidence classification semantic: only current satisfying artifacts become `satisfied`,
  demonstrated later corrections become `deferred`, and all remaining rows become `historical`.
- Extend the existing completion check and its disposable fixture assertions; do not add a second
  enforcement mechanism.

## Constitution Check (Post-Design)

PASS. The design remains within the pre-design boundary: it adds only development-side Markdown
coverage records and extends the existing validation test. It adds no runtime dependency, shipped
artifact, generator output, constitution rule, Experience Standard rule, or substantive edit to a
completed spec. The Feature 039 coverage-record exception is sufficient for the new records, and
the existing Bash 3.2-compatible toolchain remains sufficient.

## Contracts

No `contracts/` artifact is needed. This feature changes an internal development check and local
Markdown records, not a public API, CLI command schema, or external integration.

## Complexity Tracking

No violations. The feature reuses the existing completion checker and Markdown record format.
