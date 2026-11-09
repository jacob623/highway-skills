# Implementation Plan: Codify Plan Review Question

**Branch**: `231-codify-plan-review-question` | **Date**: 2026-11-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/231-codify-plan-review-question/spec.md`

## Summary

highway-codify gains a `review` step between `menu` and `tasks`. Choosing **Review the plan?** at the menu goes to `review`, which walks every section of `plan.md`, then asks **What would you add, correct, or remove?** followed by "If this is accurate, just say so." The menu returns only after the reply. A reply that names a change takes the existing stated-edit path: regenerate the plan, then `check`, then `menu`. Continuing to code is unchanged.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: N/A. No template, record, or catalog changes

**Testing**: New `.highway/tools/tests/codify-plan-review.test.sh`, observed failing first. Moved version pins in [research.md](research.md) R4. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: Each codify step stays at or under 400 words (`codify-feature-wording.test.sh`). The step order `menu`, `tasks` stays, so a new step sits between them. The menu's wording does not change. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one new test, the version pins in R4

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No new shipped file. The edited skill carries no `.specify/` or `specs/` reference (D1.1). No new Markdown link (D6.2).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only. No Bash 4 feature (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill version changes, so the skill catalog and adapters are regenerated (D4.5, D4.6). No template or instruction changes, so the library catalog and instructions are not.
- **Validation Gate**: PASS. No validator check changes, so D3.4 does not apply. D3.5: the moved pins in R4 supersede the version value only.
- **Verification**: D3.1 baseline before the first edit, D3.2 after the last. D3.3 is met by the new test. D3.6: the new test is observed failing first. D3.8: the new test declares its instrument class.
- **Shared library review (D8.1)**: N/A. No shared template changes.
- **Live documentation (D6.1)**: N/A. `_authoring-standard.md` and `.highway/DISTRIBUTION.md` do not describe codify's plan menu.

Skill content gates, from `.highway/governance/constitution.md`:

- P2.6: the new step names no script, `git` command, absolute path, or file time.
- P7.5: `review` is about 110 words, and `menu` shrinks.
- Experience Standard X2.49: the question asks what is wrong, so agreement alone does not satisfy it.
- PASS pending `validate-skill.sh`.

Version bump, per R4: `highway-codify` 14.0.0 to 14.1.0.

### Post-design re-check

PASS. [contracts/wording.md](contracts/wording.md) names every changed line. R4 names every moved pin.

## Project Structure

### Documentation (this feature)

```text
specs/231-codify-plan-review-question/
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
.highway/skills/highway-codify/SKILL.md            (order line, Classify, menu, new review step, Verification, 14.1.0)
.highway/tools/tests/codify-plan-review.test.sh    (new)
.highway/tools/tests/*.test.sh                     (moved pins, R4)
```

**Structure Decision**: The review becomes its own step, as in highway-onboarding's `review`. The menu keeps its two options and its stated-edit path. Generated catalogs and adapters are refreshed after the source edit.

## Complexity Tracking

No constitution violation requires a justification.
