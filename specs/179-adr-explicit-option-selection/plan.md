# Implementation Plan: Explicit ADR Option Selection

**Branch**: `179-adr-explicit-option-selection` | **Date**: 2026-10-15 | **Spec**: `specs/179-adr-explicit-option-selection/spec.md`

**Input**: Feature specification from `specs/179-adr-explicit-option-selection/spec.md`

## Summary

Move option selection ownership from automatic ADR tie-breaking to explicit user input. Require exactly one Discovery and one option identifier for ADR creation, provide a no-write decision prompt when the option is omitted, reject options outside the Discovery, and preserve Discovery recommendation evidence as advisory context. Implement this as a focused contract change to the canonical ADR skill, shared ADR record contract, ADR tests, and generated copies/catalogs.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2-compatible tests

**Primary Dependencies**: Existing Highway ADR/Discovery catalogs, shared ADR templates, canonical validators, and adapter/catalog generators

**Storage**: Repository Markdown records and catalogs; no new persistence mechanism

**Testing**: `.highway/tools/tests/highway-adr.test.sh`, focused output-template checks, generated adapter/catalog correspondence, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Repository-local multi-agent skill distribution on macOS-compatible Bash

**Project Type**: Declarative skill and shared-output-contract framework

**Performance Goals**: Preserve existing bounded validation and allocation behavior; no new runtime performance target

**Constraints**: Source documents remain authoritative; failed, missing-option, and unsupported-option paths preserve all pre-operation bytes and allocate no ADR identifier

**Scale/Scope**: One ADR invocation resolves one Discovery and one option; existing catalogs and generated agent trees remain the supported scope

## Constitution Check

*GATE: PASS* - This feature changes an existing skill and shared output contract under the existing authoritative source and generator pattern. It adds no runtime service, dependency, persistence mechanism, executable product code, or new workflow owner. Existing source immutability, atomic publication, deterministic ordering, generated-surface correspondence, and shared-template validation remain applicable. No complexity violation requires justification.

## Project Structure

### Documentation (this feature)

```text
specs/179-adr-explicit-option-selection/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── adr-explicit-selection.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-adr/SKILL.md
.highway/library/templates/output/adr-record.md
.highway/library/templates/output/adr-catalog.md
.highway/tools/tests/highway-adr.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/catalog/
.github/skills/highway-adr/SKILL.md
.claude/skills/highway-adr/SKILL.md
.cursor/skills/highway-adr/SKILL.md
.agents/skills/highway-adr/SKILL.md
```

**Structure Decision**: Keep the existing declarative skill architecture. Modify only the canonical ADR skill, shared ADR record/template tests, and generated outputs. Discovery remains the owner of recommendation generation and scoring; ADR remains the owner of explicit selection, rationale, consequences, and commitment.

## Complexity Tracking

No violations. The existing skill, template, test, and generator structure directly fits the feature.
