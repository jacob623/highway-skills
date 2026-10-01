# Implementation Plan: Update Profile Skill

**Branch**: `115-update-profile-skill` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/115-update-profile-skill/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the Profile skill from 4.0.0 to 5.0.0 so accepted evidence is re-evaluated before every unresolved canonical question, accepted website evidence can produce grounded recommendations immediately, accepted mutations are persisted before dependent results, and guided completion emits one user-relevant synthesis. Preserve the four readiness domains and retained schema 3.0.0. Implement the contract in the authoritative Markdown skill, synchronize all distributed copies, amend focused Bash verification, and validate the complete repository suite.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts and Bash 3.2-compatible verification scripts

**Primary Dependencies**: Existing Highway Experience Standard 5.0.0, Highway Constitution 6.0.0, and repository test helpers; no new dependency

**Storage**: Markdown retained Profile at `.highway/library/knowledge/profile.md`; template schema 3.0.0

**Testing**: Focused Profile Bash contract tests plus `.highway/tools/tests/run-all.sh`, distribution-copy diffs, and `git diff --check`

**Target Platform**: Distributed Highway skill trees consumed by supported agents; checks must run on macOS Bash 3.2 and the declared toolchain

**Project Type**: Internal governance skill/documentation repository with Bash validation tooling

**Performance Goals**: Deterministic, repository-local validation; no runtime latency target

**Constraints**: Preserve four readiness domains and schema 3.0.0; do not restate generic Experience Standard rules; do not add runtime dependencies; keep distributed copies synchronized; preserve Bash 3.2 compatibility

**Scale/Scope**: One Profile skill, five synchronized copies, existing Profile validators/tests, and no changes to unrelated governance skills or stale follow-up documents

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The plan modifies a skill and validation tests, so the following gates apply:

- **D1.3/D1.4**: Cite the Highway Skills Constitution and Experience Standard by reference; do not copy their rule sentences into Profile or this plan.
- **D1.5**: This Constitution Check records the applicable rule IDs for the skill/library change.
- **D2.1-D2.4**: Keep all verification scripts Bash 3.2-compatible, use the declared toolchain, preserve cross-platform utility flags, and add no runtime dependency.
- **D3.1-D3.5**: Start from the passing suite, amend at least one focused test for the behavior change, evaluate fixtures before enabling new assertions, do not weaken unrelated assertions, and finish with the full suite passing.
- **D4.5-D4.7**: Synchronize every distributed Profile copy and validate source-to-adapter correspondence after the source change.

**Gate status before Phase 0**: PASS by repository state and planned approach. No violation or complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/115-update-profile-skill/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 decisions
├── data-model.md        # Phase 1 retained Profile and recommendation model
├── quickstart.md        # Phase 1 validation guide
└── tasks.md             # Phase 2 output (/speckit-tasks command - not created here)
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
├── skills/highway-profile/SKILL.md
├── library/templates/output/profile-record.md
└── tools/
  ├── validate-profile.sh
  ├── lib/profile.sh
  └── tests/
    ├── profile-behavior.test.sh
    ├── profile-structure.test.sh
    ├── profile-context-contract.test.sh
    ├── profile-template-migration.test.sh
    └── run-all.sh

.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
```

**Structure Decision**: This is a distributed documentation-and-verification change. The authoritative Profile skill is maintained under `.highway/skills`; the four adapter copies are synchronized outputs. Existing Bash validators and tests own contract verification. No `contracts/` directory is needed because the repository exposes no external API or runtime service.

## Complexity Tracking

No constitution violations or additional architectural complexity identified.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
