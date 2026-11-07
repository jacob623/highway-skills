# Implementation Plan: Establish From Record

**Branch**: `223-establish-from-record` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/223-establish-from-record/spec.md`

## Summary

An implementation proposal records Deployed by, Managed by, and Language. Deployed by and Managed by are chosen from platform kind. A codify proposal reads those values as the executor and lets each task keep its own platform. A coding standard whose Technology is a platform title proposes only `[Platform] is used` and `[Platform] is not used`.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `highway-implementation`, `highway-codify`, `highway-codify-config`, `highway-onboarding`. Templates `implementation-record.md` and `codify-platforms.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: The implementation record and `library/coding-standards/codify-platforms.md`

**Testing**: New `.highway/tools/tests/establish-from-record.test.sh`, observed failing first. Moved pins in [research.md](research.md) R6. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: New steps stay at or under 250 words. `platform proposal` and `standard proposal` stay at or under 400. `draft` and `provider` stay at or under 250. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`. No migration of older records

**Scale/Scope**: Four skills, two templates, one new test, the version pins in R6

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with the recorded moves in R6 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: The two changed templates are cited by `highway-implementation` and `highway-codify-config`. `validate-skill.sh` runs on those skills and on `highway-codify`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. Each new behavior is its own ordered step.

Version bumps:

- `highway-implementation` 7.2.0 to 7.3.0. MINOR. The proposal and the record gain three fields.
- `highway-codify` 12.0.0 to 12.1.0. MINOR. The executor and the task platform are different.
- `highway-codify-config` 3.2.5 to 3.3.0. MINOR. The platform row gains Kind, and a platform standard's entries are fixed.
- `highway-onboarding` 10.1.0 to 10.2.0. MINOR. A named return step is honored after the new row exists.
- `codify-platforms.md` 2.0.0 to 2.1.0. MINOR. The table gains Kind.
- `implementation-record.md` 2.1.0 to 2.2.0. MINOR. The record gains Execution.

No complexity exception is required.

### Post-design re-check

PASS. [contracts/execution.md](contracts/execution.md), [contracts/proposal.md](contracts/proposal.md), and [contracts/platform-entries.md](contracts/platform-entries.md) name the lines the tests pin. R6 names every moved pin. No step in the design exceeds its word limit.

## Project Structure

### Documentation (this feature)

```text
specs/223-establish-from-record/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── execution.md
│   ├── proposal.md
│   └── platform-entries.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-codify/SKILL.md
.highway/skills/highway-codify-config/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/library/templates/output/implementation-record.md
.highway/library/templates/output/codify-platforms.md
.highway/tools/tests/establish-from-record.test.sh
```

**Structure Decision**: The skills and the two templates are the source. One test pins the contracts. Generated catalogs and adapters are refreshed after the version bumps.

## Complexity Tracking

No constitution violation requires a justification.
