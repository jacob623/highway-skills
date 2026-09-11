# Quickstart: Probe Reachability Correction

**Feature**: 042-probe-reachability-correction | **Date**: 2026-09-10

Everything below was run on 2026-09-10 from the repository root on macOS with the default
`/bin/bash` (3.2.57). Times are wall clock on that machine; reproduce them rather than cite them.

---

## Run one probe leg

```sh
cd .highway/tools/tests
bash distribution-packaging.test.sh --probe source-document            # expect exit 1
bash distribution-packaging.test.sh --probe source-document --neutralise  # expect exit 0
bash distribution-packaging.test.sh --probe no-such-class              # expect exit 2
```

```sh
echo "EXIT=$?"
```

**Expect no output.** Probes print nothing in either state; the exit code is the whole signal. This
is why auditing reach requires reading the probe body, and it is the limitation `FR-017` narrows for
the `D4.3` legs by capturing and asserting the generator's refusal message.

## Run the whole suite and time it

```sh
cd .highway/tools/tests
time bash run-all.sh
```

Baseline before this feature adds a leg: **175, 175, 176, 185, 190, 206s** across six runs. Target
180s; interim ceiling 240s. One run is not a measurement — take at least three and record the range,
because the spread above is wider than the margin being argued about.

## See the defect this feature corrects

`spec-record.test.sh` is mapped to both `D5.4` and `D5.5`. Its probe builds bare directories:

```sh
cd .highway/tools/tests
grep -n 'probe_root' spec-record.test.sh
```

The seeded tree contains no `spec.md`, so `D5.5`'s directory-name-versus-`Feature Branch` comparison
has nothing to read. The probe exits 1 on the numbering gap, the harness records success, and `D5.5`
was never exercised.

Same shape in `completion-coverage.test.sh`: six seeded defects, all routed through
`register_problems`, while `coverage_check` — the function deciding `D7.2` and `D7.4` — is never
called by any leg.

## Establish one mapping row the way `FR-024` requires

Not by reading. By removing:

1. Choose an `[auto]` rule from the Enforcement Map (`.specify/memory/constitution.md`, ~lines
   289–303).
2. Remove that rule's enforcement from the tree — delete the check function's body, or the call.
3. Run `bash run-all.sh`. Record whether it failed and **which leg reported it**.
4. Restore the file byte-exact and re-run to confirm green.

A row whose evidence is step 3's observation is a row. A row whose evidence is "the probe appears to
touch this" is the claim this feature exists to retract.

Thirteen rows. Each cycle costs roughly one suite run, so budget accordingly.

## Confirm the `D4.3` hole before closing it

The untracked-directory refusal is asserted at `distribution-packaging.test.sh` lines 193–204. The
modified-file refusal — `generate-distribution.sh` line 76 — is asserted nowhere. To see it fire:

```sh
cd /Users/…/highway-skills
.highway/tools/generate-distribution.sh /tmp/dist-$$ >/dev/null 2>&1   # ~7.8s, exit 0
printf 'drift\n' >>/tmp/dist-$$/.claude/skills/highway-controls/SKILL.md
.highway/tools/generate-distribution.sh /tmp/dist-$$ 2>&1 | tail -2    # ~0.07s, exit 1
rm -rf /tmp/dist-$$
```

The second run names the modified file and refuses. Nothing in the suite currently requires that.

## Constraints that will bite

| Constraint | Symptom if ignored |
|---|---|
| Literal `specs/` or `.specify/` in `tools/tests/` | `shipped-tree-independence.test.sh` fails — it scans that directory by an explicit `find` at line 57, despite the manifest excluding it |
| `git` used to restore | Violates the probe contract and `D2.x`; feature 010 lost uncommitted work this way |
| File created without `$$` | Escapes `run-all.sh`'s sweep and survives a crash |
| Bash 4 syntax | Silent breakage on the default macOS shell |
| Editing anything under `specs/041-auto-check-integrity/` except `coverage.md` | `D5.1` |
| Amending the constitution | `FR-015` |

## Done means

`bash run-all.sh` exits 0, the mapping has thirteen measured rows, the suite range is recorded rather
than asserted, and the coverage record says thirteen. Green alone is not done — green is what the
report this feature corrects was based on.
