# Implementation Plan: Highway NFR Setup Experience

**Branch**: `096-nfr-setup-experience` | **Date**: 2026-09-27 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/096-nfr-setup-experience/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Extend `highway-nfrs` so Setup can move from durable Control-derived recommendations into
user-authored NFR discovery, while preserving NFR ownership of candidate state, records,
relationships, readiness, persistence, and completion. Keep the existing four-field readiness
contract unchanged and add a separate active-collection result with explicit `Continue` and
`Finished` semantics. Update Setup only to consume that owner result and request fresh readiness
after explicit finish. Regenerate adapters and extend focused contract and executable checks.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing NFR, Setup, Controls, shared output templates, Experience Standard, validators, test harness, and adapter generators; no new dependency

**Storage**: Existing NFR records, catalog, candidate-state projection, and generated adapters; no new retained artifact beyond the existing NFR-owned candidate state

**Testing**: NFR onboarding/management tests, Setup routing tests, UX alignment checks, readiness and output-template checks, skill validation, adapter correspondence, and full `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree consumed by GitHub Copilot, Claude Code, and Cursor; validation on macOS and supported GNU-like shell environments

**Project Type**: Repository-distributed agent skill suite with Markdown workflow contracts and shell validation

**Performance Goals**: Preserve bounded, deterministic contract evaluation and generation; no new runtime or network work

**Constraints**: Preserve existing records, identifiers, catalogs, relationships, atomicity, and readiness; keep collection completion separate from readiness; do not inspect NFR internals from Setup; preserve Bash 3.2 compatibility; regenerate derived artifacts

**Scale/Scope**: Canonical NFR and Setup skills, focused tests and fixtures, shared contract documentation, three generated NFR/Setup adapter representations, and repository-wide validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | Changed shipped skills and generated adapters must pass packaged-tree validation and path checks. |
| Toolchain Gate (D2.1-D2.4) | PASS | Existing Markdown and Bash 3.2-compatible utilities are reused; no runtime dependency is added. |
| Generator Gate (D4.1-D4.4) | N/A | No generator script is changed; declared generators run after canonical skill inputs change. |
| Correspondence Gate (D4.5-D4.7) | PASS | Canonical NFR and Setup skill changes require regeneration and adapter/catalog correspondence checks. |
| Validation Gate (D3.4-D3.5) | PASS | Focused checks extend existing fixtures and preserve assertions for prior candidate, readiness, and routing behavior. |

### Skill content gates

| Rule | Verdict | Evidence |
|---|---|---|
| P5.1-P5.5 | PASS | NFR and Setup retain explicit failure handling, ownership boundaries, and no-write guarantees. |
| P6.1/P6.6 | PASS | Collection, candidate, readiness, and Setup advancement use explicit owner states and deterministic ordering. |
| P8.3/P8.4 | PASS | Verification will cover derived recommendations, open discovery, explicit finish, fresh readiness, resume, and false completion. |
| P10.1/P10.2 | PASS | The amended NFR and Setup skills will receive Constitution and Experience Standard review. |

Process result: PASS. No unresolved gate violations or complexity exceptions.

## Project Structure

### Documentation (this feature)

```text
specs/096-nfr-setup-experience/
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
├── skills/highway-nfrs/SKILL.md
├── skills/highway-setup/SKILL.md
├── tools/tests/
│   ├── highway-nfr-onboarding.test.sh
│   ├── nfr-management.test.sh
│   ├── highway-setup.test.sh
│   ├── highway-setup-executable.test.sh
│   └── highway-ux-alignment.test.sh
└── tools/generate-agent-adapters.sh
.github/skills/highway-nfrs/SKILL.md
.github/skills/highway-setup/SKILL.md
.claude/skills/highway-nfrs/SKILL.md
.claude/skills/highway-setup/SKILL.md
.cursor/rules/highway-nfrs.mdc
.cursor/rules/highway-setup.mdc
```

**Structure Decision**: Reuse the existing canonical `.highway/skills` contracts and focused Bash
tests. Extend NFR owner behavior and the Setup consumer contract, document the collection/readiness
boundary in `contracts/`, and regenerate the three distributed adapter trees. No application source
tree, external interface, or new runtime component is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | Existing repository structure is sufficient. |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
