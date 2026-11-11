# Data Model: Standard Alignment Record Templates in Their Skills

## Record template

A complete template for one kind of record.

- **Location**: `skills/<owner>/assets/<name>.md` for the 11 moved templates;
  `.highway/library/templates/output/<name>.md` for `adr-record`, `architecture-record`, and
  `implementation-record` until Phase 10.
- **Frontmatter**: `name`, `description`, `metadata.version`. Unchanged by the move.
- **Marker**: at least one `## File Frontmatter`, `## Body`, or `## Catalog Structure` heading. This is
  what makes it a complete template to the skill validator and the template check.
- **Resolved by**: `hw_template <name>`.
- **Read by**: its owning skill only (moved templates); the owner and highway-onboarding (shared three).

## Owning skill

The one skill that creates a kind of record.

- **Names its template as**: `assets/<name>.md`, in Inputs, Outputs, steps, and Verification.
- **Version**: one MINOR increment in this phase.
- **Validated with**: its own `SKILL.md` checks, plus the template checks on each complete template in its
  `assets/`.

## Skeleton

One of highway-setup's 12 empty project files in `skills/highway-setup/assets/`.

- **Marker**: none of the three template headings.
- **Checked by**: `catalog-seeding.test.sh`, against its reference copy in
  `tests/fixtures/catalog-seeding/skeletons/<name>.md`, and by the template check against fixtures.
- **Not checked by**: the skill validator.

## Validation cache key

- **Before**: hash of `SKILL.md` plus the environment hash (validator, libraries, governing documents,
  `.highway/library/`).
- **After**: hash of `SKILL.md` and every file under the skill's `assets/` (sorted), plus the environment
  hash, which also covers `validate-library.sh`.

## Relationships

```text
owning skill 1 ── n complete templates in assets/   (validator checks each)
highway-setup 1 ── 12 skeletons in assets/          (catalog-seeding compares each with its reference)
hw_template name ── 1 template or skeleton path
```
