---
name: highway-discovery
description: "Manages a repository-wide Discovery baseline."
usage: "Invoke as `/highway-discovery` and state the Request."
compatibility: all
metadata:
  version: 2.0.0
---

# highway-discovery

## Purpose

Creates one deterministic architectural Discovery analysis between a completed Request and later
ADR work, producing bounded Candidate Solution Options, exact Reference Architecture matches, a
complete Comparison Matrix, and one advisory Recommendation.

## When to use

- A requester has supplied exactly one completed Request identifier in `REQ` plus six digits.
- The repository needs deterministic findings, assumptions, risks, unknowns, Candidate Solution
  Options, a Comparison Matrix, a Recommendation, and advisory governance context before ADR work.
- A later `highway-adr` workflow needs one stable Discovery input.

## When not to use

- Do not select Requests by recency, filename order, or batch listing.
- Do not analyze an incomplete Request or invent missing business evidence.
- A successful analysis requires at least two and no more than five viable Candidate Solution Options.
- Do not approve, create, update, or remove Objectives, Controls, NFRs, Requests, ADRs, or
  Reference Architectures, Reference Implementations, architecture artifacts, or decisions.

## Inputs

- Exactly one explicit `REQ` identifier followed by six digits.
- The uniquely resolved Request at the user-owned `requests/` path, which must expose completion
  state `Complete`.
- Request Solution Constraints from the completed Request, loaded in this exact order:
  `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`,
  `known_systems`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`,
  `regulatory_restrictions`.
- Optional closed baselines, loaded only in this order: Profile, Objective, Control, NFR.
- Optional Reference Architecture baseline loaded after NFR; Reference Implementation data is
  consulted only for the advisory tie-break.
- The complete output structure in `.highway/library/templates/output/discovery-record.md`.
- The complete catalog structure in `.highway/library/templates/output/discovery-catalog.md`.
- The Discovery Conversation Contract and Discovery Analysis Contract: invocation, closed-input,
  deterministic-rule, failure, and ADR handoff boundaries defined by those contracts.

The conversation contract governs invocation and completion responses; the analysis contract
governs the closed inputs and deterministic rule order. The record always includes the exact
sections `Objective Relationships`, `Control Relationships`, and `NFR Relationships`.

## Outputs

- One user-owned Discovery record at `discoveries/DISCXXXXXX.md`.
- One user-owned Discovery catalog at `discoveries/discoveries.md`.
- The record follows the complete structure in `.highway/library/templates/output/discovery-record.md`.
- The catalog follows `.highway/library/templates/output/discovery-catalog.md`.
- The completion response names the Discovery identifier, Request identifier, Record path, and
  Catalog path.
- Source resolution, validation, privacy review, scoring, allocation, or writing failure produces
  no output and preserves existing bytes.

## ADR Handoff

The handoff is a read-only projection for the later `highway-adr` workflow.
- Include data required for one future ADR: the Discovery and Request identifiers, every Candidate
  Solution Option and `OPT` identifier, the Comparison Matrix, Recommendation, Recommendation
  rationale, and every Reference Architecture Match.
- Do NOT include:
  - selected option
  - rejected option identifiers
  - recommendation acceptance
  - recommendation rejection rationale
  - decision authority
  - consequences
- These values are owned exclusively by ADR. Discovery records no decision and grants no
  implementation authorization.

Persist the handoff as `discoveries/DISCXXXXXX.md` and maintain the catalog at `discoveries/discoveries.md`.

The handoff is eligible for exactly one future ADR analysis input and does not repeat analysis. ADR
may select any option and owns all decision persistence.

## Reference Implementation Evaluation

Reference Implementations are advisory artifacts identified by the authoritative catalog and
associated Reference Architecture. Evaluation is read-only and produces traceability evidence,
matching identifiers, counts, and blocking reasons only.

## Reference Implementation Matching

A Reference Implementation matches a Candidate Solution Option only when either condition is true:

1. The Reference Implementation explicitly references a matching Reference Architecture.
2. The Reference Implementation explicitly references the identifier of a Reference Architecture
  matched by that option.

No match exists otherwise. Semantic similarity, inference, approximation, or similarity scoring
MUST NOT create a match.

## Reference Implementation Counting

Reference Implementation Count equals the number of unique matching Reference Implementations for
an option. Count each stable Reference Implementation identifier once, even when duplicate
references or multiple paths identify the same implementation. In other words, duplicate references count once.

Missing or unreadable Reference Implementations contribute zero. Malformed Reference Implementations,
including unparseable artifacts, missing stable identity, or missing required
fields, are excluded from counting and tie-breaking; record the blocking reason and continue.
An unresolved Reference Architecture reference in an otherwise valid implementation is a valid
non-match.

An absent or unreadable catalog produces zero counts. An internally inconsistent catalog, including
duplicate stable identifiers, excludes affected implementations, records the reason, and continues
with zero affected counts. When an option matches multiple Reference Architectures, use the highest
Reference Implementation Count among those matches.

## Recommendation Tie-Break Evaluation

Reference Implementation data is evaluated only according to the Reference Implementation
Evaluation rules and is used exclusively for deterministic tie-breaking.

Apply tie-breaking only after score calculation and Reference Architecture evaluation, when
multiple options have identical Recommendation scores. Evaluate tied options in this exact order:

1. Reference Architecture Match
2. Reference Implementation Count
3. Lowest Discovery-scoped `OPT` identifier

Reference Architecture Match evaluates whether an option has one or more matched Reference
Architectures. Options with one or more matches outrank options with no matches. For each option,
use the highest implementation count across its matched architectures. Stop immediately when one
criterion selects a single option; later criteria MUST NOT be evaluated.

Reference Implementation evidence MUST NOT change Recommendation scores, confidence, Recommendation rationale, or ranking except through this defined deterministic tie-break.

## Reference Implementation Determinism

For identical Requests, Discovery inputs, Profile, Objective, Control, NFR, Reference Architecture,
and Reference Implementation baselines, matches, counts, tie-break outcomes, and Recommendation
selection remain identical. Evaluation MUST NOT use timestamps, creation dates, modification dates,
recency, environment state, randomness, semantic similarity, inference, or similarity scoring.

## Reference Implementation Scope Clarification

Included are advisory matching, deterministic counting, deterministic tie-breaking, implementation
reuse visibility, architecture adoption visibility, and traceability. Excluded are recommendation
creation, scoring, confidence, rationale, ranking except tie-breaking, implementation approval or
authorization, architecture approval, governance approval, and ADR ownership.

## Reference Implementation Traceability

A Reference Implementation match indicates only that a related implementation artifact exists. A
match does not indicate recommendation, endorsement, approval, architectural correctness,
implementation suitability, or implementation authorization. ADR remains responsible for selecting
a Candidate Solution Option and recording all architecture decisions.

Reference Implementation evaluation MUST NOT mutate Reference Implementations, Reference
Architectures, source baselines, Discovery inputs, ADR records, or governance baselines.

## Workflow

1. Receive exactly one `REQ` followed by six digits. Reject missing, malformed, ambiguous, nonexistent, non-unique, or incomplete sources before allocation or writes; abort and preserve existing bytes.
2. Resolve exactly one Request and verify its completion marker is `Complete`. Treat its evidence as authoritative and read-only. Do not scan for an implicit newest or batch source.
3. Load closed inputs in order: Request, Request Solution Constraints, Profile when present, Objective when present, Control when present, NFR when present, and Reference Architecture when present. Read the eight Request Solution Constraints fields in their declared order, preserve `unknown` separately from empty arrays, and treat them as read-only evidence. Reference Implementation data is evaluated only according to the Reference Implementation Evaluation rules and is used exclusively for deterministic tie-breaking. Reference Implementation matching and counting occur only after score calculation and Reference Architecture evaluation. Missing optional Reference Architecture data produces an empty match set; missing or unreadable Reference Implementation data produces zero counts.
4. Normalize LF line endings and comparison text, then redact secrets and regulated personal data before copying, matching, scoring, or serialization. Replace excluded material with a stable category marker.
5. Copy Request evidence in fixed order. Preserve Research Findings, Assumptions, Risks, Unknowns, and Objective, Control, and NFR relationship extraction and advisory behavior.
6. Generate distinct Candidate Solution Options from explicit Desired Change strategies first, then strategies implied by Objectives, Controls, NFRs, Research Findings, and available Reference Architectures. When `allowed_solution_classes` is known, generate only candidates in those classes; when it is `unknown`, preserve unconstrained generation. Normalize each candidate, evaluate Solution Constraints, filter invalid candidates, and only then score survivors. Normalize and deduplicate before identifier allocation, aggregate supporting evidence, reject incomplete options, and record any more-than-five truncation boundary.
7. Exclude candidates that violate `existing_platforms_required`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, or `regulatory_restrictions` before scoring, comparison, or recommendation. Record every excluded candidate in the Candidate Elimination Log with candidate identifier and title, status `Excluded`, reason category, constraint identifier or value, and deterministic reason. Order entries by candidate identifier, constraint category, then constraint identifier or value. Preferred platforms and known systems never eliminate candidates. If filtering leaves no viable candidates, abort without writes.
8. Sort retained options by Desired Change alignment, Objective alignment, constraint alignment, and alphabetical title, in that order. Retain the deterministic first two through five options and assign identifiers such as `OPT000001` only after sorting. Fewer than two retained options aborts without writes.
9. Evaluate every Reference Architecture candidate independently using exact matching precedence: explicit identifier, exact normalized title, capability identifier, Objective identifier, Control identifier, then NFR identifier. Report every matching candidate with its identifier, confidence, highest-precedence match reason, matched option identifiers, and Reference Implementation count. Semantic, similarity, and inference matching are excluded.
10. Calculate retained-candidate alignment only after filtering: Required Platform Match is 100 for traceability only; Preferred Platform Match is 100 when a preferred platform is used and 50 otherwise; Known-System Alignment is 100 when all declared known systems are reused, 75 when one or more but not all are reused, and 50 when none are reused. Include Constraint Alignment, Satisfied Constraints, Unsatisfied Constraints, and `Constraint Compliance` (`Fully Compliant`) for every retained candidate.
11. Calculate Objective, NFR, Control, Constraint Alignment, and Risk Reduction scores with weights Objective 25, NFR 25, Control 20, Constraint Alignment 20, and Risk Reduction 10. Use floor rounding, zero for zero denominators, and totals from 0 through 100. Derive High confidence for 90-100, Medium for 70-89, and Low for 0-69. Informational Complexity, Governance Impact, and Operational Overhead classifications never affect scoring, confidence, ranking, selection, or option ordering.
12. Render the complete Candidate Solution Comparison Matrix before the Recommendation. Include every retained option in option order, Allowed Solution Class, Constraint Alignment Score, Required Platform Match, Preferred Platform Match, Constraint Compliance, every score component, total, Reference Architecture matches, exactly one `Recommended` status, and all mandatory informational categories. For equal totals, apply the Recommendation Tie-Break Evaluation section.
13. Build and validate record and catalog in memory before writing. Validate identifiers, option bounds, score identity, advisory-only fields, source-byte preservation, and complete template order. Allocate only from catalog `Next ID`, advance it exactly once, retry an exclusive allocation conflict at most 3 times, then write the record and catalog as one ordered transaction.
14. On success, report `REQ -> DISC -> ADR` traceability and expose the complete Discovery-to-ADR handoff. ADR creation is the later owning workflow and remains responsible for selected or rejected options, acceptance, rationale, consequences, and decisions.

## Verification

- Confirm the input is exactly one explicit `REQ` plus six digits and resolves to one completed
  Request.
- Confirm the record has the required sections in shared-template order: Request Reference, Research
  Findings, Assumptions, Risks, Unknowns, Request Solution Constraints, Candidate Elimination Log,
  Candidate Solution Options, Candidate Solution Comparison Matrix, Recommendation, Objective
  Relationships, Control Relationships, NFR Relationships, and Reference Architecture Matches.
- Confirm the record contains two through five unique `OPT` identifiers, complete option fields,
  a complete matrix in option order, exactly one `Recommended` status, and one Recommendation
  whose score values equal the matrix values.
- Confirm every Reference Architecture match is exact, independently evaluated, reported with its
  highest-precedence reason, and advisory.
- Confirm the Recommendation is advisory and contains no selected option, rejected option,
  approval, architecture decision, implementation authorization, or governance mutation.
- Confirm all eight Request Solution Constraints render in canonical order, mandatory violations
  are eliminated before scoring, preferred platforms and known systems are scoring-only, retained
  Required Platform Match is 100 for traceability only, known-system alignment is 100/75/50, and
  matrix compliance is `Fully Compliant`.
- Confirm the catalog has only `Version`, `Next ID`, and `## Discovery Index`, with one unique row.
- Confirm every candidate elimination is recorded before scoring and the elimination log is ordered
  deterministically by candidate and constraint identity.
- Confirm identical closed inputs and catalog state produce byte-identical output.
- Confirm secrets and regulated personal data are absent and stable exclusion evidence is present.
- Confirm Objective, Control, and NFR baselines and the Request remain byte-for-byte unchanged.
- Confirm allocation advances exactly once, write nothing on failure, and leave no partial record or catalog.
- Confirm the successful handoff is exactly one future Discovery input for `highway-adr`.
- Confirm Reference Implementation matching uses only the two explicit matching conditions.
- Confirm duplicate matches are counted once per stable identifier.
- Confirm malformed Reference Implementations are excluded and their blocking reasons are recorded.
- Confirm missing, unreadable, absent, or inconsistent implementation data produces zero affected counts.
- Confirm Recommendation score and confidence, plus rationale, are unchanged by Reference Implementation evidence.
- Confirm tie-break order is Reference Architecture Match, Reference Implementation Count, then lowest `OPT` identifier.
- Confirm evaluation stops immediately after a criterion selects one winner.
- Confirm repeated executions with identical inputs are deterministic.
- Confirm ADR ownership is unchanged and no implementation is authorized.

## Error Handling

- A malformed Reference Implementation is excluded from evaluation, its blocking reason is recorded, and Discovery must fall back to the remaining evidence.
- An unreadable Reference Implementation contributes zero through a fallback to the remaining evidence.
- Multiple matching paths for one Reference Implementation fall back to counting the stable identifier once.
- An absent or unreadable Reference Implementation catalog must fall back to zero counts.
- An internally inconsistent catalog excludes affected implementations, records the reason, and must fall back to zero affected counts.
- A Reference Implementation matching failure must fall back to zero matching implementations.
- Any source, validation, privacy, scoring, allocation, or writing failure aborts with no output, preserves existing bytes, and does not create an ADR, record a decision, authorize implementation, or mutate governance.
- Missing, malformed, ambiguous, nonexistent, non-unique, or incomplete Request: abort and preserve existing bytes.
- Missing or malformed catalog, fewer than two viable options, failed score calculation, failed privacy redaction, failed validation, or write failure: abort and preserve existing bytes.
- More than five viable options: fall back by retaining the deterministic first five and record the truncation boundary.
- Missing or unreadable optional Reference Architecture data: fall back to an empty match set without failing.
- A malformed or internally inconsistent Reference Architecture: fall back by excluding it, record its blocking reason in findings, and do not mutate the baseline.
- A Reference Architecture match operation failure: fall back to an empty match set.
- Catalog allocation conflict: retry the exclusive operation no more than 3 times, then report allocation failure without a write.
- A missing optional Profile, Objective, Control, or NFR baseline: fall back to an empty relationship section.
- A malformed present Profile, Objective, Control, or NFR baseline: abort safely.
- Malformed or contradictory Solution Constraints, an empty invalid `allowed_solution_classes` value, or zero viable candidates: abort safely and preserve existing bytes without a record, catalog update, partial output, or source mutation.
- Abort; never mutate governance baselines, create an ADR, record a decision, or silently replace user-owned bytes.

## Example

`/highway-discovery REQ000001`

## MVP Option Probes

For each candidate solution option, capture these concise probes before comparison:

- **Summary:** What the option is and how it addresses the objective.
- **Benefits:** Expected value and strengths.
- **Risks:** Material drawbacks, failure modes, or trade-offs.
- **Assumptions:** Conditions that must hold for the option to work.
- **Dependencies:** People, systems, decisions, or external constraints required.

Use stable option identifiers (`OPTXXXXXX`) and carry these probes into the Candidate Solution Comparison Matrix and Recommendation.
