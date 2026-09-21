# Implementation Plan: highway-nfrs Shared Output Contract Final Cleanup

**Branch**: `065-nfr-shared-output-contract-cleanup` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/065-nfr-shared-output-contract-cleanup/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Make the NFR record and catalog templates the sole structural authorities. Refactor only duplicated
record/catalog shape prose in `highway-nfrs`, retain classification, routing, allocation, versioning,
relationship, transaction, determinism, validation, and no-write behavior, extend the existing NFR
focused checks, and regenerate the three derived adapter forms.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill/template contracts and POSIX/Bash 3.2-compatible shell validation

**Primary Dependencies**: Existing `.highway/tools` validators, NFR/output-template focused shell tests, adapter generator, and full-suite harness; no new dependency

**Storage**: Canonical Markdown skills/templates, generated adapters, and user-owned NFR Markdown files; no runtime storage change

**Testing**: `validate-skill.sh`, `validate-library.sh`, `nfr-management.test.sh`, `output-template.test.sh`, adapter correspondence checks, distribution validation, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway skill tree consumed by GitHub Copilot, Claude Code, and Cursor; development and validation on macOS with the supported shell toolchain

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Preserve bounded validation and generation behavior; focused checks add no user-facing runtime or network work

**Constraints**: Shared templates own complete retained shape; `highway-nfrs` owns behavior; preserve P9.1, identifiers, status, allocation, determinism, transaction safety, user-owned bytes, and Bash 3.2 compatibility

**Scale/Scope**: One canonical skill, two shared output templates, existing focused test surfaces, three generated adapters, and the complete repository suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The feature changes one canonical skill, focused validation evidence, and derived adapters. It adds no
runtime, external service, package dependency, user-owned data migration, or governance rule.

| Gate | Verdict | Evidence / planned satisfaction |
|---|---|---|
| **Packaging Gate** | PASS | Changed shipped files remain free of development-only references and pass distribution validation. (D1.1, D1.2, D6.2) |
| **Toolchain Gate** | PASS | Existing Markdown and Bash 3.2-compatible utilities are reused; no new interpreter, package, or non-portable shell feature is planned. (D2.1-D2.4) |
| **Generator Gate** | PASS | Existing adapter generation runs after the canonical NFR skill changes; generator scripts are not changed. (D4.1-D4.4) |
| **Correspondence Gate** | PASS | Canonical NFR changes are followed by adapter regeneration and correspondence/coverage checks. (D4.5-D4.7) |
| **Validation Gate** | PASS | Focused source and disposable-fixture checks use independent seeded failures and byte-preservation assertions. (D3.4-D3.5) |
| **Skill Content Gate** | PASS | NFR workflow behavior remains while record/catalog structure moves to complete shared templates. (D1.5, P9.1) |

Process result: PASS. No unresolved gate violations.

## Project Structure

### Documentation (this feature)

```text
specs/065-nfr-shared-output-contract-cleanup/
├── plan.md              # This file
├── research.md          # Phase 0 research decisions
├── data-model.md        # Phase 1 contract ownership model
├── quickstart.md        # Phase 1 validation guide
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
.highway/
├── library/templates/output/
│   ├── nfr-record.md
│   └── nfr-catalog.md
├── skills/highway-nfrs/SKILL.md
└── tools/tests/
  ├── nfr-management.test.sh
  └── output-template.test.sh
.github/skills/highway-nfrs/SKILL.md
.claude/skills/highway-nfrs/SKILL.md
.cursor/rules/highway-nfrs.mdc
```

**Structure Decision**: Reuse the existing governance layout. The canonical skill and shared
templates remain under `.highway/`; focused checks extend existing test surfaces; generated
adapters are regenerated from the canonical source. No external interface or application source
tree is added, so no `contracts/` directory is required.

## Implementation Sequence

1. Inventory the NFR record and catalog templates alongside the current `highway-nfrs` Outputs and
   Verification wording; classify every statement as structure or behavior.
2. Refactor `highway-nfrs` to cite both complete templates, remove duplicated record/catalog shape
   prose, and replace structural verification lists with template-conformance checks.
3. Extend focused checks with independent disposable probes for missing citations, restored shape,
   removed behavior, stale adapters, and no-write residue.
4. Validate the canonical skill and both templates, regenerate the three adapters, and run adapter
   correspondence and distribution checks.
5. Run focused tests and the complete repository suite, then review `git diff --check` and confirm
   Features 061/062, protected Request paths, and user-owned NFR outputs are untouched.

## Phase 0 Research Questions

- Which exact NFR record and catalog declarations are structural duplicates?
- Which classification, routing, allocation, versioning, relationship, transaction, determinism,
  validation, and no-write behavior tokens must remain detectable?
- Which existing test surfaces can prove independent structural failures and byte preservation?
- Which generated adapter paths and correspondence checks cover `highway-nfrs`?

## Post-Design Re-evaluation

- **Template authority**: PASS. The two existing shared templates remain unchanged and become the
  complete named structural authorities in `highway-nfrs`.
- **Skill/behavior separation**: PASS. NFR classification, routing, allocation, versioning,
  relationships, transactions, determinism, validation, and destructive-action boundaries remain
  skill-owned.
- **Governance and packaging**: PASS. P9.1 is satisfied through complete citations; no runtime,
  dependency, governance rule, or user-owned migration is introduced.
- **Generated integrity**: PASS pending regeneration and correspondence validation after edits.
- **Validation isolation**: PASS pending independent disposable probes and byte-preservation checks.

Post-design result: PASS pending implementation and executable validation.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature reuses existing templates, validators, tests, generators, and repository layout. |
