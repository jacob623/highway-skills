# Implementation Plan: Claude Bash Failures

**Branch**: `255-claude-bash-failures` | **Date**: 2026-11-18 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/255-claude-bash-failures/spec.md`

## Summary

F33 recovery after Phase 8: keep deny-all-Bash and fatal `rejected-request` on refuse, but
steer Claude toward file tools by writing short Local-mode / no-Bash guidance into each
attempt’s throwaway home (`.claude/CLAUDE.md`) and loading it with `settingSources: ["user"]`
only. Optional clearer Bash denial text may name file tools; it is not an exit gate. Confirm
with two Claude smokes (≥14/16 each) and one highway-codify log; close F33 only when the smoke
bar holds and Bash-driven fails drop vs Phase 8 baseline.

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/` (`PATH` includes `$HOME/.local/node/bin`).

**Primary Dependencies**: Existing `@anthropic-ai/claude-agent-sdk` under `harness/` only; no new
packages. Judge remains Cursor/Luna.

**Storage**: Files. Guidance written under throwaway `agentHome/.claude/CLAUDE.md`. Committed
logs under `specs/255-claude-bash-failures/harness/`.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`,
`bash tests/run-all.sh`. Live: two `--agent claude --smoke` (≥14/16) and one
`--agent claude --skills highway-codify` on pinned Haiku.

**Target Platform**: macOS and Linux, Claude Code via Agent SDK (local subprocess).

**Project Type**: Skill framework with bash suite and behavioral harness (CLI).

**Performance Goals**: Smoke/codify logs each under ~100 KB after redaction. Parallelism unchanged
unless live proves unsafe.

**Constraints**:

- No commit unless asked.
- No skill, template, fixture, or scenario edits.
- Secrets redacted; never print `ANTHROPIC_API_KEY`.
- `mv`, not `git mv`; no constitution bump expected; no backward compatibility.
- `rollout-plan.md` stays gitignored / distribution-excluded.
- Do not allow in-project Bash; do not adopt Codex continue-after-refuse for Claude Bash.
- Do not load operator personal Claude config (`settingSources` must not include sources that
  reach the real operator home; throwaway `HOME` + `"user"` only).

**Scale/Scope**: Small Claude driver + test + README change; three live logs; findings + rollout
Status update. No Copilot/Cursor/Codex driver behavior change.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.10.0)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | No skill/plugin source change | D1.1, D1.2, D6.2 | PASS: harness-only guidance |
| Toolchain Gate | No new harness dependency | D2.1–D2.5 | PASS: reuse existing Claude SDK |
| Generator Gate | No generator change | D4.1–D4.4 | N/A |
| Correspondence Gate | No skill content change | D4.5–D4.7 | PASS |
| Validation Gate | New/extended harness unit tests + suite | D3.4, D3.5 | PASS: tests under `harness/test/`; suite not weakened |
| Skill Content Gate | No skill edits | Delegated | PASS: FR forbids skill/template/fixture/scenario change |

Verification:

- D3.1 / D3.2: suite before first edit and after final edit.
- D3.3 / D3.6: guidance / settingSources tests observed failing before implementation.
- D6.1: `harness/README.md`, findings, rollout Status.
- No Harness Toolchain amendment (SDK already declared in 3.10.0).

### Post-design re-check

Re-evaluated after Phase 1. Contracts stay under the spec folder. Throwaway
`.claude/CLAUDE.md` + `settingSources: ["user"]` are justified by FR-002 and research R1; deny
behavior unchanged (FR-001). All gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/255-claude-bash-failures/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── claude-guidance.md
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
├── README.md                    # Claude throwaway-home guidance note
├── src/drivers/claude.ts        # prepareClaudeAgentHome + settingSources ["user"]
└── test/claude.test.ts          # guidance + settingSources + Bash deny coverage

harness-model-findings.md        # F33 update / close
rollout-plan.md                  # Phase Status (gitignored)
```

**Structure Decision**: Single harness package change on the existing Claude driver; no new
top-level apps or packages.

## Complexity Tracking

> No constitution violations requiring justification.
