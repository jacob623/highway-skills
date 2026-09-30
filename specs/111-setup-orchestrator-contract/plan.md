# Implementation Plan: Setup Orchestrator Contract Simplification

**Branch**: `111-setup-orchestrator-contract` | **Date**: 2026-09-30 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/111-setup-orchestrator-contract/spec.md`

## Summary

Rewrite `.highway/skills/highway-setup/SKILL.md` as a thin owner orchestrator. Preserve owner-declared readiness and collection result contracts, while removing copied domain workflows, owner internals, checkpoint behavior, persistence verification, and generic interaction/error rules. Update focused contract tests and regenerate derived artifacts.

## Technical Context

**Language/Version**: Markdown and POSIX-compatible Bash 3.2.57

**Primary Dependencies**: Highway Skills Constitution, Highway Experience Standard, Profile/Objectives/Controls/NFR owner contracts, repository generators

**Storage**: No Setup-owned storage; owner artifacts and owner state remain owned by their skills

**Testing**: `.highway/tools/tests/run-all.sh` and focused Setup contract tests

**Target Platform**: Distributed Highway skill tree and generated agent adapters

**Project Type**: Runtime skill/documentation repository

**Performance Goals**: N/A; preserve deterministic routing and generator output

**Constraints**: Keep owner schemas unchanged; avoid generated-artifact drift; keep Setup within constitution limits

**Scale/Scope**: One shipped skill, its generated adapters/catalog entries, and focused tests

## Constitution Check

*GATE: PASS before Phase 0 and after Phase 1.*

Process gates:
- Packaging Gate: PASS — shipped skill and generated artifacts will be validated for development-only references.
- Validation Gate: PASS — focused tests will be amended without weakening assertions.
- Correspondence Gate: PASS — changed skill input requires catalog and adapter regeneration.
- Toolchain and Generator Gates: N/A unless implementation edits `.highway/tools/`.
- D1.5, D6.1, and D6.2: PASS — canonical and generated affected artifacts will be identified and synchronized.

Skill content gates: PASS against the Highway Skills Constitution:
- P1.5 and P11.1: runtime dependencies are named in Inputs.
- P7.3 and P10.1: generic governance and experience rules are referenced, not copied.
- P7.7: the breaking rewrite increments `7.0.0` to `8.0.0`.
- P12.5–P12.12: Setup consumes owner results, delegates owner actions, and does not inspect owner state.
- P5.14: Error Handling retains only Setup-specific exceptions.

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
├── library/catalog/
└── agents/<adapter-tree>/
specs/111-setup-orchestrator-contract/
```

**Structure Decision**: Modify the canonical Setup skill, amend focused contract tests under
`.highway/tools/tests/`, regenerate catalog/adapters through existing generators, and keep
planning artifacts under this feature directory. No application source tree or new runtime
storage is introduced.

## Complexity Tracking

No violations requiring a complexity exception are planned.
