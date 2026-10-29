# Implementation Plan: Review Presentation Refinements

**Branch**: `196-review-presentation-refinements` | **Date**: 2026-10-29 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/196-review-presentation-refinements/spec.md`

## Summary

Objectives, Controls, and NFRs number their capture reviews. Onboarding shortens the AI-Assisted Engineering and Planning description. Assessment titles each listed finding, renames Complexity to Solution Complexity, and lets the person dismiss from the list and from a finding's details. Request merges `start` and `capture` into one `start` step in the capture layout, with readable Solution Constraints names and "None" for unknown or empty values.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: The `SKILL.md` sources of `highway-objectives`, `highway-controls`, `highway-nfrs`, `highway-onboarding`, `highway-assessment`, and `highway-request`. `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-catalog.sh`

**Storage**: Unchanged. The request record keeps snake-case Solution Constraints fields, `unknown`, and `[]`. The findings file does not store the finding title

**Testing**: Amend `onboarding-assessment-guidance.test.sh` and `static-highway-capability.test.sh`, add one contract check, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. The person accepts a request proposal once

**Constraints**: The supplied copy is exact. Do not change the request record template, the findings template, the request identifier and write steps, or the finding details apart from the closing line. `static-operating-nfrs.test.sh` requires the request rules to keep naming `procurement_constraints` and `vendor_restrictions`. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: The `capture` step in three skills. One onboarding description. The `Classify`, `list of findings`, `finding`, and Verification sections in assessment. The `Procedure`, `Classify`, `start`, `capture`, and Verification sections in request

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. D3.5 applies: two tests assert copy this feature replaces. `retirements.md` names the superseded behavior. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill sources change.
- Skill Content Gate: PASS pending `validate-skill.sh` on all six skills. D1.5 names P10.1: each skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because no shared template is edited.

Experience Standard fit: the findings list still holds at most 5 choices under X2.16. Questions stay bold and guidance lines stay plain under X2.67. Readable field names keep identifiers out of what the person sees under X2.3.

Version bumps are MAJOR because a previously conforming flow no longer conforms:

| Skill | From | To |
|---|---|---|
| `highway-objectives` | 7.0.0 | 8.0.0 |
| `highway-controls` | 7.0.0 | 8.0.0 |
| `highway-nfrs` | 8.0.0 | 9.0.0 |
| `highway-onboarding` | 4.0.0 | 5.0.0 |
| `highway-assessment` | 3.0.0 | 4.0.0 |
| `highway-request` | 3.0.0 | 4.0.0 |

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 adds one test and amends two, with a retirement record. No shipped file is added beyond the test.

## Project Structure

### Documentation (this feature)

```text
specs/196-review-presentation-refinements/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── retirements.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-objectives/SKILL.md
.highway/skills/highway-controls/SKILL.md
.highway/skills/highway-nfrs/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/skills/highway-assessment/SKILL.md
.highway/skills/highway-request/SKILL.md
.highway/tools/tests/onboarding-assessment-guidance.test.sh
.highway/tools/tests/static-highway-capability.test.sh
.highway/tools/tests/review-presentation-refinements.test.sh
```

**Structure Decision**: Each skill owns its own copy and flow. Adapters and the catalog are regenerated from the six sources.

## Complexity Tracking

> No constitution violation requires a justification table.
