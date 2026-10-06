# Implementation Plan: Profile Runtime Separation Cleanup

**Branch**: `143-profile-runtime-separation` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/143-profile-runtime-separation/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Refactor the source `highway-profile` skill so it describes current Profile-specific meaning,
acquisition, readiness, persistence, and downstream boundaries while delegating shared interaction
and authority mechanics to the finalized runtime documents. The implementation will replace the
obsolete-format branches and duplicated Enrichment guidance, add a focused static contract for the
new responsibility split, update only directly invalidated Profile guards, and regenerate declared
agent adapters from the source skill.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract; Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway Skills Constitution, Experience Standard, Highway Identity,
Profile template, and Spec Kit validation scripts

**Storage**: Markdown repository artifacts; no new storage

**Testing**: Focused static-document contracts and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill trees on macOS and other Bash-compatible environments

**Project Type**: Internal documentation and shell-validation repository

**Performance Goals**: No runtime performance change; keep the Profile skill substantially smaller and easier to execute

**Constraints**: Do not modify `profile-record.md`, `experience-standard.md`, `constitution.md`, or
`highway-identity.md`; preserve Profile schema, operations, readiness, acceptance, persistence, and
generated adapter correspondence; use ASCII-compatible Bash validation.

**Scale/Scope**: One source skill, its declared generated adapters, focused Profile guards, and the
Feature 143 design artifacts; no new external interface.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Rule / gate | Status | Evidence |
|---|---|---|
| D1.1 Layer separation and shippability | PASS | Change is confined to the Profile skill contract, its generated copies, and direct validation records. |
| D1.3 Non-restatement | PASS | Shared interaction and authority behavior is cited, not copied; protected runtime documents remain unchanged. |
| D1.4 Cross-document references | PASS | Profile references the Experience Standard, Constitution, Highway Identity, and retained template by their existing roles. |
| D2.1 Environment discipline | PASS | Validation remains Bash 3.2-compatible and uses the repository's existing scripts. |
| D3.1/D3.2 Verification before and after | PASS | Baseline focused guards and the full suite will run before completion and after implementation. |
| D3.5 Protected artifact scope | PASS | The four protected documents and retained template are explicit exclusions in the feature spec. |
| D4.5-D4.7 Generated artifact integrity | PASS | Source changes will be followed by the existing adapter generator and correspondence checks. |
| D6.1 Documentation currency | PASS | Plan, research, data model, quickstart, tasks, and implementation records describe the same current-state contract. |

No gate violations require a complexity exception.

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
.highway/skills/highway-profile/SKILL.md       # source skill contract
.github/skills/highway-profile/SKILL.md        # generated adapter copy
.claude/skills/highway-profile/SKILL.md        # generated adapter copy
.cursor/skills/highway-profile/SKILL.md        # generated adapter copy
.agents/skills/highway-profile/SKILL.md        # generated adapter copy
.highway/tools/tests/profile-*.test.sh         # existing Profile contracts
.highway/tools/tests/feature-*.test.sh         # dependent historical guards
.highway/tools/tests/run-all.sh                # repository validation entry point
```

**Structure Decision**: This is a source-document change with generated adapter outputs and static
shell contracts. No application source tree, external API contract, or new runtime service is needed.

## Complexity Tracking

No complexity violations.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
