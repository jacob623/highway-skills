# Implementation Plan: Profile Conversational Enrichment

**Branch**: `119-profile-conversational-enrichment` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/119-profile-conversational-enrichment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Refine the shipped `highway-profile` skill so synthesized Profile recommendations validate
organizational understanding with accuracy-oriented wording and a Profile-specific conversational
composition: acknowledge the accepted context, optionally contribute one grounded advisory observation,
present the cohesive recommendation, then validate it with one decision question and a correction path.
The implementation preserves the existing recommendation-first acquisition order, four readiness
domains, save-before-result persistence, brownfield boundary, completion synthesis, shared Experience
Standard ownership, schema `3.0.0`, and skill version `5.1.0`. It updates Profile-specific contract
assertions and regenerates declared dependents. The shared Profile template remains unchanged.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract; Bash 3.2.57-compatible shell tests

**Primary Dependencies**: Existing Highway identity, Experience Standard 6.0.0, Skills Constitution
6.0.0, Profile template and validators, existing generator scripts; no new runtime dependency

**Storage**: Existing user-owned Markdown Profile at `.highway/library/knowledge/profile.md`; no
new storage and no change to `.highway/library/templates/output/profile-record.md`

**Testing**: Existing Profile behavior, lifecycle, structure, UX, Markdown, migration, correspondence,
and full-suite Bash contracts; `.highway/tools/validate-skill.sh`

**Target Platform**: Shipped Highway distributions and macOS development environment; tests remain
compatible with the default macOS Bash 3.2 toolchain

**Project Type**: Documentation-led skill distribution with shell-based contract validation

**Performance Goals**: Deterministic local validation; no service latency, throughput, or availability
target is introduced

**Constraints**: Update only Profile-specific skill behavior and verification; preserve the four-domain
readiness model, recommendation-first order, persistence-before-result boundary, brownfield exclusion,
completion synthesis, and Experience Standard delegation; do not change the shared Profile template,
Experience Standard, identity, or unrelated skills; do not persist acknowledgment/advisory commentary
unless explicitly incorporated into accepted evidence; do not hand-edit generated artifacts

**Scale/Scope**: One shipped skill, focused Profile contracts, declared generated adapters/catalogs, and
Feature 119 design records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change is a shipped-skill refinement with Profile-specific test coverage. It does not change the
shared output template, generator scripts, storage format, or external interface.

### Process gates

| Gate | Verdict | Evidence / plan obligation |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The skill cites shipped governance, identity, and template paths only; packaged validation remains independent of development artifacts. |
| Toolchain Gate (D2.1-D2.4) | PASS | Shell assertions remain compatible with Bash 3.2 and the declared repository toolchain. |
| Generator Gate (D4.1-D4.4) | N/A | No generator implementation is changed. |
| Correspondence Gate (D4.5-D4.7) | PASS | The source skill is regenerated into declared adapters/catalog outputs after the source edit. |
| Validation Gate (D3.4-D3.5) | PASS | Focused assertions cover all four validation prompts, transient commentary, single-question validation, and preserved lifecycle boundaries. |
| Skill Content Gate (D1.5) | PASS | Applicable Skills Constitution rules are reviewed by ID, including P5.14, P7.3-P7.6, P8.2, P9.1-P9.5/P9.7, P10.1, P11.1, and P12.13-P12.15. |

Process result: PASS. No complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/119-profile-conversational-enrichment/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

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
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-library-catalog.sh
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
```

**Structure Decision**: The authoritative Profile skill and its focused shell contracts are the
implementation surface. Generated adapters and catalog entries are derived outputs and will be
regenerated after the source edit. No `contracts/` directory is needed because the feature introduces
no public API, CLI wire format, endpoint, or external integration.

## Post-Design Constitution Check

| Rule area | Verdict | Design evidence |
|---|---|---|
| Layer separation and shippability | PASS | Development-only Feature 119 records are not cited by the shipped skill; the skill cites only shipped governance and library paths. |
| Environment and dependency discipline | PASS | No new package, service, interpreter, storage system, or non-Bash test dependency is introduced. |
| Verification before and after | PASS | Test-first focused assertions cover accuracy-oriented prompts, optional advisory behavior, transient content, persistence order, and preserved boundaries. |
| Generated artifact integrity | PASS | All declared Profile adapters and catalog outputs are regenerated and checked for correspondence. |
| Documentation currency | PASS | Skill, focused contracts, quickstart, research, data model, and plan remain aligned. |
| Shared library dependency review | PASS | `profile-record.md` remains unchanged and its schema/readiness contract is explicitly preserved. |
| Highway Skills Constitution skill-content gate | PASS | The plan preserves the single shared Experience sentence and delegates generic acceptance, advisory, and single-question rules to the Experience Standard. |

No constitution violation requires complexity justification. Phase 0 research resolves all technical
unknowns; Phase 1 introduces no external contract.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | The existing Profile skill and contract-test tree already provide the required implementation surface. | A new project, storage layer, or abstraction would expand scope without supporting the requested presentation refinement. |
