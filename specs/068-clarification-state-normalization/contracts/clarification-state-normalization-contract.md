# Clarification State and Fingerprint Normalization Contract

## Scope

This contract defines Feature 068 additions to the Feature 067 Clarify identity, finding state,
record count, and catalog consistency behavior. Existing command syntax, supported artifact types,
artifact ownership, analysis ordering, and source immutability remain authoritative.

## Fingerprint Normalization Contract

Fingerprint generation uses normalized inputs.

Apply normalization in this order:

1. Normalize line endings to LF.
2. Trim leading and trailing whitespace.
3. Convert values to lowercase.
4. Collapse consecutive whitespace into a single space.
5. Normalize source-field identifiers using their canonical declared names.

Fingerprints are generated only after normalization.

Requirements, `requirements`, and ` REQUIREMENTS ` all normalize to `requirements`.
Identical normalized inputs MUST generate identical fingerprints.

## Finding State Contract

Supported finding states are:

- `open`
- `resolved`

State transitions:

`open` -> `resolved`

Permitted rules:

- New findings begin in `open`.
- A finding remains open until an accepted response resolves it.
- A resolved finding retains its identifier, fingerprint, history, and evidence references.
- A resolved finding MUST NOT transition back to open.

No other states are permitted.

## Count Invariant Contract

The clarification record MUST satisfy:

`total_findings = open_findings + resolved_findings`

All three values MUST be non-negative integers. A record violating the invariant or containing an
unsupported state is malformed and derives status `blocked` before count-based status evaluation.

## Catalog Consistency Contract

Before a catalog or clarification write:

- Every catalog entry MUST resolve to an existing clarification artifact.
- Every authoritative clarification artifact MUST have exactly one catalog entry when cataloged.
- Catalog status MUST equal clarification-artifact status.
- Clarification Path MUST resolve directly to the referenced clarification artifact.

These checks apply to bootstrap and maintenance. Any failure preserves all pre-operation
clarification and catalog bytes. Clarification Path is informational and does not replace the
authoritative clarification artifact.

## Verification Contract

Verification must confirm:

- fingerprint inputs are normalized before fingerprint generation;
- case differences do not produce different fingerprints;
- surrounding whitespace differences do not produce different fingerprints;
- repeated whitespace does not change fingerprints;
- all findings use supported states only;
- new findings begin in `open`;
- resolved findings retain identifiers and history;
- resolved findings never transition to `open`;
- `total_findings` equals `open_findings` plus `resolved_findings`;
- malformed count relationships produce `blocked` status;
- every catalog entry resolves to an existing clarification artifact;
- every clarification artifact has exactly one catalog entry;
- catalog status equals clarification status; and
- Clarification Path resolves to the referenced clarification artifact.
