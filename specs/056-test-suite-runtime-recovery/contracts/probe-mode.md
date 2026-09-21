# Contract: Probe Mode (superseding)

**Supersedes**: `specs/042-probe-reachability-correction/contracts/probe-mode.md`, in full — which
itself superseded `specs/041-auto-check-integrity/contracts/probe-mode.md`. Neither earlier
document is edited; this one carries the whole record of what changed, per `D5.3`.

**Implemented by**: every test file named in the Development Constitution's Enforcement Map for an
`[auto]` rule — **six files, nine rows, ten declared artifact classes, twenty probe legs**.

**Invoked by**: `constitution-inventory.test.sh`, which decides `D3.7`.

---

## What changed, and what did not

### Unchanged

The CLI, the artifact-class vocabulary, the exit-code contract, the harness's failure messages,
behavioural clauses 1–6, and every obligation Features 041 and 042 established. Nothing is removed
and nothing is loosened. **No probe proves less than it proved.**

### Changed or added

| # | Element | Before (042) | After (056) |
|---|---|---|---|
| C11 | Scope count | "eight files today, thirteen rows" | **six files, nine rows, ten classes, twenty legs** — corrected below |
| C12 | Execution order | every leg serial, in a fresh process | **unchanged — every leg serial, in a fresh process.** Concurrency descoped 2026-09-20 to `governance-plan.md` Phase 16 |
| C13 | Output order | emitted as legs run | buffered per leg, replayed in **Enforcement Map order** |
| C14 | Build reuse | *claimed* ("built once and reused across that test's probes") but not implemented | implemented; assertions needing a fresh tree declare it |
| C15 | Runtime record | 180s retained, knowingly unmet; 240s interim ceiling | recorded below, with the ceiling's disposition |
| C16 | Reported measurement | range and median | range, median, **core count and effective worker count** (worker count is 1 — concurrency deferred) |
| C17 | Serial execution | not addressed | an explicit serial mode exists and must agree with a concurrent run |

---

## Scope correction (C11)

Feature 042 recorded "eight files today, thirteen rows". **That count is no longer true, and was
already untrue when Phase 14 of the governance plan carried it forward.**

Feature 044 removed rules D5.4, D5.5, D7.2 and D7.4 from the Enforcement Map, and the two test
files those rows named (`spec-record.test.sh`, `completion-coverage.test.sh`) went with them. The
Map went from thirteen rows to nine.

**Current, measured by executing every leg — not by reading source:**

| Mapped test file | Declared classes |
|---|---|
| `shipped-tree-independence.test.sh` | `source-document`, `disposable-fixture` |
| `distribution-packaging.test.sh` | `source-document`, `disposable-fixture`, `generated-artifact` |
| `adapter-coverage.test.sh` | `source-document`, `generated-artifact` |
| `generate-catalog.test.sh` | `generated-artifact` |
| `generate-agent-adapters.test.sh` | `generated-artifact` |
| `constitution-inventory.test.sh` | `source-document` (its own) |
| **Total** | **6 files, 10 classes, 20 legs** |

The count was taken by running all twenty legs individually and recording each exit code, because
Feature 042's own rule (C8) is that a mapping derived by reading probe source is not a mapping.

**Re-confirmed 2026-09-20 by execution, not by reading.** The post-change leg sweep ran all twenty
legs across these six files and ten classes, every exit code matched its contract, and the
violation count was zero. Nothing in this table was taken from a declaration in a source file.

## Interface

Unchanged from 042.

```sh
bash <test>.test.sh                              # normal mode
bash <test>.test.sh --probe <artifact-class>     # seed a defect of that class, check, restore
bash <test>.test.sh --probe <class> --neutralise # identical path, seeding skipped
```

The class vocabulary remains closed: `source-document`, `generated-artifact`, `disposable-fixture`.

## Exit-code contract

Unchanged from 041 and 042.

| Invocation | Required exit |
|---|---|
| `--probe <class>` | non-zero |
| `--probe <class> --neutralise` | zero |
| `--probe <undeclared-class>` | 2 |
| no arguments | normal behaviour |

## Harness contract

Clauses 1–4 unchanged. Three added, **all three deferred to `governance-plan.md` Phase 16 and not
in force** — the harness executes every leg serially in a fresh process, unchanged from before this
feature:

5. **(C12)** ~~Legs may execute concurrently under a bounded worker pool. Legs that mutate a file
   another leg reads declare a shared serial group and never overlap. The groups are tabulated in
   [suite-execution.md](suite-execution.md); one exists today.~~ **Deferred.** The "one exists
   today" claim was also verified wrong on 2026-09-20: at least four legs contend. See
   [research.md](../research.md) D5.
6. **(C13)** ~~Each leg's output is buffered and replayed in Enforcement Map order. Concurrency must
   not be visible in the output — a run's output is byte-identical to a serial run's, once
   durations are masked.~~ **Deferred.** Output order is serial order, and was verified unchanged
   against the pre-change run under the same mask.
7. **(C17)** ~~A serial run and a concurrent run over the same tree produce the same exit code and
   the same output.~~ **Deferred** — no concurrent run exists to compare against.

**What the harness must never do**, unchanged and restated because it is the load-bearing clause:
name the defect to seed. That knowledge belongs to the test that owns the artifact.

## Runtime contract

**(C14) Expensive setup is reused.** A distribution build or tree copy is produced once per test
process and shared by every assertion that does not require a freshly produced tree. Assertions
that do — the `D4.3` refusal paths, the drift check — declare it and get their own.

Feature 041 stated this clause and Feature 042 carried it forward. **Neither implemented it**: at
the 2026-09-20 baseline `distribution-packaging.test.sh` performed eleven full builds at 9.61s
each.

> **Recorded 2026-09-20 — this clause is still not implemented as written, and is not claimed to
> be.** Feature 056 examined all eleven builds (T017). Six are in normal mode and five in probe
> mode. Of the six, one is the shared build, one is the second half of DP-10's byte-identical pair
> — two independent builds are what that assertion decides — and four each build a *different*
> seeded repository state. Only DP-18 reuses the shared build, and it already did so before this
> feature. The build count is therefore unchanged at eleven. What changed is the price: a build
> fell from 9.61s to 4s, so the same eleven builds now cost ~44s instead of ~106s. C14 is left
> standing as an unmet clause rather than rewritten to describe what was achieved.

### Measured runtime

| Field | Value |
|---|---|
| Baseline before this feature (sum of per-file serial timings) | 286.50s |
| Baseline before this feature (whole-suite wall clock) | 231–263s, median 233s |
| Range after (five consecutive runs) | 170–287s (170, 171, 174, 185, 287) |
| Median after | 174s |
| Core count / effective workers | 6 / 1 |
| Target status | `retained and unmet` |
| 240s interim ceiling | `retained` |

**(C15) The target was not met, so nothing is closed.** Four of the five runs landed under 180s;
**Target**: 180s, unchanged. **(C15)** If the target is met, the 240s interim ceiling Feature 042
set is removed rather than retained as a second target, and Feature 042's recorded deviation is
closed. **If it is not met, neither happens** — the gains that preserve every probe are kept, the
achieved range is recorded as measured, the target stays at 180s, and the deviation stays open for
a later feature. Amending the target to match an achieved number is prohibited.

**Disposition: the target was not met, so nothing is closed.** Four of the five runs landed under
180s; the fifth took 287s, which breaches Feature 042's 240s interim ceiling as well. That run is
recorded rather than discarded — no load cause was evidenced at the time, so calling it an
artefact would be a guess. A re-measurement on a quiesced machine was deliberately **deferred**;
the range above is the range this feature achieved under the conditions it was measured in.

The median improved, 233s to 174s. The worst observed run did not: 263s to 287s. **The spread
widened.** The improvements are kept, the 180s target stays at 180s, the 240s ceiling stays in
force, and Feature 042's deviation stays open.

**Costing rule**, carried forward unchanged from 042's C7: each class's cost is measured after all
classes are in place, and never scaled from another class.

## Replaces

| Location | Before | After |
|---|---|---|
| 042 contract header, "eight files today, thirteen rows" | thirteen rows across eight files | C11: nine rows, six files, ten classes, twenty legs |
| 042 contract, "Runtime contract" / "Interim ceiling" | 180s unmet; 240s ceiling in force until Phase 14 | C15 |
| 041 and 042, "built once and reused across that test's probes" | stated, not implemented | C14 — **still not implemented**; the eleven builds remain, each cheaper |
| Governance plan Phase 14, "thirteen classes across eight mapped files" | thirteen / eight | ten classes across six files |
| Harness execution model (041 clauses 1–4) | serial only | C12, C13, C17 added; 1–4 unchanged |
