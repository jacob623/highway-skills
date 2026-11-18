# Research: Claude Code Driver

Resolves Phase 8 spike questions (FR-001–FR-003) and Technical Context unknowns. Clarify
locks: reject every Bash; pin current Haiku; no numeric smoke/codify floors; judge stays
Cursor/Luna; parallel same as other agents unless live proves unsafe.

## R1. Throwaway home and isolation

- **Decision**: Each attempt uses `options.agentHome` as a throwaway root. Pass
  `env: { CLAUDE_CONFIG_DIR: join(agentHome, "claude-config"), HOME: agentHome,
  CLAUDE_CODE_DISABLE_AUTO_MEMORY: "1", ANTHROPIC_API_KEY: key }` into `query()` options so
  `~/.claude.json` and session state land under the throwaway tree, not the operator home. Set
  `settingSources: []` so user/project/local CLAUDE.md, settings, and skills are not loaded.
  Keep `strictMcpConfig: true` (or `mcpServers: {}` + disable connectors) so claude.ai MCP
  connectors do not leak in. If the SDK still requires a process-level `HOME` for any path,
  serialize with a Cursor-style home mutex only after live evidence of races.
- **Rationale**: Official docs: `settingSources: []` disables filesystem settings; managed
  policy and `~/.claude.json` still load unless `CLAUDE_CONFIG_DIR` relocates the global config;
  auto memory is disabled via env / settings. Matches Phase 8 spike.
- **Alternatives considered**: Inheriting operator `~/.claude` (contamination). Relying on
  `settingSources: []` alone without `CLAUDE_CONFIG_DIR` (global config still read).

## R2. Local plugin install and which manifest is read

- **Decision**: Implement `PluginRpc` by copying `highway-agent-plugin/` into
  `join(agentHome, "plugins", "highway")` (or equivalent under the throwaway home). Shared
  `installPlugin` checks name `highway`, skill count 16, no warning, enabled from that copy.
  Drive sessions with `plugins: [{ type: "local", path: <installed absolute path> }]`. Claude
  Code reads `.claude-plugin/plugin.json` at the plugin root (Phase 6 overlay); root
  `plugin.json` remains present as the Agent Plugins base. Prefer `.claude-plugin/plugin.json`
  for the name field when reading. Live smoke proves 16 skills and that both manifests coexist
  without install failure. Skill invocations are namespaced as `/highway:<skill-id>` (or
  `highway:<skill-id>`); map those plus a read of `skills/highway-experience/SKILL.md` into
  `skillsInvoked` / `skillsBeforeOutput`.
- **Rationale**: SDK Plugins docs: only `type: "local"`; path is the plugin root (parent of
  `skills/` and `.claude-plugin/`). No marketplace CLI required for harness isolation.
- **Alternatives considered**: Pointing `plugins` at the repo `highway-agent-plugin/` without a
  home copy (weaker install checks / shared mutable tree). Marketplace install (Phase 14).

## R3. Permission callback mapping

- **Decision**: Use `permissionMode: "default"` (or omit so default applies) and **do not** put
  tools in `allowedTools` / `acceptEdits`, so every non-auto-approved call reaches `canUseTool`.
  Map tool names to neutral `AccessRequest`:

  | Claude tool | AccessRequest |
  |---|---|
  | `Read`, `Glob`, `Grep` | `read` (path from `file_path` / `path` / pattern cwd) |
  | `Write`, `Edit` | `write` (path) |
  | `Bash` | `shell` → **always deny** (clarify); never allow in-project build/test via Bash |
  | `WebFetch` / `WebSearch` | `url` (deny when scenario `web: no`) |
  | Skill / memory-like | skill tracking / `memory` deny |
  | no path / unknown | `other` |

  On deny: `{ behavior: "deny", message }`. On allow: `{ behavior: "allow", updatedInput: input }`.
  Run shared `permissionPolicy` / Local rules for project + read-root paths. If a call somehow
  runs without `canUseTool` (mode auto-approve), record via stream/tool_use observation and fail
  the attempt afterward (effects backup). Prefer `PreToolUse` hooks only if live proves
  `canUseTool` gaps.
- **Rationale**: Clarify FR-010; SDK docs state `canUseTool` is skipped for `allowedTools` /
  mode-approved calls — so avoid those auto-approvals.
- **Alternatives considered**: `disallowedTools: ["Bash"]` alone (may hide the request from the
  transcript). `bypassPermissions` (forbidden). Codex-style shell allow for build/test (rejected
  in clarify).

## R4. Ask-the-user

- **Decision**: Handle `AskUserQuestion` inside `canUseTool`: map scripted replies into the
  tool’s answer fields and return `{ behavior: "allow", updatedInput }` with those answers so
  the same session continues. If Claude never calls the tool and ends the turn with a question in
  text, the existing reply loop sends the next prompt. Include `AskUserQuestion` whenever a
  tools allowlist is used. Known SDK quirk (plugin skill context may empty answers) → if live
  shows empty answers, fall back to the reply loop and record a finding; do not block Phase 8.
- **Rationale**: Official user-input docs; mirrors Cursor askQuestion handling + reply loop.
- **Alternatives considered**: Ignoring AskUserQuestion and only using the reply loop (weaker).

## R5. Events, skills, usage

- **Decision**: Consume the `query()` async iterator. Map:
  - assistant text blocks → turn buffer / `agent` log;
  - `tool_use` / tool result → permission transcript + skill detection (`Skill` tool, `/highway:…`,
    path under `skills/highway-…`);
  - result message `usage` / `total_cost_usd` → `Usage`;
  - session id from result / system init → keep for resume.
- **Rationale**: TypeScript Agent SDK streaming model; Phase 8 spike.
- **Alternatives considered**: Buffer-only non-streaming (weaker mid-turn enforcement visibility).

## R6. Multi-turn vs resume

- **Decision**: **Resume**: first turn is `query({ prompt, options })`; each scripted reply is a
  new `query({ prompt: reply, options: { ...same, resume: sessionId } })`, then await that
  iterator to completion. Dispose/abort any open query after the attempt. Do not continue the
  operator’s personal sessions.
- **Rationale**: Sessions docs: `resume` takes an explicit session id; clearer than
  `continue` (most-recent-in-cwd) under parallel attempts. Satisfies FR-008 one-send-then-wait.
- **Alternatives considered**: Streaming stdin multi-turn on one query (more complex fake for
  tests). `continue` without id (racy under parallel).

## R7. Errors and rate limits

- **Decision**: `classifyClaudeError` maps HTTP 429 / rate limit / overload text → `rate-limit`;
  401/403 / invalid API key → `no-access`; quota/billing → `allowance`; network timeouts →
  `service-error`. Wire through existing `withRateLimit` / `RunStop` helpers like other drivers.
- **Rationale**: Same classifier contract as Copilot/Cursor/Codex.
- **Alternatives considered**: Custom retry outside shared helpers (rejected).

## R8. Model and auth

- **Decision**: Pin `models.claude` = **`claude-haiku-5-5`** (current Haiku API id as of
  2026-11-18). Auth: `ANTHROPIC_API_KEY` from `harness/.env` (registry `keys: ["ANTHROPIC_API_KEY"]`).
  `sk-ant-` already covered by `sk-` redaction. Judge stays `cursor` + `gpt-5.6-luna`. If live
  listing rejects the id, remap to the closest Haiku the key can use and note it in tasks Notes.
- **Rationale**: Clarify FR-003; Anthropic models overview lists `claude-haiku-5-5` as current
  Haiku (Haiku 4.5 is legacy).
- **Alternatives considered**: Sonnet/Opus (cost; clarify chose Haiku). Dated Haiku 4.5 snapshot.

## R9. Parallel attempts

- **Decision**: Keep configured `parallel` (4). Each attempt owns `CLAUDE_CONFIG_DIR` / throwaway
  `HOME` via per-query `env`. Add a home mutex only if live smoke shows process-global races.
- **Rationale**: Clarify; Codex proved per-client env can stay parallel.
- **Alternatives considered**: Always serial (only after evidence).

## R10. Package version

- **Decision**: Add `@anthropic-ai/claude-agent-sdk` under `harness/` only at current ^ latest
  compatible with Node 24 (pin at `npm install`). Constitution Harness Toolchain MINOR bump
  names it beside Copilot/Cursor/Codex SDKs. Runner must not import the package.
- **Rationale**: Phase 8 names this package; harness-only dependency pattern.
- **Alternatives considered**: Spawning Claude Code CLI without the SDK (brittle).

## R11. One-shot ask

- **Decision**: `claudeAsk(key, model)` creates a throwaway home + `CLAUDE_CONFIG_DIR`, runs one
  `query` with no plugins, tools restricted / empty as the SDK allows (`tools: []` or
  equivalent), `settingSources: []`, returns assistant text. Wired on the registry for later
  judge/fallback; configured judge remains Cursor.
- **Rationale**: FR-004; mirrors `cursorAsk` / `codexAsk`.
- **Alternatives considered**: Skip ask until a later phase (rejected by spec).
