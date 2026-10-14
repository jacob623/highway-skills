# Implementation Plan: Unified Recommendation Exploration Refactor

**Branch**: `173-unified-recommendation-exploration-refactor` | **Date**: 2026-10-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/173-unified-recommendation-exploration-refactor/spec.md`

## Summary

Align the authoritative Objective and Control owner contracts with the established NFR recommendation-exploration model. Add explicit Profile and Objective recommendation lineage, separate exploration from queue construction and processing, define exhaustion and explicit queue start conditions, preserve proposal-first acceptance and capture, and synchronize generated adapters and contract tests without adding runtime, persistence, ownership, or lifecycle concepts.

## Technical Context

**Language/Version**: Markdown skill contracts and POSIX-compatible shell; validation remains compatible with macOS Bash 3.2.57

**Primary Dependencies**: Existing Highway Profile, Objective, Control, and NFR owner contracts; shared Experience Standard; `.highway/tools/` generators

**Storage**: Existing user-owned Markdown Objective and Control records and catalogs; no new storage

**Testing**: Focused Objective and Control lifecycle/recommendation tests, adapter correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed skill trees on macOS and compatible shell environments

**Project Type**: Repository governance skill suite with generated agent adapters

**Performance Goals**: No new runtime performance target; identical declared context produces deterministic recommendation and queue guidance

**Constraints**: Preserve independent Objective and Control ownership, identifiers, records, catalogs, relationships, readiness, acceptance, persistence, and destructive safeguards; do not create candidate state or automatic downstream records

**Scale/Scope**: Two authoritative owner skills, eight generated adapters, focused contract tests, catalogs/manifests, and Feature 173 design artifacts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

- **Packaging Gate**: PASS. The design keeps development artifacts under `specs/` and shipped Objective and Control references under the distributed skill trees (D1.1, D1.2, D6.2).
- **Correspondence Gate**: PASS with regeneration required. Authoritative Objective and Control sources remain generator inputs; all adapters and catalog surfaces will be refreshed (D4.5-D4.7).
- **Validation Gate**: PASS with focused contract updates. Existing assertions will be extended for exploration and queue semantics without removing unrelated lifecycle coverage (D3.4, D3.5).
- **Skill Content Gate**: PASS pending final validation. The design preserves declared dependencies, owner boundaries, deterministic queue exits, output contracts, verification, and maintainability limits (P1.5, P1.7, P6.1-P6.6, P7.1-P7.7, P8.2-P8.7, P9.1-P9.7, P12A.1-P12A.4).
- **Toolchain Gate**: N/A. No generator or runtime script implementation changes are planned.
- **Generator Gate**: N/A. Existing generators will be invoked after source edits.

Design gate: PASS. The refactor changes owner guidance and contract assertions only, preserves existing record and relationship schemas, and introduces no new dependency, persistent entity, candidate artifact, or candidate lifecycle.

## Project Structure

### Documentation (this feature)

```text
specs/173-unified-recommendation-exploration-refactor/
├── plan.md              # This file
├── research.md          # Phase 0 decisions
├── data-model.md        # Phase 1 entity and state boundaries
├── quickstart.md        # Phase 1 validation guide
├── contracts/           # Phase 1 interaction contract
└── tasks.md             # Phase 2 task breakdown
```

### Source Code (repository root)

```text
.highway/skills/highway-objectives/SKILL.md  # authoritative Objective contract
.highway/skills/highway-controls/SKILL.md    # authoritative Control contract
.highway/tools/tests/                        # focused executable contract tests
.highway/tools/generate-*.sh                 # adapter/catalog/instruction generators
.github/skills/highway-objectives/SKILL.md  # generated GitHub Copilot adapter
.claude/skills/highway-objectives/SKILL.md  # generated Claude adapter
.cursor/skills/highway-objectives/SKILL.md  # generated Cursor adapter
.agents/skills/highway-objectives/SKILL.md  # generated Codex adapter
.github/skills/highway-controls/SKILL.md    # generated GitHub Copilot adapter
.claude/skills/highway-controls/SKILL.md    # generated Claude adapter
.cursor/skills/highway-controls/SKILL.md    # generated Cursor adapter
.agents/skills/highway-controls/SKILL.md    # generated Codex adapter
specs/173-unified-recommendation-exploration-refactor/  # design artifacts
```

**Structure Decision**: This is a source-first documentation and contract change. The two authoritative skills remain under `.highway/skills/`; focused tests validate the effective distributed surfaces; generated adapters and catalogs are regenerated rather than hand-edited; design artifacts remain under the Feature 173 directory. No application source, service, API, or new persistent model is introduced.

## Post-Design Constitution Check

- **D1.1, D1.2, D6.2**: PASS. Development artifacts stay under `specs/`, while shipped skill references remain resolvable within the distributed tree.
- **D3.1-D3.8**: PASS. The design uses focused existing checks, preserves unrelated assertions, and ends with the full suite plus explicit requirement coverage review.
- **D4.5-D4.7**: PASS. Both authoritative sources remain generator inputs and all declared derived surfaces will be regenerated after implementation.
- **D1.5 / Highway Skills Constitution**: PASS pending implementation validation. The design keeps named dependencies, deterministic queue exits, existing owner boundaries, verification, and error handling.
- **Complexity**: None. No runtime dependency, persistent entity, candidate state, or generator implementation is introduced.

## Complexity Tracking

No constitution violations require justification. The design uses existing owner, queue, output, generator, and validation patterns.
