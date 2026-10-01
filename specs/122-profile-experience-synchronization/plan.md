# Implementation Plan: Profile Experience Synchronization

**Branch**: `122-profile-experience-synchronization` | **Date**: 2026-10-01 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/122-profile-experience-synchronization/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Synchronize the `highway-profile` skill with Highway Identity and Experience Standard 7.1.0 by removing local conversational constraints and retaining Profile-specific evidence grounding, validation, persistence, readiness, and scope boundaries. The implementation changes the authoritative Profile skill and its directly affected contract tests only; the shared Profile template, retained Profile, Highway Identity, Experience Standard, generated adapters, and unrelated skills remain protected.

## Technical Context

**Language/Version**: Markdown guidance and macOS-compatible Bash 3.2 shell contracts

**Primary Dependencies**: Existing Highway Identity, Experience Standard 7.1.0, Profile template, and Profile contract-test suite

**Storage**: Existing Markdown Profile persistence; no storage change

**Testing**: Existing focused shell contracts plus `.highway/tools/tests/run-all.sh`

**Target Platform**: Shipped Highway skill distribution and macOS development environment

**Project Type**: Documentation-led governance and multi-agent skill suite

**Performance Goals**: No runtime performance change; preserve existing Profile interaction and validation behavior

**Constraints**: Profile-only source scope; preserve schema 3.0.0, four readiness domains, persistence ownership, website scope, brownfield exclusion, completion ownership, and shared Experience sentence; no new runtime state or dependency

**Scale/Scope**: One authoritative Profile skill, its focused tests, and Feature 122 design artifacts; no external API or storage contract

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The following gates pass before research:

| Gate | Status | Evidence |
|---|---|---|
| Layer separation and shippability | PASS | Only the shipped Profile skill and its directly affected checks are implementation surfaces; design artifacts remain under `specs/`. |
| Environment and dependency discipline | PASS | No package, service, interpreter, storage system, or external integration is added; shell checks remain compatible with macOS Bash 3.2. |
| Verification before and after | PASS | Focused Profile contracts and the full repository suite provide pre/post validation. |
| Generated artifact integrity | PASS | No generator input, generated adapter, or catalog source is changed; regeneration is unnecessary. |
| Documentation currency | PASS | Profile skill, focused checks, quickstart, research, data model, plan, and tasks remain the documented change surface. |
| Shared library dependency review | PASS | `profile-record.md` is unchanged and remains covered by existing Profile/template contracts. |
| Skill-content governance | PASS | Profile continues to cite shared governance and delegates generic interaction behavior without copying its rules. |

No constitution violation requires a complexity exception. Phase 0 research resolves all design unknowns without adding a new contract or technology.

## Project Structure

### Documentation (this feature)

```text
specs/122-profile-experience-synchronization/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/skills/highway-profile/SKILL.md
.highway/tools/tests/profile-behavior.test.sh
.highway/tools/tests/profile-lifecycle.test.sh
.highway/tools/tests/profile-structure.test.sh
.highway/tools/tests/feature-092-contract.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/profile-markdown-contract.test.sh
.highway/tools/tests/profile-template-migration.test.sh
.highway/tools/tests/feature-092-correspondence.test.sh
.highway/library/templates/output/profile-record.md  # read-only dependency
.github/skills/highway-profile/SKILL.md              # generated adapter, regenerate only if source policy requires it
```

**Structure Decision**: The authoritative Profile skill and existing Profile-specific shell contracts are the implementation surface. The shared Profile template, Highway Identity, Experience Standard, retained Profile, generated adapters, and unrelated skills are protected or read-only dependencies. No `contracts/` directory is created because this feature introduces no public API, CLI wire format, endpoint, or external integration.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature fits the existing Profile skill and contract-test structure. |
