# Feature 181 Data Model: Highway New Proposal-First Request Development

## Request Evidence Domain

The seven existing domains remain authoritative for Request completeness:

| Domain | Meaning | Creation requirement |
|---|---|---|
| Problem | User-owned business problem or need | Existing Evidence Completeness Rule |
| Actors | People, roles, or groups involved | Existing Evidence Completeness Rule |
| Current Process | User-owned description of how work occurs now | Existing Evidence Completeness Rule |
| Desired Change | User-owned outcome or change sought | Existing Evidence Completeness Rule |
| Success Measure | User-owned evidence of how improvement is recognized | Existing Evidence Completeness Rule |
| Business Constraints | User-owned business limits or explicit `No business constraints` | Existing Evidence Completeness Rule |
| Solution Constraints | Eight structured fields limiting the future candidate space | All fields satisfy existing shape/state rules |

## Solution Constraints

The existing structured fields remain unchanged:

- `allowed_solution_classes`: one or more non-empty values or `unknown`; never an empty list.
- `existing_platforms_required`: populated list, explicit empty list, or `unknown`.
- `existing_platforms_preferred`: populated list, explicit empty list, or `unknown`.
- `known_systems`: populated list, explicit empty list, or `unknown`.
- `hosting_restrictions`: non-empty value or `unknown`.
- `vendor_restrictions`: non-empty value or `unknown`.
- `procurement_constraints`: non-empty value or `unknown`.
- `regulatory_restrictions`: non-empty value or `unknown`.

These fields constrain future Discovery candidates. They do not select a solution, architecture,
implementation pattern, technology, or ADR option.

## Request Proposal

A transient Working Idea assembled from available Requester Evidence and grounded contextual
reasoning.

**Properties**:

- May contain the eight eventual review fields: Title, Problem, Actors, Current Process, Desired
  Change, Success Measures, Business Constraints, and Solution Constraints.
- Clearly distinguishes user-owned evidence from Highway-originated interpretation or suggestion.
- Reuses accepted evidence and labels unavailable evidence `Unknown`.
- Cannot be accepted or persisted while it remains a Working Idea.

## Request Discovery Contribution Opportunity

A transient proposal-first interaction state presented when accepted evidence supports a responsible
first-pass interpretation.

**Properties**:

- Opens with `Here is a proposed starting point for your Request:`.
- Offers grounded provisional understanding for omission detection, correction, refinement, and
  validation.
- Ends with `What would you add, correct, or remove?`.
- Does not request acceptance, allocate an identifier, persist a Request, perform Discovery, or
  create ADR content.
- Remains active while substantive additions, corrections, removals, combinations, narrowings, or
  qualifications continue.

## Converged Request Proposal

A complete candidate whose relevant Request understanding is stable enough for user acceptance.

**Properties**:

- Contains all eight review fields.
- Appears beneath `Here's what I've captured as your request:`.
- Ends with the Validation Question and applicable reassurance.
- Requires at least one substantive requester contribution before convergence, in accordance with
  the Experience Standard.
- Is still not a persisted Request until the requester accepts it and completeness validation passes.

## Request Acceptance

The user-owned boundary after a Converged Request Proposal.

**Transition conditions**:

1. All seven evidence domains satisfy existing completeness rules.
2. The Converged Request Proposal has been shown for review.
3. The requester gives an unambiguous acceptance.
4. Existing privacy, identifier, record, catalog, and transaction validation succeeds.

**Result**: `highway-new` may create the Request record and catalog. Acceptance alone does not
create the Request.

## Lifecycle

```text
Requester Evidence
  -> Request Discovery Contribution Opportunity
  -> Request Proposal Refinement
  -> Converged Request Proposal
  -> User Acceptance
  -> Evidence Completeness Validation
  -> Request Creation
```

### Non-creation states

Incomplete evidence, unknown required evidence, pause, cancel, stop response, declined, aborted,
blocked, privacy rejection, allocation failure, validation failure, and write failure preserve
existing Request/catalog bytes and create no Request artifact.

## Ownership Relationships

- `highway-new` owns Request Evidence Domains, Solution Constraints, completeness, acceptance,
  identifiers, Request record/catalog creation, and creation outcomes.
- Profile, Objectives, Controls, and NFRs may provide contextual evidence through their existing
  ownership rules; they do not transfer ownership into Request automatically.
- `highway-discovery` owns candidate generation, comparison, scoring, recommendation, and option
  analysis after Request creation.
- `highway-adr` owns explicit architecture/solution selection, rationale, consequences, and
  commitment.
