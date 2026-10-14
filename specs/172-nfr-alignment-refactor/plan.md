# Implementation Plan: NFR Alignment Refactor

**Branch**: `172-nfr-alignment-refactor` | **Date**: 2026-10-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/172-nfr-alignment-refactor/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Refactor the authoritative `highway-nfrs` skill to use the recommendation-first owner framework
already established by Objectives and Controls. Add recommendation exploration, internal coverage
guidance, ordered queue construction, explicit queue-processing entry, proposal-first development,
portfolio assessment, and continuation while preserving NFR ownership, persistence, readiness,
destructive safeguards, and Control-to-NFR relationship mapping. Regenerate all derived skill
artifacts and update focused contract tests without introducing runtime dependencies or candidate state.

## Technical Context

**Language/Version**: Markdown skill contracts and POSIX-compatible shell; validation must remain compatible with macOS Bash 3.2.57

**Primary Dependencies**: Existing Highway Objectives and Controls skill patterns, shared output templates, and `.highway/tools/` generators

**Storage**: User-owned Markdown NFR records and catalog under `library/governance/`

**Testing**: Focused NFR onboarding, management, output, relationship, readiness, and routing tests; `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed skill trees on macOS and compatible shell environments

**Project Type**: Repository governance skill suite with generated agent adapters

**Performance Goals**: No new runtime performance target; recommendation and queue behavior must remain deterministic for identical declared inputs

**Constraints**: Preserve NFR ownership and existing records, identifiers, catalog, readiness, relationship, duplicate, overlap, and destructive contracts; do not introduce candidate generation or a runtime dependency

**Scale/Scope**: One authoritative NFR skill, its four generated adapters, shared catalogs/manifests, NFR templates, and affected contract tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

- **Packaging Gate**: PASS. The feature changes shipped skill content and generated adapters; the plan preserves the distributed-tree validation and cross-reference requirements (D1.1, D1.2, D6.2).
- **Correspondence Gate**: PASS with regeneration required. The NFR skill is an input to declared generators; all generated artifacts will be refreshed and checked (D4.5-D4.7).
- **Validation Gate**: PASS with focused contract updates. Existing assertions will be amended only where the owner contract intentionally changes, with no removal of unrelated coverage (D3.4, D3.5).
- **Skill Content Gate**: PASS pending final validation. The authoritative skill will be checked against the Highway Skills Constitution, including dependency declaration, owner boundaries, deterministic criteria, output contracts, verification, and maintainability limits (P1.5, P1.7, P6.1-P6.6, P7.1-P7.7, P8.2-P8.7, P9.1-P9.7, P12A.1-P12A.4).
- **Toolchain Gate**: N/A. No shell generator or runtime script is being changed.
- **Generator Gate**: N/A. No generator implementation is being changed.

Design gate: PASS. The refactor preserves the existing NFR record and relationship schema, uses the
existing generated-artifact workflow, and introduces no new dependency, candidate artifact, or
candidate lifecycle.

## Project Structure

### Documentation (this feature)

```text
specs/172-nfr-alignment-refactor/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-nfrs/SKILL.md       # authoritative NFR owner contract
.highway/library/templates/output/          # retained NFR record and catalog templates
.highway/tools/tests/                        # focused contract and executable tests
.highway/tools/generate-*.sh                 # derived adapter/catalog/instruction generators
.github/skills/highway-nfrs/SKILL.md         # generated GitHub Copilot adapter
.claude/skills/highway-nfrs/SKILL.md         # generated Claude adapter
.cursor/skills/highway-nfrs/SKILL.md         # generated Cursor adapter
.agents/skills/highway-nfrs/SKILL.md         # generated Codex adapter
specs/172-nfr-alignment-refactor/            # design and validation artifacts
```

**Structure Decision**: This is a source-first documentation and contract change. The authoritative
NFR skill and shared templates remain under `.highway/`; tests validate the effective distributed
surfaces; generated adapters and catalogs are regenerated rather than hand-edited; plan artifacts
remain under the Feature 172 development directory.

## Post-Design Constitution Check

- **D1.1, D1.2, D6.2**: PASS. The design keeps development-only plan artifacts under `specs/` and
  keeps all shipped references within the distributed tree's resolvable paths.
- **D3.1-D3.8**: PASS. The design uses focused existing checks, preserves assertions outside the
  changed NFR contract, and ends with the full suite and explicit requirement coverage review.
- **D4.5-D4.7**: PASS. The NFR source remains the generator input and all declared adapters,
  catalogs, manifests, and instructions are regenerated after implementation.
- **D1.5 / Highway Skills Constitution**: PASS pending implementation validation. The design retains
  named dependencies, deterministic queue exits, existing output templates, verification, error
  handling, and owner boundaries; final validation will run the authoritative skill validator and
  dependent output-template checks.
- **Complexity**: None. No new runtime dependency, persistent entity, candidate state, or generator
  implementation is introduced.

## Complexity Tracking

No constitution violations require justification. The design uses existing owner, queue, output,
generator, and validation patterns.
