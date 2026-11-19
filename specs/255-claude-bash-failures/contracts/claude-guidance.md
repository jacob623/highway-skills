# Contract: Claude throwaway-home no-Bash guidance

## What this change supplies

`harness/src/drivers/claude.ts` gains:

1. **`CLAUDE_LOCAL_GUIDANCE`**: short markdown telling the agent to prefer
   Read / Write / Edit / Glob / Grep, not Bash; stay in-project; no memory; follow Highway
   skills / experience order.
2. **`prepareClaudeAgentHome(agentHome)`**: writes
   `join(agentHome, ".claude", "CLAUDE.md")` with that guidance. Must not copy the operator’s
   personal Claude config.
3. **Drive-session load**: Claude attempt `query` options use `settingSources: ["user"]` so the
   remapped throwaway `HOME` loads that user CLAUDE.md. Must not enable `"project"` or
   `"local"`. `claudeAsk` keeps `settingSources: []`.
4. **Enforcement unchanged**: every Bash request denied before run; successful refuse still fails
   the attempt as storage `rejected-request`. Optional deny `message` may name file tools; not
   required for exit.

## Unit tests (`harness/test/claude.test.ts`)

MUST cover:

- `prepareClaudeAgentHome` creates `.claude/CLAUDE.md` containing the guidance markers
  (file tools named; Bash discouraged).
- Drive path invokes prepare and passes `settingSources: ["user"]` into `query` options.
- Bash still denied through `canUseTool` (fatal path unchanged).
- If optional denial wording is added, assert the deny message names file tools.

## Out of scope

- Allowing any Bash under Local mode.
- Codex-style continue-after-refuse for Claude Bash.
- Skill / template / fixture / scenario edits.
- Changing Copilot, Cursor, or Codex drivers.
