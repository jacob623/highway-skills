---
name: highway-clarify
description: "Generates, updates, validates, and serves deterministic clarification records for Highway artifacts."
usage: "Invoke as `/highway-clarify <ARTIFACT-ID>`, `/highway-clarify update <ARTIFACT-ID>`, `/highway-clarify inspect <ARTIFACT-ID>`, `/highway-clarify read <ARTIFACT-ID>`, or `/highway-clarify status <ARTIFACT-ID>`."
compatibility: all
metadata:
  version: 2.0.0
---

# highway-clarify

## Purpose

Manage deterministic clarification records and advisory guided resolution for Highway baselines without changing source content.

## When to use

- Identify contradictions, missing required information, explicitly unknown values, ambiguities, or unresolved assumptions in one supported artifact.
- Record a response, inspect clarification state, read the complete record, or retrieve lightweight status.
- Provide advisory clarification state without changing the source artifact.

## When not to use

- Do not use for unsupported, lowercase, or mixed-case identifiers, or implicit newest-file selection. Identifiers are case-sensitive.
- Do not use to modify, override, rewrite, replace, or update source artifact content.
- Do not infer contradictions from general knowledge, semantic similarity, architectural taste, or model reasoning.
- Do not block downstream source consumption based on open findings.

## Inputs

- One exact uppercase identifier from `REQ######`, `DISC######`, `ADR######`, or `RA######`.
- The source artifact resolved through identifier lookup, catalog lookup, or a declared artifact path.
- The colocated clarification artifact for Update, Inspect, Read, or Status.
- The complete `.highway/library/templates/output/clarification-record.md` contract.
- The complete `.highway/library/templates/output/clarification-catalog.md` contract.
- The repository catalog at `clarifications/clarifications.md` when present.
- Explicit artifact templates, contracts, required fields, and required sections used for analysis.
- The Clarification Profile and repository contradiction catalog when declared for the source artifact.
- The default ambiguity vocabulary and explicitly declared unknown markers.

## Ambiguity Vocabulary Contract

The authoritative default vocabulary is `TBD`, `TBA`, `unknown`, `undecided`, `unspecified`,
`not defined`, `not determined`, `pending`, `future decision`, and `future work`. Normalize a
candidate by trimming leading and trailing whitespace and comparing case-insensitively against
the complete phrase. Partial-word matching, regular expressions, and semantic similarity are
prohibited. Clarification Profile terms append to the defaults and cannot remove or redefine
them. Each matched term produces exactly one ambiguity finding.

## Contradiction Rule Contract

Contradiction findings use only explicitly declared rules. Each rule MUST define a Rule Identifier, Artifact Type Scope, Source Field A, Source Field B,
Contradiction Condition, and Finding Summary Template. A finding is produced only when both referenced fields exist and the declared condition
evaluates true. General knowledge, architectural recommendations, semantic inference, probability,
similarity scoring, and model judgment do not produce contradiction findings.

## Guided resolution contract

For every finding, Clarification generates deterministic advisory guidance without changing how
the finding was detected or who owns its lifecycle. The guidance contains exactly one Question
and one Why It Matters explanation. Open findings also contain exactly three generated options in
this order: A Recommended, B Alternative, C Alternative, and D Custom. Every generated option has
a deterministic rationale and traceable evidence sources. Resolved findings retain guidance,
selection, response, identity, fingerprint, history, and evidence references.

### Recommendation Precedence

Guidance generation uses only the declared artifact-specific sources and the following precedence:
Source artifact, Clarification responses, Profile, Objectives, Controls, NFRs, Discovery,
Reference Architectures, then Reference Implementations. Identical inputs produce identical
guidance, option ordering, rationale, and source traceability with no volatile metadata.
Generation never uses filesystem ordering. Catalog bootstrap is in-memory; recalculate current findings in category priority and source artifact order before source field and identifier order.

When no authoritative evidence is available, the Recommended option is `Unknown` with an
evidence-gap rationale. When multiple highest-precedence evidence items provide contradictory
values for the same finding, Clarification does not select either value as Recommended. It
generates `Unknown / Escalate for Decision`, records the conflicting evidence sources, presents
the conflicting values as alternatives B and C, explains why the conflict exists, and requires
explicit user selection among A, B, C, or D Custom.

The artifact-specific guidance sources are:

- `REQ`: Request evidence, Profile, Objectives, Controls, and NFRs.
- `DISC`: Discovery Findings, Assumptions, Risks, Unknowns, Objectives, Controls, and NFRs.
- `ADR`: Discovery handoff, ADR context, and selected candidate option.
- `RA`: Architecture contents, Controls, NFRs, and Objectives.

The `selected_option` field accepts only A, B, C, D, or None and is informational. Selecting an
option or providing a Custom candidate does not resolve a finding; only an explicitly accepted
response may perform `open -> resolved`. Resolved findings never transition to open. Source artifacts
remain byte-for-byte unchanged. Guidance never approves a governance decision,
architecture, recommendation, or ADR decision.

## Outputs

- Every supported source artifact maps to the stable identifier `CLAR-<ARTIFACT-ID>`.
- Every response exposes eight stable fields: `artifact_id`, `exists`, `status`, `open_findings`, `resolved_findings`, `total_findings`, `path`, and `blocking_reason`.
- Generate creates one colocated `<ARTIFACT-ID>-clarification.md` artifact.
- Generate and Update create or update `clarifications/clarifications.md`.
- The catalog contains exactly one row per clarification with Clarification ID, Artifact ID, Artifact Type, Status, and informational Clarification Path.
- Catalog rows are ordered by Artifact Type, then Artifact ID.
- Update records accepted responses, appends resolution history, updates status, increments revision after commit, and returns its response contract.
- Inspect returns status and finding counts without writing.
- Read returns the complete validated clarification artifact without writing.
- Status returns the lightweight consumer contract without writing.
- Open findings remain advisory and never block downstream source consumption.
- Finding states are restricted to `open` and `resolved`; counts satisfy `total_findings = open_findings + resolved_findings`.
- Source-resolution, validation, conflict, or write failure produces no partial output and preserves source bytes.
- The complete output structure is `.highway/library/templates/output/clarification-record.md`.
- The complete catalog structure is `.highway/library/templates/output/clarification-catalog.md`.
- Privacy filtering replaces retained secrets with `<secret-redacted>` and regulated personal data with `<pii-redacted>`.
- Each finding includes Question, Why It Matters, Recommended Option, Recommended Rationale,
  Alternative Option B and rationale, Alternative Option C and rationale, Custom Option, Selected
  Option, and evidence-source traceability.

Generate and Update conflict responses include `expected_revision` and `actual_revision`. The workflow uses no automatic merging, and any repository user may invoke the commands.

## Command Contract

- `/highway-clarify <ARTIFACT-ID>` invokes Generate.
- `/highway-clarify update <ARTIFACT-ID>` invokes Update.
- `/highway-clarify inspect <ARTIFACT-ID>` invokes Inspect.
- `/highway-clarify read <ARTIFACT-ID>` invokes Read.
- `/highway-clarify status <ARTIFACT-ID>` invokes Status.

Any repository user may invoke each command under existing repository access controls.

## Workflow

1. Validate the identifier as exact uppercase `REQ`, `DISC`, `ADR`, or `RA` plus six digits; abort invalid input.
2. Resolve the source through identifier, catalog, or declared-path lookup; abort missing, duplicate, or ambiguous resolution.
3. Derive `CLAR-<ARTIFACT-ID>` and its colocated path; never scan by filesystem order, timestamp, recency, or newest file.
4. Resolve profiles in artifact-local, artifact-type, then global order; use defaults when absent and abort when unreadable.
5. Load profiles, rules, structures, markers, and vocabulary; read-only commands do not write.
6. Analyze evidence in order: `contradiction`, `missing_input`, `unknown_value`, `ambiguity`, then `unresolved_assumption`.
7. Use explicit contradiction rules, declared missing-input structures, and unknown markers.
8. Apply the default vocabulary; profiles may extend but MUST NOT remove entries, using exact normalized phrase comparison.
9. Redact secrets and regulated personal data before generation, updates, or writes.
10. Validate the record against the shared template, identities, status rules, and source preservation; abort without writing on failure.
11. Validate finding states and counts before status derivation; invalid values produce malformed `blocked` records.
12. Generate MUST recalculate findings while preserving unchanged evidence and identities, retaining history and responses, then order by category, source order, field, and identifier.
13. Generate deterministic guidance for every open finding and retain it for resolved findings. Apply declared sources and precedence; highest-precedence conflicts produce `Unknown / Escalate for Decision`, alternatives B and C, recorded sources, an explanation, and required selection. Identical inputs produce identical bytes with no volatile metadata.
14. Validate the catalog against its template, mappings, artifacts, supported values, direct paths, and status before mutation.
15. If absent, build the catalog in memory from `.highway/library/templates/output/clarification-catalog.md`, add the row, and validate it.
16. Insert or replace the row, then order catalog rows by Artifact Type and Artifact ID.
17. Update rereads revision before writing; a mismatch returns conflict.
18. Successful Update appends history and increments revision once; competing updates are never merged.
19. Retry conflicts at most 3 times; then abort.
20. Generate and Update write only after validation; Inspect, Read, and Status write nothing.
21. Derive status by precedence: `blocked`, `complete`, `in-progress`, then `not-started`.

## Finding Identity Contract

Finding identifiers use `CLAR-<ARTIFACT-ID>-NNN`. Build each deterministic Fingerprint from
Category, Source Field or Section, and Evidence Reference. Match current fingerprints against the
prior clarification record, reuse an unchanged identifier, preserve identifiers when display
order changes, and allocate the next unused sequence only for a new fingerprint. Never renumber
existing findings. Record retired identifiers and never reuse them.

### Fingerprint Normalization Contract

Normalize every category, source field or section, and evidence reference before composing a
Fingerprint. Apply these steps in order:

1. Normalize line endings to LF.
2. Trim leading and trailing whitespace.
3. Convert values to lowercase.
4. Collapse consecutive whitespace to one space.
5. Replace source-field aliases with the canonical declared source-field name.

Fingerprints are generated only after normalization. Identical normalized inputs produce identical
fingerprints; inputs that remain different after normalization remain distinct.

The required terms are: trim leading and trailing whitespace, lowercase values, collapse consecutive whitespace, use the canonical declared source-field name, and generate fingerprints only after normalization.

### Finding State Contract

The supported finding states are exactly `open` and `resolved`. New findings start `open`. An
accepted response may transition an `open` finding to `resolved` (`open -> resolved`); a resolved
finding retains its identifier, fingerprint, history, and evidence references. Resolved findings
never transition to open, and no unsupported state may be persisted. Resolved findings retain
identifiers, and resolved findings never transition to open.

## Verification

- Confirm all five command forms and exact uppercase identifier families.
- Confirm `CLAR-<ARTIFACT-ID>` identity, colocated paths, and source immutability.
- Confirm artifact-local, artifact-type, then global profile precedence and default fallback.
- Confirm every response contains the eight stable consumer fields.
- Confirm the shared template contains frontmatter, findings, resolution history, source, status, counts, and revision.
- Confirm the catalog follows `.highway/library/templates/output/clarification-catalog.md` and contains one row per clarification.
- Confirm catalog rows use supported types and statuses, reference existing clarification artifacts, have no duplicate IDs or mappings, and match clarification status.
- Confirm catalog rows are ordered by Artifact Type then Artifact ID and repeated identical inputs produce identical catalog bytes.
- Confirm regeneration preserves unchanged-evidence responses and history.
- Confirm category, source order, source field name, and finding identifier ordering.
- Confirm identical inputs produce identical generated bytes without volatile metadata.
- Confirm explicit contradiction and missing-input rules, and unknown-marker handling.
- Confirm the Ambiguity Vocabulary Contract matches all ten defaults only after trimming and case-folding, rejects partial words, regular expressions, and semantic similarity, and appends profile terms without removing defaults.
- Confirm contradiction findings require declared rules, both source fields, and a true condition; general knowledge, architectural recommendations, semantic inference, probability, similarity, and model judgment produce none.
- Confirm Finding Identity Contract fingerprints preserve IDs through reordering and removal, allocate only the next unused sequence, and never reuse retired identifiers.
- Confirm the Fingerprint Normalization Contract normalizes line endings to LF, trims, lowercases, collapses consecutive whitespace, and uses the canonical declared source-field name before fingerprint generation.
- Confirm case differences, surrounding whitespace, repeated whitespace, and source-field aliases do not create distinct fingerprints, while inputs different after normalization remain distinct.
- Confirm the Finding State Contract permits only `open` and `resolved`, new findings begin `open`, accepted responses use `open -> resolved`, resolved findings retain identifiers and history, and resolved findings never transition to `open`.
- Confirm total findings equals open findings plus resolved findings, malformed count relationships produce `blocked`, and this validation precedes complete/in-progress status derivation.
- Confirm every catalog entry resolves to an existing clarification artifact, every clarification artifact has exactly one catalog entry, catalog status equals clarification status, and Clarification Path resolves to the referenced clarification artifact.
- Confirm Generate recalculates current findings while preserving finding identities, and identical inputs produce identical bytes with no volatile metadata.
- Confirm status precedence selects exactly one state in the order `blocked`, `complete`, `in-progress`, `not-started`.
- Confirm privacy filtering uses `<secret-redacted>` and `<pii-redacted>` before retention.
- Confirm conflicts perform no write, append no history, and never merge automatically.
- Confirm successful Updates increment revision exactly once and retries stop after 3 conflicts.
- Confirm malformed records return `blocked` with a reason and read-only commands write nothing.
- Confirm open findings remain advisory and do not block downstream source consumption.
- Confirm guided resolution generates exactly one Question and one Why It Matters explanation,
  A Recommended, B Alternative, C Alternative, and D Custom with rationale and source traceability.
- Confirm identical inputs produce identical guidance with no volatile metadata, resolved findings
  retain guidance, and highest-precedence conflicts escalate without selecting either value.
- Confirm Selected Option accepts only A, B, C, D, or None and cannot resolve a finding without an
  explicitly accepted response.
- Run `.highway/tools/validate-skill.sh .highway/skills/highway-clarify` and `.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md`.

## Error Handling

- Invalid, lowercase, mixed-case, unsupported, missing, duplicate, or ambiguous identifier: abort.
- Missing, unreadable, or malformed source: abort without writing.
- Missing required structure with no declaration: fall back.
- Declared missing required structure: fall back to the declared field or section.
- Explicit contradiction rule mismatch: fall back to the next analysis category.
- Invalid response or unknown finding: abort the Update.
- Privacy-blocked response: abort the Update and write nothing.
- Malformed clarification artifact: abort with `blocked` and a non-empty blocking reason.
- Unsupported finding state, resolved-to-open transition, negative/non-integer count, or count mismatch: abort with malformed `blocked` status and preserve all pre-operation bytes.
- Revision mismatch: retry at most 3 times.
- Three revision conflicts: abort.
- Missing optional Clarification Profile: fall back to defaults.
- Unreadable selected Clarification Profile: abort.
- Sensitive value in retained content: abort before writing.
- Missing catalog: construct an in-memory catalog from the authoritative template, validate it as existing, and abort without writing if validation fails.
- Malformed catalog, duplicate mapping, missing clarification reference, unsupported type or status, or status mismatch: abort and preserve catalog bytes.
- Catalog write failure: abort and preserve clarification and catalog bytes.
- Clarification Path that does not resolve directly to the authoritative artifact: abort and preserve all pre-operation bytes.
- Validation or clarification write failure: abort and preserve all pre-operation bytes.
- Suspected vulnerability or unauthorized access-control failure: report the condition and abort.

## Example

`/highway-clarify REQ000001`

`/highway-clarify update REQ000001`
