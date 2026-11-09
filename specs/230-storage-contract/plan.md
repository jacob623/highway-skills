# Implementation Plan: Storage Contract

**Branch**: `230-storage-contract` | **Date**: 2026-11-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/230-storage-contract/spec.md`

## Summary

A new shipped governance document, `.highway/governance/storage.md`, defines the four repository operations with a Local, Remote, and Chat entry each; only Local is supported. The skills constitution gains P2.6, an `[auto]` rule that a skill reaches the repository only through those operations, decided by a new registered check that scans skill prose outside fenced blocks for a script, a `git` command, an absolute path, or a file time. `highway-help` stops naming the catalog generator. highway-codify numbers a feature from a new Features table in the product's `metadata.md` instead of listing the features folder. The always-on agent context points to the storage contract.

## Technical Context

**Language/Version**: Markdown skill and governance source, Bash 3.2.57-compatible validator and tests

**Primary Dependencies**: `.highway/tools/lib/rule-checks.sh` (registry and check), `validate-skill.sh`, `validate-library.sh`. Skills `highway-codify` and `highway-help`. Template `codify-metadata.md`. Instruction `highway-agent-context.md`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, `generate-library-catalog.sh`, and `generate-instructions.sh`

**Storage**: Product `metadata.md` gains a Features table

**Testing**: New `.highway/tools/tests/storage-contract.test.sh`, observed failing first. A seeded P2.6 case in `rule-checks.test.sh`. Moved pins in [research.md](research.md) R8. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: codify `write` stays at or under 250 words. P2.6 rule text is one keyword and 25 words or fewer. No shipped path references `.specify/` or `specs/`. The check uses `awk` only

**Scale/Scope**: One new governance document, one constitution rule and check, two skills, one template, one instruction, 14 fixtures, one new test, the pins in R8

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. `storage.md` ships through the existing `include .highway/governance` row, with no manifest change. It and every edited shipped file carry no `.specify/` or `specs/` reference (D1.1). The distribution's own validator runs the new check from the shipped `rule-checks.sh` (D1.2). No new Markdown link (D6.2).
- **Toolchain Gate**: PASS. The check and test use `awk`, `grep`, `sed`, `mktemp`, `cat`, `mkdir`, `rm`, and `wc`. No Bash 4 feature (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. Skill versions, a template version, and an instruction change, so the skill catalog, adapters, library catalog, and instructions are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS. D3.4: every fixture's verdict under the new check is recorded in R3 before the check is wired in. D3.5: the moved pins in R8 supersede version values only, and the reworded fixture lines change no asserted defect.
- **Verification**: D3.1 baseline before the first edit, D3.2 after the last. D3.3 is met by the new test. D3.6: the new test is observed failing first. D3.8: the new test declares its instrument class.
- **Shared library review (D8.1)**: `codify-metadata.md` gains the Features table. Its only writer and reader is `highway-codify`, updated in the same change.
- **Live documentation (D6.1)**: `_authoring-standard.md` and `.highway/DISTRIBUTION.md`, per R9.

Skill content gates, from `.highway/governance/constitution.md`:

- P1.1, P1.3: the P2.6 rule has one keyword and 13 words.
- P2.6: every shipped skill passes after `highway-help` is reworded.
- P5.2: help's missing-catalog item names one next action, abort.
- P7.5: codify `write` stays under 250 words.
- P9.1: the Features columns are defined in the template, not the skill.
- Self-application of the constitution amendment: P1.1 through P1.4, P6.4, P6.6, and P7.3 are reviewed in the Sync Impact Report.
- PASS pending `validate-skill.sh` and `validate-library.sh`.

Version bumps, per R8: constitution 9.1.0 to 10.0.0, `highway-codify` 13.0.0 to 14.0.0, `highway-help` 3.0.4 to 3.1.0, `codify-metadata.md` 1.0.0 to 2.0.0.

### Post-design re-check

PASS. [contracts/wording.md](contracts/wording.md) names every changed line. R3 records fixture verdicts. R8 names every moved pin.

## Project Structure

### Documentation (this feature)

```text
specs/230-storage-contract/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── wording.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/governance/storage.md                     (new)
.highway/governance/constitution.md                (P2.6, 10.0.0)
.highway/tools/lib/rule-checks.sh                  (registry row, rc_check_P2_6, library exempt)
.highway/instructions/highway-agent-context.md
.highway/skills/highway-help/SKILL.md
.highway/skills/highway-codify/SKILL.md
.highway/library/templates/output/codify-metadata.md
.highway/skills/_authoring-standard.md
.highway/DISTRIBUTION.md
.highway/tools/tests/fixtures/*/SKILL.md           (Verification lines)
.highway/tools/tests/storage-contract.test.sh      (new)
.highway/tools/tests/rule-checks.test.sh           (seeded P2.6 case)
.highway/tools/tests/*.test.sh                     (moved pins, R8)
```

**Structure Decision**: The check lives with the other registered checks. Generated catalogs, adapters, and instruction files are refreshed after the source edits.

## Complexity Tracking

No constitution violation requires a justification.
