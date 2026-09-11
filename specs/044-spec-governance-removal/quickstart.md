# Quickstart: Specification-Record Governance Removal

**Feature**: 044-spec-governance-removal | **Date**: 2026-09-11

How to execute and verify this removal. Every step names what must be true afterwards, because the
only risk in a deletion feature is that it reaches further than intended.

All commands run from the repository root. Bash 3.2 syntax only; the persistent shell is zsh, so
loops are wrapped in `bash -c`.

---

## Before you start

**Do not skip this.** Two of these numbers cannot be recovered once the edits begin.

```bash
# D3.1 gate: the suite passes before the first edit. Three runs, reported as a range.
bash -c 'for i in 1 2 3; do S=$(date +%s); bash .highway/tools/tests/run-all.sh >/tmp/base.$i 2>&1; \
  echo "run $i: $(( $(date +%s) - S ))s exit=$?"; done'

# SC-010 baseline: the rule-to-skill decision count. Expected 93 of 480.
# Record the exact command used alongside the number, so the after-measurement is comparable.
```

Write all of it into `research.md` §1.2 before editing anything. A baseline recorded after the fact
is not a baseline.

**Get the `D3.5` sign-off.** A human must approve the deletion of three passing tests. The reasoning
is in `research.md` §2.4. This is the one `[human-review]` rule in the constitution and it is not
self-certifying.

---

## Step 1 — Relocate `D5.3` and `D7.3`

Move both rows into `### III. Verification Before and After`. **Copy the Rule and Observable columns
byte-for-byte.** Do not reword, do not renumber.

Verify:

```bash
grep -c '^| D5\.3 |' .specify/memory/constitution.md   # expect 1
grep -c '^| D7\.3 |' .specify/memory/constitution.md   # expect 1
```

Both principle sections now hold only rules bound for removal.

---

## Step 2 — Remove the four Enforcement Map rows

Remove the rows for `D5.4`, `D5.5`, `D7.2`, `D7.4`.

**Then run the full suite.** This step is isolated for a reason: no Enforcement Map row has ever been
removed, and `constitution-inventory.test.sh` derives its work from that map. Its behaviour under a
shrinking map is predicted, not observed.

```bash
bash .highway/tools/tests/run-all.sh; echo "exit=$?"
```

Expect exit 0, and expect `constitution-inventory.test.sh` to be noticeably faster. **Record the new
timing.** It is the measurement that tells you how much of its 97.2s was map-driven.

If this step fails, stop. Do not proceed to deleting files — diagnose here, where the cause is
unambiguous.

---

## Step 3 — Remove the eight rules and two sections

Remove `D5.1`, `D5.2`, `D5.4`, `D5.5`, `D7.1`, `D7.2`, `D7.4`, `D7.5`, then the now-empty
`### V. Specification Record Integrity` and `### VII. Completion Integrity` sections including their
rationale paragraphs.

Verify nothing is left behind or over-removed:

```bash
# No removed rule survives
grep -nE '^\| D5\.(1|2|4|5) \||^\| D7\.(1|2|4|5) \|' .specify/memory/constitution.md   # expect no output

# Retained rules intact
grep -nE '^\| D5\.3 \||^\| D7\.3 \|' .specify/memory/constitution.md                   # expect 2 lines

# D1.1 and D1.2 untouched
grep -nE '^\| D1\.(1|2) \|' .specify/memory/constitution.md                            # expect 2 lines

# Rule count: expect 30
grep -oE '\bD[0-9]+\.[0-9]+\b' .specify/memory/constitution.md | sort -u | wc -l
```

---

## Step 4 — Bump the version

`1.6.0` → `2.0.0`. MAJOR, because the Versioning Policy defines MAJOR as a principle being removed,
and two are.

The amendment entry records: removed ids, relocated ids, new rule count, new tier counts, and the
self-application review against `D1.3`, `D1.4` and `D5.3`.

**Do not edit any historical version entry.** Their counts were true when written (FR-007).

---

## Step 5 — Amend the callers, before deleting anything

```bash
grep -n 'feature-038-plan' .highway/tools/tests/run-all.sh
grep -n 'feature-038-plan' .highway/tools/tests/feature-038-evidence-report.sh
```

`run-all.sh` names it twice — in the skip `case` and in the ordered tail list. Both must go.

`feature-038-evidence-report.sh` names it once, inside a `static contract` category.

**Leave `feature-038-helpers.sh` alone.** `readiness-executable.test.sh` and
`highway-setup-executable.test.sh` both source it.

---

## Step 6 — Delete the three test files

```bash
rm .highway/tools/tests/completion-coverage.test.sh \
   .highway/tools/tests/spec-record.test.sh \
   .highway/tools/tests/feature-038-plan.test.sh

bash .highway/tools/tests/run-all.sh; echo "exit=$?"
```

Expect exit 0 and 40 tests where there were 43.

Confirm nothing dangles:

```bash
grep -rn 'completion-coverage\|spec-record\|feature-038-plan' .highway/ .specify/   # expect no output
```

---

## Step 7 — Close the records

**Completion register.** Rewrite the header so it asserts no reader — it currently claims `D7.2`,
`D7.4` and `D7.5` read it, which is now false. Add `withdrawn` to the stated vocabulary. Then:

- `042-probe-reachability-correction` → `complete`
- `043-corrective-provenance-honesty` → `withdrawn`

**Feature 043's spec.** Status `Draft` → `Withdrawn`, naming Feature 044 and stating that its
subject — `correction_check` and `D7.5` — no longer exists. **Change nothing else in that file.**

```bash
# 042's record must be untouched: 27 rows, all satisfied
grep -cE '^\| FR-[0-9]+ \| satisfied \|' specs/042-probe-reachability-correction/coverage.md  # expect 27
grep -cE '^\| FR-[0-9]+ \| deferred \|' specs/042-probe-reachability-correction/coverage.md   # expect 0

# 043's requirements must be intact
grep -c '^- \*\*FR-' specs/043-corrective-provenance-honesty/spec.md   # expect 17
```

---

## Step 8 — Close out

```bash
# D3.2 gate: three runs, reported as a range
bash -c 'for i in 1 2 3; do S=$(date +%s); bash .highway/tools/tests/run-all.sh >/tmp/after.$i 2>&1; \
  echo "run $i: $(( $(date +%s) - S ))s exit=$?"; done'
```

Then re-measure the `validate-skill.sh` decision count. **Expect 93 of 480, unchanged.** A different
number means something was edited that should not have been — investigate before reporting complete.

Work through the verification checklist in
[contracts/removal-inventory.md](./contracts/removal-inventory.md) §J. Every line maps to a success
criterion.

---

## Reporting rules

Two, and they are requirements rather than style preferences:

- **Runtime is a side effect.** State it before and after. Do not present it as a reason for the
  change. The three deleted tests are 11.8s of ~200s — 5.9%. Any larger saving comes from
  `constitution-inventory` losing map entries, which is welcome and still not the justification.
  (FR-022)
- **This feature adds no coverage.** It removes governance over files that do not ship. The
  rule-to-skill figure is unchanged at 19.4% by design. Do not describe the result as an improvement
  in test coverage. (SC-010)

## If something goes wrong

Each step has a single-purpose verification for a reason. Do not batch steps to save time — a suite
failure after three combined edits costs more to diagnose than the runs saved.

`constitution-inventory.test.sh` at step 2 is the least predictable point in this feature. If it
fails there, the map-row removal is the cause; nothing has been deleted yet.
