# Implementation Plan: Claude Code Driver

**Branch**: `254-claude-code-driver` | **Date**: 2026-11-18 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/254-claude-code-driver/spec.md`

## Summary

The harness gains a Claude Code agent driver and registry entry for `claude`.
`@anthropic-ai/claude-agent-sdk` is added under `harness/` only. Each attempt uses a throwaway
`CLAUDE_CONFIG_DIR` / `HOME` (`agentHome`), installs Highway by copying `highway-agent-plugin/`
into that home and loading it with `plugins: [{ type: "local", path }]`, enforces Local storage
through `canUseTool` (every Bash denied; project + plugin reads/writes allowed), resumes the same
session id for scripted replies, and maps stream events to the shared transcript and usage shapes.
`claudeAsk` is wired for judge/fallback; configured judge stays Cursor with Luna. Pinned model:
`claude-haiku-5-5`. Live logs: `smoke-1.log`, `smoke-2.log`, `codify.log` (no numeric pass floors).

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/` (`PATH` includes `$HOME/.local/node/bin`).

**Primary Dependencies**: `@anthropic-ai/claude-agent-sdk` (new, pin at install); `@cursor/sdk`,
`@openai/codex-sdk`, `@github/copilot-sdk` unchanged. Judge uses Cursor/Luna.

**Storage**: Files. `harness/harness.config.json` gains `models.claude`. Attempt state under
throwaway agent homes. Committed run logs under `specs/254-claude-code-driver/harness/`.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`, `bash tests/run-all.sh`.
Live: two `--agent claude --smoke` and one `--agent claude --skills highway-codify` on Haiku.

**Target Platform**: macOS and Linux, Claude Code via Agent SDK (local subprocess).

**Project Type**: Skill framework with bash suite and behavioral harness (CLI).

**Performance Goals**: Smoke/codify run logs each under 100 KB (SC). Parallel same as configured
unless live proves unsafe.

**Constraints**:

- No commit unless asked.
- No skill, template, fixture, or scenario edits.
- Secrets redacted; never print `ANTHROPIC_API_KEY`.
- `mv`, not `git mv`; constitution Harness Toolchain MINOR only; no backward compatibility.
- `rollout-plan.md` stays gitignored / distribution-excluded.
- Runner does not import `@anthropic-ai/claude-agent-sdk`; only `drivers/claude.ts` does.
- Reject every Bash request; no Codex-style in-project shell allowances.

**Scale/Scope**: One new driver file, registry entry, config model, unit tests, docs/governance,
three live logs, findings section, Phase 8 Status.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.9.0 → 3.10.0 by this change)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | No skill/plugin source change expected | D1.1, D1.2, D6.2 | PASS: no hand-edit of generated plugin; regenerate only if a field is rejected live |
| Toolchain Gate | Harness-only dependency | D2.1–D2.5 | PASS: Declared Toolchain unchanged; suite stays green |
| Generator Gate | Only if `.claude-plugin` field rejected live | D4.1–D4.4 | N/A unless FR-014 fires |
| Correspondence Gate | No skill content change | D4.5–D4.7 | PASS: no skill MINOR unless live forces a plugin-source fix |
| Validation Gate | New harness unit tests + suite | D3.4, D3.5 | PASS: new tests under `harness/test/`; bash suite not weakened |
| Skill Content Gate | No skill edits planned | Delegated | PASS: FR-015 forbids skill/template/fixture/scenario change |

Verification:

- D3.1 / D3.2: suite before first edit and after final edit.
- D3.3 / D3.6: new Claude driver tests observed failing before implementation.
- D6.1: `harness/README.md`, findings, rollout Status, standard-alignment.
- Harness Toolchain amendment: add `@anthropic-ai/claude-agent-sdk` (MINOR 3.10.0).

### Post-design re-check

Re-evaluated after Phase 1. Contracts stay under the spec folder and harness. Reject-all-Bash via
`canUseTool` and throwaway `CLAUDE_CONFIG_DIR` are justified by FR-001/FR-010. All gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/254-claude-code-driver/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── claude-driver.md
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
├── package.json                 # + @anthropic-ai/claude-agent-sdk
├── harness.config.json          # + models.claude (claude-haiku-5-5)
├── README.md
├── src/
│   ├── agents.ts                # + claude registry entry
│   └── drivers/
│       ├── copilot.ts
│       ├── cursor.ts
│       ├── codex.ts
│       └── claude.ts            # NEW
└── test/
    └── claude.test.ts           # NEW (plus registry assertions)

.specify/memory/constitution.md  # Harness Toolchain MINOR 3.10.0
harness-model-findings.md
rollout-plan.md                  # Phase 8 Status
standard-alignment.md
```

**Structure Decision**: Follow Phase 5 registry contract — one driver file and one `AGENTS` entry;
runner unchanged aside from accepting `claude`. No skill edits.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Per-attempt CLAUDE_CONFIG_DIR + HOME env bag | Isolate config/memory/plugins from the operator home | Inheriting `~/.claude` contaminates runs |
| canUseTool deny-all Bash (no build/test shell) | Clarify FR-010; Claude has Read/Write/Edit | Codex-style shell allow would violate clarify |
| Resume-per-reply session model | FR-008 one send then wait on same session | Single streaming stdin harder to fake in unit tests |
