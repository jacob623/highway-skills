# Clarification Determinism and Lifecycle Contract

## Scope

This contract defines the Feature 067 additions to `highway-clarify` and its clarification catalog. Feature 066 remains authoritative for command syntax, supported artifact types, base catalog identity, status values, ordering, ownership, and transaction behavior unless this contract explicitly adds a rule.

## Ambiguity Vocabulary Contract

The default vocabulary is authoritative unless extended by a Clarification Profile. The default terms are `TBD`, `TBA`, `unknown`, `undecided`, `unspecified`, `not defined`, `not determined`, `pending`, `future decision`, and `future work`.

Matching is case-insensitive exact normalized phrase comparison. Leading and trailing whitespace is ignored. Partial-word matching, regular expressions, and semantic similarity are prohibited. Profile extensions append phrases and cannot remove or redefine default terms. One matched term produces one ambiguity finding.

## Contradiction Rule Contract

Contradiction detection uses only explicitly declared contradiction rules. Each rule contains a Rule Identifier, Artifact Type Scope, Source Field A, Source Field B, Contradiction Condition, and Finding Summary Template.

A contradiction finding requires both referenced fields to exist and the declared condition to evaluate true. General knowledge, architectural recommendations, semantic inference, probability, similarity scoring, and model judgment are not contradiction rules and cannot produce findings.

## Finding Identity Contract

Finding identifiers use `CLAR-<ARTIFACT-ID>-NNN`. A deterministic fingerprint contains Category, Source Field or Section, and Evidence Reference.

- Match current fingerprints against prior fingerprints.
- Reuse the existing identifier when a fingerprint is unchanged.
- Preserve identifiers when findings are reordered.
- Allocate the next unused sequence only for a new fingerprint.
- Never renumber existing findings.
- Retired identifiers are never reused.

## Status Contract

Status is selected by the first matching condition in this order:

1. `blocked`: the clarification artifact exists and is malformed or structurally invalid.
2. `complete`: the record is valid and `open_findings` equals zero.
3. `in-progress`: the record is valid and `open_findings` is greater than zero.
4. `not-started`: the clarification artifact does not exist.

Exactly one status is selected. Blocked status overrides all count-based states.

## Catalog Bootstrap Contract

When `clarifications/clarifications.md` is absent:

1. Read the authoritative `.highway/library/templates/output/clarification-catalog.md` structure into an in-memory catalog.
2. Add the proposed clarification row, including its informational Clarification Path.
3. Validate the constructed catalog with the same rules used for an existing catalog.
4. Write the clarification and catalog only after both validations succeed.

A validation or write failure preserves all pre-operation clarification and catalog bytes.

## Catalog Row Contract

The Clarification Index contains:

| Clarification ID | Artifact ID | Artifact Type | Status | Clarification Path |
|---|---|---|---|---|
| `CLAR-REQ000001` | `REQ000001` | `REQ` | `in-progress` | `requests/REQ000001-clarification.md` |

The path is informational and resolves directly to the authoritative clarification artifact. Rows are unique and sorted by Artifact Type, then Artifact ID. Supported types are `REQ`, `DISC`, `ADR`, and `RA`; supported statuses are `not-started`, `in-progress`, `complete`, and `blocked`.

## Verification Contract

Verification must confirm:

- exact case-insensitive ambiguity matching after trimming;
- no regular-expression, semantic, or partial-word matching;
- profile extensions append without removing defaults;
- contradiction findings originate only from declared rules;
- contradiction detection uses no inference, similarity, probability, or model judgment;
- unchanged fingerprints retain identifiers;
- reordered findings retain identifiers;
- removed findings do not renumber later findings;
- retired identifiers are never reused;
- identical inputs produce identical finding identifiers;
- blocked status overrides other statuses;
- status precedence selects exactly one state;
- missing catalogs are built from the authoritative template;
- bootstrap catalogs receive existing-catalog validation; and
- validation and write failures preserve pre-operation bytes.
