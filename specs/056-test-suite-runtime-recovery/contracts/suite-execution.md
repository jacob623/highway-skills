# Contract: Suite Execution

**Requirements**: FR-010, FR-011, FR-013, FR-014, FR-021 | **Success criteria**: SC-008, SC-009,
SC-011

Governs how the suite schedules work and how it emits output. Nothing here changes what any test
decides; it changes only when legs run and when their output is printed.

---

## Scope of concurrency

Concurrency is confined to **within `constitution-inventory.test.sh`**, across its twenty probe
legs. `run-all.sh` continues to run test files **one at a time**.

**Rationale**: `run-all.sh` opens with a residue sweep that deletes PID-named probe artifacts. If
test files ran concurrently, the sweep and a live probe would share a window, and FR-014 would need
a locking scheme the Declared Toolchain does not support well. The measured gain does not require
it — the legs are where the 111.75s sits.

**Consequence**: FR-014 is satisfied structurally. The sweep never runs while a leg is live,
exactly as today.

## Worker count — DEFERRED, not in force

> **Descoped 2026-09-20 and carried to `governance-plan.md` Phase 16.** Nothing in this section or
> in "Serial mode" below is implemented. The suite executes every leg serially in a fresh process,
> exactly as it did before this feature. `HIGHWAY_TEST_WORKERS` **does not exist** and setting it
> has no effect. The `getconf` Declared Toolchain amendment was reverted, so the core-derived
> default described here is **not currently permitted under D2.2**. The design below is retained as
> the starting point for Phase 16, which must re-verify it rather than adopt it.

Resolved 2026-09-20 under resolution R3. ~~`getconf` was added to the Declared Toolchain
(`.specify/memory/constitution.md` 2.0.0 → 2.1.0), so a core-derived default is permitted under
D2.2.~~ *(Reverted — the constitution is back at 2.0.0.)*

| Condition | Workers |
|---|---|
| `HIGHWAY_TEST_WORKERS` set to *n* ≥ 1 | *n* |
| Unset, `getconf _NPROCESSORS_ONLN` reports *c* ≥ 1 | *c* |
| Unset, `getconf` reports 1, or empty, or a non-numeric value | 1 — identical to serial mode |

**The fallback is a supported mode, not a degraded one.** FR-021 already requires serial execution
be indistinguishable in output and exit code from a concurrent run, so a platform where core
detection fails loses speed and nothing else.

`HIGHWAY_TEST_WORKERS` must be validated as a positive integer; any other value is an error naming
the variable and the value, never a silent fallback. A typo that quietly halves the machine would
make FR-003's recorded worker count a fiction.

Dispatch uses `xargs -P <workers>`. `xargs` is in the Declared Toolchain; `-P` is accepted by both
GNU findutils and BSD/macOS `xargs` and was confirmed on the reference machine. Bash 3.2 has no
`wait -n`, so a hand-rolled pool would busy-poll.

**D2.3 obligation carried into the task phase**: `_NPROCESSORS_ONLN` is a non-POSIX operand. It is
accepted by both glibc and Apple/BSD `getconf` and returns 6 on the reference machine; it must be
confirmed on Linux rather than assumed, alongside `xargs -P`.

## Serial mode (FR-021) — DEFERRED, not in force

~~`HIGHWAY_TEST_WORKERS=1` runs every leg sequentially.~~ Serial execution is currently the only
mode, reached by there being no other, which is not the same as having been implemented.

**Obligation**: a serial run and a concurrent run over the same tree produce **the same exit code**
and **the same output**, once reported durations are masked (SC-011). Serial mode is not a
degraded path — it is the same code with a pool size of one.

## Output ordering (FR-011)

1. Each leg writes to its own scratch file. Nothing is written to the terminal while legs run.
2. On completion, buffers are replayed **in Enforcement Map order** — the order the rows appear in
   `.specify/memory/constitution.md` — not in completion order.
3. Each buffer is replayed whole. No interleaving at any granularity.
4. Buffers are removed by `trap ... EXIT`, on both the pass and fail paths.

**Obligation (SC-009)**: the suite's full output after this feature is byte-identical to its output
before, once durations are masked. This is checked by `diff`, not by reading:

```sh
mask() { sed -E 's/[0-9]+\.[0-9]+s/T/g; s/[0-9]+ seconds/T/g; s#(/T//[A-Za-z0-9_.-]*\.)[A-Za-z0-9]{6}/#\1XXXXXX/#g'; }
bash .highway/tools/tests/run-all.sh 2>&1 | mask >/tmp/after.txt
diff /tmp/before.txt /tmp/after.txt        # must be empty
```

`/tmp/before.txt` is captured in Phase A, before the first edit. If it is not captured first it
cannot be reconstructed, which is why FR-001 sequences measurement ahead of change.

The mask has three rules, not two. The third normalises the six-character random suffix `mktemp`
gives a scratch directory, which `highway-setup.test.sh` prints inside four expected failure
messages. It differs on every run of the *unchanged* suite, so leaving it unmasked would make the
diff report a difference that is not one. Masking it is not a loosening: the surrounding path,
the message text and the line's position are all still compared exactly.

**Cost accepted**: progress no longer streams live during the harness. For a run under three
minutes this is a fair trade for a claim that can be checked mechanically.

## Serialized groups (FR-010)

Legs that mutate a file another leg reads **must** declare a shared group. Legs in a group never
overlap; distinct groups and ungrouped legs may run concurrently.

| Group | Members | Shared state |
|---|---|---|
| `generate-catalog-source` | `constitution-inventory --probe source-document` (both modes); `generate-catalog --probe generated-artifact` (both modes) | `generate-catalog.test.sh`, copied, perturbed three times and restored in place by the former |

**This table is the declaration FR-010 requires.** A future leg that mutates a shared file adds a
row here. Discovering the constraint through an intermittent failure instead is the outcome this
table exists to prevent.

## Exit codes (FR-013)

Unchanged.

| Condition | `run-all.sh` exit |
|---|---|
| Every test passes | 0 |
| Any test fails | 1, with `Failed tests:` listing each failing file by name |

Leg exit codes keep the probe-mode contract's values: seeded non-zero, neutralised zero, undeclared
class 2. A leg that fails to start is a failure, never a skip.

## Residue (FR-014)

| Obligation | How it holds |
|---|---|
| The sweep must not remove an artifact a live leg is using | The sweep runs before any test file starts; no leg is live |
| Residue from an interrupted run must still be removed | Sweep patterns unchanged |
| New scratch files must be swept | Leg buffers are named with `$$` and match the existing patterns |

## Failure messages

Unchanged from the probe-mode contract's table. Under concurrency each message still arrives whole,
in Map order, naming its rule id, test file and class.

| Condition | Message |
|---|---|
| `HIGHWAY_TEST_WORKERS` is not a positive integer | `FAIL: HIGHWAY_TEST_WORKERS must be a positive integer, got: <value>` |
| Probe exits zero | `FAIL: <rule> probe for <class> did not fail on a seeded defect: <test>` |
| Neutralised probe exits non-zero | `FAIL: <rule> probe for <class> fails without a seeded defect: <test>` |
| Undeclared class (exit 2) | `FAIL: <rule> test probes a class it does not declare: <test> -> <class>` |
| Test has no probe mode | `FAIL: <rule> test does not implement probe mode: <test>` |
| Zero pairs exercised | `FAIL: no rule/class pairs were exercised; the harness matched nothing` |

## Out of scope

Test discovery order, the two tests `run-all.sh` deliberately runs last
(`readiness-executable.test.sh`, `highway-setup-executable.test.sh`), and the summary block. All
unchanged.
