# Data Model: Highway Objective

## Business Objective Record

- **Path**: `library/objectives/OBJXXXXXX.md`.
- **Ownership**: User-owned; never written beneath `.highway`.
- **Frontmatter**: `id`, `title`, `status`, and `capabilities: []` in the retained record template.
- **Body**: Statement, success measures, and rationale as user-owned Markdown content.
- **Identifier**: `OBJ` followed by six digits; allocated once, never changed, and never reused.
- **Status**: Defaults to `active`; update may change it to the supported user-owned status value.

## Objective Baseline

- **Records**: The set of files under `library/objectives/`.
- **Version**: Semantic baseline version stored in the catalog; one increment follows each confirmed
  mutation according to the action table.
- **Next identifier**: Catalog-owned allocation pointer greater than every allocated identifier,
  including identifiers whose records were removed.
- **State transition**: Read-only -> proposed -> confirmed write, or proposed -> declined/aborted
  with all bytes unchanged.

## Objective Catalog

- **Path**: `library/governance/objectives.md`.
- **Contents**: Baseline version, `next_id`, objective index, identifiers, titles, statuses,
  ownership statement, and direct-edit warning.
- **Ordering**: Stable identifier order.
- **Determinism**: No timestamps, random identifiers, environment-derived values, or unordered
  input effects.

## Mutation Report

- **Fields**: Action, file, summary, affected entries, confirmation status, and resulting version.
- **Read-only result**: Reports status without a write and identifies the absence when no baseline
  exists.
- **Declined/failed result**: Reports the reason and `Confirmation Status: Declined` or the
  applicable non-write state while preserving affected bytes.

## Validation Invariants

- Every objective file has a unique valid identifier.
- Every catalog entry resolves to exactly one objective file.
- `next_id` is greater than every allocated identifier and is not reused after deletion.
- No objective record exists beneath `.highway`.
- No emitted artifact contains a timestamp, random identifier, or environment-derived value.