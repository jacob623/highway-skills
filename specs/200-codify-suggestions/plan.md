# Implementation Plan: Codify Suggestions

**Branch**: `200-codify-suggestions` | **Date**: 2026-10-31 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/200-codify-suggestions/spec.md`

## Summary

When codify has an accepted implementation and no named action, it shows an ordered list of at most five self-service suggestions before any proposal. Each line is a title and a summary. The person explores one or provides their own. The proposal keeps that title and summary and adds a description, a flowchart, acceptance criteria, and each component's responsibility and boundary. When the invocation already names the action, the list is skipped and that proposal opens immediately. Acceptance still does not run the automation or change the implementation.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md` and `.highway/library/templates/output/codify-record.md`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/validate-library.sh`

**Storage**: The saved proposal at `code/<id>/codify.md`. The suggestion list is not saved. Existing implementation, architecture, decision, request, and finding files are not rewritten

**Testing**: Amend `.highway/tools/tests/highway-codify.test.sh` with the list and proposal strings. No assertion is removed. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target

**Constraints**: At most five suggestions. A named action skips the list. The proposal keeps the current state, the day, and the means. The diagram is a flowchart in the proposal. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: One skill procedure step and one output template. The request close and the assessment skill stay as they are

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`. D6.2 stays satisfied because the skill still cites the codify record template.
- Toolchain Gate: PASS. The amended test uses the existing shell test. D2.1 through D2.4 stay satisfied.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5, D4.6, and D4.7 require catalog, library-catalog, and adapter regeneration after `highway-codify` and `codify-record.md` change.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the amended contract test. D3.4 does not rescore existing fixtures. D3.5 does not apply: no assertion is removed or loosened. D3.2 requires the suite to pass after the last edit.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-codify` and `validate-library.sh` on `codify-record.md`. The skill must still satisfy P1.5, P1.7, P5.6, P5.8, P5.10, P5.12, P6.2, P6.6, P7.1, P7.2, P7.4, P7.5, P8.3, P9.1, P9.6, P9.7, P9.8, and P10.1. The new list is procedure text, not a new set of MUST-level rules.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 1.0.0 | 2.0.0 |
| `codify-record.md` | 1.0.0 | 2.0.0 |

Both are MAJOR because a start that opened a proposal with no suggestion list, and a saved proposal without the new sections, no longer conforms. `highway-request` stays 5.0.0. `highway-assessment` stays 4.0.0. The catalog template is unchanged.

No complexity exception is required.

### Post-design re-check

PASS. The list is a flowchart-free step. The diagram is one fenced flowchart in the proposal and in the saved record. A named action skips the list. Suggestions that fit the current state come first, then the other kind, each in record order, and the list stops at five.

## Project Structure

### Documentation (this feature)

```text
specs/200-codify-suggestions/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/library/templates/output/codify-record.md
.highway/skills/highway-codify/SKILL.md
.highway/tools/tests/highway-codify.test.sh
```

**Structure Decision**: `highway-codify` owns the suggestion list and the richer proposal. The record template owns the saved sections. The request close is not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
