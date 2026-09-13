# Quickstart: Validating Contract Proof and Lexicon Speed

**Feature**: [spec.md](spec.md) | **Date**: 2026-09-12

How to confirm this feature works, end to end. Run from the repository root.

## Prerequisites

- `/bin/bash` reporting `3.2.57` or later. Check with `/bin/bash -c 'echo $BASH_VERSION'`. The
  constructs used here are 3.2-safe; running the suite under a newer `bash` in `PATH` would not prove
  that.
- A clean working tree. Several checks below compare against committed state.
- The suite green before any edit, per D3.1.

## Step 0 — Capture the baseline before editing anything

This must happen **first**. Once `frontmatter-lexicon.sh` is modified the original output is no
longer observable, and the equivalence check in Step 3 degrades into guesswork.

```bash
mkdir -p /tmp/046-baseline
for d in .highway/skills/*/ .highway/tools/tests/fixtures/*/; do
  n=$(basename "$d")
  bash .highway/tools/validate-skill.sh "$d" > "/tmp/046-baseline/$n.out" 2>&1
  echo "$n exit=$?" >> /tmp/046-baseline/exits.txt
done
```

Store it outside the repository tree so it cannot be mistaken for a deliverable.

## Step 1 — Record the starting suite state

```bash
time bash .highway/tools/tests/run-all.sh
```

**Expected**: exits 0, 37 files pass. Note the wall-clock figure; roughly 280 seconds is the
Feature 045 baseline. Record it — Step 5 compares against it.

## Step 2 — Verify the required-key proof actually fails when the property is broken

Do this **before** trusting the proof. A test that has never been observed failing is a test that has
never been observed at all (D3.6).

1. Seed the defect: change the validator so its required-key set comes from the keys with bespoke
   checks rather than from the manifest.
2. Run the new proof alone:

   ```bash
   bash .highway/tools/tests/frontmatter-contract-required-keys.test.sh
   ```

   **Expected**: non-zero exit, reporting the expected missing-field finding was absent.

3. Remove the defect and re-run.

   **Expected**: exit 0.

Then confirm it is not vacuous — temporarily make the validator reject everything. The proof must
**still fail**, because its positive assertion requires the unmodified target to pass.

## Step 3 — Confirm the lexicon change altered nothing observable

```bash
for d in .highway/skills/*/ .highway/tools/tests/fixtures/*/; do
  n=$(basename "$d")
  bash .highway/tools/validate-skill.sh "$d" > "/tmp/046-after-$n.out" 2>&1
  diff "/tmp/046-baseline/$n.out" "/tmp/046-after-$n.out" || echo "DIFFERS: $n"
done
```

**Expected**: no output. Any difference in text, order, or exit status is a defect, not an
improvement — including a reordered finding.

## Step 4 — Confirm the tracked files were never written

```bash
git diff --stat .highway/tools/.frontmatter-contract \
                .highway/library/knowledge/frontmatter-lexicon.txt
```

**Expected**: empty, including after a run in which the new proof fails. Force a failure and re-check;
this is the observable behind FR-005 and FR-014.

## Step 5 — Measure the lexicon cost

The gate is the lexicon's own cost, not total runtime (see Clarifications). Measure the checker
directly across a fresh process state:

```bash
/bin/bash -c '
  source .highway/tools/lib/constitution.sh
  source .highway/tools/lib/frontmatter-lexicon.sh
  d="$(sed -n "s/^description: *//p" .highway/skills/highway-setup/SKILL.md | head -1)"
  time { for i in 1 2 3; do fl_check_field "$PWD/.highway" description "$d" >/dev/null; done; }'
```

**Expected**: per-invocation lexicon cost at or below **0.025s**, down from a measured **0.237s**.
Prototype measurements across all 8 skills ranged 0.0126–0.0145s.

Then re-run the full suite and record total runtime as an **observation**:

```bash
time bash .highway/tools/tests/run-all.sh
```

**Expected**: exits 0. If the total remains above the 240 second interim ceiling, record the residue
as outstanding work owned by Phase 14 — it is not a failure of this feature.

## Step 6 — Confirm the governance surface is untouched

```bash
bash .highway/tools/tests/shipped-tree-independence.test.sh
git diff --stat .highway/governance/ .specify/memory/constitution.md
```

**Expected**: the first exits 0 — the new test file ships, so it must not name a development path.
The second is empty; no rule was added, removed, or retagged.

## Step 7 — Confirm nothing silently stopped being checked

```bash
for d in .highway/skills/*/; do
  bash .highway/tools/validate-skill.sh "$d" | grep '^UNCHECKED:' 
done
```

**Expected**: every `UNCHECKED:` line is empty. A faster checker that quietly checks less would pass
Steps 3 and 5 and fail here.

## Done when

- All 8 skills and every fixture produce byte-identical output to the baseline.
- The required-key proof has been observed failing against a seeded defect, and failing when made
  vacuous.
- Lexicon cost per invocation is at or below 0.025s.
- The tracked manifest and lexicon are unmodified, including after a failing run.
- The suite exits 0 and `UNCHECKED` is empty for every skill.
