# Implementation Plan: Experience Rule Table Alignment

**Branch**: `080-experience-rule-table-alignment` | **Date**: 2026-09-23 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/080-experience-rule-table-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Correct the presentation and terminology of the X2 Interaction section in the authoritative
Experience Standard. Move X2.2-X2.6 into the existing rule table, add the two applicability
definitions required by X2.3/X2.4, and separate the no-long-running-activity example into an
N/A Scenario/Example table that records N5. Add focused shell assertions for row shape,
definitions, duplicate prevention, and N/A structure while preserving Feature 079 rule meaning,
the X namespace, and the user-owned distribution manifest.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown governance documents; Bash 3.2.57-compatible tests

**Primary Dependencies**: Existing macOS/BSD command-line toolchain declared by the development constitution

**Storage**: Version-controlled Markdown and shell files; no runtime storage

**Testing**: `.highway/tools/tests/rule-checks.test.sh`, `.highway/tools/tests/coverage-summary.test.sh`, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway tree on macOS and GNU-compatible environments

**Project Type**: Governance documentation and shell validation suite

**Performance Goals**: Focused checks complete within the existing repository test-suite runtime

**Constraints**: Preserve approved X2.1-X2.6 obligations and samples; preserve N5 and PASS/FAIL/N/A vocabulary; do not modify skills, user-owned governance artifacts, generated artifacts, or `.highway/tools/.distribution-manifest`; keep tests Bash 3.2-compatible and add no dependencies.

**Scale/Scope**: One shipped governance document, one focused validation test, and related existing assertions under Feature 080.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Pre-design gate evaluation**

| Gate | Verdict | Evidence |
|---|---|---|
| Packaging Gate | PASS | Changed `.highway/` files remain within the declared distributed tree; final validation will run packaged-tree checks and resolve references. |
| Toolchain Gate | PASS | Focused tests use the existing Bash 3.2-compatible shell and declared utilities; no runtime dependency is added. |
| Generator Gate | N/A | No `generate-*.sh` script is changed. |
| Correspondence Gate | N/A | No skill directory or declared generator input is changed. |
| Validation Gate | PASS | Existing assertions will be amended without weakening them; new checks will be exercised against current fixtures before completion. |
| Skill Content Gate | N/A | No file under `.highway/skills/` or `.highway/library/` is changed. |

Process requirements carried into implementation: begin and end with `run-all.sh` passing
(D3.1/D3.2), amend a focused test for this validation change (D3.3), record seeded-failure
evidence for new assertions (D3.4/D3.6), preserve assertion strength (D3.5), and keep live
documentation synchronized (D6.1). The Experience Standard amendment will list its changed
table, definitions, rationale prose, and example structure in its sync impact record per the
document's own versioning and self-application policy.

**Post-design gate re-evaluation**

The focused X2 checks pass, `git diff --check` passes, the distribution manifest is unchanged,
and no extension hooks are configured. The full suite currently reports `44 passed, 1 failed`
because `adapter-coverage.test.sh` detects pre-existing stale catalog files
(`.highway/catalog/index.json` and `.highway/catalog/index.md`); neither file is changed by
Feature 080. This is recorded as a baseline repository blocker for D3.2, not attributed to the
feature plan. The focused validation evidence is otherwise PASS; the full suite must be rerun
after the catalog drift is resolved before implementation is marked complete.

## Project Structure

### Documentation (this feature)

```text
specs/080-experience-rule-table-alignment/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

```text
 .highway/
 ├── governance/
 │   └── experience-standard.md       # authoritative X2 rules and examples
 └── tools/tests/
     ├── rule-checks.test.sh           # focused X2 row/definition/example assertions
     ├── coverage-summary.test.sh      # existing N/A and verdict-vocabulary assertions
     └── run-all.sh                     # full validation entry point
```

**Structure Decision**: This is a shipped governance-document amendment with shell validation,
not an application feature. The authoritative document remains under `.highway/governance/`; the
focused assertions remain under `.highway/tools/tests/`; Feature 080 planning records remain under
`specs/080-experience-rule-table-alignment/`. No external contracts are generated.

## Complexity Tracking

No constitution violations or exceptional complexity require justification.
