# Implementation Plan: Final Shared Output Contract Cleanup

**Branch**: `064-shared-output-contract-cleanup` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/064-shared-output-contract-cleanup/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Move the remaining Control and Discovery retained-output structure ownership into the shared
templates. Refactor only duplicated record/catalog shape prose in `highway-controls` and
`highway-discovery`, retain their behavioral contracts, extend the existing focused shell checks,
and regenerate the three derived adapter forms for each changed skill.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill/template contracts and POSIX/Bash 3.2-compatible shell validation

**Primary Dependencies**: Existing `.highway/tools` validators, focused shell tests, adapter generator, and full-suite harness; no new dependency

**Storage**: Canonical Markdown skills/templates, generated adapters, and user-owned Control/Discovery Markdown files; no runtime storage change

**Testing**: `validate-skill.sh`, `validate-library.sh`, existing output-template and Discovery contract tests, adapter correspondence checks, distribution validation, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway skill tree consumed by GitHub Copilot, Claude Code, and Cursor; development and validation on macOS with the supported shell toolchain

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Preserve bounded validation and generation behavior; focused checks add no user-facing runtime or network work

**Constraints**: Shared templates own complete retained shape; skills own behavior; preserve P9.1, existing paths/IDs/status/allocation, determinism, advisory boundaries, user-owned bytes, and Bash 3.2 compatibility

**Scale/Scope**: Two canonical skills, three shared output templates, two focused test surfaces, six generated adapters, and the complete repository suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The feature changes two canonical skills, focused validation evidence, and derived adapters. It adds
no runtime, external service, package dependency, user-owned data migration, or governance rule.

| Gate | Verdict | Evidence / planned satisfaction |
|---|---|---|
| **Packaging Gate** | PASS | Changed shipped files remain free of development-only references and pass distribution validation. (D1.1, D1.2, D6.2) |
| **Toolchain Gate** | PASS | Existing Markdown and Bash 3.2-compatible utilities are reused; no new interpreter, package, or non-portable shell feature is planned. (D2.1-D2.4) |
| **Generator Gate** | PASS | Existing adapter generation runs after canonical skill changes; generator scripts are not changed unless focused evidence requires it. (D4.1-D4.4) |
| **Correspondence Gate** | PASS | Both canonical skills are followed by adapter regeneration and correspondence/coverage checks. (D4.5-D4.7) |
| **Validation Gate** | PASS | Focused source and disposable-fixture checks use independent seeded failures and byte-preservation assertions. (D3.4-D3.5) |
| **Skill Content Gate** | PASS | Control allocation/versioning/transaction/NFR proposal behavior and Discovery filtering/scoring/recommendation/ADR boundaries remain while duplicated structure prose is removed. (D1.5, P9.1) |

Process result: PASS. No unresolved gate violations.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
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
│   ├── control-catalog.md
│   ├── discovery-record.md
│   └── discovery-catalog.md
├── skills/
│   ├── highway-controls/SKILL.md
│   └── highway-discovery/SKILL.md
└── tools/tests/
   ├── output-template.test.sh
   └── highway-discovery.test.sh
.github/skills/highway-controls/SKILL.md
.github/skills/highway-discovery/SKILL.md
.claude/skills/highway-controls/SKILL.md
.claude/skills/highway-discovery/SKILL.md
.cursor/rules/highway-controls.mdc
.cursor/rules/highway-discovery.mdc
```

**Structure Decision**: Reuse the existing governance layout. Canonical skills and shared templates
remain under `.highway/`; focused checks extend their established test surfaces; generated adapters
are regenerated from canonical sources. No external interface or application source tree is added,
so no `contracts/` directory is required.

## Implementation Sequence

1. Inventory the Control catalog and Discovery record/catalog templates alongside the current
  Outputs and Verification wording; classify every statement as structure or behavior.
2. Refactor `highway-controls` to cite the complete Control catalog template and remove duplicated
  catalog listing/version/next-ID/management-shape declarations while retaining deterministic and
  transactional behavior.
3. Refactor `highway-discovery` to cite complete record/catalog templates and replace duplicated
  section, field, and index verification with template-conformance wording while retaining all
  analysis, scoring, recommendation, allocation, privacy, determinism, and ADR behavior.
4. Extend the existing focused tests with independent disposable probes for missing citations,
  reintroduced structural duplication, removed behavior, stale adapters, and no-write residue.
5. Validate canonical skills and all three shared templates, regenerate six adapters, and run
  adapter correspondence and distribution checks.
6. Run focused tests and the complete repository suite, then review `git diff --check` and confirm
  Features 061/062 and user-owned Control/Discovery outputs are untouched.

## Phase 0 Research Questions

- Which exact Control catalog and Discovery record/catalog declarations are structural duplicates?
- Which Control and Discovery behavior tokens must remain detectable after cleanup?
- Which existing test surfaces can prove independent structural failures and byte preservation?
- Which generated adapter paths and correspondence checks cover both changed skills?

## Post-Design Re-evaluation

- **Template authority**: PASS. The three existing shared templates remain unchanged and become the
  named complete structural authorities in the two skills.
- **Skill/behavior separation**: PASS. Control allocation, versioning, transactions, relationships,
  and NFR proposals remain skill-owned; Discovery analysis, filtering, scoring, recommendation,
  traceability, determinism, and ADR boundaries remain skill-owned.
- **Governance and packaging**: PASS. P9.1 is satisfied through complete citations; no runtime,
  dependency, governance rule, or user-owned migration is introduced.
- **Generated integrity**: PASS pending regeneration and correspondence validation after edits.
- **Validation isolation**: PASS pending independent disposable probes and byte-preservation checks.

Post-design result: PASS pending implementation and executable validation.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
| None | N/A | The feature reuses existing templates, validators, tests, generators, and repository layout. |
