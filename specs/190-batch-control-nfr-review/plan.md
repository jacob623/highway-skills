# Implementation Plan: Batch Control and NFR Review

**Branch**: `190-batch-control-nfr-review` | **Date**: 2026-10-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/190-batch-control-nfr-review/spec.md`

## Summary

Controls and NFRs show every queued item in one review, separated by a line, and accept that set once. The stored statement and rationale are the text from that review. The same card is used when stored active records are reopened. The one-at-a-time capture and the bridge into the next item are removed. Objectives, the record templates, and recommendation building stay as they are. Published copies are regenerated.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-controls/SKILL.md`, `.highway/skills/highway-nfrs/SKILL.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`

**Storage**: Control and NFR records and their catalogs, written once after the batch is accepted, in their current locations and template shape

**Testing**: Update the Controls proposal check in `.highway/tools/tests/output-template.test.sh`, add a batch-review contract check under `.highway/tools/tests/`, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. One acceptance for each queue

**Constraints**: Do not accept Controls or NFRs one at a time. Do not show a bridge into the next item. Do not add a success-measures block. Do not prompt a review of the stored records. Do not change Objectives, the record templates, or recommendation building. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: The capture and stored-record review of two skills, plus the test that still requires the singular Control heading

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. `.highway/tools/tests/output-template.test.sh` requires the singular Control heading, so replacing that assertion records the superseded heading under D3.5. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill sources change. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-controls` and `highway-nfrs`. D1.5 names P10.1: each skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because the record templates are not edited.

Each skill version bump is MAJOR, `5.1.0` to `6.0.0`, because the confirmation sequence changes. A flow that accepted one Control or one NFR at a time no longer conforms.

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 does not add a dependency, a success-measures block, a template edit, or an Objectives edit. The batch card is the queue review and the stored-record review. The write still uses the current statement and rationale sections.

## Project Structure

### Documentation (this feature)

```text
specs/190-batch-control-nfr-review/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-controls/SKILL.md
.highway/skills/highway-nfrs/SKILL.md
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/control-nfr-batch-acceptance.test.sh
```

**Structure Decision**: The behavior change is the two skill sources. The record templates stay the write contract. Adapters and the skill catalog are regenerated from those sources.

## Complexity Tracking

> No constitution violation requires a justification table.
