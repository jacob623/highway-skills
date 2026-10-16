# Implementation Plan: Highway Assessment

**Branch**: `183-highway-assessment` | **Date**: 2026-10-16 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Deliver the repository-native `highway-assessment` workflow. The canonical skill will load accepted
repository context, present retained open findings, analyze a requested domain, and guide advisory
finding review without mutating owning artifacts. Findings will persist in one validated Markdown
knowledge artifact with sequential `F###` display IDs, deterministic fingerprints, explicit statuses,
and revision-based stale-update rejection. Generated adapters and catalogs will be refreshed from the
canonical source.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract and POSIX-compatible Bash 3.2 test tooling

**Primary Dependencies**: Existing Highway shared-library validators, generators, and test harness

**Storage**: `.highway/library/knowledge/assessment-findings.md`

**Testing**: Focused shell contract test, skill/library validators, generated-artifact checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway repositories distributed through the supported agent adapter trees

**Project Type**: Repository skill and durable knowledge workflow

**Performance Goals**: Present retained open findings before new analysis; avoid repeated equivalent findings on repeated runs

**Constraints**: Bash 3.2 compatibility; no new runtime dependency; no assessment logic in other owner skills; no architecture, implementation, dependency, capability, inventory, or alternate finding artifact family; stale updates must not overwrite newer findings

**Scale/Scope**: MVP supports architecture, implementation, and portfolio domains over the accepted repository artifacts available in one Highway repository

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The design passes the constitution gates:

- Layer separation is preserved: assessment logic is owned by `highway-assessment`; existing artifact owners are not extended.
- The change is shippable through the canonical `.highway/skills` source and generated adapters rather than hand-edited outputs.
- Bash 3.2-compatible constructs and existing repository generators/tests are reused.
- Shared library knowledge uses the existing frontmatter and validation contract.
- Verification includes focused behavior/document checks, validators, regeneration, the full test suite, and whitespace validation.
- No new external dependency, identifier family, or unowned artifact family is introduced.

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
.highway/
├── skills/highway-assessment/SKILL.md
├── library/knowledge/assessment-findings.md
└── tools/tests/highway-assessment.test.sh
.github/skills/highway-assessment/SKILL.md
.claude/skills/highway-assessment/SKILL.md
.cursor/skills/highway-assessment/SKILL.md
.agents/skills/highway-assessment/SKILL.md
specs/183-highway-assessment/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

**Structure Decision**: Add the canonical skill, knowledge artifact, and focused test under the
existing `.highway` ownership boundaries. Use the existing generators for the four adapter trees
and catalog/manifests. Keep all feature design records under `specs/183-highway-assessment`.

## Phase 0: Research Summary

Research is recorded in [research.md](research.md). Key decisions are:

1. Assessment owns observation and review; other artifact owners remain unchanged.
2. Findings use the shared library frontmatter contract and a single Markdown table with explicit
  `Fingerprint` and `Revision` fields.
3. Fingerprints normalize line endings, trim, lowercase, collapse whitespace, and combine Category,
  Domain, and Finding Text. Sequential `F###` IDs are allocated only for new fingerprints.
4. Writes validate the complete in-memory record, compare the supplied revision with the stored
  revision, reject stale updates, and increment revision once on success.
5. Existing Highway generators and validators are sufficient; no new dependency or generator is
  required.

## Phase 1: Design Summary

The data model is defined in [data-model.md](data-model.md). User-facing and persistence contracts
are defined in [contracts/highway-assessment.md](contracts/highway-assessment.md) and
[contracts/assessment-findings.md](contracts/assessment-findings.md). Runnable validation scenarios
are in [quickstart.md](quickstart.md).

The post-design constitution check remains passing: the design adds no new owner boundary, generated
tree is refreshed from source, and validation covers the durable artifact and interactive contract.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature fits the existing skill, library, generator, and shell-test boundaries. |
