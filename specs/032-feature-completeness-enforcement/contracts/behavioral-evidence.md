# Behavioral Evidence Contract

## Purpose

Define the observable contract used to validate Features 030 and 031 without treating Markdown phrase
presence as proof of workflow behavior.

## Evidence Categories

Every requirement coverage row uses exactly one primary category:

- `behavioral`: an executable disposable-tree case observes the promised input, output, writes, and preservation behavior.
- `structural`: a validator or correspondence check proves repository shape, packaging, or generated-surface agreement.
- `documentation-only`: a contract is present but no executable behavior currently proves it.
- `deferred`: the requirement is intentionally not claimed as complete and includes a reason.

## Feature 030 Behavioral Contract

1. Create a disposable valid baseline containing Controls, NFRs, relationship fields, and catalog state.
2. Generate candidates from the documented rule inputs and compare candidate content and ordering to the expected result.
3. Verify proposal generation changes no baseline bytes.
4. Exercise Accept, Modify, Replace, Reject, and Cancel decisions independently.
5. For accepted decisions, verify exactly one allocated immutable NFR, reciprocal identifier-only relationships, and preservation of unrelated bytes.
6. For rejected, cancelled, invalid, and no-candidate cases, verify zero writes.
7. Inject allocation or commit failure and verify exact restoration of every affected record and catalog.
8. Validate direct NFR authoring with `controls: []` without inferring a Control.

## Feature 031 Behavioral Contract

1. Create a disposable baseline containing valid, asymmetric, orphaned, malformed, duplicate, and blocked relationship cases.
2. Inspect every relationship and compare deterministic classifications and ordering to expected output.
3. Generate proposals containing artifact, current state, proposed state, reason, and impact.
4. Exercise read-only, approve, reject, cancel, incomplete, and independent subset decisions.
5. Verify reciprocal repairs add only missing IDs, orphan repairs remove only invalid references, and duplicate repairs retain one occurrence.
6. Inject validation, staging, and commit failures and verify exact restoration of affected records and catalogs.
7. Analyze removal and explicit proposed-baseline replacement; list every affected artifact and relationship by ID and title before confirmation.
8. Repeat inspection and planning over byte-identical baselines and compare outputs byte-for-byte.

## Atomicity Contract

An approved operation is successful only when its complete selected change set and required catalog
outputs commit together. Any failure before completion returns a blocking result and restores every
snapshot in the affected set. A one-sided relationship, partially allocated NFR, changed unrelated
record, or changed unrelated catalog is a failure.

## Cleanup Contract

Every case runs in an isolated temporary tree, records its expected cleanup paths, removes probes on
success and failure, and verifies that no temporary files remain in the working tree.

## Lifecycle Contract

A feature cannot be labeled complete while any required coverage row is missing or any requirement is
supported only by documentation where executable evidence is required. Status, task checkboxes,
coverage outcomes, and test evidence must make the same claim.
