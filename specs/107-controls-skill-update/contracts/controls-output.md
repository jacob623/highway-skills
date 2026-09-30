# Controls Output Contract

## Readiness

Controls readiness remains exactly four fields:

```text
Status: Complete|Missing|Blocked
Summary: <Control baseline explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Complete` means the persisted baseline is usable. It does not mean setup/configure collection has
finished.

## Setup/configure collection

The collection result is distinct from readiness and contains only the fields needed by Setup to
continue, finish, stop, or delegate:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Created Control IDs` is intentionally absent. Setup requests fresh readiness after `Finished` and
uses collection status, not cumulative identifiers, to route the interaction.

## Direct mutations

Existing direct Add, Update, Remove, and Set result contracts remain unchanged unless a surviving
owner contract requires a narrowly scoped adjustment. Destructive actions retain their impact
analysis and explicit confirmation.

## User-authored review

Materially interpreted user-authored Controls use:

```markdown
**Here's what I've captured as your Control:**

**Title:**  
[Title]

**Statement:**  
[Statement]

**Why it matters:**  
[Rationale]

**Would you like to accept this Control?**
```

Displayed recommendations are captured directly without this redundant review.
