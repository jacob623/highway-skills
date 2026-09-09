# Quickstart: Validating the Highway Experience Standard

**Feature**: 017-experience-standard | **Date**: 2026-09-08

How to verify this feature works. Every command runs from the repository root.

## Prerequisites

```bash
.highway/tools/tests/run-all.sh            # must pass before starting (D3.1)
git status --porcelain | grep -v '^??' || echo "clean"
```

## 1. The document exists and is complete

```bash
ls .highway/governance/experience-standard.md
grep -n '^## ' .highway/governance/experience-standard.md
```

**Expected**: sections for Scope, Non-goals, Precedence, Tier definitions, Rules, Candidates, and
Versioning, plus a Sync Impact Report.

## 2. Every rule is well formed

```bash
grep -cE '^\| X[0-9]+\.[0-9]+ \|' .highway/governance/experience-standard.md
grep -E '^\| X[0-9]+\.[0-9]+ \|' .highway/governance/experience-standard.md \
  | grep -vcE '\[(auto|agent-checkable|human-review)\]'
```

**Expected**: a non-zero rule count, and **0** rows missing a tier tag.

```bash
grep -E '^\| X[0-9]+\.[0-9]+ \|' .highway/governance/experience-standard.md | grep -c '\[auto\]'
```

**Expected**: `0`. No rule is `[auto]` until Phase 6 builds enforcement.

## 3. Exactly one keyword per rule

```bash
grep -E '^\| X[0-9]+\.[0-9]+ \|' .highway/governance/experience-standard.md \
  | awk -F'|' '{n=gsub(/MUST/,"MUST",$3); if (n != 1) print "  " $2 " has " n " keywords"}'
```

**Expected**: no output. `MUST NOT` counts as one keyword.

## 4. No restatement — the central risk

The three nearest collisions, identified in Phase 0. Read each pair and confirm the `X` rule
constrains the *form* of a behaviour rather than requiring the behaviour itself.

```bash
for r in P1.7 P5.2 P4.6; do grep -E "^\| $r \|" .highway/governance/constitution.md; done
grep -E '^\| X[0-9]+\.[0-9]+ \|' .highway/governance/experience-standard.md
```

**Expected**: no `X` rule requires a skill to ask when ambiguous (`P1.7`), to name one of four next
actions (`P5.2`), or to report rather than silently alter (`P4.6`). Those obligations are Layer 1.

## 5. Namespace hygiene

```bash
grep -oE '\bX[0-9]+\.[0-9]+\b' .highway/governance/experience-standard.md | sort | uniq -d
grep -oE '\b[PD][0-9]+\.[0-9]+\b' .highway/governance/experience-standard.md | sort -u
```

**Expected**: no duplicate `X` ids. Any `P` or `D` id present must be a citation, never a
restatement.

## 6. Both skills satisfy every rule

```bash
for d in .highway/skills/*/; do
  echo "--- $(basename "$d") ---"
  awk '/^## Outputs/{f=1} /^## Verification/{f=0} f' "$d/SKILL.md" | grep -oE '\bX[0-9]+\.[0-9]+\b' | tr '\n' ' '
  echo
done
```

**Expected**: each skill lists the `X` ids it satisfies.

Then confirm every cited id resolves:

```bash
for id in $(grep -rhoE '\bX[0-9]+\.[0-9]+\b' .highway/skills/*/SKILL.md | sort -u); do
  grep -qE "^\| $id \|" .highway/governance/experience-standard.md \
    && echo "  $id: resolves" || echo "  $id: MISSING FROM STANDARD"
done
```

**Expected**: every id resolves.

## 7. Skills still validate

```bash
for d in .highway/skills/*/; do
  echo "--- $(basename "$d") ---"
  .highway/tools/validate-skill.sh "$d" 2>&1 | tail -1
done
```

**Expected**: `OK: skill '<id>' is valid` for both, with `0 unchecked`. Watch specifically for
`P7.5` — the citation line adds words to a normative section.

## 8. The Correspondence Gate discharges — `D4.7`

This feature edits two skills, which are generator inputs. Feature 016's rule requires regeneration
in the same change.

```bash
.highway/tools/tests/adapter-coverage.test.sh && echo "artifacts current"
```

**Expected**: `artifacts current`. If it reports a stale catalog or adapter, run
`generate-catalog.sh` and `generate-agent-adapters.sh`, then re-run.

## 9. Shipped-tree independence

```bash
.highway/tools/tests/shipped-tree-independence.test.sh && echo "PASS"
grep -cE '\.specify/|specs/' .highway/governance/experience-standard.md
```

**Expected**: `PASS`, and `0` development-path references.

## 10. Final state

```bash
.highway/tools/tests/run-all.sh
git status --porcelain | grep -v '^??'
grep -oE '"version": "[^"]*"' .highway/catalog/index.json
```

**Expected**: all tests pass; the changed files are the standard, both skills, the catalog, the
adapters, and the adapter manifest; both skill versions show a PATCH increment.
