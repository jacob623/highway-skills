# Research: Cursor Driver

Every driver question from Phase 7 and FR-001 is answered below. Technical Context unknowns are
resolved. Cloud/remote support is recorded as a new Phase 20 in `rollout-plan.md` (clarification
session answer; Phase 19 is already Repository URL).

## R1. Throwaway home and isolation

- **Decision**: Each attempt sets `HOME` (and clears `CURSOR_DATA_DIR` unless pointing inside that
  home) to `options.agentHome` for the Cursor SDK call window. Ambient layers stay off with
  `local: { cwd: projectDir, settingSources: ["plugins"] }` only — never `"user"`, `"project"`,
  `"team"`, `"mdm"`, or `"all"`. Conversation state uses `local.store` under the agent home (JSONL
  or the SDK default under that HOME) so personal `~/.cursor` is never read. Because parallel
  attempts would race on process `HOME`, the driver serializes the HOME-scoped create/send/wait/
  dispose window with an async mutex inside `drivers/cursor.ts`; scenario scheduling can still use
  the shared parallel count.
- **Rationale**: The SDK loads user plugins and hooks from `~/.cursor/` relative to `HOME`. Empty
  `settingSources` would skip plugins entirely; `"plugins"` alone loads installed plugins without
  project/user rules. Docs: ambient settings are not loaded by default; cloud always loads
  project/team/plugins and ignores `settingSources`.
- **Alternatives considered**: Mutating `HOME` without a mutex (races under `--parallel 4`).
  Putting hooks only in the project (last resort; the agent can edit them). Cloud runtime (out of
  scope; Phase 20).

## R2. Local plugin install and which manifest is read

- **Decision**: There is no Copilot-style plugin RPC. The driver supplies a `PluginRpc` adapter that
  copies `highway-agent-plugin/` into
  `<agentHome>/.cursor/plugins/local/highway/` (full copy, not a symlink — Cursor skips symlinks
  that point outside that folder), then reports name, skill count, and enabled from the on-disk
  tree. Cursor Plugin layout uses `.cursor-plugin/plugin.json`; the adapter reads that file for the
  plugin name when present, otherwise the root `plugin.json`. Skills live under `skills/` in the
  installed copy; `readRoots(home)` returns
  `[join(home, ".cursor/plugins/local/highway")]` so skill file reads are allowed. Shared
  `installPlugin` still owns the name / count / warning / enabled checks.
- **Rationale**: Cursor docs install local plugins under `~/.cursor/plugins/local/<name>` and detect
  Cursor Plugin vs Agent Plugin from which manifest exists. Phase 6 ships both; Cursor tooling is
  documented against `.cursor-plugin/plugin.json`. Live smoke proves the install and skill count.
- **Alternatives considered**: Symlink into `plugins/local` (skipped by Cursor). Relying on the
  developer's real `~/.cursor/plugins/local` (personal plugin contamination). Project-scoped plugin
  install in `cwd` (not the documented local-test path for SDK `"plugins"`).

## R3. Permission control before each tool

- **Decision**: The SDK has **no programmatic** permission callback (file-based hooks only). Under
  the HOME override, write `agentHome/.cursor/hooks.json` plus hook scripts that deny shell
  (`beforeShellExecution`), deny memory-like tools, and map read/write paths through the same
  rules as `permissionPolicy` (project writes allowed; reads in project or read roots; outside
  writes denied). Log each decision as a `permission` transcript line. Additionally, map every
  `tool_call` stream event: if a rejected kind still completes, treat that as effects-based
  enforcement (FR-010) — record the request and fail the attempt afterward. Record for Phase 9
  that Codex faces the same “no host-process callback” class of gap when an SDK is hooks-only.
- **Rationale**: Clarification Q1 chose effects-based when pre-reject is impossible; hooks give
  pre-reject for shell and many tools when they load from the throwaway home. Forum request for
  programmatic `preToolUse` confirms the gap. Project hooks remain last resort.
- **Alternatives considered**: Wait for SDK programmatic hooks. Project-only hooks. Sandbox alone
  (`sandboxOptions`) — not a storage-invariant policy.

## R4. Ask-the-user questions

- **Decision**: Headless SDK runs have no human-in-the-loop approval prompt. There is no Copilot-
  style `onUserInputRequest`. If the model emits a question in assistant text, the existing reply
  loop answers it after `run.wait()` (same path as an unmatched turn). Stream type `"request"` is
  treated as a system note if seen; the driver does not block on interactive approval.
- **Rationale**: SDK docs: headless mode does not ask for approval; gate tools with hooks or
  sandbox instead. FR-008 and the shared reply loop already cover turn-end questions.
- **Alternatives considered**: Faking interactive approval over `"request"` events (undocumented /
  unstable for scripted answers).

## R5. Events, skills, and usage

- **Decision**: Consume `run.stream()` `SDKMessage` events:
  - `assistant` → accumulate text for the turn; log one `agent` entry after `run.wait()`;
  - `tool_call` → map `name`/`args` to `AccessRequest` for logging and effects checks; paths from
    defensive parses of `args`;
  - skill invocations → from tool names or args that name a skill (defensive); log `skill: invoked
    <name>`; track `skillsInvoked` / `skillsBeforeOutput`;
  - `usage` → add to `Usage` (token fields from `TokenUsage`); also merge `result.usage` after wait;
  - `system` / `status` / `task` / `thinking` → raw only, or brief `system` lines when useful.
  Each scripted reply is one `agent.send(message)` then `await run.wait()` on the same agent;
  always `await agent[Symbol.asyncDispose]()` (or `await using`).
- **Rationale**: Published stream envelope is stable; tool `args`/`result` are not — parse
  defensively (docs warning).
- **Alternatives considered**: `onDelta` only (too fine-grained for the run log).

## R6. Model pinning and listing

- **Decision**: During implementation, call `Cursor.models.list({ apiKey })` with the harness key
  and pick the best available Composer-family id (Phase 7 example `composer-2.5`, else `composer-2`
  or the account’s closest listed id). Write that id to `models.cursor` in `harness.config.json`.
  Create agents with `model: { id: <chosen> }`.
- **Rationale**: FR-003; list is account-specific. Do not hard-code a missing id.
- **Alternatives considered**: Shipping without a live list (would fail create). Auto/Router models
  (less reproducible for findings).

## R7. Auth, errors, and classifier

- **Decision**: Key variable `CURSOR_API_KEY` only (Phase 5 already redacts `cursor_`). Pass
  `apiKey` explicitly on every create/prompt. `CursorAgentError` / `AuthenticationError` with
  missing or invalid key → `missing-token` or `no-access` (401/403 / “Invalid API key”). Respect
  `error.isRetryable` for rate-limit retries; map rate-limit text/429 to `rate-limit`, premium/
  quota to `allowance`. A finished `RunResult` with `status: "error"` is outcome `error` with
  kind from the classifier on `error_message` / status text.
- **Rationale**: FR-009, FR-011; SDK skill guidance distinguishes startup vs run failures and
  `isRetryable`.
- **Alternatives considered**: Relying on stored `Cursor.auth.login()` credentials (not for CI).

## R8. One-shot ask (judge / reply fallback)

- **Decision**: `cursorAsk(key, model)` uses `Agent.prompt` (or create+send+dispose) with
  `tools: []`, `local: { cwd: throwawayHome, settingSources: [] }`, no plugin install, under the
  same HOME mutex pattern. Default `judge.agent` stays `copilot`.
- **Rationale**: Clarification Q2; `tools: []` means text-only (SDK docs).
- **Alternatives considered**: Skipping ask until a later phase (rejected by clarify).

## R9. Local-only runtime; cloud → Phase 20

- **Decision**: Pass only `local: { ... }` to `Agent.create` / `Agent.prompt`. Never pass `cloud`.
  Research confirms a Cursor-hosted cloud runtime exists (`cloud: { repos }` / empty repos). Per
  clarification Q5, that work is **Phase 20** in `rollout-plan.md`, not this driver.
- **Rationale**: Phase 7 goal and FR-001 / FR-005.
- **Alternatives considered**: Prefer local but fall back to cloud (rejected).

## R10. Dependency and versions

- **Decision**: Add `@cursor/sdk` `^1.4.0` (npm current at plan time) under `harness/package.json`
  only. `cursorVersions()` reads that package’s version as `sdk` and reports `runtime: "local"`.
- **Rationale**: Harness-only dependency; distribution excludes `harness/`.
- **Alternatives considered**: Pinning an exact older version without listing models first.

## R11. Committed logs and parallel

- **Decision**: Live runs use the shared `parallel` setting. Save stdout to
  `specs/249-cursor-driver/harness/smoke-1.log`, `smoke-2.log`, and `codify.log`.
- **Rationale**: Clarifications Q3 and Q4; FR-019.
