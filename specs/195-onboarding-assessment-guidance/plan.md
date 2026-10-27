# Implementation Plan: Onboarding and Assessment Guidance

**Branch**: `195-onboarding-assessment-guidance` | **Date**: 2026-10-27 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/195-onboarding-assessment-guidance/spec.md`

## Summary

Onboarding gains an `overview` step before the first capability list, numbered single capabilities with the title and description on separate lines, the AI-Assisted Engineering and Planning capability in place of Highway, a transition before the first mapping, and mapping labels separated from their values. Assessment gains an opening heading and a `list of findings` step that shows up to five numbered findings, replaces the separate Open list, and is the place the person returns to from a finding.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-onboarding/SKILL.md`, `.highway/skills/highway-assessment/SKILL.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`

**Storage**: Unchanged. The findings file keeps its columns, statuses, identifiers, and revision rule. Onboarding records keep their shape.

**Testing**: Amend `.highway/tools/tests/static-highway-capability.test.sh`, add one contract check, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. A findings list shows at most 5 findings

**Constraints**: The supplied copy is exact, apart from "Highway" capitalization and the missing "to". Do not change the ADR, architecture, or implementation write path, the findings file template, `explore`, or `summary`. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: The `Procedure`, `Classify`, `capabilities`, and `map` sections and Verification in onboarding. The `Purpose`, `Outputs`, `Procedure`, `Entry`, `Classify`, `open`, and `finding` sections and Verification in assessment

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. D3.5 applies: `static-highway-capability.test.sh` asserts three Highway sentences that this feature replaces. `retirements.md` names the superseded behavior. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill sources change. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on both skills. D1.5 names P10.1: each skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because no shared template is edited.

Experience Standard fit: a findings list holds at most 5 choices under X2.16. Questions stay bold and guidance lines stay plain under X2.67. Identifiers stay hidden from the list under X2.3.

Version bumps are MAJOR because a previously conforming flow no longer conforms:

| Skill | From | To |
|---|---|---|
| `highway-onboarding` | 3.0.0 | 4.0.0 |
| `highway-assessment` | 2.0.0 | 3.0.0 |

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 adds one test and amends one, with a retirement record. No shipped file is added beyond the test.

## Project Structure

### Documentation (this feature)

```text
specs/195-onboarding-assessment-guidance/
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
.highway/skills/highway-onboarding/SKILL.md
.highway/skills/highway-assessment/SKILL.md
.highway/tools/tests/static-highway-capability.test.sh
.highway/tools/tests/onboarding-assessment-guidance.test.sh
```

**Structure Decision**: Each skill owns its own copy and flow. Adapters and the catalog are regenerated from the two sources.

## Complexity Tracking

> No constitution violation requires a justification table.
