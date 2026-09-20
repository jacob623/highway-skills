---
name: highway-discovery
description: "Manages a repository-wide Discovery baseline."
usage: "Invoke as `/highway-discovery` and state the Request."
compatibility: all
metadata:
  version: 1.0.0
---

# highway-discovery

## Purpose

Creates one deterministic Discovery analysis between a completed Request and later ADR work.

## When to use

- A requester has supplied exactly one completed Request identifier in `REQ` plus six digits.
- The repository needs deterministic findings, assumptions, risks, unknowns, approaches, and
  advisory Objective, Control, and NFR candidates before ADR work.
- A later `highway-adr` workflow needs one stable Discovery input.

## When not to use

- Do not select Requests by recency, filename order, or batch listing.
- Do not analyze an incomplete Request or invent missing business evidence.
- Do not approve, create, update, or remove Objectives, Controls, NFRs, Requests, ADRs, or
  architecture artifacts.

## Inputs

- Exactly one explicit `REQ` identifier followed by six digits.
- The uniquely resolved Request at the user-owned `requests/` path, which must expose completion
  state `Complete`.
- Optional closed baselines, loaded only in this order: Profile, Objective, Control, NFR.
- The complete output structure in `.highway/library/templates/output/discovery-record.md`.
- The complete catalog structure in `.highway/library/templates/output/discovery-catalog.md`.
- The Discovery Conversation Contract and Discovery Analysis Contract: invocation, closed-input,
  deterministic-rule, failure, and ADR handoff boundaries defined by those contracts.

The conversation contract governs invocation and completion responses; the analysis contract
governs the closed inputs and deterministic rule order. The record always includes the exact
sections `Objective Relationships`, `Control Relationships`, and `NFR Relationships`.

## Outputs

- One user-owned record at `discoveries/DISCXXXXXX.md` with `status: proposed`.
- One user-owned catalog at `discoveries/discoveries.md`, bootstrapped when absent.
- Both outputs follow the complete structures in `.highway/library/templates/output/discovery-record.md`
  and `.highway/library/templates/output/discovery-catalog.md`.
- A completion response naming the Discovery identifier, Request identifier, record path, catalog
  path, and advisory relationship observations.
- No output when source resolution, privacy, validation, allocation, or writing fails.

## Workflow

1. Receive exactly one `REQ` followed by six digits. Reject missing, malformed, ambiguous, nonexistent, non-unique, or incomplete sources before allocation or writes.
2. Resolve exactly one Request and verify its completion marker is `Complete`. Treat its evidence as authoritative and read-only. Do not scan for an implicit newest or batch source.
3. Load only the closed inputs in order: Request, Profile when present, Objective when present, Control when present, and NFR when present. Missing optional baselines produce empty relationship sections. Normalize LF line endings and trailing whitespace while preserving display spelling.
4. Redact secrets and regulated personal data before copying or matching. Replace excluded material with a stable category marker and request business-relevant replacement evidence.
5. Copy Request evidence in fixed order. Generate Research Findings from Problem, Actors, Current Process, Desired Change, Success Measure, and Business Constraints in source order.
6. Generate Assumptions for absent, explicitly unknown, or dependency-bearing evidence. Generate Risks for constraints, dependencies, unresolved assumptions, privacy exclusions, and failure-sensitive transaction conditions. Generate Unknowns for absent evidence, unresolved terms, and explicit unknown markers. Deduplicate each collection by normalized text and sort by its stable normalized key.
7. Generate Candidate Approaches only from distinct strategies explicitly present in Desired Change. When none exist, emit `No candidate approaches identified from the supplied evidence.` Do not invent an approach.
8. Match each Objective, Control, and NFR independently. Explicit identifier references are High confidence; exact normalized title or statement matches are Medium; at least two normalized non-stopword tokens from Problem and Desired Change are Low. A single token is insufficient. Deduplicate by identifier and sort High, Medium, Low, then identifier. Every candidate is marked advisory and includes its first matching rule, source evidence domain, rationale, and confidence.
9. Derive the title from the explicit Request title, otherwise the normalized Problem title fallback, and serialize the complete record using the shared record template's exact heading order. Serialize the catalog with `Version`, authoritative `Next ID`, `## Discovery Index`, and one entry.
10. Build and validate record and catalog in memory before writing. Allocate only from catalog `Next ID`, advance it exactly once, retry an exclusive allocation conflict at most 3 times, then write the record and catalog as one ordered transaction.
11. On success, report `REQ -> DISC -> ADR` traceability and keep all relationships advisory. ADR creation is the later owning workflow and is not performed here.

## Verification

- Confirm the input is exactly one explicit `REQ` plus six digits and resolves to one completed
  Request.
- Confirm the record has the nine required sections in shared-template order and exactly one
  Request reference.
- Confirm the catalog has only `Version`, `Next ID`, and `## Discovery Index`, with one unique row.
- Confirm identical closed inputs and catalog state produce byte-identical output.
- Confirm secrets and regulated personal data are absent and stable exclusion evidence is present.
- Confirm Objective, Control, and NFR baselines and the Request remain byte-for-byte unchanged.
- Confirm allocation advances exactly once, write nothing on failure, and leave no partial record or catalog.
- Confirm the successful handoff is exactly one future Discovery input for `highway-adr`.

## Error Handling

- Missing, malformed, ambiguous, nonexistent, non-unique, or incomplete Request: abort and preserve existing bytes.
- Missing or malformed catalog, failed privacy redaction, failed validation, or write failure: abort and preserve existing bytes.
- Catalog allocation conflict: retry the exclusive operation no more than 3 times, then report allocation failure without a write.
- A missing optional Profile, Objective, Control, or NFR baseline yields an empty relationship section; a malformed present baseline aborts safely.
- Abort; never mutate governance baselines, create an ADR, or silently replace user-owned bytes.

## Example

`/highway-discovery REQ000001`
