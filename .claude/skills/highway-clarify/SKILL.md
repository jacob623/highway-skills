---
name: highway-clarify
description: "Manages Highway data."
usage: "Invoke as `/highway-clarify <ID>`."
compatibility: all
metadata:
  version: 1.0.0
---

# highway-clarify

## Purpose

Manage review records for authoritative Highway baselines without changing source content.

## When to use

- A repository user needs to identify contradictions, missing required information, explicitly unknown values, ambiguities, or unresolved assumptions in one supported artifact.
- A repository user needs to record a response, inspect clarification state, read the complete record, or retrieve a lightweight status.
- A downstream workflow needs advisory clarification state without changing the source artifact.

## When not to use

- Do not use for unsupported identifier families, lowercase or mixed-case identifiers, or implicit newest-file selection. Identifiers are case-sensitive.
- Do not use to modify, override, rewrite, replace, or update source artifact content.
- Do not use to infer contradictions from general knowledge, semantic similarity, architectural taste, or model reasoning.
- Do not use to block downstream source consumption based on open findings.

## Inputs

- One exact uppercase identifier from `REQ######`, `DISC######`, `ADR######`, or `RA######`.
- The source artifact resolved through identifier lookup, catalog lookup, or a declared artifact path.
- The colocated clarification artifact when using Update, Inspect, Read, or Status.
- The complete `.highway/library/templates/output/clarification-record.md` contract.
- Explicit artifact templates, contracts, owning skill outputs, workflow contracts, required fields, and required sections used for missing-input analysis.
- The Clarification Profile and repository contradiction catalog when declared for the source artifact.
- The default ambiguity vocabulary and explicitly declared unknown markers.

## Outputs

- Generate creates one colocated `<ARTIFACT-ID>-clarification.md` artifact and returns the Generate response contract.
- Update records accepted responses, appends resolution history, updates status, increments revision after commit, and returns the Update response contract.
- Inspect returns status, open findings, resolved findings, total findings, path, and blocking reason without writing.
- Read returns the complete validated clarification artifact without writing.
- Status returns the lightweight consumer contract without writing.
- Open findings remain advisory and never block downstream source consumption.
- A source-resolution, validation, conflict, or write failure produces no partial clarification output and preserves source bytes.
- The complete output structure is `.highway/library/templates/output/clarification-record.md`.

Generate and Update conflict responses include `expected_revision` and `actual_revision`.
The workflow uses no automatic merging, and any repository user may invoke the commands.

## Command Contract

- `/highway-clarify <ARTIFACT-ID>` invokes Generate.
- `/highway-clarify update <ARTIFACT-ID>` invokes Update.
- `/highway-clarify inspect <ARTIFACT-ID>` invokes Inspect.
- `/highway-clarify read <ARTIFACT-ID>` invokes Read.
- `/highway-clarify status <ARTIFACT-ID>` invokes Status.

Any repository user may invoke each command under existing repository access controls.

## Workflow

1. Validate the supplied identifier as exact uppercase `REQ`, `DISC`, `ADR`, or `RA` followed by six digits; on failure, abort and report the invalid identifier.
2. Resolve the source through identifier lookup, catalog lookup, or a declared path in the published precedence order; on missing, duplicate, or ambiguous resolution, abort.
3. Derive the colocated clarification path as `<ARTIFACT-ID>-clarification.md`; do not scan by filesystem ordering, timestamp, recency, or newest-file selection.
4. For Generate, load the declared profile, contradiction rules, required structures, unknown markers, and ambiguity vocabulary; for read-only commands, load and validate the clarification artifact without writing.
5. Analyze evidence in this order: `contradiction`, `missing_input`, `unknown_value`, `ambiguity`, `unresolved_assumption`; when categories overlap, emit only the highest-priority category and one finding per evidence source.
6. Produce contradiction findings only from explicit source, profile, or repository-catalog rules; produce missing-input findings only from declared required structures; classify unknown markers without classifying absence as unknown.
7. Apply the default ambiguity vocabulary `modern`, `scalable`, `appropriate`, `reasonable`, `adequate`, `sufficient`, `robust`, `flexible`, `user-friendly`, `efficient`, `best practice`, `future-proof`, `enterprise-grade`, `simple`, `easy`, and `optimized`, unless an explicit profile replaces or extends it.
8. Validate the complete clarification record in memory against the shared template, stable finding identities, status rules, and source-byte preservation; on validation failure, abort and write nothing.
9. For Update, read and record the integer revision, stage the response in memory, reread the revision immediately before writing, and abort with a conflict response when expected and actual revisions differ.
10. On a successful Update commit, append history and increment revision by exactly one; never automatically merge competing responses, findings, history, statuses, or metadata.
11. Permit a caller to retry a conflict no more than 3 times; after the third conflict, abort.
12. For Generate and Update, write only the colocated clarification artifact after all validation passes; for Inspect, Read, and Status, write nothing.
13. Derive status as `not-started` when no clarification artifact exists, `in-progress` when findings remain open, `complete` when zero or all findings are resolved, and `blocked` when the clarification artifact is malformed.

## Verification

- Confirm all five command forms are recognized and map to their declared response contract.
- Confirm only exact uppercase `REQ######`, `DISC######`, `ADR######`, and `RA######` identifiers are accepted.
- Confirm source resolution uses only declared lookup mechanisms and never filesystem order, timestamps, recency, or newest-file selection.
- Confirm the clarification path is colocated and uses `<ARTIFACT-ID>-clarification.md`.
- Confirm the shared template contains YAML frontmatter, structured body sections, findings, resolution history, source details, status, and revision.
- Confirm category evaluation order and one-finding-per-evidence behavior.
- Confirm contradiction findings require explicit rules and missing-input findings require declared structure.
- Confirm explicit unknown markers are detected and absent fields are not classified as unknown.
- Confirm Generate and Update preserve source bytes and leave no partial clarification output on failure.
- Confirm revision conflicts report expected and actual revisions, perform no write, append no history, and never merge automatically.
- Confirm successful Update increments revision exactly once and conflict retries stop after 3 attempts.
- Confirm Inspect, Read, and Status perform no writes and malformed records return `blocked` with a reason.
- Confirm open findings remain advisory and do not block downstream source consumption.
- Run `.highway/tools/validate-skill.sh .highway/skills/highway-clarify` and `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md`.

## Error Handling

- Invalid, lowercase, mixed-case, unsupported, missing, duplicate, or ambiguous identifier: abort.
- Missing, unreadable, or malformed source: abort.
- Missing required structure: fall back to no `missing_input` finding when no structure is declared; otherwise record the declared missing field or section.
- Explicit contradiction rule mismatch: fall back to the next analysis category.
- Invalid response or unknown finding: abort the Update and preserve artifact and source bytes.
- Privacy-blocked response: abort the Update and write nothing.
- Malformed clarification artifact: abort read-only processing with `blocked` and a non-empty blocking reason.
- Revision mismatch: retry at most 3 times.
- Three revision conflicts: abort.
- Validation or write failure: abort.
- Suspected vulnerability or unauthorized access-control failure: report the condition and abort.

## Example

`/highway-clarify REQ000001`

`/highway-clarify update REQ000001`

