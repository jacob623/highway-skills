# Implementation Plan: Controls and NFR Review Output Contracts

**Branch**: `078-controls-nfr-review-output` | **Date**: 2026-09-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/078-controls-nfr-review-output/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Clarify the existing Control and NFR onboarding contracts so their review output fields, empty
review results, proposal-state boundary, deterministic ordering, readiness ownership, and duplicate
failure behavior are explicit and testable. The implementation remains documentation- and
contract-focused: update canonical skills and focused shell assertions, then regenerate required
distributed artifacts through the existing workflow. No new persistence model, workflow stage,
identifier scheme, readiness state, governance artifact, or ownership boundary is introduced.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2-compatible shell plus Markdown/YAML contracts

**Primary Dependencies**: Existing `.highway/tools/` test, validation, catalog, and adapter tooling

**Storage**: Existing root-level `library/governance/` records and catalogs; proposal state remains
disposable and no new storage is introduced

**Testing**: Focused Bash contract/fixture tests, existing readiness and routing tests, generated
artifact validation, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and Linux shells; changed scripts must remain Bash 3.2-compatible

**Project Type**: Internal command/skill contract suite with canonical Markdown skills and shell tests

**Performance Goals**: No new runtime performance target; review output must be deterministic and
complete within the existing interactive workflow

**Constraints**: Preserve Feature 077 behavior; no new runtime model or artifact; explicit empty
result shape; no timestamps, randomness, environment values, filesystem-order dependence, or session
state; no partial writes on duplicate failure; maintain existing ownership boundaries

**Scale/Scope**: Two canonical skills, their review contracts, focused fixtures/tests, and any
existing generated correspondence required by source changes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates before Phase 0:

- Layer/shippability: PASS. Canonical source contracts remain separate from user-owned governance
  records, and no development-only path is added to shipped content.
- Dependency/toolchain: PASS. No dependency is added; changed tests remain within the declared Bash
  3.2-compatible toolchain.
- Verification: PASS for planning. The design requires focused tests before and after contract edits,
  plus full-suite and diff validation after implementation.
- Generated correspondence: PASS pending implementation. Canonical skill changes require the existing
  catalog, adapter, and correspondence checks; no generator is changed.
- Documentation currency: PASS pending implementation. Contract references and focused assertions
  must be updated together.

No gate is an unresolved violation. Phase 0 research and Phase 1 design may proceed.

Post-design re-evaluation:

- No new persistence model, runtime dependency, interface, workflow stage, readiness state, or
  governance artifact was designed.
- The only planned implementation surfaces are the two canonical skill contracts, focused fixture
  assertions, and regenerated correspondence where source skills change.
- Constitution gates remain PASS pending implementation validation and generated-artifact checks.

Process gates before Phase 0:

- Layer/shippability: PASS. Design keeps canonical source contracts separate from user-owned
  governance records and does not add development-only paths to shipped content.
- Dependency/toolchain: PASS. No dependency is added; any changed test remains within the declared
  Bash 3.2-compatible toolchain.
- Verification: PASS for planning. The design requires focused tests before and after contract edits,
  and a full-suite/diff check after implementation.
- Generated correspondence: PASS pending implementation. If canonical skill text changes, the
  existing catalog/adapter regeneration and correspondence checks must run; no generator is changed.
- Documentation currency: PASS pending implementation. Contract references and focused assertions
  must be updated together.

No gate is an unresolved violation. Phase 0 research and Phase 1 design may proceed; implementation
must re-evaluate generated-artifact and validation gates after source changes.

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
├── skills/
│   ├── highway-controls/SKILL.md
│   └── highway-nfrs/SKILL.md
└── tools/tests/
  ├── highway-controls-onboarding.test.sh
  ├── highway-nfr-onboarding.test.sh
  ├── governance-routing.test.sh
  ├── readiness-owner-states.test.sh
  └── fixtures/controls-nfr-onboarding/

.github/skills/          # generated correspondence
.claude/skills/           # generated correspondence
.cursor/rules/            # generated correspondence
library/governance/       # existing user-owned records, outside this feature's source tree
```

**Structure Decision**: Keep the existing canonical skill and shell-test layout. Feature 078 adds
focused assertions and contract documentation under `.highway/tools/tests/` and design artifacts
under this feature directory. It does not add application code, a runtime service, a new governance
record type, or an external interface.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | No constitution violations identified. | Existing skill contracts, fixture harness, validators, and generated-artifact workflow are sufficient. |
