---
name: highway-onboarding
description: "Manages a repository-wide baseline."
usage: "Invoke as `/highway-onboarding`."
compatibility: all
metadata:
  version: 1.0.0
---

# highway-onboarding

## Purpose

Bring existing organizational technology into Highway through a durable knowledge model that discovers business capabilities, maps existing platforms or processes, validates a proposed pre-existing architecture decision, and delegates owner mutations without creating an inventory or substitute artifact family.

## Experience

Onboarding follows the Highway Experience Standard. Present the Next Action first, use business language, distinguish accepted repository knowledge from observed evidence and Working Ideas, and ask the correction-oriented Contribution Opportunity before any proposal becomes eligible for acceptance. Reuse accepted Profile, Objective, Control, NFR, ADR, Architecture, and Implementation knowledge before asking for new evidence.

The required validation question is: **What would you add, correct, or remove?** A requester may accept, correct, remove, qualify, ask for more information, or mark a finding unknown. Questions and examples do not count as acceptance.

## Response Support Text

Use only the support appropriate to the active interaction:

- Validation Question: `**What would you add, correct, or remove?**`
- Acceptance Reassurance: `If this is accurate, just say so.`
- Discovery Reassurance: `If you don't know, say "I don't know" and we'll work through it together.`

Use the Acceptance Reassurance when the requester is reviewing a proposed capability, mapping, or
ADR. Use the Discovery Reassurance when the requester must provide unresolved organizational
information and no grounded starting point is available.

## Interpretation Confidence

Prefer a grounded interpretation of an organizational capability or provider relationship that can
be corrected over a missing interpretation that forces the requester to create it from scratch. When
accepted repository knowledge or supplied evidence supports a useful distinction, implication,
connection, limitation, or Working Idea, present it before asking a question that merely seeks
permission to express it. Keep the interpretation provisional until the requester contributes and
accepts the resulting proposal.

## Onboarding Contribution Opportunity

When accepted context or supplied evidence supports a responsible first-pass capability
interpretation, present it as a provisional Working Idea under:

**Here is a proposed starting point for your onboarding:**

Include the business capability, supporting evidence, relevant provider relationship, and any
uncertainty. Close with exactly: **What would you add, correct, or remove?** This opportunity is not
a candidate for acceptance and does not create an ADR, allocate an identifier, or persist anything.
If no grounded interpretation exists, ask one consequential missing-evidence question and do not
manufacture a starting point.

## When to use

- The requester starts `/highway-onboarding` without a command argument or environment description.
- Accepted Profile, Objective, Control, NFR, ADR, Architecture, or Implementation knowledge can ground a capability interpretation.
- The requester can provide conversational evidence, manually provided organization websites, or imported materials.
- Existing platforms, services, or custom processes need to be understood as evidence for accepted architecture knowledge.

## When not to use

- Do not create or maintain a technology, platform, provider, application, or landscape inventory.
- Do not create a fake Request, fake Discovery, synthetic DISC record, alternate ADR artifact, or parallel artifact family.
- Do not use onboarding for unrelated Request, Discovery, Control, NFR, relationship, Architecture, or Implementation work; route that work to its owning workflow.
- Do not use live enterprise discovery integrations in this release.
- Do not treat an unsupported historical claim, unknown provider, or unaccepted rationale as accepted organizational knowledge.

## Inputs

- Accepted repository context: Profile, Objective, Control, NFR, ADR, Architecture, and Implementation artifacts.
- Conversation contributions from the organization owner.
- Manually provided organization websites and imported organizational materials, when available.
- Existing owner contracts, the complete output structures in `.highway/library/templates/output/adr-record.md` and `.highway/library/templates/output/adr-catalog.md`, and the owner skills for `highway-adr`, `highway-architecture`, and `highway-implementation`.

## Ownership and evidence precedence

Onboarding owns capability discovery, platform mapping evidence, proposal review, ADR acceptance, ADR identifier allocation, ADR structure, provenance, ADR/catalog persistence, and downstream sequencing. `highway-adr` owns the separate Discovery-based ADR workflow. Architecture owns Reference Architecture generation and persistence. Implementation owns Reference Implementation generation and persistence.

Use accepted repository context first, then manually provided materials and conversation. Mark each item as accepted repository knowledge, observed evidence, proposed finding, user validation, or accepted onboarding finding. Do not promote a proposed finding across a validation boundary without the requester contribution that supports it.

## Capability Discovery

1. Present one concise sentence summarizing accepted capability coverage before requesting new environment evidence.
2. Distinguish accepted coverage from missing or provisional interpretations. A provisional interpretation must invite correction.
3. Propose a missing business capability only when accepted context provides grounded support, and include a business-language explanation.
4. Present a Contribution Opportunity before acceptance and ask: **What would you add, correct, or remove?**
5. Retain additions, corrections, removals, and uncertainty in the active onboarding scope. Unknown remains unknown and is not accepted architecture knowledge.
6. Maintain a transient queue of requester-validated capabilities. Queue membership is not an ADR or architecture acceptance.

## Platform Mapping

Process one accepted capability at a time. Present its business purpose before asking which platform or process currently provides it. Preserve each answer as accepted onboarding evidence, including a custom process or explicit unknown.

Support many-to-many mappings: one capability may map to multiple platforms or processes, and one platform or process may provide multiple capabilities. Preserve an optional requester-identified primary mapping. Group accepted mappings by provider for review only, without creating a separate platform, provider, application, or technology artifact.

## Proposed Pre-existing ADR

Process one provider group at a time. Present its accepted business capabilities, grounded likely alternatives, rationale, limitations, and historical uncertainties as a Working Idea. Ground alternatives and rationale in accepted Profile, Objectives, Controls, NFRs, onboarding evidence, and permitted repository context. Unsupported historical claims remain unknown or provisional.

Present the Contribution Opportunity and ask: **What would you add, correct, or remove?** Re-evaluate after every substantive contribution. Only a stabilized proposal explicitly accepted by the requester may become an ADR record.

## ADR Record Creation

After the requester accepts a stabilized proposal, onboarding creates the ADR record directly using the shared `.highway/library/templates/output/adr-record.md` and `.highway/library/templates/output/adr-catalog.md` structures. Onboarding owns ADR identifier allocation, record validation, direct catalog entry creation, and atomic persistence for this path. It does not require or fabricate Discovery or option identifiers and does not create a synthetic Discovery record.
This direct onboarding path is owned by `highway-onboarding`.

The minimum onboarding provenance is:

```yaml
request: onboarding
discovery: highway
```

Use exactly one scalar request provenance value, `request: onboarding`, and one scalar discovery-source value, `discovery: highway`. Requests for the separate Discovery-based ADR workflow route to `highway-adr` and retain its existing contract.

## Outputs

- A normal accepted ADR created and persisted directly by onboarding with the shared ADR output structures.
- A Reference Architecture owned and persisted by `highway-architecture` after successful ADR persistence.
- A Reference Implementation owned and persisted by `highway-implementation` after successful Architecture persistence.
- A user-facing final summary of `Platform -> ADR -> Reference Architecture -> Reference Implementation` only after all three owner mutations succeed.
- No onboarding inventory, fake Request, fake Discovery, synthetic DISC, alternate ADR, or parallel artifact family.

## Workflow

1. Load accepted repository context and present one concise capability coverage sentence.
2. Develop grounded missing-capability Working Ideas and invite contribution.
3. Retain only requester-validated capabilities in the transient queue.
4. Map each accepted capability to one or more platforms or processes, preserving many-to-many relationships, optional primary mappings, and unknown values.
5. Group mappings by provider for review without creating an inventory.
6. Develop and re-evaluate one proposed pre-existing ADR per provider group until the requester accepts or rejects it.
7. Render and validate the normal ADR record from the shared templates, allocate the next ADR identifier from the ADR catalog, and persist the ADR and catalog atomically.
8. Invoke `highway-architecture` for that ADR and wait for successful Architecture persistence and a durable Architecture identifier.
9. Invoke `highway-implementation` for that Architecture and wait for successful Implementation persistence.
10. If Architecture or Implementation fails, retry that failed owner no more than three times. Then stop, preserve earlier successful mutations, report the failed owner boundary without claiming completion, and offer manual resume from that owner.
11. On manual resume, start at the stored failed owner boundary without repeating successful owner mutations.

## Verification

- Confirm accepted capability coverage is presented before new environment questions.
- Confirm every proposed capability and rationale receives the exact correction-oriented Contribution Opportunity before acceptance.
- Confirm many-to-many mappings, optional primary mappings, and explicit unknowns are preserved without an inventory artifact.
- Confirm unsupported historical claims remain provisional or unknown.
- Confirm onboarding writes a normal ADR from the shared record and catalog templates with exactly one scalar `request: onboarding` value and one scalar `discovery: highway` value, with no synthetic Discovery.
- Confirm requests for the separate Discovery-based ADR workflow route to `highway-adr` unchanged.
- Confirm ADR success precedes Architecture invocation and Architecture success precedes Implementation invocation.
- Confirm a failed downstream owner stops the next owner, retries at most three times, preserves earlier durable results, and resumes from the failed owner boundary.
- Confirm final output exposes only the Platform to ADR to Reference Architecture to Reference Implementation relationship and does not claim completion after failure.
- Confirm identical evidence produces deterministic proposal ordering and excludes timestamps, dates, environment identifiers, random values, and session identifiers.

## Error Handling

Unavailable or contradictory websites and imported materials are reported as limitations; onboarding continues only from supported evidence. A requester correction or rejection removes the affected material from accepted onboarding scope. Unknown platform or rationale values do not authorize ADR creation.

Any ADR, Architecture, or Implementation failure stops downstream orchestration. Architecture and Implementation failures retry no more than three times. After exhaustion, preserve successful earlier owner mutations and offer manual resume from the failed owner boundary. No failed run is reported as complete.

## Example

`/highway-onboarding`

Next Action: Review the accepted capability coverage below, then tell me what to add, correct, or remove.

Accepted coverage: Order fulfillment and customer support are represented by accepted repository knowledge; the current provider mapping remains to be confirmed.

What would you add, correct, or remove?
