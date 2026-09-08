# Contract: Coverage Summary Invariance

**Feature**: `013-auto-tier-honesty` | **Date**: 2026-09-08

This feature adds no command and changes no interface. What it does have is an output contract it
must **not** break, established for `validate-skill.sh` in feature 003. This document states what
must hold unchanged, so a change to it is recognisable as a contract break rather than a detail.

---

## Unchanged: the summary format

```text
CHECKED:   <space-separated rule ids>
FAILED:    <space-separated rule ids>
N/A:       <rule id>=<condition> ...
DEFERRED:  <space-separated rule ids>
UNCHECKED: <space-separated rule ids>
```

| Invariant | Requirement |
|---|---|
| C1 | Exactly five groups, these labels, this order |
| C2 | Every rule id in the constitution appears in exactly one group |
| C3 | An `N/A` entry carries its condition code |
| C4 | Deferred and unchecked rules never affect exit status |
| C5 | A failure is reported under its own rule id, never folded into a general category |

C4 matters here: as P6.4 moves from unchecked to checked, it begins to affect exit status for the
first time. That is intended — it is the point of the feature — but it means any skill violating
P6.4 now fails where it previously passed silently.

---

## Unchanged: exit codes

| Code | Meaning |
|---|---|
| `0` | No check failed |
| `1` | At least one check failed |

---

## Changed: group membership only

| Rule | Before | After |
|---|---|---|
| P2.3 | `UNCHECKED` | `DEFERRED` |
| P6.4 | `UNCHECKED` | `CHECKED`, or `FAILED` if violated |

**Post-condition**: `UNCHECKED` is empty for every skill.

---

## New failure output

`rc_check_P6_4` reports in the established shape — a line naming the location and the specific
problem, dispatched under its own rule id:

```text
ERROR: [P6.4] line 34: decision criterion references 'currently', which is a prohibited time reference
```

The prohibited token is named in the message. A check that says only that something is wrong
forces the author to re-derive the rule from the constitution.

---

## Behavioral guarantees

| # | Guarantee | Requirement |
|---|---|---|
| G1 | Every `[auto]` rule has a registered check | FR-001, SC-002 |
| G2 | The `UNCHECKED` group is empty | FR-002, SC-001 |
| G3 | Each decision is reported under its own rule id | FR-004, C5 |
| G4 | The five-group format is unchanged | FR-005, C1–C3 |
| G5 | The new check is observed rejecting a violating artifact | FR-010, SC-004 |
| G6 | No pre-existing fixture changes verdict undeliberately | FR-009, SC-005 |
| G7 | P6.4 is not applied to library files | FR-011 |
| G8 | A future `[auto]` rule without a check fails the suite | FR-015, SC-008 |

---

## Toolchain

No new utility. The check uses `awk` and `grep`, both already declared, and reads its token list
through the existing `con_token_list()`. D2.2 and D2.4 hold with no change to the Declared
Toolchain.
