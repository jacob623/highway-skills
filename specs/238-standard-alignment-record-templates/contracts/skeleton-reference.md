# Contract: Skeleton Reference Comparison

## Reference copies

`tests/fixtures/catalog-seeding/skeletons/<asset>` holds one file for each asset `hw_seeded` lists (12),
byte-identical to `skills/highway-setup/assets/<asset>` when this phase lands.

## Check

In `tests/catalog-seeding.test.sh`, for each asset `hw_seeded` lists:

- a missing reference copy fails with `<asset>: no reference copy`;
- any difference fails with `<asset>: differs from its reference copy`, followed by the `diff` lines that
  differ;
- `storage.md` must contain the line `Mode: Local` exactly, or the test fails with
  `storage.md: does not say Mode: Local`.

A heading, version line, frontmatter key, table header column, or line of prose that is removed, added,
or changed in a skeleton is a difference.

## Changing a skeleton on purpose

Edit the skeleton and its reference copy in the same change.

## Seeded failure

A copy of `request-catalog.md` with its `Status` column removed differs from the reference, and the
comparison reports it.
