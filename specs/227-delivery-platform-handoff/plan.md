# Implementation Plan: Delivery Platform Handoff

**Branch**: `227-delivery-platform-handoff` | **Date**: 2026-11-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/227-delivery-platform-handoff/spec.md`

## Summary

`highway-codify` replaces the dead-end "[Field] is needed" stop in `provider` with a move to a new `platforms needed` step that holds the person's message and its replies. A yes hands off to a new `delivery platforms` step in `highway-implementation`, which shows the five-field view, writes only the Execution lines on acceptance, and hands back with a return line. A named platform is held as this run's Executor and never written to the record. `highway-onboarding` states that its implementations store `Needed`, `Needed`, and `None`, and returns to `provider` in `highway-codify` after onboarding a platform named for one run.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `highway-codify`, `highway-implementation`, `highway-onboarding`. `highway-codify-config` already holds any return step. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: The implementation record's Execution lines. The template already allows `Needed` and `None`, so it is unchanged

**Testing**: New `.highway/tools/tests/delivery-platform-handoff.test.sh`, observed failing first. Moved pins in [research.md](research.md) R5. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: The new step stays at or under 250 words. The skill body does not gain MUST or SHOULD, or the banned words. No shipped path references `.specify/` or `specs/`. The person's message and hand-off lines are used exactly as supplied

**Scale/Scope**: Three skills, one new test, the pins in R5

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk`, `grep`, and `wc` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with the recorded moves in R5 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: N/A. `implementation-record.md` is unchanged.
- **Live documentation (D6.1)**: Purpose, When to use, Outputs, Procedure order, and Verification in each changed skill are updated in the same change.

Skill content gates, from `.highway/governance/constitution.md`:

- P7.3: `highway-implementation` owns the record write and the view. `highway-codify` owns the stop and the this-run Executor. `delivery platforms` cites `field` for name resolution and does not restate it.
- `highway-codify` keeps "Do not change the implementation". The write happens in `highway-implementation`.
- PASS pending `validate-skill.sh`.

Version bumps:

- `highway-codify` 12.2.0 to 12.3.0. MINOR. New stop message and replies.
- `highway-implementation` 7.5.0 to 7.6.0. MINOR. New `delivery platforms` step and entry.
- `highway-onboarding` 10.4.0 to 10.5.0. MINOR. Stated Execution values and a new return step.

No complexity exception is required.

### Post-design re-check

PASS. [contracts/wording.md](contracts/wording.md) names every replaced and new line. R5 names every moved pin. The new step is under 250 words.

## Project Structure

### Documentation (this feature)

```text
specs/227-delivery-platform-handoff/
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
.highway/skills/highway-codify/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/tools/tests/delivery-platform-handoff.test.sh
```

**Structure Decision**: Each skill keeps what it emits and what it writes. Generated catalogs and adapters are refreshed after the version bumps.

## Complexity Tracking

No constitution violation requires a justification.
