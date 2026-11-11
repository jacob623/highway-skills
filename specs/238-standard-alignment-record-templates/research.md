# Research: Standard Alignment Record Templates in Their Skills

Each entry records a decision, why it was chosen, and what else was considered.

## R1. Where each template goes

**Decision**: each template moves, byte-identical, to the `assets/` of its only reader:

| Template | Skill |
| --- | --- |
| `codify-metadata.md`, `codify-plan.md`, `codify-record.md`, `codify-tasks.md` | highway-codify |
| `coding-standard.md` | highway-codify-config |
| `control-record.md` | highway-controls |
| `nfr-record.md` | highway-nfrs |
| `objective-record.md` | highway-objectives |
| `discovery-record.md` | highway-discovery |
| `request-record.md` | highway-request |
| `profile-record.md` | highway-profile |

Each file is compared with `cmp` against a copy taken before the move. Its frontmatter (`name`,
`description`, `metadata.version`) stays.

**Rationale**: a search of `skills/` shows each template is named only by the skill above. The Phase 2
resolutions in `standard-alignment.md` name the same owners. Keeping the file names means `hw_template`,
`harness/fixtures/templates.map`, and every scenario's `template` argument change location only.

**Alternatives considered**: renaming each asset after the record it shapes (`record.md`, `plan.md`).
That renames every reference and makes the codify names ambiguous.

## R2. Skill text

**Decision**: in each of the 8 skills, every `.highway/library/templates/output/<file>.md` becomes
`assets/<file>.md`. highway-profile drops two sentences: "Do not read, copy, or review
`.highway/library/knowledge/profile.md`." and "Do not write `.highway/library/knowledge/profile.md`."
It keeps "Create `library/knowledge/` when it is absent.", because highway-profile can run before setup.
Each skill takes one MINOR version.

**Rationale**: FR-002, FR-004, and FR-005. The sentences around each path already read correctly with
the new path.

**Alternatives considered**: none.

## R3. Paths helper and tests

**Decision**: the 11 `hw_template` arms point at `$HW_SKILLS/<skill>/assets/<file>.md`. Every test that
sets `OUTPUT="$HW_OUTPUT_TEMPLATES"` and joins a moved name uses `$(hw_template <name>)` instead. Where a
test joins only moved names, its `OUTPUT` line goes. `HW_OUTPUT_TEMPLATES` stays for the three shared
records.

Tests that assert a literal citation (`.highway/library/templates/output/<file>.md` in a skill) assert
`assets/<file>.md`. `output-template.test.sh` counts the skills still citing
`.highway/library/templates/output/`: highway-adr, highway-architecture, highway-implementation, and
highway-onboarding (4, was 12).

**Rationale**: D2.5 requires tests to get locations from the paths helper.

**Alternatives considered**: a `HW_ASSETS` variable per skill. `hw_template` already resolves by name.

## R4. The skill validator's asset check

**Decision**: `validate-skill.sh` checks each file in `<skill>/assets/` that has a `## File Frontmatter`,
`## Body`, or `## Catalog Structure` heading, the same test `harness/bin/template-check.sh` uses to tell a
template from a skeleton. For each, it runs `validate-library.sh --asset <file>`, which applies the
template checks exactly as for a file under `library/templates/`: `name` and `description` present, the
auto-tier rules, the template exemptions (P1.1, P1.3, P7.4, P7.5) and the library exemptions (P8.7, P6.4,
P2.6). `--asset` skips the containment and library-type checks, because the skill validator has already
decided which file to check, and a probe skill may sit in a temporary folder.

Each finding is reported on stderr as `ERROR: [<tag>] assets/<file>: <finding>` and makes the skill fail.
A failing rule's id joins the FAILED line. The CHECKED, N/A, DEFERRED, and UNCHECKED lines describe the
skill only, so a passing skill's verdict is unchanged.

All 14 complete templates pass the library validator today (checked by copying each under
`.highway/library/templates/` and validating it). highway-setup's 12 skeletons have none of the three
headings and are not checked.

**Rationale**: the clarifications choose the skill validator and complete templates only. Reusing the
library validator's checks keeps one implementation for Phase 11 to merge, instead of a second copy of
the rule loop.

**Alternatives considered**:

- Copying the rule loop into `validate-skill.sh`. Two copies of the exemption logic would drift.
- Moving the loop into a shared library now. That is Phase 11's merge, done early and wider than needed.
- Adding the asset results to CHECKED and N/A. That changes every verdict line for the 11 skills with
  templates, against D3.4, for no new information.

## R5. The validation cache

**Decision**: `vc_key` hashes the skill's `SKILL.md` and every file under its `assets/`, in sorted order.
`vc_environment_hash` adds `validate-library.sh`, which the asset check now runs.

**Rationale**: the environment hash covered `.highway/library/`, so a template edit used to invalidate
every record. Once a template lives in `assets/`, a key that hashes only `SKILL.md` would replay a passing
verdict after the template broke.

**Alternatives considered**: disabling the cache for skills with assets. That slows the most-validated
skills for no gain.

## R6. Exact skeleton checks

**Decision**: `tests/fixtures/catalog-seeding/skeletons/` holds a reference copy of each of the 12
skeletons. `catalog-seeding.test.sh` compares each skeleton with its copy using `diff`, and reports the
skeleton and the differing lines. It also requires the line `Mode: Local` in `storage.md`. A probe removes
one table column from a copy of a skeleton and confirms the comparison fails.

**Rationale**: a skeleton is all structure (frontmatter, heading, version line, table header, and for two
catalogs a sentence of prose), so the exact structure is the whole file. A reference copy states it in one
place per skeleton, and changing a skeleton on purpose means changing its copy too.

**Alternatives considered**:

- An expected signature (keys, headings, header rows) written into the test. More code, and it misses
  prose such as the coding-standards intro.
- Comparing with the `setup` stage fixture. Those files are copies of the skeletons and change with them,
  so the comparison would not catch an accidental edit made to both.

## R7. The new test

**Decision**: `tests/record-templates.test.sh` (static-document-contract and executed-behavior) checks:

1. each of the 11 templates is in its owner's `assets/`, and `hw_template` resolves to it;
2. `.highway/library/templates/output/` holds exactly `adr-record.md`, `architecture-record.md`, and
   `implementation-record.md`;
3. each owner names `assets/<file>.md`, and no skill names a moved template under
   `.highway/library/templates/`;
4. no skill names `.highway/library/knowledge/`;
5. the distribution manifest names no moved template;
6. the validator's asset check, on a copy of highway-request in a temporary folder: the copy passes; with
   `description` removed from `assets/request-record.md` it fails and names that file; highway-setup
   passes and its output names no skeleton;
7. the cache key changes when a file in a copy's `assets/` changes.

Probes 6 and 7 are the seeded failures for R4 and R5.

**Rationale**: FR-001 to FR-010 each need an observable check, and no existing test owns placement.

**Alternatives considered**: spreading the checks across `output-template.test.sh` and
`validation-cache.test.sh`. That test is already long and mixes features.

## R8. Harness

**Decision**: no scenario, fixture, or `templates.map` line changes: each names a template by file name,
resolved through `hw_template`. `harness/test/select.test.ts` selects with
`skills/highway-codify/assets/codify-plan.md`, which maps to highway-codify as part of the skill, and
expects the same three scenarios. `tests/harness-path-map.test.sh` expects that path, and its "no skill
names it" probe uses `adr-record.md`, which stays shared. `harness/README.md` shows the new path.

**Rationale**: `harness/bin/path-map.sh` maps a file under `skills/<id>/` to that skill, so selection is
unchanged.

**Alternatives considered**: none.

## R9. Distribution, generators, and documents

**Decision**: the manifest drops its rows for `objective-record.md`, `request-record.md`, and
`profile-record.md`; the moved templates ship inside `skills`, which is already included. The catalog and
adapters are regenerated twice. `profile-template-migration.test.sh` asserts that the manifest names no
`profile-record.md` under `.highway/` and that highway-profile has no guard. `framework/README.md`,
`framework/authoring-standard.md`, `README.md`, `harness/README.md`, and `standard-alignment.md` describe
the new arrangement; `standard-alignment.md` marks Phase 9 complete and notes that Phase 11's validator
step has started.

**Rationale**: FR-010, FR-013. `include .highway/library` already covers the three remaining records.

**Alternatives considered**: none.

## R10. Out of scope

- `tests/fixtures/profile-091/reference-participant/SKILL.md` names `.highway/library/knowledge/profile.md`.
  It is a test fixture, not a Highway skill, and no test reads it. It stays.
- The three shared record templates and onboarding's handoffs are Phase 10.
- Specs keep their historical paths.
