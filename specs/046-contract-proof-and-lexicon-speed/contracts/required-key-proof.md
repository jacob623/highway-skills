# Contract: Required-Key Proof

**Feature**: [../spec.md](../spec.md) | **Date**: 2026-09-12

The behavioural obligation that the new test must discharge. This is stated as a contract rather than
as test steps because the obligation, not the mechanism, is what must survive future edits.

## The claim being defended

The frontmatter contract manifest is the **sole** authority on which frontmatter keys are required.
Adding a required row to the manifest, and changing nothing else, must cause a previously conforming
artifact to stop conforming.

Feature 045 asserted this and demonstrated it once by hand. Nothing in the suite defended it. A
regression would therefore be silent: the manifest would still look authoritative while having become
partly decorative.

## Obligations

| ID | Obligation |
|---|---|
| RK-1 | The proof MUST exercise the real validator end to end. Asserting on the manifest's file contents does not discharge it (D3.8). |
| RK-2 | The proof MUST assert the **negative**: with the required row added, validation of the target reports a missing-field finding naming that key. |
| RK-3 | The proof MUST assert the **positive**: without the added row, the same target passes. Without this, a validator that failed everything would satisfy RK-2. |
| RK-4 | The proof MUST cover both scopes — a top-level key and a `metadata` key. A generic enforcement path that handles only one scope must fail this. |
| RK-5 | The proof MUST NOT write to the tracked manifest, on any path, including failure. |
| RK-6 | The proof MUST remove every temporary artifact it creates, including when it fails partway. |
| RK-7 | The proof MUST NOT depend on which specific skill it validates. Editorial work on a real skill's frontmatter must not be able to invalidate it. |
| RK-8 | The proof MUST have been observed failing against a seeded defect before being marked complete (D3.6). |

## Seeded defect for RK-8

The defect must make the validator derive its required-key set from somewhere other than the
manifest — for example, restricting enforcement to the keys that have bespoke checks, which is
exactly the state the code was in before Feature 045's generic safety net was added.

**Expected observation**: the proof fails, reporting that the expected missing-field finding was
absent.

A defect that merely breaks the validator is not sufficient. It would produce a failure for the wrong
reason and would prove nothing about where required keys come from.

## Expected finding shape

The missing-field finding follows the existing form and MUST NOT be altered by this feature:

```text
ERROR: [SCHEMA] missing required field '<key>'
```

The proof asserts on the key name. It MUST NOT assert on the total number of findings for the target,
because an unrelated future check could legitimately add one and would break the proof for a reason
that has nothing to do with the property under test.

## Out of contract

- The number, order, or wording of any other finding.
- Any behaviour of the manifest's own shape validation, which Feature 045 already covers.
- Performance. This proof runs the validator a handful of times; its cost is not a concern.
