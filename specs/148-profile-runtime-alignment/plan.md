# Implementation Plan: Profile Runtime Architecture Alignment

**Branch**: `148-profile-runtime-alignment` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/148-profile-runtime-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the shipped Profile skill so Profile owns organizational-domain semantics, completeness,
acceptance, readiness, persistence, acquisition, and cross-domain reasoning while the Highway
Experience Standard owns generic collaboration and conversational convergence. Remove retired
runtime context and the Constitution failure-model dependency, replace the local convergence
procedure with an ownership boundary, preserve the Profile record contract, and regenerate all
Profile adapters after the source skill and focused validation contracts are updated.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract; Bash 3.2-compatible repository validation scripts

**Primary Dependencies**: Highway Experience Standard, Highway Identity context, existing Profile
record template, existing Profile owner helpers, and generated adapter/catalog tooling

**Storage**: Existing Markdown Profile at `.highway/library/knowledge/profile.md`; no schema change

**Testing**: Focused Profile contract suites and `bash .highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill trees on macOS and other declared shell environments

**Project Type**: Git-native governance skill suite with Markdown runtime contracts and shell validators

**Performance Goals**: No new runtime performance target; preserve existing Profile interaction and
readiness behavior.

**Constraints**: Do not modify Highway Identity, Highway Experience Standard, Highway Skills
Constitution, Setup, Objectives, Controls, NFRs, Profile record template, or Clarify. Do not add
runtime dependencies, retained collaboration fields, or readiness dimensions. Generated Profile
adapters must remain synchronized with the source skill.

**Scale/Scope**: One shipped skill, four generated agent adapters, focused Profile tests, and the
repository suite; no external API or persistence-schema expansion.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

- **D1.1/D1.2**: PASS. The change does not introduce development-path references into shipped
  artifacts and the packaged tree remains independently valid.
- **D2.1-D2.4**: N/A. No tool implementation or runtime dependency is added.
- **D3.1**: PASS. The repository suite is green before implementation planning.
- **D3.3**: PASS. The feature includes amendments to Profile-specific validation tests.
- **D3.5**: PASS. Existing assertions are preserved unless they encode the retired Profile behavior;
  each replacement remains explicit and narrower where appropriate.
- **D4.5-D4.7**: PASS. The source Profile skill is an input to catalog and adapter generation; all
  generated Profile artifacts will be regenerated and correspondence-tested.
- **D6.1/D6.2**: PASS. Profile-facing live documentation and referenced paths remain current and
  resolvable within the declared change boundary.
- **D8.1**: N/A. No shared library artifact changes.

### Skill content gate

- **P7.1/P7.2/P7.4/P7.6/P7.7/P8.3/P9.1-P9.8**: PASS subject to focused validation and the full
  repository suite. The Profile version will move from `8.1.0` to `9.0.0` because runtime
  dependencies and Profile-owned convergence/failure obligations are removed or redefined.

No gate violation requires a complexity exception.

### Post-design re-check

- **D1.1/D1.2**: PASS. Design artifacts remain development-only and introduce no shipped-path
  reference to `.specify/` or `specs/`.
- **D3.3/D3.5**: PASS. The design requires focused Profile contract updates without weakening
  existing protected behavior.
- **D4.5-D4.7**: PASS. The implementation sequence includes regeneration and correspondence
  validation for every Profile adapter and catalog input.
- **D6.1/D6.2**: PASS. All design references resolve within the repository.
- **Skill Content Gate**: PASS subject to final skill validation, focused Profile tests, adapter
  correspondence, and the full suite; no protected runtime artifact is part of the implementation
  scope.

## Project Structure

### Documentation (this feature)

```text
specs/148-profile-runtime-alignment/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Not required: no external interface is introduced
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-profile/SKILL.md
.highway/tools/tests/profile-behavior.test.sh
.highway/tools/tests/profile-runtime-separation.test.sh
.highway/tools/tests/profile-convergence-behavior.test.sh
.highway/tools/tests/highway-profile.test.sh
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
.highway/catalog/index.json
.highway/catalog/index.md
```

**Structure Decision**: Update the source Profile Markdown contract and its focused validation
surface, then regenerate the declared agent adapters and catalog artifacts. The retained Profile
template and other owner/runtime documents remain unchanged.

## Complexity Tracking

No constitution violations or complexity exceptions are required.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
