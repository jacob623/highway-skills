---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 8.1.0
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
- `.highway/library/knowledge/highway-identity.md` for behavioral guidance, `.highway/library/knowledge/highway-vision.md`
  for strategic direction, and `.highway/library/knowledge/highway-platform-objectives.md` for evaluation criteria.
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
machine fields.

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

#### Semantic convergence decision

After substantive evidence changes the active understanding, reconsider the complete active evidence
with relevant accepted Profile context before deciding whether to propose convergence. This is a
semantic decision, not a turn count, a mandatory-question rule, a new-noun trigger, or a requirement
to explore every possible category.

Use this order:

1. Resolve consequential user-owned ambiguity or contradiction through the Experience Standard.
2. Develop a grounded substantive relationship, implication, distinction, tension, alternative,
  opportunity, concern, or recommendation when it could materially change the domain's meaning.
3. Provide the applicable Contribution Opportunity when Highway materially shaped that Working Idea
  and an equivalent opportunity has not already occurred.
4. Proceed to the domain-specific Converged Proposal when no consequential ambiguity or useful
  supported development remains.
5. Use available evidence or a grounded Working Idea before asking an unresolved-domain question.

Model-originated relationships and implications remain provisional Working Idea material until the
person accepts them through the existing Profile domain acceptance path. A complete, directly
supplied contribution may proceed directly when Profile does not materially reshape it. Do not
manufacture a relationship from unsupported evidence, and preserve supported implications for their
appropriate unresolved domain rather than forcing them into the active domain.

##### Organizational expression

Expression guides representation, not truth. Acquisition may reveal characteristic terminology,
recurring language, recognizable phrasing, or formality. Use suitable supported terminology in
Profile proposals when it improves clarity, but do not preserve unsupported claims or imitate style
at the expense of accuracy. The person's active wording and corrections remain authoritative.
Expression guidance is transient and does not add retained tone, voice, persona, style, or expression
fields. Profile-owned expression guidance does not control Objectives, Controls, NFRs, or other owners.

##### Identity

Identity establishes who the organization is and what it meaningfully encompasses, including durable
activity and purpose. It is not a technology-landscape inventory. When Profile materially assembles
Identity from multiple sources or substantial interpretation, present meaningful organizational
facets provisionally before final synthesis when that helps inspection. A directly supplied,
domain-complete description may proceed directly when Profile does not materially reshape it.

After convergence, validate with `**Is this an accurate description of your organization?**`
followed by `You can also change it or provide your own description.`

##### Vision

Vision describes the future the organization is trying to create. Reason from the full accepted
Identity and other relevant Profile evidence; do not let one Identity facet become the whole Vision
merely because it is the easiest continuation.

When entering unresolved Vision, open the user-visible subject with `### Where you're going`.

Validate the Converged Proposal with **Does this accurately reflect where you'd like [Organization
Name] to go?** followed by `You can also change it or provide your own vision.`

##### Competitive Path

Competitive Path describes the broad organizational approach toward the accepted Vision. It may
reason about strategic choices, sequencing, priorities, and organizational direction. It does not
elicit or retain Controls, NFRs, safeguards, architecture, implementation requirements, or plans.
When volunteered downstream-owned information changes the broad approach, retain only its broad
strategic meaning. When entering unresolved Competitive
Path, open the user-visible subject with `### How you'll get there`.

Validate the Converged Proposal with **Does this accurately reflect how [Organization Name] plans to
get there?** followed by `You can also change it or provide your own approach.`

##### Guiding Principles

Guiding Principles describe the enduring principles that shape organizational decisions. Use
accepted Identity, Vision, Competitive Path, and other accepted Profile context as grounding. Do not
turn a principle into an enforceable Control. When entering unresolved Guiding Principles, open the
user-visible subject with `### What will guide your decisions`.

Validate the Converged Proposal with **Does this accurately reflect what should guide decisions at [Organization Name]?** followed by `You can also change it or provide your own principles.`

#### Cross-domain reasoning

New substantive organizational evidence is evaluated across every unresolved Profile domain.
Accepted Identity informs Vision when relevant; accepted Identity and Vision inform Competitive Path;
accepted Identity, Vision, and Competitive Path inform Guiding Principles.

Profile uses transient Conversational Clarification through the Highway Experience Standard.
Persisted clarification records belong to `highway-clarify` when separately requested.

## Operations

Operations remain setup, configure, readiness, view, show, describe, add, update, remove, and reset.
Persist only information the person supplied, selected, or accepted, including permitted optional
Context. Acceptance authorizes the mutation but is not successful persistence. After acceptance
changes retained Profile state, perform that mutation before any dependent readiness, completion, or
other owner result. If persistence fails, stop before dependent progression and report actionable
failure context under the Constitution's common failure model.

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
- User-visible collaboration follows the Highway Experience Standard.
- Domain completeness does not independently establish conversational convergence.
- Substantive evidence changes trigger useful re-evaluation with relevant accepted context.
- Mature direct contributions retain a short path without ceremonial exploration.
- Working Ideas remain transient and unretained until accepted through the existing domain path.
- Supported cross-domain implications are preserved for the appropriate unresolved domain.
- No retained schema field or readiness dimension is added for convergence or collaboration concepts.

## Error Handling

- A malformed, contradictory, or structurally invalid retained Profile is `Blocked` and is not mutated.
- An accepted Profile mutation that fails does not establish the affected domain as persisted and does not permit dependent terminal output.
- Stop before dependent progression and report actionable user-facing failure context under the Constitution's common failure model.

## Example

`/highway-profile readiness`
