# Implementation Plan: Test Suite Runtime Recovery

**Branch**: `056-test-suite-runtime-recovery` | **Date**: 2026-09-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/056-test-suite-runtime-recovery/spec.md`

## Summary

The suite costs 286.5s against a 180s target. The cost is not spread across the forty test files —
it is four mechanisms, each measured: the D3.7 harness re-executes six test files twenty times in
serial fresh processes (111.75s); a single distribution build costs 9.6s and the suite performs
roughly seventeen of them; each build spawns two processes per repository file to classify it, and
65% of the repository is `specs/`, which can never ship; and each build spawns `validate-skill.sh`
ten times (3.7s of every build).

The approach attacks all four without changing what any probe decides. Classification becomes one
`awk` pass over a manifest read once, and the walk prunes exclude records that have nothing
included beneath them — which also removes the ~1s of permanent runtime each new feature
specification currently adds. Distribution builds are reused within a test process, which the
probe-mode contract already claims happens and which the code does not do. `verify_self_validation`
validates all ten skills in one pass. The harness's twenty probe legs, which share no state except
in two declared cases, run under a bounded worker pool with output buffered and replayed in
Enforcement Map order, so the suite's output stays byte-identical and the speed-up cannot hide a
behavior change.

Every step is proved by equivalence rather than asserted: the classifier against all 773 paths,
the distribution by hash, the suite by a masked diff of its own output.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible shell (macOS default `/bin/bash`), with `awk`, `sed`,
`grep`. No associative arrays, no `mapfile`/`readarray`, no `${var^^}`.

**Primary Dependencies**: The Declared Toolchain in `.specify/memory/constitution.md` only.
~~One addition was required and has been made — `getconf`, constitution 2.0.0 → 2.1.0.~~
**Reverted 2026-09-20 with Phase D.** No addition was required in the end; the constitution is
back at 2.0.0 and this feature changed no governance document. See Constitution Check below.

**Storage**: Plain files. No database, no state beyond the repository tree and `mktemp` scratch.

**Testing**: `.highway/tools/tests/run-all.sh`, 40 `*.test.sh` files at the baseline and 41 after
this feature added `classification-scope.test.sh`, of which 6 are named in the
Development Constitution's Enforcement Map and implement probe mode across 10 artifact classes.

**Target Platform**: macOS (reference machine, Bash 3.2.57) and Linux. Both must run the suite.

**Project Type**: Shell tooling and its test harness. No application runtime.

**Performance Goals**: Full suite ≤180s on the reference machine across 5 consecutive runs,
reported as a range and a median with the core count and effective worker count (FR-002, FR-003).

**Constraints**: No assertion removed or loosened (FR-006). Distribution byte-identical aside from
the recorded generation timestamp (FR-008, SC-006). Suite output identical in content and order
once durations are masked (FR-011, SC-009). No new runtime dependency (D2.4).

**Scale/Scope**: 773 repository files, 501 under `specs/`, 58 distribution manifest records, 83
distributed files, 10 skills, 40 test files, 20 probe legs.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design below.*

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| **Packaging Gate** | The change touches a shipped path | **N/A** — every file this feature edits (`.highway/tools/tests/`, `.highway/tools/lib/distribution.sh`, `.highway/tools/generate-distribution.sh`) carries an `exclude` record in `.highway/tools/.distribution-manifest`. D1.1 and D1.2 are still decided by the suite on every run, and SC-006 asserts the produced distribution is unchanged. |
| **Toolchain Gate** | The change touches a file under `.highway/tools/` | **TRIGGERED** — see rule verdicts below |
| **Generator Gate** | The change touches a `generate-*.sh` script | **TRIGGERED** — `generate-distribution.sh` is edited |
| **Correspondence Gate** | The change modifies a directory under `.highway/skills/` or another generator input | **N/A** — no skill, catalog input, or adapter input is touched |
| **Validation Gate** | The change adds or modifies a validation check | **TRIGGERED** — FR-019 adds a check and several tests change internally |
| **Skill Content Gate** | The change creates or modifies a file under `.highway/skills/` or `.highway/library/` | **N/A: Skill Content Gate not triggered** |

### Rule verdicts

| Rule | Verdict | Evidence |
|---|---|---|
| D2.1 | PASS | All new code is Bash 3.2 form. The worker pool uses `xargs -P`, not `wait -n`. No associative array is introduced; the prune-root set is a newline-delimited string, matching the existing `seen=""` idiom in `harness_run`. |
| D2.2 | PASS | Every utility the plan uses is declared. ~~`getconf` was added to the Declared Toolchain on 2026-09-20 (2.0.0 → 2.1.0) under resolution R3~~ — **the amendment was reverted when Phase D was descoped; `getconf` is not used and not declared.** D2.2 now passes against the unamended 2.0.0 list. See "Resolved gate item" below. |
| D2.3 | PASS (to verify) | `xargs -P` is accepted by both GNU findutils and BSD/macOS `xargs`. The task phase verifies this on both rather than assuming it, following the `sort -V` precedent recorded in the 1.0.0 ratification. |
| D2.4 | PASS | No package manager, interpreter, or binary is added. |
| D4.1 | PASS | No generated artifact is hand-edited. |
| D4.2 | PASS | `generate-catalog.sh` is untouched; its determinism probe is unchanged. |
| D4.3 | PASS | `generate-distribution.sh`'s refusal paths are not modified; only its internal cost is. `distribution-packaging.test.sh` asserts both refusals and continues to. |
| D4.4 | PASS | `generate-distribution.sh` produces no committed artifact (it is excluded from Declared generators), but SC-006 requires its output be proved byte-identical, which is the stronger check. |
| D3.4 | PASS | FR-019's new check is evaluated against the current tree before it is enabled, and the expected verdict for every existing path recorded. |
| D3.5 | **PASS, and this is the feature's central risk** | No assertion is removed or loosened. The assertion inventory contract captures every assertion before any edit precisely so this is checkable rather than claimed. D3.5 is `[human-review]`; the inventory exists to make that review take minutes rather than a re-reading of six files. |

### Resolved gate item — D2.2 and the worker count

**Status: resolved 2026-09-20. R3 chosen.**

The spec's fifth clarification fixed the concurrency limit as **derived from the machine's usable
core count**, and FR-021 requires serial execution to be the behavior on a machine reporting one
usable core. Reading the core count requires `getconf` (POSIX, present on both target platforms),
which was not in the Declared Toolchain, and D2.2 prohibits invoking a utility outside it.

Three resolutions were considered:

| # | Resolution | Cost |
|---|---|---|
| R1 | Add `getconf` to the Declared Toolchain list | Amends the constitution *document* (version bump, Sync Impact Report). D2.2's **rule text is unchanged**, and FR-017 forbids adding or amending a *rule*, so this is permitted — but it is a constitution edit inside a runtime feature. |
| R2 | Worker count comes from `HIGHWAY_TEST_WORKERS`; the suite invokes no new utility and the *caller* supplies the number | Fully D2.2-clean. But the default when unset cannot be core-derived, so either the default is a fixed number (contradicting the clarification) or it is 1 (making 180s an opt-in result, which fails FR-002 as a default experience). |
| **R3** | `HIGHWAY_TEST_WORKERS` override, defaulting to a core-derived value via `getconf`, with R1's list amendment | **Chosen.** The same amendment as R1, and the override also gives FR-021's serial mode a name (`HIGHWAY_TEST_WORKERS=1`) and makes the measurement reproducible per FR-003. |

**Amendment made**: `.specify/memory/constitution.md` 2.0.0 → 2.1.0 (MINOR), 2026-09-20.
`getconf` added to the Declared Toolchain (25 entries → 26). No rule text changed; D2.2 and D2.4
rule and Observable text are byte-identical, so FR-017's prohibition on adding or amending a rule
holds. The list is widened, so no previously conforming script is invalidated — confirmed by
`grep` finding no existing `getconf` invocation under `.highway/`, meaning the addition permits new
work rather than retroactively legalising shipped work.

> **Amendment reverted, 2026-09-20, same day.** Phase D was descoped, so the only consumer of
> `getconf` disappeared and the entry would have declared a utility nothing invokes. R3 is
> therefore *not* what shipped: no resolution shipped, because the problem was removed rather
> than solved. `.specify/memory/constitution.md` is back at 2.0.0 with 25 entries and zero
> occurrences of `getconf`, confirmed by `git diff` against `HEAD` being empty. The analysis
> above is left standing because Phase 16 will need it again if concurrency is revisited.

**Carried into the task phase as a D2.3 obligation**: `_NPROCESSORS_ONLN` is a non-POSIX operand.
It is accepted by both glibc and Apple/BSD `getconf`, and was confirmed on the reference machine
(returns 6). It must be confirmed on Linux too, alongside `xargs -P`, rather than assumed. If a
platform ever returns empty or non-numeric, the worker count falls back to 1 — which FR-021 already
requires be a correct, fully supported mode rather than a degraded one.

## Project Structure

### Documentation (this feature)

```text
specs/056-test-suite-runtime-recovery/
├── plan.md                              # This file
├── research.md                          # Phase 0: measured baseline (FR-001) and decisions
├── data-model.md                        # Phase 1: entities and their invariants
├── quickstart.md                        # Phase 1: how to reproduce every measurement and proof
├── contracts/
│   ├── probe-mode.md                    # Supersedes 042's, per D5.3
│   ├── suite-execution.md               # Worker limit, ordering, serial mode, residue safety
│   ├── assertion-inventory.md           # FR-006 baseline, captured before any edit
│   └── classification-equivalence.md    # FR-007/FR-008 byte-identical proof
├── checklists/
│   └── requirements.md                  # Written by /speckit-specify; 16/16
└── tasks.md                             # /speckit-tasks output — NOT created here
```

### Source code (repository root)

```text
.highway/tools/
├── lib/
│   └── distribution.sh                   # dist_classify_many added; dist_classify becomes a wrapper
├── generate-distribution.sh              # pruned walk, batched self-validation, single hash pass
└── tests/
    ├── run-all.sh                        # unchanged output; residue sweep made concurrency-safe
    ├── constitution-inventory.test.sh    # ~~harness_run gains a bounded worker pool~~ NOT TOUCHED — Phase D descoped
    ├── distribution-packaging.test.sh    # ~~build reuse within the process~~ NOT TOUCHED — no further safe reuse exists (T017)
    ├── shipped-tree-independence.test.sh # scan_targets uses the pruned walk
    ├── adapter-coverage.test.sh          # ~~tree-copy reuse~~ NOT TOUCHED — normal mode already makes one copy (T018)
    └── classification-scope.test.sh      # NEW — FR-019's standing structural guard
```

**Structure Decision**: No new directory. This feature was planned to change the internals of six
existing files under `.highway/tools/` and add one test file. **It changed three and added one**:
`lib/distribution.sh`, `generate-distribution.sh`, `tests/shipped-tree-independence.test.sh`, and
the new `tests/classification-scope.test.sh`. The other three were left alone because the work
planned for them either did not pay (Phase D, and the self-validation batching) or was already
done (build and tree-copy reuse). Nothing under `.highway/skills/`,
`.highway/library/`, `.highway/catalog/` or `.highway/governance/` is touched, which is what keeps
the Packaging and Correspondence gates N/A and what FR-017's "Layer 1 and Layer 2 untouched"
requires.

**FR-017 confirmed at close**: `git status --short` lists exactly four paths under `.highway/`,
all of them the files named above; both constitution documents are byte-identical to `HEAD`; and
no constitution *rule* was added, amended or removed. The one governance-document edit this
feature made was reverted the same day. `governance-plan.md` was also edited — to record Phases 15
and 16 and to correct Phase 14's class count — but it is a roadmap, not a Layer 1 or Layer 2
artifact, and no rule is stated in it.

`classification-scope.test.sh` must declare `# Instrument class:` and `# Artifact classes:` headers
even though it is not in the Enforcement Map, because `constitution-inventory.test.sh` scans every
`*.test.sh` for both. Missing this is the most likely way an otherwise correct implementation fails
its first suite run.

## Implementation Phases

Ordered so that every proof exists before the thing it proves is changed. FR-001 makes this
mandatory, not stylistic: the baseline cannot be reconstructed after the fact.

| Phase | Work | Requirements | Expected saving |
|---|---|---|---|
| **A. Baseline** | Record per-class costs in `research.md`; capture the assertion inventory contract; record the pre-change suite output with durations masked | FR-001, FR-006 | none (it is the evidence) |
| **B. Classification** | `dist_classify_many`; prune exclude roots with nothing included beneath; equivalence proof over all 773 paths | FR-007, FR-008, FR-012 | −25s, and growth coupling removed |
| **C. Build cost** | Batch `verify_self_validation` into one validator invocation; single hash pass; reuse a build only where two assertions genuinely share a tree state | FR-009 | −50s |
| **D. Concurrency** | ~~Bounded worker pool in `harness_run`; buffered ordered replay; declared serialization for the two conflicting legs; serial mode~~ **DESCOPED 2026-09-20 → `governance-plan.md` Phase 16** | FR-010, FR-011 (partly), FR-021 — recorded not met | ~~−85s~~ → re-estimated −32s, then deferred |
| **E. Standing guard** | `classification-scope.test.sh` | FR-019 | +<1s (accepted) |
| **F. Record** | Supersede the probe-mode contract; close the deviation; remove the 240s ceiling; correct the class count | FR-015, FR-016, FR-020 | none |

**Phase D descope, recorded 2026-09-20.** Two measured reasons, neither of them a change of
opinion about the design. First, the −85s estimate was apportioned from the 286.5s pre-Block-B
standalone sum; after Block B the twenty legs total ~55s with an 11s longest leg, so a six-worker
pool is floored at ~21–25s and the real saving is ~32s. Second, decision D5's serialization set is
wrong: inspection on 2026-09-20 found `adapter-coverage` and `generate-catalog` both writing
`.highway/catalog/index.*`, four tests writing `.highway/tools/.adapter-manifest`, and
`constitution-inventory`'s own `source-document` leg perturbing `generate-catalog.test.sh` in
place — four contending legs, not one pair. Implementing concurrent mutation of a live tree against
a known-incorrect serialization set, for 32s, is not a trade this feature will make on its own
authority.

A third reason makes the ordering matter rather than just the size: ~6s of suite time per added
skill, measured this feature and routed to Phase 15, sits inside roughly 60% of these same legs.
Phase 15 removes that work; Phase D would only have divided it. Done in this order, Phase D is
worth ~15–22s afterwards and may not be worth doing at all — which is the decision Phase 16 is
required to take against a fresh measurement. Done in the other order, the pool is built and
maintained at full cost for a saving that then evaporates.

**Consequence for the constitution.** The `getconf` addition to the Declared Toolchain
(2.0.0 → 2.1.0) existed only to permit Phase D's core-derived worker default. It was reverted;
`.specify/memory/constitution.md` is back at 2.0.0 with 25 entries. A toolchain entry whose sole
justification is deferred work permits nothing, and leaving it would be the same defect as a rule
that decides nothing. This also restores FR-017 to literally true for this feature: no constitution
rule is added or amended. Phase 16 re-makes the amendment if and only if it proceeds.

Phases B and C are independent of D and can land separately; each must leave the suite green and
the output diff clean on its own. Phase F is conditional on the measured outcome — FR-020 governs
what it says if 180s is not reached.

**Correction recorded 2026-09-20, during Phase A.** This table originally described Phase C as
"reuse one build per test process". Capturing the assertion inventory showed that assumption to be
mostly wrong, and the row above has been narrowed to match. DP-10 requires two independent builds
by definition — that is what it decides. DP-11, DP-13, DP-15 and DP-17 each build against a
*different* seeded repository state, and AC-13 perturbs a skill source so it cannot share AC-11's
currency tree. Only DP-18 and DP-21 can share a build, and DP-21 already did. Weakening any of
those assertions to manufacture reuse is prohibited by FR-006 and by rule R4 of the assertion
inventory contract. The honest FR-009 saving is therefore to make *every* build cheaper —
one `validate-skill.sh` invocation instead of ten, one hashing pass instead of per-file — rather
than to make fewer builds. Tasks T017 and T018 are correspondingly narrow. The −50s estimate is
retained because it was derived in M3 from per-build cost, not from a build count; Phase C's
outcome is measured in T024 regardless.

> **Outcome, 2026-09-20.** The narrowing was right and the remedy was half wrong. T017 and T018
> found no further safe reuse and changed nothing, as expected. Of the two cheapening measures,
> the hashing pass worked and the batched `validate-skill.sh` did not — it saved nothing measurable
> and was reverted, because the per-skill cost is process spawning *inside* the rule-check and
> lexicon libraries, not process startup. A build still fell from 9.61s to 4s, but most of that
> came from Phase B's pruned walk rather than from Phase C. Phase C's own contribution is the
> hashing pass alone, worth ~1s per build. The −50s estimate was not achieved.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| ~~D2.2 open item (`getconf`)~~ | ~~FR-010 and FR-021 require a core-derived worker limit~~ | **Withdrawn.** Phase D was descoped, so no core count is needed, the amendment was reverted, and this violation no longer exists. |
| ~~Concurrency in a Bash 3.2 harness~~ | ~~111.75s of 286.5s is twenty independent serial processes~~ | **Withdrawn.** Phase B cut the same legs to ~55s, so the saving fell from ~85s to ~32s and no longer justified concurrent execution in a Bash 3.2 harness. Deferred to `governance-plan.md` Phase 16 with the design intact. |
| Buffered, replayed output | FR-011 requires byte-identical ordering, which live streaming cannot provide under concurrency | Streaming with per-line prefixes was rejected at clarification: it turns every future before/after comparison into a judgement call instead of a `diff`. |

## Post-Design Constitution Check

Re-evaluated after `research.md`, `data-model.md`, the four contracts and `quickstart.md` were
written. The design did not change any gate's trigger status.

| Rule | Verdict | Change since the initial check |
|---|---|---|
| D2.1 | PASS | Confirmed: `xargs -P` and newline-delimited strings only. No associative arrays, no `wait -n`, no `mapfile`. |
| D2.2 | PASS | ~~Resolved by R3. `getconf` added to the Declared Toolchain, 2.0.0 → 2.1.0.~~ **Resolved instead by descoping Phase D:** no undeclared utility is used, and the constitution is untouched at 2.0.0. |
| D2.3 | PASS | `quickstart.md` Phase D adds the cross-platform checks for `xargs -P` ordering (research Q-B) and for `getconf _NPROCESSORS_ONLN`. || D2.4 | PASS | No new dependencies introduced by the design. |
| D3.4 | PASS | `classification-scope.test.sh` is structural, not timed — a flaky timing test would get disabled and take the protection with it. |
| D3.5 | PASS, with the feature's central risk now controlled | `contracts/assertion-inventory.md` turns the `[human-review]` obligation into a diff rather than a recollection. Its table is unpopulated by design; Phase A populates it before the first code edit. |
| D3.6 | PASS | `quickstart.md` Phase E requires the new guard be observed failing before the behavior is marked complete. |
| D4.1–D4.4 | PASS | `contracts/classification-equivalence.md` O4 makes byte-identity a mechanical check over all 83 distributed files. |
| D5.3 | PASS | `contracts/probe-mode.md` supersedes 042's in full and tabulates C11–C17. No completed feature's directory is edited. |
| D1.5, D6.2 | N/A | No skill or library content touched; every edited file carries an `exclude` manifest record. |

**Two design outputs are deliberately incomplete**, and both are gated rather than forgotten:
the runtime table in `contracts/probe-mode.md` (Phase F, and FR-020 governs its wording if 180s is
not reached), and the table in `contracts/assertion-inventory.md` (Phase A, before any edit).
Neither can be honestly filled in at planning time.

**Gate status for `/speckit-tasks`: PASS.** The D2.2 item is resolved; see "Resolved gate item"
above.
