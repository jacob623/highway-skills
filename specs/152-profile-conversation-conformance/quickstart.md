# Quickstart: Validating Feature 152

How to run and interpret the checks for this feature. All paths are relative to the repository root.

---

## Before the first edit (D3.1)

```bash
bash .highway/tools/tests/run-all.sh
```

Must pass. Record the pass count; it is the baseline the completion report compares against.

---

## ⚠️ Known trap — invoke tests with `bash`, never `./`

About thirty test files in `.highway/tools/tests/` are **not executable**. Running `./some.test.sh`
returns rc=126 in roughly 20 ms, which reads like a fast pass if you are only watching for output.

```bash
# wrong — exits 126, looks like success
./.highway/tools/tests/feature-152-profile-conversation-conformance.test.sh

# right
bash .highway/tools/tests/feature-152-profile-conversation-conformance.test.sh
```

---

## Running this feature's test

```bash
bash .highway/tools/tests/feature-152-profile-conversation-conformance.test.sh
```

Exit 0 passes. Any failure names the specific assertion — the rule row, the gate bullet, or the
point-of-use site that is missing.

### Seeded probe (D3.7)

The test declares two artifact classes, and the probe must be able to fail for each:

```bash
# must exit non-zero — defect is seeded
bash .highway/tools/tests/feature-152-profile-conversation-conformance.test.sh --probe source-document
bash .highway/tools/tests/feature-152-profile-conversation-conformance.test.sh --probe generated-artifact

# must exit 0 — identical path, unseeded
bash .highway/tools/tests/feature-152-profile-conversation-conformance.test.sh --probe source-document --neutralise
bash .highway/tools/tests/feature-152-profile-conversation-conformance.test.sh --probe generated-artifact --neutralise
```

An undeclared class must exit 2. The working pattern is in
`.highway/tools/tests/generate-agent-adapters.test.sh` lines 9–52.

---

## Verifying SC-004 by hand

SC-004 requires that removing the rule row, the gate bullet, or **any single** point-of-use site
fails the test by name. Verify the third clause explicitly, because it is the one a reference-based
implementation can silently defeat:

```bash
cp .highway/skills/highway-profile/SKILL.md /tmp/profile.bak

# delete the capture heading from exactly one of the four domains, then:
bash .highway/tools/tests/feature-152-profile-conversation-conformance.test.sh   # must fail

cp /tmp/profile.bak .highway/skills/highway-profile/SKILL.md
```

If the test still passes with one site removed, the site-count assertion is missing or wrong.

---

## After editing any SKILL.md (D4.4, D4.7)

A skill document is a generator input. Re-run every declared generator; none may leave a diff:

```bash
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-instructions.sh
.highway/tools/generate-library-catalog.sh

git status --short
```

`generate-agent-adapters.sh` exits 0 when all adapters are current, and exits 1 on a validation
failure (writing no partial set) or on a hand-edited target, which it names.

Confirm the four adapter trees are byte-identical to source:

```bash
for tree in .github .claude .cursor .agents; do
  cmp -s .highway/skills/highway-profile/SKILL.md "$tree/skills/highway-profile/SKILL.md" \
    && echo "$tree ok" || echo "$tree DIFFERS"
done
```

---

## Counter updates to confirm

```bash
# rule total — expect 59 after the amendment
grep -cE '^\| X[0-9]+\.[0-9]+ \|' .highway/governance/experience-standard.md

# every site that still asserts the old total — expect no output when done
grep -rn 'ne 49' .highway/tools/tests/

# every site that still asserts an old version string — expect no output when done
grep -rn '10\.0\.0' .highway/tools/tests/
```

Five sites assert the rule count; eight assert the Profile version; two assert the standard's
version. All are enumerated in the plan.

---

## P7.5 word budget (tracked risk)

Several Profile sections gain text, and P7.5 caps a normative section at 400 words. Measure before
and after for `#### Domain completeness`, each of the four domain subsections, `## Readiness`, and
`## Operations`.

```bash
awk '/^#### Domain completeness/,/^#### Cross-domain reasoning/' \
  .highway/skills/highway-profile/SKILL.md | wc -w
```

If any section exceeds 400, the single-definition approach in Research D2 has not been applied
tightly enough — do not resolve it by splitting a section, which would break assertions in eight
other tests.

---

## Before the final commit (D3.2)

```bash
bash .highway/tools/tests/run-all.sh
```

Must pass, with a count greater than the baseline by the number of assertions added.

---

## What this validation does **not** establish

Every check here is a static document contract. None of it is evidence that any of the thirteen
behaviors occurs in a real conversation. D3.8 forbids recording it as such, and the spec's Evidence
boundary states this in the artifact itself. The completion report must state requirement coverage
separately from check results, per D7.3.
