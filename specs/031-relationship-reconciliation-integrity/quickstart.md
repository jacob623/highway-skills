# Quickstart: Relationship Reconciliation and Integrity Management

## Prerequisites

- Repository checkout at the project root with `.highway/` present.
- A disposable `library/governance/` fixture tree; do not use live user-owned governance data.
- Existing Control and NFR record formats with `nfrs` and `controls` relationship fields.
- Bash 3.2-compatible shell utilities.

## Focused Validation

Run the relationship contract test:

```sh
/bin/bash .highway/tools/tests/relationship-integrity.test.sh
```

Expected result: valid, malformed, orphaned, asymmetric, direct-NFR, deterministic, proposal,
confirmation, impact, preservation, and atomicity checks pass without writing live governance data.

## Inspect Scenario

1. Prepare isolated records containing a valid reciprocal edge, a missing reciprocal edge, an orphan
   Control reference, an orphan NFR reference, a malformed identifier, and a direct NFR with
   `controls: []`.
2. Run Inspect mode and capture the report.
3. Snapshot all fixture files before and after the run.
4. Compare two inspect runs over identical inputs.

Expected result: findings are classified and canonically ordered, direct NFRs remain valid, output is
byte-identical across runs, and no file changes occur.

## Repair Proposal Scenario

1. Run Repair mode against the asymmetric and orphan fixtures.
2. Confirm each proposal lists artifact, current state, proposed state, reason, and impact.
3. Reject or cancel once and compare the complete fixture snapshot.
4. Approve a reciprocal addition and an orphan removal independently.
5. Re-run Inspect mode.

Expected result: rejection/cancellation writes nothing; approved changes modify only relationship
fields and leave all resulting links reciprocal and resolvable.

## Impact Scenario

1. Request removal analysis for a related Control, related NFR, and a baseline replacement.
2. Verify every affected immutable identifier and title is listed individually.
3. Decline confirmation and compare records, catalogs, and relationships before and after.

Expected result: counts never substitute for the affected-item list, and declined destructive
operations write nothing.

## Existing Validation Surface

```sh
/bin/bash .highway/tools/validate-skill.sh .highway/skills/highway-relationships
/bin/bash .highway/tools/validate-skill.sh .highway/skills/highway-controls
/bin/bash .highway/tools/validate-skill.sh .highway/skills/highway-nfrs
/bin/bash .highway/tools/tests/adapter-coverage.test.sh
/bin/bash .highway/tools/tests/distribution-packaging.test.sh
/bin/bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: source skills, catalogs, adapters, and distribution declarations correspond; all
focused and repository tests pass; and no live `library/governance/` data is created or modified.

## Scope Check

Confirm the implementation does not create or derive Controls/NFRs, edit statements or rationales,
reclassify artifacts, repair future relationship types, or add a second relationship store.
