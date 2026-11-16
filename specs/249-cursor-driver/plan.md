# Implementation Plan: Cursor Driver

**Branch**: `249-cursor-driver` | **Date**: 2026-11-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/249-cursor-driver/spec.md`

## Summary

The harness gains a Cursor agent driver and registry entry for `cursor`. `@cursor/sdk` (^1.4.0)
is added under `harness/` only. Each attempt uses the **local** runtime with a throwaway `HOME`
(`agentHome`), installs Highway by copying `highway-agent-plugin/` into
`<home>/.cursor/plugins/local/highway/`, loads plugins via `settingSources: ["plugins"]`, enforces
policy through home-scoped hooks plus effects-based checks on `tool_call` events (R3), and maps
streams to the shared transcript and usage shapes. `cursorAsk` is wired for a future judge switch;
the configured judge stays Copilot. Live logs: `smoke-1.log`, `smoke-2.log`, `codify.log`. Cloud
runtime is Phase 20 in `rollout-plan.md`, not this change.

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/` (`PATH` includes `$HOME/.local/node/bin`).

**Primary Dependencies**: `@cursor/sdk` ^1.4.0 (new); `@github/copilot-sdk` unchanged for Copilot
and the default judge.

**Storage**: Files. `harness/harness.config.json` gains `models.cursor`. Attempt state under
throwaway agent homes. Committed run logs under `specs/249-cursor-driver/harness/`.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`, `bash tests/run-all.sh`.
Live: two `--agent cursor --smoke` and one `--agent cursor --skills highway-codify`.

**Target Platform**: macOS and Linux, Cursor **local** runtime only.

**Project Type**: Skill framework with bash suite and behavioral harness (CLI).

**Performance Goals**: Smoke/codify run logs each under 100 KB (SC-005). HOME mutex may serialize
Cursor SDK windows under parallel scheduling without changing the shared `parallel` config.

**Constraints**:

- No commit unless asked.
- No skill, template, fixture, or scenario change (FR-015).
- Secrets redacted; never print `CURSOR_API_KEY`.
- `mv`, not `git mv`; MINOR constitution bump only; no backward compatibility.
- `rollout-plan.md` stays gitignored / distribution-excluded.
- Runner does not import `@cursor/sdk`; only `drivers/cursor.ts` does.

**Scale/Scope**: One new driver file, registry entry, config model, unit tests, docs/governance,
three live logs, findings section, Phase 20 stub already added during research.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.7.0 → 3.8.0 by this change)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | No shipped path changes; `harness/` excluded | D1.1, D1.2, D6.2 | N/A / PASS: harness-only + docs that name harness paths |
| Toolchain Gate | No Declared Toolchain script change expected | D2.1–D2.5 | N/A unless a bash test is edited |
| Generator Gate | No generator change unless Cursor rejects a manifest field | D4.1–D4.4 | N/A unless FR-014 fires |
| Correspondence Gate | No `skills/` change | D4.5–D4.7 | N/A |
| Validation Gate | New harness unit tests only | D3.4, D3.5 | PASS: new tests under `harness/test/`; no weakened bash assertions planned |
| Skill Content Gate | No `skills/` edit | Delegated | N/A |

Verification:

- D3.1 / D3.2: suite before first edit and after final edit.
- D3.3 / D3.6: new Cursor driver tests observed failing before implementation.
- D6.1: `harness/README.md`, findings, rollout Status, standard-alignment.
- Harness Toolchain amendment: add `@cursor/sdk` (MINOR 3.8.0).

### Post-design re-check

Re-evaluated after Phase 1. Contracts stay under the spec folder and harness; Phase 20 is
documentation-only in `rollout-plan.md`. All gates hold. Cloud is not implemented here.

## Project Structure

### Documentation (this feature)

```text
specs/249-cursor-driver/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── cursor-driver.md
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
├── package.json                 # + @cursor/sdk
├── harness.config.json          # + models.cursor
├── README.md
├── src/
│   ├── agents.ts                # + cursor registry entry
│   └── drivers/
│       ├── copilot.ts           # unchanged
│       └── cursor.ts            # NEW
└── test/
    └── cursor.test.ts           # NEW (plus registry assertions)

.specify/memory/constitution.md  # Harness Toolchain MINOR
harness-model-findings.md        # Cursor smoke section
rollout-plan.md                  # Phase 7 Status + Phase 20 (research)
standard-alignment.md            # phase outcome note
```

**Structure Decision**: Follow Phase 5 registry contract — one driver file and one `AGENTS` entry;
no runner import of Cursor’s SDK.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| HOME mutex inside the driver | Parallel attempts would race on process `HOME` while Cursor discovers plugins under `~/.cursor` | Per-attempt child processes would change the runner; project-only hooks are last resort |
