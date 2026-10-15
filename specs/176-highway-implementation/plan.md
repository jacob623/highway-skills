# Implementation Plan: Highway Reference Implementation Workflow

**Branch**: `176-highway-implementation` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/176-highway-implementation/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Create a source-first `highway-implementation` skill that consumes exactly one accepted
`ARCH######` Reference Architecture and publishes one deterministic, conceptual-to-realization
Reference Implementation with a catalog-owned `RI######` identifier. The implementation will follow
the existing Highway architecture and ADR patterns, adding implementation-specific output templates,
read-only governance consumption, technology-realization rules, lifecycle mappings, atomic
persistence, focused contract tests, and regenerated agent/catalog surfaces.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract and POSIX/Bash 3.2-compatible shell test tooling

**Primary Dependencies**: Existing Highway shared templates, catalogs, generators, validators, and
test harness; no new runtime dependency

**Storage**: Repository-owned Markdown Reference Implementation records and catalogs under the
user-owned `implementations/` path

**Testing**: Focused shell contract tests plus `.highway/tools/tests/run-all.sh`, adapter coverage,
validation, and `git diff --check`

**Target Platform**: macOS default Bash 3.2 and the distributed Highway skill trees

**Project Type**: Repository skill and deterministic Markdown artifact workflow

**Performance Goals**: Complete ordinary implementation generation within the existing repository
workflow without introducing a new service or dependency; no runtime throughput target applies

**Constraints**: Immutable upstream artifacts, catalog-owned identifiers, deterministic output,
atomic record/catalog writes, no volatile metadata, no executable code, no deployment authorization,
Bash 3.2 compatibility, and no new runtime dependency

**Scale/Scope**: One accepted Reference Architecture to one proposed Reference Implementation per
invocation; optional Clarification, Profile, Objective, Control, and NFR context; MVP excludes plans,
tasks, source code, infrastructure definitions, deployment, and self-service productization

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Verdict | Evidence / planned check |
|------|---------|--------------------------|
| Packaging Gate | PASS | Planned shipped outputs avoid `.specify/` and `specs/` references; generated paths will be checked against D1.1, D1.2, and D6.2. |
| Toolchain Gate | PASS | Any new shell test uses Bash 3.2-compatible syntax and only the declared toolchain under D2.1-D2.4. |
| Generator Gate | N/A | No generator script is modified. |
| Correspondence Gate | PASS | Adding the source skill and shared templates triggers regeneration and adapter/catalog correspondence checks under D4.5-D4.7. |
| Validation Gate | PASS | New contract tests will be evaluated against existing fixtures and will not weaken prior assertions under D3.4-D3.5. |
| Skill Content Gate | PASS | The planned skill will satisfy the applicable Highway Skills Constitution checks for identity, ownership, shared templates, deterministic behavior, and output scope. |

The planned skill will be checked against P7.1-P7.4, P7.7, P8.2-P8.7, P9.1-P9.8, P10.1,
P11.1-P11.4, and P13.2. It will declare one purpose and semantic version, reference shared
templates instead of duplicating generic structure, declare inputs and written paths, preserve
upstream ownership, use deterministic criteria, and assign acceptance/persistence to the
implementation workflow.

## Project Structure

### Documentation (this feature)

```text
specs/176-highway-implementation/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-implementation/SKILL.md
.highway/library/templates/output/implementation-record.md
.highway/library/templates/output/implementation-catalog.md
.highway/tools/tests/highway-implementation-onboarding.test.sh
.github/skills/highway-implementation/SKILL.md
.claude/skills/highway-implementation/SKILL.md
.cursor/skills/highway-implementation/SKILL.md
.agents/skills/highway-implementation/SKILL.md
specs/176-highway-implementation/
```

**Structure Decision**: Add one authoritative skill under `.highway/skills/`, two shared output
templates under `.highway/library/templates/output/`, one focused shell contract test, and
regenerate all declared agent adapters and catalogs. Runtime implementation records and catalogs
are written by the future skill to the user-owned `implementations/` path and are not committed as
source fixtures in this feature.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature uses the existing repository skill, template, generator, and test structure. |

### Post-design re-check

PASS. The design keeps shipped behavior behind the source skill and shared templates, names every
output path, preserves Reference Architecture and governance ownership, uses deterministic catalog
allocation, and introduces no runtime dependency. The contract and quickstart cover malformed,
blocked, missing, duplicate, non-accepted, and write-failure cases, repeated-run determinism,
technology-choice evidence, lifecycle mappings, generated-surface regeneration, and the complete
repository suite.
