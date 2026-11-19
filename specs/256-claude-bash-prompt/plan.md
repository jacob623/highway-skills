# Implementation Plan: Claude Bash Prompt

**Branch**: `256-claude-bash-prompt` | **Date**: 2026-11-18 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/256-claude-bash-prompt/spec.md`

## Summary

F33 recovery after Spec 255: keep deny-all-Bash and fatal `rejected-request` on refuse, but
ensure Local-mode / no-Bash guidance reaches every Claude drive session via
`systemPrompt: { type: "preset", preset: "claude_code", append: CLAUDE_LOCAL_GUIDANCE }`.
Revert drive `settingSources` to `[]` (home-file + `"user"` did not close F33). Keep writing
throwaway `.claude/CLAUDE.md` as supporting only. Confirm with two smokes (≥14/16) and one
codify log; close F33 only when the smoke bar holds and Bash-driven fails drop vs Phase 8.

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/` (`PATH` includes `$HOME/.local/node/bin`).

**Primary Dependencies**: Existing `@anthropic-ai/claude-agent-sdk` under `harness/` only; no new
packages. Judge remains Cursor/Luna.

**Storage**: Files. Supporting guidance may still live under throwaway
`agentHome/.claude/CLAUDE.md`. Session-start delivery is via SDK `systemPrompt` append.
Committed logs under `specs/256-claude-bash-prompt/harness/`.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`,
`bash tests/run-all.sh`. Live: two `--agent claude --smoke` (≥14/16) and one
`--agent claude --skills highway-codify` on pinned Haiku.

**Target Platform**: macOS and Linux, Claude Code via Agent SDK (local subprocess).

**Project Type**: Skill framework with bash suite and behavioral harness (CLI).

**Performance Goals**: Smoke/codify logs each under ~100–300 KB after redaction. Parallelism
unchanged unless live proves unsafe.

**Constraints**:

- No commit unless asked.
- No skill, template, fixture, or scenario edits.
- Secrets redacted; never print `ANTHROPIC_API_KEY`.
- `mv`, not `git mv`; no constitution bump expected.
- `rollout-plan.md` stays gitignored / distribution-excluded.
- Do not allow in-project Bash; do not adopt Codex continue-after-refuse for Claude Bash.
- Do not load operator personal Claude config (`settingSources: []` on drive).

**Scale/Scope**: Small Claude driver + test + README change; three live logs; findings + rollout
Status update.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.10.0)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | No skill/plugin source change | D1.1, D1.2, D6.2 | PASS |
| Toolchain Gate | No new harness dependency | D2.1–D2.5 | PASS |
| Generator Gate | No generator change | D4.1–D4.4 | N/A |
| Correspondence Gate | No skill content change | D4.5–D4.7 | PASS |
| Validation Gate | Extended harness unit tests + suite | D3.4, D3.5 | PASS |
| Skill Content Gate | No skill edits | Delegated | PASS |

Verification: D3.1/D3.2 suite before/after; D3.3/D3.6 tests fail then pass; D6.1 README,
findings, rollout Status. No Harness Toolchain amendment.

### Post-design re-check

Re-evaluated after Phase 1. `systemPrompt` append + `settingSources: []` justified by FR-002 and
research R1; deny behavior unchanged (FR-001). All gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/256-claude-bash-prompt/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── claude-session-guidance.md
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
├── src/drivers/claude.ts   # systemPrompt append; settingSources []
└── test/claude.test.ts

harness-model-findings.md
rollout-plan.md             # Phase Status (gitignored)
```

**Structure Decision**: Single harness package change on the existing Claude driver.

## Complexity Tracking

> No constitution violations requiring justification.
