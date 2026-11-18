# Contract: Git Pre-Refuse (Codex Driver)

## Scope

Harness Codex driver behavior for Local-mode `git` under FR-001 / FR-002.

## Pre-run deny (primary)

1. Before starting a Codex thread for an attempt, the throwaway home MUST contain
   `$CODEX_HOME/rules/default.rules` with a rule that forbids the `git` command prefix
   (`decision = "forbidden"`).
2. The throwaway home MUST contain short Local-mode / no-`git` guidance (`AGENTS.md` or
   equivalent under that home only).
3. Neither file may be copied from the operator’s personal home.

## Classification (backup + continue semantics)

| Observation | Permission log | `Rejection.fatal` | Attempt |
| --- | --- | --- | --- |
| `git` requested and denied / not completed | Denied / pre-refused git | `false` | May continue |
| `git` `command_execution` with status `completed` | Rejected git (completed) | `true` | Fail (effects) |
| Outside-path or network-install shell (completed/failed per Phase 9) | As today | `true` (unchanged) | Fail |

## Non-goals

- Pre-refuse of outside-path or network-install shells this phase.
- Allowing completed `git` under any circumstance.
- Changing Copilot or Cursor drivers.

## Unit-testable surface

- Rules + guidance files exist under a prepared agent home with expected content fragments.
- Classifier / noteAccess: git + non-completed → non-fatal; git + completed → fatal.
