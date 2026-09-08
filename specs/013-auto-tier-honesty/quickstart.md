# Quickstart: Validating Auto-Tier Honesty

**Feature**: `013-auto-tier-honesty` | **Date**: 2026-09-08

Runnable scenarios proving the feature works. Each maps to a success criterion. Run from the
repository root.

**Prerequisites**: a clean working tree and `.highway/tools/tests/run-all.sh` exiting 0, which
D3.1 requires before any change begins. Record the count — it is 15 today.

Format details are in [the contract](contracts/coverage-summary.md); the structures involved are
in [the data model](data-model.md).

---

## S1 — The unchecked group is empty (SC-001)

The single clearest indicator that the feature worked:

```bash
.highway/tools/validate-skill.sh .highway/skills/highway-help | grep '^UNCHECKED:'
```

**Expected**: `UNCHECKED:` with nothing after it. Before this feature it reads
`UNCHECKED: P2.3 P6.4`.

---

## S2 — Every `[auto]` rule has a check (SC-002)

```bash
bash -c '
source .highway/tools/lib/constitution.sh
source .highway/tools/lib/rule-checks.sh
auto="$(con_rule_ids_by_tier "$(con_file)" auto | sort)"
reg="$(rc_registered_ids | tr " " "\n" | sort)"
echo "tagged auto but unregistered: [$(comm -23 <(echo "$auto") <(echo "$reg") | tr "\n" " ")]"
'
```

**Expected**: `[]`. Any id listed here is a rule promising automation it does not have.

---

## S3 — The check is dispatched, not merely written (FR-004)

The mistake this catches shipped once already: a check that exists, passes its own tests, and is
never called.

```bash
bash -c 'source .highway/tools/lib/rule-checks.sh; echo "P6.4 -> $(rc_check_fn P6.4)"'
```

**Expected**: `P6.4 -> rc_check_P6_4`. If this is empty while the suite is green, the registry row
was added with the wrong indentation — it is a **two-tab** heredoc.

---

## S4 — The check can fail, and names the token (SC-004, FR-010)

```bash
tmp="$(mktemp -d)/skill"; mkdir -p "$tmp"
cp -R .highway/skills/highway-help/. "$tmp/"
# Seed a prohibited time reference into a decision-criteria section.
sed -i '' 's|^## When to use$|## When to use\n\nUse this skill when the catalog is currently stale.|' "$tmp/SKILL.md"
.highway/tools/validate-skill.sh "$tmp"; echo "exit=$? (MUST be 1)"
rm -rf "$tmp"
```

**Expected**: exit 1, with a line reporting `[P6.4]` and naming `currently`. A check never
observed rejecting anything proves nothing about what it accepts.

---

## S5 — P2.3 is deferred, not unchecked (FR-003)

```bash
.highway/tools/validate-skill.sh .highway/skills/highway-help | grep '^DEFERRED:' | grep -o 'P2\.3'
```

**Expected**: `P2.3`. Its tier now says a judgement is required, which is true, rather than
claiming an automation that does not exist.

---

## S6 — Library files are not judged by a skill rule (FR-011)

```bash
.highway/tools/validate-library.sh .highway/library/templates/*.md 2>&1 | grep '^N/A:'
```

**Expected**: `P6.4` appears among the exemptions, and no library file fails P6.4. A library file
has no decision-criteria sections; judging it against a rule about them would fail authors for
content the rule was never written to govern.

---

## S7 — No pre-existing verdict changed undeliberately (SC-005)

```bash
for f in .highway/tools/tests/fixtures/*/; do
  .highway/tools/validate-skill.sh "$f" >/dev/null 2>&1
  echo "$(basename "$f"): exit=$?"
done
```

**Expected**: identical to the recorded pre-change results. A fixture asserting exactly one
failure must still produce exactly one. Compare against the table recorded during implementation,
per D3.4 — do not verify this from memory.

---

## S8 — The regression guard works (SC-008)

```bash
cp .highway/governance/constitution.md /tmp/constitution.bak
sed -i '' 's|^| P3.1 \(.*\)\[agent-checkable\] |&|' /dev/null 2>/dev/null || true
# Retag one agent-checkable rule to [auto] without adding a check.
sed -i '' 's|\(^| P3\.1 |.*\)\[agent-checkable\] |\1[auto] |' .highway/governance/constitution.md
.highway/tools/tests/constitution-inventory.test.sh; echo "exit=$? (MUST be nonzero)"
cp /tmp/constitution.bak .highway/governance/constitution.md
```

**Expected**: nonzero, naming `P3.1`. Then confirm restoration with
`.highway/tools/tests/run-all.sh`.

> Restore from the backup copy. Do **not** use version control to revert the constitution — during
> feature 010 that discarded unrelated uncommitted work in the same file.

---

## S9 — The follow-up list is empty (SC-006)

```bash
grep -c 'TODO(' .highway/governance/constitution.md
```

**Expected**: `0`.

---

## S10 — The suite passes, nothing weakened (SC-007)

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: all tests pass, count no lower than 15. No assertion removed or loosened.

---

## S11 — The distribution still builds

The constitution ships, so a change to it must survive packaging:

```bash
d="$(mktemp -d)/dist"; .highway/tools/generate-distribution.sh "$d"; echo "exit=$?"; rm -rf "$d"
```

**Expected**: exit 0, three `PASS:` lines. In particular the distribution's own validator must
still succeed using only what the distribution contains — the new token list is inside the
constitution, which ships, so nothing new is required.
