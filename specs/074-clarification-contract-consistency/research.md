# Research: Clarification Contract Consistency

## Decision 1: Keep canonical inputs authoritative

Decision: Edit `.highway/skills/highway-clarify/SKILL.md` and `.highway/library/templates/output/clarification-record.md` as the canonical contract sources.
Rationale: Existing generators derive agent adapters and catalogs from these repository inputs, so changing generated copies directly would violate the repository's generation boundary.
Alternatives considered: Editing only generated adapters was rejected because it would be overwritten and would leave canonical behavior contradictory.

## Decision 2: Use separate recommendation basis/state pairs

Decision: Preserve the three basis values `authoritative`, `evidence-gap`, and `conflict`; map the latter two to `Unknown` and `Escalate for Decision` respectively.
Rationale: The existing Feature 073 contract already defines these values and the requested feature removes only the retired combined state.
Alternatives considered: Introducing a new conflict or uncertainty vocabulary was rejected because it would expand the contract and reintroduce interpretation drift.

## Decision 3: Validate generated output as well as examples

Decision: Treat catalogs, adapters, validation outputs, generated examples, and retained artifacts derived from canonical Clarification inputs as generated-artifact scope.
Rationale: The feature requirements explicitly cover generated records and copies, and the repository already has generator and adapter correspondence tests.
Alternatives considered: Searching only canonical files was rejected because stale generated output could still ship contradictory behavior.

## Decision 4: Make invalid records fail before writes

Decision: Keep the existing no-partial-write and source-immutability contract as the single failure consequence for invalid basis/state pairings, history duplicates, and evidence structures.
Rationale: This matches the current skill workflow and allows all new validation fixtures to assert byte preservation without introducing a new transaction mechanism.
Alternatives considered: Repairing malformed records in place was rejected because it would alter retained artifacts without an accepted response or explicit source change.

## Decision 5: Use focused static and disposable fixtures

Decision: Extend the existing Clarification and output-template tests with static contract assertions and disposable fixtures for each requested invalid state or structure.
Rationale: The test suite already declares source-document, generated-artifact, and disposable-fixture classes and supports portable Bash 3.2 checks.
Alternatives considered: Adding a new test framework was rejected because it would add a runtime dependency without improving coverage of the Markdown/Bash contract.
