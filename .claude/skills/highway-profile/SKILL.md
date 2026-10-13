---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 11.2.0
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

Using your organization's name is often a good choice.

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

##### Response Support Text

Profile uses the following reusable interaction elements.

###### Validation Question

The default validation question is:

**What would you add, correct, or remove?**

A sharper open question drawn from the active discussion may replace it when it still asks what to add, correct, or remove.

The Validation Question remains the only emphasized element in a review block.

###### Acceptance Reassurance

The Acceptance Reassurance is:

If this is accurate, just say so.

Use it beneath a Validation Question when the person is reviewing a candidate or Converged Proposal.

###### Discovery Reassurance

The Discovery Reassurance is:

If you don't know, say "I don't know" and we'll work through it together.

Use it when the person is being asked to originate unresolved organizational information and no grounded starting point, Working Idea, interpretation, possibility, or advisory contribution has yet been supplied for reaction.

###### Combined Reassurance

The Combined Reassurance is:

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

Use the Combined Reassurance when both are reasonable outcomes of the interaction.

Use the Acceptance Reassurance alone when the person is reacting to a candidate or Working Idea and "I don't know" would be unnatural.

Use the Discovery Reassurance alone when the person is being asked to originate information and no meaningful starting point has yet been provided.

Every domain presents its Converged Proposal the same way.

Present the candidate under its capture heading:

**Here's what I've captured as your [domain]:**

Place the Validation Question beneath the candidate.

Place the applicable reassurance beneath the Validation Question.

Render:

Validation Question

blank line

applicable reassurance

The Validation Question remains the only emphasized element in the review block.

Use the Discovery Reassurance only when the person is being asked to originate unresolved organizational information and the workflow has not yet supplied a meaningful starting point for reaction.

Do not use the Discovery Reassurance merely because no Substantive Contribution has occurred yet.

A grounded possibility, interpretation, distinction, implication, connection, tension, tradeoff, recommendation, or other Working Idea already gives the person something to react to.

In those cases, use the Acceptance Reassurance or Combined Reassurance as appropriate.

Imported website evidence does not count as a user Substantive Contribution.

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

When a Discovery Contribution Opportunity is active, incorporate one grounded advisory addition into
its structured starting point when accepted Profile evidence supports one. The addition may be a
distinction, implication, connection, tension, tradeoff, possibility, or recommendation; attribute it
to the workflow, keep it as a Working Idea outside the candidate unless the person adopts it, and let
the person react through the active Discovery Contribution Opportunity. Use an advisory question only
when accepted evidence cannot support a responsible starting point or consequential ambiguity remains
unresolved. Canonical questions, validation questions, acceptance-boundary questions, and direct
clarification of consequential ambiguity are excluded.

When several grounded additions are possible, prefer them in this order: distinction, implication,
connection, tension, tradeoff, possibility, recommendation. Prefer revealing structure already
present in accepted evidence before introducing a new possibility.

A contribution is not satisfied by renaming, relabeling, summarizing, or paraphrasing accepted
evidence. It must supply a distinction, implication, tension, connection, tradeoff, possibility, or
decision criterion that was not already explicit in the person's own words.

_A tradeoff made visible._ The person says growth should never come at the expense of meaningful
work.

What the workflow adds:

One tension I notice is that popularity and meaningful work often align, but not always. A class
might attract many registrations because it is easy to market while another better reflects what
the organization exists to teach.

When a Discovery Contribution Opportunity is active, that tension belongs inside the proposed
starting point rather than in a follow-up question.

For example:

- Important Tradeoff
  Growth is valuable, but not at the expense of the organization's most meaningful work. When
  popularity and mission pull in different directions, meaningful work remains the priority.

The person reacts to the proposed starting point rather than recreating the tradeoff through
additional questioning.

#### Contribution in practice

When the person supplies something substantial, add one grounded thing to it. Attribute the addition
to the workflow, leave it outside the candidate until they adopt it, and present it inside the active
structured starting point so the person can add, correct, remove, or replace it through the shared
reaction path. A contribution that reaches past the person's material is not a contribution, however
useful it sounds. One worked counter-example.

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
3. Extend one step: offer a reachable possibility, opportunity, risk, or tradeoff that follows
  directly from the immediately preceding step.

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
make consultant-style strategic leaps. When a Discovery Contribution Opportunity is active, present
the connected move inside its proposed starting point and let the person react through the existing
reaction invitation.

##### Interpretation confidence

Prefer a grounded interpretation that can be corrected over a missing interpretation that forces the person to create it from scratch.

When accepted evidence already supports a useful distinction, implication, connection, tension, structure, organizing principle, or Working Idea, do not ask a question that merely seeks permission to express the interpretation.

When accepted evidence supports a responsible first-pass interpretation of Vision, Competitive Path, or Guiding Principles, prefer presenting a structured starting point rather than continuing exploratory questioning.

When a Discovery Contribution Opportunity is active, express that grounded interpretation inside its proposed starting point rather than questioning it separately.

The starting point exists to give the person something meaningful to react to.

Questions remain available when accepted evidence cannot support a responsible starting point.

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

### Identity Discovery Contribution Opportunity

When website content, imported material, or discovery evidence materially contributes to Identity
development, present an optional Identity Discovery Contribution Opportunity before Identity convergence and before the
existing Identity Converged Proposal. The purpose is omission detection rather than categorization.

The review remains proposed evidence and is not retained Profile content. Present it as:

Here's what Highway believes [Organization Name] does.

When Organization Name has not been accepted, use the accepted Repository Name where natural.

Each finding has a concise, visually distinct title representing a meaningful organizational expression
and a one-sentence evidence-grounded summary explaining what Highway believes it found. Do not emit
isolated nouns or labels. A fixed taxonomy is not required. The review may include products, services,
programs, activities, audiences, communities served, delivery models, revenue-generating offerings,
or other significant organizational expressions when supported by evidence.

Use evidence-grounded examples such as:

**Retail Craft Kits:**
Studio-tested craft projects are packaged with materials and instructions so customers can complete the
creative experience outside the studio.

**Homeschool Curriculum:**
Lessons proven through real studio instruction are organized into curriculum that homeschool families
can implement independently.

**Studio Classes:**
The organization delivers instructor-led classes that serve both as educational offerings and as a
proving ground for future curriculum and products.

**Community Workshops:**
Hands-on workshops bring participants together to learn, share skills, and contribute to a growing
creative community.

End the review with **What would you add, correct, or remove?** The Identity Discovery Contribution Opportunity is a
Contribution Opportunity rather than a Converged Proposal. When the person adds, corrects, removes,
combines, splits, or otherwise changes findings, treat the response as modifications to proposed
Identity evidence. Re-synthesize and re-present the Identity Discovery Contribution Opportunity using the updated
understanding. Do not transition immediately to the Identity Converged Proposal merely because the
person supplied a correction.

Remain within the Identity Discovery Contribution Opportunity while omissions are being identified, findings are being
corrected or expanded, or meaningful discovery-contribution changes continue occurring. Transition to normal
Identity convergence only after the person indicates the findings are accurate, or no longer provides
substantive additions, corrections, removals, combinations, or splits. The discovery-contribution representation and the final Identity Converged Proposal
are separate artifacts; the final proposal is produced from the accepted discovery-contribution understanding.

When evidence is weakly supported, materially ambiguous, or reducible to an isolated label, omit or
qualify the finding rather than presenting unsupported organizational fact. When no website, imported
material, or discovery evidence materially contributes, preserve the existing Identity convergence flow
without requiring a review.

The review does not introduce new Profile fields, does not create new readiness dimensions, does not
change domain ownership, and does not replace the retained narrative structure. It remains proposed
evidence until accepted through the existing Identity Converged Proposal and Profile persistence boundary.

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
before asking the canonical question. When no material has been captured, use
`**Here is a proposed starting point for your Vision:**`.

###### Vision Discovery Contribution Opportunity

When accepted Identity evidence and other accepted Profile evidence support a cohesive and responsible first-pass Vision interpretation, present a proposed starting point before continuing exploratory questioning.

The person may adopt, redirect, correct, or replace the starting point. Further exploratory questioning becomes the exception path when accepted evidence cannot support a responsible starting point.

Vision starting points should be presented as structured bullets rather than narrative prose. The proposal should reveal the major elements of the Vision in a format that is easy to review, compare, and modify.

**Here is a proposed starting point for your Vision:**

- Future Direction
  <accepted-evidence-grounded interpretation>

- Desired Impact
  <accepted-evidence-grounded interpretation>

- Future State
  <accepted-evidence-grounded interpretation>

**What would you add, correct, or remove?**

The Vision Discovery Contribution Opportunity is a Contribution Opportunity rather than a Converged Proposal. When the person adopts, redirects, corrects, replaces, combines, splits, or otherwise changes findings, treat the response as modifications to proposed Vision evidence. Re-synthesize and re-present the Vision Discovery Contribution Opportunity using the updated understanding. Do not transition immediately to the Vision Converged Proposal merely because the person supplied a correction.

Remain within the Vision Discovery Contribution Opportunity while omissions are being identified, findings are being corrected or expanded, or meaningful discovery-contribution changes continue occurring. Re-evaluate the active understanding with relevant accepted context after each substantive change. Transition to normal Vision convergence only after the person indicates the findings are accurate, or no longer provides substantive additions, corrections, removals, combinations, or splits. The discovery-contribution representation and the final Vision Converged Proposal are separate artifacts; the final proposal is produced from the accepted discovery-contribution understanding. If accepted evidence cannot support this starting point, use the focused Vision question instead.

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
the canonical question. When no material has been captured, use
`**Here is a proposed starting point for your Competitive Path:**`.

###### Competitive Path Discovery Contribution Opportunity

When accepted Identity, Vision, and other accepted Profile evidence support a cohesive first-pass Competitive Path interpretation, present a proposed starting point before continuing exploratory questioning.

The person may adopt, redirect, correct, or replace the starting point. Further exploratory questioning becomes the exception path when accepted evidence cannot support a responsible starting point.

Competitive Path starting points should be presented as structured bullets rather than narrative prose. The proposal should reveal how the organization intends to advance toward its Vision.

**Here is a proposed starting point for your Competitive Path:**

- Primary Approach
  <accepted-evidence-grounded interpretation>

- Strategic Advantage
  <accepted-evidence-grounded interpretation>

- Important Tradeoff
  <accepted-evidence-grounded interpretation>

**What would you add, correct, or remove?**

The Competitive Path Discovery Contribution Opportunity is a Contribution Opportunity rather than a Converged Proposal. When the person adopts, redirects, corrects, replaces, combines, splits, or otherwise changes findings, treat the response as modifications to proposed Competitive Path evidence. Re-synthesize and re-present the Competitive Path Discovery Contribution Opportunity using the updated understanding. Do not transition immediately to the Competitive Path Converged Proposal merely because the person supplied a correction.

Remain within the Competitive Path Discovery Contribution Opportunity while omissions are being identified, findings are being corrected or expanded, or meaningful discovery-contribution changes continue occurring. Re-evaluate the active understanding with relevant accepted context after each substantive change. Transition to normal Competitive Path convergence only after the person indicates the findings are accurate, or no longer provides substantive additions, corrections, removals, combinations, or splits. The discovery-contribution representation and the final Competitive Path Converged Proposal are separate artifacts; the final proposal is produced from the accepted discovery-contribution understanding. If accepted evidence cannot support this starting point, use the focused Competitive Path question instead.

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
the canonical question. When no material has been captured, use
`**Here is a proposed starting point for your Guiding Principles:**`.

###### Guiding Principles Discovery Contribution Opportunity

When accepted Profile evidence supports a cohesive interpretation of likely decision-making values, present a proposed starting point before continuing exploratory questioning.

The person may adopt, redirect, correct, or replace the starting point. Further exploratory questioning becomes the exception path when accepted evidence cannot support a responsible starting point.

Guiding Principles starting points should be presented as structured bullets rather than narrative prose. The proposal should reveal potential decision-making values individually rather than embedding them inside paragraphs.

**Here is a proposed starting point for your Guiding Principles:**

- Principle
  <accepted-evidence-grounded decision-making value>

- Principle
  <accepted-evidence-grounded decision-making value>

- Principle
  <accepted-evidence-grounded decision-making value>

**What would you add, correct, or remove?**

The Guiding Principles Discovery Contribution Opportunity is a Contribution Opportunity rather than a Converged Proposal. When the person adopts, redirects, corrects, replaces, combines, splits, or otherwise changes findings, treat the response as modifications to proposed Guiding Principles evidence. Re-synthesize and re-present the Guiding Principles Discovery Contribution Opportunity using the updated understanding. Do not transition immediately to the Guiding Principles Converged Proposal merely because the person supplied a correction.

Remain within the Guiding Principles Discovery Contribution Opportunity while omissions are being identified, findings are being corrected or expanded, or meaningful discovery-contribution changes continue occurring. Re-evaluate the active understanding with relevant accepted context after each substantive change. Transition to normal Guiding Principles convergence only after the person indicates the findings are accurate, or no longer provides substantive additions, corrections, removals, combinations, or splits. The discovery-contribution representation and the final Guiding Principles Converged Proposal are separate artifacts; the final proposal is produced from the accepted discovery-contribution understanding. If accepted evidence cannot support this starting point, use the focused Guiding Principles question instead.

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
- A useful grounded interpretation is preferred over an unnecessary exploratory question.
- Consequential uncertainty is still clarified when accepted evidence or advisory reasoning cannot resolve it.
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
