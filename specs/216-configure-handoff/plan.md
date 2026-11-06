# Implementation Plan: Configure Handoff

**Branch**: `216-configure-handoff` | **Date**: 2026-11-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/216-configure-handoff/spec.md`

## Summary

`highway-onboarding` gains a `configure` step between `lineage` and `summary`. For each platform the person agreed to, it emits one transition sentence and follows `highway-codify-config` with the return step `configure`. `highway-implementation` does the same from `platforms`, with the return step `close`. `highway-codify-config` holds a return step from Entry, and its menu decline goes there. Both configure pointers are removed. Every change is numbered conditions and actions with a named next step.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-onboarding/SKILL.md`, `.highway/skills/highway-implementation/SKILL.md`, `.highway/skills/highway-codify-config/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: N/A. The platforms to configure and the return step stay in the conversation

**Testing**: New `.highway/tools/tests/configure-handoff.test.sh`, observed failing first. Pins and moved assertions in [research.md](research.md) R5. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `configure` and each changed step stay at or under 250 words, excluding the heading, except where a step already exceeded it. New sentences are a condition, then an action, or a named next step. No new sentence contains so that, because, in order to, should, consider, prefer, usually, or where appropriate. The skill bodies do not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: Three skills, one new test, seven pin moves, two moved assertions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and the adapters are regenerated (D4.5 through D4.7). No library file changes.
- **Validation Gate**: PASS with recorded replacements in R5 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on the three skills.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. The handoff decision does not fit `lineage` or `summary`, so it is its own step, `configure`. Implementation and configuration change one branch each and add one Entry step.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-onboarding` | 10.0.0 | 10.1.0 |
| `highway-implementation` | 7.0.0 | 7.1.0 |
| `highway-codify-config` | 3.0.0 | 3.1.0 |

MINOR. Each skill gains the handoff or the return. No contract is narrowed.

No complexity exception is required.

### Post-design re-check

PASS. The contract states `configure` as four numbered steps ending in `summary` or the handoff. Each changed branch names its next step. The return step is a skill and a step name.

## Project Structure

### Documentation (this feature)

```text
specs/216-configure-handoff/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── handoff-steps.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-onboarding/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-codify-config/SKILL.md
.highway/tools/tests/configure-handoff.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
.highway/tools/tests/record-purpose-titles.test.sh
.highway/tools/tests/config-live-rules.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/onboarding-technology-capabilities.test.sh
```

**Structure Decision**: The three skills are the sources. Tests pin their text and versions. The catalog and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
