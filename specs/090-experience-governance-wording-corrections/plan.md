# Implementation Plan: Experience Governance Wording Corrections

**Branch**: `090-experience-governance-wording-corrections` | **Date**: 2026-09-24 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/090-experience-governance-wording-corrections/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Correct the Experience Standard's Interactive Workflow UX Contract authority wording, align X2.9's
trigger with its five Observable outcomes, remove orphaned amendment rationale, move Principle XII
directly after Principle V, and remove the duplicate Principle XI rationale. The implementation
changes only the two governing documents and the focused validation assertions needed to prove the
corrections; it adds no principles, rule identifiers, tiers, N/A conditions, or skill migrations.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown governance documents; Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing `.highway/tools/lib` parsers, rule checks, and shell test harnesses; no new dependency

**Storage**: Git-tracked Markdown governance documents and shell validators

**Testing**: Focused constitution inventory and UX alignment tests, followed by `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and portable POSIX-like environments supported by the existing Bash 3.2-compatible toolchain

**Project Type**: Governance/documentation system with shell-based validation tooling

**Performance Goals**: Preserve the existing validation runtime budget; no new runtime performance contract

**Constraints**: Preserve all existing identifiers, tiers, N/A applicability, and unaffected rule text; classify the precedence change under the Constitution's own versioning policy; do not modify individual skill files

**Scale/Scope**: Two governing documents, amendment metadata, precedence/count records, and focused validation assertions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Passes before design:

- D1.3/D1.4: the plan keeps development records separate from shipped governance rules and cites
  the governing documents rather than restating unrelated development rules.
- P1.1-P1.4: no new rule is introduced; the corrected X2.9 wording must retain its existing
  keyword, Observable shape, Tier, and normative-length limit.
- P7.3: the wording alignment must not restate or create a competing rule source; the UX Contract
  remains interpretive and organizational guidance.
- Versioning Policy: the Experience Standard wording correction and Constitution precedence change
  are classified independently, with the latter assessed for conflict-resolution impact rather than
  assumed to be a PATCH.
- Scope: only the two governing documents and validation artifacts required by the feature may
  change; individual skill files remain out of scope.

No gate violation is currently identified. Post-design review must verify the concrete amendment
metadata, preserved identifiers, and focused validator coverage.

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
├── governance/
│   ├── constitution.md
│   └── experience-standard.md
└── tools/
  └── tests/
    ├── constitution-inventory.test.sh
    ├── highway-ux-alignment.test.sh
    └── run-all.sh

specs/090-experience-governance-wording-corrections/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

**Structure Decision**: This feature changes two distributed governance documents and only the
focused validation assertions needed to recognize their corrected wording, precedence, and history.
It exposes no API, CLI, or external system interface, so no `contracts/` artifact is required.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
No Constitution Check violations require justification.
