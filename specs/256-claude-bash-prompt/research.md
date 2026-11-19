# Research: Claude Bash Prompt

Resolves Technical Context unknowns for F33 recovery after Spec 255. Locks carried forward:
refused Bash still fails the attempt; smoke ≥14/16 each; clearer denial feedback optional;
throwaway-home file alone is not enough; Haiku pin and Cursor/Luna judge stay; no
skill/template/fixture/scenario edits.

## R1. How session-start guidance is delivered

- **Decision**: On every Claude **drive** `query()`, set
  `systemPrompt: { type: "preset", preset: "claude_code", append: CLAUDE_LOCAL_GUIDANCE }`
  (same text as Spec 255’s `CLAUDE_LOCAL_GUIDANCE`). Keep writing
  `prepareClaudeAgentHome` → `<home>/.claude/CLAUDE.md` as a supporting artifact. Prefer
  `settingSources: []` again for drive sessions so isolation matches Phase 8 (no project/local
  settings; no reliance on `"user"` CLAUDE.md load, which Spec 255 did not prove effective).
  `claudeAsk` stays `settingSources: []` and does **not** need the append (no plugin / no Bash
  path).
- **Rationale**: Official Agent SDK docs: CLAUDE.md is not loaded when `settingSources: []`;
  `systemPrompt` preset `append` always injects into the session. Spec 255’s `"user"` + home
  file missed ≥14/16 and Bash denials rose vs Phase 8. FR-002 requires guidance that reaches
  session start. Append is the reliable lever; home file alone is explicitly insufficient.
- **Alternatives considered**:
  - Keep `settingSources: ["user"]` only (already tried; did not close F33).
  - Append **and** `"user"` (duplicate delivery; risk of loading empty user settings side
    effects — unnecessary if append is required).
  - Custom full `systemPrompt` string (drops `claude_code` tool/safety guidance).

## R2. Guidance content

- **Decision**: Reuse `CLAUDE_LOCAL_GUIDANCE` from Spec 255 (prefer Read/Write/Edit/Glob/Grep;
  do not use Bash; stay in project; no memory; Highway skills / experience order). No skill
  text edits; no softening of deny-all-Bash.
- **Rationale**: Same message Spec 255 intended; only the delivery path changes.
- **Alternatives considered**: Longer prompt with examples (noise); denial-message-only (optional,
  already shipped, not enough alone).

## R3. Enforcement unchanged

- **Decision**: Deny-all-Bash, fatal refuse → `rejected-request`, path/memory bans, effects
  backup for completed forbidden tools — unchanged. Optional `CLAUDE_BASH_DENY_MESSAGE` may
  remain; not an exit gate.
- **Rationale**: Spec FR-001; prior clarify locks.
- **Alternatives considered**: Codex continue-after-refuse (forbidden).

## R4. Confirmation bar and baselines

- **Decision**: Two `--agent claude --smoke` (≥14/16 each) and one
  `--agent claude --skills highway-codify` (no numeric floor). Logs under
  `specs/256-claude-bash-prompt/harness/`. F33 closes only if both smoke bars hold **and**
  Bash-driven `rejected-request` fails are fewer than Phase 8 baseline
  (`specs/254-claude-code-driver/harness/smoke-*.log`). Spec 255 logs are comparison context,
  not the close baseline. Model Haiku; judge Cursor/Luna; parallelism unchanged unless live
  proves unsafe.
- **Rationale**: Spec FR-003–FR-005, FR-007; Spec 255 smoke bar lock.
- **Alternatives considered**: Raise bar to ≥15/16 (stricter than locked Spec 255 bar).

## R5. Tests and docs

- **Decision**: Extend `harness/test/claude.test.ts`: assert drive `query` options include
  `systemPrompt` preset `claude_code` with append containing no-Bash / file-tool markers;
  assert `settingSources: []` on drive (after this change); keep Bash deny tests; keep
  `prepareClaudeAgentHome` file write test. Suite + harness unit/typecheck green. Update
  `harness/README.md` Claude section for session-start append + optional home file. Update
  findings and rollout Status from live evidence. No constitution bump.
- **Rationale**: FR-006, FR-009, D3.1–D3.3, D6.1.
- **Alternatives considered**: Live-only validation (fails FR-006).
