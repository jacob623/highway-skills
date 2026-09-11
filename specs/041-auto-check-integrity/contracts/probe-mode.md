# Contract: Probe Mode

**Implemented by**: every test file named in the Development Constitution's Enforcement Map for an
`[auto]` rule — eight files today.

**Invoked by**: `constitution-inventory.test.sh`, which decides `D3.7`.

---

## Interface

```sh
bash <test>.test.sh                              # normal mode, unchanged
bash <test>.test.sh --probe <artifact-class>     # seed a defect of that class, check, restore
bash <test>.test.sh --probe <class> --neutralise # identical path, seeding skipped
```

`<artifact-class>` is one of `source-document`, `generated-artifact`, `disposable-fixture`, and must
be one the test declares in its `# Artifact classes:` comment.

## Exit-code contract

| Invocation | Required exit | Means |
|---|---|---|
| `--probe <class>` | **non-zero** | The check reported the seeded defect |
| `--probe <class> --neutralise` | **zero** | Without the defect the check is quiet |
| `--probe <undeclared-class>` | **2** | Distinguishable from a check failure; the harness reports a declaration mismatch, not a defect |
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
4. **Restoration never uses version control.** `distribution-packaging.test.sh` records the reason in
   its own header: during feature 010 a revert discarded unrelated uncommitted work. Independently,
   `git` is not in the Declared Toolchain.
5. **Any file created on disk is named with `$$`** and is matched by the sweep in `run-all.sh`.
6. **Probe mode returns before the test's own harness loop.** This matters only for
   `constitution-inventory.test.sh`, which is itself mapped; without the guard it invokes itself
   without bound.

## Harness contract

For each Enforcement Map row naming an `[auto]` rule, `constitution-inventory.test.sh`:

1. Resolves the row's test filename and reads its `# Artifact classes:` declaration.
2. For each declared class, runs `--probe <class>` and requires a non-zero exit.
3. For each declared class, runs `--probe <class> --neutralise` and requires a zero exit.
4. Reports the count of `(rule, class)` pairs exercised, and fails if it is zero.

### Failure messages

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

## Replaces

| Location | Today | After |
|---|---|---|
| `constitution-inventory.test.sh` lines 201–202 | `grep -q '^# Seeded failure probe:'` | Paired probe invocation |
| `constitution-inventory.test.sh` line 222 | `grep -q '^# Artifact classes:'` | The declaration is read and each class is exercised |

The comment lines stay. They become documentation of a probe that runs, rather than the evidence that
one exists.

## Runtime contract

Probe mode runs **only the probed class's check path**, not the whole test. Measured, whole-test
re-runs would add roughly 516s to a 109s suite (research R3). Expensive setup — the two distribution
builds in `distribution-packaging`, the tree copy in `adapter-coverage` — is built once and reused
across that test's probes.

**Budget**: the full suite stays under 180s, measured before and after. If exceeded, probe scope is
reduced and the reduction is recorded rather than the budget restated.
