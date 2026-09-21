# Implementation Plan: Highway New Solution Constraints Cleanup

**Branch**: `057-highway-new-solution-constraints-cleanup` | **Date**: 2026-09-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/057-highway-new-solution-constraints-cleanup/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Clarify the `highway-new` Solution Constraints contract without changing its eight-field order,
durable Request structure, or Discovery/ADR ownership. The implementation will classify the four
list-shaped and four scalar fields, reject an empty `allowed_solution_classes` value, preserve the
distinct empty-array and `unknown` states where permitted, improve local field-error recovery, and
align focused verification with the workflow. Source guidance, shared output documentation,
focused assertions, and generated adapters remain correspondent.

## Technical Context

**Language/Version**: Markdown skill instructions; repository tooling remains Bash 3.2.57-compatible.

**Primary Dependencies**: Existing `highway-new` skill, shared Request output template, focused
`highway-new.test.sh`, skill/library validators, catalog and adapter generators, and correspondence
checks. No new runtime dependency.

**Storage**: Existing plain Markdown source/template files and user-owned Request records; no new storage.

**Testing**: Focused `highway-new.test.sh`, `validate-skill.sh`, `validate-library.sh`, generated
artifact correspondence checks, distribution checks, and `run-all.sh`.

**Target Platform**: macOS and Linux repository environments; generated adapters target GitHub
Copilot, Claude Code, and Cursor.

**Project Type**: Internal agent skill and repository governance tooling.

**Performance Goals**: One natural-language question per intake turn; no independent service
latency or throughput target.

**Constraints**: Preserve deterministic field order, privacy screening, bounded recovery, no-partial-
write behavior, shared-template authority, generated correspondence, and Request-only ownership.

**Scale/Scope**: One Request conversation at a time; eight Solution Constraints fields; no external
service or persistence scale requirement.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Result | Evidence / condition |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | N/A | No shipped path outside the generated adapter outputs is introduced; packaging checks still run. |
| Toolchain Gate (D2.1-D2.4) | PASS | No new runtime or utility dependency; source is Markdown and existing Bash tooling. |
| Generator Gate (D4.1-D4.4) | PASS | Existing catalog and adapter generators are rerun if their inputs change. |
| Correspondence Gate (D4.5-D4.7) | PASS | The source skill is a declared generator input; catalog, adapters, and manifests are regenerated and checked. |
| Validation Gate (D3.4-D3.6) | PASS | Focused assertions are extended, legacy wording is seeded/observed, and existing fixture verdicts remain covered. |
| Skill Content Gate (D1.5) | PASS | The plan records the Highway Skills Constitution check for source skill and shared library changes. |

**Pre-design result: PASS.** No constitution amendment or unjustified exception is required.

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
├── skills/highway-new/SKILL.md                         # authoritative source skill
├── library/templates/output/request-record.md          # shared Request output contract
└── tools/
    ├── tests/highway-new.test.sh                       # focused behavior and wording assertions
    ├── validate-skill.sh                               # source skill validation
    ├── validate-library.sh                             # shared template validation
    ├── generate-catalog.sh                             # catalog regeneration
    └── generate-agent-adapters.sh                      # adapter regeneration

.github/skills/highway-new/SKILL.md                     # generated adapter
.claude/skills/highway-new/SKILL.md                     # generated adapter
.cursor/rules/highway-new.mdc                           # generated adapter
specs/057-highway-new-solution-constraints-cleanup/     # design artifacts
```

**Structure Decision**: Extend the existing authoritative skill, shared Request output contract,
focused test, and generated adapters. Add design contracts and validation guidance under this
feature directory. No runtime service, package, new persistence layer, or external API is needed.

## Phase 0: Research Summary

Research is complete in [research.md](research.md). Decisions resolved:

- Preserve Spec 053's eight-field order and existing Request ownership boundaries.
- Classify four fields as list-shaped and four as scalar restrictions.
- Treat `allowed_solution_classes` as the non-empty candidate-space exception; `unknown` remains valid.
- Keep the existing focused test and generators as the verification surfaces; add no new dependency.

## Phase 1: Design Summary

Design artifacts:

- [data-model.md](data-model.md) defines field shapes, valid states, and correction transitions.
- [contracts/solution-constraints-intake-contract.md](contracts/solution-constraints-intake-contract.md)
  defines the conversation and local error-recovery contract.
- [contracts/solution-constraints-verification-contract.md](contracts/solution-constraints-verification-contract.md)
  defines the focused assertions and preserved boundaries.
- [quickstart.md](quickstart.md) defines runnable validation scenarios and expected outcomes.

No external service contract is required; these Markdown contracts document repository-owned skill
conversation and verification interfaces.

## Post-Design Constitution Re-check

| Gate | Result | Evidence planned |
|---|---|---|
| P1/P6 deterministic workflow | PASS | Field categories, order, states, and local recovery are explicit. |
| P4/P5 verification and failure handling | PASS | Invalid candidate-space, list, scalar, and privacy cases are covered without weakening existing behavior. |
| P7/P8 skill structure and verification | PASS | Existing sections, validators, focused tests, generators, and adapter targets remain authoritative. |
| P9.1 shared output contract | PASS | The source skill continues to cite the shared Request template rather than duplicating its complete structure. |
| D3 behavioral evidence | PASS | Focused assertions distinguish static wording checks from executed recovery behavior. |
| D4 generated correspondence | PASS | Catalog and all three adapters are regenerated and checked after source changes. |
| D1 shippability | PASS | No development-only path is introduced into shipped skill content. |

**Post-design result: PASS.** No new constitution amendment is required.

## Complexity Tracking

No constitution violations require justification; no additional complexity is introduced.
