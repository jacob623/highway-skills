# Quickstart: Frontmatter Contract Hardening

**Feature**: 045-frontmatter-contract-hardening | **Date**: 2026-09-11

How to build, wire in, and verify each new check end to end. Every step is seeded-defect-first: a
fixture is added and observed passing incorrectly, only then does the check that makes it fail get
implemented (`D3.6`).

All commands run from the repository root. Bash 3.2 syntax only.

---

## Before you start

```bash
# D3.1 gate: the suite passes before the first edit.
bash .highway/tools/tests/run-all.sh; echo "exit=$?"

# Record the current verdict of all 6 mutations from the 2026-09-11 audit (spec Summary / SC-001).
# 3 should currently fail correctly, 3 should currently pass incorrectly — record which is which.
```

## Step 1 — Add the manifest and lexicon as inert data

```bash
# Create .highway/tools/.frontmatter-contract per contracts/frontmatter-contract-shape.md.
# Create .highway/library/knowledge/frontmatter-lexicon.txt, seeded from the 126-word measurement,
# re-taken now rather than trusted from the spec (research.md Risk 2).
sort -c .highway/library/knowledge/frontmatter-lexicon.txt   # must exit 0 — file is sorted
sort .highway/library/knowledge/frontmatter-lexicon.txt | uniq -d   # must print nothing — no duplicates
bash .highway/tools/tests/run-all.sh; echo "exit=$?"   # still green — nothing reads either file yet
```

## Step 2 — Add loader libraries with no caller

Add `lib/frontmatter-contract.sh`, `lib/frontmatter-lexicon.sh`, and `fm_list_keys`/
`fm_list_metadata_keys` in `lib/frontmatter.sh`. Run the suite; still green, because nothing calls
them yet.

## Step 3 — Add fixtures and observe the gap

```bash
for f in invalid-skill-duplicate-key invalid-skill-undeclared-key \
         invalid-skill-short-description invalid-skill-unrecognized-word; do
  bash .highway/tools/validate-skill.sh .highway/tools/tests/fixtures/$f/SKILL.md
  echo "$f exit=$? (expected 0 — the gap this feature closes)"
done
```

Each command above must currently exit `0` (incorrectly pass). If any already fails, the check it
targets already exists and this feature's scope for that row is void — record that as a finding,
not a silent skip.

## Step 4 — Wire in the closed-key-set and duplicate-key checks

Implement in `schema-validate.sh`/`validate-skill.sh`, driven by `frontmatter-contract.sh`. Re-run
step 3's loop for the two relevant fixtures — both must now exit non-zero and name the offending
key. Re-run the full suite and all 8 real skills:

```bash
bash .highway/tools/tests/run-all.sh; echo "exit=$?"
for d in .highway/skills/*/; do
  [ -f "$d/SKILL.md" ] && { bash .highway/tools/validate-skill.sh "$d/SKILL.md"; echo "$d exit=$?"; }
done
```

All 8 must still exit `0`. A non-zero exit here is a real, previously-undetected defect — fix it and
name it; do not edit the check to tolerate it (FR-017).

## Step 5 — Wire in the length lower bound

Same pattern: `invalid-skill-short-description` must now fail, all 8 real skills must still pass
(already confirmed comfortably above 10 characters — see spec Validated Outcomes, minimum observed
79 in `highway-nfrs`'s `usage` field).

## Step 6 — Wire in the lexicon and identifier resolution

Same pattern for `invalid-skill-unrecognized-word`. Additionally confirm zero false positives
across all 8 skills' free-form fields against the re-measured lexicon (SC-003), and spot-check one
skill-id token and one each of a `D`-, `P`-, and `X`-prefixed rule-id token resolve correctly
without needing a lexicon entry.

## Step 7 — Author-facing documentation

Add the `metadata.dependencies` row to `_authoring-standard.md`'s frontmatter table, state the
10-character lower bound, and cite `.highway/tools/.frontmatter-contract` and
`contracts/frontmatter-contract-shape.md` per `P7.3`. Run `authoring-standard.test.sh`.

## Step 8 — Required-key acceptance proof (FR-016, SC-004)

```bash
# Temporarily add one required key no skill sets, e.g.:
printf 'top\towner\tyes\t-\n' >> .highway/tools/.frontmatter-contract
for d in .highway/skills/*/; do
  [ -f "$d/SKILL.md" ] && { bash .highway/tools/validate-skill.sh "$d/SKILL.md"; echo "$d exit=$?"; }
done
# Expect at least one non-zero exit naming "owner" as missing — this is the load-bearing proof.
# Then revert:
git checkout -- .highway/tools/.frontmatter-contract
```

## Step 9 — Closing measurements

```bash
bash .highway/tools/tests/run-all.sh; echo "exit=$?"   # must be 0, and within 240s (SC-005)
# Confirm UNCHECKED is empty for every skill (FR-018) and re-run all 6 original mutations —
# all 6 must now be caught (SC-001, up from 3 of 6).
```
