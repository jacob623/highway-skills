# Contract: Relationship Integrity Workflow

## Inputs

The workflow reads the user-owned Control and NFR baselines, their existing catalogs, and a mode:
`Inspect`, `Repair`, or `Impact`.

It MUST locate the project root from `.highway/` and MUST not guess a governance path. Missing,
malformed, duplicate, or inconsistent baselines are blocking conditions for repair.

## Inspect Mode

Inspect mode MUST:

- read every Control `nfrs` value and NFR `controls` value;
- validate identifier format, target existence, target type, reciprocal membership, and duplicates;
- classify findings as valid, malformed, orphaned, asymmetric, duplicate, or blocked;
- sort records and findings canonically by immutable identifiers; and
- emit a deterministic Relationship Summary, Integrity Report, and Repair Recommendations section.

Inspect mode MUST NOT write records, catalogs, relationship fields, or repair plans.

## Repair Proposal Contract

Each recommendation MUST contain:

- affected artifact type, immutable ID, and path;
- current relationship state;
- proposed relationship state;
- reason for the proposal; and
- impact on reciprocal traceability.

A reciprocal repair adds only the missing immutable identifier. An orphan repair removes only the
invalid reference. A direct NFR with `controls: []` has no repair recommendation merely because it
is unlinked.

Recommendations MUST be independently selectable and ordered deterministically.

## Repair Confirmation Contract

The complete proposal MUST be shown before any write. The author may approve, reject, or cancel
each recommendation. An incomplete or ambiguous decision cancels the operation. Rejection,
cancellation, or read-only mode produces zero writes.

## Approved Repair Contract

Before commit, validate the selected recommendations against the baseline snapshot and confirm:

1. every target exists and has the expected type;
2. every relationship ID remains immutable and correctly formatted;
3. only relationship fields are selected for mutation;
4. approved changes produce reciprocal valid edges; and
5. all expected files and catalogs remain unchanged except for approved relationship changes and
   required existing catalog regeneration.

Apply the selected relationship-only changes as one operation. If any precondition or write fails,
stop before partial writes and report the blocking condition.

## Impact Mode Contract

For Control removal, NFR removal, or baseline replacement, list every affected artifact individually
by immutable identifier and title, including relationship direction and the traceability that would
be lost. A count alone is invalid. The owning Control/NFR workflow must show this impact before its
destructive confirmation.

An empty impact set is reported explicitly. Declined or incomplete destructive confirmation writes
nothing.

## Determinism and Scope Contract

Identical baselines and mode inputs produce byte-identical classification, recommendation content,
ordering, and report output. Output MUST contain no timestamp, random value, environment-derived
value, or filesystem-order dependency.

This workflow does not create Controls or NFRs, derive governance intent, edit titles/statements/
rationales/statuses, reclassify artifacts, synchronize future relationship types, or add a second
relationship store.
