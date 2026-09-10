# Quickstart: Control-Derived NFR Generation

## Prerequisites

- Repository checkout at the project root with `.highway/` present.
- Existing `highway-controls` and `highway-nfrs` skills, templates, catalogs, and validators.
- A disposable root-level `library/governance/` fixture tree; do not use live user-owned governance data.
- Bash 3.2-compatible shell utilities.

## Focused Validation

Run the focused workflow test:

```sh
/bin/bash .highway/tools/tests/control-derived-nfr.test.sh
```

Expected result: all proposal, determinism, review-order, acceptance, rejection, cancellation,
relationship, direct-authoring, invalid-state, preservation, and no-new-store checks pass.

## Deterministic Proposal Scenario

1. Create the same valid Control content in two isolated fixture baselines.
2. Run the Control-derived proposal workflow in each fixture without accepting candidates.
3. Compare proposal output byte-for-byte.
4. Confirm no NFR record, catalog, or relationship file was created in either fixture.

Expected result: identical Control input produces identical ordered candidate output and no writes
before review.

## Accepted Candidate Scenario

1. Add a valid Control in an isolated fixture.
2. Review the displayed candidate and accept it, or modify its wording before accepting.
3. Inspect the new NFR and both governance catalogs.
4. Confirm the NFR has `controls: [CTL...]` and the Control has the allocated NFR ID in `nfrs`.
5. Confirm existing IDs, unrelated records, and unrelated catalog content are unchanged.

Expected result: one accepted candidate creates one NFR and both identifier-only relationship fields.

## Rejected and Cancelled Scenarios

1. Generate a candidate and reject it; compare the fixture snapshot before and after.
2. Generate candidates and cancel the review; compare the fixture snapshot before and after.
3. Generate a valid Control with no matching rule.

Expected result: no NFR artifact, catalog entry, allocation, or relationship is written; the Control
remains valid.

## Existing Validation Surface

```sh
/bin/bash .highway/tools/validate-skill.sh .highway/skills/highway-controls
/bin/bash .highway/tools/validate-skill.sh .highway/skills/highway-nfrs
/bin/bash .highway/tools/validate-library.sh .highway/library/templates/output/control-record.md
/bin/bash .highway/tools/validate-library.sh .highway/library/templates/output/nfr-record.md
/bin/bash .highway/tools/tests/adapter-coverage.test.sh
/bin/bash .highway/tools/tests/distribution-packaging.test.sh
/bin/bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: every command exits 0, generated registration artifacts correspond to both skills,
and no live root-level governance data is created by focused tests.

## Deferred Scope Check

Confirm the implementation adds no reverse NFR-to-Control generation, relationship reconciliation,
orphan repair, removal impact analysis, automatic synchronization, alternate relationship store, or
record-format change. Those behaviors are reserved for Phase 4.
