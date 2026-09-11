# Data Model: Automatic Check Integrity

**Feature**: 041-auto-check-integrity | **Date**: 2026-09-10

This feature introduces one new entity and changes how three existing ones are read. No entity is
removed.

---

## Completion register entry

**Location**: one row in `.specify/memory/completion-register.md`. See
[contracts/completion-register.md](contracts/completion-register.md) for the wire format.

| Field | Type | Required | Description |
|---|---|---|---|
| `Feature` | Feature directory basename | Yes | Must name an existing directory under `specs/` |
| `Status` | Enum | Yes | Exactly one of `complete`, `incomplete`, `in-progress` |
| `Corrects` | Feature directory basename or `-` | Yes | The earlier feature whose defect this one corrects |

### Validation rules

| # | Rule | Source |
|---|---|---|
| V1 | Every directory matching `specs/[0-9][0-9][0-9]-*` has exactly one row | FR-001, FR-004 |
| V2 | Every `Feature` value names an existing directory | FR-004 |
| V3 | `Status` is one of the three declared values; anything else is a rejection, not a default | FR-001 |
| V4 | A non-`-` `Corrects` value names an existing directory with a **lower** number than the row's own | FR-006 |
| V5 | A row MUST NOT correct itself | FR-006 |

### Relationships

- **`Status = complete` → coverage record required.** The feature's directory must hold `coverage.md`
  in the declared schema. This is the relationship that replaces the checkbox test.
- **`Corrects ≠ -` → corrective provenance required.** The correcting feature's own coverage record
  must carry `deferred` rows naming the originating feature, the revised requirement, and the
  superseding feature — the ratified `D7.5` Observable, unchanged by this feature.
- **`Status = incomplete` or `in-progress` → no coverage obligation.** The feature is out of scope for
  `D7.2` and `D7.4` because the register says so, not because a file inside it says so.

### State transitions

```text
in-progress ──► complete      a feature ships; its coverage record must exist at the same moment
in-progress ──► incomplete    a feature is abandoned
incomplete  ──► in-progress   work resumes
complete    ──► (terminal)    a completed feature is never un-completed; a correction is a new spec
```

`complete` being terminal is `D5.2`'s shape: a correction ships as a new spec that names the earlier
one in its `Corrects` field, rather than reopening it.

### Measured initial population

| Status | Count | Notes |
|---|---|---|
| `complete` | 39 | Includes 038 and 040, both of which carry unchecked tasks today (research R8) |
| `incomplete` | 1 | `003-constitution-enforcement`, replacing the `-ne 3` special case in the check |
| `in-progress` | 1 | `041-auto-check-integrity`, this feature, until it ships |
| `Corrects` non-empty | 8 | The eight names currently hardcoded in `completion-coverage.test.sh` lines 328–336 |

Totals to 41 once this feature's own directory exists.

---

## Artifact class declaration

**Location**: a comment line in each test file — `# Artifact classes: a, b, c`. Already present in
all 39 tests; this feature changes it from a string that is matched to a list that is executed.

| Field | Type | Description |
|---|---|---|
| class name | Identifier | One of the declared vocabulary below |

**Declared vocabulary**, unchanged from the tree as it stands:

| Class | Means |
|---|---|
| `source-document` | A hand-authored file the check reads — a constitution, a spec, a skill |
| `generated-artifact` | A file produced by a script under `.highway/tools/` and recorded in a manifest |
| `disposable-fixture` | A file created for the duration of a run under `mktemp -d` |

### Validation rules

| # | Rule | Source |
|---|---|---|
| V6 | Every test declares at least one class | FR-009, existing |
| V7 | Every class named is in the declared vocabulary | FR-009 |
| V8 | Every declared class of a mapped test has a probe | FR-009, FR-010 |
| V9 | A test MUST NOT probe a class it does not declare | FR-009 |

---

## Probe

**Location**: a function inside the test that owns it. Not an artifact on disk except while running.

| Field | Type | Description |
|---|---|---|
| class | Identifier | The artifact class this probe proves |
| subject | Path | The real artifact whose bytes are altered |
| seed | Operation | The defect introduced |
| restore | Operation | The byte-exact reversal, never via version control |

### Validation rules

| # | Rule | Source |
|---|---|---|
| V10 | `--probe <class>` exits non-zero | FR-008 |
| V11 | `--probe <class> --neutralise` exits zero | FR-008 |
| V12 | The subject's bytes are identical before and after the run | FR-012 |
| V13 | Any on-disk artifact is named with `$$` and appears in the suite sweep | FR-012 |

**V11 is what makes V10 mean anything.** A probe that always fails satisfies V10 alone.

### The probes this feature adds

| Test | Class | Subject | Seed |
|---|---|---|---|
| generate-agent-adapters | generated-artifact | an adapter under a declared agent tree | append a byte after generation |
| generate-catalog | generated-artifact | the catalog | perturb one byte outside the excepted timestamp between two runs |
| adapter-coverage | generated-artifact | `highway-inquiry`'s catalog entry | remove it |
| adapter-coverage | generated-artifact | `highway-inquiry`'s adapter in one agent tree | remove it |
| adapter-coverage | generated-artifact | the adapter manifest | remove `highway-inquiry`'s row |
| adapter-coverage | generated-artifact | the distribution manifest | remove `highway-inquiry`'s row |
| adapter-coverage | source-document | `highway-inquiry`'s `SKILL.md` | change the description without regenerating |
| constitution-inventory | source-document | a mapped test file | make its declared probe stop failing |
| completion-coverage | source-document | the register | an unregistered directory, an orphan entry, a malformed status |

`highway-inquiry` is the prescribed subject because it conforms and can therefore be broken and
restored — the round trip Phase 4c required.

---

## Coverage record

Unchanged in shape. Two instances are brought into it.

| Field | Type | Required | Description |
|---|---|---|---|
| `Requirement` | `FR-<n>` with optional letter suffix | Yes | Declared in the feature's own `spec.md` |
| `Outcome` | Enum | Yes | `satisfied`, `deferred`, or `historical` |
| `Evidence` | Prose | Yes | Non-empty; a `satisfied` row's leading path must exist |

### What changes

| Instance | Today | After |
|---|---|---|
| `038/coverage.md` | Header `\| Requirement \| Coverage \| Evidence class \|`; 15 requirement rows and 8 non-requirement rows | Declared header; the 8 non-requirement rows removed |
| `040/coverage.md` | Absent | Written, one row per declared requirement id |

The 8 non-requirement rows break no parser — `coverage_rows()` matches only lines beginning
`| FR-nnn |`. They are removed because `D7.4` requires one column schema, and a row using
`Evidence class` in a third sense under a renamed header is a silent mislabel.

---

## What is deliberately not modelled

- **Whether a feature is complete.** The register records a maintainer's judgment. Nothing computes it,
  and FR-007 forbids a heuristic that would.
- **Whether one feature corrects another.** `D7.5` is `[agent-checkable]` by design. The register
  records the judgment; the check enforces the consequence.
- **Instrument class.** `D3.8` already governs it and this feature does not reopen it.
