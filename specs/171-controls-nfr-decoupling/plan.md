# Implementation Plan: Controls NFR Decoupling

**Branch**: `171-controls-nfr-decoupling` | **Date**: 2026-10-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/171-controls-nfr-decoupling/spec.md`

**Scope decision**: Remove the Control-derived NFR candidate lifecycle only. Direct NFR recommendation and development remain a follow-on feature.

## Summary

Remove the Control-derived NFR candidate-generation ownership model and its durable candidate-state artifact. Keep Controls responsible only for Control recommendation, development, acceptance, capture, persistence, readiness, and continuation. Remove candidate-state dependencies from NFRs, Setup, verification, readiness, workflow, ownership, and error handling, then preserve the Objectives-aligned recommendation-first Controls lifecycle and regenerate all derived artifacts.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing Highway skills, Objectives/Controls/NFR owner contracts, generator scripts, and shell test harness

**Storage**: Existing user-owned Control and NFR records; remove framework-owned `.highway/catalog/nfr-candidate-state.md`

**Testing**: Focused Controls, NFR, Setup, candidate-state absence, generated-artifact, and full-suite tests

**Target Platform**: macOS and Linux-compatible shell environments supported by the repository

**Project Type**: Source-first conversational skill suite with generated agent adapters

**Performance Goals**: Preserve existing deterministic owner and artifact validation behavior; no new performance target

**Constraints**: No direct NFR recommendation redesign; no new runtime dependency or retained record fields; preserve accepted records; remove all active candidate-generation ownership language; do not modify `highway-profile`

**Scale/Scope**: Controls, NFRs, Setup, shared catalogs/state, focused tests, generated adapters/manifests, and repository-wide validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Rule | Status | Evidence / Plan |
|---|---|---|
| D1.5 | PASS | The plan records a Constitution Check because authoritative skills and a shared catalog artifact change. |
| D1.4 | PASS | The plan cites rule IDs without reproducing constitution rule text. |
| D3.1 | REQUIRED | Confirm the repository suite is passing before implementation. |
| D3.2 | REQUIRED | Run the full repository suite after removal and regeneration. |
| D3.3 | REQUIRED | Add or amend focused decoupling and ownership tests. |
| D3.4 | REQUIRED | Evaluate new absence checks against existing fixtures before enabling them. |
| D4.1/D4.7 | REQUIRED | Regenerate every adapter, catalog, manifest, and instruction artifact after source changes. |
| D2.4 | PASS | No runtime package, interpreter, binary, or other dependency is introduced. |

No gate violation or complexity exception is identified.

## Project Structure

### Documentation (this feature)

```text
specs/171-controls-nfr-decoupling/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

### Source Code (repository root)
```text
.highway/
├── skills/highway-controls/SKILL.md
├── skills/highway-nfrs/SKILL.md
├── skills/highway-setup/SKILL.md
├── catalog/nfr-candidate-state.md       # removed by this feature
├── tools/tests/                          # focused and full-suite validation
├── tools/generate-agent-adapters.sh
├── tools/generate-catalog.sh
└── tools/generate-library-catalog.sh
.github/skills/, .claude/skills/, .cursor/skills/, .agents/skills/  # generated adapters
.highway/catalog/                         # generated indexes and manifests
```

**Structure Decision**: Preserve the source-first repository. Update authoritative Controls, NFR, and Setup contracts plus the framework-owned candidate-state artifact and focused tests; regenerate all derived adapters/catalogs/manifests. No external API contract or new source project is introduced.

## Phase 0: Research

1. Trace every candidate-generation and candidate-state reference across Controls, NFRs, Setup, catalogs, verification, readiness, workflow, ownership, and error handling.
2. Compare the Controls contract with Objectives to identify the structural lifecycle that must remain after decoupling: recommend, develop, capture, and continue collection.
3. Identify retained Control/NFR record and relationship boundaries so removing lifecycle state does not rewrite accepted records.
4. Identify existing focused fixtures and tests that prove candidate derivation, recovery, NFR readiness, Control-derived relationships, and generated correspondence; define replacement absence checks before enabling them.

Research will record decisions, rationale, and alternatives in `research.md`. The clarified scope resolves the only product-level unknown: direct NFR recommendation is deferred.

## Phase 1: Design

`data-model.md` documents the ownership chain, retained records, obsolete candidate-state artifact, and transient owner lifecycle boundaries. `quickstart.md` documents absence scans, focused owner tests, regeneration, and full-suite validation. No `contracts/` directory is needed because this is an internal skill-contract refactor with no new external interface.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
None. The change removes an obsolete cross-owner lifecycle and preserves existing owner storage and mutation boundaries.
