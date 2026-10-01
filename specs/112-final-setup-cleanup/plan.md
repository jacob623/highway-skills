# Implementation Plan: Final Setup Contract Cleanup

**Branch**: `112-final-setup-cleanup` | **Date**: 2026-09-30 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/112-final-setup-cleanup/spec.md`

## Summary

Correct the `highway-setup` `8.0.0` skill contract by restoring the valid Purpose heading,
generalizing owner-result routing, adding the first-run welcome, encoding exact separated
transitions, and removing duplicated Constitution boundaries. Update focused contract tests and
regenerate affected adapters and catalogs.

## Technical Context

**Language/Version**: Markdown and POSIX-compatible Bash 3.2.57

**Primary Dependencies**: Highway Skills Constitution, Highway Experience Standard, four owner contracts, repository generators

**Storage**: No Setup-owned storage

**Testing**: Focused Setup contract tests and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree and generated agent adapters

**Project Type**: Runtime skill/documentation repository

**Performance Goals**: Preserve deterministic owner routing and generated artifact synchronization

**Constraints**: Keep version `8.0.0`, owner schemas unchanged, and generic governance centralized

**Scale/Scope**: One shipped skill, focused contract tests, generated adapters, and catalogs

## Constitution Check

*GATE: PASS before Phase 0 and after Phase 1.*

Process gates:
- Packaging Gate: PASS — the shipped Setup skill and generated artifacts will be validated.
- Validation Gate: PASS — existing tests will be amended to the corrected owner-specific contract.
- Correspondence Gate: PASS — the changed skill input requires catalog and adapter regeneration.
- Toolchain and Generator Gates: N/A unless generator scripts are changed.
- D1.5, D6.1, and D6.2: PASS — affected canonical and generated artifacts will be synchronized.

Skill content gates: PASS against the Highway Skills Constitution:
- P1.5/P11.1: Inputs retain only named runtime dependencies.
- P7.3/P10.1: Constitution and Experience Standard rules are referenced rather than duplicated.
- P7.7: version remains `8.0.0` because this is a correction completing that contract.
- P12.5–P12.12: Setup consumes owner-specific results and delegates owner actions.
- P5.14: only Setup-specific exceptions remain in Error Handling.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/
├── skills/highway-setup/SKILL.md
├── tools/tests/
├── catalog/
└── generated agent adapters/
specs/112-final-setup-cleanup/
```

**Structure Decision**: Update the canonical Setup skill and affected contract tests, regenerate
the catalog and adapters, and keep design artifacts under this feature directory. No owner schema
or Setup persistence artifact changes.

## Complexity Tracking

No violations requiring a complexity exception are planned.
