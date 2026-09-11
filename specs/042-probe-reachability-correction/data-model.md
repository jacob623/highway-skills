# Data Model: Probe Reachability Correction

**Feature**: 042-probe-reachability-correction | **Date**: 2026-09-10

There is no database here. These are the conceptual entities the probe machinery manipulates, their
fields, their invariants, and the state each moves through. They exist so that tasks can be written
against named things rather than against line numbers.

---

## 1. Artifact class

A category of file a probe may seed a defect into. The vocabulary is **closed** at three values.

| Field | Value |
|---|---|
| Name | `source-document` \| `generated-artifact` \| `disposable-fixture` |
| Declared in | a `# Artifact classes:` comment in the test file's header |
| Read by | `constitution-inventory.test.sh`, the `D3.7` harness |
| Cardinality | one to three per mapped test; each declared class must be probed |

**Invariants**

- A class a test declares but does not probe exits **2**, and the harness reports a declaration
  mismatch rather than a check failure. A test cannot buy coverage by declaring.
- A class not in the vocabulary is not a class. Research R3 rejects inventing a fourth to resolve a
  collision.
- One class may carry more than one rule. When it does, its probe must fail if *any* of those rules'
  enforcement is removed — not merely one of them.

**Changes in this feature**

| Test | Before | After |
|---|---|---|
| `distribution-packaging.test.sh` | `source-document`, `disposable-fixture` | + `generated-artifact` |
| `completion-coverage.test.sh` | `source-document` | + `disposable-fixture` |
| `spec-record.test.sh` | `disposable-fixture` | unchanged; the existing class's probe is broadened |

---

## 2. Probe leg

One invocation of a test's probe CLI. Two legs per declared class.

| Field | Value |
|---|---|
| Invocation | `bash <test>.test.sh --probe <class>` or `... --neutralise` |
| Required exit | seeded → non-zero; neutralised → zero; undeclared class → 2 |
| Output | today, **none** — probes print nothing in either state |
| Cost | wall-clock seconds, measured, never estimated |
| Artifacts created | named with `$$`, removed by `trap ... EXIT`, swept by `run-all.sh` |

**State**

```text
  declared ──▶ seeded ──▶ checked ──▶ restored ──▶ exited
                  │                       ▲
                  └── neutralise skips ────┘
```

Restoration runs on every path out, including an early exit, because the trap is installed before
the seed is written.

**Invariants**

- Alters a real artifact of the class, not a copy the check does not read.
- Invokes the same function normal mode invokes. Not a re-implementation, not a subset.
- Restores byte-exact, and never via version control — `git` is outside the Declared Toolchain, and
  during feature 010 a revert discarded unrelated uncommitted work.
- Returns before the test's own harness loop, which matters for `constitution-inventory.test.sh`
  because it is itself mapped.

**Known limitation, recorded rather than fixed here**: a failing probe emits nothing, so diagnosing
*why* it failed requires reading its source. This is what forced source inspection during this
feature's own audit. The contract asks only for exit codes, so it is not a defect against the
contract; `FR-017`'s output-capture requirement narrows it for the `D4.3` legs only.

---

## 3. Class-to-rule join

**New in this feature.** The correspondence that `D3.7` and the Enforcement Map each half-express
and neither completes.

| Field | Value |
|---|---|
| Left | an Enforcement Map row: a rule id marked `[auto]` and its test filename |
| Right | a probe leg: a test filename and a declared artifact class |
| Key | the rule id — every `[auto]` rule needs at least one row |
| Derivation | **by measurement**: remove the rule's enforcement, run the suite, record which leg failed |

**Why it is not a constitution rule**: deciding which rule a probe reaches is semantic. The one
mechanical proxy available — "declare at least as many classes as you have mapped rules" — passes
for `completion-coverage` the moment any second class is added, regardless of what that class
reaches. A proxy that cannot fail for the defect it names is the thing `D3.7` was meant to stop.
Recorded in research R6; `FR-015` forbids the amendment here.

**Invariants**

- A row whose evidence is "the probe source appears to touch this" is not a row. `FR-024`.
- A rule with no row is an unreached rule, and the count of those is `SC-002`'s measure.
- The mapping is total over `[auto]` rules: thirteen rows for thirteen Enforcement Map entries.

**Required shape** (the artifact `FR-023` produces):

| Rule | Test | Class | Enforcement removed | Suite failed | Detecting leg |
|---|---|---|---|---|---|
| D4.3 | `distribution-packaging` | `generated-artifact` | the modified-file refusal | yes | seeded leg |
| … | … | … | … | … | … |

Thirteen rows. Each `Suite failed` cell is an observation, not a prediction.

---

## 4. Superseding contract

A contract document in this feature's `contracts/` that replaces one in a completed feature's,
because `D5.1` forbids editing the completed feature's directory.

| Field | Value |
|---|---|
| Supersedes | `specs/041-auto-check-integrity/contracts/probe-mode.md` |
| Obligation | name **every** changed element explicitly, per `D5.3` |
| Forbidden | editing the superseded file; silent divergence |

**Invariants**

- The superseded document stays where it is and is not annotated. The superseding one carries the
  whole record of what changed.
- An element that is unchanged is not re-stated as changed. The Replaces table distinguishes them.

---

## 5. Rule, as this feature treats it

Not a new entity — the constitution's — but its states matter to `SC-002` and `SC-009`.

| State | Meaning | Count before | Count after |
|---|---|---|---|
| Unasserted | no check anywhere detects its violation | 1 half-rule (`D4.3` modified-file) | 0 |
| Asserted, unreached | normal mode detects it; no declared probe reaches it | 4 (`D4.3`, `D5.5`, `D7.2`, `D7.4`) | 0 |
| Asserted and reached | a declared probe fails when its enforcement is removed | 9 | 13 |

The middle row is the one research R2 insists on keeping separate from the top row. Reporting the
four as "unenforced" would be the same class of over-claim this feature exists to correct.
