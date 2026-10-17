---
name: highway-assessment
description: "Manages the repository-wide baseline."
usage: "Invoke as `/highway-assessment`."
compatibility: all
metadata:
  version: 1.1.0
---

# highway-assessment

## Purpose

Analyze accepted repository knowledge and surface meaningful observations for human review.

## Experience

Assessment follows the Highway Experience Standard. Present retained open findings before new
analysis, distinguish accepted knowledge from observed evidence and Working Ideas, and keep every
finding advisory until the requester reviews it. Use business language and ask the correction-oriented
Contribution Opportunity before a finding becomes eligible for acceptance.

## Response Support Text

Use only the support appropriate to the active interaction:

- Validation Question: `**What would you add, correct, or remove?**`
- Acceptance Reassurance: `If this is accurate, just say so.`
- Discovery Reassurance: `If you don't know, say "I don't know" and we'll work through it together.`

## Interpretation Confidence

Prefer a grounded observation that can be corrected over a missing interpretation that forces the
requester to create it from scratch. Present one useful relationship, gap, implication, tension,
opportunity, concern, or recommendation when accepted repository knowledge supports it. Do not
manufacture a finding when the evidence does not support one.

## Assessment Contribution Opportunity

When accepted knowledge supports a responsible first-pass observation, present it as a provisional
Working Idea under:

**Here is a proposed assessment finding:**

Name the category, domain, accepted evidence, and uncertainty. Close with exactly:
**What would you add, correct, or remove?** This is not an acceptance request and does not mutate
repository artifacts. A finding remains advisory until the requester explicitly dispositions it.

## When to use

- Use `/highway-assessment` for portfolio assessment when no domain is provided.
- Use `/highway-assessment architectures` to assess architecture coverage, consistency, dependencies, opportunities, reuse, and risks.
- Use `/highway-assessment implementations` to assess implementation relationships and patterns.
- Use `/highway-assessment portfolio` to correlate accepted repository knowledge across domains.

Assessment starts with the accepted catalogs and uses architecture traversal only when the
catalog evidence does not answer the active question. Portfolio analysis correlates all four
catalogs. Architecture analysis compares architecture representation with realized capabilities.
Implementation analysis uses the Implementation Catalog to locate implementations and the
Capability Catalog to assess provider, realization, reuse, distribution, and dependency patterns.

## When not to use

- Do not add assessment logic to Profile, Objectives, Controls, NFRs, Discovery, ADR, Architecture, Implementation, or Onboarding.
- Do not create architecture, implementation, dependency, capability, inventory, or assessment artifact families.
- Do not treat findings as organizational fact or accepted knowledge without requester disposition.
- Do not infer a finding from missing or unsupported evidence.
- Do not perform owner mutations requested through assessment; route them to the responsible workflow.

## Inputs

- Accepted Profile, Objectives, Controls, NFRs, ADRs, Reference Architectures, and Reference Implementations.
- Accepted catalog indexes, loaded before source-record traversal:
  - `adrs/adrs.md`
  - `architectures/architectures.md`
  - `implementations/implementations.md`
  - `implementations/capabilities.md`
- Catalog entries are the starting point for navigation. Source records are opened selectively for detailed evidence only when a catalog entry is insufficient.
- Existing `.highway/library/knowledge/assessment-findings.md`.
- The selected assessment domain, defaulting to `portfolio`.
- Requester corrections, dispositions, and requests for more information.

## Ownership and evidence precedence

Assessment owns observing, correlating, analyzing, finding identity, finding review, and findings
persistence. Existing artifact owners retain authority over their artifacts and mutations. Use
accepted repository knowledge first, then permitted repository evidence. Keep extracted information,
interpretations, recommendations, and findings proposed until the applicable requester review.

Catalog indexes are authoritative for navigation and direct relationships. Associated ADR,
Architecture, and Implementation records remain authoritative for detailed rationale, constraints,
dependencies, and other retained record content. A conflict is reported as inconsistent evidence;
assessment does not silently repair either source. Assessment is read-only for owner artifacts and
routes capability, provider, implementation, architecture, and catalog mutations to the
responsible workflow.

Use Capability Catalog `Realized By` values directly for provider concentration, shared
realization, implementation reuse, and technology adoption observations. Compare those values with
Reference Architecture and Reference Implementation catalog entries for coverage, distribution,
and landscape analysis. Do not create a technology inventory or require an architecture traversal
when accepted catalog evidence already supports the observation. Missing, malformed, unreadable,
duplicated, unresolved, or conflicting evidence remains unknown unless it supports an existing
finding category.

## Finding Categories

Supported categories are `Coverage`, `Consistency`, `Dependency`, `Opportunity`, `Reuse`, and `Risk`.
A finding must identify one category and one domain and must be grounded in accepted repository
knowledge.

## Finding Identity and Persistence

Persist findings in `.highway/library/knowledge/assessment-findings.md` using the shared library
contract. Each finding has a sequential zero-padded `F###` display ID and a separate deterministic
`Fingerprint`. Normalize line endings to LF, trim, lowercase, and collapse consecutive whitespace
before composing the fingerprint from Category, Domain, and Finding Text. Reuse the existing row and
ID for an equivalent fingerprint; allocate the next unused ID only for a new fingerprint.

The record has a non-negative `revision`. Validate the complete in-memory record before writing. A
mutation based on a stale revision is rejected, writes nothing, and requires reload before retry.
Successful mutation increments revision exactly once. Invalid rows, duplicate IDs, duplicate
fingerprints, unsupported values, and unsupported transitions reject the complete mutation.

Normalize catalog rows by stable identifier and canonical field values before correlation. Equivalent
catalog inputs in a different row order must produce the same finding identities and equivalent
observations. Do not use filesystem order, timestamps, random values, or inferred technology
inventories as assessment evidence.

## Finding Review

1. Load and validate the findings record before new analysis.
2. Present every `Open` finding first as `* **F###:** Single-sentence finding summary.`
3. Analyze only the selected domain and accepted repository context.
4. Present grounded observations under **Here is a proposed assessment finding:**.
5. Ask **What would you add, correct, or remove?** before acceptance.
6. Support `Accept`, `Dismiss`, `Resolve`, `Supersede`, and `Request More Information`.
7. Keep `Request More Information` status-neutral.
8. Persist only validated changes and genuinely new findings.

## Finding Statuses

New findings start `Open`. Supported transitions are:

```text
Open -> Accepted | Dismissed | Resolved | Superseded
```

Resolved, dismissed, and superseded findings remain retained for context and duplicate detection.
Unsupported transitions are rejected.

## Outputs

- A retained `.highway/library/knowledge/assessment-findings.md` record rendered from `.highway/library/templates/output/assessment-findings.md`, containing validated advisory findings.
- A user-facing review of existing Open findings before new analysis.
- New or updated finding rows only after validation and a non-stale revision check.
- No architecture, implementation, dependency, capability, inventory, or alternate artifact family.

## Advisory Boundary and Routing

Accepted findings remain advisory observations and do not automatically create architecture,
implementation, dependencies, capabilities, or controls. Requests for those mutations route to the
responsible owner. Assessment logic remains centralized in this skill.

## Error Handling

Malformed findings, unsupported values, duplicate IDs or fingerprints, unsupported transitions, and
stale revisions reject the complete mutation without writing. Missing or unsupported evidence remains
unknown. Requests for owner mutations are routed to the responsible workflow.

## Verification

- Confirm all three domains and the portfolio default.
- Confirm `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, and `implementations/capabilities.md` are available before source-record traversal.
- Confirm catalog indexes are the starting point for navigation and source records are opened selectively for detailed evidence.
- Confirm direct Capability Catalog `Realized By` provider analysis, Implementation Catalog lookup, capability-to-architecture coverage, and implementation reuse/distribution guidance.
- Confirm open findings are presented before new analysis.
- Confirm categories, statuses, display IDs, fingerprints, and revision rules.
- Confirm stale updates reject without overwriting newer findings.
- Confirm equivalent fingerprints reuse existing rows and IDs.
- Confirm the Contribution Opportunity and advisory boundary.
- Confirm no owner artifact or new identifier family is created.
- Confirm assessment is read-only for owner catalogs and records and routes mutation requests to their responsible workflows.
- Confirm identical accepted inputs produce deterministic findings without timestamps or random values.

## Example

`/highway-assessment portfolio`

Next Action: Review the open assessment findings below, then tell me what to add, correct, or remove.

* **F001:** Commerce and accounting capabilities appear related, but no accepted architecture describes their information exchange.

**What would you add, correct, or remove?**
