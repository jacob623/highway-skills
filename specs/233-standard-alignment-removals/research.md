# Research: Standard Alignment Removals

The spec has no open clarification. This file records the decisions that fix how each removal is
made, and the inventory each decision rests on. The inventory was taken with a repository-wide
search that excludes `specs/`, `standard-alignment.md`, `rollout-plan.md`, `.git/`, and the
harness's `node_modules/` and `runs/`.

## R1. Reference inventory

Every file outside the excluded paths that names a removed file or field:

| File | What it names | Action |
|---|---|---|
| `README.md` (root) | `.highway/catalog/index.md` | Reword the "Build the catalog" line to name only `index.json` |
| `.highway/tools/README.md` | `index.md` in the generate-catalog section; the whole generate-library-catalog section | Reword the first; delete the second |
| `.highway/skills/_authoring-standard.md` | `overlap_flags` in step 4 of the manual overlap review | Delete step 4 (R4) |
| `.highway/skills/highway-help/SKILL.md` and its four agent copies | `overlap_flags` in "When not to use" | Delete the line in the source, bump the version, regenerate the copies |
| `.highway/tools/generate-catalog.sh` | `index.md`, `catalog/README.md`, `overlap_flags`, `generated_at` | Write `index.json` only, with `entries` only (R3) |
| `.highway/catalog/index.json` | `generated_at`, `overlap_flags` | Regenerate |
| `.highway/catalog/index.md`, `library-index.json`, `library-index.md`, `README.md` | Removed files | Delete |
| `.highway/tools/generate-library-catalog.sh`, `audit-objective-rename.sh`, `.objective-rename-allowlist`, `audit-profile-migration.sh`, `seed-library-context.sh` | Removed files | Delete |
| `.highway/tools/.distribution-manifest` | Rows exclude `.objective-rename-allowlist`, `audit-objective-rename.sh`, and the seeding script's three missing root sources | Delete those five rows; keep the `.DS_Store` row (R10) |
| `.highway/tools/tests/generate-catalog.test.sh` | `generated_at`, `overlap_flags`, `index.md` | Make stricter (R3) |
| `.highway/tools/tests/adapter-coverage.test.sh` | `strip_timestamp`, `generate-library-catalog.sh` twice, the four catalog files | Drop the library generator calls and the timestamp filter; compare `index.json` byte for byte (R5) |
| `.highway/tools/tests/distribution-packaging.test.sh` | `normalize_catalog_timestamps` over four catalog files | Remove the function and its calls (R5) |
| `.highway/tools/tests/feature-092-correspondence.test.sh` | The `generate-library-catalog.sh` token and `library-index.json` | Drop both (R6) |
| `.highway/tools/tests/fixtures/profile-092/dependent-artifact-inventory.tsv` | `index.md` in row 4; row 5 is the library index | Drop `index.md` from row 4; delete row 5 (R6) |
| `.highway/tools/tests/fixtures/profile-092/impact-review.tsv` | Row 6 is the library index | Delete row 6 (R6) |
| `.highway/tools/tests/harness-path-map.test.sh` | `expect .highway/catalog/index.md none -` | Point the expectation at `.highway/catalog/index.json` (R7) |
| `harness/selection/shared.txt` | The three library READMEs | Delete the three `none` rows (R7) |
| `.specify/memory/constitution.md` | `generate-library-catalog.sh` in the declared generators; the timestamp exception in D4.2, D4.7, and their Enforcement Map notes | Amend, MAJOR (R8) |
| Four test files | Removed tools | Delete (R9) |

`.highway/tools/tests/fixtures/profile/generated-value.yaml` has a `generated_at:` key, but it is a
Profile fixture value, not the skill catalog field. It stays.

The historical Sync Impact Reports at the top of the development constitution name
`generate-library-catalog.sh` and the timestamp. They record past amendments and stay unchanged.

- **Decision**: change exactly the rows above.
- **Rationale**: the search is the acceptance test for FR-002, FR-007, FR-008, and SC-001.
- **Alternatives considered**: a narrower search per user story. Rejected because a shared
  file (the tools README, the constitution) carries references for more than one story.

## R2. Removal order

- **Decision**: do the catalog changes (US2) and the library index removal (US1) before the
  README removals (US3), because `generate-catalog.sh` and `generate-library-catalog.sh` both
  link to `catalog/README.md`. The one-off tooling removal (US4) is independent.
- **Rationale**: removing the catalog README first would leave a generated `index.md` that links
  to a missing file.
- **Alternatives considered**: removal in spec order. Works too, but leaves a broken link between
  steps.

## R3. Catalog generator output and its test

`generate-catalog.sh` writes `index.json` with `generated_at`, `entries`, and `overlap_flags`, and
writes `index.md`. Its test checks the three keys, checks that `index.md` exists, and compares two
runs after removing the `generated_at` line.

- **Decision**: the generator writes `{"entries": [...]}` to `index.json` and nothing else. The
  test first changes to assert: `entries` present; no `generated_at` and no `overlap_flags`;
  `index.md` absent after a run; two runs identical byte for byte with no filtering. The test is
  observed failing against the current generator before the generator changes (D3.6). The empty
  form stays `"entries": []`.
- **Rationale**: FR-004 and FR-005. The stricter test is the D3.3 test change for this behavior,
  and the change strengthens the test rather than weakening it (D3.5).
- **Alternatives considered**: keeping an empty `overlap_flags: []` for schema stability. Rejected
  by the spec, and highway-help reads only `entries`.

The test's probe mode compares two seeded snapshots and is unaffected.

## R4. The manual overlap review

Step 4 of the authoring standard's manual overlap review tells the author to record residual
overlap in `overlap_flags`. The committed array is empty, so no recorded overlap is lost.

- **Decision**: delete step 4. Steps 1 to 3 stay: generate the catalog, compare descriptions, and
  consolidate or cross-reference by the constitution's threshold. P7.3 already decides what to do
  with overlap, and it does not need a record.
- **Rationale**: the field is removed, and an empty field has never been used.
- **Alternatives considered**: moving the record to another file. Rejected because the spec drops
  the field and no consumer reads it.

## R5. Timestamp handling in the correspondence and packaging tests

`adapter-coverage.test.sh` filters `generated_at` and `_Generated at:` lines before comparing the
committed catalogs with a fresh regeneration. `distribution-packaging.test.sh` normalizes the same
lines before comparing two packaging runs.

- **Decision**: remove `strip_timestamp` and compare `catalog/index.json` with `diff` directly.
  Remove `normalize_catalog_timestamps` and its calls. Remove the library generator from both
  regeneration blocks in `adapter-coverage.test.sh`, normal mode and probe mode.
- **Rationale**: no generator writes a timestamp after this change, so the filters hide nothing,
  and comparing raw bytes makes both tests stricter (D3.5).
- **Alternatives considered**: keeping the filters as harmless. Rejected because the amended D4.2
  and D4.7 allow no timestamp exception, and a filter would let one back in unseen.

## R6. The Feature 092 evidence fixtures

The `profile-092` fixtures record which generated files depended on the Profile change, and
`feature-092-correspondence.test.sh` checks that the inventory names each generator and that each
generated dependent exists.

- **Decision**: delete the library index rows from both fixtures, drop `index.md` from the
  catalog row, and drop `generate-library-catalog.sh` and `library-index.json` from the test's
  lists. Every other row and check stays.
- **Rationale**: the test checks that the named dependents exist, so a row for a removed file
  would fail it. The removed rows describe a dependency that no longer exists.
- **Alternatives considered**: keeping the fixture rows as history. Rejected, because the test
  would fail and FR-002 forbids the reference.

## R7. Harness selection and path map

`harness/selection/shared.txt` lists the three library READMEs as `none`.
`harness-path-map.test.sh` requires every shipped file under `.highway/library/`,
`.highway/governance/`, and `.highway/instructions/` to map to a skill or appear in `shared.txt`,
and its expectation list includes `.highway/catalog/index.md`.

- **Decision**: delete the three README rows from `shared.txt`. Change the `index.md` expectation
  to `.highway/catalog/index.json`, which `path-map.sh` still classifies as `none` under its
  "generated catalog" rule.
- **Rationale**: SC-006 requires every listed path to exist, and the test keeps covering the
  catalog rule.
- **Alternatives considered**: deleting the expectation. Rejected because it would leave the
  catalog rule untested (D3.5).

## R8. Development constitution amendment

- **Decision**: amend `.specify/memory/constitution.md` from 2.3.0 to 3.0.0 (MAJOR), dated
  2026-11-11:
  - D4.2 Observable: "Two consecutive runs differ in no byte."
  - D4.7 Observable: "Re-running every declared generator leaves no diff against the committed
    artifacts."
  - Enforcement Map, D4.2 note: asserts re-running with unchanged inputs produces byte-identical
    output.
  - Enforcement Map, D4.7 note: drops "excepting the recorded generation timestamp on generators
    that write one".
  - Declared generators: drop `generate-library-catalog.sh`; replace the note that
    `generate-instructions.sh` writes no timestamp with a note that no declared generator writes
    one.
  - A new Sync Impact Report at the top lists each changed element and the self-application
    review against D1.3, D1.4, and D5.3.
- **Rationale**: FR-003 and the clarification session. Removing an exception strengthens an
  obligation, which the Versioning Policy classes as MAJOR.
- **Alternatives considered**: MINOR with the exception kept. Rejected in clarification.

## R9. Removed tests and their assertions (FR-010, SC-007)

Each assertion in a removed test is either kept in a remaining test or recorded as superseded.
This table is the D3.5 record.

| Removed test | Assertion | Disposition |
|---|---|---|
| `generate-library-catalog.test.sh` | Every assertion | Superseded: the library index and its generator are removed |
| `objective-rename-contract.test.sh` | The audit and allowlist exist and the clean audit passes | Superseded: the Feature 028 rename is finished and the audit is removed |
| `objective-rename-contract.test.sh` | Allowlist policy: missing, absolute, traversal, duplicate, non-empty, and prohibited entries are rejected | Superseded: the allowlist is removed |
| `objective-rename-contract.test.sh` | A stale singular "objective" reference on a live surface is rejected | Superseded, per the clarification: the rename is finished, and Phases 6 to 11 rewrite or remove every path it scanned |
| `objective-rename-contract.test.sh` | The Feature 028 plan's manifest provenance and objective test path are checked | Superseded: both check a finished feature's record under `specs/` |
| `profile-migration.test.sh` | The clean migration audit passes, and a former-path probe is rejected and named | Superseded, per the clarification: the Profile path migration is finished, and later phases rewrite every path it scanned |
| `profile-migration.test.sh` | The canonical Profile template exists with `schema_version: 3.0.0` | Kept: `profile-markdown-contract.test.sh` line 18 asserts the same schema version on the same file |
| `seed-library-context.test.sh` | Copies the three root context files, keeps unrelated files, fails on a missing source, converges a conflicting destination | Superseded: the seeding script is removed, and its three source files do not exist |

## R10. Distribution manifest

`audit-profile-migration.sh`, `seed-library-context.sh`, and `generate-library-catalog.sh` ship
through the manifest's include patterns for `.highway/tools/`, so removing the files removes them
from the distribution with no manifest edit. `.objective-rename-allowlist` and
`audit-objective-rename.sh` have their own rows. Three more rows exclude `highway-identity.md`,
`highway-platform-objectives.md`, and `highway-vision.md` at the repository root. Those files do
not exist; they were the seeding script's sources, and nothing else names them.

- **Decision**: delete the two tool rows and the three root context-file rows. Keep
  `exclude .DS_Store`.
- **Rationale**: FR-011. A row for a removed file, or for a removed script's missing input, is a
  stale reference.
- **Alternatives considered**: keeping the three root rows as a guard. Rejected because no
  process creates those files any more.

## R11. `.DS_Store`

Three local files exist: `./.DS_Store`, `.highway/.DS_Store`, and `.highway/skills/.DS_Store`.
None is tracked, and `.gitignore` ignores the name.

- **Decision**: delete all three locally. No repository diff results.
- **Rationale**: FR-013. The root file is included because the Phase 4 text says to delete
  `.DS_Store` without limiting the location.
- **Alternatives considered**: none.

## R12. highway-help version

- **Decision**: 3.1.0 to 3.1.1, a patch. The line removed is guidance in "When not to use"; the
  Inputs, Outputs, and both modes are unchanged, and the mode outputs read only `entries`.
- **Rationale**: P7.7 reserves MAJOR for a breaking contract change; this is not one.
- **Alternatives considered**: MINOR. Rejected because no capability is added.
