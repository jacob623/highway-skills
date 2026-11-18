# Data Model: Codex Smoke Failures

Entities for harness behavior this phase. No new persisted product schemas.

## ThrowawayCodexHome

Per-attempt isolated Codex/user home (`options.agentHome`).

| Field | Rules |
| --- | --- |
| `path` | Unique temp directory; set as `CODEX_HOME` and throwaway `HOME` in Codex `env` |
| `rules/default.rules` | Required; `prefix_rule` forbidding `git` (R1) |
| `AGENTS.md` | Required short Local-mode / no-`git` guidance (R3); harness-authored |
| Plugin tree | Staged/installed `highway` with 16 skills; enabled |

**Validation**: Must not contain or symlink the operator’s personal `~/.codex` or personal
`AGENTS.md`. Shared install checks still pass.

## GitShellDecision

Classification outcome for a shell access that is git.

| Field | Values / rules |
| --- | --- |
| `kind` | Always treated as denied for Local mode |
| `status` | From Codex `command_execution` item (`completed`, `failed`, …) |
| `fatal` | `true` only when `status === "completed"`; otherwise `false` (pre-refuse / denied) |
| `summary` | Permission transcript line distinguishing pre-refuse vs completed-fatal |

**State transition**:

```text
request seen → rules forbid (preferred) → non-fatal logged denial → attempt continues
           ↘ command completes anyway → fatal rejection + effects fail → attempt fails
```

## CodexAttemptOutcome (confirmation)

| Field | Rules |
| --- | --- |
| Plugin install | Must show 16 skills (SC-001) |
| Smoke pass count | ≥9/16 per confirming smoke (FR-005) or F31 stays open with miss documented |
| Codify | Log required; no numeric floor; map failures to findings |
| Git-driven fails | Must be fewer than Phase 9 baseline to close F31 (with smoke bar) |

## FindingF31

| Field | Update rules |
| --- | --- |
| Status | Close only when FR-005 bar + fewer git-driven fails; else remain open |
| Runs / Basis | Point at this spec’s logs vs `specs/252-codex-driver/harness/` |
| Proposed resolution | Pre-refuse + guidance + load fixes as implemented |

## Relationships

- `ThrowawayCodexHome` → owns rules, guidance, plugin install for one attempt.
- `GitShellDecision` → produced by Codex driver; consumed by runner fatal filter.
- Confirming logs → update `FindingF31` and any new findings.
