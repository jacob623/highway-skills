# Quickstart: Validating Experience Standard Enforcement

**Feature**: 018-experience-enforcement | **Date**: 2026-09-08

How to verify this feature works. Every command runs from the repository root.

## Prerequisites

```bash
.highway/tools/tests/run-all.sh
git status --porcelain | grep -v '^??' || echo "clean"
```

## 1. The merged inventory reaches the summary

```bash
.highway/tools/validate-skill.sh .highway/skills/highway-help 2>&1 | tail -5
```

**Expected**: the five groups, with `X` ids present. `UNCHECKED:` is empty.

Count what landed where:

```bash
for g in CHECKED DEFERRED UNCHECKED; do
  echo -n "$g X-rules: "
  .highway/tools/validate-skill.sh .highway/skills/highway-help 2>&1 \
    | grep "^$g:" | grep -oE '\bX[0-9]+\.[0-9]+\b' | wc -l | tr -d ' '
done
```

**Expected**: `UNCHECKED` is `0`. `CHECKED` is the measured automated count — 1, possibly 2. Do not
adjust the check to raise this number.

## 2. Every X rule is accounted for

```bash
standard=.highway/governance/experience-standard.md
all=$(grep -oE '^\| X[0-9]+\.[0-9]+' "$standard" | awk '{print $2}' | sort -u)
seen=$(.highway/tools/validate-skill.sh .highway/skills/highway-help 2>&1 \
        | grep -oE '\bX[0-9]+\.[0-9]+\b' | sort -u)
echo "in standard: $(echo "$all" | wc -l | tr -d ' ')   in summary: $(echo "$seen" | wc -l | tr -d ' ')"
comm -23 <(echo "$all") <(echo "$seen")
```

**Expected**: equal counts, and no output from `comm` — nothing in the standard is missing from the
summary.

## 3. The library validator is unaffected

The scoping decision this feature turns on.

```bash
.highway/tools/validate-library.sh .highway/library/templates/requirements-inquiry.md 2>&1 | tail -2
.highway/tools/validate-library.sh .highway/library/templates/requirements-inquiry.md 2>&1 \
  | grep -c 'X[0-9]\.[0-9]'
```

**Expected**: exit 0, and **`0`** `X` rule ids. Library content emits nothing; `X` rules must never
reach it.

## 4. The vacuity assertion actually fires

The check that matters most, because its absence is invisible.

```bash
cp .highway/tools/lib/constitution.sh /tmp/con.bak
sed -i '' 's/\[PX\]/[Z]/' .highway/tools/lib/constitution.sh    # match nothing
.highway/tools/tests/constitution-inventory.test.sh 2>&1 | head -3
cp /tmp/con.bak .highway/tools/lib/constitution.sh && rm /tmp/con.bak
.highway/tools/tests/constitution-inventory.test.sh >/dev/null 2>&1 && echo "restored: PASS"
```

**Expected**: with the pattern broken the test **fails**, naming that it matched no rules. If it
passes, the guard is vacuous and the whole inventory guarantee is worthless — this is the exact
failure feature 014 hit.

## 5. An ungrouped rule fails the inventory

```bash
cp .highway/governance/experience-standard.md /tmp/std.bak
printf '| X9.9 | A placeholder MUST exist. | Nothing. | [auto] |\n' >> .highway/governance/experience-standard.md
.highway/tools/tests/constitution-inventory.test.sh 2>&1 | head -3
cp /tmp/std.bak .highway/governance/experience-standard.md && rm /tmp/std.bak
```

**Expected**: fails naming `X9.9` — tagged `[auto]` with no registered check, so it lands in
`UNCHECKED`.

## 6. The specimen check catches the drift it was written for

The defect that exists today.

```bash
grep -m1 '  version:' .highway/skills/highway-help/SKILL.md
awk '/^## Example/{f=1} f' .highway/skills/highway-help/SKILL.md | grep -m1 '^Version:'
```

**Before the repair**: `3.0.2` and `Version: 3.0.1` — they disagree.

**After the repair and with the check enabled**, break it again to prove the check reads what it
claims:

```bash
cp .highway/skills/highway-help/SKILL.md /tmp/help.bak
sed -i '' 's/^Version: 3\.0\.2/Version: 9.9.9/' .highway/skills/highway-help/SKILL.md
.highway/tools/validate-skill.sh .highway/skills/highway-help 2>&1 | grep -E 'ERROR|FAILED' | head -2
cp /tmp/help.bak .highway/skills/highway-help/SKILL.md && rm /tmp/help.bak
.highway/tools/validate-skill.sh .highway/skills/highway-help >/dev/null 2>&1 && echo "restored: PASS"
```

**Expected**: fails naming the field and both values; passes once restored.

## 7. Skills declare their X coverage

```bash
for d in .highway/skills/*/; do
  echo -n "  $(basename "$d"): "
  awk '/^## Verification/{f=1;next} /^## /{f=0} f' "$d/SKILL.md" \
    | grep -oE '\bX[0-9]+\.[0-9]+\b' | tr '\n' ' '
  echo
done
```

**Expected**: each names the `X` rules its self-check exercises, and every id resolves in the
standard.

## 8. Artifacts current and suite green

```bash
.highway/tools/tests/adapter-coverage.test.sh && echo "artifacts current"
.highway/tools/tests/run-all.sh
git status --porcelain | grep -v '^??'
```

**Expected**: `D4.7` discharged after regeneration, all tests pass, and the changed files are the
loader, the registry, the validator, the inventory test, the standard, both skills, and the
regenerated catalog and adapters.
