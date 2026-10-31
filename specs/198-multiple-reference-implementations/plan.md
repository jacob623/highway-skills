# Implementation Plan: Multiple Reference Implementations

**Branch**: `198-multiple-reference-implementations` | **Date**: 2026-10-29 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/198-multiple-reference-implementations/spec.md`

## Summary

One architecture can have many current implementations, and many current decisions can name that architecture. Discovery surfaces an existing implementation when an exact match already has one. A later decision for a different option asks whether it replaces the earlier decision or runs beside it, then closes with one next step: create the architecture, create the implementation, or name the implementation that already exists. The architecture and implementation records gain the conformance content from the spec.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: The output templates for the ADR, architecture, and implementation records and catalogs, and the `SKILL.md` sources of `highway-discovery`, `highway-adr`, `highway-architecture`, `highway-implementation`, and `highway-onboarding`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/validate-library.sh`

**Storage**: Decision, architecture, and implementation records and their catalogs. Existing files are not rewritten

**Testing**: Amend `.highway/tools/tests/adr-record-completeness.test.sh` and add one contract check, then `.highway/tools/tests/run-all.sh`. The amendment is recorded in `retirements.md`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target

**Constraints**: A decision selects a specific option. One decision names at most one architecture. The decision handoff does not contain an implementation entry. Match only by identifier, exact title, capability, objective, control, or operational expectation. Do not add an implementation plan, tasks, source code, infrastructure, deployment authorization, a clock timestamp, a product name on the architecture, a second copy of a decision statement, a capability identifier, or a viewpoint catalog. Do not change Controls or NFRs. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Six output templates. The discovery option list, the ADR proposal and close, the architecture and implementation writers, and onboarding's copies of those writers

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. D3.5 applies: two assertions in `adr-record-completeness.test.sh` are replaced, and the reason is recorded in `retirements.md`. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog, library-catalog, and adapter regeneration after the sources change.
- Skill Content Gate: PASS pending `validate-skill.sh` on the five skills and `validate-library.sh` on the six templates. D8.1 applies to every skill that cites a changed template.

Version bumps are MAJOR because a previously conforming record or flow no longer conforms:

| Source | From | To |
|---|---|---|
| `adr-record.md` | 2.0.0 | 3.0.0 |
| `adr-catalog.md` | 3.0.0 | 4.0.0 |
| `architecture-record.md` | 1.0.0 | 2.0.0 |
| `architecture-catalog.md` | 2.0.0 | 3.0.0 |
| `implementation-record.md` | 1.0.0 | 2.0.0 |
| `implementation-catalog.md` | 2.0.0 | 3.0.0 |
| `highway-discovery` | 3.0.0 | 4.0.0 |
| `highway-adr` | 3.0.0 | 4.0.0 |
| `highway-architecture` | 3.0.0 | 4.0.0 |
| `highway-implementation` | 3.0.0 | 4.0.0 |
| `highway-onboarding` | 6.0.0 | 7.0.0 |

No complexity exception is required.

### Post-design re-check

PASS. The design keeps one row per record. The many side is a list of decision ids on the architecture row, and many implementation rows for one architecture. The implementation skill stops writing an implementation id onto the decision.

## Project Structure

### Documentation (this feature)

```text
specs/198-multiple-reference-implementations/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
├── retirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/library/templates/output/adr-record.md
.highway/library/templates/output/adr-catalog.md
.highway/library/templates/output/architecture-record.md
.highway/library/templates/output/architecture-catalog.md
.highway/library/templates/output/implementation-record.md
.highway/library/templates/output/implementation-catalog.md
.highway/skills/highway-discovery/SKILL.md
.highway/skills/highway-adr/SKILL.md
.highway/skills/highway-architecture/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/tools/tests/adr-record-completeness.test.sh
.highway/tools/tests/multiple-reference-implementations.test.sh
```

**Structure Decision**: The templates own the record and catalog shapes. Discovery surfaces a match. The ADR owns replacement, reuse, and the next step. Architecture and implementation write their own records. Onboarding uses those same sections and does not ask the replacement question.

## Complexity Tracking

> No constitution violation requires a justification table.
