# Implementation Plan: Recommendation Exploration Simplification Pass

**Branch**: `174-recommendation-exploration-simplification` | **Date**: 2026-10-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/174-recommendation-exploration-simplification/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Simplify the Objective, Control, and NFR creation instructions so Recommendation Presentation,
Recommendation Exploration, each domain Development Lifecycle, and Queue and Acceptance Boundaries
own behavior. Creation Workflow will only orchestrate those sections and the canonical no-recommendation
path. User-facing examples will describe review of selected artifacts while retaining queue mechanics
as internal lifecycle concepts. Authoritative skill sources will be edited first, then generated
adapters, catalogs, and focused contract tests will be regenerated or updated through existing tools.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown and POSIX/Bash 3.2.57 validation scripts

**Primary Dependencies**: Existing Highway skill sources, Spec Kit artifacts, and repository generators

**Storage**: N/A; no persisted runtime model changes

**Testing**: `.highway/tools/tests/run-all.sh`, focused skill contract tests, adapter/catalog correspondence checks, `git diff --check`

**Target Platform**: macOS and distributed Highway skill trees

**Project Type**: Documentation-driven multi-agent skill suite

**Performance Goals**: No runtime performance change; validation remains bounded by the existing repository suite

**Constraints**: Preserve existing lifecycle, ownership, acceptance, persistence, continuation, and explicit-finish behavior; do not add dependencies or new workflow concepts

**Scale/Scope**: Three authoritative skills, their generated adapters/catalog entries, and focused validation tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

- Packaging Gate: N/A; generated and source skill artifacts are already within the declared shipped paths, but no development-only reference will be added (D1.1, D1.2, D6.2).
- Toolchain Gate: N/A; no `.highway/tools/` script is changed (D2.1-D2.4).
- Generator Gate: N/A; no generator implementation is changed (D4.1-D4.4).
- Correspondence Gate: PASS; authoritative skill inputs to the declared generators will be regenerated and checked for correspondence (D4.5-D4.7).
- Validation Gate: PASS; focused contract assertions will be added or amended without weakening existing coverage (D3.4-D3.6).
- Skill Content Gate: PASS in plan; the source skill changes will be reviewed against the Highway Skills Constitution by rule IDs (D1.5), and shared-library dependencies will be revalidated if any are touched (D8.1).

Verification gates:

- Begin from a passing `.highway/tools/tests/run-all.sh` result (D3.1).
- End with a passing `.highway/tools/tests/run-all.sh` result and record requirement coverage separately from check results (D3.2, D7.3).
- Update every live generated or source document that names the changed behavior and verify references (D6.1-D6.2).

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
├── skills/
│   ├── highway-objectives/SKILL.md
│   ├── highway-controls/SKILL.md
│   └── highway-nfrs/SKILL.md
└── tools/
  ├── generate-agent-adapters.sh
  ├── generate-catalog.sh
  ├── generate-instructions.sh
  ├── generate-library-catalog.sh
  └── tests/

.github/skills/
.claude/skills/
.cursor/skills/
.agents/skills/
.highway/catalog/
```

**Structure Decision**: The repository uses authoritative Markdown skill sources under `.highway/skills/`.
Generated agent adapters and catalogs are derived outputs and must be refreshed after source edits.
Focused contract tests remain under `.highway/tools/tests/`; Feature 174 design and validation records
remain under `specs/174-recommendation-exploration-simplification/`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The plan introduces no constitution violations or additional architectural projects. |

## Post-Design Constitution Check

- D1.5: PASS. This plan records the applicable Constitution and Highway Skills Constitution gates by rule ID.
- D3.1-D3.3: PASS pending implementation validation. The implementation must begin from the passing suite, amend focused tests for this behavioral contract change, and finish with the passing suite.
- D3.5-D3.6: PASS pending implementation evidence. Existing assertions will not be weakened, and changed contract behavior will have a focused failing-before/fixed-after check recorded in the implementation work.
- D4.7: PASS pending implementation regeneration. All declared generators will be run after authoritative skill sources change.
- D6.1-D6.2: PASS pending implementation review. Source skills, focused tests, generated surfaces, and cross-references naming the changed behavior will be kept current and resolvable.
- D8.1: N/A. No shared library artifact is changed by this feature.

No design decision introduces a new dependency, persisted state, external interface, lifecycle stage,
ownership model, or development-only reference into a shipped artifact.
