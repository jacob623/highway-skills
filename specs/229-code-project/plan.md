# Implementation Plan: Code Project

**Branch**: `229-code-project` | **Date**: 2026-11-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/229-code-project/spec.md`

## Summary

highway-codify checks the implementation record right after selection. An incomplete record hands off to `highway-implementation`, which proposes Deployed by, Managed by, and Language with a Why it matters line for each, and returns to the check. A record whose Language names a coding standard makes the product a code project. A new `code project` step decides the suggestions: Establish first, then changes to the product code grounded in the record. A new `code tasks` step decides the proposal shape for a code project: code tasks show Language in place of Provider, Establish is a skeleton plus the pipeline when Deployed by is a pipeline, and the Language standard places the source files. The one-run platform naming and the `platforms needed` step are removed. Onboarding stores Language as `Needed`.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `highway-codify`, `highway-implementation`, `highway-onboarding`. Templates `implementation-record.md` and `codify-record.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: The implementation record's Execution lines. The codify record shape gains the code task line

**Testing**: New `.highway/tools/tests/code-project.test.sh`, observed failing first. Moved pins in [research.md](research.md) R8. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `record check`, `code project`, and `provider` stay at or under 250 words. `code tasks` and `delivery platforms` stay at or under 400 words. No changed step gains MUST, SHOULD, or a banned word. The user's sentences are used exactly. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: Three skills, two templates, one new test, the pins in R8

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk`, `grep`, and `wc` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with the recorded moves in R8 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: `implementation-record.md` allows `Needed` for Language. Every reader of Language treats `Needed` as unset: `highway-codify` `record check` and `highway-implementation` `delivery platforms`. `codify-record.md` gains the code task line, the code project diagram, and the code project README. Its only writer is `highway-codify`. Both are MINOR bumps.
- **Live documentation (D6.1)**: Purpose, Procedure, and Verification in each changed skill are updated in the same change.

Skill content gates, from `.highway/governance/constitution.md`:

- P7.1: highway-codify's Purpose stays one sentence.
- P7.3: `record check` owns completeness. `code project` owns the trigger and the suggestions. `code tasks` owns the code project proposal shape. Other steps point to `code tasks` in one sentence and do not restate it. `provider` owns the Executor.
- P7.5: word limits above.
- PASS pending `validate-skill.sh`.

Version bumps:

- `highway-codify` 12.3.0 to 13.0.0. MAJOR. The one-run platform and `platforms needed` are removed, and the hand-off return step changes.
- `highway-implementation` 7.7.0 to 7.8.0. MINOR. The view gains a heading and Why it matters lines, and decline asks to return.
- `highway-onboarding` 10.5.0 to 10.6.0. MINOR. Language starts as `Needed`.
- `implementation-record.md` 2.2.0 to 2.3.0. MINOR.
- `codify-record.md` 9.0.0 to 9.1.0. MINOR.

No complexity exception is required.

### Post-design re-check

PASS. [contracts/wording.md](contracts/wording.md) names every replaced and new line. R8 names every moved pin.

## Project Structure

### Documentation (this feature)

```text
specs/229-code-project/
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
.highway/library/templates/output/implementation-record.md
.highway/library/templates/output/codify-record.md
.highway/tools/tests/code-project.test.sh
.highway/tools/tests/*.test.sh (moved pins, R8)
```

**Structure Decision**: `record check` sits after `choose`, `code project` after `codified`, and `code tasks` after `draft`. Generated catalogs and adapters are refreshed after the version bumps.

## Complexity Tracking

No constitution violation requires a justification.
