# Implementation Plan: Highway New Shared Output Contract Migration

**Branch**: `063-highway-new-output-contract` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/063-highway-new-output-contract/spec.md`

## Summary

Migrate `highway-new` to the shared-output-contract model by making the Request record and Request
catalog templates the sole authorities for retained structure, removing duplicated structural
verification from the skill, and adding focused proof that behavioral ownership remains intact.
The implementation reuses the existing Markdown skill/template library, Bash 3.2-compatible
validators and disposable fixtures, and canonical generators for derived adapters.

## Technical Context

**Language/Version**: Markdown skill/template contracts and POSIX/Bash 3.2-compatible shell validation

**Primary Dependencies**: Existing `.highway/tools` validators, focused shell tests, adapter generator, and full-suite harness; no new dependency

**Storage**: Canonical Markdown skill/template files, generated adapters, and user-owned Request Markdown files; no runtime storage change

**Testing**: `validate-skill.sh`, `validate-library.sh`, focused `highway-new` contract checks, adapter correspondence checks, distribution validation, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway skill tree consumed by GitHub Copilot, Claude Code, and Cursor; development and validation on macOS with the supported shell toolchain

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Preserve current bounded validation and generation behavior; focused checks remain disposable and add no user-facing runtime or network work

**Constraints**: Request templates own complete retained shape; `highway-new` owns intake behavior; preserve P9.1, existing paths/IDs/status/allocation, privacy and transaction semantics, generated derivation, and Bash 3.2 compatibility

**Scale/Scope**: One canonical skill, two existing Request templates, affected generated adapters/catalog metadata, one focused validation surface, and the complete repository suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The feature changes one canonical skill, focused validation evidence, and derived adapters. It adds
no runtime, external service, package dependency, user-owned data migration, or governance rule.

| Gate | Verdict | Evidence / planned satisfaction |
|---|---|---|
| **Packaging Gate** | PASS | Changed shipped files remain free of development-only references and pass distribution validation. (D1.1, D1.2, D6.2) |
| **Toolchain Gate** | PASS | Existing Markdown and Bash 3.2-compatible utilities are reused; no new interpreter, package, or non-portable shell feature is planned. (D2.1-D2.4) |
| **Generator Gate** | PASS | Existing adapter generation runs after the canonical skill changes; generator scripts are not changed unless a focused gap is demonstrated. (D4.1-D4.4) |
| **Correspondence Gate** | PASS | The canonical `highway-new` source is followed by adapter regeneration and correspondence/coverage checks. (D4.5-D4.7) |
| **Validation Gate** | PASS | Focused source and disposable-fixture checks use independent seeded failures and byte-preservation assertions. (D3.4-D3.5) |
| **Skill Content Gate** | PASS | Evidence, privacy, allocation, determinism, Solution Constraints, transaction, status, and Discovery handoff behavior remain while only duplicated structure prose is removed. (D1.5, P9.1) |

Process result: PASS. No unjustified gate violations.

## Project Structure

### Documentation (this feature)

```text
specs/063-highway-new-output-contract/
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
│   └── request-catalog.md
├── skills/highway-new/SKILL.md
└── tools/
    ├── tests/output-template.test.sh
    ├── tests/highway-new.test.sh       # extend existing focused surface if present
    ├── validate-library.sh
    ├── validate-skill.sh
    └── generate-agent-adapters.sh
.github/skills/highway-new/SKILL.md      # generated adapter
.claude/skills/highway-new/SKILL.md      # generated adapter
.cursor/rules/highway-new.mdc            # generated adapter
```

**Structure Decision**: Use the existing repository governance layout. The canonical skill and
shared Request templates remain under `.highway/`; focused validation stays in the existing test
harness or its established `highway-new` test surface; derived adapters are regenerated rather
than hand-edited. No external interface or application source tree is introduced, so no
`contracts/` directory is required.

## Implementation Sequence

1. Inventory the Request record/catalog templates and current `highway-new` Outputs/Verification
   wording; record every behavioral rule that must survive and every structural declaration to remove.
2. Refactor `highway-new` Outputs to cite the complete Request record and catalog templates, and
   replace duplicated record headings, Solution Constraints ordering, and catalog shape with
   template-authority wording.
3. Refactor Verification to assert template conformance for both retained outputs while retaining
   identifier, status, allocation, privacy, determinism, transaction, no-write, and Discovery
   handoff checks.
4. Extend the existing focused shell test with independent disposable fixtures for missing record
   citation, missing catalog citation, duplicated structure, removed behavior, stale adapters, and
   canonical/user-owned byte preservation.
5. Validate the canonical skill and both templates, regenerate affected adapters, and run adapter
   correspondence and distribution checks.
6. Run the focused test and complete repository suite, then use `git diff --check` and a final
   changed-path review confirming Features 061 and 062 remain untouched.

## Phase 0 Research Questions

- Which exact Request record and catalog structure statements are duplicated in `highway-new` and
  must be replaced by template citations?
- Which behavioral assertions must remain after structural prose is removed?
- Which existing focused test and validator surfaces can prove template conformance and independent
  disposable failures without a new framework?
- Which generated adapters are derived from `highway-new`, and what correspondence command verifies
  them without hand edits?

## Post-Design Re-evaluation

- **Template authority**: PASS. Existing Request record and catalog templates are the named sole
  structural authorities; the feature does not change either template.
- **Skill/behavior separation**: PASS. Request shape moves to template conformance while intake,
  privacy, allocation, determinism, transactions, and Discovery boundaries remain skill behavior.
- **Governance and packaging**: PASS. P9.1 is satisfied through complete citations; no new rule,
  runtime, dependency, or user-owned migration is introduced.
- **Generated integrity**: PASS pending adapter regeneration and correspondence validation after the
  canonical skill change.
- **Validation isolation**: PASS pending independent disposable fixtures and byte-preservation checks.

Post-design result: PASS pending implementation and executable validation.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| None | N/A | The feature reuses existing templates, validators, tests, generators, and repository layout. |
