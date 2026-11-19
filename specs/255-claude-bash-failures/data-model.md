# Data Model: Claude Bash Failures

## Throwaway Claude home (extended)

| Path | Role |
| --- | --- |
| `agentHome` / throwaway `HOME` | Entire attempt home (unchanged) |
| `CLAUDE_CONFIG_DIR` → `join(agentHome, "claude-config")` | Global config / sessions (unchanged) |
| `join(agentHome, "plugins", "highway")` | Staged Highway plugin (unchanged) |
| **`join(agentHome, ".claude", "CLAUDE.md")`** | **NEW**: Local-mode / no-Bash guidance for this attempt only |

## Guidance artifact

| Field | Value |
| --- | --- |
| Constant | `CLAUDE_LOCAL_GUIDANCE` (exported string in `claude.ts`) |
| Writer | `prepareClaudeAgentHome(agentHome)` |
| Content | Prefer Read/Write/Edit/Glob/Grep; do not use Bash; stay in project; no memory; follow Highway skills / experience order |
| Isolation | Must not copy operator `~/.claude` or personal `CLAUDE.md` |
| Load path | Drive sessions: `settingSources: ["user"]` (loads `~/.claude/CLAUDE.md` under remapped HOME) |
| Ask path | `claudeAsk` keeps `settingSources: []` |

## Permission classification (unchanged from Phase 8)

| Tool / effect | Outcome |
| --- | --- |
| Read/Glob/Grep inside project or read root | Allow |
| Write/Edit inside project | Allow |
| Write/Edit outside project | Deny |
| **Any Bash** | **Deny** (always) → attempt still fails storage as `rejected-request` |
| Memory | Deny |
| Web when `web: no` | Deny |

Optional: Bash deny `message` may name file tools; still fatal.

## Config / registry

Unchanged: `models.claude` (Haiku), `judge.agent` / `judge.model` (cursor / Luna), `claude` registry row.

## Findings entity F33

| Field | Close rule |
| --- | --- |
| Status | Closed only if both confirming smokes ≥14/16 **and** Bash-driven `rejected-request` fails are fewer than Phase 8 baseline |
| Else | Update Runs / Basis / Proposed resolution; leave open |

## Committed run logs

| File | Run | Pass bar |
| --- | --- | --- |
| `specs/255-claude-bash-failures/harness/smoke-1.log` | First `--agent claude --smoke` | ≥14/16 |
| `specs/255-claude-bash-failures/harness/smoke-2.log` | Second `--agent claude --smoke` | ≥14/16 |
| `specs/255-claude-bash-failures/harness/codify.log` | `--agent claude --skills highway-codify` | No numeric floor; map failures to findings |

Baseline comparison: `specs/254-claude-code-driver/harness/smoke-*.log`.
