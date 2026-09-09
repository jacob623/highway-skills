# Quickstart: Validating Generated Artifact Correspondence

**Feature**: 016-artifact-correspondence | **Date**: 2026-09-08

How to verify this feature works. Every command is runnable from the repository root.

## Prerequisites

- Bash 3.2.57 or later
- A clean working tree — several checks below compare against committed state

```bash
git status --porcelain | grep -v '^??' || echo "clean"
```

## 1. Baseline

The suite must pass before any change, per `D3.1`.

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: `Summary: N passed, 0 failed`

## 2. The repair is in place

Feature 015 left the library catalog stale. Confirm it is current before D4.7 is enabled — the
MINOR classification of the amendment depends on it.

```bash
T=$(mktemp -d)
cp -R .highway "$T/.highway"
( cd "$T" && .highway/tools/generate-library-catalog.sh >/dev/null )
diff <(grep -vi generated_at .highway/catalog/library-index.json) \
     <(grep -vi generated_at "$T/.highway/catalog/library-index.json") \
  && echo "library catalog: CURRENT"
rm -rf "$T"
```

**Expected**: `library catalog: CURRENT`, and `requirements-inquiry` present in the committed
catalog rather than `"entries": []`.

## 3. The rules are readable

```bash
grep -E '^\| D4\.[567] \|' .specify/memory/constitution.md
grep -E 'D4\.[567]' .specify/memory/constitution.md | grep -i 'test.sh'
```

**Expected**: three rule rows, each tagged `[auto]`, and three Enforcement Map rows naming the
deciding test.

## 4. The check passes on a correct tree

```bash
.highway/tools/tests/adapter-coverage.test.sh && echo "PASS"
```

**Expected**: `PASS`, no output above it.

## 5. The check leaves nothing behind

The guarantee that matters most, because a check that dirties the tree gets disabled.

```bash
before=$(git status --porcelain)
.highway/tools/tests/adapter-coverage.test.sh
after=$(git status --porcelain)
[ "$before" = "$after" ] && echo "tree unchanged" || echo "TREE MODIFIED"
ls -d /tmp/tmp.* 2>/dev/null | wc -l
```

**Expected**: `tree unchanged`, and no growth in temp directory count across repeated runs.

## 6. Failure proofs — the part that actually proves anything

Watching a check pass proves nothing; it may be matching nothing at all. Each proof breaks one
correspondence for `highway-inquiry`, confirms the failure, and restores.

> Each block restores what it broke. Run them one at a time and confirm the tree is clean between.

### P1 — Missing catalog entry

```bash
cp .highway/catalog/index.json /tmp/p1.bak
grep -v 'highway-inquiry' /tmp/p1.bak > .highway/catalog/index.json
.highway/tools/tests/adapter-coverage.test.sh; echo "exit=$?"
cp /tmp/p1.bak .highway/catalog/index.json && rm /tmp/p1.bak
```

**Expected**: `exit=1`, message naming the missing catalog entry. Then clean.

### P2 — Missing adapter

```bash
mv .cursor/rules/highway-inquiry.mdc /tmp/p2.bak
.highway/tools/tests/adapter-coverage.test.sh; echo "exit=$?"
mv /tmp/p2.bak .cursor/rules/highway-inquiry.mdc
```

**Expected**: `exit=1`, message naming `.cursor/rules/highway-inquiry.mdc`.

### P3 — Missing adapter manifest row

```bash
cp .highway/tools/.adapter-manifest /tmp/p3.bak
grep -v 'highway-inquiry' /tmp/p3.bak > .highway/tools/.adapter-manifest
.highway/tools/tests/adapter-coverage.test.sh; echo "exit=$?"
cp /tmp/p3.bak .highway/tools/.adapter-manifest && rm /tmp/p3.bak
```

**Expected**: record the verdict rather than assume it — see the note in
[contracts/correspondence-check.md](contracts/correspondence-check.md). Removing a row for a skill
that still exists is a D4.5 gap, not a D4.6 orphan.

### P4 — Missing distribution manifest row

```bash
cp .highway/tools/.distribution-manifest /tmp/p4.bak
grep -v '.github/skills/highway-inquiry' /tmp/p4.bak > .highway/tools/.distribution-manifest
.highway/tools/tests/adapter-coverage.test.sh; echo "exit=$?"
cp /tmp/p4.bak .highway/tools/.distribution-manifest && rm /tmp/p4.bak
```

**Expected**: `exit=1`, the existing "would not reach users" message.

### P5 — Stale description

The case nothing detected before this feature.

```bash
cp .highway/skills/highway-inquiry/SKILL.md /tmp/p5.bak
sed 's/^description: .*/description: "deliberately stale for proof P5"/' /tmp/p5.bak \
  > .highway/skills/highway-inquiry/SKILL.md
.highway/tools/tests/adapter-coverage.test.sh; echo "exit=$?"
cp /tmp/p5.bak .highway/skills/highway-inquiry/SKILL.md && rm /tmp/p5.bak
```

**Expected**: `exit=1`, message naming the stale catalog. Before this feature this produced
`exit=0`.

### P6 — Orphaned artifact

```bash
mv .highway/skills/highway-inquiry /tmp/p6-skill
.highway/tools/tests/adapter-coverage.test.sh; echo "exit=$?"
mv /tmp/p6-skill .highway/skills/highway-inquiry
```

**Expected**: `exit=1`, with orphans named across the catalog, adapters, and both manifests.

## 7. Vacuity guard

A check that iterates nothing passes silently — the failure this whole feature is about.

```bash
T=$(mktemp -d); cp -R .highway "$T/.highway"; rm -rf "$T"/.highway/skills/*/
( cd "$T" && .highway/tools/tests/adapter-coverage.test.sh; echo "exit=$?" )
rm -rf "$T"
```

**Expected**: `exit=1`, `no skills were found`.

## 8. Final state

```bash
.highway/tools/tests/run-all.sh
git status --porcelain | grep -v '^??' || echo "clean"
grep -o '"name": "[^"]*"' .highway/catalog/index.json
```

**Expected**: all tests pass; tree clean; both `highway-help` and `highway-inquiry` present.
