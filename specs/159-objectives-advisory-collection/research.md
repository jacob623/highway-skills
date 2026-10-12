# Research: Objectives Advisory Collection

## Decision: Keep highway-objectives as the sole behavioral owner

**Rationale:** The existing skill owns Objective meaning, completeness, acceptance, readiness,
duplicate/overlap handling, identifiers, catalog mutation, persistence, and owner results. The
feature changes collaboration guidance and staged processing, not those ownership boundaries.

**Alternatives considered:** Moving advisory behavior into Profile or the Experience Standard was
rejected because it would duplicate ownership and violate the feature's explicit preservation scope.

## Decision: Model multi-select as transient ordered working state

**Rationale:** A selected recommendation is accepted as a recommendation, but unresolved Success
Measures must block capture. An ordered queue makes the per-recommendation statement, Success,
rationale, review, and capture sequence explicit without creating a new retained schema.

**Alternatives considered:** Capturing all selected recommendations together was rejected because it
can imply completion and bypass unresolved Success evidence. Persisting queue checkpoints was rejected
because the existing workflow does not persist conversational state.

## Decision: Use static source and adapter contract tests

**Rationale:** This repository ships Markdown skill contracts and generated copies. Focused tests can
verify exact wording, ordering, protected contracts, adapter equality, and fixture non-mutation;
runtime conversational quality remains outside static test capability.

**Alternatives considered:** Adding a runtime service or model harness was rejected as outside the
repository architecture and feature scope.

## Decision: Increment the skill version MAJOR

**Rationale:** Changing the review prompt and multi-selection behavior changes externally observable
skill guarantees. Constitution P7.7 and the Skill Versioning Policy require a MAJOR increment for a
breaking contract or behavioral guarantee change.

**Alternatives considered:** MINOR was rejected because these are not additive-only behaviors; the
existing multi-select capture behavior is intentionally replaced.

## Decision: No new external contract artifact

**Rationale:** The feature exposes no API, CLI schema, database migration, or service boundary.
The Markdown skill body and its generated adapters are the complete delivery surface.

**Alternatives considered:** A contracts document was considered but would duplicate the authored
skill and create a second source of truth.