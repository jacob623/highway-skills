# Highway New Proposal-First Interaction Contract

## Scope

This contract defines the user-visible and ownership behavior for proposal-first `highway-new`
intake. Existing Request record, catalog, privacy, allocation, and Solution Constraint contracts
remain authoritative and are referenced rather than duplicated here.

## Interaction Forms

### Request Discovery Contribution Opportunity

Trigger when accepted evidence supports a responsible first-pass interpretation of at least one
consequential Request aspect.

```text
Here is a proposed starting point for your Request:

<grounded Request Proposal Working Idea>

**What would you add, correct, or remove?**
```

The opportunity is provisional. It must not request acceptance, create or persist a Request,
allocate an identifier, perform Discovery analysis, create ADR content, or propose an architecture
decision.

### Converged Request Proposal

After substantive requester contribution, owner completeness, and conversational convergence:

```text
**Here's what I've captured as your request:**

Title
Problem
Actors
Current Process
Desired Change
Success Measures
Business Constraints
Solution Constraints

**What would you add, correct, or remove?**

If this is accurate, just say so.
```

The Validation Question is the only emphasized element in the review block. Acceptance is requested
only after this proposal is complete and the owner’s completeness rules pass.

## Response Support Text

Use only the support appropriate to the active interaction:

- Validation Question: `**What would you add, correct, or remove?**`
- Acceptance Reassurance: `If this is accurate, just say so.`
- Discovery Reassurance: `If you don't know, say "I don't know" and we'll work through it together.`
- Additional Suggestions Reassurance: `If you'd like additional suggestions, just let me know.`
- Request Proposal Reassurance: `The goal is to make sure Highway understands the request correctly before creating the Request.`

The combined confirmation/uncertainty reassurance remains available when both outcomes are natural.

## Refinement Rules

1. Reuse accepted evidence already represented in the active proposal.
2. Re-evaluate after every substantive addition, correction, removal, combination, narrowing,
   qualification, or redirection.
3. Keep Highway-originated interpretations and suggestions as Working Ideas until accepted under
   the owning Request workflow.
4. Ask only one consequential missing-evidence question at a time.
5. Represent unavailable or uncertain evidence as `Unknown`; never invent it.
6. A request for explanation, comparison, or examples is not acceptance.
7. Stop proposing when the requester is finished or no useful grounded non-duplicate development
   remains.

## State and Ownership Contract

| State | User-visible meaning | Request mutation | Downstream mutation |
|---|---|---|---|
| Requester Evidence | User is supplying or has supplied intake evidence | None | None |
| Contribution Opportunity | Highway offers provisional understanding for correction | None | None |
| Request Proposal Refinement | Active Working Idea is being changed and re-evaluated | None | None |
| Converged Request Proposal | Complete candidate is ready for user acceptance | None | None |
| User Acceptance | Requester accepts the complete proposal | Not yet created | None |
| Evidence Completeness Validation | Existing owner checks run before creation | None on failure | None |
| Request Creation | Existing owner transaction succeeds | Create Request record/catalog | None |

## Boundary Contract

- `highway-new` remains the sole owner of Request completeness, acceptance, identifiers, records,
  catalogs, privacy, allocation, transactions, and creation outcomes.
- Incomplete, cancelled, blocked, privacy-rejected, validation-failed, allocation-failed, and
  write-failed paths create no Request and preserve existing bytes.
- `highway-new` does not perform Discovery analysis, create ADR content, propose architecture
  decisions, or create substitute artifacts.
- After successful creation, the response may direct the requester to `/highway-discovery
  REQXXXXXX` for option evaluation against Objectives, Controls, and NFRs.
