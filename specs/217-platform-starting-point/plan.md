# Implementation Plan: Platform Starting Point and Automation Grounding

**Branch**: `217-platform-starting-point` | **Date**: 2026-11-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/217-platform-starting-point/spec.md`

## Summary

`highway-codify-config` gains the starting-point line, a shared `use entries` step, a `platform written` step, a New Realized Capabilities field, and a handoff to `highway-implementation`. `current` becomes numbered steps that capture automation capabilities whether or not the implementation realizes them. Both proposal shapes place **Why it matters:** under each entry. The Procedure paragraph on use entries is removed. `highway-implementation` gains an `add capabilities` step, entered from Entry, that records the passed capabilities without a question and returns to the held step. Every change is numbered conditions and actions with a named next step.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md`, `.highway/skills/highway-implementation/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: `library/coding-standards/codify-platforms.md`, `implementations/[RI id].md`, and `implementations/capabilities.md` in adopting repositories. No template changes

**Testing**: New `.highway/tools/tests/platform-starting-point.test.sh`, observed failing first. Pins and moved assertions in [research.md](research.md) R7. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `use entries` and `add capabilities` stay at or under 250 words. `current`, `platform proposal`, and `standard proposal` stay at or under 400 words. New sentences are a condition, then an action, or a named next step. No new or changed step contains so that, because, in order to, should, consider, prefer, usually, or where appropriate. The skill bodies do not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: Two skills, one new test, seven pin moves, one moved assertion

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and the adapters are regenerated (D4.5 through D4.7). No library file changes.
- **Validation Gate**: PASS with recorded replacements in R7 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on the two skills.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. Entry building does not fit either proposal step without passing 400 words, so it is its own step, `use entries`. The after-write questions become `platform written`, so the handoff has a named return step. Recording capabilities does not fit `write`, so it is its own step, `add capabilities`.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify-config` | 3.1.0 | 3.2.0 |
| `highway-implementation` | 7.1.0 | 7.2.0 |

MINOR. Configuration gains new realized capabilities and the handoff. Implementation gains `add capabilities`. Entry form changes inside proposals, and saved cells keep the same `; ` list form, so no saved contract is narrowed.

No complexity exception is required.

### Post-design re-check

PASS. The contract states `current`, `use entries`, `platform written`, and `add capabilities` as numbered steps. Each branch names its next step. The return step is a skill and a step name.

## Project Structure

### Documentation (this feature)

```text
specs/217-platform-starting-point/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── config-steps.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/tools/tests/platform-starting-point.test.sh
.highway/tools/tests/config-live-rules.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/configure-handoff.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
.highway/tools/tests/record-purpose-titles.test.sh
```

**Structure Decision**: The two skills are the sources. Tests pin their text and versions. The catalog and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
