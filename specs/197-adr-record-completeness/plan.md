# Implementation Plan: ADR Record Completeness

**Branch**: `197-adr-record-completeness` | **Date**: 2026-10-29 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/197-adr-record-completeness/spec.md`

## Summary

The ADR record gains a problem-and-forces Context, a Decision Scope, a Revisit When section, alternatives that carry their own definitions, typed governance links, and handoff fields that name the reference architecture and reference implementation. The handoff stops copying the chosen option and the architecture matches. `superseded` joins the record and catalog statuses. Onboarding writes the same sections. The architecture and implementation skills may update only the ADR's handoff ids after their own write.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/library/templates/output/adr-record.md`, `.highway/library/templates/output/adr-catalog.md`, and the `SKILL.md` sources of `highway-adr`, `highway-onboarding`, `highway-architecture`, and `highway-implementation`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/validate-library.sh`

**Storage**: ADR records at `adrs/<ADR id>.md` and the catalog at `adrs/adrs.md`. Architecture and implementation records keep their shape

**Testing**: Add one contract check, then `.highway/tools/tests/run-all.sh`. `output-template.test.sh` requires `Selected Option: OPTXXXXXX` and `Selection Source: User-provided explicit selection` in the ADR template. Both strings stay

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target

**Constraints**: Do not add named deciders, a second scoring, an implementation plan, or a clock timestamp. Do not change the Discovery, the architecture record template, or the implementation record template. Authorization stays: proceed to Reference Architecture, do not implement. Existing ADR files are not migrated. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Two output templates. The `write` step in `highway-adr`, the `orchestrate` step in `highway-onboarding`, and the `write` step plus scope lines in `highway-architecture` and `highway-implementation`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. D3.5 does not apply unless an existing assertion is loosened or removed. The two template strings the suite requires stay. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill sources change.
- Skill Content Gate: PASS pending `validate-skill.sh` on the four skills and `validate-library.sh` on the templates. D8.1 applies: both ADR templates change, so every skill that cites either one is re-validated. Those are `highway-adr` and `highway-onboarding`, plus `highway-architecture` and `highway-implementation` once they cite `adr-record.md`.

Version bumps are MAJOR because a previously conforming record or flow no longer conforms:

| Source | From | To |
|---|---|---|
| `adr-record.md` | 1.0.0 | 2.0.0 |
| `adr-catalog.md` | 2.0.0 | 3.0.0 |
| `highway-adr` | 2.0.0 | 3.0.0 |
| `highway-onboarding` | 5.0.0 | 6.0.0 |
| `highway-architecture` | 2.0.0 | 3.0.0 |
| `highway-implementation` | 2.0.0 | 3.0.0 |

No complexity exception is required.

### Post-design re-check

PASS. The design adds one test and changes no existing assertion. The ADR update by architecture and implementation is limited to two handoff fields and never touches the decision text or status.

## Project Structure

### Documentation (this feature)

```text
specs/197-adr-record-completeness/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/library/templates/output/adr-record.md
.highway/library/templates/output/adr-catalog.md
.highway/skills/highway-adr/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/skills/highway-architecture/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/tools/tests/adr-record-completeness.test.sh
```

**Structure Decision**: The ADR template owns the record shape. `highway-adr` and `highway-onboarding` write it. `highway-architecture` and `highway-implementation` update only its handoff ids.

## Complexity Tracking

> No constitution violation requires a justification table.
