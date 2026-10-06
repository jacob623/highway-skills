# Research: Experience Standard Runtime Contract Refactor

## Decision: Keep the Experience Standard as the sole shared runtime interaction contract

**Rationale:** The specification assigns generic user-visible interaction behavior to the Experience Standard while Highway Identity supplies identity and owning skills supply domain semantics, completeness, acceptance, and persistence. The refactor can therefore remove duplicated explanations without moving behavior across ownership boundaries.

**Alternatives considered:** Moving the interaction loop into Highway Identity or repeating it in each owning skill was rejected because either option would create a competing runtime contract and increase maintenance drift.

## Decision: Preserve the existing X-rule inventory and validate by stable identifiers

**Rationale:** X-rule IDs and Observables are the stable normative surface. The implementation should compare the refactored inventory against the current baseline and separately verify the compact Interaction Model, targeted guidance, examples, ownership boundaries, and version metadata.

**Alternatives considered:** Renumbering rules or replacing the inventory with prose-only guidance was rejected because it would break traceability and make behavioral preservation harder to review.

## Decision: Use documentation-only implementation with focused static validation

**Rationale:** The requested change affects one Markdown governance document. It introduces no runtime state, schema, persistence, dependency, generated adapter, or external interface. A focused Bash contract test and the existing full suite are sufficient validation surfaces.

**Alternatives considered:** Adding a runtime interaction engine, persisted inference state, or a new contract schema was rejected because the feature explicitly preserves current behavior and ownership boundaries.

## Decision: Treat the 25% reduction target as a measured planning/validation check

**Rationale:** The specification defines a measurable shorter-document outcome but does not prescribe a tooling mechanism. Planning can measure the pre-refactor and post-refactor line counts, while contract assertions protect the retained behavior.

**Alternatives considered:** Establishing a new generalized documentation metrics tool was rejected as unnecessary for a single-document refactor.

## Decision: No external contracts directory

**Rationale:** This repository distributes Markdown governance and agent skill artifacts rather than exposing an API, endpoint, CLI schema, or machine protocol for this feature. The document contract is represented by the source file and focused validation test.

**Alternatives considered:** Creating a synthetic API contract was rejected because it would document an interface the repository does not expose.
