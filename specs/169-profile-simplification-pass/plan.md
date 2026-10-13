# Implementation Plan: Profile Simplification Pass

**Branch**: `169-profile-simplification-pass` | **Date**: 2026-10-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/169-profile-simplification-pass/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Make the four existing Profile Discovery Contribution Opportunities the dominant development model by removing five competing standalone guidance sections, folding their useful structure-revealing concept into each opportunity, preserving Interpretation confidence, and removing verification claims that describe retired mechanisms. The implementation changes the authoritative Profile Markdown and directly corresponding static contracts, then regenerates delivery artifacts.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown guidance and Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Profile source, generated adapter/catalog scripts, Profile validators, and repository test harness

**Storage**: No new storage; retained Profile record and schema are unchanged

**Testing**: Focused static contract, existing Profile contracts, Profile validator, generated correspondence checks, and full Bash suite

**Target Platform**: Source-distributed agent skill trees on macOS-compatible shell tooling

**Project Type**: Source-first agent skill/documentation repository

**Performance Goals**: No runtime performance target; deterministic validation remains within existing suite expectations

**Constraints**: Preserve source-to-adapter byte identity, Bash 3.2 compatibility, Profile lifecycle and acceptance boundaries, and no new runtime or persistence surface

**Scale/Scope**: One authoritative Profile skill, four generated Profile adapters, catalog correspondence, Profile verification guidance, and directly corresponding static contracts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1.1 Layer separation**: PASS. The source-first Profile owner remains authoritative; no competing runtime or artifact owner is introduced.
- **D1.3 Non-restatement**: PASS. The plan cites existing Profile and Experience Standard contracts without copying unrelated governance rules into shipped guidance.
- **D2.1 Dependency discipline**: PASS. No dependency is added.
- **D3.1 Verification before completion**: PASS. Focused contracts, Profile validation, generated correspondence, and the full suite are named gates.
- **D3.8 Evidence honesty**: PASS. Static checks are documented as document evidence and do not claim to prove live conversational behavior.
- **D4.7 Generated correspondence**: PASS. Adapters, catalog artifacts, and manifest will be regenerated after source changes.
- **D6.1 Documentation currency**: PASS. Plan, research, data model, contract, quickstart, and tasks will describe the same bounded simplification.
- **D8.1 Shared-context impact**: N/A. No shared library artifact changes.

**Gate result**: PASS. No violation requires complexity tracking.

## Project Structure

### Documentation (this feature)

```text
specs/169-profile-simplification-pass/
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
.highway/skills/highway-profile/SKILL.md                         # authoritative guidance
.highway/tools/tests/feature-169-profile-simplification.test.sh # focused static contract
.highway/tools/tests/feature-152-profile-conversation-conformance.test.sh # aligned legacy contract
.github/skills/highway-profile/SKILL.md                          # generated adapter
.claude/skills/highway-profile/SKILL.md                          # generated adapter
.cursor/skills/highway-profile/SKILL.md                          # generated adapter
.agents/skills/highway-profile/SKILL.md                          # generated adapter
.highway/catalog/index.json                                      # generated catalog
.highway/catalog/index.md                                        # generated catalog
.highway/tools/.adapter-manifest                                 # generated correspondence manifest
```

**Structure Decision**: Keep the existing source-first Markdown skill structure. Add one focused static contract under `.highway/tools/tests/`, align directly coupled Profile verification assertions, update the authoritative source, and regenerate distributed adapters, catalog artifacts, and the adapter manifest. No application source tree, external interface, or durable data schema is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature stays within the existing Profile source and validation surfaces. |
