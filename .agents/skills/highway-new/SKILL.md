---
name: highway-new
description: "Manages a repository-wide request baseline and updating its state."
usage: "Invoke as `/highway-new` with a business request in plain language."
compatibility: all
metadata:
  version: 1.0.0
---

## Purpose

Create a business request artifact by collecting the business evidence required by the Evidence Completeness Rules.

## Experience

Request intake follows the Highway Experience Standard.
Ask one unresolved evidence question at a time, put the `Next Action` first, and omit
implementation details unless requested. During collection report `Current Domain`,
`Completed Domains`, `Remaining Domains`, and `Current Activity`; resume begins at the first incomplete evidence domain.

`User Exits` are `pause`, `cancel`, or `stop responding`; `Owner Outcomes` are `declined`,
`aborted`, or `blocked`. `Resume Applicability`: `Persisted owner evidence`. Request ownership
retains authority for identifiers, artifacts, catalogs, and completion claims; this skill never
creates a substitute record for another owner.

## When to use

- A requester has a business problem, idea, request, or desired change that needs an intake record.
- A requester needs to add business evidence to an incomplete request before durable creation.
- A repository owner needs a new request record with a catalog-owned identifier.

## When not to use

- Do not use for architecture, technology recommendations, implementation plans, Controls, or NFRs.
- Do not use for Request-to-Objective, Request-to-Control, or Request-to-NFR relationship discovery.
- Do not use to change an existing request lifecycle status after creation.

## Inputs

- The requester's plain-language business problem, idea, request, or desired change.
- The requester's answers collected during this invocation.
- The current Profile, Objectives, Controls, and NFRs when present, read through their owning workflows only as contextual example sources.
- `.highway/library/templates/output/request-record.md` for the complete request record structure.
- `.highway/library/templates/output/request-catalog.md` for the complete request catalog structure.
- The user-owned `requests/` directory and `requests/requests.md` catalog when present.
- The repository's `.highway/` root and existing request files when resolving the user-owned output location.

## Outputs

- A user-owned request record at `requests/REQXXXXXX.md`, only when all evidence domains satisfy the Evidence
Completeness Rules, using the complete authoritative structure defined by `.highway/library/templates/output/request-record.md`.
- A user-owned request catalog at `requests/requests.md`, only when a complete request is successfully created, using the complete authoritative structure defined by `.highway/library/templates/output/request-catalog.md`.
- A conversational response containing one question and one to three contextual examples while evidence remains incomplete.
- No request artifact when intake is empty, allocation fails, validation fails, or a transaction cannot complete.

## Workflow

1. Read the requester's initial description and the seven evidence domains in this order: Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints, Solution Constraints.
2. Reuse accepted evidence and identify a grounded interpretation of at least one consequential Request aspect before asking a questionnaire-first question.
3. When a grounded interpretation exists, present a Request Discovery Contribution Opportunity as a provisional Working Idea, then invite correction, addition, or removal. Do not request acceptance or create a Request at this stage.
4. After every substantive response, re-evaluate the active proposal with accepted evidence and preserve the requester's corrections. Ask exactly one consequential missing-evidence question only when responsible reasoning and available evidence cannot resolve it.
5. Mark each domain satisfied only when its evidence rule is met. Represent unavailable or uncertain evidence as `Unknown`; never invent it.
6. Generate one to three examples using this precedence order: existing request evidence, Profile, Objectives, Controls, NFRs. Keep examples and repository context separate from requester evidence and requirements.
7. Repeat proposal refinement and missing-evidence collection until the requester stops answering or all domains are complete and conversational convergence is reached.
8. Derive the title from an explicit requester title, otherwise from Problem evidence using the same input text each time.
9. Present a Converged Request Proposal for review only after the requester has made a substantive contribution, all required evidence is complete, and grounded non-redundant reasoning is unlikely to materially improve the proposal.
10. Read `requests/requests.md`, bootstrapping it with `Version: 1.0.0` and `Next ID: REQ000001` when absent, only after the requester accepts the complete proposal.
11. Allocate the catalog's `Next ID` only when it matches `REQ` followed by exactly six digits.
12. Build the request record and catalog update in memory before writing either file.
13. Validate identifier, status, completeness, privacy, record structure, catalog structure, and request index before writing.
14. Write the request record and catalog update only after both validations pass.
15. When the catalog changed during allocation, retry the exclusive allocation operation at most 3 times.
16. When every domain is complete and the proposal is accepted, build and validate the request artifact and catalog update, then write both; otherwise, create neither artifact and continue evidence collection.
17. When input contains a secret or regulated personal data, exclude it and request business-relevant replacement evidence.
18. When Version 1 creates a request, write status `proposed` and no relationship sections.
19. The request record and catalog update are created only after all seven evidence domains satisfy the Evidence Completeness Rules and the requester accepts the Converged Request Proposal.

For Business Constraints, use `No business constraints` when the requester confirms that no constraints apply.
This is canonical intake wording for the existing explicit empty state; preserve `unknown` for
uncertainty and do not persist the phrase as a new record value.

For Solution Constraints, ask one question at a time and collect these eight fields in this order:

- `allowed_solution_classes` as a user-owned extensible list containing one or more non-empty values or `unknown`.
  Preserve multiple entries without ranking them. An empty list, blank answer,
  malformed scalar, whitespace-only entry, or empty entry is invalid.
- `existing_platforms_required` as existing enterprise platforms that must be used.
- `existing_platforms_preferred` as existing enterprise platforms the requester names as preferred, kept distinct from required platforms.
- `known_systems` as descriptive business systems involved in, affected by, referenced by, or participating in the process.
- `hosting_restrictions` as conditions that exclude unsuitable hosting options.
- `vendor_restrictions` as conditions that exclude unsuitable vendors.
- `procurement_constraints` as acquisition constraints, including restrictions on new purchases.
- `regulatory_restrictions` as regulatory or data-handling conditions.

The list-shaped fields are `allowed_solution_classes`, `existing_platforms_required`,
`existing_platforms_preferred`, and `known_systems`. The scalar restriction fields are
`hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and
`regulatory_restrictions`.

For all other list-shaped fields, record a populated list, an explicit empty array, or `unknown`.
Record each field as user-provided evidence. Missing fields are not valid evidence. The absent constraint is neutral
and is never a preference, recommendation, ranking,
or selection criterion. A malformed value must be replaced by valid evidence or `unknown` before
creation.

allowed_solution_classes must contain one or more values or unknown; allowed_solution_classes cannot be empty because
it defines the future Discovery candidate space, and an empty value would make the permitted
solution domain indeterminate. Reject an empty candidate space rather than treating it as an
unconstrained request. Scalar restrictions require a non-empty value or `unknown`; they
never use an empty array.

For a Solution Constraints field error, identify the exact field, state its accepted value shape,
provide a valid example, and request a replacement value or unknown. For `allowed_solution_classes`, the error must state that
the field must contain one or more values or `unknown`. For other list-shaped fields, distinguish
a populated list, an explicit empty list, and `unknown`. For a scalar restriction, request a
non-empty value or `unknown`; never coerce an invalid blank into an empty list. A valid replacement
updates only the failed field and continues with the next unanswered question without restarting the domain. The bounded
recovery rule below applies before the write and preserves the original Request and catalog bytes.
Apply existing
privacy screening to replacement answers and write nothing when a replacement is blocked.
The blocked replacement is not written.

The future Discovery handoff must contain one or more allowed solution classes or unknown, never an
empty list; preserve those values without ranking them. Solution Constraints limit the future Discovery candidate space; they do not choose an architecture,
implementation pattern, technology, solution category, or candidate. Known systems and named
platform context remain descriptive business evidence and do not imply integration or architecture.
Discovery owns candidate generation, classification, comparison, scoring, recommendation, and

## Response Support Text

Use only the support appropriate to the active interaction:

- Validation Question: `**What would you add, correct, or remove?**`
- Acceptance Reassurance: `If this is accurate, just say so.`
- Discovery Reassurance: `If you don't know, say "I don't know" and we'll work through it together.`
- Additional Suggestions Reassurance: `If you'd like additional suggestions, just let me know.`
- Request Proposal Reassurance: `The goal is to make sure Highway understands the request correctly before creating the Request.`

## Request Discovery Contribution Opportunity

When accepted evidence supports a responsible first-pass interpretation of at least one consequential
Request aspect, open with exactly:

`Here is a proposed starting point for your Request:`

Present the interpretation as a provisional Working Idea. Close with exactly:

`**What would you add, correct, or remove?**`

This Request Discovery Contribution Opportunity is not a candidate for acceptance. It does not
create a Request, allocate an identifier, persist a catalog, perform Discovery analysis, create ADR
content, or propose an architecture decision. If no grounded interpretation exists, ask one
consequential missing-evidence question and do not invent a proposal.

## Request Proposal Refinement

Treat Highway-originated interpretations, implications, and suggestions as Working Idea material
until the requester accepts the resulting proposal. Re-evaluate after every addition, correction,
removal, combination, narrowing, qualification, or redirection. Reuse evidence already represented
in the active proposal and do not ask a domain question that the evidence already answers.

Ask exactly one natural-language question at a time, and only when it is a consequential
missing-evidence question. A request for explanation,
comparison, or examples is not acceptance. Keep unavailable or uncertain evidence as `Unknown`,
and apply existing privacy screening before retaining replacement evidence. Pause, cancel, or a
stopped response creates no Request artifact and preserves existing bytes.

## Request Development Lifecycle

The interaction moves through Requester Evidence, Request Discovery Contribution Opportunity,
Request Proposal Refinement, Converged Request Proposal, User Acceptance, Evidence Completeness
Validation, and Request Creation. These are user-relevant meanings, not a reason to narrate internal
state transitions. No Request mutation occurs before User Acceptance; a Converged Request Proposal
is complete enough for review but remains provisional until that boundary.

## Converged Request Proposal

After substantive requester contribution, owner completeness, and conversational convergence, review
the candidate under the heading `**Here's what I've captured as your request:**`. Include Title,
Problem, Actors, Current Process, Desired Change, Success Measures, Business Constraints, and
Solution Constraints. End the review with exactly `**What would you add, correct, or remove?**`
and, when appropriate, `If this is accurate, just say so.`

Acceptance is requested only for this complete proposal. Approval, explanation requests, partial
responses, or a request for more suggestions do not independently create a Request. After acceptance,
run the existing Evidence Completeness Rules and all existing validation, privacy, allocation, and
transaction checks before writing anything.

## Acceptance Boundary

User Acceptance is the sole boundary at which the complete proposal becomes eligible for Request
creation. Incomplete, cancelled, blocked, privacy-rejected, validation-failed, allocation-failed,
and write-failed paths create no Request artifact and preserve existing Request and catalog bytes.

## Ownership Boundaries

`highway-new` remains the sole owner of Request evidence, completeness, acceptance, identifiers,
records, catalogs, privacy, allocation, transactions, and creation outcomes. It creates no
Discovery or ADR artifact and does not perform candidate generation, comparison, scoring,
recommendation, architecture analysis, solution selection, rationale, consequences, or
authorization. After successful creation, direct the requester to `/highway-discovery REQXXXXXX`
for option evaluation against Objectives, Controls, and NFRs.
architecture analysis. ADR owns solution and architecture decisions, including selection, rationale,
consequences, and authorization. This workflow creates no Discovery or ADR artifact.

## Verification

- Confirm the generated record path matches `requests/REQ` followed by six digits.
- Confirm the generated Request record conforms to the complete structure defined by `.highway/library/templates/output/request-record.md`.
- Confirm the generated Request catalog conforms to the complete structure defined by `.highway/library/templates/output/request-catalog.md`.
- Confirm Next ID advances exactly once after successful request creation.
- Confirm no secret or regulated personal data appears in the written request record.
- Confirm a failed allocation, validation, or write leaves existing request and catalog bytes unchanged.
- Confirm repeated identical input produces identical question, examples, title, and artifact content.
- Confirm new requests are created with
status: proposed.
- Confirm empty arrays and `unknown` are distinct, valid, non-blocking Solution Constraints states.
- Confirm `allowed_solution_classes` contains one or more non-empty values or `unknown`, never an empty list.
- Confirm no request record is written while any evidence domain remains incomplete.
- Confirm no catalog update occurs while any evidence domain remains incomplete.

## Error Handling

- Empty initial input: abort and report that a feature description is required.
- Missing `.highway/` root: abort and report that the project root cannot be located.
- Missing or invalid output template: abort and report the template path.
- Missing or invalid catalog next ID: abort and report that allocation cannot proceed.
- Catalog changed during allocation: retry the exclusive operation at most 3 times.
- Secret or regulated personal data detected: retry intake 3 times maximum after requesting replacement evidence.
- Invalid Solution Constraints field value: retry at most 3 times; on exhaustion, preserve the original Request and catalog bytes.
- Request or catalog validation failure: abort, write nothing, and preserve the original bytes of every existing artifact.
- Request or catalog write failure: abort, write nothing, and preserve the original bytes of every existing artifact.
- Architecture, implementation, Control, NFR, or relationship request: fall back to the owning workflow without writing a request artifact.
- One or more evidence domains remain incomplete: abort the write, write nothing, and continue evidence collection.

## Example

`/highway-new We need a consistent way for finance reviewers to reduce manual invoice comparison time.`
