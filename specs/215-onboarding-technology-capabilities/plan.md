# Implementation Plan: Onboarding Technology Capabilities

**Branch**: `215-onboarding-technology-capabilities` | **Date**: 2026-11-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/215-onboarding-technology-capabilities/spec.md`

## Summary

`highway-onboarding` opens with the heading "Let's get to know your technology landscape" and proposes technology capabilities. Each business activity in accepted context yields the technology capability it relies on, named for what the technology does. An activity that no technology supports is left out. No system is named on the starting point. `map` asks for an unknown provider as it does today.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-onboarding/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: N/A. Onboarding writes no new file

**Testing**: New `.highway/tools/tests/onboarding-technology-capabilities.test.sh`, observed failing first. Pins and moved assertions are recorded in [research.md](research.md) R4. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `capabilities` stays at or under 400 words, excluding the heading. New text is a condition, then the action. The skill body does not gain MUST or SHOULD, and does not say should, consider, prefer, usually, or where appropriate. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one new test, one moved pin, three moved assertions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and the adapters are regenerated (D4.5 through D4.7). No library file changes.
- **Validation Gate**: PASS with recorded replacements in R4 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on `highway-onboarding`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. The technology rule belongs to `capabilities` and is added there as ordered sentences. The heading change belongs to `overview`.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-onboarding` | 9.0.0 | 10.0.0 |

MAJOR. The capabilities onboarding proposes are narrowed to technology capabilities.

No complexity exception is required.

### Post-design re-check

PASS. The contract adds four sentences to `capabilities` and changes three overview lines and two placeholders. `capabilities` stays under 400 words. `map`, `mapping`, and `orchestrate` are unchanged apart from the placeholder in `map`.

## Project Structure

### Documentation (this feature)

```text
specs/215-onboarding-technology-capabilities/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── onboarding-capabilities.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-onboarding/SKILL.md
.highway/tools/tests/onboarding-technology-capabilities.test.sh
.highway/tools/tests/onboarding-assessment-guidance.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
```

**Structure Decision**: The skill is the source. Tests pin its text and version. The catalog and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
