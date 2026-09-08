# Quickstart: Validating Distribution Packaging

**Feature**: `012-distribution-packaging` | **Date**: 2026-09-08

Runnable scenarios proving the feature works end to end. Each maps to a success criterion. Run
from the repository root.

**Prerequisites**: a clean working tree and a passing suite — `.highway/tools/tests/run-all.sh`
exits 0. D3.1 requires this before any change begins.

Interface details are in [the command contract](contracts/generate-distribution.md); file formats
are in [the data model](data-model.md).

---

## S1 — Produce a distribution in one step (SC-001)

```bash
dist="$(mktemp -d)/highway"
.highway/tools/generate-distribution.sh "$dist"
```

**Expected**: exit 0, ending `distribution accepted:`. Three `PASS:` lines appear. No prompt and
no manual file selection.

---

## S2 — Every path is classified (SC-002)

```bash
.highway/tools/generate-distribution.sh "$(mktemp -d)/d" 2>&1 | grep -c 'unclassified'
```

**Expected**: `0`. Then confirm the failing direction is real:

```bash
touch newfile.md
.highway/tools/generate-distribution.sh "$(mktemp -d)/d"; echo "exit=$?"
rm -f newfile.md
```

**Expected**: exit 1, naming `newfile.md` as unclassified. An unclassified path must fail rather
than default to either classification.

---

## S3 — No development-only references reach a user (SC-003)

```bash
grep -rF -e '.specify/' -e 'specs/' "$dist" | wc -l
```

**Expected**: `0`.

---

## S4 — Cross-references resolve (SC-004)

Covered by the second `PASS:` line in S1. To confirm independently, check that the front page's
targets exist inside the distribution:

```bash
ls "$dist/README.md" && grep -o '](\([^)]*\))' "$dist/README.md"
```

**Expected**: the front page exists at the distribution root — not the repository's own — and
every listed target resolves inside `$dist`.

---

## S5 — The distribution validates itself (SC-005)

The point of this scenario is that the command comes from **inside** the distribution:

```bash
(cd "$dist" && env -u CONSTITUTION_FILE ./.highway/tools/validate-skill.sh .highway/skills/highway-help)
echo "exit=$?"
```

**Expected**: exit 0. Nothing from the repository participates. Now prove the check is meaningful
rather than vacuous:

```bash
cp -R "$dist" "${dist}-broken" && rm -rf "${dist}-broken/.highway/governance"
(cd "${dist}-broken" && env -u CONSTITUTION_FILE ./.highway/tools/validate-skill.sh .highway/skills/highway-help)
echo "exit=$?"
```

**Expected**: nonzero. A distribution missing its governing document must fail. If this exits 0,
the verification is resolving something from outside the distribution and FR-009a is not met.

---

## S6 — Two runs are byte-identical (SC-006)

```bash
a="$(mktemp -d)/a"; b="$(mktemp -d)/b"
.highway/tools/generate-distribution.sh "$a"
.highway/tools/generate-distribution.sh "$b"
diff -r -x '.distribution-record' "$a" "$b"; echo "exit=$?"
```

**Expected**: exit 0, no output. The record is excluded because its content is a function of the
files already compared.

---

## S7 — Regressions fail the suite, not the user (SC-007, SC-008)

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: all tests pass, with the packaging test among them. Then confirm the test is capable
of failing:

```bash
printf 'see specs/001-multi-agent-skill-suite/spec.md\n' > .highway/tools/probe.tmp
.highway/tools/tests/run-all.sh; echo "exit=$?"
rm -f .highway/tools/probe.tmp
```

**Expected**: nonzero, naming `probe.tmp`. Remove the probe afterward.

> Use `rm` on the probe. Do not use `git checkout` to revert it — during feature 010 that reverted
> unrelated uncommitted work in the same file. Recorded here because the mistake is easy to repeat.

---

## S8 — Overwrite refusal (FR-013)

```bash
guard="$(mktemp -d)/guard"; mkdir -p "$guard"; echo "hand-authored" > "$guard/notes.md"
.highway/tools/generate-distribution.sh "$guard"; echo "exit=$?"
cat "$guard/notes.md"
```

**Expected**: exit 1 with a refusal naming the directory, and `notes.md` still reading
`hand-authored`. The step must never destroy a directory it did not produce.

---

## S9 — The decision is recorded (SC-009)

```bash
grep -n 'Decision recorded' governance-plan.md
```

**Expected**: the component-scope decision and its reasoning are present, including why
runtime-only was recorded first and then reversed.

---

## Cleanup

```bash
rm -rf "$dist" "${dist}-broken" "$a" "$b" "$guard"
```
