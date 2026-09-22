# Implementation Plan: Clarification Catalog (Phase 1)

**Branch**: `066-clarification-catalog` | **Date**: 2026-09-22 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/066-clarification-catalog/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add a shared Clarification catalog output template and extend `highway-clarify` to maintain
`clarifications/clarifications.md` during successful Generate and Update operations. The catalog
will index the existing `CLAR-<ARTIFACT-ID>` identity, artifact ID, supported artifact type, and
status; it will be validated, deduplicated, deterministically ordered, and written only after the
clarification artifact succeeds. Discovery and clarification analysis behavior remain unchanged.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts; Bash 3.2.57 validation scripts

**Primary Dependencies**: Existing `highway-clarify` contract, shared output templates, and repository validation suite

**Storage**: Repository Markdown files under `clarifications/` and `.highway/library/templates/output/`

**Testing**: Focused `.highway/tools/tests/highway-clarify.test.sh` and output-template checks, followed by `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU-like shell environments supported by the repository

**Project Type**: Repository-distributed agent skill suite with Markdown contracts and shell validation

**Performance Goals**: Catalog maintenance completes as one local repository operation for the bounded clarification inventory; no network or timestamp-dependent work

**Constraints**: No new runtime dependency; exact uppercase six-digit identifiers; supported types `REQ`, `DISC`, `ADR`, `RA`; supported statuses `not-started`, `in-progress`, `complete`, `blocked`; preserve bytes on validation or write failure; deterministic ordering by artifact type then artifact ID

**Scale/Scope**: One catalog per repository, one row per clarification artifact, and Phase 1 changes limited to the Clarify skill, its shared catalog template, focused validation, generated adapters, and feature design artifacts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The change adds shipped files under `.highway/`; packaged-tree validation and path checks are required in final validation. |
| Toolchain Gate (D2.1-D2.4) | PASS | Any focused test additions remain Bash 3.2.57-compatible and use the declared toolchain only. |
| Generator Gate (D4.1-D4.4) | N/A | No `generate-*.sh` script is changed. |
| Correspondence Gate (D4.5-D4.7) | PASS | `highway-clarify` and a shared library template are generator inputs; catalog and adapter correspondence must be regenerated and checked. |
| Validation Gate (D3.4-D3.5) | PASS | New or amended focused checks must be evaluated against existing fixtures and must not weaken assertions. |

### Skill content gate

| Rule | Verdict | Evidence |
|---|---|---|
| P9.1 | PASS | `highway-clarify` will cite `.highway/library/templates/output/clarification-catalog.md` as the complete catalog structure and will retain behavior outside that structure. |
| P8.3/P8.4 | PASS | The skill retains a Verification section with named validation commands and catalog checks. |
| P6.1/P6.6 | PASS | Catalog validation, ordering, uniqueness, and transaction decisions are explicit and deterministic. |
| P5.1-P5.5 | PASS | Catalog validation and write failures have explicit abort/no-write paths. |

No gate is unresolved; no complexity exception is required.

## Implementation Evidence

- The catalog template and `highway-clarify` contract are implemented and pass their focused validators.
- Focused `highway-clarify.test.sh` and `output-template.test.sh` checks pass.
- Generated adapters and library/Highway catalog indexes were regenerated; adapter correspondence passes.
- The required 200-second full-suite run reached 41 passed scripts and 0 reported failures before timing out in the final executable check. The final setup executable passes independently and after the preceding validator, so the timeout remains an unresolved full-suite execution issue rather than a recorded assertion failure.

## Project Structure

### Documentation (this feature)

```text
specs/066-clarification-catalog/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/
│   └── clarification-catalog-contract.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/
├── skills/highway-clarify/SKILL.md
├── library/templates/output/clarification-catalog.md
├── tools/tests/highway-clarify.test.sh
└── tools/tests/output-template.test.sh
specs/066-clarification-catalog/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/clarification-catalog-contract.md
clarifications/
└── clarifications.md
```

**Structure Decision**: Extend the existing Markdown skill and shared-template surfaces in
`.highway/`, validate them with the existing Bash test harness, and document the catalog data
model and command contract in this feature directory. The user-owned catalog is created at the
repository-root `clarifications/clarifications.md` by the implemented workflow and is not a
development fixture.

## Complexity Tracking

No constitution violations.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
