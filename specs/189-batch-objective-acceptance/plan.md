# Implementation Plan: Batch Objective Acceptance

**Branch**: `189-batch-objective-acceptance` | **Date**: 2026-10-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/189-batch-objective-acceptance/spec.md`

## Summary

The guided objectives flow shows every queued objective in one review, separated by a line, and accepts that set once. The stored statement, success measures, and rationale are the text from that review. The one-at-a-time capture and the bridge into the next objective are removed. Review of objectives already stored, recommendation, and queue building stay as they are. The objective record template is unchanged.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-objectives/SKILL.md`, `.highway/library/templates/output/objective-record.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`

**Storage**: Objective records and the objective catalog, written once after the batch is accepted, in their current locations and template shape

**Testing**: Add a batch-review contract check under `.highway/tools/tests/`, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. One acceptance for the whole queue

**Constraints**: Do not accept objectives one at a time. Do not show a bridge into the next objective. Do not prompt a review of the stored records. Do not add a closing line after the write. Do not change the stored-objective review, the recommendation flow, or the record template. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: The capture step of one skill, plus the places that send the queue into that step

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. No current test asserts the one-at-a-time capture, so D3.5 does not require a removed assertion. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill source changes. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-objectives`. D1.5 names P10.1: the skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because `objective-record.md` is not edited.

The objectives skill version bump is MAJOR, `5.1.0` to `6.0.0`, because the confirmation sequence changes. A flow that accepted one objective at a time no longer conforms.

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 does not add a dependency, a second acceptance, a template edit, or a change to the stored-objective review. The batch review is the only new conversation, and the write still uses the current record sections.

## Project Structure

### Documentation (this feature)

```text
specs/189-batch-objective-acceptance/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-objectives/SKILL.md
.highway/tools/tests/objective-batch-acceptance.test.sh
.highway/library/templates/output/objective-record.md   # cited, not edited
```

**Structure Decision**: The behavior change is the objectives skill source. The record template stays the write contract. Adapters and the skill catalog are regenerated from that source.

## Complexity Tracking

> No constitution violation requires a justification table.
