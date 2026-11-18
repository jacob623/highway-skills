# Implementation Plan: Codex Smoke Failures

**Branch**: `253-codex-smoke-failures` | **Date**: 2026-11-18 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/253-codex-smoke-failures/spec.md`

## Summary

Reduce Codex smoke fails dominated by F31 without weakening Local-mode bans. Primary lever:
**pre-refuse `git` before it runs** via Codex throwaway-home `rules/` (`prefix_rule` with
`decision = "forbidden"` for `git`) plus driver semantics that treat a denied/non-completed `git`
as a **logged, non-fatal** refusal while a **completed** `git` still fails fatally (effects
backup). Required support: short Local-mode / no-`git` guidance written into each throwaway home
(`AGENTS.md`), never the operator’s personal config. Secondary: verify/fix plugin skill load so
Highway skills are usable mid-attempt (FR-003). Confirm with two Codex smokes (≥9/16 each) and
one highway-codify run (no numeric floor); update findings/F31 from evidence.

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/` (`PATH` includes `$HOME/.local/node/bin`).

**Primary Dependencies**: `@openai/codex-sdk` (already in harness); Codex CLI rules language
(Starlark `.rules` under `$CODEX_HOME/rules/`). No new npm packages expected.

**Storage**: Files. Per-attempt throwaway `CODEX_HOME`/`HOME`. Logs under
`specs/253-codex-smoke-failures/harness/`. Findings in `harness-model-findings.md`. No skill
content edits this phase.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`, `bash tests/run-all.sh`.
Unit tests for git pre-refuse vs completed-git fatal, and guidance file contents. Live: two
`--agent codex --smoke` (≥9/16) + one `--agent codex --skills highway-codify`.

**Target Platform**: macOS and Linux; Codex CLI via SDK with throwaway home.

**Project Type**: Behavioral harness driver hardening (CLI).

**Performance Goals**: Smoke/codify logs each under 100 KB; configured parallel unless proven unsafe.

**Constraints**:

- No commit unless asked.
- Do not allow `git`, outside paths, or network-facing installs under Local mode.
- Pre-refuse covers **git only**; other forbidden shells stay effects-fatal.
- Pre-refused git MUST NOT alone fail the attempt; completed git MUST.
- Guidance in throwaway home only; no personal `AGENTS.md` / `~/.codex` leak.
- No hand-edit of generated plugin; no skill/template/fixture/scenario edits unless FR requires
  (default: harness only).
- Secrets redacted; `mv` not `git mv`; `rollout-plan.md` stays gitignored.

**Scale/Scope**: Codex driver + tests + docs/findings + three live logs. Likely touch
`harness/src/drivers/codex.ts`, `harness/test/codex*.ts`, README/findings/rollout Status.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.9.0)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | No regenerated plugin expected | D1.1, D1.2, D6.2 | PASS: harness-only unless FR-003 forces install layout still from generated plugin |
| Toolchain Gate | Suite after harness change | D2.1–D2.5 | PASS if suite stays green; no Declared Toolchain script change |
| Generator Gate | No generator field change | D4.1–D4.4 | N/A |
| Correspondence Gate | No skill bump | D4.5–D4.7 | N/A |
| Validation Gate | New unit tests + suite | D3.4, D3.5 | PASS: tests under `harness/test/`; bash suite not weakened |
| Skill Content Gate | Default no skill edits | Delegated | PASS: out of scope |

Verification:

- D3.1 / D3.2: suite before first edit and after final edit.
- D3.3 / D3.6: new pre-refuse / guidance tests observed failing before implementation.
- D6.1: harness README, findings, rollout Status as needed.

### Post-design re-check

Re-evaluated after Phase 1. Pre-refuse via Codex rules + non-fatal denial semantics and throwaway
guidance satisfy FR-002 without weakening FR-001. Contracts stay under the spec folder. All gates
hold.

## Project Structure

### Documentation (this feature)

```text
specs/253-codex-smoke-failures/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── git-pre-refuse.md
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
├── README.md
├── src/drivers/codex.ts          # rules + AGENTS guidance; git pre-refuse vs completed fatal
└── test/
    └── codex.test.ts             # pre-refuse / guidance / load assertions

harness-model-findings.md         # F31 update; new findings if needed
rollout-plan.md                   # Status for this phase (gitignored)
standard-alignment.md             # touch only if needed for harness note
```

**Structure Decision**: Harden the existing Codex driver and throwaway-home setup; no new agent
registry entry and no skill regeneration unless install research forces a packaging-safe fix.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Codex `rules/` + harness dual gate for git | SDK has no approval callback under `approvalPolicy: never`; need true pre-run deny | Guidance alone rejected as primary lever in clarify |
| Non-fatal git denial vs fatal completed git | Clarify: pre-refuse must not fail the attempt; completed git still must | Treating all git classifications as fatal recreates F31 |
