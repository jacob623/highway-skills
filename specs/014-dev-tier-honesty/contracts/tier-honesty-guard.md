# Contract: Tier-Honesty Guard and Enforcement Map

**Feature**: `014-dev-tier-honesty` | **Date**: 2026-09-08

This feature adds no command. Its contracts are the format of the Enforcement Map and the output
of the guard that reads it. Both are binding: a change to either is a behavioral change requiring
a test amendment under D3.3.

---

## The Enforcement Map format

A Markdown table in `.specify/memory/constitution.md`, under its own heading.

```text
| Rule | Enforced by | Note |
|---|---|---|
| D1.1 | shipped-tree-independence.test.sh | Seeds a probe to prove it can fail |
```

| Field | Constraint |
|---|---|
| Rule | A `D` rule id, appearing exactly once across the table |
| Enforced by | A bare filename, resolved under `.highway/tools/tests/` |
| Note | Free text; may be empty |

**Why a bare filename rather than a path**: the map is read by a test that already knows the
directory, and a path would be a second place the test location is written down. It also keeps the
document free of a path that means nothing to a reader outside this repository.

---

## Guard output

### Success

Silent. The guard prints nothing when both documents are honest, matching every other assertion in
`constitution-inventory.test.sh`.

### Failure — Skills Constitution

```text
FAIL: the Highway Skills Constitution tags these rules [auto] but no check decides them: P6.5
```

### Failure — Development Constitution, unmapped rule

```text
FAIL: the Highway Development Constitution tags these rules [auto] but the Enforcement Map does not name a test for them: D5.4
```

### Failure — Development Constitution, map names a missing test

```text
FAIL: the Highway Development Constitution's Enforcement Map names a test that does not exist: D1.1 -> shipped-tree-independence.test.sh
```

Each message names the document, the rule, and where the break is. A message naming only the rule
would leave a reader checking two documents to find out which one is wrong.

---

## Exit codes

Unchanged. `constitution-inventory.test.sh` exits 0 when every assertion holds, 1 otherwise, as it
does today.

---

## Behavioral guarantees

| # | Guarantee | Requirement |
|---|---|---|
| G1 | `[auto]` has a stated meaning for Layer 0 rules | FR-001, FR-002 |
| G2 | The difference from the Layer 1 meaning is stated | FR-003, FR-004 |
| G3 | Every `[auto]` `D` rule satisfies that meaning | FR-005, SC-002 |
| G4 | A rule that cannot satisfy it carries a truthful tier | FR-006 |
| G5 | D5.4 is enforced rather than retagged away | FR-007 |
| G6 | The guard covers both documents | FR-010, SC-004 |
| G7 | A guard failure names the document | FR-011, SC-004 |
| G8 | The guard extends only after the document is honest | FR-012 |
| G9 | Every new check is demonstrated failing | FR-014, SC-006 |
| G10 | Nothing added by this feature enters the distribution | FR-015, SC-009 |

---

## Toolchain

No new utility. The map is parsed with `awk` and `grep`, both already declared. Nothing is added
to the Declared Toolchain, so D2.2 and D2.4 hold unchanged.

---

## Scope boundary

Every file this feature touches lives under `.highway/tools/tests/` or `.specify/`. Both are
excluded by the distribution manifest, so no manifest change is required and the packaged tree is
byte-identical before and after.

If a future change to this feature's work requires editing anything under `.highway/tools/lib/`,
the packaging classification must be revisited in the same change. That is a design rule, not an
observation.
