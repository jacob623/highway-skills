# Data Model: Specification-Record Governance Removal

**Feature**: 044-spec-governance-removal | **Date**: 2026-09-11

This feature introduces no runtime data structure. The "model" here is the set of governance
entities whose state changes, and the transitions each one undergoes. It exists so that the
implementation can be checked against a declared end state rather than against an impression.

## Entities

### Constitution rule

A row in a principle table of `.specify/memory/constitution.md`, carrying an id, Rule text, an
Observable, and a tier.

| Attribute | Constraint |
|---|---|
| `id` | `D<principle>.<n>`. Not renumbered by this feature, even where relocation makes the number inconsistent with its new principle |
| `subject` | Derived, not stored. Either *the record* or *the product*. This single attribute decides disposition |
| `tier` | One of `[auto]`, `[agent-checkable]`, `[human-review]`. Unchanged for every surviving rule |
| `disposition` | `removed`, `relocated`, or `untouched` |

**State transitions:**

```text
untouched ──(subject = record)──> removed
untouched ──(subject = product, under a removed principle)──> relocated
```

There is no transition to a weakened or disabled state. A rule is removed or it is intact; this
feature introduces no third condition.

**Population after this feature:** 8 `removed`, 2 `relocated`, all others `untouched`.

### Principle section

A `###` heading in the constitution holding a rule table and a rationale paragraph.

| Attribute | Constraint |
|---|---|
| `heading` | Roman numeral and name |
| `rules` | The rule ids it contains |
| `removable` | True only when `rules` is empty of survivors |

**Invariant:** a principle section is removed only after every rule it holds is `removed` or has been
`relocated` out. This orders steps 2 and 4 of the plan.

### Enforcement Map row

A row binding a rule id to the test file that decides it.

| Attribute | Constraint |
|---|---|
| `rule_id` | Must name a rule that exists in the document |
| `test_file` | Must name a file that exists under `.highway/tools/tests/` |

**Invariant, and the reason for the plan's ordering:** both columns must resolve at all times.
`constitution-inventory.test.sh` executes every row's declared probe, so a row naming a deleted file
fails immediately. Rows are therefore removed **before** the files they name, never after.

**Population: 13 → 9.**

### Test file

A file under `.highway/tools/tests/`.

| Attribute | Constraint |
|---|---|
| `subject` | *The record* or *the product*. Decides disposition, exactly as for a rule |
| `mapped_rules` | The Enforcement Map rows naming it. May be empty |
| `sourced_by` | Surviving files that `source` it. **Non-empty blocks removal** |

The `sourced_by` attribute is in this model because ignoring it would have caused a defect:
`feature-038-helpers.sh` has two surviving callers and was initially listed for removal.

**Population: 39 → 36.** (Corrected during implementation: the planning-time estimate of 43 → 40
was wrong; 39 was the actual count of `.highway/tools/tests/*.test.sh` files immediately before
T015, confirmed by `ls .highway/tools/tests/*.test.sh | wc -l` both before and after T015.)

### Register row

A row in `.specify/memory/completion-register.md`: feature name, status, `Corrects`.

| Attribute | Before | After |
|---|---|---|
| `status` vocabulary | `complete`, `incomplete`, `in-progress` | adds `withdrawn` |
| readers | `D7.2`, `D7.4`, `D7.5` via `completion-coverage.test.sh` | none |
| authority | Maintainer-declared, machine-read | Maintainer-declared, machine-unread |

**State transitions performed by this feature:**

```text
042-probe-reachability-correction:  in-progress ──> complete
043-corrective-provenance-honesty:  in-progress ──> withdrawn
044-spec-governance-removal:        in-progress ──> complete   (at close)
```

The register survives the removal of every rule that reads it. It stops being a checked artifact and
becomes an index. FR-019 requires its header to say so, because that header currently asserts that
three rules read it — a claim this feature makes false.

### Feature record

A directory under `specs/`.

| Attribute | Constraint after this feature |
|---|---|
| numbering | Convention. No longer checked — `D5.4` removed |
| naming | Convention. No longer checked — `D5.5` removed |
| `coverage.md` | Retained, unread. Neither required nor validated |
| immutability | Convention. No longer stated — `D5.1` removed |

**Withdrawn** is a new observed state for a feature record: its subject ceased to exist before it
was implemented. Feature 043 is the first and, at the time of writing, only instance. A withdrawn
record retains its directory, requirements and clarifications; only its Status changes, and it names
the feature that removed its subject.

## Relationships

```text
Principle section  1 ──── * Constitution rule
Constitution rule  0..1 ──── 1 Enforcement Map row
Enforcement Map row  * ──── 1 Test file
Test file  * ──── * Test file          (sourced_by)
Register row  1 ──── 1 Feature record
```

The chain that governs deletion order runs right to left along the middle three relations:

```text
Test file ← Enforcement Map row ← Constitution rule ← Principle section
```

Deleting from the left breaks the suite. Deleting from the right leaves transient orphans that are
harmless. So the implementation removes Map rows, then rules, then sections, then files — with the
Map row and the file separated by a full suite run.

## Counts, before and after

| Quantity | Before | After |
|---|---|---|
| Constitution rules | 38 | 30 |
| Principle sections | 8 | 6 |
| Enforcement Map rows | 13 | 9 |
| Test files under `.highway/tools/tests/` | 39 | 36 |
| Rules whose subject is the record | 8 | 0 |
| Register status vocabulary | 3 values | 4 values |
| Rule-to-skill pairs decided by `validate-skill.sh` | 93 of 480 | **93 of 480** |

The last row is the point of the feature stated as a number: this change removes governance without
removing a single decision about a shipped file.
