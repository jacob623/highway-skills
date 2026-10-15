# Implementation Plan: Highway Architecture and Implementation Invocation Guards

**Branch**: `177-highway-architecture-invocation` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/177-highway-architecture-invocation/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add explicit direct-invocation guards to `highway-architecture` and `highway-implementation`.
Each skill will request its required upstream identifier when omitted, reject implicit source
selection, validate the supplied identifier and resolved source using existing canonical validators,
and preserve the current no-write and traceability boundaries. The implementation is a focused
update to the two authoritative Markdown skill contracts, their contract tests, generated adapters,
and generated catalog metadata; existing architecture and implementation generation remains owned
by Features 175 and 176.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible test tooling and Markdown skill contracts

**Primary Dependencies**: Existing Highway Skills Constitution, Experience Standard, catalogs,
shared output templates, and canonical validation helpers

**Storage**: No new storage; existing ADR, architecture, and implementation catalogs and records
remain authoritative

**Testing**: `.highway/tools/tests/highway-architecture-onboarding.test.sh`,
`.highway/tools/tests/highway-implementation-onboarding.test.sh`, focused validator checks, and
`.highway/tools/tests/run-all.sh`

**Target Platform**: macOS default Bash 3.2.57 and distributed agent skill consumers

**Project Type**: Markdown-based multi-agent skill suite with Bash validation and generation tooling

**Performance Goals**: Preserve existing validator and generator runtime; invocation guidance adds
 no new external process or runtime dependency

**Constraints**: Exact user-visible prompt literals; one explicit identifier; no implicit selection;
validation before persistence; no partial writes; deterministic output; generated artifacts must be
regenerated rather than hand-edited; Bash 3.2 compatibility

**Scale/Scope**: Two authoritative skills, two focused contract tests, their generated adapters,
catalog metadata, and one combined invocation contract; no new durable entity or schema

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | PASS | D1.1, D1.2, and D6.2 remain satisfied; no development path is added to shipped content. |
| Toolchain Gate | PASS | D2.1-D2.4; no new script dependency or non-portable shell construct is required. |
| Generator Gate | N/A | No generator script is changed. |
| Correspondence Gate | PASS | D4.5-D4.7; both source skills will be regenerated into every declared adapter and catalog surface. |
| Validation Gate | PASS | D3.4-D3.5; existing focused tests are amended with missing-input and explicit-source assertions without weakening prior checks. |

### Skill Content Gate

PASS against the Highway Skills Constitution. Existing frontmatter, required sections, ownership,
determinism, error handling, no-write, and output boundaries remain intact; the new direct-invocation
guidance is added to the owning skills and verified by their existing validators and focused tests.

### Post-Design Gate

PASS. The design introduces no new dependency, persistence schema, generator, or ownership boundary.
The canonical validators selected during clarification remain the sole completeness and readiness
definitions for both source types.

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
├── skills/
│   ├── highway-architecture/SKILL.md
│   └── highway-implementation/SKILL.md
├── catalog/index.json
└── tools/tests/
  ├── highway-architecture-onboarding.test.sh
  └── highway-implementation-onboarding.test.sh

.github/skills/
├── highway-architecture/SKILL.md
└── highway-implementation/SKILL.md

.claude/skills/
├── highway-architecture/SKILL.md
└── highway-implementation/SKILL.md

.cursor/skills/
├── highway-architecture.mdc
└── highway-implementation.mdc
```

**Structure Decision**: Preserve the existing source-skill, focused-test, catalog, and generated
adapter structure. Feature 177 changes only the two owning skill contracts and their corresponding
test assertions; it does not introduce application source directories or a runtime service.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature fits the existing two-skill contract and generated-artifact structure. |
