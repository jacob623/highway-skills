# Quickstart: Validating Test Suite Runtime Recovery

**Feature**: 056-test-suite-runtime-recovery | **Date**: 2026-09-20

How to reproduce every measurement and every proof this feature depends on. Run from the repository
root. Nothing here is a substitute for `tasks.md`; this is the validation guide.

---

## Prerequisites

```sh
cd /path/to/highway-skills
/bin/bash --version | head -1        # expect 3.2.57 on macOS
getconf _NPROCESSORS_ONLN            # record this; FR-003 requires it with every measurement
                                     # must be a positive integer on BOTH platforms (D2.3)
bash .highway/tools/tests/run-all.sh; echo "exit=$?"   # D3.1 — must be 0 before any edit
```

If the suite does not exit 0 before you start, stop. D3.1 is not advisory, and a baseline taken on
a red tree measures nothing.

---

## Phase A — Capture the baseline (before any edit)

**This is the one step that cannot be redone later.** FR-001 exists because a baseline taken after
the change is a description, not a control.

### A1 — Whole-suite wall clock

```sh
for i in 1 2 3 4 5; do
  /usr/bin/time -p bash .highway/tools/tests/run-all.sh >/dev/null 2>/tmp/t$i
  grep '^real' /tmp/t$i
done
```

Record all five. Report min–max and median, never a best sample.

### A2 — Suite output, durations masked

```sh
mask() { sed -E 's/[0-9]+\.[0-9]+s/T/g; s/[0-9]+ seconds/T/g; s#(/T//[A-Za-z0-9_.-]*\.)[A-Za-z0-9]{6}/#\1XXXXXX/#g'; }
bash .highway/tools/tests/run-all.sh 2>&1 | mask >specs/056-test-suite-runtime-recovery/.before.txt
```

Every later phase diffs against this file. Keep it until Phase F.

### A3 — Per-class probe cost

Run this with `bash`, not `zsh`. The loop reads two fields per line, so it does not rely on the
shell word-splitting an unquoted variable — zsh does not, and under zsh an earlier form of this
snippet silently ran `bash "<file> <class>"` and reported `exit=127` for all twenty legs.

```sh
bash <<'EOF'
while read -r test_name class; do
  [ -n "$test_name" ] || continue
  for mode in "" "--neutralise"; do
    start=$(date +%s)
    bash ".highway/tools/tests/$test_name" --probe "$class" $mode >/dev/null 2>&1
    echo "$test_name $class ${mode:-seeded} exit=$? $(( $(date +%s) - start ))s"
  done
done <<'LEGS'
shipped-tree-independence.test.sh source-document
shipped-tree-independence.test.sh disposable-fixture
distribution-packaging.test.sh source-document
distribution-packaging.test.sh disposable-fixture
distribution-packaging.test.sh generated-artifact
adapter-coverage.test.sh source-document
adapter-coverage.test.sh generated-artifact
generate-catalog.test.sh generated-artifact
generate-agent-adapters.test.sh generated-artifact
constitution-inventory.test.sh source-document
LEGS
EOF
```

Expect twenty lines: ten exiting non-zero (seeded), ten exiting zero (neutralised). **Any other
exit code is a defect, not a timing result** — stop and investigate rather than recording it. In
particular `exit=127` on every leg means the loop never reached a test; it is a harness fault.

The reference measurement is in [research.md](research.md) §M2 (111.75s total).

### A4 — Assertion inventory

Populate the table in [contracts/assertion-inventory.md](contracts/assertion-inventory.md) for the
four in-scope files. Do not start Phase B until it is complete.

---

## Phase B — Classification equivalence

Full obligations in
[contracts/classification-equivalence.md](contracts/classification-equivalence.md).

```sh
source .highway/tools/lib/distribution.sh
REPO_ROOT="$PWD"
find "$REPO_ROOT" -type f -not -path "$REPO_ROOT/.git/*" \
  | sed "s|^$REPO_ROOT/||" | sort >/tmp/paths.txt
wc -l /tmp/paths.txt                                   # expect 773 at time of writing

while read -r p; do printf '%s\t%s\n' "$(dist_classify "$p")" "$p"; done </tmp/paths.txt >/tmp/old.txt
dist_classify_many </tmp/paths.txt >/tmp/new.txt
diff /tmp/old.txt /tmp/new.txt && echo "EQUIVALENT"
```

Then the adversarial set — these are the cases a naive rewrite gets wrong:

```sh
for p in .github/skills/highway-new/SKILL.md .github .highway/tools/tests/run-all.sh \
         .highway/skills/highway-new/SKILL.md specs/056-test-suite-runtime-recovery/spec.md \
         .DS_Store .highway/tools/lib/distribution.sh no/such/path; do
  printf '%s\t%s\n' "$(dist_classify "$p")" "$p"
done
```

Expected: `include`, `exclude`, `exclude`, `include`, `exclude`, `exclude`, `exclude`,
`unclassified`.

Prune roots must be derived, not listed:

```sh
dist_prune_roots        # expect specs, .specify, and the exact-match file records
                        # must NOT contain .github, .claude, .cursor, or .highway
```

If `.github` appears in that output, stop. Pruning it drops every adapter out of the distribution.

---

## Phase C — Distribution byte-identity

```sh
OLD=$(mktemp -d); NEW=$(mktemp -d)
git stash            # or otherwise obtain the pre-change tree
bash .highway/tools/generate-distribution.sh "$OLD"
git stash pop
bash .highway/tools/generate-distribution.sh "$NEW"

( cd "$OLD" && find . -type f | sort ) >/tmp/old-files.txt
( cd "$NEW" && find . -type f | sort ) >/tmp/new-files.txt
diff /tmp/old-files.txt /tmp/new-files.txt && echo "SAME 83 PATHS"

while read -r f; do
  a=$(shasum -a 256 "$OLD/$f" | cut -d' ' -f1)
  b=$(shasum -a 256 "$NEW/$f" | cut -d' ' -f1)
  [ "$a" = "$b" ] || echo "DIFFERS: $f"
done </tmp/new-files.txt
```

The only permitted difference is the file carrying the recorded generation timestamp, which the
D4.2 Observable already excepts. Anything else is a packaging defect.

---

## Phase D — Concurrency, ordering and serial mode

```sh
# Same output, concurrent vs serial (SC-011)
HIGHWAY_TEST_WORKERS=1 bash .highway/tools/tests/run-all.sh 2>&1 | mask >/tmp/serial.txt
bash .highway/tools/tests/run-all.sh 2>&1 | mask >/tmp/concurrent.txt
diff /tmp/serial.txt /tmp/concurrent.txt && echo "SERIAL == CONCURRENT"

# Same output as before the feature (SC-009)
diff specs/056-test-suite-runtime-recovery/.before.txt /tmp/concurrent.txt && echo "UNCHANGED OUTPUT"

# Order is stable across runs, not just correct once
for i in 1 2 3; do bash .highway/tools/tests/run-all.sh 2>&1 | mask | grep '^==> Running' | md5; done

# A bad override is an error, not a silent fallback
HIGHWAY_TEST_WORKERS=nonsense bash .highway/tools/tests/constitution-inventory.test.sh; echo "exit=$?"
HIGHWAY_TEST_WORKERS=0 bash .highway/tools/tests/constitution-inventory.test.sh; echo "exit=$?"
```

The three hashes must match. A run-to-run difference here means ordering is emergent rather than
declared, which FR-011 forbids.

Then re-run A3 unchanged. All twenty legs must still produce their contract exit codes (SC-003).

---

## Phase E — The standing guard

```sh
bash .highway/tools/tests/classification-scope.test.sh; echo "exit=$?"     # expect 0

# Seed the regression it exists to catch (SC-010)
# Temporarily make the walk enumerate a pruned root, then:
bash .highway/tools/tests/classification-scope.test.sh; echo "exit=$?"     # expect non-zero
# ...naming the offending path and prune root. Restore before continuing.
```

A guard that has never been observed failing is not evidence. D3.6 requires the failing run be
recorded before the behavior is marked complete.

Also confirm the new file does not break the repository-wide inventory:

```sh
grep -c '^# Instrument class:\|^# Artifact classes:' .highway/tools/tests/classification-scope.test.sh
```

Expect 2. `constitution-inventory.test.sh` scans **every** `*.test.sh` for both headers, including
files that are not in the Enforcement Map. Omitting them is the most likely first-run failure.

---

## Phase F — Record and acceptance

### F1 — Five consecutive runs

Repeat A1 on an idle machine. Record range, median, core count, effective worker count.

| Outcome | What to write |
|---|---|
| Every run ≤180s | Target **met**. Remove the 240s interim ceiling, close Feature 042's deviation. |
| Any run >180s | Target **retained and unmet** (FR-020). Keep the gains, record the achieved range, leave the target at 180s and the ceiling and deviation in place. **Do not amend the target.** |

### F2 — Growth evidence (FR-012, one-off)

```sh
mkdir -p specs/.growth-probe
for i in $(seq 1 500); do echo "probe $i" >"specs/.growth-probe/f$i.md"; done
# re-run A1, compare, then:
rm -rf specs/.growth-probe
```

Expect ≤5s change. Baseline for comparison: ≈55s today (research §M4). **Remove the directory** —
leaving it behind would poison every later measurement.

### F3 — Final gates

```sh
bash .highway/tools/tests/run-all.sh; echo "exit=$?"     # D3.2 — must be 0
git status --short                                        # no probe residue, no stray fixtures
```

Then populate the runtime table in [contracts/probe-mode.md](contracts/probe-mode.md) and fill
every `after` column in the assertion inventory.

---

## Stop conditions

Stop and report rather than continuing, if:

- Any of the twenty legs stops producing its contract exit code (FR-005).
- An assertion has no counterpart after the change (FR-006, R1).
- The distribution differs in any file other than the generation timestamp (SC-006).
- The masked output diff is non-empty and the difference is not explained by a recorded,
  intentional change (SC-009).
- Reaching 180s appears to require dropping a class or loosening a probe. This is the case
  governance plan Phase 14 says to stop on, and FR-020 says what to ship instead.
