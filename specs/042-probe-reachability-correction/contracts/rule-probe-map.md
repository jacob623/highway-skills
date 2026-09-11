# Rule-to-probe map — measured, not read

**Feature**: 042-probe-reachability-correction
**Measured**: 2026-09-10, after every class this feature adds, broadens or repairs was in place
**Method**: for each `[auto]` Enforcement Map row, one line of the code deciding that rule was
replaced with an always-passing form, `bash .highway/tools/tests/run-all.sh` was run in full, the
exit code and the `FAIL:` lines were recorded, and the file was restored from bytes held in memory.
All thirteen files were confirmed sha256-identical after restore. No probe source was read to
produce the "detecting leg" column: it is what the suite printed.

This satisfies FR-023 (the join is recorded) and FR-024 (it is derived by removal, not by reading).

## The thirteen rows — final measurement

| Rule | Test | Declared classes | Enforcement removed | Suite failed | Detecting leg, as the suite labelled it |
|---|---|---|---|---|---|
| D1.1 | shipped-tree-independence.test.sh | source-document, disposable-fixture | `find_violations` line 66, the token scan | yes (exit 1, 207s) | `D1.1 probe for source-document` **and** `D1.1 probe for disposable-fixture` |
| D1.2 | distribution-packaging.test.sh | source-document, disposable-fixture, generated-artifact | `generate-distribution.sh` line 88, `verify_no_development_paths`'s report | yes (exit 1, 210s) | `D1.2 probe for source-document`, plus two normal-mode assertions |
| D4.1 | generate-agent-adapters.test.sh | generated-artifact | line 31, `hand_edit_preserved`'s grep | yes (exit 1, 196s) | `D4.1 probe for generated-artifact` |
| D4.2 | generate-catalog.test.sh | generated-artifact | line 30, `catalog_snapshots_match`'s comparison | yes (exit 1, 209s) | `D4.2 probe for generated-artifact` |
| D4.3 | distribution-packaging.test.sh | source-document, disposable-fixture, generated-artifact | `generate-distribution.sh` line 75, `check_no_drift`'s hash comparison | yes (exit 1, 225s) | `D1.2 probe for generated-artifact`, plus normal mode's `packaging did not refuse to overwrite` |
| D4.5 | adapter-coverage.test.sh | source-document, generated-artifact | line 84, `check_skill_correspondence`'s catalog-entry test | yes (exit 1, 211s) | `D4.5 probe for generated-artifact` |
| D4.6 | adapter-coverage.test.sh | source-document, generated-artifact | line 134, `orphan_problems`'s adapter-manifest orphan test | yes (exit 1, 213s) | `D4.5 probe for generated-artifact`, plus normal mode |
| D4.7 | adapter-coverage.test.sh | source-document, generated-artifact | line 184, `skill_currency_ok`'s diff | yes (exit 1, 214s) | `D4.5 probe for source-document` |
| D5.4 | spec-record.test.sh | disposable-fixture | line 54, `numbering_problems`'s gap branch | yes (exit 1, 220s) | `D5.4 probe for disposable-fixture` |
| D5.5 | spec-record.test.sh | disposable-fixture | line 71, `identity_problems`'s basename comparison | yes (exit 1, 231s) | `D5.4 probe for disposable-fixture` |
| D7.2 | completion-coverage.test.sh | source-document, disposable-fixture | line 120, `coverage_check`'s `comm -23` | yes (exit 1, 217s) | `D7.2 probe for disposable-fixture`, plus normal mode's `missing requirement id unexpectedly passed` |
| D7.4 | completion-coverage.test.sh | source-document, disposable-fixture | line 73, `coverage_check`'s header count | yes (exit 1, 256s) | `D7.2 probe for disposable-fixture`, plus normal mode's `invalid coverage header unexpectedly passed` |
| D3.7 | constitution-inventory.test.sh | source-document | line 47, `harness_probe_pair`'s `seeded_exit -eq 0` branch | yes (exit 1, 289s) | normal mode's `harness_probe_pair did not report a probe that cannot fail on its own seeded defect` |

**Thirteen of thirteen.** The runtimes in this table are removal-cycle runs taken on a machine
already busy with the measurement campaign; the settled suite figures are in `research.md` R5.

## How to read the "detecting leg" column

The harness labels a probe pair by Enforcement Map **row**, and four rows share a file with another
row. So where two rules are decided by one test file and one class, the leg is announced under
whichever row the harness reached first — `D1.2` stands for the `distribution-packaging` pair,
`D5.4` for `spec-record`, `D4.5` for `adapter-coverage`, `D7.2` for `completion-coverage`. The label
is not evidence about which rule was broken; the removal is. Each rule of each shared pair was
nonetheless removed separately and each removal failed the suite, so the pairs are proved
individually, not jointly.

`D3.7` is the one row whose detection does not come through the probe channel. See below.

## The count SC-002 asks for

| | Before (T003) | First exhaustive pass (T015) | After the T015 corrections |
|---|---|---|---|
| Rules measured | 4 | 13 | 13 |
| Undetected when their enforcement was removed | 4 | 3 | **0** |
| Which | `D4.3`, `D5.5`, `D7.2`, `D7.4` | `D4.5`, `D4.6`, `D3.7` | — |

`SC-002` was written as a fall from four to zero. The honest account is a fall from **seven** to
zero. T003 measured only the four rules the Feature 041 audit had already suspected; four was never
the population, only the sample. T015 is the first exhaustive measurement, and it found three
further rules whose enforcement could be removed with the suite still reporting green. They were not
a regression this feature introduced — the same removals would have passed before it — they were
three more instances of the defect this feature names, found by the method this feature adopted.
All three were then corrected inside this feature.

## What the three further defects were, and how each was corrected

### D4.5 and D4.6 — one leg seeding many defects at once

`adapter-coverage.test.sh`'s `generated-artifact` leg seeded four defects simultaneously (catalog
entry removed, adapter file removed, adapter manifest row removed, distribution manifest row
removed) and required `check_skill_correspondence` to fail. With four defects present, deleting any
one of the four checks left the other three still reporting, so the leg still failed and the harness
still announced a pass. This is a failure of contract clause C5 — a leg that seeds more than one
defect must fail if *any* one enforcement is removed — and it is the same shape as the original
`D4.3` defect, one level down.

`D4.6`'s four orphan checks had a second problem: they lived inline in the normal-mode body, so no
probe could reach them at all.

**Correction**: the four `D4.6` loops were extracted into `orphan_problems()`, which normal mode now
calls, and the `generated-artifact` leg was rewritten to seed each of eight defects on its own —
four decided by `check_skill_correspondence`, four by `orphan_problems` — requiring each to be
reported. Removing any one check now makes the leg exit 0. Verified by removal: `D4.5` at line 84
and `D4.6` at line 134 each fail the suite.

### D3.7 — a rule that cannot fully prove itself through its own channel

`constitution-inventory.test.sh` probed itself by seeding a probe that always fails, which reaches
`harness_probe_pair`'s `neutral_exit` branch. The `seeded_exit -eq 0` branch — the one that catches
a probe unable to detect its own seeded defect, which is the entire point of `D3.7` — was never
exercised, and deleting it left the suite green.

Seeding the missing case is not sufficient on its own, and this is the interesting part. A probe leg
reports a defect *by exiting 0*, and it is the `seeded_exit` branch that turns that exit 0 into a
failure. Remove the branch and the report announcing its absence is the very thing no longer heard.
Measured: with the branch deleted and the leg seeding all three cases, the suite still exited 0.

**Correction**: the three reports are asserted in normal mode, on the same `harness_probe_pair` the
harness loop calls, against a real mapped test whose probe is perturbed in place and restored
immediately. The **message** is asserted, not only the return code — with the exit-2 branch deleted,
an undeclared class still reaches the `neutral_exit` branch, so the return code alone left that
branch unproved. Verified by removal: deleting line 44, 47 or 50 each fails the suite and names
which report went missing. The probe leg also seeds all three cases, so the two branches that *can*
be proved through the probe channel are proved twice.

The general lesson, recorded because it will recur: **a check cannot prove the part of itself that
carries its own verdict.** That part has to be asserted through a different channel.
