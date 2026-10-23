# Implementation Plan: Static Operating NFRs

**Branch**: `191-static-operating-nfrs` | **Date**: 2026-10-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/191-static-operating-nfrs/spec.md`

## Summary

A new NFR review includes two operating limits, **No system hosting** and **Direct purchase**, inferred from accepted material or filled with the default text. The person accepts, corrects, or removes each one with the rest of the set. A Request proposal copies an accepted limit, by those titles, into hosting, solution class, procurement, and vendor. Discovery is not edited. It already excludes options that violate those filled fields.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-nfrs/SKILL.md`, `.highway/skills/highway-request/SKILL.md`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`

**Storage**: Accepted limits are ordinary NFR records. The Request stores the copied field values in its current solution-constraint section.

**Testing**: Add a contract check under `.highway/tools/tests/`, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. Both limits appear in one NFR review

**Constraints**: Do not ask a question in place of either limit. Do not omit either limit because the material is silent. Do not recreate a removed or retitled limit from another NFR. Do not put these limits into Profile, Vision, Competitive Path, Objectives, or Controls. Do not edit Discovery. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: The new-set NFR review in one skill, and the Request proposal fields in one skill

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. No constitution or experience-standard edit. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to add or amend a test. No current test asserts the absence of these two limits, so D3.5 does not require a removed assertion. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires catalog and adapter regeneration after the skill sources change. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-nfrs` and `highway-request`. D1.5 names P10.1: each skill keeps its Experience Standard reference and does not restate generic interaction rules. D8.1 does not apply because no shared template is edited.

The NFR skill version bump is MAJOR, `6.0.0` to `7.0.0`, because a new review that omitted the two limits no longer conforms. The Request skill version bump is MAJOR, `2.0.0` to `3.0.0`, because a proposal that left those four fields unknown no longer conforms when the titled NFRs are accepted.

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 does not add a dependency, a Discovery edit, or a third limit. The class value is named. The Request copies by exact title.

## Project Structure

### Documentation (this feature)

```text
specs/191-static-operating-nfrs/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-nfrs/SKILL.md
.highway/skills/highway-request/SKILL.md
.highway/tools/tests/static-operating-nfrs.test.sh
```

**Structure Decision**: The behavior change is the NFR review and the Request proposal. Discovery already consumes the filled Request fields. Adapters and the skill catalog are regenerated from the edited sources.

## Complexity Tracking

> No constitution violation requires a justification table.
