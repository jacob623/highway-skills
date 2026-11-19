# Data Model: Claude Bash Prompt

## Session-start guidance

| Field | Value |
| --- | --- |
| Constant | `CLAUDE_LOCAL_GUIDANCE` (existing; reused) |
| Delivery | Drive `query` options: `systemPrompt: { type: "preset", preset: "claude_code", append: CLAUDE_LOCAL_GUIDANCE }` |
| Isolation | Drive `settingSources: []` (no operator/project/local settings) |
| Supporting file | `prepareClaudeAgentHome` may still write `join(agentHome, ".claude", "CLAUDE.md")` — not sufficient alone |
| Ask path | `claudeAsk` keeps `settingSources: []`; no append required |

## Permission classification (unchanged)

| Tool / effect | Outcome |
| --- | --- |
| Read/Glob/Grep inside project or read root | Allow |
| Write/Edit inside project | Allow |
| Write/Edit outside project | Deny |
| **Any Bash** | **Deny** → attempt still fails as `rejected-request` |
| Memory | Deny |

Optional: `CLAUDE_BASH_DENY_MESSAGE` may remain; still fatal.

## Config / registry

Unchanged: `models.claude` (Haiku), judge cursor / Luna, `claude` registry row.

## Findings entity F33

| Field | Close rule |
| --- | --- |
| Status | Closed only if both confirming smokes ≥14/16 **and** Bash-driven `rejected-request` fails are fewer than Phase 8 baseline |
| Else | Update Runs / Basis / Proposed resolution; leave open |

## Committed run logs

| File | Run | Pass bar |
| --- | --- | --- |
| `specs/256-claude-bash-prompt/harness/smoke-1.log` | First smoke | ≥14/16 |
| `specs/256-claude-bash-prompt/harness/smoke-2.log` | Second smoke | ≥14/16 |
| `specs/256-claude-bash-prompt/harness/codify.log` | highway-codify | No numeric floor |

Baselines: Phase 8 `specs/254-claude-code-driver/harness/smoke-*.log`; Spec 255 logs for context.
