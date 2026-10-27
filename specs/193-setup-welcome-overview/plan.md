# Implementation Plan: Setup Welcome Overview

**Branch**: `193-setup-welcome-overview` | **Date**: 2026-10-24 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/193-setup-welcome-overview/spec.md`

## Summary

The setup welcome ends with an overview of the four parts of setup instead of a separator and "Let's get started." The text above it, the condition that shows it, and the handoff to Profile are unchanged.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-setup/SKILL.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`

**Storage**: None. Setup writes no repository file.

**Testing**: Add a contract check under `.highway/tools/tests/`, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. The overview appears once, on a first run

**Constraints**: The overview copy is exact. Do not change the welcome condition, the text above the overview, the Profile handoff, or the Objectives, Controls, and NFRs transitions. Do not place a literal `###` line inside the skill's `### Welcome` section. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: The Welcome section and its verification line in one skill

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. No current test asserts "Let's get started.", so D3.5 does not require a retired assertion. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill source changes. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-setup`. D1.5 names P10.1: the skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because no shared template is edited.

The setup skill version bump is MAJOR, `9.1.0` to `10.0.0`, because a welcome that ended with "Let's get started." no longer conforms.

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 adds no file to the shipped tree beyond one test. The overview copy and its heading level are named in the contract.

## Project Structure

### Documentation (this feature)

```text
specs/193-setup-welcome-overview/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-setup/SKILL.md
.highway/tools/tests/setup-welcome-overview.test.sh
```

**Structure Decision**: The behavior change is the setup skill's Welcome section. Adapters and the skill catalog are regenerated from that source.

## Complexity Tracking

> No constitution violation requires a justification table.
