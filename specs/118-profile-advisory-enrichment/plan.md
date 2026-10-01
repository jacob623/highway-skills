# Implementation Plan: Profile Advisory Enrichment

**Branch**: `118-profile-advisory-enrichment` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/118-profile-advisory-enrichment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Align the shipped `highway-profile` skill with the Experience Standard 6.0.0, Constitution 6.0.0,
and Highway identity's Constructive Advisory direction while preserving the existing Profile record,
schema `3.0.0`, four readiness domains, and supported operations. The implementation will tighten
Profile-specific acquisition, accepted-evidence re-evaluation, cohesive paragraph recommendations,
constructive advisory behavior, save-before-result persistence, completion synthesis, and machine-result
suppression. It will add or amend focused Profile contract tests and regenerate declared skill
dependents after the source skill changes. `profile-record.md` remains unchanged.

## Technical Context

**Language/Version**: Markdown skill contract; Bash 3.2.57-compatible shell tests

**Primary Dependencies**: Highway Experience Standard 6.0.0, Highway Skills Constitution 6.0.0,
Highway identity, existing Profile helper and validators, existing catalog/adapter generators; no
new runtime dependency

**Storage**: Existing user-owned Markdown Profile at `.highway/library/knowledge/profile.md`; no
new storage technology and no change to `.highway/library/templates/output/profile-record.md`

**Testing**: Focused Bash contract tests under `.highway/tools/tests/`,
`.highway/tools/validate-skill.sh`, generator correspondence checks, and
`.highway/tools/tests/run-all.sh`

**Target Platform**: Shipped Highway distributions and macOS development environment; shell changes
must remain compatible with default Bash 3.2 and the declared toolchain

**Project Type**: Documentation-led skill distribution with shell-based contract validation

**Performance Goals**: Deterministic local contract validation; no service latency, throughput, or
availability target is introduced

**Constraints**: Modify only `highway-profile` behavior and Profile-specific verification; do not
modify `profile-record.md`; preserve schema `3.0.0`, four domains, three domain states, supported
operations, and existing error behavior; keep brownfield technology discovery outside Profile; do
not add a retrieval dependency; do not duplicate generic Experience Standard rules; do not hand-edit
generated artifacts; keep source contracts free of `.specify/` and `specs/` references

**Scale/Scope**: One shipped skill, its focused tests, existing Profile readiness and persistence
contracts, and declared generated skill dependents

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change touches a shipped skill and its Profile-specific tests. It does not change the shared
Profile template, a generator script, or a new external interface.

### Process gates

| Gate | Verdict | Evidence / plan obligation |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The amended skill cites only shipped governance, identity, and template paths; packaged validation runs with development artifacts absent. |
| Toolchain Gate (D2.1-D2.4) | PASS | Any shell test edits remain Bash 3.2-compatible and use the declared toolchain. |
| Generator Gate (D4.1-D4.4) | N/A | No `generate-*.sh` script is changed. |
| Correspondence Gate (D4.5-D4.7) | PASS | The source skill is a generator input; declared adapters/catalogs are inventoried and regenerated after the source edit. |
| Validation Gate (D3.4-D3.5) | PASS | New or amended assertions retain seeded probes and identify superseded behavior before enablement. |
| Skill Content Gate (D1.5) | PASS | `highway-profile` is reviewed against applicable Skills Constitution rules by ID, especially P5.14, P7.3-P7.6, P8.2, P9.1-P9.5/P9.7, P10.1, P11.1, and P12.13-P12.15. |

Process result: PASS. No complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/118-profile-advisory-enrichment/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks)
```

### Source Code (repository root)
```text
.highway/skills/highway-profile/SKILL.md
.highway/tools/tests/feature-092-contract.test.sh
.highway/tools/tests/profile-behavior.test.sh
.highway/tools/tests/profile-structure.test.sh
.highway/tools/tests/profile-lifecycle.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/fixtures/profile-092/
.github/skills/ and other declared generated adapter trees/
.highway/catalog/ and declared generated catalog outputs/
```

**Structure Decision**: The source Profile skill and its focused shell contract tests remain the
authoritative implementation surface. The shared Profile template is a read-only dependency for
this feature. Generated adapters and catalog outputs are derived and regenerated, never hand-edited.
No `contracts/` directory is created because this feature adds no external interface.

## Post-Design Constitution Check

| Rule area | Verdict | Design evidence |
|---|---|---|
| Layer separation and shippability | PASS | Runtime Profile text references shipped paths only; all Feature 118 artifacts remain development-only. |
| Environment and dependency discipline | PASS | No new package, interpreter, service, or persistence technology; shell tests remain Bash 3.2-compatible. |
| Verification before and after | PASS | Focused assertions cover each changed behavior and the full suite runs before completion. |
| Generated artifact integrity | PASS | Declared generated dependents are regenerated and checked for correspondence. |
| Documentation currency | PASS | Skill, focused tests, quickstart, and design records are updated together. |
| Shared library dependency review | PASS | The Profile skill remains aligned with the unchanged `profile-record.md` template and its tests. |
| Highway Skills Constitution skill-content gate | PASS | The design preserves output declarations, context inputs, Experience Standard citation, owner-result boundaries, and size limits under the applicable P-rules. |

No constitution violation requires complexity justification. Phase 0 research resolves all technical
unknowns; Phase 1 design introduces no external contract.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | The feature fits the existing single skill distribution and test tree. | No additional application, storage, or integration structure is needed. |
