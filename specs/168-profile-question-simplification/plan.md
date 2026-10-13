# Implementation Plan: Profile Question-Bias Simplification

**Branch**: `168-profile-question-simplification` | **Date**: 2026-10-13 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/168-profile-question-simplification/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Reduce competing question-centric guidance in the authoritative Profile skill so grounded reasoning normally becomes content inside an active structured starting point and the person reacts through the existing Discovery Contribution Opportunity. Preserve focused consequential-ambiguity questions, canonical fallback questions, existing convergence and acceptance boundaries, and generated adapter correspondence. The implementation changes source Markdown and its static validation contract only; adapters and catalog artifacts are regenerated from the source.

## Technical Context

**Language/Version**: Markdown guidance and Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Profile source, generated adapter/catalog scripts, and repository test harness

**Storage**: No new storage; retained Profile data and schema are unchanged

**Testing**: Existing Bash static-document contracts, Profile validator, adapter generator, catalog generator, and full suite

**Target Platform**: Source-distributed agent skill trees on macOS-compatible shell tooling

**Project Type**: Source-first agent skill/documentation repository

**Performance Goals**: No runtime performance target; validation remains deterministic and completes within the existing repository-suite expectations

**Constraints**: Preserve source-to-adapter byte identity, Bash 3.2 compatibility, existing Profile lifecycle and acceptance boundaries, and no new runtime or persistence surface

**Scale/Scope**: One authoritative Profile skill, four generated Profile adapters, catalog correspondence, and directly corresponding static contracts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1.1 Layer separation**: PASS. The change preserves the source-first Profile owner and does not create a competing runtime or artifact owner.
- **D1.3 Non-restatement**: PASS. The plan cites the Experience Standard and existing Profile contract rather than copying unrelated governance rules into shipped guidance.
- **D2.1 Dependency discipline**: PASS. No new dependency is introduced.
- **D3.1 Verification before completion**: PASS. The focused contract, Profile validator, generated correspondence, catalog generation, and full suite are named validation gates.
- **D3.8 Evidence honesty**: PASS. Static contracts are documented as document evidence and do not claim to prove runtime conversational behavior.
- **D4.7 Generated correspondence**: PASS. All adapters and catalog artifacts will be regenerated after the source change.
- **D6.1 Documentation currency**: PASS. The plan, research, data model, quickstart, contract, and tasks will describe the same bounded change.
- **D8.1 Shared-context impact**: N/A. No shared library artifact is changed.

**Gate result**: PASS. No violation requires complexity tracking.

## Project Structure

### Documentation (this feature)

```text
specs/168-profile-question-simplification/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-profile/SKILL.md                         # authoritative guidance
.highway/tools/tests/feature-168-profile-question-simplification.test.sh # focused static contract
.github/skills/highway-profile/SKILL.md                          # generated adapter
.claude/skills/highway-profile/SKILL.md                          # generated adapter
.cursor/skills/highway-profile/SKILL.md                          # generated adapter
.agents/skills/highway-profile/SKILL.md                          # generated adapter
.highway/catalog/index.json                                      # generated catalog
.highway/catalog/index.md                                        # generated catalog
.highway/tools/.adapter-manifest                                 # generated correspondence manifest
```

**Structure Decision**: Keep the existing source-first Markdown skill structure. Add one focused static contract under `.highway/tools/tests/`; update the authoritative Profile source; regenerate distributed adapters, catalog artifacts, and the adapter manifest. No application source tree, external interface, or durable data schema is introduced.

## Complexity Tracking

No constitution violations or complexity exceptions are required.
