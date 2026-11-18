# Contract: Codex driver and registry

## What this driver supplies

`harness/src/drivers/codex.ts` exports:

1. **`codexDriver`**: a `Driver` that:
   - uses `@openai/codex-sdk` with a fully controlled `env` (`CODEX_HOME` + throwaway `HOME` =
     `options.agentHome`);
   - starts threads with `cwd` = project dir, `sandboxMode: "workspace-write"`, network access
     off, `skipGitRepoCheck: true`, and non-interactive approval (`never` / auto-deny);
   - installs via a filesystem / CLI `PluginRpc` into the throwaway home from
     `highway-agent-plugin/` (`.codex-plugin/plugin.json`), then shared `installPlugin` checks;
   - maps streamed items (`command_execution`, file changes, messages, usage) to transcript
     entries, skills lists, and usage;
   - applies effects-based failure for forbidden command/path effects (FR-001 / FR-008);
   - wraps SDK calls with existing rate-limit / retry helpers and `classifyCodexError`;
   - throws `RunStop("no-access")` when the key is refused;
   - always disposes / closes the thread and does not leave personal config behind.
2. **`classifyCodexError`**: maps auth, rate-limit, allowance, and retryable signals to
   `FailureKind`.
3. **`codexAsk`**: one-shot text ask with no plugin / tools as restricted as the SDK allows,
   throwaway home (for judge/fallback).
4. **`codexVersions`**: SDK package version and `runtime: "cli"`.

## Registry

`AGENTS` gains the `codex` row from [data-model.md](../data-model.md). The runner still imports no
Codex SDK.

## Configuration

- `--agent codex` is accepted once registered.
- `models.codex` is required when Codex is selected (existing resolve rules).
- Configured judge for this phase: `judge.agent=cursor` with Luna; `judge.agent=codex` is valid
  because `ask` is present.

## Enforcement contract (unit-tested)

See [data-model.md](../data-model.md) effects table. Tests MUST cover: allowed project read;
allowed project write; allowed in-project build/test; outside write fails; `git` fails;
network-facing install fails.

## Out of scope in this contract

- Public marketplace install (Phase 14).
- Promoting fixtures from Codex runs (Phase 16).
- Skill edits other than storage-contract MINOR (FR-002).
- Changing the shared runner beyond accepting the new registry entry.
