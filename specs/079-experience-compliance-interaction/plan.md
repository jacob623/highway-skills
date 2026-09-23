# Implementation Plan: Experience Compliance and Interaction Guidance

**Branch**: `079-experience-compliance-interaction` | **Date**: 2026-09-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/079-experience-compliance-interaction/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend the shipped Highway Skills Constitution with an Experience Standard definition, the X
Experience Compliance principle, precedence and review obligations, then extend the shipped
Experience Standard with X2.2-X2.6 interaction rules, rationale, and non-normative examples.
Update the existing shell-based governance inventory and review-output tests so X rules, PASS/
FAIL/N/A reporting, and grandfathering behavior are explicit without introducing a second
enforcement mechanism.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown governance documents; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing `.highway/tools/lib/constitution.sh`, `rule-checks.sh`,
`validate-skill.sh`, and shell test harness; no new dependency

**Storage**: Versioned Markdown files under `.highway/governance/`; disposable shell fixtures
for tests

**Testing**: Focused `.highway/tools/tests/*.test.sh` tests followed by
`.highway/tools/tests/run-all.sh` and `git diff --check`

**Target Platform**: Distributed Highway tree on macOS and GNU/Linux; default macOS Bash 3.2

**Project Type**: Governance/documentation suite with portable shell validation tooling

**Performance Goals**: No runtime performance target; focused validation remains bounded by the
existing document and fixture set

**Constraints**: No new runtime dependency; preserve the existing five-group review output,
PASS/FAIL/N/A vocabulary, Bash 3.2 compatibility, shipped-tree independence, and existing
grandfathering behavior

**Scale/Scope**: Two shipped governance documents, the existing skill validator/inventory,
focused governance tests, and no user-facing skill rewrites unless a skill is otherwise amended


## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Packaging Gate — PASS**: The feature changes shipped governance and validation paths, so D1.1,
  D1.2, and D6.2 apply. The plan keeps development-only references out of shipped files, keeps
  the packaged tree independently valid, and uses only resolvable repository references.
- **Toolchain Gate — PASS**: Validation scripts remain Bash 3.2-compatible and use only the
  declared toolchain under D2.1-D2.4. No package, interpreter, or binary is added.
- **Validation Gate — PASS WITH TEST OBLIGATION**: New or amended review checks must be tested
  against existing fixtures and observed failing/passing per D3.4 and D3.6; no existing assertion
  may be weakened per D3.5.
- **Correspondence Gate — N/A**: No generator script, `.highway/skills/` directory, or generator
  input is changed.
- **Skill Content Gate — N/A**: No `.highway/skills/` or `.highway/library/` content is changed;
  the constitutional review is governed by the process gates above.
- **D3.1/D3.2**: Implementation must record a passing suite before the first code edit and after
  the final edit.
- **D3.3**: Because the review behavior changes, at least one test under `.highway/tools/tests/`
  must be added or amended.

## Project Structure

### Documentation (this feature)

```text
specs/079-experience-compliance-interaction/
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
├── tools/
│   ├── lib/
│   │   ├── constitution.sh
│   │   └── rule-checks.sh
│   ├── validate-skill.sh
│   └── tests/
│       ├── constitution-inventory.test.sh
│       ├── coverage-summary.test.sh
│       ├── rule-checks.test.sh
│       └── run-all.sh
└── skills/

.specify/
└── memory/constitution.md

specs/079-experience-compliance-interaction/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/review-output.md
└── spec.md
```

**Structure Decision**: Keep canonical governance in `.highway/governance/`, enforcement and
coverage tests in `.highway/tools/`, and Feature 079 design records in its existing `specs/`
directory. No generated adapter/catalog changes are expected because neither governance document
is a declared generator input.

## Complexity Tracking

No constitution violations require justification. The design reuses the existing governance
documents, parser, validator, five-group report, and shell test harness.
