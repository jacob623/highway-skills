# Data Model: Delivery Platform Proposal

## Held field

One per Execution line: Deployed by, Managed by, Language.

| State | Deployed by / Managed by | Language |
|-------|--------------------------|----------|
| Unset | `Needed`, empty, or a platform with no platforms-catalog row | `None` or empty |
| Stored | A platform with a platforms-catalog row | A coding-standard title |
| Named | A value the person named in this visit | Same |

## Transitions

- Unset → value from `execution` (a row, or `Needed` / `None` when no candidate).
- Stored → unchanged.
- Named → unchanged for the rest of the visit.
- `accept` writes the three held fields when Deployed by and Managed by are not `Needed`.
- `decline` writes nothing.
