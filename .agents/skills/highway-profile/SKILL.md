---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 11.1.0
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
Beneath it, unemphasized, say `If this is accurate, just say so.` The acceptance request stays the
only emphasized element in the block.

Before the first Substantive Contribution in an active domain, add the unemphasized reassurance
`If you don't know, say "I don't know" and we'll work through it together.` After the first
Substantive Contribution in that domain, remove the conditional reassurance. Imported website
evidence does not count as a Substantive Contribution.

The person's response to that request is the domain's acceptance boundary. Recognize acceptance by
what the response means, not by whether it matches a particular phrase, and do not wait for a second
confirmation. When the person gives unambiguous approval, proceed directly to the Converged Proposal
and then its validation question. Do not insert a second contribution-oriented review question.
Where the proposal and candidate are materially identical, the validation question may be
`Anything you'd change before we keep this?`. Approval with new substantive information triggers
re-evaluation. Ambiguous approval remains subject to the existing convergence handling. Once a
domain is accepted, do not present the same substance again; if a later revision is needed, name
what changed. Compare against accepted content ignoring differences in line wrapping and spacing.
When it is unclear whether a candidate has developed since acceptance, present it.

A domain's substance is kept only after its finished candidate has been presented and accepted.
Material gathered while composing a domain stays working material until then, in all four domains.

The validation question applies only where a candidate has been presented. Where nothing has been
captured yet, invite a reaction instead, under the heading the Highway Experience Standard defines
for that moment, `**Here is a proposed starting point for your [domain]:**`, and ask for no
acceptance there.

Where the preceding domain produced no accepted substance, say that nothing has been accepted yet
rather than inventing a carry-forward.

Say nothing about retaining the answer, about where this sits in the sequence, about a domain's
state, or about what comes next. This holds for the whole conversation, not only for readiness
wording: the person reads their own material developing, not an account of the work being done to
it.

#### Advisory question scaffolding

Before a Profile-owned question whose answer depends on advisory reasoning, present one grounded
advisory addition when accepted Profile evidence supports one. The addition may be a distinction,
implication, connection, tension, tradeoff, possibility, or recommendation; attribute it to the
workflow, keep it as a Working Idea outside the candidate unless the person adopts it, and use it to
explain the question rather than merely repeat accepted evidence. Canonical questions, validation
questions, acceptance-boundary questions, and direct clarification of consequential ambiguity are
excluded. The question is the only emphasized element.

When several grounded additions are possible, prefer them in this order: distinction, implication,
connection, tension, tradeoff, possibility, recommendation. Prefer revealing structure already
present in accepted evidence before introducing a new possibility.

A contribution is not satisfied by renaming, relabeling, summarizing, or paraphrasing accepted
evidence. It must supply a distinction, implication, tension, connection, tradeoff, possibility, or
decision criterion that was not already explicit in the person's own words.

_A tradeoff made visible._ The person says growth should never come at the expense of meaningful
work. What the workflow adds: one tension I notice is that popularity and meaningful work often
align, but not always. A class might attract many registrations because it is easy to market while
another better reflects what the organization exists to teach. **When those two pull in different
directions, which one should win?**

#### Contribution in practice

When the person supplies something substantial, add one thing to it. Attribute the addition to the
workflow, leave it outside the candidate until they adopt it, and close on a question that invites
them to push back. Three worked examples, one move each, then one example of what not to do.

*A distinction drawn out of one word.* The person says their work is about getting people into
housing faster. What the workflow adds: "faster" is carrying two different organizations — one that
shortens the wait for a decision, one that shortens the wait for keys. The first is a case-handling
organization; the second is a supply organization, and they would not make the same choices.
**Which of those two would you be judged on?**

*Latent structure named as an organizing principle.* The person lists training frontline staff,
publishing the eligibility rules, and letting applicants see their own case. What the workflow adds:
those are not three activities but one principle — moving knowledge toward the person who needs it
rather than toward the institution that holds it. **Does that read as the thing you're building, or
as one strand of it?**

*A stated preference reframed as a decision criterion.* The person says they would rather do one
thing properly than three things badly. What the workflow adds: as a preference that is a
temperament, but as a criterion it is sharper — a new commitment has to displace an existing one
rather than sit alongside it, which makes it a test any proposal can be put through. **What would
have to be true for you to break it?**

Each of those three works on material the person already supplied. A contribution that reaches past
that material is not a contribution, however useful it sounds. One worked counter-example.

*A move with nothing underneath it.* The person says: "We are a bakery." The workflow answers: "One
possibility I see is franchising — you could license the brand to independent operators and grow
without the capital." That is not a contribution. Nothing in the accepted material supports
franchising, growth, licensing, or a view about capital; the person said what they are, not what
they want, and the move invents the rest. The tell is that the addition would read the same if the
person had said they were a dentist. What the moment actually calls for is the question that opens
the material up: **What does the bakery do that a person would miss if it closed?**

#### Possibility-list Contribution Opportunities

Before convergence, when accepted Profile evidence supports several distinct grounded possibilities,
Profile MAY present a concise list as one Contribution Opportunity. The list is pre-convergence
reaction material, not a recommendation set and not three advisory contributions. Treat the whole
list together with its closing invitation as one opportunity under the existing Experience Standard;
this behavior does not modify X2.69.

Each item must remain provisional and traceable to accepted Profile evidence. The person may adopt,
reject, combine, modify, or ignore items individually; an unaddressed item is not accepted. Use no
more than three items, and close with the shared emphasized question that asks what to add, correct,
or remove. Do not present the list as a candidate, acceptance request, or selection among options.
After convergence, present the singular Converged Proposal path instead.

#### Structure-revealing contributions

When contributing a distinction, implication, connection, tension, tradeoff, possibility, or
recommendation, prefer contributions that reveal structure already present in accepted evidence.
Structure may be a relationship between accepted facts, an organizing principle, a role played by
an activity or capability, a hierarchy, a decision criterion, a tension, a dependency, or a
recurring pattern. Structure is not a summary of accepted facts.

This is a selection and execution preference for existing contribution types, not a new
contribution category. When useful grounded reasoning exists, use this hierarchy:

1. Reveal structure: make a supported relationship, pattern, role, tension, or organizing principle
  explicit when it is implied by accepted evidence but not yet stated by the person.
2. Reveal an implication: explain a reasonable consequence of the revealed structure.
3. Extend one step: offer a reachable possibility, opportunity, risk, question, or tradeoff that
  follows directly from the immediately preceding step.

Do not treat restatement, reorganization, relabeling, paraphrase, or synonym replacement alone as
a contribution. Do not skip directly to an extension when useful structure is available. If no
useful structure is supported, do not manufacture one merely to satisfy this preference.

After revealing structure, the workflow may provide one connected linear chain of reasoning. Each
step must derive directly from the immediately preceding step, remain traceable to accepted
evidence, be attributable to Highway, and remain a Working Idea outside the candidate unless the
person adopts it. A chain may be structure → implication or structure → implication → possibility
or tradeoff. The chain may contain structure, implication, possibility, or tradeoff. Diverging
alternatives, recommendation sets, and opportunity catalogs are not permitted. Those are multiple
independent additions rather than one connected advisory move.

The addition must stop making sense when detached from the accepted evidence. For example, a
possibility such as franchising is not grounded merely because the organization is a bakery. Do not
make consultant-style strategic leaps, and close the connected move with the existing reaction
invitation when that invitation applies.

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
and treat the person's response as the acceptance boundary for Identity. Retain nothing from
Identity before that candidate is presented and accepted. When no material has been captured, use
`**Here is a proposed starting point for your Identity:**`.

##### Vision

Vision describes the future the organization is trying to create. Reason from the full accepted
Identity and other relevant Profile evidence; do not let one Identity facet become the whole Vision
merely because it is the easiest continuation. Vision does not elicit or retain the approach,
sequencing, or organizational method for reaching that future; that approach is developed with
Competitive Path.
When the person offers one of those while composing Vision, say so in their own terms:
`**That is an important part of how you will get there. I will carry it forward when we reach
Competitive Path, and return to Vision.**`

When entering unresolved Vision, open the user-visible subject with `### Where you're going`. Open
it by naming accepted Identity substance in the person's own words and connecting it to the question
being asked. Open that subject with grounded possibilities drawn from accepted Profile evidence
before asking the Vision question. When no material has been captured, use
`**Here is a proposed starting point for your Vision:**`.

Present the Converged Proposal under `**Here's what I've captured as your Vision:**`, validate it
with the shared validation question, and treat the person's response as the acceptance boundary for
Vision. Retain nothing from Vision before that candidate is presented and accepted.

##### Competitive Path

Competitive Path describes the broad organizational approach toward the accepted Vision. It may
reason about strategic choices, sequencing, priorities, and organizational direction. It does not
elicit or retain Controls, NFRs, safeguards, architecture, implementation requirements, or plans.
When volunteered downstream-owned information changes the broad approach, retain only its broad
strategic meaning. When entering unresolved Competitive
Path, open the user-visible subject with `### How you'll get there`. Open it by naming accepted
Vision substance in the person's own words and connecting it to the question being asked. Open that
subject with grounded possibilities drawn from accepted Profile evidence before asking the
Competitive Path question. When no material has been captured, use
`**Here is a proposed starting point for your Competitive Path:**`.

Present the Converged Proposal under `**Here's what I've captured as your Competitive Path:**`,
validate it with the shared validation question, and treat the person's response as the acceptance
boundary for Competitive Path. Retain nothing from Competitive Path before that candidate is
presented and accepted.

##### Guiding Principles

Guiding Principles describe the enduring principles that shape organizational decisions. Use
accepted Identity, Vision, Competitive Path, and other accepted Profile context as grounding. Do not
turn a principle into an enforceable Control. When entering unresolved Guiding Principles, open the
user-visible subject with `### What will guide your decisions`. Open it by naming accepted
Competitive Path substance in the person's own words and connecting it to the question being asked.
Open that subject with grounded possibilities drawn from accepted Profile evidence before asking the
Guiding Principles question. When no material has been captured, use
`**Here is a proposed starting point for your Guiding Principles:**`.

Present the Converged Proposal under `**Here's what I've captured as your Guiding Principles:**`,
validate it with the shared validation question, and treat the person's response as the acceptance
boundary for Guiding Principles. Retain nothing from Guiding Principles before that candidate is
presented and accepted.

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
- No domain substance is retained before that domain's candidate has been presented.
- Each domain opening names accepted substance from the preceding domain.
- Contribution in practice carries three worked exemplars, each adding one thing.
- Contribution in practice carries one counter-example of an addition the accepted material does not support.
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
