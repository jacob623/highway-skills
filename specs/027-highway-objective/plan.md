# Implementation Plan: Highway Objective

**Branch**: `027-highway-objective` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/027-highway-objective/spec.md`

## Summary

Create the shipped `highway-objectives` skill and its shared retained-record template. The skill
will manage user-owned Business Objective records under `library/objectives/`, maintain a
deterministic `library/governance/objectives.md` catalog, and report confirmed or declined
mutations without writing inside `.highway/`. Implementation will follow the existing
`highway-nfrs` and `highway-controls` conventions, with focused fixture-driven tests for action
routing, permanent identifiers, deterministic catalog generation, semantic versioning, and
transactional no-write behavior.

## Technical Context

**Language/Version**: Markdown skill contracts; Bash 3.2.57-compatible repository tests and helpers

**Primary Dependencies**: Existing Highway skill validator, library validator, catalog generator, adapter generator, and declared shell toolchain

**Storage**: User-owned Markdown records under `library/objectives/` and generated catalog at `library/governance/objectives.md`

**Testing**: Focused `highway-objectives` contract/behavior test, library/catalog correspondence tests, distribution packaging, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and GNU/Linux development environments using the distributed Highway tree

**Project Type**: Repository skill and user-owned governance artifact workflow

**Performance Goals**: Deterministic catalog generation and completion within the existing test-suite execution envelope

**Constraints**: No objective writes under `.highway`; no timestamps, random, or environment-derived values; identifiers never reused; Bash 3.2 compatibility; preserve user bytes on declined or failed operations

**Scale/Scope**: One new skill, one shared output template, one runtime catalog, and fixture-driven coverage for the ten supported actions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

| Gate | Verdict | Evidence |
|---|---|---|
| Packaging Gate | PASS | The new skill and shared template are shipped paths; the plan includes distribution classification, validation, adapter generation, and packaged-tree checks. |
| Toolchain Gate | PASS | New scripts use Bash 3.2.57-compatible constructs and the existing declared shell toolchain; no runtime package dependency is introduced. |
| Correspondence Gate | PASS | Adding `.highway/skills/highway-objectives/` and `.highway/library/templates/output/objective-record.md` requires catalog, adapter, manifest, and generated-output correspondence checks. |
| Validation Gate | PASS | The plan adds focused malformed-input, deterministic-output, identifier, version, and no-write tests before enabling the workflow. |
| Spec Record Gate | PASS | Feature 027 is the next sequential spec and does not modify completed Feature 024, 025, or 026 records. |
| Skill Content Gate | PASS | The new skill will cite the complete shared objective-record template and conform to the Highway Skills Constitution. |

Applicable Development Constitution rules: D1.1-D1.6, D2.1-D2.4, D3.1-D3.6, D4.1-D4.7,
D5.1-D5.4, D6.1-D6.2, D7.1-D7.3, and D8.1.

Applicable Highway Skills Constitution review: P1.1-P1.7, P2.1-P2.5, P3.1-P3.5, P4.1-P4.8,
P5.1-P5.5, P6.1-P6.6, P7.1-P7.3, P8.1-P8.4, and P9.1. The implementation must cite the
repository's approved authority sources where required by the skill constitution.

Applicable Highway Experience Standard review: X1.1-X1.5, X2.1, X4.1, X5.1-X5.2, and X6.1.

## Project Structure

### Documentation

```text
specs/027-highway-objective/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/objective-workflow.md
└── checklists/requirements.md
```

### Source and test paths

```text
.highway/
├── skills/highway-objectives/SKILL.md
├── library/templates/output/objective-record.md
└── tools/tests/
    ├── objective-management.test.sh
    └── fixtures/objective-management/

.github/skills/highway-objectives/SKILL.md
.claude/skills/highway-objectives/SKILL.md
.cursor/rules/highway-objectives.mdc

library/
├── objectives/OBJXXXXXX.md
└── governance/objectives.md
```

**Structure Decision**: Keep the source skill and reusable record template under `.highway/`,
generate agent adapters from the source skill, and keep all objective records/catalog output at
repository-root `library/` so the artifacts remain user-owned and outside the framework's own
governance tree. Use a focused shell test with temporary repositories/fixtures to avoid mutating
the live user baseline.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| None | N/A | The implementation uses the existing skill, library, test, catalog, and distribution surfaces. |
