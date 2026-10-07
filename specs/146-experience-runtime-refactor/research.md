# Research: Experience Runtime Refactor

## Decision: Treat the Experience Standard as a standalone Markdown runtime contract

**Rationale:** The current artifact is `.highway/governance/experience-standard.md`; runtime behavior is expressed as definitions, X-rule tables, explanatory sections, and an Interaction Model. No executable runtime component or data store is introduced by this feature.

**Alternatives considered:** Introducing a runtime engine or schema was rejected because the feature explicitly changes the standard's contract and wording, not the execution environment.

## Decision: Remove development governance from the shipped runtime document

**Rationale:** The requested architecture assigns development validation to the development Constitution and user-visible interaction to the Experience Standard. Tier labels, validator mechanics, self-application, Constitution precedence, and detailed amendment policy therefore do not belong in the runtime artifact.

**Alternatives considered:** Retaining cross-references for traceability was rejected because an executing skill must be able to use the Experience Standard without loading development governance.

## Decision: Use version 9.0.0

**Rationale:** The clarification records a major refactor: runtime rule IDs are consolidated or retired, development-governance machinery is removed, and convergence semantics are strengthened.

**Alternatives considered:** 8.5.0 and 8.4.1 were rejected because the change is not merely additive or editorial.

## Decision: Preserve the clarified rule-ID ownership model

**Rationale:** X2.4 becomes the single questioning/clarification rule; X2.38 becomes the single substantive re-evaluation rule; X2.41 remains the convergence boundary; X2.37 remains the Contribution Opportunity rule. X2.14, X2.39, X2.40, and X2.8 retire into those owners. X2.2 and X2.13 are rationalized separately as advisory-before-questioning guidance rather than folded into X2.4.

**Alternatives considered:** Keeping every overlapping ID was rejected because it preserves competing obligations. Retiring IDs without recording their successor was rejected because it loses traceability.

## Decision: Validate with existing document-contract tests plus the full suite

**Rationale:** Existing tests already assert Experience Standard structure, convergence, amendment history, rule inventory, and protected-path behavior. The implementation should update those stale expectations or add narrowly scoped assertions for the 9.0.0 runtime boundary, removed metadata, surviving IDs, and retired IDs. The complete `.highway/tools/tests/run-all.sh` suite remains the final regression check.

**Alternatives considered:** Adding a new runtime test harness was rejected because the repository validates Markdown governance contracts through shell checks and the feature introduces no executable runtime code.

## Decision: No external contracts or data schema

**Rationale:** The artifact is consumed as Markdown guidance by existing workflows. The feature changes the document contract and its validation evidence, not a machine API, persistence model, or interchange format.

**Alternatives considered:** Creating `contracts/` or a new data schema was rejected as implementation detail outside the feature's scope.
