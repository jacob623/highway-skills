# Contract: Probe Mode (superseding)

**Supersedes**: `specs/041-auto-check-integrity/contracts/probe-mode.md`, in full. That document is
not edited — `D5.1` forbids editing a completed feature's directory — and this one carries the whole
record of what changed, per `D5.3`.

**Implemented by**: every test file named in the Development Constitution's Enforcement Map for an
`[auto]` rule — eight files today, thirteen rows.

**Invoked by**: `constitution-inventory.test.sh`, which decides `D3.7`.

---

## What changed, and what did not

### Unchanged

The CLI, the artifact-class vocabulary, the exit-code contract, the harness's failure messages, and
behavioural clauses 1–6. Nothing Feature 041 established is removed or loosened.

### Changed or added

| # | Element | Before (041) | After (042) |
|---|---|---|---|
| C1 | Coverage obligation | each declared **class** is probed | each declared class is probed **and** each mapped **rule** is reached by at least one leg |
| C2 | `distribution-packaging` classes | `source-document`, `disposable-fixture` | **+ `generated-artifact`** |
| C3 | `completion-coverage` classes | `source-document` | **+ `disposable-fixture`** |
| C4 | `spec-record` probe | seeds a numbering gap only | seeds a numbering gap **and** an identity defect |
| C5 | Multi-rule class | not addressed | a class carrying two rules must fail if **either** enforcement is removed |
| C6 | Runtime claim | "the full suite stays under 180s, measured before and after" | 180s **retained as a target, knowingly unmet**; a **240s interim ceiling** applies until governance Phase 14 |
| C7 | Per-leg cost | not required | each class's cost measured **after all classes exist**, never scaled from another class |
| C8 | Rule/leg mapping | did not exist | required, and **derived by removing enforcement**, not by reading probe source |
| C9 | Mapped-row count in 041's coverage record | twelve | **thirteen** rows across eight files |
| C10 | `D4.3` assertions | untracked-directory refusal only | **both** refusals, with output captured and asserted |

---

## Interface

```sh
bash <test>.test.sh                              # normal mode, unchanged
bash <test>.test.sh --probe <artifact-class>     # seed a defect of that class, check, restore
bash <test>.test.sh --probe <class> --neutralise # identical path, seeding skipped
```

`<artifact-class>` is one of `source-document`, `generated-artifact`, `disposable-fixture`, and must
be one the test declares in its `# Artifact classes:` comment. **The vocabulary is closed.** A
collision between two rules of the same class is resolved by C5, never by inventing a fourth name.

## Exit-code contract

| Invocation | Required exit | Means |
|---|---|---|
| `--probe <class>` | **non-zero** | The check reported the seeded defect |
| `--probe <class> --neutralise` | **zero** | Without the defect the check is quiet |
| `--probe <undeclared-class>` | **2** | Distinguishable from a check failure |
| no arguments | 0 or non-zero | Normal behaviour, unchanged |

**Exit 2 must be distinct.** If an undeclared class exited 1, a test could satisfy the harness by
declaring classes it does not probe.

## Behavioural contract

1. **The probe alters a real artifact of the declared class.** Not a copy the check does not read.
   A `disposable-fixture` probe alters the fixture the test's own run would consume.
2. **The check invoked is the same function the test runs in normal mode.** Not a re-implementation
   and not a subset that happens to look at the seeded field.
3. **Restoration is byte-exact and unconditional**, via `trap ... EXIT`, so it survives a check that
   exits early.
4. **Restoration never uses version control.** During feature 010 a revert discarded unrelated
   uncommitted work; independently, `git` is not in the Declared Toolchain.
5. **Any file created on disk is named with `$$`** and is matched by the sweep in `run-all.sh`.
6. **Probe mode returns before the test's own harness loop.** This matters for
   `constitution-inventory.test.sh`, which is itself mapped; without the guard it recurses.
7. **(C1) Every mapped rule is reached.** For each Enforcement Map row naming a test, at least one of
   that test's probe legs must fail when *that row's* rule enforcement is removed. A test deciding
   several rules does not discharge its obligation by proving one.
8. **(C5) A class carrying more than one rule seeds every one of them**, and fails if any single
   enforcement among them is removed. Detecting only the union is not detection.
9. **(C9) Defects are seeded and decided one at a time.** A leg that seeds several defects together
   and then asks once whether anything was reported still passes when all but one enforcement is
   deleted. `adapter-coverage.test.sh` seeded four at once, and any one of its four `D4.5` checks
   could be removed with the leg still failing on the other three. Seed, decide, restore, repeat.
10. **(C10) Deciding code is reachable from probe mode.** A check that lives only in a test's inline
    normal-mode body is unreachable by every declared class, whatever the Enforcement Map says.
    `D4.6`'s four orphan loops did, and were extracted into `orphan_problems()` so that probe mode
    and normal mode decide through the same function.
11. **(C11) A check cannot prove the part of itself that carries its own verdict.** A probe leg
    reports a defect by exiting 0, and it is `harness_probe_pair`'s `seeded_exit` branch that turns
    that exit 0 into a failure — so removing that branch silences the report announcing its absence.
    Measured: with it deleted, the suite still exited 0. Such a branch must be asserted through a
    different channel, in normal mode, and the assertion must check the **message** and not only the
    return code: with the exit-2 branch deleted, an undeclared class still reaches the `neutral_exit`
    branch, so a return-code assertion alone leaves it unproved.

## Harness contract

For each Enforcement Map row naming an `[auto]` rule, `constitution-inventory.test.sh`:

1. Resolves the row's test filename and reads its `# Artifact classes:` declaration.
2. For each declared class, runs `--probe <class>` and requires a non-zero exit.
3. For each declared class, runs `--probe <class> --neutralise` and requires a zero exit.
4. Reports the count of `(rule, class)` pairs exercised, and fails if it is zero.

### Failure messages

Unchanged from 041.

| Condition | Message |
|---|---|
| Probe exits zero | `FAIL: <rule> probe for <class> did not fail on a seeded defect: <test>` |
| Neutralised probe exits non-zero | `FAIL: <rule> probe for <class> fails without a seeded defect: <test>` |
| Undeclared class (exit 2) | `FAIL: <rule> test probes a class it does not declare: <test> -> <class>` |
| Test has no probe mode | `FAIL: <rule> test does not implement probe mode: <test>` |
| Artifact modified after the run | `FAIL: <rule> probe for <class> left <path> modified` |
| Zero pairs exercised | `FAIL: no rule/class pairs were exercised; the harness matched nothing` |

**What the harness must never do**: name the defect to seed. That knowledge belongs to the test that
owns the artifact. A harness holding it is the enumerated list Feature 016 removed one level up.

**What the harness cannot do (C8)**: verify clause 7 itself. Which rule a leg reaches is semantic,
and the only mechanical proxy — comparing class count to mapped-rule count — passes for any second
class regardless of what it reaches. Clause 7 is therefore discharged by the mapping artifact below,
and the mapping's honesty rests on how it is derived, not on who reviewed it.

## Mapping contract (C8, new)

A table with one row per `[auto]` Enforcement Map row — thirteen today — recording rule, test, class,
the enforcement removed, whether the suite failed, and which leg detected it.

**Derivation is normative.** Each row is produced by removing that rule's enforcement from the tree,
running the suite, observing the failure, and restoring. A row inferred by reading probe source is
not a row. Reading source is precisely what produced the report this feature corrects.

## Runtime contract (C6, C7)

Probe mode runs **only the probed class's check path**, not the whole test. Expensive setup — the
distribution builds in `distribution-packaging`, the tree copy in `adapter-coverage` — is built once
and reused across that test's probes.

**Measured, 2026-09-10, before this feature adds a leg**: six suite runs at 175, 175, 176, 185, 190,
206s; CPU 199–203s. Re-measured immediately before the first edit, five runs: 172, 173, 174, 176,
191s, median **174s**.

**Measured, 2026-09-10, after every class this feature adds, broadens or repairs**. Two samples of
five consecutive runs, all exit 0:

| Sample | Runs | Range | Median |
|---|---|---|---|
| Taken immediately after the thirteen removal cycles | 5 | 208, 210, 211, 245, 277s | 211s |
| Machine settled | 5 | 204, 209, 210, 210, 211s | 210s |

Settled range **204–211s**, median **210s**, against a pre-change median of 174s: **+36s**.

Per-leg costs, each timed on its own:

| Leg | Exit | Time |
|---|---|---|
| `distribution-packaging --probe generated-artifact` | 1 | 7.67s |
| `distribution-packaging --probe generated-artifact --neutralise` | 0 | 15.48s |
| `completion-coverage --probe disposable-fixture` | 1 | 0.06s |
| `completion-coverage --probe disposable-fixture --neutralise` | 0 | 0.07s |
| `spec-record --probe disposable-fixture` (broadened) | 1 | 0.04s |
| `spec-record --probe disposable-fixture --neutralise` | 0 | 0.03s |
| **Total measured** | — | **23.35s** |

The `generated-artifact` class costs 23.15s, not the ~16s projected from the first measurement: its
neutralised leg runs a full build of its own on top of the one the seeded leg needs. The figure is
reported as measured rather than adjusted. The measured legs account for 23.35s of the 36s rise; the
remaining ~13s is attributable to the `adapter-coverage` rewrite (eight seeded checks where there
was one) and `constitution-inventory`'s four added normal-mode `harness_probe_pair` invocations, but
neither was timed in isolation, so the gap is recorded as unexplained rather than attributed.

**Target**: 180s. **Retained and knowingly unmet** — the suite already straddled it before this
feature and is further from it now. Feature 041's claim that the budget was measured and held is
superseded by the ranges above. Governance plan Phase 14 is the follow-up expected to recover it.

**Interim ceiling**: 240s, in force only until governance plan Phase 14 recovers the runtime. It is
a ceiling, not a second target, and Phase 14's Done-when requires its removal once 180 is met.

**Ceiling status: held under normal conditions, breached under load.** Eight of ten measured runs
fell in 204–211s. Two — 245s and 277s — were taken while the machine was still loaded from the
forty-minute removal campaign and exceeded the ceiling. Both are reported rather than discarded:
selecting the sample to fit the claim is the failure mode this whole feature exists to correct.

**Costing rule (C7)**: each class's cost is measured after all of this feature's classes are in
place. Scaling one class's figure to another is forbidden — the `D4.3` figure is dominated by two
full distribution builds and generalises to nothing.

## Replaces

| Location | Today | After |
|---|---|---|
| `constitution-inventory.test.sh` lines 201–202 | `grep -q '^# Seeded failure probe:'` | Paired probe invocation (041; unchanged) |
| `constitution-inventory.test.sh` line 222 | `grep -q '^# Artifact classes:'` | The declaration is read and each class is exercised (041; unchanged) |
| `specs/041-auto-check-integrity/contracts/probe-mode.md` "Runtime contract" | budget asserted as measured and held | C6 and C7 above |
| `specs/041-auto-check-integrity/contracts/probe-mode.md` header, "eight files today" | class coverage implied rule coverage | C1 and clause 7 |
| Feature 041's completion record, "twelve pairs" | twelve | thirteen (C9) |
