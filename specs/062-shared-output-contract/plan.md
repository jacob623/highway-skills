# Implementation Plan: Shared Output Contract Implementation

**Branch**: `062-shared-output-contract` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/062-shared-output-contract/spec.md`

## Summary

Establish one authoritative shared template pair for each retained baseline artifact, migrate the
five emitting skills to cite complete record and catalog templates, and add focused validation that
protects structural ownership while preserving workflow behavior. The implementation uses the
existing Markdown contract library, Bash 3.2-compatible validators and fixtures, and canonical
generators for adapters and catalogs. User-owned records, catalogs, and behavioral semantics remain
unchanged.

## Technical Context

**Language/Version**: Markdown skill/template contracts and POSIX/Bash 3.2-compatible shell validation

**Primary Dependencies**: Existing `.highway/tools` validators, focused shell tests, template validators, and adapter/catalog generators; no new dependency

**Storage**: Markdown templates, skill contracts, generated adapters/catalogs, and user-owned Markdown baselines; no runtime storage change

**Testing**: `.highway/tools/tests/output-template.test.sh`, existing per-skill tests and validators, adapter/catalog correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree consumed by GitHub Copilot, Claude Code, and Cursor; development and validation on macOS with the supported shell toolchain

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Preserve current bounded validation and generation behavior; focused checks must remain disposable and must not add runtime or network work to user-facing skills

**Constraints**: Templates own retained artifact shape; skills own behavior; preserve P9.1, existing paths/IDs/versioning/allocation, no-write and transaction semantics, generated-artifact derivation, and Bash 3.2 compatibility

**Scale/Scope**: Five retained baseline pairs, five skill contracts, three new catalog templates if absent, existing record/catalog templates, one shared-output focused test surface, generated adapters/catalogs, and the full repository suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The feature changes shipped template/skill documentation, focused validation evidence, and derived
artifacts. It adds no runtime, external service, package dependency, or governance principle.

| Gate | Verdict | Evidence / planned satisfaction |
|---|---|---|
| **Packaging Gate** | PASS | Changed shipped files will remain free of development-only references and will pass distribution validation. (D1.1, D1.2, D6.2) |
| **Toolchain Gate** | PASS | Existing Markdown and Bash 3.2-compatible utilities are reused; no new interpreter, package, or non-portable shell feature is planned. (D2.1-D2.4) |
| **Generator Gate** | PASS | Existing adapter and catalog generators will be run after canonical sources change; generator scripts themselves are not changed unless a focused gap is proven. (D4.1-D4.4) |
| **Correspondence Gate** | PASS | Every changed skill/template source will be followed by adapter/catalog regeneration and currency/coverage checks. (D4.5-D4.7) |
| **Validation Gate** | PASS | Focused structural checks will use disposable valid/invalid fixtures, independent seeded failures, and byte-preservation assertions. (D3.4-D3.5) |
| **Skill Content Gate** | PASS | Migrated skills will retain behavioral workflow, ownership, allocation, readiness, relationship, transaction, determinism, and failure rules while replacing only duplicated structure prose. (D1.5, P9.1) |

Process result: PASS. No unjustified gate violations.

## Project Structure

### Documentation (this feature)

```text
specs/062-shared-output-contract/
├── spec.md              # feature requirements
├── plan.md              # this implementation plan
├── research.md          # Phase 0 decisions and repository evidence
├── data-model.md        # Phase 1 contract entities and relationships
├── quickstart.md        # Phase 1 validation guide
├── checklists/
│   └── requirements.md # specification quality checklist
└── tasks.md             # Phase 2 output from /speckit-tasks
```

### Source Code (repository root)

```text
.highway/
├── library/templates/output/
│   ├── request-record.md
│   ├── request-catalog.md
│   ├── objective-record.md
│   ├── objective-catalog.md       # added if absent
│   ├── control-record.md
│   ├── control-catalog.md         # added if absent
│   ├── nfr-record.md
│   ├── nfr-catalog.md             # added if absent
│   ├── discovery-record.md
│   └── discovery-catalog.md
├── skills/
│   ├── highway-new/SKILL.md
│   ├── highway-objectives/SKILL.md
│   ├── highway-controls/SKILL.md
│   ├── highway-nfrs/SKILL.md
│   └── highway-discovery/SKILL.md
├── tools/tests/output-template.test.sh
├── tools/validate-library.sh
├── tools/validate-skill.sh
├── tools/generate-agent-adapters.sh
├── tools/generate-catalog.sh
└── tools/generate-library-catalog.sh
.github/skills/, .claude/skills/, .cursor/rules/  # generated adapters
.highway/catalog/                                  # generated skill/library catalogs
```

**Structure Decision**: Use the existing repository governance layout. Canonical templates and skill
contracts remain under `.highway/`; focused validation remains in the existing output-template test;
derived adapters and catalogs are regenerated rather than hand-edited. No external interface or
application source tree is introduced, so no `contracts/` directory is required.

## Implementation Sequence

1. Inventory current record/catalog templates and the five emitting skills; capture existing catalog
   metadata, index columns, paths, versions, next-ID semantics, and behavioral assertions before
   editing.
2. Create the missing Objective, Control, and NFR catalog templates from their current generated
   catalog behavior, and normalize the existing Request and Discovery catalog templates only where
   needed to satisfy the shared catalog contract without changing user-owned paths or allocation.
3. Refactor `highway-new`, `highway-objectives`, `highway-controls`, `highway-nfrs`, and
   `highway-discovery` Outputs/Verification sections to cite complete record/catalog templates and
   remove duplicated structural declarations while retaining behavioral rules.
4. Extend `.highway/tools/tests/output-template.test.sh` with authoritative-template inventory,
   catalog identity/shape, citation, duplication, behavior-preservation, and disposable-fixture
   assertions. Each deterministic rule gets an independently failing invalid fixture.
5. Run per-template/per-skill validators and focused tests, then regenerate adapters and both
   catalogs from canonical sources. Verify generated correspondence and unchanged user-owned
   baselines.
6. Run distribution, adapter/catalog, output-template, and full-suite validation; use `git diff
   --check` and a final source/generated status review before completion.

## Phase 0 Research Questions

- What exact metadata, next-ID, version, and index shapes do current user-owned catalogs require?
- Which structural prose is duplicated in each of the five skill contracts, and which statements are
  behavioral and must remain?
- Which existing validators and generated-artifact checks can be extended without adding a new
  validation framework?
- How can disposable fixtures prove missing templates, missing citations, duplicate structure, and
  stale generated output independently without mutating canonical files?

## Post-Design Re-evaluation

- **Template authority**: PASS pending research confirmation of all current catalog shapes and
  creation of the three missing catalog templates from observed behavior.
- **Skill/behavior separation**: PASS. The spec explicitly retains workflow and domain semantics in
  skills while moving complete retained-artifact shape to templates.
- **Governance and packaging**: PASS. P9.1 is strengthened through complete citations; no new
  principle, runtime, dependency, external interface, or user-owned migration is introduced.
- **Generated integrity**: PASS pending regeneration and correspondence checks after canonical edits.
- **Validation isolation**: PASS pending disposable independent fixtures and byte-preservation checks.

Post-design result: PASS. Implementation verification completed: all ten retained templates and
five migrated skills validate, disposable output-contract probes pass, generated correspondence
passes, distribution packaging passes, and the full repository suite reports 42 passed and 0 failed.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| None | N/A | The feature reuses the existing template, skill, validator, fixture, and generation mechanisms. |
