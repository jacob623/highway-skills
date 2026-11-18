# Implementation Plan: Codex Driver

**Branch**: `252-codex-driver` | **Date**: 2026-11-18 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/252-codex-driver/spec.md`

## Summary

The harness gains a Codex agent driver and registry entry for `codex`. `@openai/codex-sdk` is
added under `harness/` only. Each attempt uses a throwaway `CODEX_HOME`/`HOME` (`agentHome`),
installs Highway from `highway-agent-plugin/` via a local Codex marketplace / `.codex-plugin`
layout, runs with `sandboxMode: workspace-write` and network off, enforces storage with
effects-based classification of command/file items (allow in-project R/W + build/test; fail git /
outside / network installs), and maps streamed items to the shared transcript and usage shapes.
`codexAsk` is wired for judge/fallback; configured judge becomes Cursor with Luna. Storage
contract gets MINOR wording for shell-as-file-tool agents. Live logs: `smoke-1.log`,
`smoke-2.log`, `codify.log`.

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/` (`PATH` includes `$HOME/.local/node/bin`).

**Primary Dependencies**: `@openai/codex-sdk` (new, pin at install); `@cursor/sdk` and
`@github/copilot-sdk` unchanged. Judge uses Cursor/Luna.

**Storage**: Files. `harness/harness.config.json` gains `models.codex`; `judge.agent` → `cursor`,
judge model Luna. Attempt state under throwaway agent homes. Committed run logs under
`specs/252-codex-driver/harness/`. Skill: `storage-contract.md` MINOR + regenerate.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`, `bash tests/run-all.sh`.
Live: two `--agent codex --smoke` and one `--agent codex --skills highway-codify` on Luna /
closest Codex-listed id.

**Target Platform**: macOS and Linux, Codex CLI via SDK (local JSONL).

**Project Type**: Skill framework with bash suite and behavioral harness (CLI).

**Performance Goals**: Smoke/codify run logs each under 100 KB (SC). Parallel same as configured
unless live proves unsafe.

**Constraints**:

- No commit unless asked.
- Skills change limited to storage-contract MINOR wording + regenerate (FR-002); no other skill /
  template / fixture / scenario edits.
- Secrets redacted; never print `OPENAI_API_KEY` / `CODEX_API_KEY`.
- `mv`, not `git mv`; constitution Harness Toolchain MINOR only; no backward compatibility.
- `rollout-plan.md` stays gitignored / distribution-excluded.
- Runner does not import `@openai/codex-sdk`; only `drivers/codex.ts` does.

**Scale/Scope**: One new driver file, registry entry, config model + judge switch, storage-contract
MINOR, unit tests, docs/governance, three live logs, findings section, Phase 9 Status.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.8.0 → 3.9.0 by this change)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | Regenerated adapters/plugin after storage-contract | D1.1, D1.2, D6.2 | PASS: regenerate from source; no hand-edit of generated plugin |
| Toolchain Gate | Possible suite impact from skill MINOR | D2.1–D2.5 | PASS if suite stays green; no Declared Toolchain script change |
| Generator Gate | Only if `.codex-plugin` field rejected live | D4.1–D4.4 | N/A unless FR for manifest fix fires |
| Correspondence Gate | storage-contract + highway-experience MINOR | D4.5–D4.7 | PASS: regenerate adapters/plugin/catalog after bump |
| Validation Gate | New harness unit tests + suite | D3.4, D3.5 | PASS: new tests under `harness/test/`; bash suite not weakened |
| Skill Content Gate | FR-002 storage-contract wording only | Delegated | PASS: scoped MINOR; no other skill behavior edits |

Verification:

- D3.1 / D3.2: suite before first edit and after final edit.
- D3.3 / D3.6: new Codex driver tests observed failing before implementation.
- D6.1: `harness/README.md`, findings, rollout Status, standard-alignment.
- Harness Toolchain amendment: add `@openai/codex-sdk` (MINOR 3.9.0).

### Post-design re-check

Re-evaluated after Phase 1. Contracts stay under the spec folder and harness. Effects-based
enforcement and storage-contract MINOR are justified by FR-001/FR-002. All gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/252-codex-driver/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── codex-driver.md
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
├── package.json                 # + @openai/codex-sdk
├── harness.config.json          # + models.codex; judge → cursor/luna
├── README.md
├── src/
│   ├── agents.ts                # + codex registry entry
│   └── drivers/
│       ├── copilot.ts
│       ├── cursor.ts
│       └── codex.ts             # NEW
└── test/
    └── codex.test.ts            # NEW (plus registry assertions)

skills/highway-experience/
├── SKILL.md                     # MINOR bump
└── references/storage-contract.md  # shell-as-file-tool wording

framework/ + highway-agent-plugin/   # regenerate after skill bump
.specify/memory/constitution.md      # Harness Toolchain MINOR 3.9.0
harness-model-findings.md
rollout-plan.md                      # Phase 9 Status
standard-alignment.md
```

**Structure Decision**: Follow Phase 5 registry contract — one driver file and one `AGENTS` entry;
runner unchanged aside from accepting `codex`. Storage-contract change is the only skill edit.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Effects-based shell classification | Codex’s primary file path is shell; banning all shell fails every attempt | Fixed allowlist rejected in clarify; failing all shell breaks codify |
| Per-attempt CODEX_HOME + HOME env bag | Isolate plugins/config/history from the operator home | Inheriting `~/.codex` contaminates runs |
| storage-contract MINOR | Agents whose file tool is the shell need Local wording | Harness-only rule rejected in clarify |
