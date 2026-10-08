# Quickstart: Suite Runtime Reduction

**Feature**: 151 | **Date**: 2026-10-08

Run these from the repository root. Each part states what proves the feature works and what proves
it did not trade coverage for speed.

## Prerequisites

- macOS or Linux, bash 3.2.57 or later
- A clean working tree: `git status --short` reports nothing unexpected
- The suite green before any edit (D3.1)

## Part 0 — Record the baseline

```sh
time .highway/tools/tests/run-all.sh
```

**Expected**: `Summary: 74 passed, 0 failed`, exit 0.

**Reference baseline**: 371.8 s wall. Re-measure on the machine under test rather than trusting
this figure — the first recorded baseline for this feature was a cold run and overstated every
test by up to 7×. Run it twice and use the second number.

## Part 1 — Validation cache

### 1a. The saving is real

```sh
rm -rf "${TMPDIR:-/tmp}/highway-validation-cache"
time .highway/tools/generate-agent-adapters.sh    # cold
time .highway/tools/generate-agent-adapters.sh    # warm
```

**Expected**: cold ≈ 8.1 s, warm under 4 s. The difference is the twelve skill validations no
longer being repeated.

### 1b. A defect is still caught (the assertion that matters)

```sh
.highway/tools/generate-agent-adapters.sh                      # populate the cache
printf '\nMUST not appear\n' >> .highway/skills/highway-help/SKILL.md
.highway/tools/generate-agent-adapters.sh ; echo "exit=$?"
git checkout -- .highway/skills/highway-help/SKILL.md
```

**Expected**: non-zero exit naming `highway-help`, with the same error text as before the feature.
A pass here would mean the cache is masking defects, which is the one failure mode that makes this
feature worse than doing nothing.

### 1c. A governance edit invalidates every skill

```sh
.highway/tools/generate-agent-adapters.sh                      # populate
printf '\n' >> .highway/governance/constitution.md
time .highway/tools/generate-agent-adapters.sh                 # must be cold again
git checkout -- .highway/governance/constitution.md
```

**Expected**: the run takes cold time, not warm time. Contract VC-6.

### 1d. Output is unchanged

```sh
git status --short .github .claude .cursor .agents .highway/catalog
```

**Expected**: no output. Generated artifacts are byte-identical (FR-003, D4.2).

### 1e. The escape hatch works

```sh
rm -rf "${TMPDIR:-/tmp}/highway-validation-cache"
.highway/tools/validate-skill.sh --no-cache .highway/skills/highway-profile ; echo "exit=$?"
ls "${TMPDIR:-/tmp}/highway-validation-cache" 2>/dev/null | wc -l
```

**Expected**: exit 0 and a count of 0 — `--no-cache` validates fully and records nothing (VC-7).

### 1f. The cache never enters the repository

```sh
git status --short | grep -i cache ; echo "exit=$?"
```

**Expected**: no matching lines (VC-9, FR-005).

## Part 2 — Runner concurrency

### 2a. Same results, less time

```sh
time .highway/tools/tests/run-all.sh | tee /tmp/151-run1.txt
time .highway/tools/tests/run-all.sh | tee /tmp/151-run2.txt
time .highway/tools/tests/run-all.sh | tee /tmp/151-run3.txt
for f in /tmp/151-run1.txt /tmp/151-run2.txt /tmp/151-run3.txt; do
  grep -E '^(PASS|FAIL):' "$f" | sort > "$f.sorted"
done
diff /tmp/151-run1.txt.sorted /tmp/151-run2.txt.sorted && \
diff /tmp/151-run2.txt.sorted /tmp/151-run3.txt.sorted && echo "identical across three runs"
```

**Expected**: `74 passed, 0 failed` each time, identical sorted results, and wall time at or under
180 s (SC-001, SC-003).

### 2b. Concurrency is not hiding a failure

```sh
.highway/tools/tests/run-all.sh --serial | tail -3
```

**Expected**: the same 74 passed, 0 failed. Any test that passes serially and fails concurrently —
or the reverse — is real coupling to investigate, not a flake to retry (FR-011, RC-1).

### 2c. Output is attributed, not interleaved

```sh
grep -cE '^(PASS|FAIL): ' /tmp/151-run1.txt
grep -nE '^(PASS|FAIL): .*(PASS|FAIL): ' /tmp/151-run1.txt ; echo "exit=$?"
```

**Expected**: 74 result lines, and no line containing two results spliced together (RC-4).

### 2d. The sweep still runs first

```sh
touch distribution-probe-manual.md
.highway/tools/tests/run-all.sh | tail -3
ls distribution-probe-manual.md 2>/dev/null || echo "swept"
```

**Expected**: `swept`, and 74 passed. Residue from an interrupted run must not reach a test
(RC-5, FR-010).

## Part 3 — Coverage was not traded for speed

```sh
ls .highway/tools/tests/*.test.sh | wc -l
git diff --stat -- .highway/tools/tests/
```

**Expected**: the file count is at least 74 plus any test this feature adds, and the diff shows no
assertion removed. FR-012 and SC-002 are the point of this part: a faster suite that tests less is
a failed implementation of this feature, not a successful one.

## Decision point after Part 1

Measure `constitution-inventory.test.sh` on its own:

```sh
time bash .highway/tools/tests/constitution-inventory.test.sh
```

Baseline 88.9 s. If the cache has not brought it down materially, it alone sets the floor for any
concurrent run and SC-001 is out of reach. Stop and decide whether to amend the spec to bring the
meta-harness into scope, rather than proceeding to Part 2 and discovering it at the end.
