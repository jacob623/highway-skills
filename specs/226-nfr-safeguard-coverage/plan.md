# Implementation Plan: NFR Safeguard Coverage

**Branch**: `226-nfr-safeguard-coverage` | **Date**: 2026-11-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/226-nfr-safeguard-coverage/spec.md`

## Summary

`highway-nfrs` keeps offering an operational expectation for each accepted safeguard until a queued or captured NFR covers it. A shown recommendation the person did not select no longer counts as coverage. Every recommendation in a set shows a **Why it matters:** line. An NFR that reflects accepted Controls has the rationale **Enforces your Safeguard, [Control title],** by [how it keeps that Control true], or the plural form for more than one. Capture reuses the line shown in the set, and a rationale the person edits is kept as written. Every set keeps the 3 to 5 limit.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `highway-nfrs`. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: N/A. The NFR record and catalog shapes are unchanged

**Testing**: New `.highway/tools/tests/nfr-safeguard-rationale.test.sh`, observed failing first. One moved pin in [research.md](research.md) R4. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: Experience Standard X2.16 caps a set at five choices. No section grows past its word limit. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one new test, one moved pin

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with the recorded move in R4 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: N/A. `nfr-record.md` and `nfr-catalog.md` are unchanged.
- **Live documentation (D6.1)**: The `highway-nfrs` verification lines are updated in the same change. No other live document describes the NFR recommendation set.

Experience Standard:

- X2.16: PASS. The first spec answer let a set pass five choices. Planning surfaced the conflict, and the person chose to keep the cap (spec Clarifications). Every set still emits 3 to 5.
- X2.9: PASS. **Why it matters:** already labels rationale in capture, review, and the two limits. The set now uses the same label for the same content.

Skill content gates, from `.highway/governance/constitution.md`:

- P7.3: the rationale rule is stated once in `recommend`. `capture` and `review` cite it.
- PASS pending `validate-skill.sh`.

Version bumps:

- `highway-nfrs` 9.0.0 to 9.1.0. MINOR. New set line, new rationale rule, and a narrower coverage rule.

No complexity exception is required.

### Post-design re-check

PASS. [contracts/wording.md](contracts/wording.md) names every replaced and new line. R4 names the moved pin. Each step gains at most two sentences.

## Project Structure

### Documentation (this feature)

```text
specs/226-nfr-safeguard-coverage/
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
.highway/skills/highway-nfrs/SKILL.md
.highway/tools/tests/nfr-safeguard-rationale.test.sh
.highway/tools/tests/guided-flow-refinements.test.sh
```

**Structure Decision**: `highway-nfrs` owns the set, the rationale, and the write. Generated catalogs and adapters are refreshed after the version bump.

## Complexity Tracking

No constitution violation requires a justification.
