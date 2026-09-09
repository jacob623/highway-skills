# Quickstart: Validating Development Tier Honesty

**Feature**: `014-dev-tier-honesty` | **Date**: 2026-09-08

Runnable scenarios proving the feature works. Each maps to a success criterion. Run from the
repository root.

**Prerequisites**: a clean working tree and `.highway/tools/tests/run-all.sh` exiting 0, which
D3.1 requires. Record the count — it is 15 today, and will be 16 once the spec-record check lands.

Formats are in [the contract](contracts/tier-honesty-guard.md); structures are in
[the data model](data-model.md).

---

## S1 — `[auto]` has a stated meaning for Layer 0 (SC-001)

```bash
grep -n -A6 -i 'what \[auto\] means\|Tier Definitions\|Enforcement Map' .specify/memory/constitution.md | head -30
```

**Expected**: a statement of what `[auto]` obliges for a rule in that document, and an explicit
note of how it differs from the Layer 1 meaning. If a reader has to infer either, FR-002 and
FR-003 are not met.

---

## S2 — Every `[auto]` rule is mapped or retagged (SC-002)

```bash
bash -c '
source .highway/tools/lib/constitution.sh
C=".specify/memory/constitution.md"
for r in $(con_rule_ids_by_tier "$C" auto); do
  grep -q "^| $r |" <(sed -n "/Enforcement Map/,/^## /p" "$C") \
    && echo "$r mapped" || echo "$r UNMAPPED"
done
'
```

**Expected**: every line reads `mapped`. Any `UNMAPPED` is a rule claiming automation with nothing
recorded behind it.

---

## S3 — Every named test exists (SC-002)

```bash
sed -n '/Enforcement Map/,/^## /p' .specify/memory/constitution.md \
  | awk -F'|' '/^\| D[0-9]/ {gsub(/ /,"",$3); if ($3 != "") print $3}' \
  | while read -r t; do
      [ -f ".highway/tools/tests/$t" ] && echo "OK   $t" || echo "MISSING $t"
    done
```

**Expected**: no `MISSING`. A map row naming a renamed or deleted test is the failure mode most
likely to appear next.

---

## S4 — D5.4 is enforced, not retagged away (SC-006, FR-007)

```bash
.highway/tools/tests/spec-record.test.sh; echo "exit=$? (0 = pass)"
```

**Expected**: exit 0 on the current tree, where `specs/` holds `001` through `014` contiguously.
Then prove the check can fail:

```bash
mkdir -p specs/016-deliberate-gap
.highway/tools/tests/spec-record.test.sh; echo "exit=$? (MUST be nonzero)"
rmdir specs/016-deliberate-gap
```

**Expected**: nonzero, naming the gap. Remove the probe with `rmdir` — do not use version control
to revert, which discarded unrelated uncommitted work during feature 010.

---

## S5 — The guard covers both documents (SC-004)

```bash
.highway/tools/tests/constitution-inventory.test.sh; echo "exit=$? (0 = pass)"
```

Then confirm each document is genuinely covered, one at a time.

**Skills Constitution:**

```bash
cp .highway/governance/constitution.md /tmp/skills.bak
sed -i '' 's|\(^| P6\.5 |.*\)\[agent-checkable\] |\1[auto] |' .highway/governance/constitution.md
.highway/tools/tests/constitution-inventory.test.sh 2>&1 | grep 'Skills Constitution'
cp /tmp/skills.bak .highway/governance/constitution.md
```

**Development Constitution:**

```bash
cp .specify/memory/constitution.md /tmp/dev.bak
sed -i '' 's|\(^| D3\.3 |.*\)\[agent-checkable\] |\1[auto] |' .specify/memory/constitution.md
.highway/tools/tests/constitution-inventory.test.sh 2>&1 | grep 'Development Constitution'
cp /tmp/dev.bak .specify/memory/constitution.md
```

**Expected**: each produces a failure line naming **that** document and the rule. If the
development case produces no output, the guard is still covering one document and FR-010 is not
met.

Restore from the backups, then confirm with `.highway/tools/tests/run-all.sh`.

---

## S6 — A stale map row is caught (FR-011)

```bash
cp .specify/memory/constitution.md /tmp/dev.bak
sed -i '' 's|shipped-tree-independence\.test\.sh|no-such-test.test.sh|' .specify/memory/constitution.md
.highway/tools/tests/constitution-inventory.test.sh 2>&1 | grep 'does not exist'
cp /tmp/dev.bak .specify/memory/constitution.md
```

**Expected**: a failure naming the rule and the missing test.

---

## S7 — The follow-up list is empty (SC-007)

```bash
grep -c 'TODO(' .specify/memory/constitution.md
```

**Expected**: `0`.

---

## S8 — Nothing new reaches the distribution (SC-009)

```bash
a="$(mktemp -d)/a"
.highway/tools/generate-distribution.sh "$a" >/dev/null 2>&1 && echo "builds: yes"
find "$a" -name 'spec-record*' -o -name 'constitution-inventory*' | wc -l
grep -rl 'Enforcement Map' "$a" | wc -l
rm -rf "$a"
```

**Expected**: `builds: yes`, then `0` and `0`. The development constitution and the tests that
enforce it have no business in a recipient's tree.

---

## S9 — The suite passes, nothing weakened (SC-008)

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: all tests pass, count no lower than 16. No assertion removed or loosened.

---

## Cleanup

```bash
rm -f /tmp/skills.bak /tmp/dev.bak
```
