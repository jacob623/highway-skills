# Research: Probe Reachability Correction

**Feature**: 042-probe-reachability-correction | **Date**: 2026-09-10

All findings below were measured against the tree on 2026-09-10. Nothing here is inferred from
reading a task record or a completion report.

---

## R1 — The defect is a missing join, not three missing probes

**Decision**: Treat the root cause as the absent correspondence between the artifact classes a test
declares and the Enforcement Map rules that test is named as deciding.

**Rationale**: `D3.7`'s Observable binds a probe to an artifact *class*. The Enforcement Map binds a
test to a *rule*. Nothing requires the two to meet. A test named as deciding several rules therefore
satisfies `D3.7` by proving any one of them. Measured across all eight mapped test files:

| Test | Declared classes | Rules mapped to it | Reached by a declared probe |
|---|---|---|---|
| `shipped-tree-independence` | `source-document`, `disposable-fixture` | D1.1 | yes |
| `distribution-packaging` | `source-document`, `disposable-fixture` | D1.2, **D4.3** | D1.2 yes; D4.3 partial |
| `generate-agent-adapters` | `generated-artifact` | D4.1 | yes |
| `generate-catalog` | `generated-artifact` | D4.2 | yes |
| `adapter-coverage` | `source-document`, `generated-artifact` | D4.5, D4.6, D4.7 | yes |
| `spec-record` | `disposable-fixture` | D5.4, **D5.5** | D5.4 only |
| `completion-coverage` | `source-document` | **D7.2**, **D7.4** | neither |
| `constitution-inventory` | `source-document` | D3.7 | yes |

Every one of those probes exits non-zero, so the harness reported success in each case.

**Before-state, measured by removal (T003, 2026-09-10).** Each rule's enforcement was removed from
the tree, the owning test's declared probes were run, and the tree restored byte-exact:

| Rule | Enforcement removed | Probe legs run | Result |
|---|---|---|---|
| D4.3 | `check_no_drift` returns 0 immediately | `source-document`, `disposable-fixture` | both still exit 1 — **undetected** |
| D5.5 | `identity_problems` returns 0 immediately | `disposable-fixture` | still exits 1 — **undetected** |
| D7.2 | the `comm -23` missing-id comparison emptied | `source-document` | still exits 1 — **undetected** |
| D7.4 | the `header_count` test replaced with `false` | `source-document` | still exits 1 — **undetected** |

All three edited files verified byte-identical after restoration. This is the four that `SC-002`
requires to fall to zero, established by observation rather than by reading probe source.

**Alternatives considered**: Fixing `D4.3` alone. Rejected once the measurement showed two further
instances — three independent occurrences of one cause is the pattern this repository has paid for
repeatedly, and the spec's clarification record names it.

---

## R2 — The gap is provability, not defencelessness, in three of the four cases

**Decision**: State the finding as "not provable by a declared probe" rather than "not enforced",
because for three of the four rules the enforcement is asserted and does round-trip in normal mode.

**Rationale**: This distinction was nearly overstated in the spec, and the measurement corrects it:

| Rule | Asserted in normal mode? | Evidence |
|---|---|---|
| D5.5 | **Yes**, with a seeded round trip | `spec-record.test.sh` lines 105–120 build `identity_probe_root`, seed a branch mismatch and a placeholder name, and fail if `identity_problems` detects neither |
| D7.2 / D7.4 | **Yes**, extensively | `completion-coverage.test.sh` lines 347–439 drive `coverage_check` through eleven `assert_pass`/`assert_fail` cases including a restore |
| D4.3, untracked directory | Yes | `distribution-packaging.test.sh` lines 193–204 |
| **D4.3, modified file** | **No — asserted in no mode** | No assertion anywhere invokes the generator against a target it produced and then modified |

So only one half of one rule is genuinely undefended. The other three are defended but cannot
demonstrate it to `D3.7`, which is a weaker defect and is recorded as such. Reporting all four as
"unenforced" would be the same over-claim this feature exists to correct.

**Consequence for scope**: `FR-017` (assert the modified-file refusal) is the only requirement that
closes an actual hole. The rest close reporting integrity.

---

## R3 — Class vocabulary is closed, so a class may have to carry two rules

**Decision**: Where a test decides two rules that fall in the same artifact class, one probe seeds
both defects and must fail if either enforcement is removed.

**Rationale**: The probe-mode contract fixes the vocabulary at `source-document`,
`generated-artifact`, `disposable-fixture`, and the harness runs exactly one seeded leg and one
neutralised leg per declared class. `spec-record` decides `D5.4` and `D5.5`, and both are naturally
`disposable-fixture` — its probe builds a synthetic directory tree rather than touching the real
spec record. It therefore cannot declare two separate classes for them. This is the same resolution
the spec's second clarification reached for `D4.3`'s two refusal paths, applied for a different
reason.

**Alternatives considered**:

- *Widen the vocabulary* — would amend the probe-mode contract's interface beyond what this feature
  needs, and a fourth class name invented to dodge a collision is not an artifact class.
- *Route `D5.5` through `source-document`* — a real `spec.md` is a source document, but seeding one
  means editing a completed spec directory, which `D5.1` forbids and whose exception covers only
  `coverage.md`. Rejected on governance grounds, not convenience.

---

## R4 — `completion-coverage` gets a second class, and the contract already sanctions it

**Decision**: Add `disposable-fixture` to `completion-coverage.test.sh`, seeding a defect into the
checked-in coverage fixture rather than into any real feature's record.

**Rationale**: The existing `source-document` probe alters the real completion register, which is
correct for the register-integrity assertions but cannot reach `coverage_check`. `coverage_check`'s
own normal-mode assertions already run against `$FIXTURES/coverage-valid`, a checked-in fixture, so
a probe that seeds a defect there satisfies the probe-mode contract's first behavioural clause
verbatim — *"a `disposable-fixture` probe alters the fixture the test's own run would consume"* —
and needs no new artifact.

**Alternatives considered**: Seeding a real feature's `coverage.md`. `D5.1`'s exception does permit
editing a coverage record, so this is legal, but it puts a real completion record into a
seed-and-restore cycle for no gain in what is proved. Rejected.

---

## R5 — Measured cost of the `D4.3` class, and why the total is left open

**Decision**: State the `D4.3` class cost as measured and the feature's total as open until all
classes exist.

**Rationale**: Measured 2026-09-10 against the real tree:

| Leg | Time | Exit | Message |
|---|---|---|---|
| Seeded, untracked-directory refusal | 0.06s | 1 | names the directory |
| Build a tracked target (prerequisite for the modified-file leg) | 7.82s | 0 | — |
| Seeded, modified-file refusal | 0.07s | 1 | names `.claude/skills/highway-controls/SKILL.md` |
| Neutralised, full build | 7.86s | 0 | — |

One class covering both refusals costs roughly **16s** across its two legs; two classes would cost
roughly 24s, because each would need its own build. The `completion-coverage` `disposable-fixture`
class performs file operations only and should be inexpensive, but it has not been measured, so no
figure for it is recorded here. `spec-record` adds no class and therefore no leg.

**Suite baseline**, six runs on 2026-09-10: **175, 175, 176, 185, 190, 206s**; CPU time stable near
199–203s. The target is 180s. The suite already straddles it before this feature adds anything.

**Re-measured immediately before the first edit (T002, five consecutive runs)**: **172, 173, 174,
176, 191s**, all exit 0. Median 174s. This is the pre-change figure `SC-005`'s comparison is made
against; the earlier six-run set is retained because it is the sample Feature 041's completion claim
was made against.

**Measured after every class was in place (T018)**, each leg timed individually:

| Leg | Exit | Time |
|---|---|---|
| `distribution-packaging.test.sh --probe generated-artifact` | 1 | 7.67s |
| `distribution-packaging.test.sh --probe generated-artifact --neutralise` | 0 | 15.48s |
| `completion-coverage.test.sh --probe disposable-fixture` | 1 | 0.06s |
| `completion-coverage.test.sh --probe disposable-fixture --neutralise` | 0 | 0.07s |
| `spec-record.test.sh --probe disposable-fixture` (broadened) | 1 | 0.04s |
| `spec-record.test.sh --probe disposable-fixture --neutralise` | 0 | 0.03s |
| **Total added or broadened** | — | **23.35s** |

Two corrections to the estimate recorded above. First, the `generated-artifact` class costs
**23.15s**, not the ~16s projected from the first measurement: the neutralised leg runs a full build
of its own on top of the one the seeded leg needs, and the estimate did not account for that. The
figure is reported as measured rather than adjusted downwards. Second, the `completion-coverage` and
`spec-record` legs are together **0.20s** — the guess that they would be inexpensive held, but it is
now a measurement rather than a guess. Effectively the whole added cost of this feature is the two
distribution builds.

**Final suite measurement (T019)**, after the `D4.5`/`D4.6`/`D3.7` corrections were also in place.
Two samples of five consecutive runs, all exit 0:

| Sample | Runs | Range | Median |
|---|---|---|---|
| First, taken immediately after the thirteen removal cycles | 5 | 208, 210, 211, 245, 277s | 211s |
| Second, machine settled | 5 | 204, 209, 210, 210, 211s | 210s |

The settled figure is **204–211s**, median **210s**, against a pre-change median of 174s: **+36s**.
That is more than the 23.35s of added probe legs, and the difference is not explained by a
measurement this feature took — the `adapter-coverage` rewrite runs eight seeded checks where it ran
one, and `constitution-inventory` gained four normal-mode `harness_probe_pair` invocations, but
neither was timed in isolation. The gap is recorded as unexplained rather than attributed.

Two runs of the first sample — 245s and 277s — exceeded the 240s interim ceiling `FR-020` sets. Both
were taken with the machine still under load from the forty-minute removal campaign, and neither
recurred in the settled sample. The ceiling is reported as **held under normal conditions and
breached under load**, which is a weaker claim than "every run falls under 240 seconds" and is the
one the measurement supports.

---

## R6 — The join cannot honestly be made `[auto]` in this feature

**Decision**: Record the rule-to-probe-leg mapping as a contract artifact, derived by measurement,
and do not add or amend a constitution rule.

**Rationale**: Deciding *which* rule a given probe reaches requires reading the probe's intent
against the rule's text. That is semantic, and every mechanical proxy under-detects — the same
reasoning that keeps `D7.1`, `D3.5`, `D3.8` and `D8.1` off the `[auto]` tier. A check that asserted
"each mapped test declares at least as many classes as it has mapped rules" would pass for
`completion-coverage` the moment a second class is added regardless of what that class reaches,
which is a proxy that cannot fail for the defect it names. `FR-015` forbids constitution changes
here, and the spec's fourth clarification recorded elevating the join to `D3.7`'s Observable as a
declined option, not an oversight.

**How the mapping is made falsifiable anyway**: `FR-024` requires each entry to be established by
removing that rule's enforcement from the tree and observing the suite fail — the same round-trip
discipline `D3.4` and `D3.6` already require. A mapping derived by reading probe source and
inferring reach is exactly the unverified claim this feature corrects.

---

## R7 — New probe code may not contain the development-directory tokens

**Decision**: Assemble any `specs` or `.specify` path segment at runtime, following the precedent
already in both files.

**Rationale**: This was nearly recorded for the wrong reason. `.distribution-manifest` reads
`exclude .highway/tools/tests`, so the directory is **not** distributed — but
`shipped-tree-independence.test.sh` scans it anyway, by a second `find` at line 57 added on top of
the manifest-derived set, because feature 010 chose to scan fixtures with no exemption and
narrowing that would weaken the check under `D3.5`. So the constraint holds, and a plan that had
reasoned only from the manifest would have concluded it did not.

The precedent is already in place and was verified: `distribution-packaging.test.sh` writes
`DEV_DIR="spec""s"` at lines 45 and 140, and `completion-coverage.test.sh` writes
`SPEC_DIR="spec""s"` at line 14 and `SPECIFY_DIR=".""specify"` at line 17. New probe code that needs
either path segment must assemble it the same way, or `D1.1` fails on the first run.
