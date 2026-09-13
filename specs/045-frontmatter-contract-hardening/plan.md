# Implementation Plan: Frontmatter Contract Hardening

**Branch**: `045-frontmatter-contract-hardening` | **Date**: 2026-09-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/045-frontmatter-contract-hardening/spec.md`

## Summary

Declare the `SKILL.md` frontmatter contract — every permitted top-level and `metadata` key, its
required/optional status, and its value constraint, including `metadata.dependencies` — in one
new shipped manifest, `.highway/tools/.frontmatter-contract`, modeled on the existing
`.distribution-manifest` and `.adapter-manifest` precedent: a TAB-delimited, header-commented data
file the declared toolchain can parse with `awk`/`cut`/`grep`, with no new runtime dependency.
`lib/schema-validate.sh` is rewritten to derive its checks from that manifest instead of its own
hardcoded constants, closing the permitted key set so an undeclared or duplicate key is reported by
name, adding a 10-character lower bound to `description` and `usage`, and adding a maintained
lexicon at `.highway/library/knowledge/frontmatter-lexicon.txt` that free-form values are checked
against, with skill ids and rule ids accepted by resolution instead of lexicon membership.

The technical approach is **externalize, then enforce**: every constant this feature touches
already exists as validator behavior today (three of six seeded mutations already fail correctly);
the work is moving the *declaration* of that behavior into a file the validator reads, closing the
one gap declaration alone cannot close (the permitted key set was never enumerated at all), and
adding the two genuinely new checks (length lower bound, lexicon). Verification is seeded-defect
fixtures per rule, mirroring the existing `fixtures/invalid-skill-*` convention, not live mutation
of a shipping skill.

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS default), per `D2.1`

**Primary Dependencies**: None added. Declared Toolchain only (`awk`, `cut`, `grep`, `sed`, `sort`,
`tr`, `uniq`), per `D2.2` and `D2.4`

**Storage**: Files. New: `.highway/tools/.frontmatter-contract` (contract manifest),
`.highway/library/knowledge/frontmatter-lexicon.txt` (lexicon). Amended:
`.highway/tools/lib/schema-validate.sh`, `.highway/tools/lib/frontmatter.sh`,
`.highway/tools/validate-skill.sh`, `.highway/skills/_authoring-standard.md`

**Testing**: `.highway/tools/tests/run-all.sh`. Extends `validate-skill.test.sh` and
`authoring-standard.test.sh`; adds one new file, `frontmatter-lexicon.test.sh`. New fixture
directories under `.highway/tools/tests/fixtures/`, following the existing `invalid-skill-*`
naming convention

**Target Platform**: macOS and Linux, per `D2.3`

**Project Type**: Governance/tooling repository. Layer 1 (Authoring) — every check added is tagged
`[SCHEMA]`; no constitution rule is added, removed, or retagged

**Performance Goals**: None stated. `run-all.sh` must stay within the 240 second interim ceiling
Feature 042 set (SC-005)

**Constraints**: The suite passes before the first edit and after the last (`D3.1`, `D3.2`). Every
new check is evaluated against all 8 existing skills and every existing fixture before being
enabled (`D3.4`, FR-015). No existing skill's frontmatter is edited to make a check pass (FR-017).
`UNCHECKED` stays empty for every skill (FR-018)

**Scale/Scope**: 1 new manifest, 1 new lexicon file (seeded from 126 measured words), 2 new library
functions (`fm_list_keys`, `fm_list_metadata_keys`), 1 new library file
(`lib/frontmatter-contract.sh` or equivalent loader), 3 test files touched (2 amended, 1 new), 8
existing skills re-validated against the closed key set with zero expected regressions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

### Layer 0 — Highway Development Constitution

| Gate | Trigger evaluates | Rules evaluated |
|---|---|---|
| Packaging Gate | True — `.highway/tools/.frontmatter-contract` and `.highway/library/knowledge/frontmatter-lexicon.txt` are shipped paths per `.distribution-manifest`'s `include .highway/tools -` and `include .highway/library -` records | D1.1, D1.2, D6.2 |
| Toolchain Gate | True — `.highway/tools/lib/*.sh` and `.highway/tools/validate-skill.sh` are edited | D2.1–D2.4 |
| Generator Gate | False — no `generate-*.sh` script is touched | N/A (N1) |
| Correspondence Gate | False — no skill directory is added, removed, or modified, and no declared generator input changes | N/A (N1) |
| Validation Gate | True — new validation checks are added | D3.4, D3.5 |
| Skill Content Gate | True — `.highway/skills/_authoring-standard.md` and the new lexicon file under `.highway/library/knowledge/` are touched | Delegated to Highway Skills Constitution per `D1.5`, see below |

| Rule | Tier | Verdict | Basis |
|---|---|---|---|
| D1.1 | [auto] | PASS | Neither new file nor any edited file introduces `.specify/` or `specs/` |
| D1.2 | [auto] | **Gate** | `validate-skill.sh` must exit 0 against a copy of the tree with `.specify/` and `specs/` removed, run after the final edit |
| D1.3 | [agent-checkable] | PASS | This plan cites rule ids and restates no rule sentence |
| D1.4 | [agent-checkable] | PASS | Same |
| D1.5 | [agent-checkable] | **Gate** | See Layer 1 Constitution Check below |
| D1.6 | [agent-checkable] | N/A (N4) | No distributed path set changes; the new files are absorbed by existing directory-level `include` records |
| D2.1 | [agent-checkable] | **Gate** | Every edited script must avoid associative arrays, `mapfile`, `readarray`, `${var^^}`, `&>>` |
| D2.2 | [agent-checkable] | **Gate** | The contract manifest and lexicon are parsed with `awk`, `cut`, `grep`, `sed`, `sort`, `tr`, `uniq` only — all declared |
| D2.3 | [agent-checkable] | PASS | No new utility flag is introduced beyond what the toolchain already uses |
| D2.4 | [agent-checkable] | **Gate** | No package manager, interpreter, or binary outside the declared toolchain is introduced — in particular, no `jq` |
| D3.1 | [agent-checkable] | **Gate** | Suite must exit 0 before the first edit |
| D3.2 | [agent-checkable] | **Gate** | Suite must exit 0 after the final edit |
| D3.3 | [agent-checkable] | **Gate** | `validate-skill.test.sh` and `authoring-standard.test.sh` are amended; `frontmatter-lexicon.test.sh` is added |
| D3.4 | [agent-checkable] | **Gate** | Every new check evaluated against all 8 skills and every existing fixture before being wired into `validate-skill.sh`'s call path |
| D3.5 | **[human-review]** | PASS, pending review | No existing assertion is removed or loosened; only new assertions and one bound (500-char upper) gains a paired lower bound |
| D3.6 | [agent-checkable] | **Gate** | Each new check is observed failing against its seeded fixture before the implementation that makes it pass |
| D3.7 | [auto] | N/A (N4) | This rule governs `[auto]` rules in *this document's own* Enforcement Map; the checks this feature adds are Layer 1 `[SCHEMA]` checks, not Layer 0 rules |
| D3.8 | [agent-checkable] | N/A | No static document-contract test is recorded as behavioral evidence; every new fixture is exercised through `validate-skill.sh`'s actual exit code |
| D4.1–D4.7 | mixed | N/A (N1) | No generator, generated artifact, or generator input is touched |
| D6.1 | [agent-checkable] | **Gate** | `_authoring-standard.md` and `.highway/tools/README.md` (if it describes `schema-validate.sh`'s behavior) must be updated in this change |
| D6.2 | [agent-checkable] | **Gate** | Every new cross-reference (standard → manifest, manifest → lexicon) must resolve inside the packaged tree |
| D8.1 | [agent-checkable] | N/A | No shared *output* template (the `P9.1` citation mechanism) is changed; the contract manifest is a validator input, not a cited output template |

**Gates carried forward to verification, not Complexity Tracking**: none of the above are
violations requiring justification. Every `**Gate**` row above is a condition this plan's tasks
must satisfy and record evidence for in `research.md`, not an exception to argue for.

### Layer 1 — Highway Skills Constitution (per `D1.5`)

Triggered because this feature edits `.highway/skills/_authoring-standard.md` and creates
`.highway/library/knowledge/frontmatter-lexicon.txt`. Neither is a `SKILL.md`: both are reference
documents the constitution's own precedent already treats as partially exempt (compare
`rc_library_exempt_ids`, which excuses library files from `P8.7` and `P6.4`).

| Rule | Verdict | Basis |
|---|---|---|
| P1.1–P1.7 | N/A (N2) | These govern a skill's normative rule lines; `_authoring-standard.md` and the lexicon contain no normative rule lines of their own — they cite rule ids |
| P2.1–P2.5 | N/A (N2) | Same; no skill-shape technology rule applies to a reference document or a word list |
| P3.1–P3.5 | N/A (N2) | Neither document makes a MUST-level claim requiring an Approved Authority Source citation |
| P4.1–P4.6 | N/A (N2) | No quality claim is stated in either document |
| P5.1–P5.6 | N/A (N2) | Neither document is a workflow with steps and failure paths |
| P6.1–P6.6 | N/A (N2) | Neither document states a decision criterion |
| P7.1 | N/A (N4) | Neither artifact is a skill; `_authoring-standard.md` predates and is exempt by type, the lexicon is a data file |
| P7.2 | N/A (N4) | Neither artifact carries `metadata.version` |
| P7.3 | **Gate** | `_authoring-standard.md` MUST cite `.highway/tools/.frontmatter-contract` and restate none of its content |
| P7.4–P7.6 | N/A (N4) | Rule-count and word-count ceilings apply to a `SKILL.md`'s normative sections; neither artifact has one |
| P7.7 | N/A (N4) | Neither artifact has a skill contract to version |
| P8.1–P8.6 | N/A (N2/N4) | Neither document is a numbered workflow |
| P8.7 | **Gate** | Neither document introduces a relative-path Markdown link |
| P9.1 | N/A (N4) | Neither artifact emits a file on a user's behalf |

## Project Structure

### Documentation (this feature)

```text
specs/045-frontmatter-contract-hardening/
├── plan.md                              # This file
├── research.md                          # Phase 0 output
├── data-model.md                        # Phase 1 output
├── quickstart.md                        # Phase 1 output
├── contracts/
│   └── frontmatter-contract-shape.md    # Phase 1 output: the exact manifest grammar and initial content
└── tasks.md                             # Phase 2 output (/speckit-tasks — not created here)
```

### Source Code (repository root)

```text
.highway/tools/
├── .frontmatter-contract                # NEW — declared permitted keys, required flag, constraint token
├── lib/
│   ├── schema-validate.sh                # AMENDED — reads bounds/enums from the contract manifest;
│   │                                      #   gains closed-key-set, duplicate-key, and lower-bound checks
│   ├── frontmatter.sh                    # AMENDED — adds fm_list_keys, fm_list_metadata_keys
│   ├── frontmatter-contract.sh           # NEW — loads and queries .frontmatter-contract
│   └── frontmatter-lexicon.sh            # NEW — lexicon membership + skill-id/rule-id resolution
├── validate-skill.sh                     # AMENDED — wires in the new checks after existing field validators
└── tests/
    ├── validate-skill.test.sh            # AMENDED — new mutation cases
    ├── authoring-standard.test.sh        # AMENDED — asserts the new table row and the citation
    ├── frontmatter-lexicon.test.sh       # NEW — lexicon shape + spell-check + identifier resolution
    └── fixtures/
        ├── invalid-skill-duplicate-key/          # NEW
        ├── invalid-skill-undeclared-key/         # NEW
        ├── invalid-skill-short-description/      # NEW
        └── invalid-skill-unrecognized-word/      # NEW

.highway/library/knowledge/
└── frontmatter-lexicon.txt               # NEW — sorted, deduplicated, one word per line

.highway/skills/_authoring-standard.md    # AMENDED — cites the manifest; adds metadata.dependencies row;
                                           #   states the 10-character lower bound
```

**Structure Decision**: All new files live under existing directories that already ship
(`.highway/tools/`, `.highway/library/knowledge/`). No new top-level directory is created. Test
fixtures follow the established `invalid-skill-*` naming convention rather than mutating a real
skill in place.

## Complexity Tracking

*No violations.* Every Layer 0 and Layer 1 gate above resolves to PASS or a task-level obligation
this feature's own tasks discharge; none requires an argued exception. This table is intentionally
empty.

## Implementation Phases

### Order is a correctness constraint, not a preference

1. **Record the baseline.** Suite exit code and runtime, and the exact verdict of all 6 original
   seeded mutations against the current validator, before any edit. Required by `D3.1` and to give
   SC-001 a documented "before".
2. **Write the contract manifest and lexicon as data**, with no script yet reading either. This
   keeps every intermediate commit's suite green: an unread file cannot change a verdict.
3. **Add the loader libraries** (`frontmatter-contract.sh`, `frontmatter-lexicon.sh`,
   `fm_list_keys`/`fm_list_metadata_keys`) with no caller yet. Same reasoning as step 2.
4. **Add the new fixture directories**, each with a single seeded defect, and confirm each one
   currently passes validation incorrectly (proving the gap exists) before any check is wired in —
   this is `D3.6`'s "observed failing" evidence in reverse: the fixture must be observed *wrongly
   passing* first.
5. **Wire the closed-key-set and duplicate-key checks into `schema-validate.sh` and
   `validate-skill.sh`.** Run the full suite; confirm the new fixtures now fail and all 8 real
   skills still pass.
6. **Wire the length lower bound**, sourced from the manifest rather than a literal `10` in the
   script. Same verification.
7. **Wire the lexicon and identifier-resolution check.** Same verification, plus the full
   126-word measurement re-run with zero false positives (SC-003).
8. **Add the `metadata.dependencies` row to `_authoring-standard.md`** and the manifest citation,
   satisfying `P7.3` and FR-008.
9. **Run the required-key acceptance proof (FR-016, SC-004):** add one new required key to the
   manifest only, confirm a previously-conforming skill now fails, then remove that key again
   before finishing (it is a proof, not a permanent addition).
10. **Record the closing measurements**: final suite runtime against the 240s ceiling, `UNCHECKED`
    empty for all 8 skills, and the full 6-of-6 mutation-audit re-run.

Steps 5, 6, and 7 each end with a full suite run rather than deferring verification to the end, so
a regression is attributable to the step that caused it.

### What this feature must not do

- Edit any existing skill's frontmatter to make a new check pass, per FR-017. A real defect found
  during rollout is fixed as a defect and named as one.
- Introduce `jq`, a JSON parser, `aspell`, `hunspell`, or any interpreter outside the Declared
  Toolchain, per `D2.4` and this feature's own Out of Scope.
- Leave the required-key acceptance proof (step 9) in place as a permanent manifest change — it is
  evidence, not a feature.
- Loosen the existing 500-character upper bound while adding the 10-character lower bound.

## Risks

- **The closed-key-set check is the one most likely to surprise an existing skill.** Every one of
  the 8 skills must be checked against the manifest before it is wired in (`D3.4`); an
  undocumented key present today (there is no evidence of one, but none has been enumerated before
  either) would be a real defect this feature must report and fix, not suppress by widening the
  permitted set to match.
- **The lexicon's 126-word baseline was measured 2026-09-11 (spec Summary); it may drift by the
  time this feature lands.** The measurement is re-taken at implementation time (step 7), not
  assumed from the spec.
- **`fm_get`'s existing `head -n1` behavior is left unchanged.** Every current caller depends on
  first-match resolution; duplicate-key detection is added as a parallel check over
  `fm_list_keys()`, not a change to `fm_get` itself, so no existing caller's behavior shifts.

## Phase Outputs

- **Phase 0** → [research.md](./research.md): format/location decisions for the contract manifest
  and lexicon, the key-enumeration and duplicate-detection mechanism, and the test-file boundary
  decision.
- **Phase 1** → [data-model.md](./data-model.md): the entities and their fields;
  [contracts/frontmatter-contract-shape.md](./contracts/frontmatter-contract-shape.md): the exact
  manifest grammar and its initial, fully-populated content; [quickstart.md](./quickstart.md): how
  to run the seeded-defect verification end to end.

## Post-Design Constitution Re-Check

Re-evaluated after Phase 1 artifacts were written. No verdict changed. `P7.3` is discharged by
`contracts/frontmatter-contract-shape.md` existing as the one place the manifest's grammar is
documented, cited by id from `_authoring-standard.md` rather than restated there.
