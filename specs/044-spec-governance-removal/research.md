# Research: Specification-Record Governance Removal

**Feature**: 044-spec-governance-removal | **Date**: 2026-09-11

## 1. Baseline measurements

### 1.1 Recorded on 2026-09-11, before any edit

Per-test wall-clock timings, each test invoked directly with `bash <file>`:

| Test | Time | Exit |
|---|---|---|
| `constitution-inventory.test.sh` | 97.2s | 0 |
| `distribution-packaging.test.sh` | 38.3s | 0 |
| `completion-coverage.test.sh` | **11.0s** | 0 |
| `generate-catalog.test.sh` | 9.1s | 0 |
| `adapter-coverage.test.sh` | 7.8s | 0 |
| `generate-agent-adapters.test.sh` | 6.2s | 0 |
| `rule-checks.test.sh` | 6.0s | 0 |
| `output-template.test.sh` | 1.25s | 0 |
| `coverage-summary.test.sh` | 0.84s | 0 |
| `profile-behavior.test.sh` | 0.81s | 0 |
| `spec-record.test.sh` | **0.59s** | 0 |
| `control-derived-nfr.test.sh` | 0.50s | 0 |
| `highway-setup.test.sh` | 0.42s | 0 |
| `feature-038-plan.test.sh` | **0.24s** | 0 |
| `relationship-integrity.test.sh` | 0.24s | 0 |

**The three tests this feature removes total 11.83 seconds.** Against a suite of roughly 200
seconds, that is 5.9%.

Two files hold 135.5 seconds — 68% of the run. Both survive this feature. **Any claim that this
feature addresses the suite's runtime would be false**, and FR-022 exists to prevent one being made
in the completion report.

### 1.2 Still to be recorded at implementation time

These cannot be taken now because they must bracket the edits:

- `run-all.sh` exit code and wall-clock runtime immediately before the first edit, per `D3.1`.
  Report as a range over at least three runs, not a single sample — Feature 041's task record was
  corrected for claiming a target met from one sample, and that mistake must not recur here.
- The same after the final edit, per `D3.2` and SC-009.
- `validate-skill.sh`'s rule-to-skill decision count before and after. Expected unchanged at
  **93 of 480** (19.4%); SC-010 treats any movement as evidence of an unintended edit.

## 2. What becomes unchecked, per removed test

`D3.5` requires that no assertion be removed without a recorded reason naming the superseded
behaviour. This section is that record. It is written per test rather than as a single paragraph,
because a blanket justification is exactly the move `D3.5` exists to catch.

### 2.1 `completion-coverage.test.sh` (592 lines, 11.0s)

Decided `D7.2` and `D7.4`, and implemented `correction_check` for `D7.5`.

**Behaviour that becomes unchecked:**

- That every requirement id in a completed feature's `spec.md` appears exactly once in that feature's
  coverage record.
- That every completed feature holds a `coverage.md` with the `Requirement`, `Outcome`, `Evidence`
  column schema and a bounded outcome vocabulary.
- That a `satisfied` row's evidence names a file that exists.
- That a corrective feature's coverage record carries originating-and-superseding provenance.
- That every directory under `specs/` has a completion register row.

**Why that no longer matters:** every one of those properties is a property of a file that is
stripped from the distribution. A user receives none of them. The strongest of the five — the
artifact-existence assertion on `satisfied` rows — is also the one this repository has already
measured as bypassable: gated on `[[ "$outcome" == "satisfied" ]]`, it never fires on a `deferred`
row, and measured 2026-09-11 all 96 deferred rows across the eight complete corrective features
contain no colon and no file-ish token. The check that mattered most was the easiest to evade, and
the evasion was systemic rather than incidental.

**Verdict:** removal accepted. The behaviour is real but its subject leaves scope.

### 2.2 `spec-record.test.sh` (150 lines, 0.59s)

Decided `D5.4` and `D5.5`.

**Behaviour that becomes unchecked:** that feature directory numbers are contiguous from 001 with no
gap and no duplicate, and that each directory's basename equals the `Feature Branch` value declared
in its own `spec.md`.

**Why that no longer matters:** both are properties of directory naming in a tree that does not
ship. A gap would make history slightly harder to read. It would break nothing a user runs.

**Honest cost:** this is the removal with the most genuine loss. The test is cheap at 0.59s, it has
a real probe, and it caught a class of defect that is easy to introduce and annoying to find later.
It is removed anyway, because retaining it means retaining `D5.4` and `D5.5`, and a rule retained
only because its test is cheap is a rule kept for the wrong reason. Numbering becomes convention.

**Verdict:** removal accepted, with the cost stated rather than minimised.

### 2.3 `feature-038-plan.test.sh` (69 lines, 0.24s)

Decided no mapped rule. It verified Feature 038's own `plan.md` and `tasks.md` ownership and
task-record contracts, and read Feature 037's `spec.md`.

**Behaviour that becomes unchecked:** that one historical feature's planning documents retain a
particular internal structure.

**Why that no longer matters:** it asserts properties of two completed, frozen feature directories.
Nothing can change them, so nothing can break the assertion — the test could only ever pass. It is
the clearest case of the three.

**Verdict:** removal accepted without reservation.

### 2.4 `D3.5` human-review verdict

**Verdict: APPROVED for removal, on the ground that the subject leaves scope — not on the ground
that the checks were weak, slow, or inconvenient.**

The distinction matters and is recorded deliberately. All three tests pass today. None was removed
to make a failing change go green. `D3.5`'s target is the move where an assertion is loosened to
accommodate work; this is the different case where the thing asserted about is no longer governed.

Two facts are recorded against the possibility that this reasoning is self-serving:

1. Feature 042 is currently blocked by one of these checks. Removing the check unblocks it. That is
   a real incentive to reach the conclusion reached here, and it is named so a reviewer can weigh it.
2. The removal was proposed as a runtime fix and **that justification was tested and rejected** —
   11.8s of ~200s. Had the runtime argument been accepted uncritically, the change would have shipped
   on a false premise.

This verdict requires a human sign-off before step 7 of the plan. It is not self-certifying.

## 3. Rule disposition reasoning

Ten rules sit under the two principles in scope. Each was assessed on one question: **is its subject
the record, or the product?**

| Rule | Subject | Disposition |
|---|---|---|
| `D5.1` | A completed spec directory | Remove |
| `D5.2` | Where a correction ships — a numbered spec directory | Remove |
| `D5.3` | A superseding document naming every element it changes | **Retain, relocate** |
| `D5.4` | A feature directory number | Remove |
| `D5.5` | A feature directory name | Remove |
| `D7.1` | A task marked complete in `tasks.md` | Remove |
| `D7.2` | A completed feature's coverage record | Remove |
| `D7.3` | The shape of a completion report | **Retain, relocate** |
| `D7.4` | A coverage record's path and schema | Remove |
| `D7.5` | Corrective coverage provenance | Remove |

### 3.1 Why `D5.3` is retained

Its subject is any superseding document, not the spec record. The constitution's own
**Self-Application** section states that the document is subject to `D1.3`, `D1.4` and `D5.3`, and
that every amendment records a review against those ids. Removing `D5.3` would break the
constitution's account of how it amends itself — including the amendment this feature performs.

### 3.2 Why `D7.3` is retained

Its subject is a completion report: that it states requirement coverage separately from check
results. That obligation is about not conflating two claims, and it survives the deletion of
`coverage.md` as a governed artifact. It is also the rule that most directly encodes this
repository's recurring lesson — that a green suite is not a coverage claim — and it would be
perverse to delete it in a change whose own report must distinguish a measured side effect from a
justification.

### 3.3 Relocation target

Both move to **Principle III, Verification Before and After**, which survives intact. Rule text and
Observable are carried byte-identical; only the heading above them changes. SC-003 verifies this.

Rule ids are **not** renumbered. `D5.3` and `D7.3` keep their ids under Principle III even though
the numbering no longer matches the principle number. Renumbering would invalidate every citation in
every existing spec, plan and coverage record in the repository, which is a far larger change than
this feature's subject, and it would do so to fix a cosmetic inconsistency.

## 4. Rules explicitly retained that the reasoning might otherwise reach

`D1.1` and `D1.2` both name `specs/` and `.specify/`. A careless application of "remove rules that
mention the spec tree" would delete them.

They point the opposite way. `D1.1` prohibits a **shipped** file from containing those tokens, and
`D1.2` requires the packaged tree to validate with those directories **absent**. Their subject is
the product's independence from the record — the very property that makes this feature's whole
argument work. Deleting them would remove the guarantee that the record is strippable, while acting
on the belief that it is.

FR-004 protects them. FR-008 generalises the protection.

## 5. Ordering research

`constitution-inventory.test.sh` executes the declared probe of every test named in the Enforcement
Map, which is why it costs 97.2s. This produces a hard ordering constraint:

- Delete a test file **before** its Map row → `constitution-inventory` tries to execute a probe in a
  file that does not exist.
- Delete the Map row **before** the test file → the test becomes unmapped but still runs and passes
  under `run-all.sh`. Harmless and transient.

**Map rows first.** The plan's step 3 is isolated and suite-verified for this reason: no Map row has
been removed before, and the behaviour of `constitution-inventory` under a shrinking map is
predicted, not observed.

**Correction, recorded after observing it (T008):** the second bullet's prediction was wrong.
`constitution-inventory.test.sh` also asserts the reverse direction — that every rule tagged
`[auto]` appears in the Map — so removing a Map row while its rule is still tagged `[auto]` fails
immediately, it is not "harmless and transient". The two removals (Map row, rule definition) cannot
be sequenced as separate suite-green checkpoints; they must land as one atomic edit, verified
together. Implementation performed T007 and T010 as a single change for this reason. The ordering
constraint against test-file deletion (first bullet, and the constraint the Enforcement Map section
of the constitution states explicitly) is unaffected and remains correct: rows and rules go before
files.

## 6. Blast radius, measured

`grep` across `.highway/` and `.specify/` for references to the three test files returned exactly
three files: `run-all.sh`, `feature-038-evidence-report.sh`, and the constitution itself.

`grep` for the removed rule ids across `.highway/` returned only the two test files being deleted.
**No shipped file cites any removed rule.**

One correction to an earlier assumption, found during this research and recorded because it would
have caused a defect: `feature-038-helpers.sh` is sourced by `readiness-executable.test.sh` and
`highway-setup-executable.test.sh`, both of which survive. It must be **retained**. Only
`feature-038-evidence-report.sh` references a deleted test, and only within one `run_category` line.
FR-011 was corrected to say so.

## 7. Open questions

None blocking. Two items are deliberately left to implementation:

- The exact wording of the rewritten completion register header (FR-019). It must assert no reader,
  and must add `withdrawn` to the stated vocabulary.
- Whether `feature-038-evidence-report.sh` is amended or removed outright. It has no caller inside
  the suite; the decision rests on whether the remaining category still produces useful evidence.

## 8. Completion report — runtime section (T028)

Per FR-022: stated as a measured side effect, not a justification. The change was not made to
improve runtime, and did not target either of the two tests that account for 68% of suite time
(`constitution-inventory.test.sh`, `distribution-packaging.test.sh` — both retained, both
unchanged).

**Before** (§1.1, three runs, 2026-09-11, before the first edit): 201s, 217s, 202s — all exit 0.

**After** (three runs, 2026-09-11, after the final edit): 179s, 182s, 177s — all exit 0.

The suite is roughly 20-40s faster, consistent with removing 11.83s of direct test time
(§1: `completion-coverage.test.sh` 11.0s, `spec-record.test.sh` 0.59s, `feature-038-plan.test.sh`
0.24s) plus `constitution-inventory.test.sh` now executing three fewer declared probes. **This
number is not a target met and is not the reason for the change** — the change was scope removal,
recorded in §2.4's `D3.5` verdict. Coverage is unchanged: `validate-skill.sh` still decides
93 of 480 (§1.2, SC-010) — this feature adds no test coverage and does not claim to.
