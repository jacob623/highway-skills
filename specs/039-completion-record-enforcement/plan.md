# Implementation Plan: Completion Record Enforcement

**Branch**: `039-completion-record-enforcement` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/039-completion-record-enforcement/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Make D7.2 enforceable across every completed feature from 021 onward, plus Feature 020. The
implementation will standardize coverage records on `coverage.md` with `Requirement`, `Outcome`,
and `Evidence` columns; make missing or malformed records fail the completion test; back-fill and
normalize the in-scope records; record corrective relationships; reconcile feature directory
identities; and amend the Layer 0 constitution with D3.7, D3.8, D5.5, D7.4, D7.5, plus the narrow
D5.1 exceptions for the coverage record and for relocating a completed spec directory.

Features 001 through 019 are deliberately out of scope and owned by Feature 040 under Phase 13.
This feature defines the `historical` outcome and bounds it to Features 001-020; Feature 040 is its
only consumer.

Two obligations are deliberately wider than the completion check alone. D3.7 reaches **every**
registered `[auto]` check — twelve once D5.5 and D7.4 are added — so each must declare its artifact
classes and prove a seeded defect fails one artifact of each class. D3.8 requires every test to
declare its instrument class, not only that coverage rows cite the right class. Both are measured
against the repository before being enabled, per D3.4; any rule that cannot reach conformance in
this change is recorded as enabled later rather than tagged as enforced.

## Technical Context

**Language/Version**: Markdown governance artifacts; Bash 3.2-compatible test scripts

**Primary Dependencies**: Existing `.highway/tools/tests/` harness, Spec Kit records, and standard shell utilities

**Storage**: Markdown coverage records and disposable test fixtures; no new persistent runtime storage

**Testing**: `completion-coverage.test.sh`, `spec-record.test.sh`, focused fixture assertions, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and Linux-compatible Bash environments

**Project Type**: Markdown-based governance repository with Bash validation tooling

**Performance Goals**: Complete local coverage validation without network access; no latency threshold is introduced

**Constraints**: Preserve completed substantive spec records; permit only the declared coverage-record exception; use existing Bash 3.2-compatible utilities; do not modify the Skills Constitution or Experience Standard

**Scale/Scope**: Completed feature directories from 021 onward plus Feature 020, every registered `[auto]` check, the feature identity check, and the Development Constitution. Features 001-019 are Feature 040's scope.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change touches `specs/`, `.highway/tools/tests/`, `.specify/memory/constitution.md`, and
coverage records under completed feature directories. It does not touch shipped paths, skills,
libraries, generators, or generated adapters.

| Gate | Trigger | Verdict | Evidence / action |
|---|---|---|---|
| Packaging Gate | No shipped path is modified | N/A | D1.1, D1.2, and D6.2 are not triggered. |
| Toolchain Gate | `.highway/tools/tests/completion-coverage.test.sh` is modified | PASS | Preserve Bash 3.2 compatibility and use only the declared toolchain. |
| Generator Gate | No `generate-*.sh` script is modified | N/A | No generator is changed. |
| Correspondence Gate | No skill, library, or generator input is modified | N/A | Generated artifacts are outside scope. |
| Validation Gate | The completion validation check is modified | PASS | Evaluate existing fixtures before enabling; retain and extend failure assertions under D3.4 and D3.5. D3.7 and D3.8 are measured against the tree before being enabled. |
| Spec Record Gate | New Feature 039 directory, back-filled coverage records, and the Feature 036 relocation | PASS | Feature 039 is sequential. Completed substantive file content stays immutable; the amended D5.1 Observable is what permits the coverage record and the directory relocation, and both are enabled in this same change. |
| Skill Content Gate | No `.highway/skills/` or `.highway/library/` file is modified | N/A | No Highway Skills Constitution check is required. |

The proposed D3.7, D3.8, D5.5, D7.4, and D7.5 rules are the feature's intended constitution
amendment; they are not pre-existing gate failures. No violation or complexity exception is
required.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/tools/tests/
├── completion-coverage.test.sh       # Enforces coverage records and seeded failures
├── spec-record.test.sh                # Verifies feature directory identity and numbering
└── run-all.sh                         # Full validation entry point
.specify/memory/
└── constitution.md                    # Layer 0 rules and Enforcement Map
specs/
├── 001-* through 038-*                # Historical feature records and back-filled coverage
└── 039-completion-record-enforcement/
  ├── spec.md
  ├── plan.md
  ├── research.md
  ├── data-model.md
  ├── quickstart.md
  ├── contracts/
  └── tasks.md                        # Created by /speckit-tasks
```

**Structure Decision**: Keep the implementation in the existing Layer 0 validation and spec
record paths. Coverage records are development artifacts; the completion test reads them directly,
and no new service, package, runtime dependency, or shipped content is introduced.

## Contracts

- [Coverage record contract](contracts/coverage-record-contract.md) defines the canonical
  `coverage.md` path, columns, outcomes, artifact resolution, and corrective evidence.
- [Constitution amendment contract](contracts/constitution-amendment-contract.md) defines the
  Layer 0 rule additions, narrow D5.1 exceptions, and pre-enable obligations.

## Requirement Traceability

FR-001 through FR-011 map to T005-T025 and the focused completion check; FR-012 through FR-014
map to T033-T044 and the instrument/probe declarations; FR-015 through FR-018 map to T009-T011
and T045-T049; FR-019 through FR-024 map to T033-T044 and the amended Development Constitution;
FR-025 through FR-027 map to T005, T017, T023, T025, and the final full-suite run T054.

## Complexity Tracking

No violations.
