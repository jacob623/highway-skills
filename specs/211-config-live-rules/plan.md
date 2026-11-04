# Implementation Plan: Current Proposal Rules

**Branch**: `211-config-live-rules` | **Date**: 2026-11-04 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/211-config-live-rules/spec.md`

## Summary

Before a platform or coding standard add or update, `highway-codify-config` reads that technology's current public documentation. Each When to use and When not to use entry is one deterministic sentence, with **Why it matters:** on the next line, and only the sentence is saved. Each coding rule contains the word must, and one rule keeps encoded or encrypted credentials outside the standard's files. A coding standard saved with no conflicts states its consequence and returns to the menu.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md` and `.highway/library/templates/output/coding-standard.md`. Generators `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`. Validators `validate-skill.sh` and `validate-library.sh`

**Storage**: Organization catalogs `library/coding-standards/codify-platforms.md` and `library/coding-standards/coding-standards.md`, plus one standard file per accepted standard. Why it matters is not stored

**Testing**: New `.highway/tools/tests/config-live-rules.test.sh`, observed failing first. Two `highway-codify-config` pins and the `coding-standard.md` pin move to `3.0.0`, with reasons in [research.md](research.md) R6. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: None. The documentation check happens once before the proposal and writes nothing

**Constraints**: Each `###` step stays at or under 400 words. The skill body does not gain the keywords MUST or SHOULD. No shipped path references `.specify/` or `specs/`. `highway-codify` is unchanged

**Scale/Scope**: One skill, one output template, one new test, three version pins

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The library catalog, the skill catalog, and the adapters are regenerated after the skill and template change (D4.5 through D4.7).
- **Validation Gate**: PASS with recorded replacements. The `highway-codify-config` pin moves from `2.0.0` to `3.0.0` in `codify-config-skill.test.sh` and `codify-file-layout.test.sh`. The `coding-standard.md` pin in `codify-file-layout.test.sh` moves from `2.0.0` to `3.0.0`. Reasons are in R6 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on `highway-codify-config`, the only skill that cites `coding-standard.md`, and `validate-library.sh` on that template.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on `highway-codify-config`. The new instructions stay imperative and do not add MUST or SHOULD, so P1.1 and P7.5 do not gain new normative lines. Each `###` step still stays at or under 400 words.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify-config` | 2.0.0 | 3.0.0 |
| `coding-standard.md` | 2.0.0 | 3.0.0 |

MAJOR for both. The same add or update can produce a different proposal, a coding standard saved with no conflicts returns to the menu, and a standard file's rules now contain the word must, including the credential rule. `codify-platforms.md` and `coding-standards-catalog.md` stay at their current versions because a saved cell is still the rule text.

No complexity exception is required.

### Post-design re-check

PASS. `current` is its own step, at 77 words. `platform proposal` is 279 words. `standard proposal` is 383 words. The closing question does not gain a Why it matters line. Platform writes are unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/211-config-live-rules/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── proposal-rules.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md
.highway/library/templates/output/coding-standard.md
.highway/tools/tests/config-live-rules.test.sh          (new)
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-file-layout.test.sh
```

**Structure Decision**: The documentation check is a `current` step both proposals open for an add or update. A removal skips it. The use-rule shape is one paragraph in the procedure so neither proposal repeats it.

## Complexity Tracking

> No constitution violation requires a justification table.
