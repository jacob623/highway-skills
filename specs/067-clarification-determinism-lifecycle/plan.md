# Implementation Plan: Clarification Determinism and Lifecycle Contracts

**Branch**: `067-clarification-determinism-lifecycle` | **Date**: 2026-09-22 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/067-clarification-determinism-lifecycle/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Feature 067 extends `highway-clarify` and the clarification catalog contract with explicit deterministic
ambiguity, contradiction, finding-identity, status-precedence, and catalog-bootstrap rules. Add
the informational Clarification Path column while retaining catalog version `1.0.0`, advance the
skill metadata to `1.3.0`, update focused Bash 3.2.57 contract/fixture tests, regenerate derived
artifacts, and validate the complete repository suite.

## Technical Context

**Language/Version**: Markdown skill contracts; Bash 3.2.57 validation scripts

**Primary Dependencies**: Existing `highway-clarify` contract, clarification record/catalog templates, declared Clarification Profiles and contradiction rules, and repository test harness

**Storage**: User-owned clarification artifacts and `clarifications/clarifications.md`; no new storage system

**Testing**: Focused Clarify/template tests, skill/library validators, generated-artifact correspondence checks, and serialized full suite

**Target Platform**: macOS and GNU-like shell environments supported by the repository

**Project Type**: Repository-distributed agent skill suite with Markdown contracts and shell validation

**Performance Goals**: Deterministic local processing for the bounded clarification inventory; no network or timestamp-dependent work

**Constraints**: Exact phrase matching only; rule-only contradiction findings; immutable finding identifiers; status precedence; same validation for bootstrap and existing catalogs; zero partial writes; no command or ownership changes; Bash 3.2.57 compatibility; no runtime dependency

**Scale/Scope**: One clarification catalog per repository, bounded clarification records, four supported artifact types, and changes limited to Clarify, its shared catalog template, focused tests, generated artifacts, and feature design records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The change modifies shipped Clarify/template paths; packaged-tree validation and path checks are required. |
| Toolchain Gate (D2.1-D2.4) | PASS | Focused tests remain Bash 3.2.57-compatible and use the declared repository toolchain only. |
| Generator Gate (D4.1-D4.4) | N/A | No generator script is changed. |
| Correspondence Gate (D4.5-D4.7) | PASS | `highway-clarify` and the shared catalog template are generator inputs; derived adapters and indexes must be regenerated. |
| Validation Gate (D3.4-D3.5) | PASS | New behavior checks are evaluated against existing fixtures and must not weaken existing assertions. |

### Skill content gates

| Rule | Verdict | Evidence |
|---|---|---|
| P5.1-P5.5 | PASS | New ambiguity, contradiction, identity, status, and bootstrap branches will name failure conditions and one explicit next action. |
| P6.1/P6.6 | PASS | Matching, precedence, profile extension, and bootstrap decisions use declared ordered rules and deterministic inputs. |
| P8.3/P8.4 | PASS | The existing Verification section is extended with named deterministic and lifecycle checks. |
| P9.1 | PASS | The catalog output continues to cite `.highway/library/templates/output/clarification-catalog.md` as its complete structure. |

No gate is unresolved; no complexity exception is required.

## Phase 0 Research Summary

See [research.md](./research.md). The selected design preserves Feature 066 ownership and
transaction conventions, adds the requested contracts in the specified section order, stores
finding identity state with the clarification artifact, and uses one validation path for
bootstrap and existing catalogs.

## Project Structure

### Documentation (this feature)

```text
specs/067-clarification-determinism-lifecycle/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/
├── skills/highway-clarify/SKILL.md
├── library/templates/output/clarification-catalog.md
└── tools/tests/
    ├── highway-clarify.test.sh
    └── output-template.test.sh
specs/067-clarification-determinism-lifecycle/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/clarification-determinism-contract.md
clarifications/
└── clarifications.md
```

**Structure Decision**: Extend the existing Markdown skill and shared-template surfaces in
`.highway/`, add focused static and disposable-fixture checks under the existing test harness,
and document the contracts in this feature directory. The user-owned clarification catalog is
created by the workflow and is not a development fixture.

## Post-Design Constitution Check

All process gates remain PASS or N/A after design. The design adds no runtime dependency, no new
generator, no new shipped storage system, and no change to command syntax or ownership. The Skill
Content Gate remains PASS because the Clarify skill cites the complete shared catalog template and
its Verification and Error Handling sections will name each new deterministic branch.

No constitution violations or complexity exceptions.

## Implementation Status

Feature 067 implementation and validation completed on 2026-09-22. The deterministic Clarify
contracts, lifecycle record metadata, catalog path/template, focused tests, generated adapters and
indexes, and validation evidence are complete. No extension hooks were configured. The serialized
full suite completed with 42 passed and 0 failed.
