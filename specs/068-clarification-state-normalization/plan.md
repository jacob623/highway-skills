# Implementation Plan: Clarification State and Fingerprint Normalization

**Branch**: `068-clarification-state-normalization` | **Date**: 2026-09-22 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/068-clarification-state-normalization/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Feature 068 extends the Feature 067 Clarify contract with ordered fingerprint normalization,
two-state finding lifecycle rules, count invariants, catalog consistency verification, and schema
version updates. The change remains within the existing Markdown skill and shared-template surfaces,
extends Bash disposable contract tests, regenerates derived adapters and indexes, and preserves
command syntax, artifact ownership, supported types, and source immutability.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing `highway-clarify` contract, clarification record/catalog templates, Feature 067 identity/status rules, and repository test harness

**Storage**: User-owned clarification artifacts and `clarifications/clarifications.md`; no new storage system

**Testing**: Focused Clarify/template tests, skill/library validators, generated-artifact correspondence checks, and serialized full suite

**Target Platform**: macOS and GNU-like shell environments supported by the repository

**Project Type**: Repository-distributed agent skill suite with Markdown contracts and shell validation

**Performance Goals**: Deterministic local processing for the bounded clarification inventory; no network or timestamp-dependent work

**Constraints**: Ordered normalization; only `open` and `resolved` finding states; count invariant; one-way resolution; one-to-one catalog consistency; zero partial writes; Bash 3.2.57 compatibility; no runtime dependency

**Scale/Scope**: One clarification catalog per repository, bounded clarification records, four supported artifact types, and changes limited to Clarify, shared templates, focused tests, generated artifacts, and Feature 068 design records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | Shipped Clarify and template paths change; packaged-tree, path, and documentation validation are required. |
| Toolchain Gate (D2.1-D2.4) | PASS | Work remains Markdown and Bash 3.2.57-compatible and uses the declared repository toolchain. |
| Generator Gate (D4.1-D4.4) | N/A | No generator script is changed. |
| Correspondence Gate (D4.5-D4.7) | PASS | Canonical skill/template changes require adapter and catalog-index regeneration and correspondence checks. |
| Validation Gate (D3.4-D3.5) | PASS | Focused static and disposable checks are added without weakening existing assertions. |

### Skill Content Gates

| Rule | Verdict | Evidence |
|---|---|---|
| P5.1-P5.5 | PASS | New normalization, state, count, and consistency failure paths name explicit next actions. |
| P6.1/P6.6 | PASS | Normalization order, state transitions, count precedence, and catalog relationships are declared rules. |
| P8.3/P8.4 | PASS | Verification sections are extended with normalization, state, count, and consistency checks. |
| P9.1 | PASS | Clarify continues to cite the complete shared record and catalog templates. |

No gate is unresolved and no complexity exception is required.

## Phase 0 Research Summary

See [research.md](./research.md). Research confirms that Feature 068 should extend existing
Clarify contracts and disposable Bash checks, preserve Feature 067 ownership and transaction
behavior, and version only the schemas whose documented structure or behavior changes.

## Project Structure

### Documentation (this feature)

```text
specs/068-clarification-state-normalization/
├── plan.md              # This file
├── research.md          # Phase 0 decisions
├── data-model.md        # Phase 1 entities and invariants
├── quickstart.md        # Phase 1 validation guide
├── contracts/           # Phase 1 contract
└── tasks.md             # Phase 2 output, not created by this command
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
├── skills/highway-clarify/SKILL.md
├── library/templates/output/clarification-record.md
├── library/templates/output/clarification-catalog.md
└── tools/tests/
  ├── highway-clarify.test.sh
  └── output-template.test.sh
.github/skills/highway-clarify/SKILL.md
.claude/skills/highway-clarify/SKILL.md
.cursor/rules/highway-clarify.mdc
specs/068-clarification-state-normalization/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/clarification-state-normalization-contract.md
```

**Structure Decision**: Extend the canonical Clarify skill and its two shared output templates,
add focused static/disposable checks under the existing Bash harness, regenerate the three agent
adapters and catalog indexes, and keep all Feature 068 design artifacts under the feature directory.
No runtime source tree or new storage system is introduced.

## Post-Design Constitution Check

All process and skill-content gates remain PASS or N/A after design. The design adds no dependency,
generator, command, supported artifact type, storage system, or ownership boundary. Normalization,
state, count, and catalog consistency rules are explicit, testable, and covered by the focused
verification plan. No complexity exception is required.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violations. |
