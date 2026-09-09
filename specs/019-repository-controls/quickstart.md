# Quickstart: Validating Repository Controls

**Feature**: 019-repository-controls | **Date**: 2026-09-08

How to verify this feature works. Every command runs from the project root.

## Prerequisites

```bash
.highway/tools/tests/run-all.sh
git status --porcelain | grep -v '^??' || echo "clean"
```

## 1. The containment boundary holds

The requirement that is not in the original draft, and the one most likely to be implemented
narrowly.

```bash
mkdir -p library/governance/controls
cat > library/governance/controls/CTL000001.md <<'EOF'
---
id: CTL000001
title: Administrative Access Requires MFA
nfrs: []
status: active
---
Administrative access MUST require multi-factor authentication.
EOF

echo "relative path:"; .highway/tools/validate-library.sh library/governance/controls/CTL000001.md 2>&1 | tail -1
echo "absolute path:"; .highway/tools/validate-library.sh "$(pwd)/library/governance/controls/CTL000001.md" 2>&1 | tail -1
```

**Expected**: both decline the file as outside the framework root. Before this feature, the
absolute form was classified as Highway governance content and judged against the Skills
Constitution.

## 2. Fixtures still work — the trap

```bash
.highway/tools/tests/validate-library.test.sh && echo "library tests PASS"
.highway/tools/validate-library.sh .highway/tools/tests/fixtures/library/governance/valid/policy.md 2>&1 | tail -1
```

**Expected**: tests pass, and the fixture is still classified. Fixtures live under `.highway/` but
**not** under `.highway/library/` — an implementation scoped to the latter declines all of them.

## 3. A baseline Highway's own rules would reject is accepted

```bash
for i in $(seq 1 30); do
  printf -- '---\nid: CTL%06d\ntitle: Control %d\nnfrs: []\nstatus: active\n---\nProduction workloads MUST be deployed across at least two availability zones in separate regions with automated failover and documented recovery objectives agreed by the service owner.\n' "$i" "$i" \
    > "library/governance/controls/CTL$(printf '%06d' $i).md"
done
.highway/tools/tests/run-all.sh 2>&1 | tail -2
```

**Expected**: the suite passes. Thirty Controls, each with an uppercase keyword and each over
twenty-five words — content that would fail `P7.4` and `P1.3` if it sat under `.highway/library/`.

## 4. Nothing user-owned reaches a Highway catalog

```bash
.highway/tools/generate-catalog.sh >/dev/null && .highway/tools/generate-library-catalog.sh >/dev/null
grep -c 'CTL0' .highway/catalog/*.json .highway/catalog/*.md
```

**Expected**: `0` in every catalog.

```bash
rm -rf library
git checkout -- .highway/catalog/ 2>/dev/null; echo "cleaned"
```

## 5. Identifiers are never reused

The guarantee that fails silently if the next identifier is computed rather than recorded.

```bash
grep -i 'next' library/governance/controls.md      # before
# add a Control, remove the highest-numbered one, add another
grep -i 'next' library/governance/controls.md      # after
```

**Expected**: the recorded next identifier only ever increases. Removing `CTL000023` does not make
it available again.

## 6. Nothing is destroyed without being named

```bash
# Request a Set that would drop existing Controls, then decline the confirmation.
before=$(find library/governance -type f | sort; md5 -q library/governance/controls.md 2>/dev/null)
# ... perform the declined Set ...
after=$(find library/governance -type f | sort; md5 -q library/governance/controls.md 2>/dev/null)
[ "$before" = "$after" ] && echo "tree unchanged after declined confirmation"
```

**Expected**: every Control that would be lost is named by identifier **and title** before
anything is written, and declining leaves the tree byte-identical. A count alone does not satisfy
this.

## 7. The catalog is deterministic

```bash
cp library/governance/controls.md /tmp/c1
# regenerate without changing any Control
diff /tmp/c1 library/governance/controls.md && echo "identical"
grep -ci 'generated at\|timestamp' library/governance/controls.md
```

**Expected**: `identical`, and `0` timestamps. Unlike Highway's own catalogs, this one carries no
`generated_at`, so staleness is detectable by regeneration.

## 8. The skill is registered completely

The list feature 015 got wrong, now enforced by `D4.5`.

```bash
grep -c 'highway-controls' .highway/catalog/index.json
ls .github/skills/highway-controls .claude/skills/highway-controls .cursor/rules/highway-controls.mdc 2>&1 | grep -c 'highway-controls'
grep -c 'highway-controls' .highway/tools/.adapter-manifest
grep -c 'highway-controls' .highway/tools/.distribution-manifest
.highway/tools/tests/adapter-coverage.test.sh && echo "correspondence: PASS"
```

**Expected**: a catalog entry, three adapters, adapter manifest rows, and **three distribution
manifest rows**. The last is what was missed last time — without it the skill ships its source
while its adapters are silently dropped.

## 9. The skill's own text conforms

```bash
.highway/tools/validate-skill.sh .highway/skills/highway-controls 2>&1 | tail -3
awk '/^## /{s=$0} /MUST/{c++} END{print "MUST-level rules: " c+0 " (cap 12)"}' .highway/skills/highway-controls/SKILL.md
```

**Expected**: `OK ... 0 unchecked`, and a `MUST` count at or under twelve. If it exceeds, the skill
splits along the Set seam — recorded, not resolved by softening an obligation.

## 10. Final state

```bash
.highway/tools/tests/run-all.sh
git status --porcelain | grep -v '^??'
```

**Expected**: all tests pass, and the changed files are the skill, the validator, the new test, the
catalog, the adapters, and the manifests.
