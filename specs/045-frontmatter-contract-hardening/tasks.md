# Tasks: Frontmatter Contract Hardening

**Input**: Design documents from `/specs/045-frontmatter-contract-hardening/`
**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md),
[data-model.md](./data-model.md),
[contracts/frontmatter-contract-shape.md](./contracts/frontmatter-contract-shape.md),
[quickstart.md](./quickstart.md)

**Tests**: Requested implicitly by the constitution's verification discipline (`D3.4`, `D3.6`) and
by spec.md FR-014/FR-015: every new check must be observed failing against a seeded fixture and
passing after byte-exact restoration before it is considered done. Test-file assertions are
therefore embedded inside each user story's own phase, immediately after the behavior they cover is
wired in, rather than deferred to Polish.

**Organization**: Tasks are grouped by user story from spec.md. US1 and US2 are both P1 — spec.md
states "both stories must land together for the contract to be meaningful" — but US1 is ordered
first because US2's closed-key-set check reads the same declared-contract loader US1 delivers
(research.md Decision 1). Foundational tasks write the manifest, lexicon, loaders, and fixtures as
inert data with no caller, so every intermediate commit keeps the suite green (plan.md
Implementation Phases, steps 2-4).

## Phase 1: Setup

- [X] T001 Record the `D3.1` baseline: run `bash .highway/tools/tests/run-all.sh`, log exit code
      and wall-clock runtime. Result: exit 0, 36 passed, 0 failed, ~191s.
- [X] T002 Re-run the 2026-09-11 mutation audit's 6 seeded defects against the current
      `validate-skill.sh` and log each verdict, confirming 3 pass incorrectly (undeclared key,
      duplicated `description:`, too-short `description:`) and 3 already fail correctly. Verified
      via temp copies of `highway-help` (directory name preserved to avoid an id-mismatch
      confound): all 3 gap mutations exit 0 (pass incorrectly) as expected.
- [X] T003 Re-measure the lexicon word set across the 8 existing skills' `description`, `usage`,
      and `agent_exceptions[].deviation` fields; confirm the count against the spec's 126-word,
      2026-09-11 measurement and record any drift. Result: 163 words once the 8 real skills' text
      is merged with the vocabulary of the 8 pre-existing test fixtures that run through
      `validate-skill.sh` (drift from the spec's estimate is expected and pre-flagged in
      research.md Risk 2).

**Checkpoint**: Baseline captured. Nothing has been edited yet.

## Phase 2: Foundational (blocking prerequisites)

**Purpose**: Get the declared contract, lexicon, loader libraries, and seeded-defect fixtures in
place as inert data with no caller, per plan.md's ordering constraint — an unread file cannot
change a verdict, so every step here keeps the suite green.

- [X] T004 Create `.highway/tools/.frontmatter-contract` with the exact grammar and 7-row initial
      content specified in
      [contracts/frontmatter-contract-shape.md](./contracts/frontmatter-contract-shape.md). No
      script reads it yet.
- [X] T005 [P] Create `.highway/library/knowledge/frontmatter-lexicon.txt`, seeded from T003's
      re-measured word list, one word per line, sorted, deduplicated. (163 words.)
- [X] T006 Verify lexicon shape: `sort -c .highway/library/knowledge/frontmatter-lexicon.txt`
      exits 0, and `sort .highway/library/knowledge/frontmatter-lexicon.txt | uniq -d` prints
      nothing. Confirmed both.
- [X] T007 [P] Add `fm_list_keys()` and `fm_list_metadata_keys()` to
      `.highway/tools/lib/frontmatter.sh`, reusing the indentation-based parsing
      `fm_get_nested()` already uses. No caller yet.
- [X] T008 [P] Create `.highway/tools/lib/frontmatter-contract.sh`: a loader that parses
      `.frontmatter-contract` and exposes accessors for the permitted key set, each key's
      required/optional status, and its constraint token; detects a malformed manifest (a
      duplicate `(scope, key)` row, or an invalid `required`/`constraint` token) and reports it as
      an error. No caller yet.
- [X] T009 [P] Create `.highway/tools/lib/frontmatter-lexicon.sh`: exposes lexicon-membership
      checking with hyphen-splitting for compound words (FR-009), and skill-id/rule-id resolution
      per FR-011 (skill id against `.highway/skills/`; rule id prefix-routed to
      `.highway/governance/constitution.md` or `.highway/governance/experience-standard.md`
      depending on which document contains the id). Deliberately does NOT consult
      `.specify/memory/constitution.md`: this file ships to users, and D1.1 forbids a shipped
      artifact from referencing a development-only path; a skill also has no legitimate reason to
      cite a development-process rule id. No caller yet.
- [X] T010 Add 4 new fixture directories under `.highway/tools/tests/fixtures/`, each a copy of an
      existing valid `SKILL.md` with exactly one seeded defect: `invalid-skill-duplicate-key/`,
      `invalid-skill-undeclared-key/`, `invalid-skill-short-description/`,
      `invalid-skill-unrecognized-word/`, per
      [contracts/frontmatter-contract-shape.md](./contracts/frontmatter-contract-shape.md)'s
      seeded-defect verification matrix.
- [X] T011 Confirm each of the 4 new fixtures currently passes `validate-skill.sh` incorrectly
      (exit 0) — the "observed gap" evidence required before any check is wired in. Confirmed:
      all 4 exit 0.
- [X] T012 Run `bash .highway/tools/tests/run-all.sh`; confirm exit 0. Nothing is wired in yet, so
      the suite must stay exactly as green as the T001 baseline. Confirmed: 36 passed, 0 failed.

**Checkpoint**: Manifest, lexicon, loaders, and fixtures exist; nothing reads them yet; suite is
unchanged. Every user story phase below can now proceed.

## Phase 3: User Story 1 - The frontmatter contract is declared once and the validator reads it (Priority: P1) 🎯 MVP

**Goal**: `lib/schema-validate.sh`'s checked key set and constraints trace to
`.frontmatter-contract`, a malformed declaration is reported as an error, and adding a required key
to the manifest alone breaks a previously-conforming skill.

**Independent Test**: Add a new required key to `.frontmatter-contract` with no script change, run
`validate-skill.sh` against an existing conforming skill, and confirm it now fails naming the
absent key.

- [X] T013 [US1] In `.highway/tools/lib/schema-validate.sh`, source the permitted key set,
      required/optional status, and constraints (`SV_VALID_AGENTS`, `SV_VALID_COMPATIBILITY`,
      length bounds) from `frontmatter-contract.sh` instead of the script's own constants (FR-002).
      Implemented via `fc_constraint()` lookups at call time; the valid-agents list is derived
      from the `compatibility` enum minus the literal `all` token (single declared source, no
      separate manifest row needed). Also added `sv_validate_required_keys()`, a generic
      safety-net loop over every required manifest key with no bespoke presence check of its own,
      which is what makes T018 possible without a script change.
- [X] T014 [US1] Remove the now-redundant hardcoded constants from
      `.highway/tools/lib/schema-validate.sh` once nothing reads them (SC-002). Removed
      `SV_VALID_AGENTS` and `SV_VALID_COMPATIBILITY`; `SV_ID_REGEX`/`SV_VERSION_REGEX` are kept
      (out of this feature's declared scope; `SV_VERSION_REGEX` remains unused/vestigial as
      before, `SV_ID_REGEX` still drives `sv_validate_id`).
- [X] T015 [US1] In `.highway/tools/validate-skill.sh`, call `frontmatter-contract.sh`'s
      malformed-manifest detection at startup so a duplicate `(scope, key)` row or an invalid
      `required`/`constraint` token in `.frontmatter-contract` causes an error before any
      per-skill check runs (FR-003).
- [X] T016 [US1] [P] In `.highway/tools/tests/validate-skill.test.sh`, add an assertion that
      seeds a malformed manifest (a duplicate row appended to a temporary copy of
      `.frontmatter-contract`), confirms it is reported as an error, then restores the manifest
      byte-exact. Implemented via the `FRONTMATTER_CONTRACT_FILE` env override (points at a
      throwaway temp-file copy), so the real manifest is never touched at all rather than
      touched-then-reverted.
- [X] T017 [US1] Run the full suite and re-validate all 8 existing skills; confirm all 8 still
      pass unchanged (`D3.4`). Confirmed: suite 36/36 passed; all 8 real skills exit 0.
- [X] T018 [US1] Required-key acceptance proof (FR-016, SC-004): temporarily append one new
      required-key row to `.frontmatter-contract`, re-validate all 8 skills, confirm at least one
      now fails naming the new key, then revert the manifest to its 7-row content
      (`git checkout -- .highway/tools/.frontmatter-contract`). Record the observed failing
      skill(s) as the proof. Implemented via the `FRONTMATTER_CONTRACT_FILE` env override with a
      temp-file copy carrying an added `top owner yes -` row: all 8 real skills failed, each
      naming `ERROR: [SCHEMA] missing required field 'owner'`; the real manifest file was never
      written to, so no revert was needed.

**Checkpoint**: The contract is declared once and is load-bearing — this alone is independently
valuable and independently verifiable.

## Phase 4: User Story 2 - An undeclared or duplicated key is reported by name (Priority: P1)

**Goal**: Every top-level and `metadata` key present in a skill's frontmatter is checked against
the closed permitted set; an undeclared or duplicated key is reported by name.

**Independent Test**: Add an undeclared top-level key to a copy of a valid `SKILL.md`, and
separately duplicate `description:` in another copy; confirm both are reported by name, then
confirm both restore to passing byte-exact.

- [X] T019 [US2] Wire the closed-key-set check into `.highway/tools/lib/schema-validate.sh`/
      `validate-skill.sh`: every key `fm_list_keys()`/`fm_list_metadata_keys()` finds in a skill's
      frontmatter must appear in `.frontmatter-contract`; an undeclared key is reported by name
      (FR-005). Implemented `sv_validate_closed_key_set(file, highway_root)`: top-level keys are
      checked against `fc_declared_keys(top)` with `metadata` implicitly permitted (it is the
      container, not itself a manifest row); metadata-scope keys are checked against
      `fc_declared_keys(metadata)`. Undeclared keys reported as
      `ERROR: [SCHEMA] undeclared top-level key '<k>'` / `'metadata.<k>'`.
- [X] T020 [US2] Wire the duplicate-key check as an independent pass over
      `fm_list_keys()`/`fm_list_metadata_keys()`'s output using `sort | uniq -d`, reported by
      name regardless of `fm_get()`'s existing first-match resolution, which is left unchanged
      (FR-006, research.md Decision 4). Implemented `sv_validate_duplicate_keys(file)` using raw
      (non-deduplicated) key-list output; reports
      `ERROR: [SCHEMA] duplicate top-level key '<k>'` / `'metadata.<k>'`. Both wired into
      `validate-skill.sh` after `sv_validate_required_keys`. Fixed a pre-existing fixture
      (`invalid-skill-missing-version`) that used an undeclared `metadata.license` key to omit
      version, which now also (correctly) failed the new closed-key-set check; changed it to
      `metadata: {}` so it isolates the one intended P7.2 failure.
- [X] T021 [US2] [P] In `.highway/tools/tests/validate-skill.test.sh`, add assertions against
      `invalid-skill-undeclared-key/` and `invalid-skill-duplicate-key/`: each is reported by
      name, and each fixture is confirmed unaffected (still fails) after a no-op re-run. Added
      `assert_exit_nonzero_naming` (naming `licence`/`description` exactly) plus
      `assert_single_failure` (tagged `SCHEMA`, exactly 1 finding) for both fixtures, plus a
      repeated `assert_exit_nonzero_naming` re-run confirming identical failure on a second pass.
- [X] T022 [US2] Run the full suite and re-validate all 8 existing skills; confirm all 8 still
      pass. A failure here is a real, previously-undetected defect to report and fix, not to
      suppress by widening the manifest (FR-017). Confirmed: suite 36/36 passed; all 8 real
      skills exit 0.

**Checkpoint**: The closed key set and duplicate-key detection are enforced — combined with US1,
the contract is now meaningful per spec.md's stated equal-priority pairing.

## Phase 5: User Story 3 - `description`/`usage` carry a lower bound, and `metadata.dependencies` is declared (Priority: P2)

**Goal**: `description` and `usage` are rejected when shorter than 10 characters as well as when
too long, and `_authoring-standard.md` has a Required frontmatter table row for
`metadata.dependencies`.

**Independent Test**: Set `description: "x"` in a copy of a valid `SKILL.md` and confirm rejection
naming the lower bound; confirm `_authoring-standard.md`'s table has the new row.

- [X] T023 [US3] In `.highway/tools/lib/schema-validate.sh`, extend `sv_validate_description()`
      and `sv_validate_usage()` to check both bounds of the `length:10-500` constraint read from
      `.frontmatter-contract`, reporting which bound (lower or upper) was violated (FR-007).
      Already implemented as part of T013's rewrite this session (`_sv_parse_length_constraint`
      + explicit min/max checks in both functions); confirmed via the
      `invalid-skill-short-description` fixture (`ERROR: [SCHEMA] field 'description' is shorter
      than the minimum 10 characters (got 1)`, exactly 1 finding).
- [X] T024 [US3] [P] In `.highway/tools/tests/validate-skill.test.sh`, add an assertion against
      `invalid-skill-short-description/` confirming lower-bound rejection, and an assertion
      confirming the existing upper-bound behavior is unchanged. Added
      `assert_exit_nonzero_naming` for both short ("shorter than the minimum") and long
      ("exceeds") description fixtures, plus `assert_single_failure ... SCHEMA` for the short one.
- [X] T025 [US3] In `.highway/skills/_authoring-standard.md`'s Required frontmatter table, add a
      row for `metadata.dependencies` naming the constraint `dc_validate_dependencies` already
      enforces, and cite `.highway/tools/.frontmatter-contract` and
      `contracts/frontmatter-contract-shape.md` per `P7.3` (FR-004, FR-008). Added the table row
      (tagged `DEPENDENCY`) plus a sentence citing `.frontmatter-contract` and
      `contracts/frontmatter-contract-shape.md`.
- [X] T026 [US3] [P] In `.highway/tools/tests/authoring-standard.test.sh`, add an assertion that
      the new row and citation exist. Added two `grep -qF` checks for
      `` `metadata.dependencies` `` and `.frontmatter-contract`.
- [X] T027 [US3] Run the full suite and re-validate all 8 existing skills; confirm all 8 still
      pass (the spec's Validated Outcomes already confirmed all 8 skills are comfortably above 10
      characters; minimum observed 79 in `highway-nfrs`'s `usage`). Confirmed: suite 36/36
      passed; all 8 real skills exit 0.

**Checkpoint**: Length bounds and dependency declaration match what is actually enforced.

## Phase 6: User Story 4 - Free-form frontmatter values are checked against a maintained lexicon (Priority: P2)

**Goal**: Every word in `description`, `usage`, and each `agent_exceptions[].deviation` is checked
against the lexicon or resolved as a skill id or rule id; each unrecognized word is reported
individually.

**Independent Test**: Add a nonexistent skill id (e.g. `highway-nfrz`) to a copy of a valid
`SKILL.md`'s `description`, confirm it is reported individually as unresolved, and confirm all 126
re-measured words are accepted with zero false positives.

- [X] T028 [US4] Wire `frontmatter-lexicon.sh` into `validate-skill.sh` for `description`,
      `usage`, and each `agent_exceptions[].deviation`: tokenize on whitespace, split hyphenated
      compounds on hyphens, and check each part against the lexicon (FR-009). Wired via
      `fl_check_field`, called for `description`/`usage` only when that field's own
      length/presence check produced zero errors (skip-on-length-failure, avoiding double
      findings on one nonsense field), and for each `agent_exceptions[].deviation` entry
      unconditionally.
- [X] T029 [US4] Wire skill-id resolution (accepted only if `.highway/skills/<token>` exists) and
      prefix-routed rule-id resolution (`D`/`P`/`X`) as acceptance paths evaluated before lexicon
      membership (FR-011). Already implemented inside `fl_check_field` itself (built in Phase 2);
      confirmed `D`-prefixed tokens are deliberately never resolved (D1.1: the dev constitution
      is never consulted by shipped code), so a `D`-prefixed token falls through to ordinary
      lexicon word-checking like any other unrecognized token.
- [X] T030 [US4] Wire individual-word reporting: every unrecognized word is reported by name
      together with the field it came from; a count alone is never substituted (FR-010). Already
      implemented inside `fl_check_field` (one `ERROR: [SCHEMA] field '<label>' contains
      unrecognized word '<word>'` line per word). Discovered and fixed one pre-existing false
      positive this required surfacing: `.highway/tools/tests/rule-checks.test.sh`'s shared base
      fixture used 9 words not yet in the lexicon (`checks`, `conforming`, `each`, `exactly`,
      `mutates`, `rule`, `seed`, `sh`, `violation`); added all 9 (172 words total, re-verified
      sorted with no duplicates).
- [X] T031 [US4] Create `.highway/tools/tests/frontmatter-lexicon.test.sh` with: a lexicon-shape
      assertion (one word per line, sorted, no duplicates — FR-012); an assertion against
      `invalid-skill-unrecognized-word/` confirming individual reporting; one skill-id resolution
      case; one `D`-, one `P`-, and one `X`-prefixed rule-id resolution case each. Created (new
      test file, suite count 36→37). The `D`-prefixed case asserts non-resolution (per D1.1, this
      is the expected/correct outcome, not a gap). Fixed one self-inflicted violation of D1.1
      found while writing it: an explanatory comment literally quoted the dev-only path
      `.specify/memory/constitution.md`, which `shipped-tree-independence.test.sh` correctly
      flagged; reworded to describe the constraint without the literal path.
- [X] T032 [US4] Run the full suite and re-validate all 8 existing skills' free-form fields
      against the re-measured lexicon; confirm zero false-positive rejections (SC-003). Confirmed:
      suite 37/37 passed; all 8 real skills exit 0.

**Checkpoint**: All four user stories are independently delivered and independently verifiable.

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T033 Re-run all 6 of the original 2026-09-11 seeded mutations end to end against the
      finished validator; confirm all 6 are now caught, up from 3 of 6 (SC-001). Re-seeded all 6
      defect types (undeclared key, duplicated `description:`, too-short `description:`, missing
      `metadata.version`, oversized `description:`, unrecognized word) against temp copies of
      `highway-help`; every one now fails, each naming the specific offending field/key.
- [X] T034 Confirm `UNCHECKED` is empty for all 8 skills (SC-006, FR-018). Confirmed: `UNCHECKED:`
      (empty) for all 8 real skills.
- [X] T035 Run `bash .highway/tools/tests/run-all.sh` a final time; record exit code and runtime
      against the 240 second interim ceiling (SC-005), and confirm the test file count grew only
      by the 1 new file added in T031. Result: exit 0, 37/37 passed (36→37, +1 file as expected).
      Runtime measured at ~276-283s across two runs (up from the 191s Phase-1 baseline), which
      exceeds the 240s interim ceiling; recorded honestly per SC-005's "reported against" wording
      (governance-plan.md's own Phase 041/042 history already records prior runs breaching this
      same interim ceiling) rather than suppressed. Cause: the per-word lexicon/identifier-
      resolution subprocess overhead (`fl_check_field`) multiplied across every `validate-skill.sh`
      invocation in the suite. Flagged as a follow-up candidate for a future runtime-recovery
      phase (in the spirit of Phase 14), out of this feature's scope to fix now.
- [X] T036 Confirm no constitution rule was added, removed, or retagged in this feature; every
      check it adds remains tagged `[SCHEMA]` (FR-019). Confirmed via `git diff --stat` against
      both `.highway/governance/constitution.md` and `.highway/governance/experience-standard.md`:
      zero changes. Every new check added this feature (`sv_validate_required_keys`,
      `sv_validate_closed_key_set`, `sv_validate_duplicate_keys`, the length lower bound, and the
      lexicon check) prints `ERROR: [SCHEMA] ...`.
- [X] T037 [P] Update `governance-plan.md`'s Status line: move `17` from the Active list to the
      completed-phases list, and remove Phase 17's detail section, per the document's own stated
      convention for completed phases. Updated the top Status/Last-reviewed lines, the §3 phase
      overview list and table (17 moved out of Active, feature 045 added to the completed-features
      list), and deleted the entire "### Phase 17" detail section per the same convention already
      applied to Phases 1–6, 10 and 11.

**Checkpoint**: Feature complete. All success criteria (SC-001 through SC-006) verified.

## Dependencies

- **Setup (Phase 1)** has no dependencies.
- **Foundational (Phase 2)** depends on Setup and blocks every user story phase — the manifest,
  lexicon, loaders, and fixtures must exist before any story wires behavior against them.
- **User Story 1 (Phase 3)** depends only on Foundational. Delivers the MVP: a declared,
  load-bearing contract.
- **User Story 2 (Phase 4)** depends on Foundational and on User Story 1's
  `frontmatter-contract.sh` loader existing with a working accessor for the permitted key set
  (T013). It does not depend on US1's malformed-manifest or required-key-proof tasks (T015, T018).
- **User Story 3 (Phase 5)** depends on Foundational and on User Story 1's constraint-token
  accessor (T013). Independent of US2.
- **User Story 4 (Phase 6)** depends on Foundational only (`frontmatter-lexicon.sh` from T009).
  Independent of US1, US2, and US3.
- **Polish (Phase 7)** depends on all four user story phases being complete.

## Parallel Execution Examples

Within Foundational, these have no dependency on each other and can run in parallel:

```text
T005 (lexicon file)
T007 (fm_list_keys/fm_list_metadata_keys)
T008 (frontmatter-contract.sh loader)
T009 (frontmatter-lexicon.sh loader)
```

Once Foundational (T004-T012) is complete, User Stories 3 and 4 have no dependency on each other or
on User Story 2, and can proceed in parallel with each other (both still depend on US1's T013):

```text
Phase 5 (US3): T023-T027
Phase 6 (US4): T028-T032
```

Within each story phase, the new test-file assertion task is marked `[P]` where it touches a
different file than the implementation task immediately before it (e.g. T016, T021, T024, T026).

## Implementation Strategy

**MVP first**: Complete Phase 1 (Setup) and Phase 2 (Foundational), then Phase 3 (User Story 1)
alone. This delivers a declared, load-bearing contract with no closed key set yet — independently
valuable and independently testable per spec.md's own US1 acceptance scenario, and it is the
dependency every other story needs.

**Incremental delivery after MVP**: User Story 2 next (equal P1 priority, spec.md's stated
"damaging case"), then User Stories 3 and 4 in either order or in parallel — neither depends on the
other, and both depend only on Foundational plus User Story 1's constraint-token/lexicon-loader
existing.
