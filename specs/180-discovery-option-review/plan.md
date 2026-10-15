# Implementation Plan: Discovery Option Review and Implementation Exploration

**Branch**: `180-discovery-option-review` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/180-discovery-option-review/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Extend the canonical Discovery workflow so people can review and compare generated options and
explore advisory reference implementations and cost considerations before ADR selection. The
change remains documentation- and contract-driven: the Discovery skill defines the interaction and
ownership rules, the shared Discovery record template defines optional informational sections, and
focused tests prove read-only persistence, advisory labeling, deterministic evidence handling, and
preservation of the ADR boundary. Generated catalogs and agent adapters are regenerated from those
authoritative sources.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown and POSIX-compatible Bash 3.2 repository tooling

**Primary Dependencies**: Existing Highway Discovery skill, shared output templates, catalog and adapter generators, and shell contract tests

**Storage**: Git-tracked Markdown records and catalogs; option exploration itself is read-only

**Testing**: `.highway/tools/tests/highway-discovery.test.sh`, shared output-template tests, validators, generated correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill trees consumed by supported agent integrations

**Project Type**: Git-native conversational governance skill suite with generated agent adapters

**Performance Goals**: Option review and comparison should complete within the existing Discovery interaction; no new throughput target is introduced

**Constraints**: Read-only exploration preserves all pre-operation bytes, allocates no identifiers, creates no ADR, does not alter scores or recommendation selection, and uses only accepted or explicitly qualified advisory evidence

**Scale/Scope**: One completed Discovery at a time; one-option reviews and two-option comparisons; optional evidence for two through five existing Candidate Solution Options

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The plan passes the applicable development-time gates:

- **P1 Layer Separation and Shippability**: changes remain in canonical Markdown skills, shared templates, tests, and generated outputs; no runtime application layer or new dependency is introduced.
- **P6 Determinism**: identical Discovery inputs and evidence produce identical review, comparison, example, and cost presentation; timestamps, randomness, recency, and model preference do not select or rank options.
- **P7 Documentation Currency**: implementation-facing contracts cite the authoritative skill/template and remain aligned with generated adapters.
- **P9 Shared Output Contracts**: the Discovery skill continues to cite the complete shared Discovery record and catalog templates; optional sections remain in the shared record skeleton.
- **P11 Repository Context**: accepted Request, Objective, Control, NFR, and existing Discovery evidence remain read-only context; missing evidence is reported rather than invented.

No gate violation requires a complexity exception.

## Project Structure

### Documentation (this feature)

```text
specs/180-discovery-option-review/
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
.highway/
├── skills/highway-discovery/SKILL.md
├── library/templates/output/discovery-record.md
└── tools/tests/highway-discovery.test.sh
.github/skills/highway-discovery/SKILL.md
.claude/skills/highway-discovery/SKILL.md
.cursor/skills/highway-discovery/SKILL.md
.agents/skills/highway-discovery/SKILL.md
specs/180-discovery-option-review/
├── plan.md
├── research.md
├── data-model.md
├── contracts/discovery-option-review.md
└── quickstart.md
```

**Structure Decision**: Extend the canonical Discovery skill and shared Discovery record template,
add focused contract assertions in the existing Discovery test, and regenerate the four supported
agent adapters and catalog indexes. No source-code application tree is involved.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation was identified. |
