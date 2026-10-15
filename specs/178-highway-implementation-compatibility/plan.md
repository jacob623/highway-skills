# Implementation Plan: Highway Implementation Compatibility Assessment

**Branch**: `178-highway-implementation-compatibility` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/178-highway-implementation-compatibility/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Elevate `highway-implementation` from a projection-only workflow into a validated realization
workflow. Require user-owned Implementation Selections, extract implementation-relevant
architecture responsibilities, assess deterministic coverage and compatibility before persistence,
and generate a Reference Implementation only from a `Compatible` result. Keep `Incomplete` and
`Incompatible` outcomes non-generating, preserve architecture authority and existing traceability,
and publish the compatibility assessment through the shared implementation record contract.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible validation tooling and Markdown skill/template contracts

**Primary Dependencies**: Existing Highway implementation skill, Reference Architecture catalog,
shared implementation output templates, canonical readiness/completeness validators, Controls,
NFRs, and generated adapter/catalog tooling

**Storage**: Existing architecture, implementation, Controls, and NFR records/catalogs; no new datastore

**Testing**: Existing implementation onboarding contract test, new compatibility fixtures/assertions,
shared template validation, generated adapter correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS default Bash 3.2.57 and distributed Highway skill consumers

**Project Type**: Markdown-based multi-agent skill suite with Bash validation and generation tooling

**Performance Goals**: Preserve existing static validation and generation runtime; no new external
process or runtime service

**Constraints**: User-owned selections are required; compatibility runs before allocation/persistence;
outcomes are exactly `Compatible`, `Incomplete`, or `Incompatible`; architecture remains authoritative;
recommendations remain unknown without evidence; no partial writes; deterministic ordering; Bash 3.2
compatibility; generated artifacts are regenerated rather than hand-edited

**Scale/Scope**: One authoritative implementation skill, one shared implementation record template,
focused onboarding/compatibility tests, generated adapters/catalog metadata, and Feature 178 design
artifacts; no new application source tree

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | PASS | D1.1, D1.2, D6.2; generated shipped surfaces remain free of development-only references. |
| Toolchain Gate | PASS | D2.1-D2.4; no new runtime dependency or non-portable shell construct is introduced. |
| Generator Gate | N/A | No generator script is modified. |
| Correspondence Gate | PASS | D4.5-D4.7; the changed skill/template inputs will be regenerated into declared adapters and catalogs. |
| Validation Gate | PASS | D3.3-D3.5; compatibility behavior adds focused assertions without weakening existing checks. |
| Skill Content Gate | PASS | D1.5; the plan records the Highway Skills Constitution review below. |

### Constitution Review

PASS against D1.5, D3.1-D3.8, D4.5-D4.7, D6.1-D6.2, and D8.1. The implementation skill and
shared output template are authoritative inputs, so dependent generated adapters and every skill
citing a changed shared template must be regenerated or revalidated. Existing Feature 176
implementation ownership and no-write behavior remain unchanged outside the compatibility boundary.

## Project Structure

### Documentation (this feature)

```text
specs/178-highway-implementation-compatibility/
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
├── skills/highway-implementation/SKILL.md
├── library/templates/output/implementation-record.md
├── catalog/index.json
└── tools/tests/
    ├── highway-implementation-onboarding.test.sh
    ├── implementation-compatibility.test.sh
    └── run-all.sh

.github/skills/highway-implementation/SKILL.md
.claude/skills/highway-implementation/SKILL.md
.cursor/skills/highway-implementation/SKILL.md
.agents/skills/highway-implementation/SKILL.md

specs/178-highway-implementation-compatibility/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/implementation-compatibility.md
└── tasks.md
```

**Structure Decision**: Preserve the existing source skill, shared output-template, focused test,
catalog, and generated adapter structure. Feature 178 adds compatibility behavior to the owning
implementation skill and its shared record contract; it does not create a runtime engine, service,
database, or separate brownfield workflow.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature fits the existing skill, template, test, and generated-artifact boundaries. |
