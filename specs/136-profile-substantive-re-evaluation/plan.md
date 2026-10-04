# Implementation Plan: Profile Substantive Re-evaluation and Fuller Identity

**Branch**: `136-profile-substantive-re-evaluation` | **Date**: 2026-10-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/136-profile-substantive-re-evaluation/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the Profile skill so every substantive contribution is re-evaluated against the active
Working Idea and relevant Profile context before routing, with selective clarification only for
consequential uncertainty requiring the person's information. Extend that behavior to a fuller,
provisional Identity development path and downstream Vision and Competitive Path relationship
reasoning, while retaining the existing four-domain schema and acceptance boundaries. Amend the
source skill, regenerate its distributed adapters/catalog metadata, and add focused static contract
coverage for the new behavior.

## Technical Context

**Language/Version**: Markdown skill contract with POSIX-compatible Bash 3.2 test scripts

**Primary Dependencies**: Highway Experience Standard X2.37-X2.40, Profile record template 3.0.0,
Highway Skills Constitution, existing Profile test helpers and adapter generators

**Storage**: Markdown Profile at `.highway/library/knowledge/profile.md`; no schema change

**Testing**: Focused Profile contract tests followed by `bash .highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed skill tree on macOS and POSIX-like shells

**Project Type**: Documentation-defined agent skill suite with generated agent adapters

**Performance Goals**: Deterministic static contract validation; no runtime performance target

**Constraints**: Do not modify Experience Standard, Profile template, Setup, clarify, Constitution,
or retained schema. Do not add retained reasoning state, Identity facet fields, or technology inventory.
Keep clarification separate from Contribution Opportunity, acceptance, and other discovery questions.

**Scale/Scope**: One source skill, its generated adapters/catalog metadata, and focused Profile
contract assertions covering all four domains and the specified Identity edge cases.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The pre-design gate passes:

- **P1.1-P1.4, P6.1-P6.6**: The spec and plan define explicit terminology, ordered contribution
  precedence, bounded clarification decisions, and deterministic fallback behavior.
- **P7.1-P7.5, P7.7**: The source skill keeps one Purpose, semantic metadata, maintainable section
  limits, and receives a MINOR version increment because capability is added without breaking the
  existing Inputs, Outputs, schema, or acceptance contract.
- **P8.2-P8.4**: Existing interaction order is changed only where behavior depends on it, and the
  Verification section will state checkable outcomes.
- **P9.1-P9.4**: The Profile skill continues to reference the shared record template rather than
  reproducing its retained structure.
- **P12A.1-P12A.4**: Profile remains the owner of Identity interaction and acceptance; Setup,
  clarify, and shared governance remain owners of their existing responsibilities.

No violations require complexity tracking. The post-design gate will confirm generated adapter
correspondence, protected-path integrity, section limits, and the focused contract coverage.

## Project Structure

### Documentation (this feature)

```text
specs/136-profile-substantive-re-evaluation/
├── plan.md              # This file
├── research.md          # Phase 0 research decisions
├── data-model.md        # Phase 1 entity and lifecycle model
├── quickstart.md        # Phase 1 validation guide
├── contracts/           # Not needed: no new external interface
└── tasks.md             # Phase 2 output from /speckit-tasks
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-profile/SKILL.md       # authoritative source skill
├── tools/tests/                          # Profile and feature contract tests
├── tools/generate-*.sh                   # adapter/catalog generators
├── tools/.adapter-manifest               # generated correspondence metadata
└── catalog/                              # generated skill catalog metadata
.agents/skills/highway-profile/SKILL.md   # generated adapter
.claude/skills/highway-profile/SKILL.md   # generated adapter
.github/skills/highway-profile/SKILL.md   # generated adapter
.cursor/skills/highway-profile/SKILL.md   # generated adapter
```

**Structure Decision**: This is a documentation-defined skill suite. The authoritative source is
`.highway/skills/highway-profile/SKILL.md`; generated adapters and catalog metadata are regenerated
from it. Verification belongs in `.highway/tools/tests`, with no application source tree or new
external interface contract.

## Complexity Tracking

No constitution violations. No complexity exceptions are required.

## Post-Design Constitution Check

PASS. The design adds no retained fields or external interfaces, keeps the source skill as the
single authoring surface, and confines generated changes to adapter/catalog outputs. The planned
verification covers P6 deterministic decision boundaries, P7 semantic versioning and maintainability,
P8 checkable outcomes, P9 shared-template ownership, and P12A transient reasoning and accepted-context
re-evaluation. Protected governance, setup, clarify, template, and schema artifacts remain outside
the implementation scope.

Implementation complete: Feature 136 focused contracts and the full repository suite pass (65
passed, 0 failed). Generated Profile adapters and catalog metadata were regenerated from the
5.3.0 source skill.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
