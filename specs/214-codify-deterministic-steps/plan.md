# Implementation Plan: Codify Deterministic Steps

**Branch**: `214-codify-deterministic-steps` | **Date**: 2026-11-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/214-codify-deterministic-steps/spec.md`

## Summary

`highway-codify` keeps one copy of each rule, splits the three longest steps, and replaces three judgments with a match. A named platform stays the Provider. A coding standard still has to match a file pattern or a technology before its When to use entries are checked. The plan has one story per proposal task. The check asks the first five gaps. Which suggestion is left out, and which product is joined, stay as they are.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md` and `.highway/library/templates/output/codify-plan.md`. Validators `validate-skill.sh` and `validate-library.sh`. Generators `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`

**Storage**: The plan stays `plan.md` beside the accepted proposal. No new file is added

**Testing**: New `.highway/tools/tests/codify-deterministic-steps.test.sh`, observed failing first. Pins and moved assertions are recorded in [research.md](research.md) R8 and R9. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: The check asks at most five gaps, in story order

**Constraints**: The seven new steps stay at or under 250 words, excluding the heading. Every step stays at or under 400. New text is a condition, then the action. The skill body does not gain MUST or SHOULD, and does not say should, consider, prefer, usually, or where appropriate. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one template, one new test, the pin moves in R8, the assertion moves in R9

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The library catalog, the skill catalog, and the adapters are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with recorded replacements. Pins and moved assertions are in R8 and R9 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on `highway-codify` and `validate-library.sh` on `codify-plan.md`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. `rank`, `draft`, `provider`, `resume`, `join`, and `folder` are their own steps. `suggest` keeps the replies. No new step exceeds 250 words. No step exceeds 400.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 11.0.0 | 12.0.0 |
| `codify-plan.md` | 1.0.0 | 2.0.0 |

MAJOR. The Provider fit test, the standard fit test, which Control applies, the plan's story rule, and which check question is asked are narrower.

No complexity exception is required.

### Post-design re-check

PASS. The contract states each new step as a condition and a next step. `suggest`, `draft`, `provider`, `resume`, `join`, and `folder` are drafted under 250 words. The suggestion filter and the product "means" tests are unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/214-codify-deterministic-steps/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── step-matches.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify/SKILL.md
.highway/library/templates/output/codify-plan.md
.highway/tools/tests/codify-deterministic-steps.test.sh
.highway/tools/tests/codify-feature-wording.test.sh
.highway/tools/tests/codify-products.test.sh
.highway/tools/tests/codify-write-refactor.test.sh
.highway/tools/tests/codify-closing-guide.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
.highway/tools/tests/propose-edit-lines.test.sh
```

**Structure Decision**: The skill and the plan template are the sources. Tests pin versions and step names. Catalogs and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
