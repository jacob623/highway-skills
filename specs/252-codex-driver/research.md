# Research: Codex Driver

Resolves Phase 9 spike questions and Technical Context unknowns. Clarify locks already fixed
effects-based enforcement (FR-001), storage-contract MINOR wording (FR-002), Codex one-shot ask +
judge=Cursor/Luna, parallel same as other agents, in-project build/test allowed, Luna closest-id
fallback.

## R1. Throwaway home and isolation

- **Decision**: Each attempt sets `CODEX_HOME` (and a matching throwaway `HOME` in the Codex
  `env` bag) to `options.agentHome`. Pass a fully controlled `env` to `new Codex({ env })` so the
  CLI does not inherit personal `~/.codex` or `~/.agents`. Sessions persist under that home only.
  Use `skipGitRepoCheck: true` on `startThread` because harness projects are not git repos.
- **Rationale**: SDK docs: threads persist under `~/.codex/sessions`; `env` fully controls CLI
  variables; `CODEX_HOME` is the documented isolation root for plugins/config. Cursor used a HOME
  mutex because process `HOME` raced; Codex gets per-client `env`, so parallel attempts each own a
  home without a process-global HOME mutex unless live runs prove otherwise.
- **Alternatives considered**: Inheriting process env (personal config leak). Requiring git init in
  every project (unnecessary with `skipGitRepoCheck`).

## R2. Local plugin install and manifest

- **Decision**: Implement `PluginRpc` by filesystem + CLI under the throwaway home: copy
  `highway-agent-plugin/` into a local marketplace tree under the agent home (plugin dir +
  `.agents/plugins/marketplace.json` pointing at it), then run `codex plugin marketplace add` /
  `codex plugin add highway@…` with `CODEX_HOME`/`HOME` set, or equivalently stage into
  `$CODEX_HOME/plugins/…` so skills load. Prefer reading `.codex-plugin/plugin.json` (Phase 6
  overlay with `interface`) with root Agent Plugins `plugin.json` as fallback. `readRoots(home)`
  returns the installed skill tree under that home (cache or staged path research confirms at
  implement). Shared `installPlugin` still checks name `highway`, skill count 16, no warning,
  enabled.
- **Rationale**: Codex documents local marketplace install and `.codex-plugin/plugin.json`
  compatibility; Highway already generates that overlay. Live smoke proves 16 skills.
- **Alternatives considered**: Symlink-only install (fragile). Relying on the developer’s real
  `~/.codex` (contamination). Disabling `features.plugins` (blocks Highway).

## R3. Sandbox, approval, and effects-based enforcement

- **Decision**: Start threads with `sandboxMode: "workspace-write"` (or SDK equivalent), network
  access off (`networkAccessEnabled: false` / `sandbox_workspace_write.network_access: false`),
  and `approvalPolicy: "never"` (or auto-deny interactive approvals). Prefer pre-refuse when the
  SDK/CLI exposes an approval callback; otherwise **effects-based**: after each
  `command_execution` / file-change item, classify the command:
  - **Allow**: in-project read/write effects; in-project build/test (e.g. `npm`/`node`/`tsc`/
    `python` under the project cwd with paths inside the project).
  - **Fail attempt**: `git` (any); paths outside the project; network-facing installs
    (`npm install` from registry without offline/cache-only when detectable; `curl`/`wget` to
    remote; package adds that hit the network).
  Record denied/forbidden completions as permission transcript lines and fail the attempt.
- **Rationale**: Matches clarify FR-001/B. Codex’s primary edit path is shell; banning all shell
  breaks the driver. Workspace-write sandbox is the first fence; effects classification is the
  second (same pattern as Cursor Phase 7 when pre-reject is incomplete).
- **Alternatives considered**: Fixed command allowlist only (rejected in clarify). `full_access`
  sandbox (too weak). Failing all interpreters (blocks codify).

## R4. Events, skills, usage

- **Decision**: Drive turns with `thread.runStreamed` (or `run` + items if streaming unavailable).
  Map:
  - agent/assistant message items → turn text / `agent` log;
  - `command_execution` → `AccessRequest` (shell) + effects check;
  - file-change items → write/read requests with paths;
  - skill invocation → from command/args/paths that name a skill or read
    `highway-experience/SKILL.md` / plugin skill paths; update `skillsInvoked` /
    `skillsBeforeOutput`;
  - `turn.completed.usage` → `Usage`.
  Each scripted reply is one `run`/`runStreamed` on the same thread, then wait for turn completion.
- **Rationale**: Official SDK streaming model; items.ts defines `command_execution`.
- **Alternatives considered**: Buffer-only `run()` without mid-turn effects (weaker enforcement).

## R5. Questions

- **Decision**: With `approvalPolicy: "never"`, interactive ask-the-user is not the primary path.
  Unanswered questions in assistant text are handled by the existing reply loop after the turn
  ends (same as Cursor headless). If research finds an ask tool event, answer it when present;
  do not block exit on it.
- **Rationale**: Clarify and Phase 7 pattern; Codex headless SDK is turn-based.
- **Alternatives considered**: Faking interactive approvals (unstable).

## R6. Auth and model

- **Decision**: Keys: prefer `OPENAI_API_KEY`, accept `CODEX_API_KEY` if that is what the SDK
  injects/documents (registry `keys` lists both in order; last is the one README tells a person to
  set — follow existing Agent.keys convention). **Pinned** `models.codex` = `gpt-5.6-luna` (same
  Luna id as Copilot/Cursor). Live confirmation may remap if Codex’s model list rejects that id;
  document any remap in tasks Notes. Judge config: `judge.agent = cursor`,
  `judge.model = gpt-5.6-luna`.
- **Rationale**: Clarify FR-004/FR-005a; SDK injects `CODEX_API_KEY` while many users hold
  `OPENAI_API_KEY`.
- **Alternatives considered**: Unpinned SDK default model (forbidden by clarify). Keeping Copilot
  as judge (overridden by clarify).

## R7. Parallel attempts

- **Decision**: Keep configured `parallel` (4). Each attempt owns `CODEX_HOME`/`HOME` via client
  `env`. If live smoke shows cross-attempt races, record a serial override in Notes and
  temporarily set parallel 1 for Codex only — only after evidence.
- **Rationale**: Clarify choice A.
- **Alternatives considered**: Always-serial (rejected unless unsafe).

## R8. Storage-contract skill wording

- **Decision**: Add a Local-mode sentence under Paths or Operations: when the agent’s file tool
  is the shell, in-project reads/writes may go through that shell; the skill still must not run
  `git`, reach outside the repository root, or treat network/package installs as storage
  operations. Bump highway-experience MINOR; regenerate adapters/plugin/catalog.
- **Rationale**: FR-002 clarify.
- **Alternatives considered**: Harness-only (rejected).

## R9. One-shot ask

- **Decision**: `codexAsk(key, model)` creates a throwaway home, starts a thread with no plugin
  install / tools as restricted as the SDK allows, runs one prompt, returns text. Wired on the
  registry even though the configured judge is Cursor.
- **Rationale**: FR-005 clarify; mirrors `cursorAsk`.
- **Alternatives considered**: Skip ask until a later phase (rejected).

## R10. Package version

- **Decision**: Add `@openai/codex-sdk` under `harness/` at the current ^ latest compatible with
  Node 24 (pin exact minor at `npm install` time). Constitution Harness Toolchain MINOR bump
  names it. `@openai/codex` CLI may be pulled transitively; document if a global `codex` binary
  is also required.
- **Rationale**: Phase 9 names this package; harness-only dependency pattern from Phase 7.
- **Alternatives considered**: Spawning raw CLI without SDK (more brittle event parsing).
