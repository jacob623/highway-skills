# Constitution Amendment Contract

## Scope

Feature 039 adds only Layer 0 rules to `.specify/memory/constitution.md`.

## Required amendments

| Rule | Principle | Tier | Required observable |
|---|---|---|---|
| D3.7 | III | `[auto]` | Every registered `[auto]` check declares its scope as a set of artifact classes, and a seeded defect in one artifact of each class produces a non-zero exit |
| D3.8 | III | `[agent-checkable]` | Each test declares its instrument class, and a coverage row for a runtime-behavior requirement names a test of the executed-behavior class |
| D5.5 | V | `[auto]` | Directory suffix matches the `Feature Branch` value and is not a placeholder |
| D7.4 | VII | `[auto]` | Every in-scope completed feature has `coverage.md` with the declared schema, and every outcome is `satisfied`, `deferred`, or `historical`, with `historical` bounded to Features 001-020 |
| D7.5 | VII | `[agent-checkable]` | Corrective coverage identifies the originating feature and revised requirement |

## Existing-rule amendment

D5.1's Observable gains two narrow exceptions:

1. The coverage record may be updated in a completed feature directory for retroactive accounting
   and D7.5 superseding entries.
2. Relocating a completed spec directory is not an edit to it, because no file's content changes
   and D5.5 is what compels the move.

No other file's content may change under either exception. D5.2 remains unchanged.

## Enforcement Map

D5.5 and D7.4 are `[auto]`, so each MUST appear in the Enforcement Map naming an existing test.
`constitution-inventory.test.sh` fails if either is absent.

## Pre-enable assessment

Per D3.4, D3.7 and D3.8 MUST each be measured against the repository before being enabled. A rule
that cannot reach conformance within this change is recorded as enabled later, never tagged as
enforced while unproven.

## Exclusions

- No new constitution principle.
- No amendment to the Highway Skills Constitution.
- No amendment to the Experience Standard.
- No requirement that every test be executable; static prose-contract tests remain valid for skill-content requirements.
