# Implementation Plan: Constitution Runtime Boundary

**Branch**: `145-constitution-runtime-boundary` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/145-constitution-runtime-boundary/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Refactor `.highway/governance/constitution.md` from runtime governance into development-time
governance for shipped Highway skills and shared runtime contracts. Preserve correctness-critical
determinism, owner and persistence safeguards, Experience Compliance, and development validation,
while removing Constitution-owned runtime interaction, context, collaboration, and failure
authority. Do not edit the Experience Standard, Highway Identity, or individual skills; report
downstream migration references instead.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown governance artifacts and Bash-compatible validation scripts

**Primary Dependencies**: `.highway/governance/constitution.md`, `.specify/memory/constitution.md`,
existing Constitution parsers/checks, Highway Experience Standard, Highway Identity, and current
development test harness

**Storage**: No runtime storage; one retained governance document and development validation records

**Testing**: Focused Constitution inventory/alignment/context/coverage/rule checks and
`.highway/tools/tests/run-all.sh`

**Target Platform**: Highway repository development on macOS and GNU-compatible environments

**Project Type**: Governance/documentation repository with development-time shell validation

**Performance Goals**: Preserve the existing validation runtime budget; add no runtime execution cost

**Constraints**: Constitution-only implementation; no protected runtime-file edits; no new runtime
failure or collaboration contract; stable surviving rule IDs; explicit retirement accounting;
existing validator and shell portability conventions

**Scale/Scope**: One Constitution, its definitions/principles/rules/precedence/governance sections,
associated development validators, and an audit of downstream references

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1.3/D1.4**: PASS with implementation evidence. The amendment must not copy rule text from
  the Highway Development Constitution and must record changed elements with stable IDs.
- **D3.1-D3.5**: PASS with implementation evidence. Focused and full validation must run, results
  must distinguish coverage from test outcomes, and the spec/plan/task records remain coherent.
- **D4.5-D4.7**: PASS. No generated runtime adapters or shipped skill files are changed; any
  development validator changes must remain correspondingly mapped and validated.
- **D8.1**: N/A. The feature does not change a shared runtime library artifact or output template.

No gate violations require a complexity exception. The Layer 1 Constitution amendment is evaluated
against the Layer 0 development Constitution, while runtime interaction remains owned by Layer 2.

**Post-design gate**: PASS. Research resolves versioning, stable rule IDs, determinism scope,
context ownership, runtime collaboration/failure boundaries, protected files, and downstream audit
handling. Design artifacts add no runtime dependency or persisted schema.

## Project Structure

### Documentation (this feature)

```text
specs/145-constitution-runtime-boundary/
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
├── governance/constitution.md                 # Layer 1 Constitution amendment
└── tools/tests/                                # Existing development validators
  ├── constitution-inventory.test.sh
  ├── constitution-experience-alignment.test.sh
  ├── constitution-profile-context.test.sh
  ├── coverage-summary.test.sh
  └── rule-checks.test.sh

.specify/memory/constitution.md                 # Layer 0 planning/development governance

specs/145-constitution-runtime-boundary/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/constitution-development-boundary.md
```

**Structure Decision**: Keep the implementation in the existing Layer 1 Constitution and its
development validators. Keep Feature 145 design records under the feature directory. Do not edit
the Layer 2 Experience Standard, Highway Identity, individual skills, runtime templates, or
persisted artifacts.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The existing single-document governance surface and validators are sufficient. |
