# Experience Review Output Contract

## Scope

This contract extends the existing Compliance Review Protocol to applicable Experience Standard
rules. It does not create a second report or a second verdict vocabulary.

## Rule result

Every constitutional or applicable Experience Standard rule is represented by one result line:

```text
<RULE-ID> | <VERDICT> | <EVIDENCE>
```

- `<RULE-ID>` is the stable P or X rule ID.
- `<VERDICT>` is exactly `PASS`, `FAIL`, or `N/A`.
- `PASS` and `FAIL` require the same evidence forms defined by the Constitution: quoted artifact
  text of 25 words or fewer, or a file path plus line number. `FAIL` may use `ABSENT`.
- `N/A` requires a named permitted condition token.
- Human-review rules remain in the existing `DEFERRED` block and are not assigned a verdict by an
  agent.

## Coverage summary

The existing summary remains exactly five groups:

```text
CHECKED: <rule ids decided by an automatic check>
FAILED: <rule ids with failed checks>
N/A: <rule ids with condition tokens defined by the applicable governance document>
DEFERRED: <human-review rule ids>
UNCHECKED: <rule ids with no decision>
```

Every rule ID from both shipped governance documents appears in exactly one group. Empty groups
are printed. No `WARN`, `INFO`, `PARTIAL`, or `NOT TESTED` group or verdict is introduced.

## X2 applicability

- X2.2-X2.6 apply to workflows meeting the Experience Standard's Interactive Workflow definition.
- X2.5 is `N/A` when no Long-running activity exists.
- X2.6 is `N/A` when X2.5 is `N/A`.
- Read-only or informational workflows are `N/A` for X2.2 where the rule trigger does not arise.
- Unchanged existing skills remain valid without modification; newly created or amended skills are
  reviewed against applicable X rules.
