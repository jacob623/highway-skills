# Implementation Plan: Cursor Experience Order

**Branch**: `250-cursor-experience-order` | **Date**: 2026-11-16 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/250-cursor-experience-order/spec.md`

## Summary

Fix F29 in the Cursor local driver only: map real skill activation from plugin file reads (and
correct skill-id extraction), normalize plugin paths onto the install read root so those reads are
approved for harness accounting, and stop false `skill: skills` matches. Re-run one confirmation
cycle (2× smoke + codify). Resolve F29 only when those three logs have zero `actual no skill`.
No skill, template, fixture, scenario, or Copilot driver changes.

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/` (`PATH` includes `$HOME/.local/node/bin`).

**Primary Dependencies**: Existing `@cursor/sdk` ^1.4.0; `@github/copilot-sdk` unchanged.

**Storage**: Files. Committed run logs under `specs/250-cursor-experience-order/harness/`.
`harness-model-findings.md` and gitignored `rollout-plan.md` Status notes.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`, `bash tests/run-all.sh`.
Live: two `--agent cursor --smoke`, one `--agent cursor --skills highway-codify`.

**Target Platform**: macOS and Linux, Cursor **local** runtime only (cloud = Phase 20).

**Project Type**: Skill framework with bash suite and behavioral harness (CLI).

**Performance Goals**: Prefer committed logs near prior size; no new size gate beyond SC-006
(no secrets / temp paths).

**Constraints**:

- No commit unless asked.
- No skill, template, fixture, or scenario change (FR-006).
- Secrets redacted; never print `CURSOR_API_KEY`.
- `mv`, not `git mv`; constitution bump not expected (no new SDK).
- `rollout-plan.md` stays gitignored / distribution-excluded.
- Do not weaken shared experience-order or install checks; Copilot unchanged (FR-004).
- If mapping/load remains unworkable after research, stop for a person (already answered: workable).

**Scale/Scope**: Changes concentrated in `harness/src/drivers/cursor.ts` + `harness/test/cursor.test.ts`;
findings/rollout/README notes; three live logs.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.8.0)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | No shipped path changes; `harness/` excluded | D1.1, D1.2, D6.2 | N/A / PASS: harness-only + docs |
| Toolchain Gate | No Declared Toolchain script change | D2.1–D2.5 | N/A |
| Generator Gate | No generator change | D4.1–D4.4 | N/A |
| Correspondence Gate | No `skills/` change | D4.5–D4.7 | N/A |
| Validation Gate | Harness unit tests for Cursor mapping | D3.4, D3.5 | PASS: new/changed tests under `harness/test/` |
| Skill Content Gate | No `skills/` edit | Delegated | N/A |

Verification:

- D3.1 / D3.2: suite before first edit and after final edit.
- D3.3 / D3.6: new/changed Cursor activation tests observed failing before the fix.
- D6.1: findings, rollout Status, harness README if mapping notes need a line.
- No constitution version bump expected (Harness Toolchain already lists `@cursor/sdk`).

### Post-design re-check

Re-evaluated after Phase 1. Contracts stay under the spec folder; fix is driver-local path/skill
mapping. All gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/250-cursor-experience-order/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── activation-mapping.md
│   └── live-runs.md
├── checklists/requirements.md
├── harness/
│   ├── smoke-1.log
│   ├── smoke-2.log
│   └── codify.log
└── tasks.md
```

### Source Code (repository root)

```text
harness/
├── src/drivers/cursor.ts          # skill id + path normalize + tool mapping
├── test/cursor.test.ts            # activation / deny / false-positive cases
├── README.md                      # brief Cursor activation note if needed
harness-model-findings.md          # resolve F29 / F27 runs after confirmation
rollout-plan.md                    # Phase 7 Status follow-up (gitignored)
```

**Structure Decision**: Extend the existing Cursor driver; no new package or registry entry.

## Complexity Tracking

> None — no constitution violations.
