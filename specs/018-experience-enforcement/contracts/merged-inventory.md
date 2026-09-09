# Contract: Merged Rule Inventory

**Feature**: 018-experience-enforcement | **Date**: 2026-09-08

The interface this feature exposes is the behaviour of the rule loader, the coverage summary, and
the inventory test. This is the contract those must meet.

## Loader contract

```text
con_rules <document-file>
```

Signature unchanged. One document per call; callers that need several call it several times.

| ID | Guarantee | Why it matters |
|---|---|---|
| L1 | Emits one tab-separated record per rule row: id, tier, text, observable | Existing consumers parse this shape |
| L2 | Accepts `P` and `X` rule ids | The only change; the pattern was the sole namespace binding |
| L3 | Rejects a malformed row and exits non-zero | Unchanged |
| L4 | A caller passing one document sees behaviour identical to today | `FR-003` |
| L5 | Returns nothing for a document whose namespace it does not match, without error | A document with no matching rows is empty, not broken |

**L5 is the trap.** A loader that silently returns nothing is indistinguishable from one that
matched everything and found no problems. That is why the inventory test carries a vacuity
assertion rather than trusting L5 to be visible.

## Caller scoping contract

| Caller | Documents loaded | Rationale |
|---|---|---|
| `validate-skill.sh` | Skills Constitution **and** Experience Standard | A skill is subject to both |
| `validate-library.sh` | Skills Constitution **only** | Library content emits nothing; `X` rules govern skill emissions |

This is a stated contract, not an accident of the call site. A future caller must choose its
document list deliberately.

## Coverage summary contract

Unchanged in format. Five groups, every rule id in exactly one:

```text
CHECKED:   <ids>
FAILED:    <ids>
N/A:       <ids>
DEFERRED:  <ids>
UNCHECKED: <ids>
```

| ID | Guarantee |
|---|---|
| C1 | Every `P` and `X` rule appears in exactly one group |
| C2 | `UNCHECKED` is empty |
| C3 | An `X` rule tagged `[agent-checkable]` appears in `DEFERRED` without any check being written |
| C4 | A failing check reports under its own rule id, with the rule's Observable in the message |

## Inventory test contract

| ID | Guarantee |
|---|---|
| I1 | Fails when a rule from either document appears in no coverage group |
| I2 | Fails when a rule appears in more than one |
| I3 | **Fails when the reader matched no rule from a document it claims to cover** |
| I4 | Names the offending rule and the document it came from |

I3 is the vacuity assertion. Feature 014's first extended guard passed while iterating nothing,
because the shared parser was bound to a namespace the guard was not using. The same parser is
being changed here.

## Specimen check contract

| ID | Guarantee |
|---|---|
| S1 | Reads the skill's `## Example` section |
| S2 | Where the Example repeats a value the skill's metadata also declares, the two agree |
| S3 | Records `N/A` where the skill's Example contains no such value |
| S4 | Names the field and both values on failure |

**S2 already fails.** `highway-help`: metadata `3.0.2`, Example `Version: 3.0.1`. The repair
precedes enabling the check.

## Prohibited outcomes

Stated so they are checkable rather than remembered:

- **No rule tagged `[auto]` without a registered check that decides it.** The feature is named
  "enforce"; that is not a reason to claim enforcement.
- **No proxy check that cannot fail.** A check that passes every input is worse than none, because
  it occupies the rule id and reports `CHECKED`.
- **No second enforcement mechanism.** The rule-check library stays the only one.
- **No `X` rule reaching library validation.**
- **No change to the five-group format.**

## Acceptance

| # | Check | How |
|---|---|---|
| A1 | All 8 `X` rules appear in the summary | Run the validator, read the groups |
| A2 | `UNCHECKED` empty for both skills | Same |
| A3 | Inventory test fails on an ungrouped rule | Seed one, observe, restore |
| A4 | Inventory test fails when the reader matches nothing | Break the pattern, observe, restore |
| A5 | Each new check observed failing and passing again | Round trip per check |
| A6 | Library validation unaffected | Run it before and after; verdict unchanged |
| A7 | Single-document callers unchanged | Existing tests pass |
| A8 | Automated `X` count reported as measured | Stated in the completion record |
