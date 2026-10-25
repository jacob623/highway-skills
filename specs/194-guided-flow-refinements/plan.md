# Implementation Plan: Guided Flow Refinements

**Branch**: `194-guided-flow-refinements` | **Date**: 2026-10-24 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/194-guided-flow-refinements/spec.md`

## Summary

Profile's Vision, Competitive Path, and Guiding Principles starting points show each label in bold, with its content in its own paragraph beneath it. Objectives, Controls, and NFRs number every recommendation set, accept numbers as a selection, close each set with the approved copy, and follow the ready-to-review question with an add-another line. NFR recommendations come from accepted Controls first, until every Control is reflected. After that, Profile, Objectives, or uncovered-area expectations may follow.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-profile/SKILL.md`, `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, `.highway/skills/highway-nfrs/SKILL.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`

**Storage**: None changed. Record, catalog, and profile templates stay as they are.

**Testing**: Add one contract check under `.highway/tools/tests/`, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. Each set keeps at most 5 recommendations

**Constraints**: The supplied copy is exact, apart from the "expectation" typo fix. Do not change batch review, capture, write, or stored review. Keep **No system hosting** and **Direct purchase** text and Request mapping unchanged. Do not edit Discovery. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Three starting-point templates in Profile, and the `Classify`, `recommend`, `more`, and `queue` sections of three skills

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add a test. No current test asserts the replaced lines, the bullet recommendation form, or the Profile labels, so D3.5 does not require a retired assertion. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill sources change. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on all four skills. D1.5 names P10.1: each skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because no shared template is edited.

Experience Standard fit: the new closing lines are guidance, not a question, so they stay unbolded under X2.67. A set still holds at most 5 choices under X2.16. "Select some, all or provide your own" keeps the user-authored alternative under X2.17 and plural choice wording under X2.32.

Version bumps are MAJOR because a previously conforming flow no longer conforms:

| Skill | From | To |
|---|---|---|
| `highway-profile` | 13.0.0 | 14.0.0 |
| `highway-objectives` | 6.0.0 | 7.0.0 |
| `highway-controls` | 6.0.0 | 7.0.0 |
| `highway-nfrs` | 7.0.0 | 8.0.0 |

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 adds one test and no new shipped file. The copy for every changed message is named in the contract.

## Project Structure

### Documentation (this feature)

```text
specs/194-guided-flow-refinements/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-profile/SKILL.md
.highway/skills/highway-objectives/SKILL.md
.highway/skills/highway-controls/SKILL.md
.highway/skills/highway-nfrs/SKILL.md
.highway/tools/tests/guided-flow-refinements.test.sh
```

**Structure Decision**: Each skill owns its own copy. The four sources change, and adapters and the catalog are regenerated from them.

## Complexity Tracking

> No constitution violation requires a justification table.
