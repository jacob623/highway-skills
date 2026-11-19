# Contract: Claude driver and registry

## What this driver supplies

`harness/src/drivers/claude.ts` exports:

1. **`claudeDriver`**: a `Driver` that:
   - uses `@anthropic-ai/claude-agent-sdk` `query()` with a controlled `env`
     (`CLAUDE_CONFIG_DIR`, throwaway `HOME`, `CLAUDE_CODE_DISABLE_AUTO_MEMORY`,
     `ANTHROPIC_API_KEY`);
   - sets `cwd` = project dir, `settingSources: []`, pinned `model`, and
     `plugins: [{ type: "local", path: <installed highway> }]`;
   - installs via a filesystem `PluginRpc` into the throwaway home from
     `highway-agent-plugin/` (`.claude-plugin/plugin.json`), then shared `installPlugin` checks;
   - enforces storage through `canUseTool` (every Bash denied; Local path rules for read/write);
   - resumes the same `sessionId` for each scripted reply, then waits for that turn to finish;
   - maps stream messages to transcript entries, skills lists, and usage;
   - wraps SDK calls with existing rate-limit / retry helpers and `classifyClaudeError`;
   - throws `RunStop("no-access")` when the key is refused;
   - always disposes / closes the query and does not leave personal config behind.
2. **`classifyClaudeError`**: maps auth, rate-limit, allowance, and retryable signals to
   `FailureKind`.
3. **`claudeAsk`**: one-shot text ask with no plugin / tools as restricted as the SDK allows,
   throwaway home (for judge/fallback).
4. **`claudeVersions`**: SDK package version and `runtime: "cli"`.

## Registry

`AGENTS` gains the `claude` row from [data-model.md](../data-model.md). The runner still imports
no Claude Agent SDK.

## Configuration

- `--agent claude` is accepted once registered.
- `models.claude` is required when Claude is selected (`claude-haiku-5-5`).
- Configured judge stays Cursor + Luna; `judge.agent=claude` is valid because `ask` is present.

## Enforcement contract (unit-tested)

See [data-model.md](../data-model.md) permission table. Tests MUST cover: allowed project read;
allowed project write; allowed plugin read; outside write denied; **Bash always denied**;
AskUserQuestion answered or left to reply loop; one-shot ask; error mapping.

## Out of scope in this contract

- Public marketplace install (Phase 14).
- Promoting fixtures from Claude runs (Phase 16).
- Any skill, template, fixture, or scenario edit.
- Changing the shared runner beyond accepting the new registry entry.
- Reopening Codex Phase 9 / F32 except as findings background.
