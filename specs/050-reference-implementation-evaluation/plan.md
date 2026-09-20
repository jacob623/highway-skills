# Implementation Plan: Reference Implementation Evaluation

**Branch**: `050-reference-implementation-evaluation` | **Date**: 2026-09-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/050-reference-implementation-evaluation/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Formalize Reference Implementation evaluation as an advisory, deterministic tie-break stage for
Discovery. The design adds explicit matching and unique-counting rules, preserves Recommendation
score and confidence inputs, and hands only advisory evidence to ADR. Existing Discovery,
Reference Architecture, catalog, and ADR contracts remain authoritative outside this feature.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown specifications and Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway Discovery skill, shared templates, catalog conventions,
and shell test harness

**Storage**: Repository-owned Markdown artifacts and authoritative catalogs; no new storage

**Testing**: Existing `.highway/tools/tests/` shell tests, skill validation, structural Markdown
checks, and deterministic repeated-run checks

**Target Platform**: macOS and other supported environments using the distributed Highway tree

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Complete evaluation within the existing bounded Discovery transaction;
Reference Implementation evaluation must not require network access or unbounded search

**Constraints**: Advisory-only behavior; explicit deterministic references only; no score or
confidence contribution; no mutation of source baselines or ADR records; Bash 3.2 compatibility
for validation scripts; no new runtime dependency

**Scale/Scope**: Repository-owned Reference Implementation catalogs evaluated within one Discovery
record; counts are bounded by the authoritative catalog and deduplicated by stable identifier

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change is limited to the development-only `specs/` feature record and does not modify shipped
artifacts, tools, skills, libraries, generators, or validation checks.

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | N/A | No shipped path is modified. |
| Toolchain Gate | N/A | No `.highway/tools/` file is modified. |
| Generator Gate | N/A | No generator is modified. |
| Correspondence Gate | N/A | No generator input or skill directory is modified. |
| Validation Gate | N/A | No validation check is added or modified by the planning artifacts. |
| Skill Content Gate | N/A | No `.highway/skills/` or `.highway/library/` file is modified by this plan. |

Constitution rules D1.1, D1.2, D1.5, D1.6, D2.1-D2.4, D3.3-D3.8, D4.1-D4.7, D6.1-D6.2,
and D8.1 are therefore not triggered by the documentation-only design scope.

**Post-Design Re-evaluation**: PASS. Phase 0 and Phase 1 add only development-side Markdown
artifacts under this feature directory. The contracts document existing internal workflow
boundaries; they add no shipped dependency, generator input, validation check, skill content, or
runtime interface. All gates remain N/A, and no complexity exception is required.

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
specs/050-reference-implementation-evaluation/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── reference-implementation-evaluation-contract.md
│   └── recommendation-tie-break-contract.md
└── checklists/
  └── requirements.md
```

**Structure Decision**: This feature is implemented and validated through repository Markdown
artifacts and the existing Highway shell test harness. No application source tree is introduced;
contracts describe the Discovery and ADR handoff behavior in the feature directory.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| None | N/A | The design stays within existing repository documentation and workflow boundaries. |
