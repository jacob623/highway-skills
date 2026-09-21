# Contract: Assertion Inventory

**Requirements**: FR-006 | **Rules**: D3.5 (`[human-review]`), D3.6

**Status**: **Populated 2026-09-20, before any implementation edit.** 73 assertions across the
four in-scope files.

---

## Why this file exists

This feature makes the test suite faster. The way such a feature fails is not by being slow; it is
by quietly deciding less and reporting the same green. Phase 14 of the governance plan states the
refusal directly: a probe may be made cheaper, it may not be made to prove less.

D3.5 is `[human-review]`, which means a person must confirm no assertion was weakened. Without a
baseline that review means re-reading six files and remembering what they used to say. With one it
is a diff. That is the entire purpose of this document.

## Scope

Every test file this feature edits:

| File | Why it is edited | Baseline required |
|---|---|---|
| `constitution-inventory.test.sh` | Worker pool, ordered replay | Yes |
| `distribution-packaging.test.sh` | Build reuse | Yes |
| `shipped-tree-independence.test.sh` | Pruned walk | Yes |
| `adapter-coverage.test.sh` | Tree-copy reuse | Yes |
| `generate-catalog.test.sh` | Not edited; perturbed by another leg | No |
| `generate-agent-adapters.test.sh` | Not edited | No |

Files outside this list are untouched and need no baseline. The thirty inexpensive test files, and
every test validating shipped skill or library content, are explicitly not in scope — research M5
records why.

## Schema

One row per assertion. An assertion is anything that can cause the file to exit non-zero.

| Field | Meaning |
|---|---|
| `assertion_id` | Stable label, `<file-abbrev>-NN`. Used only within this feature. |
| `decides` | What it decides, in one sentence, in terms of behavior rather than code. |
| `failure_message` | The **exact** text emitted, copied not paraphrased. This is what makes a row findable after it moves. |
| `after` | `unchanged`, or a note naming the behavior it still proves. |

## Rules

### R1 — Every row survives

A row may move file, change mechanism, or change line. **No row may disappear.** A row that has no
counterpart after the change is a removed assertion, which FR-006 forbids and which stops the
feature.

### R2 — Failure text is preserved

`failure_message` must be byte-identical after the change unless a reason is recorded naming the
superseded behavior, per D3.5's Observable. This is stricter than it may look, and deliberately:
the failure message is the whole of what a maintainer sees at 5pm on a Friday, and changing it
silently is how a check becomes untrustworthy.

### R3 — Reuse is declared

Where an assertion begins reading a **reused** distribution build or tree copy rather than a fresh
one, its `after` field records which other assertions share that artifact. This is the only place
the build-reuse optimisation can cause a real coverage loss — one assertion mutating a tree a later
assertion reads — so it is written down rather than reasoned about.

### R4 — "Faster" is never a reason

`after` may record a changed mechanism. It may not record a changed conclusion. If the only honest
note is "this now checks less, but it is quicker", the change does not land.

## Population procedure

```sh
# For each in-scope file, list every exit path and every emitted failure line.
grep -n 'echo "FAIL' .highway/tools/tests/<file>.test.sh
grep -n 'exit 1\|exit 2\|fail=1\|problems=1' .highway/tools/tests/<file>.test.sh
```

Both greps are needed: some assertions set a flag rather than exiting, and some exit without
emitting. Read the file rather than trusting the greps to be complete — they are a starting index,
not the inventory.

## Table

Captured 2026-09-20 from the four in-scope files at their pre-change state. `failure_message` is
the literal text after `FAIL: `, with `<...>` marking interpolated values.

### `constitution-inventory.test.sh` — 31 assertions

| id | decides | failure_message | after |
|---|---|---|---|
| CI-01 | An unknown CLI argument is rejected rather than ignored | `unrecognized argument: <arg>` (exit 2) | unchanged |
| CI-02 | A probe class the file does not declare exits 2, not 1 | `undeclared artifact class: <class>` (exit 2) | unchanged |
| CI-03 | `harness_probe_pair` reports a test probed with a class it does not declare | `<rule> test probes a class it does not declare: <test> -> <class>` | unchanged |
| CI-04 | `harness_probe_pair` reports a probe that cannot fail on its own seeded defect | `<rule> probe for <class> did not fail on a seeded defect: <test>` | unchanged |
| CI-05 | `harness_probe_pair` reports a probe failing with nothing seeded | `<rule> probe for <class> fails without a seeded defect: <test>` | unchanged |
| CI-06 | `harness_run` reports a mapped test with no declared classes | `<rule> test does not implement probe mode: <test>` | unchanged |
| CI-07 | `harness_run` refuses to pass having exercised nothing | `no rule/class pairs were exercised; the harness matched nothing` | unchanged |
| CI-08 | The self-probe requires all three `harness_probe_pair` branches to report | exit 1 when `undetected -eq 0` | unchanged |
| CI-09 | The parsed rule count equals the constitution's own | `parsed <n> rules, constitution contains <m>` | unchanged |
| CI-10 | Each of the three tier counts matches the document | `tier '<tier>' parsed <n> rules, constitution declares <m>` | unchanged |
| CI-11 | No rule id is duplicated | `duplicate rule ids parsed: <ids>` | unchanged |
| CI-12 | Every rule id is well formed | `malformed rule ids parsed: <ids>` | unchanged |
| CI-13 | Field lookup returns the document's own tier text | `expected P7.1 tier 'auto', got '<tier>'` | unchanged |
| CI-14 | Field lookup returns a non-empty observable | `P7.1 observable is empty` | unchanged |
| CI-15 | A malformed rule row is reported, not silently accepted | `a malformed rule row was accepted instead of reported` | unchanged |
| CI-16 | The malformed-row error names the offending id | `malformed row error did not name the offending rule id. Got: <out>` | unchanged |
| CI-17 | The vagueness token list is parsed, not empty | `parsed only <n> prohibited vagueness tokens` | unchanged |
| CI-18 | Token-list exclusions come from the document | `exclusions were not read from the constitution. Got: <out>` | unchanged |
| CI-19 | Every `[auto]` P-rule has a registered check | `the Highway Skills Constitution tags these rules [auto] but no check decides them:<ids>` | unchanged |
| CI-20 | The Experience Standard reader matches something | `no rules were read from the Experience Standard; the reader matched nothing` | unchanged |
| CI-21 | Every `[auto]` Experience rule has a registered check | `the Highway Experience Standard tags these rules [auto] but no check decides them:<ids>` | unchanged |
| CI-22 | Every `[auto]` D-rule appears in the Enforcement Map | `the Highway Development Constitution tags these rules [auto] but the Enforcement Map does not name a test for them:<ids>` | unchanged |
| CI-23 | Every Enforcement Map row names a test that exists | `the Highway Development Constitution's Enforcement Map names a test that does not exist: <rule> -> <test>` | unchanged |
| CI-24 | `pair_case` proves the seeded_exit branch still reports | `harness_probe_pair did not report a probe that cannot fail on its own seeded defect` | unchanged |
| CI-25 | `pair_case` proves the neutral_exit branch still reports | `harness_probe_pair did not report a probe that fails with nothing seeded` | unchanged |
| CI-26 | `pair_case` proves the exit-2 branch still reports | `harness_probe_pair did not report a class the test does not declare` | unchanged |
| CI-27 | `harness_probe_pair` passes an unperturbed probe | `harness_probe_pair objected to an unperturbed probe` | unchanged |
| CI-28 | Every mapped test's every declared class behaves (the 20 legs) | aggregate of CI-03..CI-07 via `harness_run` | **changed mechanism, same conclusion**: legs dispatched through a bounded pool and replayed in Enforcement Map order. Each leg still runs `harness_probe_pair` unmodified, and the aggregate return is still non-zero if any leg misbehaves. |
| CI-29 | The D-rule reader matches something | `no [auto] rules were parsed from the Highway Development Constitution; the reader matched nothing` | unchanged |
| CI-30 | Every `*.test.sh` declares an instrument class | `test does not declare an instrument class: <file>` | unchanged — now also covers `classification-scope.test.sh` |
| CI-31 | Every `*.test.sh` declares artifact classes | `test does not declare artifact classes: <file>` | unchanged — now also covers `classification-scope.test.sh` |

### `distribution-packaging.test.sh` — 21 assertions

| id | decides | failure_message | after |
|---|---|---|---|
| DP-01 | Unknown CLI argument rejected | `unrecognized argument: <arg>` (exit 2) | unchanged |
| DP-02 | Undeclared probe class exits 2 | `undeclared artifact class: <class>` (exit 2) | unchanged |
| DP-03 | The generator refuses an overwrite | `packaging did not refuse to overwrite: <target>` | unchanged |
| DP-04 | The refusal is the overwrite refusal, not another error | `packaging stopped for a reason other than the overwrite refusal: <target>` | unchanged |
| DP-05 | The refusal names its target | `the overwrite refusal did not name its target: <needle>` | unchanged |
| DP-06 | `source-document` leg: a dev-only reference is caught | leg exit 1 seeded / 0 neutralised | unchanged |
| DP-07 | `disposable-fixture` leg: a stray repo file is caught | leg exit 1 seeded / 0 neutralised | unchanged |
| DP-08 | `generated-artifact` leg: both D4.3 refusals are caught | leg exit 1 seeded / 0 neutralised | unchanged |
| DP-09 | The distribution can be produced at all | `the distribution could not be produced` | unchanged — **fresh build required** |
| DP-10 | Two runs from one repository state are byte-identical | `two packaging runs from the same repository state differ` | unchanged — **two fresh builds required**; this assertion is the reason build reuse cannot be applied here |
| DP-11 | An undeclared repository path stops packaging | `an undeclared repository path did not stop packaging` | unchanged — **fresh build with a seeded stray file** |
| DP-12 | The undeclared-path refusal names the path | `packaging rejected an undeclared path without naming it` | unchanged |
| DP-13 | A dev-only reference in a distributed file stops packaging | `a development-only reference in a distributed file did not stop packaging` | unchanged — **fresh build with a seeded reference** |
| DP-14 | That refusal names the cause | `packaging rejected a development-only reference without naming the cause` | unchanged |
| DP-15 | An unresolvable cross-reference stops packaging | `an unresolvable cross-reference did not stop packaging` | unchanged — **fresh build with a seeded link** |
| DP-16 | That refusal names the target | `packaging rejected an unresolvable reference without naming the target` | unchanged |
| DP-17 | A rejected candidate tree is removed | `a rejected candidate distribution was left in place` | unchanged — **fresh build with a seeded reject** |
| DP-18 | Self-validation can fail: a tree missing its constitution must not validate | `a distribution missing its governing document still validated` | unchanged — reads the `dist` tree built for DP-09 |
| DP-19 | The generator refuses a directory it did not produce | via DP-03..DP-05, reported as `FAIL: <why>` | unchanged |
| DP-20 | That refusal destroys nothing | `packaging destroyed a file in a directory it did not produce` | unchanged |
| DP-21 | The generator refuses a target whose files drifted | via DP-03..DP-05, reported as `FAIL: <why>` | unchanged — already reuses the `dist` tree |

### `shipped-tree-independence.test.sh` — 6 assertions

| id | decides | failure_message | after |
|---|---|---|---|
| ST-01 | Unknown CLI argument rejected | `unrecognized argument: <arg>` (exit 2) | unchanged |
| ST-02 | Undeclared probe class exits 2 | `undeclared artifact class: <class>` (exit 2) | unchanged |
| ST-03 | Both probe legs detect their seeded reference | leg exit 1 seeded / 0 neutralised | **changed mechanism, same conclusion**: `scan_targets` classifies in one pass over a pruned walk. The scanned set is unchanged — proved by `contracts/classification-equivalence.md` O3. |
| ST-04 | No distributed file references a development-only location | `distributed files reference a development-only location:` | **same**, via the same `scan_targets` change |
| ST-05 | The check can detect a seeded violation | `the shipped-tree check did not detect a deliberately seeded violation` | unchanged |
| ST-06 | Fixtures are still scanned; scope was not narrowed | `the shipped-tree check no longer scans fixtures; its scope has been narrowed` | unchanged — the deliberate re-addition of `tools/tests` survives pruning and ST-06 is what proves it |

### `adapter-coverage.test.sh` — 15 assertions

| id | decides | failure_message | after |
|---|---|---|---|
| AC-01 | Unknown CLI argument rejected | `unrecognized argument: <arg>` (exit 2) | unchanged |
| AC-02 | Undeclared probe class exits 2 | `undeclared artifact class: <class>` (exit 2) | unchanged |
| AC-03 | Every skill has a catalog entry | `skill '<id>' has no entry in the catalog` | unchanged |
| AC-04 | Every skill has each of its three adapter files | `skill '<id>' has no adapter at <rel>` | unchanged |
| AC-05 | Every adapter is included by the distribution manifest | `skill '<id>' would not reach users; <adapter> is not included by the distribution manifest` | unchanged — calls `dist_classify`, which keeps its single-path signature |
| AC-06 | Every adapter has an adapter-manifest row | `skill '<id>' has no adapter manifest row for <rel>` | unchanged |
| AC-07 | No catalog entry names an absent skill | `catalog entry '<id>' names a skill with no directory under skills/` | unchanged |
| AC-08 | No adapter-manifest row names an absent skill | `adapter manifest row names skill '<id>', which has no directory under skills/` | unchanged |
| AC-09 | No distribution-manifest row names an absent skill | `distribution manifest row <path> names a skill with no directory under skills/` | unchanged |
| AC-10 | Every adapter the manifest claims is on disk | `adapter manifest names <rel>, which is not on disk` | unchanged |
| AC-11 | Every adapter matches what regeneration would produce | `<rel> is stale; regenerating skill '<id>' produces a different adapter` | unchanged |
| AC-12 | `generated-artifact` leg: all eight D4.5/D4.6 defects are each reported | leg exit 1 seeded / 0 neutralised | unchanged |
| AC-13 | `source-document` leg: a perturbed skill source makes its adapters stale | leg exit 1 seeded / 0 neutralised | unchanged — **requires its own currency tree**, because the source is perturbed |
| AC-14 | The skill loop iterates something | `no skills were found under .highway/skills/; the check matched nothing` | unchanged |
| AC-15 | The four catalog index files are current | `.highway/<rel> is stale; regenerating from current sources produces a different file` | unchanged — already shares the single `CURRENCY_TMP` tree with AC-11 |

### Finding recorded during capture

**Build and tree-copy reuse has far less scope than plan.md's Phase C assumed.** DP-10 requires two
independent builds by definition, and DP-11, DP-13, DP-15 and DP-17 each build against a
*different seeded repository state*, so no two can share a tree without destroying what they
decide. AC-13 perturbs a skill source, so it cannot share AC-11's currency tree either.

Only DP-18 and DP-21 reuse a build, and DP-21 already did before this feature. The honest saving
available under FR-009 is therefore the batching inside `generate-distribution.sh` itself — one
`validate-skill.sh` invocation instead of ten, and one hashing pass — which makes *every* build
cheaper rather than removing builds. This is recorded here rather than resolved by weakening an
assertion, per R4.

> **Closed 2026-09-20, with one half of it wrong.** The build-reuse half held: re-examining all
> eleven builds found no further safe reuse, so the build count is unchanged and no assertion was
> touched to create one. The batching half did not. One `validate-skill.sh` invocation instead of
> ten was implemented, proven output-equivalent, measured at 9.71s against 9.63s for ten separate
> invocations, and **reverted** — the per-skill cost is inside the rule-check and lexicon
> libraries, not in process startup. Only the single hashing pass survived. A build fell from
> 9.61s to 4s, which came from the pruned classification walk and the hashing pass together.
>
> The same re-examination confirmed AC-13 and AC-15: normal mode already makes exactly one
> `CURRENCY_TMP` tree copy, AC-15 shares it, and AC-13's second copy is in probe mode and exists
> because AC-13 perturbs a skill source. No reuse was available there either, and that outcome is
> recorded rather than manufactured.

**Every row's `after` is populated: 73 rows, none empty.** No row records a weakened conclusion,
and no row is without a counterpart — no assertion was removed or loosened by this feature.

### Assertions added

| ID | Assertion | Failure message | Origin |
|---|---|---|---|
| CS-01 | The manifest yields at least one prunable root | `no prunable roots were derived from the manifest` | New in 056 (FR-019) |
| CS-02 | No derived prune root hides an `include` record | `a derived prune root would hide an included record` | New in 056 (FR-019) |
| CS-03 | Every declared classification walker derives its prune set from `dist_prune_roots` and passes `-prune` | `a classification pass enumerates paths beneath locations no manifest record can include` | New in 056 (FR-019) |

These are additions, not replacements. They live in `classification-scope.test.sh`, are structural
rather than timed, and cost under one second.

## Verification

| Check | When |
|---|---|
| Every in-scope file appears | End of Phase A |
| Row count recorded, before and after | End of Phase F |
| Every row has a non-empty `after` | End of Phase F |
| No `after` records a weakened conclusion | Human review, D3.5 |
