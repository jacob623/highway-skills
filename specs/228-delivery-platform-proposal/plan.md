# Implementation Plan: Delivery Platform Proposal

**Branch**: `228-delivery-platform-proposal` | **Date**: 2026-11-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/228-delivery-platform-proposal/spec.md`

## Summary

The `delivery platforms` step in `highway-implementation` follows `execution`, the rules the normal proposal uses, and takes its value for each unset field. Stored values and values the person named in this visit stay. `execution` returns to the step that named it, and leaves this implementation's own row out of the candidates. Acceptance writes the held fields.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `highway-implementation` only. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: The implementation record's Execution lines. The template is unchanged

**Testing**: New `.highway/tools/tests/delivery-platform-proposal.test.sh`, observed failing first. Moved pins in [research.md](research.md) R4. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `delivery platforms` and `execution` each stay at or under 250 words. The skill body gains no MUST, SHOULD, or banned word. No shipped path references `.specify/` or `specs/`. The highway-codify message is unchanged

**Scale/Scope**: One skill, one new test, the pins in R4

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk`, `grep`, and `wc` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with the recorded moves in R4 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: N/A. No template changes.
- **Live documentation (D6.1)**: Verification in `highway-implementation` is updated in the same change.

Skill content gates, from `.highway/governance/constitution.md`:

- P7.3: `execution` owns the proposal rules. `delivery platforms` cites it and does not restate the Kind order.
- P7.5: both changed steps stay under 250 words.
- PASS pending `validate-skill.sh`.

Version bump: `highway-implementation` 7.6.0 to 7.7.0. MINOR. The view gains proposed values.

No complexity exception is required.

### Post-design re-check

PASS. [contracts/wording.md](contracts/wording.md) names every replaced and new line. R4 names every moved pin.

## Project Structure

### Documentation (this feature)

```text
specs/228-delivery-platform-proposal/
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
.highway/skills/highway-implementation/SKILL.md
.highway/tools/tests/delivery-platform-proposal.test.sh
.highway/tools/tests/delivery-platform-handoff.test.sh
```

**Structure Decision**: `execution` stays the one place the proposal rules live. Generated catalogs and adapters are refreshed after the version bump.

## Complexity Tracking

No constitution violation requires a justification.
