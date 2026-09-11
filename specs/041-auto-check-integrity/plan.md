# Implementation Plan: Automatic Check Integrity

**Branch**: `041-auto-check-integrity` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/041-auto-check-integrity/spec.md`

## Summary

Every registered `[auto]` check must decide the rule it is named for. Four sites in the tree
currently fail that, and they are one defect wearing four faces: **a check asserts the presence of a
token instead of the property the rule states, so something other than the rule decides the verdict.**

The work is in three movements:

1. **Move the scope declaration out of the checked artifact.** A single completion register at
   `.specify/memory/completion-register.md` states, once, which features are complete and which
   correct an earlier one. `completion-coverage.test.sh` reads it instead of parsing task checkboxes,
   and the constitution's `Completed spec` definition is amended so the rule text and the check agree.
2. **Make the probe rule real.** `constitution-inventory.test.sh` stops grepping for
   `# Seeded failure probe:` and instead runs each mapped test's declared probe, asserting a non-zero
   exit when a defect is seeded and a zero exit when the seeding is neutralised. Five checks fail the
   moment that lands, and all five are given genuine probes in the same change — which is what keeps
   the amendment MINOR.
3. **Bring the records the rules already demand to conformance**, and record the completion claim
   that was reported met and was not.

## Technical Context

**Language/Version**: Bash 3.2.57 — the macOS system shell. No associative arrays, `mapfile`,
`readarray`, `${var^^}`, or `&>>`.

**Primary Dependencies**: None beyond the Declared Toolchain (`awk`, `grep`, `sed`, `sort`, `comm`,
`cut`, `diff`, `mktemp`, `cp`, `rm`, and siblings). **Version control is deliberately excluded** and
must not be used to restore a probe.

**Storage**: Markdown files. The register is a table under `.specify/memory/`.

**Testing**: `.highway/tools/tests/run-all.sh` — 39 test files today.

**Target Platform**: macOS and Linux; every utility flag must work on both.

**Project Type**: Governance tooling for a shell-based skill framework. No application runtime.

**Performance Goals**: The suite measures **109s** today. The probe harness must leave it under
**180s**, measured before and after rather than asserted.

**Constraints**: No second enforcement mechanism. No heuristic that infers a correction relationship.
No edit to a completed spec file other than its `coverage.md`. No amendment to the Highway Skills
Constitution or the Experience Standard.

**Scale/Scope**: 40 feature directories, 39 test files, 13 `[auto]` rule-to-test mappings across 8
test files, 6 rules currently unproven.

## Constitution Check

*Development Constitution v1.5.0. Re-checked after Phase 1 design — verdicts unchanged.*

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | Probes transiently modify `.highway/catalog/` and the adapter trees | **PASS with condition** — D1.1, D1.2, D6.2 |
| **Toolchain Gate** | The change touches files under `.highway/tools/` | **PASS** — D2.1–D2.4 |
| **Validation Gate** | The change modifies validation checks | **PASS with one human-review item** — D3.4, D3.5 |
| **Spec Record Gate** | The change touches directories under `specs/` | **PASS** — D5.1–D5.4 |
| **Generator Gate** | No `generate-*.sh` script is modified | **N/A** |
| **Skill Content Gate** | No file under `.highway/skills/` or `.highway/library/` is modified | **N/A: Skill Content Gate not triggered** |

### Rule-by-rule

| Rule | Verdict | Note |
|---|---|---|
| D1.1 | PASS | The register lives under `.specify/`, which is never distributed. No shipped file gains a development reference. Probes that touch shipped paths restore them within the same run. |
| D1.2 | PASS | Nothing the packaged tree reads is changed. |
| D1.6 | PASS | The register is the declaration this rule's shape calls for: stated once, read by each check that needs it. |
| D2.1 | PASS | No Bash 4 construct. Probe classes are held in a newline-delimited string, not an associative array. |
| D2.2 / D2.4 | PASS | No new utility and no new dependency. |
| D2.3 | PASS | No new flag. |
| D3.3 | PASS | Every behavioural change edits a file under `.highway/tools/tests/`. |
| D3.4 | PASS | The pre-enable measurement is Phase A and precedes every probe. |
| **D3.5** | **HUMAN REVIEW** | Removing the checkbox condition changes an assertion's reach. See Complexity Tracking. |
| D3.6 | PASS | Every new assertion is observed failing before the work it covers is marked complete. That is what the probe harness is. |
| D4.1–D4.7 | PASS | No generated artifact is left modified. Probe restoration is asserted, not assumed. |
| D5.1 | PASS | The register sits outside `specs/`. Only `coverage.md` files are touched under completed directories, which the existing exception permits. |
| D5.2 | PASS | This is a new numbered spec, not an edit to 039 or 040. |
| D5.4 | PASS | 041 follows 040. |
| D7.1 | **Condition** | Feature 038 is registered `complete` with four unchecked tasks. Those tasks must be completed or their shortfall recorded. See research R8. |

### Constitution amendment recorded by this feature

| Change | Location | Classification |
|---|---|---|
| `Completed spec` definition rewritten to name the register | line 239 | MINOR |
| `D7.4` Enforcement Map note: `in-scope` replaced with the register | line 285 | PATCH wording |
| `D3.7` Enforcement Map note rewritten once the check executes probes | line 286 | MINOR |
| Version and Sync Impact Report | lines 2, 12, 482 | 1.5.0 → 1.6.0 |

**The classification is conditional and must be re-decided against the Phase A measurement.** MINOR
holds only because the conformance work lands in the same change. If any of the five probes cannot be
written here, the amendment is MAJOR and that rule is recorded as enabled later — the discipline
Phases 4c, 11 and 12 each applied.

## Project Structure

### Documentation (this feature)

```text
specs/041-auto-check-integrity/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   ├── completion-register.md
│   └── probe-mode.md
├── checklists/
│   └── requirements.md
├── spec.md
└── tasks.md             # /speckit-tasks output, not created here
```

### Source code (repository root)

```text
.specify/memory/
├── constitution.md                 # amended: lines 239, 285, 286, 482, Sync Impact Report
└── completion-register.md          # NEW - the single declared completion status

.highway/tools/tests/
├── run-all.sh                      # extend the suite-level probe sweep (lines 18-25)
├── constitution-inventory.test.sh  # replace two comment greps with executed probes
├── completion-coverage.test.sh     # read the register; drop the checkbox and the 8-name list
├── adapter-coverage.test.sh        # NEW probes for D4.5, D4.6, D4.7
├── generate-agent-adapters.test.sh # NEW probe for D4.1
├── generate-catalog.test.sh        # NEW probe for D4.2
├── shipped-tree-independence.test.sh   # probe mode around its existing real probe
├── distribution-packaging.test.sh      # probe mode around its existing real probes
└── spec-record.test.sh                 # probe mode around its existing real probe

specs/038-readiness-verification-corrections/coverage.md   # header + 8 non-requirement rows
specs/040-historical-coverage-reconstruction/coverage.md   # NEW

governance-plan.md                  # record Phase 12's unmet Done-when
```

**Structure Decision**: No new directory and no new script. The register is one file in an existing
governance location; every other change edits a file that already exists. This is deliberate — the
spec forbids a second enforcement mechanism, and a new `lib/` module deciding probe outcomes would be
one.

## Implementation Phases

### Phase A — Measure before changing anything (D3.4)

Record, against the tree as it stands: which checks pass today, which fail once the comment grep is
replaced, and the suite wall clock. **This number decides the amendment classification** and cannot
be reconstructed afterwards.

### Phase B — The register and the scope it decides

Write `.specify/memory/completion-register.md` with an entry for all 40 directories. Amend the
`Completed spec` definition. Replace `completion-coverage.test.sh`'s directory glob, checkbox
condition, `-ne 3` special case and eight-name corrective list with reads of the register. Add probes
for the register itself: an unregistered directory, an entry naming no directory, a malformed status.

### Phase C — Probe mode

Add `--probe <class>` and `--neutralise` to each of the eight mapped test files. The tests that
already seed real defects are refactored around their existing probes rather than rewritten.

### Phase D — The five missing probes

`D4.1` hand-edit refusal, `D4.2` determinism, `D4.5`/`D4.6`/`D4.7` correspondence and currency using
`highway-inquiry`, and `D3.7`'s own. Each observed failing before it is wired in.

### Phase E — The harness

Replace the two greps at `constitution-inventory.test.sh` lines 201–202 and 222 with the paired probe
invocation. Guard against self-recursion. Extend the sweep in `run-all.sh`.

### Phase F — Records and the corrected claim

Normalise `038/coverage.md`, write `040/coverage.md`, reconcile Feature 038's four unchecked tasks,
and record Phase 12's unmet Done-when in `governance-plan.md` without rewording the original.

**B before C before D before E is not stylistic.** Landing E first turns the suite red for five
tests, and a red suite violates `D3.1` for every subsequent step.

## Complexity Tracking

| Violation | Why needed | Simpler alternative rejected because |
|---|---|---|
| **D3.5 human review** — the checkbox eligibility condition is removed from `completion-coverage.test.sh` | The condition lets a feature exclude itself from `D7.2` and `D7.4` through the same file the check reads. Three directories do so today. | Tightening the parse keeps the scope under the checked artifact's control, which is the defect. **Recorded reason for the superseded behaviour**: the condition implemented the constitution's own `Completed spec` definition at line 239; that definition is amended in the same change, so the assertion is replaced rather than weakened, and its reach grows from 37 directories to 40. |
| Every mapped test gains a probe mode | `D3.7` requires an observed non-zero exit per artifact class. Nothing short of running the check against a defective artifact observes that. | A harness that seeds the defects itself must enumerate them per test and per class — the enumerated-list defect Feature 016 removed. A harness that reads a comment is the defect being replaced. |
| Feature 038 is registered `complete` while four of its tasks are unchecked | It shipped, it is in the corrective set, and excluding it would hide a malformed record behind the same mechanism this feature removes. | Registering it `incomplete` keeps it invisible — the outcome the feature exists to prevent. Its four tasks are reconciled here instead. |

## Risks

| Risk | Mitigation |
|---|---|
| **Partial completion with the boxes ticked.** Phase 12 named this as the failure mode of a change this size, in the feature meant to eliminate it. | Phase A's measurement is a number, not a judgment. Phase E cannot pass until every probe in Phase D is real — the harness fails loudly rather than skipping. |
| Probe residue naming a defect that does not exist. Observed twice already. | PID naming, `trap ... EXIT` in the owning test, and the suite-level sweep. All three, not one. |
| Suite runtime becoming a disincentive to run it | 180s budget, measured. If exceeded, probe scope is reduced and the reduction is recorded. |
| The amendment being MINOR by assertion rather than by measurement | The classification is written after Phase A, not before. |
| A probe left behind in a shipped path reaching a distribution | `distribution-packaging.test.sh` builds and verifies the distribution; a residual probe fails it. |
