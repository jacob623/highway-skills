# Implementation Plan: Highway Codify

**Branch**: `199-highway-codify` | **Date**: 2026-10-31 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/199-highway-codify/spec.md`

## Summary

One accepted run of `highway-codify` writes one self-service automation for one accepted implementation. The person chooses that implementation by title or description. The proposal is one action, Day 1 or Day 2, and one accepted architecture as the means. Acceptance writes the catalog row, the saved proposal, a two-part readme, and the component folders. It does not run the automation and does not change the request, finding, implementation, architecture, or decision. An accepted request whose words match an implementation closes with codify for that title and that action. No match still closes with discovery. An explored finding still becomes a request.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: New output templates for the codify record and catalog. `SKILL.md` sources of `highway-codify` (new) and `highway-request` (close only). `highway-assessment` stays as it is. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/validate-library.sh`

**Storage**: `code/code.md` and one folder per accepted automation at the governed repository root. Existing request, finding, implementation, architecture, and decision files are not rewritten

**Testing**: Add `.highway/tools/tests/highway-codify.test.sh`. Amend the citing-skill count in `.highway/tools/tests/output-template.test.sh`. Record that amendment in `retirements.md`. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target

**Constraints**: One acceptance writes one automation. The means is an accepted architecture. Choice lists show titles and descriptions. The request close states exactly one next step once one implementation is selected, and it does not state the day. A request-led proposal uses the action the request asks for. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Two new output templates, one new skill, and the request skill's closing message. Assessment is unchanged

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`. D6.2 stays satisfied because the new skill cites the new template paths.
- Toolchain Gate: PASS. The new test uses the existing shell tests. D2.1 through D2.4 stay satisfied. No new command and no new runtime dependency.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5, D4.6, and D4.7 require catalog, library-catalog, and adapter regeneration after the new skill and the two templates are added, and after `highway-request` changes.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the new contract test. D3.4 does not rescore existing fixtures: the new check reads skill and template text. D3.5 applies to the citing-skill count in `output-template.test.sh`, recorded in `retirements.md`. D3.2 requires the suite to pass after the last edit.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-codify` and `highway-request`, and `validate-library.sh` on the two new templates. The new skill must satisfy P1.5, P1.7, P5.6, P5.8, P5.10, P5.12, P6.2, P6.6, P7.1, P7.2, P7.4, P7.5, P8.3, P9.1, P9.6, P9.7, P9.8, and P10.1. The request close is procedure text, not a new set of MUST-level rules, so P7.4 on `highway-request` stays within its current limit.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-request` | 4.0.0 | 5.0.0 |
| `highway-codify` | none | 1.0.0 |
| `codify-record.md` | none | 1.0.0 |
| `codify-catalog.md` | none | 1.0.0 |

`highway-request` is MAJOR because a close that always names discovery no longer conforms. The new skill and templates start at 1.0.0. `highway-assessment` stays 4.0.0.

No complexity exception is required.

### Post-design re-check

PASS. The automation id is `CDY` plus eight hex digits derived from the action title. A running instance is read only from two phrases in the implementation record. More than five matches keep five by exact title, then capability title, then summary, each in catalog order. The request close carries the implementation title and the action, and codify states the day.

## Project Structure

### Documentation (this feature)

```text
specs/199-highway-codify/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
├── retirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/library/templates/output/codify-record.md
.highway/library/templates/output/codify-catalog.md
.highway/skills/highway-codify/SKILL.md
.highway/skills/highway-request/SKILL.md
.highway/tools/tests/highway-codify.test.sh
.highway/tools/tests/output-template.test.sh
```

The governed repository root receives the automation files. Those paths are declared by the skill. They are not templates.

```text
code/code.md
code/CDY<8 hex>/codify.md
code/CDY<8 hex>/README.md
code/CDY<8 hex>/<component>/
```

**Structure Decision**: The templates own the saved proposal and the catalog. `highway-codify` owns the proposal, the write, and the readme. `highway-request` owns the match and the one next step. `highway-assessment` still turns an explored finding into a request and does not start codify.

## Complexity Tracking

> No constitution violation requires a justification table.
