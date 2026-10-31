# Contract: Select the Explored Option

Applies to `.highway/skills/highway-discovery/SKILL.md`.

## explore ending

**Are there any additional concerns you would like to explore for this option, or would you like to return to the list of options?**

If you'd like to select this option for the Decision record, just say so.

## New reply class

- `adopt`: selects the option being explored for the Decision record.

## explore replies

| Reply | Result |
|---|---|
| `adopt` | Continue as `highway-adr` with this Discovery id and this option id, at `start`. Do not create the ADR in this skill |
| Every existing reply | Unchanged |

## Unchanged

- The `decide` class and its handling in `start` and `explore`.
- The `start` line "If you are ready to decision on one of these options, just say so."
- Discovery writes no decision.
