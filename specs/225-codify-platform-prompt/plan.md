# Implementation Plan: Codify Platform Prompt

**Branch**: `225-codify-platform-prompt` | **Date**: 2026-11-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/225-codify-platform-prompt/spec.md`

## Summary

The lines a person sees when a platform is included and configured name highway-codify instead of automation in general. `highway-onboarding` and `highway-implementation` show a new included line, a new question, and a new line that starts configuration. `highway-codify-config` shows a new platform proposal heading and a new menu option. When each line is shown, and what each answer does, are unchanged.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `highway-onboarding`, `highway-implementation`, `highway-codify-config`. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: N/A. No record, catalog, or template changes

**Testing**: New `.highway/tools/tests/codify-platform-prompt.test.sh`, observed failing first. Moved pins in [research.md](research.md) R3. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: No section grows past its word limit. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`. Wording is used exactly as supplied

**Scale/Scope**: Three skills, one new test, the pins in R3

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with the recorded moves in R3 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: N/A. No shared template changes. `validate-skill.sh` runs on all three skills.
- **Live documentation (D6.1)**: The verification lines that paraphrase the changed lines are updated in the same change.

Skill content gates, from `.highway/governance/constitution.md`:

- P7.3: each line is stated once in the skill that emits it. `highway-onboarding` follows `platforms` in `highway-implementation` for the row write and keeps its own copy of the included line and question, as today.
- PASS pending `validate-skill.sh`.

Version bumps:

- `highway-onboarding` 10.3.0 to 10.4.0. MINOR. New included line, question, and configure line.
- `highway-implementation` 7.4.0 to 7.5.0. MINOR. Same three lines.
- `highway-codify-config` 3.4.0 to 3.5.0. MINOR. New proposal heading and menu option.

No complexity exception is required.

### Post-design re-check

PASS. [contracts/wording.md](contracts/wording.md) names every replaced and new line. R3 names every moved pin. Each change replaces words in place, so no step grows past its limit.

## Project Structure

### Documentation (this feature)

```text
specs/225-codify-platform-prompt/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── wording.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-onboarding/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-codify-config/SKILL.md
.highway/tools/tests/codify-platform-prompt.test.sh
```

**Structure Decision**: Each skill keeps the lines it emits. Generated catalogs and adapters are refreshed after the version bumps.

## Complexity Tracking

No constitution violation requires a justification.
