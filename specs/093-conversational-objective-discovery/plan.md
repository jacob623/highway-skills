# Implementation Plan: Conversational Objective Discovery

**Branch**: `093-conversational-objective-discovery` | **Date**: 2026-09-25 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/093-conversational-objective-discovery/spec.md`

## Summary

Replace the fixed Objective creation interview with owner-controlled adaptive conversational
discovery while keeping Setup as an orchestrator. Amend the shipped `highway-objectives` and
`highway-setup` contracts, focused Bash tests, generated adapters, and correspondence checks so
that transient discovery can gather Outcome, Success, and Significance evidence without changing
the durable Objective record, catalog, readiness, identifier, relationship, or transaction
contracts.

The implementation will preserve the shared Objective record and catalog templates as the complete
structural authorities, persist no conversation state, and claim creation only after the record and
catalog both pass persistence verification.

## Technical Context

**Language/Version**: Markdown skill contracts; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing `highway-setup`, `highway-objectives`, Profile context,
Highway Experience Standard, shared Objective output templates, skill/library validators,
catalog and adapter generators, and `.highway/tools/tests/run-all.sh`

**Storage**: Existing user-owned Markdown records under `library/objectives/` and catalog at
`library/governance/objectives.md`; no new transient or Setup persistence

**Testing**: Focused Objective and Setup contract/executable tests, template and correspondence
tests, validators, generated-artifact checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree validated on macOS and GNU-like environments
using Bash 3.2-compatible scripts

**Project Type**: Governed interactive Markdown skill suite and user-owned governance artifact workflow

**Performance Goals**: Preserve one unresolved user decision per interaction turn and existing
test-suite execution envelope; no service latency or throughput target applies

**Constraints**: Preserve owner authority, shared-template citations, exact opening text, permanent
IDs, readiness and version semantics, Bash 3.2 compatibility, no runtime dependency, no persisted
conversation state, no `.highway` user-owned Objective writes, and byte preservation on failure

**Scale/Scope**: Two shipped skill contracts, focused tests, generated adapters/catalog/manifests,
two durable Objective outputs, and one transient conversation per invocation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Development Constitution

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | PASS | The amended skills remain shipped `.highway/skills/` artifacts and development documents remain under `specs/`; no shipped skill references development-only paths. |
| Toolchain Gate | PASS | Focused tests use the existing Bash 3.2-compatible toolchain and add no package, interpreter, binary, or runtime dependency. |
| Generator Gate | N/A | No generator implementation changes are required; source-skill changes will still trigger regeneration and correspondence validation. |
| Correspondence Gate | PASS | Changes to shipped skill inputs require catalog, adapter, manifest, and generated-output correspondence checks. |
| Validation Gate | PASS | Static contract checks and executable fixtures remain distinct and cover ownership, adaptive flow, persistence, failure, and no-resume behavior. |
| Skill Content Gate | PASS | The plan preserves existing source, template, owner, and distribution boundaries and uses the repository validators. |

### Highway Skills Constitution and Experience Standard

Applicable review includes the skill authoring, dependency, deterministic workflow, verification,
owner-boundary, shared-output, repository-context, persistence-completion, and versioning rules;
the amended Objective skill must retain citations to both shared Objective templates. Applicable
Experience Standard review covers one unresolved response-demanding question or decision, exact
owner-content forwarding, natural validation, exits, `New interaction` resume behavior, and no
false completion claim.

**Gate status: PASS.** No complexity exception is required. Phase 0 research resolves the design
choices identified by the technical context, and Phase 1 artifacts preserve the gates.

## Project Structure

### Documentation (this feature)

```text
specs/093-conversational-objective-discovery/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── objective-conversational-workflow.md
│   ├── persistence-completion.md
│   └── setup-objective-handoff.md
└── tasks.md             # Phase 2 output (/speckit-tasks command; not created here)
```

### Source and test paths

```text
.highway/
├── skills/
│   ├── highway-objectives/SKILL.md
│   └── highway-setup/SKILL.md
├── library/templates/output/
│   ├── objective-record.md
│   └── objective-catalog.md
└── tools/tests/
    ├── objective-management.test.sh
    ├── objective-rename-contract.test.sh
    ├── highway-setup.test.sh
    ├── highway-setup-executable.test.sh
    ├── output-template.test.sh
    ├── validate-skill.test.sh
    └── run-all.sh

library/
├── objectives/OBJXXXXXX.md
└── governance/objectives.md
```

**Structure Decision**: Keep behavior in the two existing shipped skills, retained structure in
the two existing shared templates, and validation in the existing shell test suite. Use temporary
repositories or fixtures for user-owned outputs. Regenerate adapters, catalogs, manifests, and
distribution metadata from source changes; do not hand-edit generated outputs.

## Phase 0: Research

Research is recorded in [research.md](research.md). It resolves the implementation boundary,
template authority, transient-state policy, context failure boundary, persistence ordering, and
static-versus-executable validation strategy.

## Phase 1: Design and Contracts

- [data-model.md](data-model.md) defines transient conversation/proposal state, durable records and
  catalogs, readiness, context boundaries, and state transitions.
- [contracts/objective-conversational-workflow.md](contracts/objective-conversational-workflow.md)
  defines adaptive discovery, proposal validation, creation ordering, failure, and resume behavior.
- [contracts/setup-objective-handoff.md](contracts/setup-objective-handoff.md) defines conditional
  Setup introduction, owner delegation, forwarding, terminality, and resume behavior.
- [contracts/persistence-completion.md](contracts/persistence-completion.md) defines retained outputs,
  all-or-nothing mutation, verification, failure claims, versions, and relationships.
- [quickstart.md](quickstart.md) defines focused, correspondence, and full-suite validation.

### Post-Design Constitution Check

The Phase 1 design preserves the pre-design gate results. It adds no runtime dependency, shipped
development reference, competing artifact store, or alternate retained schema. Shared Objective
templates remain structural authorities; the contracts keep Setup and Objectives ownership
separate; tests cover both static document obligations and executed behavior. All gates remain
`PASS` or `N/A`; no complexity exception is required.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| None | N/A | The feature stays within the existing skills, templates, shell tests, generators, and user-owned output paths. |
