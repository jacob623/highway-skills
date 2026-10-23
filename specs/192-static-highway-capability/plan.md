# Implementation Plan: Static Highway Capability

**Branch**: `192-static-highway-capability` | **Date**: 2026-10-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/192-static-highway-capability/spec.md`

## Summary

The onboarding capability list includes one static Highway line. The person can correct or remove it. When it is accepted, its provider is the agent platform when that platform is known, and the existing unknown-provider prompt when it is not. Other capabilities keep their own providers. An accepted Highway provider is not added a second time. The decision, reference architecture, and reference implementation path is unchanged.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-onboarding/SKILL.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`

**Storage**: An accepted Highway capability becomes the existing provider records. No new file is added.

**Testing**: Add a contract check under `.highway/tools/tests/`, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. The Highway line appears once on the capability list

**Constraints**: Do not assign the agent platform to a capability it does not operate. Do not guess a product name. Do not authorize the agent to act on its own. Do not add a second Highway capability for a platform that already has an accepted Highway provider. Do not change how the decision, reference architecture, or reference implementation is written. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: The capability list and the provider mapping in one skill

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. No current test asserts the absence of the Highway line, so D3.5 does not require a removed assertion. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill source changes. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-onboarding`. D1.5 names P10.1: the skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because no shared template is edited.

The onboarding skill version bump is MAJOR, `2.0.0` to `3.0.0`, because a capability list that omitted the Highway line no longer conforms.

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 does not add a file, a second provider path, or an authorization to act. The sentence and the provider rule are named.

## Project Structure

### Documentation (this feature)

```text
specs/192-static-highway-capability/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-onboarding/SKILL.md
.highway/tools/tests/static-highway-capability.test.sh
```

**Structure Decision**: The behavior change is the onboarding skill. Accepted Highway follows the provider path that skill already writes. Adapters and the skill catalog are regenerated from that source.

## Complexity Tracking

> No constitution violation requires a justification table.
