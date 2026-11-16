# Contract: Live confirmation runs (F29)

## When

After the full bash suite and harness unit tests pass with the mapping fix.

## Commands (repository root)

```bash
export PATH="$HOME/.local/node/bin:$PATH"
mkdir -p specs/250-cursor-experience-order/harness
node harness/src/cli.ts --agent cursor --smoke > specs/250-cursor-experience-order/harness/smoke-1.log
node harness/src/cli.ts --agent cursor --smoke > specs/250-cursor-experience-order/harness/smoke-2.log
node harness/src/cli.ts --agent cursor --skills highway-codify > specs/250-cursor-experience-order/harness/codify.log
```

Use `CURSOR_API_KEY` from `harness/.env`. Model and parallel stay as configured (`gpt-5.6-luna`,
shared parallel). Judge stays Copilot. Exactly one confirmation cycle — no extra cycles for
Copilot pass-table parity.

## Pass gate for F29

- Zero attempts in `smoke-1.log`, `smoke-2.log`, and `codify.log` fail experience-order with
  `actual no skill`.
- Every attempt that reaches install still reports `installed plugin highway (16 skills)`.
- Logs hold no secret, token, or temporary filesystem path (use existing redaction).

## Findings

- If the gate holds: resolve F29; record remaining experience-order under F27 (or a new residual
  if Cursor’s model-skip rate is still much worse than Copilot’s).
- If any confirmation attempt still shows `actual no skill`: leave F29 open; do not mark won’t-fix
  without a person decision.
- Note Phase 7 Status in `rollout-plan.md` when F29 resolves.
