---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 11.0.0
---

# highway-profile

## Purpose

Collects organizational evidence and persists accepted context in the Markdown Profile.

## Scope

The Profile owns four readiness domains: Identity, Vision, Competitive Path, and Guiding
Principles. It does not create Controls, NFRs, Objectives, governance rules, or Highway identity.

## When to use

Use `setup` or `configure` to collect evidence, `readiness` to assess the retained Profile, and
`view`, `show`, `describe`, `add`, `update`, `remove`, or `reset` for explicit inspection or change.

## When not to use

Do not treat foundational Highway context or unaccepted proposal evidence as organizational fact.

## Inputs

- Project root containing `.highway/`.
- The retained Profile at `.highway/library/knowledge/profile.md`, when present.
- The structure at `.highway/library/templates/output/profile-record.md`.
- `.highway/library/knowledge/highway-identity.md` as shared, non-normative context only.
- `.highway/governance/experience-standard.md` as the authoritative interaction contract.
- User requests, proposal evidence, supplied organizational material, and a public organizational
  website when supported retrieval is available.

## Outputs

The retained artifact is `.highway/library/knowledge/profile.md`. Its complete reusable structure
is owned by `.highway/library/templates/output/profile-record.md`; this skill does not repeat that
skeleton. The optional Context structure is also owned by that template.

## Readiness

Profile determines domain completeness. An absent Profile is a valid initial state. An absent Profile
is `Missing` with Next Action: `/highway-profile setup`. A present malformed, contradictory, or
structurally invalid retained Profile is `Blocked` with Next Action: `None` and is left unchanged.
A valid incomplete Profile with any `not_discussed` domain is `Missing` with Next Action:
`/highway-profile configure`. A valid Profile with all four domains `discussed` or `bounded` is
`Complete` with Next Action: `None`. Optional Context and optional enrichment do not change readiness.

Profile readiness is an internal result containing `Status:`, `Summary:`, `Next Action:`, and
`Blocking Reason:` fields. These fields are not a normal user-facing output template. Direct
readiness requests may show the requested result; orchestrated conversation does not render these
machine fields, and does not name readiness statuses, next actions, blocking reasons, domain states,
or persistence steps.

Domain completeness is obtained by reading the retained Profile record at
`.highway/library/templates/output/profile-record.md`'s declared location. No command is invoked to
determine readiness.

#### Domain model

The Profile follows the complete structure in `.highway/library/templates/output/profile-record.md`.
It owns the meaning, evidence, state, and readiness of Identity, Vision, Competitive Path, and
Guiding Principles. Accepted evidence that establishes a domain sets it to `discussed`; an explicit
user decision not to establish further evidence may set an otherwise unresolved domain to `bounded`.
Missing evidence, uncertainty, inability to discover evidence, or `I don't know` alone does not
establish `bounded`.

Content mutations do not change the retained Profile schema version. Foundational Highway context may
show what evidence is useful, but it is not retained as organizational fact. Workflow-specific input
remains authoritative.

The Highway Experience Standard determines whether collaborative development has converged enough,
how contributions and clarification are handled, and how user-visible interaction is presented.
Profile determines the four domain meanings, evidence, completeness, readiness, persistence, and
downstream ownership described here.

Highway Identity is shared, non-normative context only.

### Acquisition

Acquisition evaluates retained Profile context, establishes Repository Name when missing, and gives
the person one opportunity to reuse supplied organizational material or a public website before
ordinary domain questioning. Supplied URLs are accepted optional Profile Context; facts derived from
websites or imported material remain proposed until accepted. When retrieval is unavailable,
continue without exposing the missing capability.

Evaluate each source across all unresolved Profile domains before selecting the next behavior. Reuse
accepted evidence across domains and do not ask the person to reproduce information already present
in supplied material. Do not use unspecified model memory or prior-agent memory as organizational
evidence. Acquisition is limited to Profile evidence and does not perform technology-platform
discovery.

When no retained Profile exists, begin first-time Setup with:

#### Let's get to know your organization

Then ask:

**What would you like to call your Highway repository?**

Accept a directly supplied Repository Name as supplied. It does not imply acceptance of Organization
Name or other organizational facts. After it is accepted, offer existing organizational material
before ordinary domain questioning. An illustrative prompt is `**Do you already have something I can
use to start understanding [Repository Name]?**` followed by an invitation to share a website,
description, strategy document, or assistant export.

The canonical questions are Identity `**What does [Organization Name] do?**`, Vision `**What is the
future vision of [Organization Name]?**`, Competitive Path `**How does [Organization Name] plan to
get there?**`, and Guiding Principles `**What principles or values guide decisions at [Organization
Name]?**`. When Organization Name is not accepted, use the accepted Repository Name where natural.
Canonical questions are Profile-owned fallbacks for unresolved organizational information. Evaluate
available Profile evidence before using them.

#### Domain completeness

A domain is complete when accumulated evidence supports one cohesive organizational narrative that
meaningfully answers the domain's purpose without unsupported organizational facts.

Profile determines domain completeness. The Highway Experience Standard determines whether
collaborative development has converged enough for that complete candidate to become a Converged
Proposal.

Profile-specific validation questions apply to the domain's Converged Proposal.

Every domain presents its Converged Proposal the same way. Present the candidate under its capture
heading, `**Here's what I've captured as your [domain]:**`, where `[domain]` is the domain name. Put
one acceptance request at the bottom: the validation question, which is
`**What would you add, correct, or remove?**`. A sharper open question drawn from the conversation
may stand in for it, as long as it stays emphasized and still asks what to add, correct, or remove.

The person's response to that request is the domain's acceptance boundary. Recognize acceptance by
what the response means, not by whether it matches a particular phrase, and do not wait for a second
confirmation. Once a domain is accepted, do not present the same substance again; if a later
revision is needed, name what changed. Compare against accepted content ignoring differences in line
wrapping and spacing. When it is unclear whether a candidate has developed since acceptance, present
it.

##### Organizational expression

Expression guides representation, not truth. Acquisition may reveal characteristic terminology,
recurring language, recognizable phrasing, or formality. Use suitable supported terminology in
Profile proposals when it improves clarity, but do not preserve unsupported claims or imitate style
at the expense of accuracy. The person's active wording and corrections remain authoritative.
Expression guidance is transient and does not add retained tone, voice, persona, style, or expression
fields. Profile-owned expression guidance does not control Objectives, Controls, NFRs, or other owners.

##### Identity

Identity establishes who the organization is and what it meaningfully encompasses, including durable
activity and purpose. It is not a technology-landscape inventory.

After convergence, present the Converged Proposal under
`**Here's what I've captured as your Identity:**`, validate it with the shared validation question,
and treat the person's response as the acceptance boundary for Identity.

##### Vision

Vision describes the future the organization is trying to create. Reason from the full accepted
Identity and other relevant Profile evidence; do not let one Identity facet become the whole Vision
merely because it is the easiest continuation. Vision does not elicit or retain the approach,
sequencing, or organizational method for reaching that future; those belong to Competitive Path.

When entering unresolved Vision, open the user-visible subject with `### Where you're going`. Open
that subject with grounded possibilities drawn from accepted Profile evidence before asking the
Vision question.

Present the Converged Proposal under `**Here's what I've captured as your Vision:**`, validate it
with the shared validation question, and treat the person's response as the acceptance boundary for
Vision.

##### Competitive Path

Competitive Path describes the broad organizational approach toward the accepted Vision. It may
reason about strategic choices, sequencing, priorities, and organizational direction. It does not
elicit or retain Controls, NFRs, safeguards, architecture, implementation requirements, or plans.
When volunteered downstream-owned information changes the broad approach, retain only its broad
strategic meaning. When entering unresolved Competitive
Path, open the user-visible subject with `### How you'll get there`. Open that subject with grounded
possibilities drawn from accepted Profile evidence before asking the Competitive Path question.

Present the Converged Proposal under `**Here's what I've captured as your Competitive Path:**`,
validate it with the shared validation question, and treat the person's response as the acceptance
boundary for Competitive Path.

##### Guiding Principles

Guiding Principles describe the enduring principles that shape organizational decisions. Use
accepted Identity, Vision, Competitive Path, and other accepted Profile context as grounding. Do not
turn a principle into an enforceable Control. When entering unresolved Guiding Principles, open the
user-visible subject with `### What will guide your decisions`. Open that subject with grounded
possibilities drawn from accepted Profile evidence before asking the Guiding Principles question.

Present the Converged Proposal under `**Here's what I've captured as your Guiding Principles:**`,
validate it with the shared validation question, and treat the person's response as the acceptance
boundary for Guiding Principles.

#### Cross-domain reasoning

New substantive organizational evidence is evaluated across every unresolved Profile domain.
Accepted Identity informs Vision when relevant; accepted Identity and Vision inform Competitive Path;
accepted Identity, Vision, and Competitive Path inform Guiding Principles. When evidence offered
while composing one domain supports another that is still unresolved, carry it forward to the
appropriate unresolved domain rather than discarding it.

Persisted clarification records belong to `highway-clarify` when separately requested.

## Operations

Operations remain setup, configure, readiness, view, show, describe, add, update, remove, and reset.
Persist only information the person supplied, selected, or accepted, including permitted optional
Context. Acceptance authorizes the mutation but is not successful persistence. The authorized
mutation is a write to the retained Profile record. After acceptance
changes retained Profile state, perform that mutation before any dependent readiness, completion, or
other owner result. If persistence fails, stop before dependent progression and report actionable
failure context, leave the affected domain unchanged, and do not claim successful readiness or
completion. Describe a failure in terms the person can act on, without naming internal operations.

Retain only the accepted cohesive domain narrative, accepted explicit corrections or replacements,
accepted explicit domain boundaries, and optional Context permitted by profile-record.md.

When guided setup or configure reaches completion, persist the final accepted domain mutation first,
then emit one concise user-relevant synthesis before returning to Setup. Use the accepted organization
name when available and connect the accepted Profile understanding to later Highway guidance. Do not
expose machine-status fields, owner-result mechanics, or implementation detail, and do not ask a new
question.

## Verification

- The retained record follows `.highway/library/templates/output/profile-record.md`.
- Readiness uses the four Profile domains and preserves `Missing`, `Blocked`, and `Complete` outcomes.
- Profile determines domain completeness; user-visible convergence follows the Highway Experience Standard.
- Identity, Vision, Competitive Path, and Guiding Principles retain their domain-specific boundaries.
- Canonical questions remain fallbacks for unresolved domains and do not replace useful grounded Profile reasoning.
- Optional Context, Organization Name, Organization URL, and optional enrichment do not affect readiness.
- Only user-provided or user-accepted organizational evidence is retained.
- Each accepted domain mutation succeeds before Profile uses it as persisted knowledge.
- Domain completeness does not independently establish conversational convergence.
- Supported cross-domain implications are preserved for the appropriate unresolved domain.
- Each domain presents its Converged Proposal under its capture heading.
- Each domain uses the single defined validation question.
- Each question requiring a response is emphasized.
- Each domain crosses one acceptance boundary before its substance is retained.
- Confirmed substance is not presented again unless the re-presentation names what changed.
- A candidate whose development since acceptance is unclear is presented rather than suppressed.
- A term the person rejected does not reappear, including as a synonym.
- An amendment preserves the accepted content's form.
- A correction that cannot be located is reported rather than applied elsewhere.
- Each Substantive Contribution receives one acknowledgment.
- An acknowledgment adds understanding beyond restating the contribution.
- Vision retains its boundary against approach, sequencing, and organizational method.
- Domain completeness is obtained by reading the retained Profile record.
- Persistence writes the accepted domain mutation to the retained Profile record.
- Internal readiness vocabulary does not appear in orchestrated conversation.
- No retained schema field or readiness dimension is added for convergence or collaboration concepts.

## Error Handling

- A malformed, contradictory, or structurally invalid retained Profile is `Blocked` and is not mutated.
- An accepted Profile mutation that fails does not establish the affected domain as persisted and does not permit dependent terminal output.
- An unexpected persistence failure stops dependent progression, reports actionable user-facing
  context, and leaves the affected domain unchanged.

## Example

`/highway-profile readiness`
