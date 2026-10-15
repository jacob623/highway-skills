# Data Model: Explicit ADR Option Selection

## Discovery

An accepted, immutable advisory source identified by `DISC######`.

**Relevant fields**:

- `id`: unique Discovery identifier.
- `options`: one or more Discovery-owned options.
- `recommended_option`: advisory recommendation, when available.
- `recommendation_rationale`: advisory explanation.
- `scores`: Discovery-owned comparison evidence.
- `comparison_matrix`: Discovery-owned comparison evidence.

**Validation**: exactly one Discovery resolves; the record is accepted, complete, and readable. ADR never mutates these fields.

## Discovery Option

A candidate owned by a Discovery and identified by `OPT######`.

**Relevant fields**:

- `id`: unique within the Discovery and stable across the workflow.
- `summary`: user-visible option description.
- `supporting_details`: evidence used in the decision context.

**Validation**: the selected option must occur in the supplied Discovery's option set. Duplicate, malformed, unknown, and cross-Discovery identifiers are invalid.

## ADR Decision Selection

The explicit option identifier supplied by the decision owner.

**Relevant fields**:

- `discovery_id`: source `DISC######`.
- `selected_option_id`: explicit `OPT######`.
- `selection_source`: user-provided selection, not recommendation or score.

**State**: absent before a valid explicit invocation; present only after the owner supplies one valid option. A missing selection pauses at the prompt and is never inferred.

## Recommendation

Advisory Discovery output used to inform the owner.

**Relevant fields**:

- `recommended_option`.
- `recommendation_rationale`.
- `scores`.
- `comparison_matrix`.

**Ownership**: Discovery owns all recommendation fields. ADR may project or display them but cannot use them as an implicit selection or modify them.

## ADR Record

A durable decision artifact identified by `ADR######`.

**Relevant fields**:

- `discovery_id`.
- `selected_option_id`.
- `decision_rationale`.
- `consequences`.
- `architecture_commitment`.
- `traceability`.

**Validation**: one selected option, explicit selection evidence, complete existing ADR sections, accepted initial status, and unchanged upstream source bytes.

## ADR Catalog

The authoritative allocation and index source.

**Relevant fields**:

- `next_id`: next available `ADR######`.
- `entries`: direct ADR records keyed by ADR identifier and Discovery identifier.

**Validation**: no duplicate Discovery entry; missing-option and invalid-option paths do not read and advance allocation or write catalog bytes.

## Relationships

- One accepted Discovery contains one or more Discovery Options.
- One successful ADR contains exactly one Decision Selection.
- One successful ADR references exactly one Discovery.
- One Discovery may have at most one ADR under the existing ADR uniqueness contract.
- Recommendation fields are projected from Discovery to ADR context without ownership transfer.
