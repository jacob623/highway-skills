# Phase 0 Research: Frontmatter Contract Hardening

All open questions the spec named as needing settlement before planning (numeric lower bound,
lexicon location, hyphenated-compound tokenization, rule-id resolution routing) were already
resolved during `/speckit-clarify` and are recorded in [spec.md](./spec.md)'s Clarifications
section. This document resolves the remaining *design* decisions `/speckit-plan` must make that
the spec deliberately left to implementation.

## Decision 1: Contract manifest format and location

**Decision**: `.highway/tools/.frontmatter-contract`, a dot-prefixed, TAB-delimited,
header-commented flat file with columns `scope`, `key`, `required`, `constraint`, read by a new
`lib/frontmatter-contract.sh`.

**Rationale**: The repository already has two working precedents for declaring a checked
vocabulary in a file the declared toolchain (no `jq`, no Python, per `D2.2`/`D2.4`) can parse:

1. `con_token_list()` in `lib/constitution.sh` — a markdown-heading-plus-blockquote list, split on
   commas. Fits a flat, unstructured word list.
2. `.distribution-manifest` / `.adapter-manifest` — TAB-delimited, header-commented data files with
   multiple named columns, read by dedicated loader functions (`dist_manifest_file()`).

The frontmatter contract needs *structured* data per entry — which scope (top-level vs.
`metadata.*`), whether it's required, and what constrains its value (an enum, a length range, a
semver pattern) — not a flat vocabulary. That rules out the blockquote pattern, which has no column
concept, and favors the manifest pattern, which already carries exactly this shape of data
successfully in production.

**Alternatives considered**:
- *JSON Schema* (the shape `specs/001-multi-agent-skill-suite/contracts/skill-frontmatter.schema.json`
  used historically). Rejected: no JSON parser is in the Declared Toolchain, and the historical file
  is unshipped and read by nothing today — recorded in the spec's Edge Cases as intentionally left
  alone rather than repeated.
- *Markdown table parsed with `awk -F'|'`.* Rejected: column alignment and cell whitespace make
  `|`-splitting fragile compared to TAB-delimiting, and no existing script in the repository parses
  a markdown table as structured data; every existing structured-data precedent uses TAB.

**Location rationale**: `.highway/tools/` is confirmed shipped —
`.highway/tools/.distribution-manifest` line 55 reads `include	.highway/tools	-`, so a new
dot-file there ships under that directory-level record with no manifest edit required (only
`tests/`, `generate-distribution.sh`, `lib/distribution.sh`, `.distribution-manifest` itself, and
two rename-audit-only files are excluded beneath it). This resolves the plan's open question of
whether `.highway/tools/` counts as "shipped": the Development Constitution's Definitions table
lists `.highway/skills/`, `.highway/library/`, `.highway/catalog/`, `.highway/governance/`, and the
generated adapter trees as illustrative examples of shipped artifacts, but `.distribution-manifest`
is the actual, authoritative declaration of what ships (that is the entire point of `D1.6`), and it
includes `.highway/tools/` explicitly.

## Decision 2: Lexicon file name and format

**Decision**: `.highway/library/knowledge/frontmatter-lexicon.txt` — one word per line, sorted,
deduplicated, no trailing blank line beyond the file's final newline.

**Rationale**: FR-012 dictates the shape (one word per line, sorted, duplicate-free). The `.txt`
extension, rather than `.md`, marks it as a data file rather than prose. `.highway/library/`'s
existing knowledge files are Markdown documents `validate-library.sh` checks for prose-shaped rule
content (Purpose statements, normative structure); a flat word list has none of that shape, and
giving it a `.md` extension would make it a false positive for those checks. The repository already
narrows scope for library files by *specific rule id* (`rc_library_exempt_ids` returns `P8.7 P6.4`)
rather than by inventing a new document type — the `.txt` extension is the same idea applied at the
file-type level, so the file never enters the Markdown-prose check path in the first place, rather
than needing new exemption logic added to `validate-library.sh`.

**Alternatives considered**:
- *`.md` with a fenced code block holding the word list.* Rejected: still triggers
  `validate-library.sh`'s prose checks on the surrounding document, which then need a Purpose
  section, When to Use, etc. for content that has none.
- *A new directory, e.g. `.highway/library/lexicons/`.* Rejected: the clarify session locked the
  directory to `.highway/library/knowledge/` specifically; introducing a sibling directory would
  contradict that answer.

## Decision 3: Key enumeration mechanism

**Decision**: Add `fm_list_keys()` (all top-level key names, in file order, including duplicates)
and `fm_list_metadata_keys()` (same, one level under `metadata:`) to `lib/frontmatter.sh`.

**Rationale**: `fm_get_nested()` already isolates the `metadata:` block using indentation as the
structural signal; `fm_list_keys`/`fm_list_metadata_keys` reuse that same indentation-based
approach to *enumerate* rather than *look up*, keeping one parsing technique for the whole file
instead of introducing a second one.

**Alternatives considered**:
- *Parse the whole frontmatter block with a single generalized recursive descent function.*
  Rejected: the file only ever has two levels (top-level, and one level under `metadata:`);
  generalizing to arbitrary nesting solves a problem this format doesn't have and no existing
  function in `frontmatter.sh` does this either.

## Decision 4: Duplicate-key detection semantics

**Decision**: Duplicate detection is a separate pass over `fm_list_keys()`'s output using
`sort | uniq -d`, reported by name. `fm_get()`'s existing `head -n1` (first-match) behavior is left
completely unchanged.

**Rationale**: Every existing caller of `fm_get()` depends on its current first-match resolution.
Changing `fm_get()` to detect or reject duplicates itself would risk changing behavior for callers
that have nothing to do with this feature. Detecting duplicates as an independent check over the
full key list, using `sort`/`uniq -d` (both Declared Toolchain), reports the duplicate by name per
FR-006 without touching `fm_get()`'s contract at all.

**Alternatives considered**:
- *Make `fm_get()` itself fail on a duplicate.* Rejected: broadens the blast radius of this
  feature's change to every existing caller instead of adding one new, narrowly scoped check.

## Decision 5: Test file boundary

**Decision**: Extend `validate-skill.test.sh` (closed-key-set, duplicate-key, length lower bound)
and `authoring-standard.test.sh` (manifest citation, `metadata.dependencies` row). Add one new
file, `frontmatter-lexicon.test.sh` (lexicon shape, spell-check, skill-id/rule-id resolution).

**Rationale**: The repository already splits `dependency-check.test.sh` out from
`validate-skill.test.sh` for a distinct check *category*, even though both run inside the same
`validate-skill.sh` orchestrator. The lexicon and identifier-resolution checks are a comparably
distinct category — a new kind of check (vocabulary membership and cross-reference resolution)
rather than a variation on existing field-shape checks — so the same precedent is followed. The
closed-key-set, duplicate-key, and length-bound checks are variations on checks
`validate-skill.test.sh` already covers (field shape and presence), so they extend that file rather
than fragmenting further.

**Alternatives considered**:
- *One new test file per new check.* Rejected: over-fragments the suite relative to the existing
  convention, which splits by check *category*, not by individual assertion.
- *Put everything in `validate-skill.test.sh`.* Rejected: would abandon the precedent that already
  exists (`dependency-check.test.sh`) for exactly this kind of distinct-category split.

## Decision 6: Seeded-defect fixture convention

**Decision**: New fixture directories under `.highway/tools/tests/fixtures/`, each holding a single
`SKILL.md` with one seeded defect, following the existing `invalid-skill-*` naming convention
(e.g. `invalid-skill-duplicate-key/`, `invalid-skill-undeclared-key/`,
`invalid-skill-short-description/`, `invalid-skill-unrecognized-word/`). `valid-skill/` remains the
positive-control fixture.

**Rationale**: `.highway/tools/tests/fixtures/` already contains this exact pattern for the
existing schema checks (`invalid-skill-long-description/`, `invalid-skill-missing-example/`,
`invalid-skill-missing-usage/`, `invalid-skill-missing-version/`, `invalid-skill-name-mismatch/`,
`invalid-skill-nondeterministic-criterion/`, `invalid-skill-relative-link/`,
`invalid_skill_bad_id/`). Following it means no new testing pattern is introduced, and it directly
satisfies FR-014's requirement that each new check be observed failing against a seeded fixture
before the fix, without touching any real, shipping skill.

**Alternatives considered**:
- *Mutate `highway-help/SKILL.md` (or another real skill) in place, then restore it.* Rejected:
  the repository already has a dedicated fixtures mechanism for exactly this purpose; mutating a
  real shipping skill risks an incomplete restoration and contradicts the established convention.
