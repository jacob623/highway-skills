# Contract: Claude session-start no-Bash guidance

## What this change supplies

`harness/src/drivers/claude.ts` must:

1. Pass `systemPrompt: { type: "preset", preset: "claude_code", append: CLAUDE_LOCAL_GUIDANCE }`
   on every Claude **drive** `query()` so Local-mode / no-Bash guidance reaches session start.
2. Use `settingSources: []` on drive sessions (isolation; do not rely on `"user"` CLAUDE.md load).
3. May keep `prepareClaudeAgentHome` writing `.claude/CLAUDE.md` as supporting only — not
   sufficient alone for FR-002.
4. Keep deny-all-Bash and fatal `rejected-request` on refuse. Optional deny message may remain.
5. Leave `claudeAsk` without guidance append; `settingSources: []`.

## Unit tests (`harness/test/claude.test.ts`)

MUST cover:

- Drive `query` options include `systemPrompt` preset `claude_code` with append containing
  file-tool / no-Bash markers.
- Drive `settingSources` is `[]`.
- Bash still denied through `canUseTool`.
- `prepareClaudeAgentHome` still writes the supporting file if kept.

## Out of scope

- Allowing any Bash under Local mode.
- Codex-style continue-after-refuse.
- Skill / template / fixture / scenario edits.
- Changing Copilot, Cursor, or Codex drivers.
