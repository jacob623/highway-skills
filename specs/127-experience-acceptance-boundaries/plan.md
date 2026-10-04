# Implementation Plan: Experience Acceptance Boundaries

**Branch**: `127-experience-acceptance-boundaries` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/127-experience-acceptance-boundaries/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the shared Experience Standard so recommendation selection is authoritative only for a
displayed Converged Proposal, while Working Ideas remain open to collaborative development. Remove
stale acknowledgment sequencing and align X2.19, X2.18, X2.21, X2.22, X2.25, contextual guidance,
Constructive Advisory, examples, and recommendation sketches with the existing Working Idea and
Converged Proposal lifecycle. Preserve X2.8, X2.36, the current inner and outer loops, readability
guidance, evolution-aware guidance, and all individual skills and schemas.

## Technical Context

**Language/Version**: Markdown governance document; no executable language

**Primary Dependencies**: Existing Experience Standard, Highway Skills Constitution, and Highway Identity guidance

**Storage**: N/A; no runtime or retained data is introduced

**Testing**: Existing shell-based `experience-standard-amendment.test.sh` and `highway-ux-alignment.test.sh`, plus the full repository suite

**Target Platform**: Repository documentation consumed by Highway workflows

**Project Type**: Governance/documentation artifact

**Performance Goals**: N/A; no runtime behavior or performance path changes

**Constraints**: Modify only `.highway/governance/experience-standard.md`; preserve stable X rule IDs, X2.8, X2.36, existing loops, schemas, templates, and individual skills

**Scale/Scope**: One shipped governance document, four rule rows, supporting guidance, examples, and recommendation sketches

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Pre-design gate review**:

- **D1.1, D1.2, D6.2 Packaging Gate**: PASS/N/A. The target is a shipped governance document, so
  its references must remain resolvable and the packaged tree must remain valid; no development
  artifact reference is introduced.
- **D1.3, D1.4**: PASS. The plan and target cite Constitution and Identity authority without
  restating their rule text.
- **D1.5**: N/A. No skill or library file is created or modified.
- **D2.1-D2.4 Toolchain Gate**: N/A. No script or runtime dependency changes.
- **D3.1-D3.3, D3.5-D3.8 Verification Gate**: Applicable at implementation. Existing tests will
  be updated only where their assertions encode superseded behavior; no requirement is weakened.
- **D3.4**: N/A. No new validation check is added.
- **D4.1-D4.7 Generator/Correspondence Gates**: N/A. No generator input or generated artifact changes.
- **D5.3**: PASS. The implementation inventory is limited to the named Experience Standard rows,
  guidance blocks, examples, and recommendation sketch; all unlisted content carries forward.
- **D6.1**: PASS. The target document is the live documentation being changed.
- **D8.1**: N/A. No shared library artifact changes.

No Constitution violation requires complexity tracking.

## Project Structure

### Documentation (this feature)

```text
specs/127-experience-acceptance-boundaries/
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
.highway/governance/
└── experience-standard.md  # sole implementation target

.highway/tools/tests/
├── experience-standard-amendment.test.sh  # existing focused contract
└── highway-ux-alignment.test.sh            # existing focused contract

specs/127-experience-acceptance-boundaries/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
└── quickstart.md
```

**Structure Decision**: This is a Markdown-only governance amendment. The shipped target remains
`.highway/governance/experience-standard.md`; existing test contracts validate its static content.
No source code, API, storage, schema, or contract directory is needed.

## Phase 0: Research

Research resolves the only design decisions: which acceptance rules conflict with the collaborative
lifecycle, which acknowledgment sequence is stale, what must remain byte-for-byte or materially
unchanged, and how existing tests should distinguish superseded assertions from weakened coverage.
Findings are recorded in `research.md`.

## Phase 1: Design

The conceptual model is recorded in `data-model.md`; no persisted data model or state store is
introduced. `quickstart.md` records focused structural, scope, preservation, and full-suite checks.
No contracts directory is created because the change exposes no new external interface.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | This feature uses one existing governance document and no new architectural component. |

## Post-Design Constitution Check

- **D1.1, D1.2, D6.2 Packaging/Documentation**: PASS. The planned target remains a shipped
  governance document with existing resolvable references and no development-tree dependency.
- **D1.3, D1.4, D5.3**: PASS. Research identifies the authoritative Constitution and Identity
  sources without copying their rule text; the changed-element inventory is explicit and unlisted
  content carries forward.
- **D2, D4, D8**: N/A. No scripts, generators, generated artifacts, shared library artifacts,
  runtime dependencies, or external interfaces are changed.
- **D3.1, D3.2**: Applicable at implementation. Focused tests and the full suite must be run before
  and after the target edit; any pre-existing or stale-suite result is reported honestly.
- **D3.3, D3.4, D3.5, D3.6, D3.7, D3.8**: Applied to the existing focused contracts. Test changes
  must preserve meaningful coverage, identify superseded behavior, and keep static document evidence
  distinct from behavioral claims.

The design passes the Constitution gates and is ready for task generation. The requested next
workflow sequence is `/speckit-tasks` followed by `/speckit-implement`.
