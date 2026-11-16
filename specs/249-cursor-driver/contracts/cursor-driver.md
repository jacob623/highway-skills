# Contract: Cursor driver and registry

## What this driver supplies

`harness/src/drivers/cursor.ts` exports:

1. **`cursorDriver`**: a `Driver` that:
   - uses `@cursor/sdk` **local** runtime only (`local: { cwd: projectDir, settingSources: ["plugins"] }`);
   - scopes `HOME` to `options.agentHome` under an async mutex for the create/send/wait/dispose window;
   - installs via a filesystem `PluginRpc` into `.cursor/plugins/local/highway/`, then shared `installPlugin` checks;
   - writes home-scoped hooks that deny shell / outside writes / memory and allow project (+ read-root) reads/writes;
   - maps stream events to transcript entries, skills lists, and usage;
   - applies effects-based failure when a forbidden tool still completes (FR-010);
   - wraps SDK calls with `withRateLimit` / `retryServiceError` and `classifyCursorError`;
   - throws `RunStop("no-access")` when the key is refused;
   - always disposes the agent.
2. **`classifyCursorError`**: maps auth, rate-limit, allowance, and retryable signals to `FailureKind`.
3. **`cursorAsk`**: one-shot text ask with `tools: []`, no plugin, throwaway home (for judge/fallback).
4. **`cursorVersions`**: SDK package version and `runtime: "local"`.

## Registry

`AGENTS` gains the `cursor` row from [data-model.md](../data-model.md). The runner still imports no
Cursor SDK.

## Configuration

- `--agent cursor` is accepted once registered.
- `models.cursor` is required when Cursor is selected (existing resolve rules).
- Default judge remains Copilot; `judge.agent=cursor` is valid because `ask` is present.

## Out of scope in this contract

- Cloud/remote `cloud:` option (Phase 20).
- Manifest field fixes (Phase 6 source only if live install rejects a field).
- Skill, template, fixture, or scenario edits.
