# Implementation Plan: Highway Reference Architecture Workflow

**Branch**: `175-highway-architecture` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/175-highway-architecture/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Create a source-first `highway-architecture` skill that consumes exactly one accepted ADR and
publishes one deterministic, conceptual Reference Architecture. The implementation will follow the
existing ADR workflow and shared output-template contracts, adding architecture-specific record and
catalog templates, read-only governance consumption, catalog-owned `ARCHXXXXXX` allocation,
atomic persistence, focused contract tests, and regenerated agent/catalog surfaces.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract and POSIX/Bash 3.2-compatible shell test tooling

**Primary Dependencies**: Existing Highway shared templates, catalogs, generators, validators, and test harness; no new runtime dependency

**Storage**: Repository-owned Markdown records and catalogs under the user-owned `architectures/` path

**Testing**: Focused shell contract tests plus `.highway/tools/tests/run-all.sh`, adapter coverage, validation, and `git diff --check`

**Target Platform**: macOS default Bash 3.2 and the distributed Highway skill trees

**Project Type**: Repository skill and deterministic Markdown artifact workflow

**Performance Goals**: Complete ordinary architecture generation within the existing shell workflow without introducing a new service or dependency; no runtime throughput target applies

**Constraints**: Immutable upstream artifacts, catalog-owned identifiers, deterministic output, atomic record/catalog writes, no timestamps or random values, no implementation authorization, Bash 3.2 compatibility, and no new runtime dependency

**Scale/Scope**: One accepted ADR to one proposed Reference Architecture per invocation; optional Profile, Objective, Control, and NFR context; MVP excludes capability artifacts, diagrams, threat models, scoring, and implementation generation

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
| Skill Content Gate | PASS | The skill plan will satisfy the delegated Highway Skills Constitution checks listed below. |

### Skill content gates

The planned skill will be checked against P7.1-P7.4, P7.7, P8.2-P8.7, P9.1-P9.8, P10.1,
P11.1-P11.4, and P13.2. It will declare one purpose and semantic version, reference the shared
templates instead of duplicating their generic structure, declare every input and written path,
preserve upstream ownership, use deterministic criteria, and assign acceptance/persistence to the
architecture workflow. No gate violation is known.

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
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
.highway/skills/highway-architecture/SKILL.md
.highway/library/templates/output/architecture-record.md
.highway/library/templates/output/architecture-catalog.md
.highway/tools/tests/highway-architecture-onboarding.test.sh
.github/skills/highway-architecture/SKILL.md
.claude/skills/highway-architecture/SKILL.md
.cursor/skills/highway-architecture/SKILL.md
.agents/skills/highway-architecture/SKILL.md
specs/175-highway-architecture/
```

**Structure Decision**: Add one authoritative skill under `.highway/skills/`, two shared output
templates under `.highway/library/templates/output/`, one focused shell contract test, and
regenerate all declared agent adapters and catalogs. Runtime architecture records and catalogs are
written by the future skill to the user-owned `architectures/` path and are not committed as source
fixtures in this feature.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No constitution violations require justification.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|

### Post-design re-check

PASS. The design keeps all shipped behavior behind the source skill and shared templates, names
every output path, preserves ADR and governance ownership, uses deterministic catalog allocation,
and introduces no runtime dependency. The contract and quickstart explicitly cover malformed,
blocked, missing, duplicate, and write-failure cases, repeated-run determinism, generated-surface
regeneration, and the complete repository suite.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
