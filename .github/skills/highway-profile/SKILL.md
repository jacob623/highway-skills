---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 5.1.0
---

## highway-profile

## Purpose

Collects organizational evidence and persists accepted context in the Markdown Profile.

## Scope

The Profile tracks four readiness domains: identity, vision, competitive path, and guiding principles.

## When to use

Use `setup` or `configure` to collect evidence, `readiness` to assess the persisted Profile, `view`,
`show`, or `describe` to inspect it, and `add`, `update`, `remove`, or `reset` for explicit changes.

## When not to use

Do not create Controls, NFRs, Objectives, governance rules, or Highway identity. Do not use an
obsolete YAML artifact as a source, fallback, authority, migration input, or mutation target.

## Inputs

- Project root containing `.highway/`.
- The authoritative Profile at `.highway/library/knowledge/profile.md`, when present.
- The shared structural template at `.highway/library/templates/output/profile-record.md`.
- `.highway/library/knowledge/highway-identity.md` for behavioral guidance when available.
- `.highway/library/knowledge/highway-vision.md` for strategic direction when available.
- `.highway/library/knowledge/highway-platform-objectives.md` for evaluation criteria when available.
- `.highway/governance/experience-standard.md` as the authoritative interaction contract.
- A user request and proposal evidence for the active interaction.

## Outputs

The retained artifact is `.highway/library/knowledge/profile.md`. Its complete reusable structure is
owned by `.highway/library/templates/output/profile-record.md`; this skill cites that file and does not
repeat its complete skeleton.

Profile readiness is an internal result containing `Status:`, `Summary:`, `Next Action:`, and
`Blocking Reason:` fields. These fields are not a normal user-facing output template.
An absent Profile is a valid initial state. Readiness classifies the retained artifact in this order: an absent Profile is `Missing` with
`Next Action: /highway-profile setup`; a present Profile with missing, malformed, contradictory, or
unsupported schema structure, including schema 2.0.0, is `Blocked` with `Next Action: None` and is left unchanged; a valid incomplete Profile with
any `not_discussed` domain is `Missing` with `Next Action: /highway-profile configure`; and a valid
Profile with all four outcomes `discussed` or `bounded` is `Complete` with `Next Action: None`.
Optional context and optional enrichment do not change readiness. Orchestrated conversation does not
render these machine fields; a direct readiness request may show the requested result.

## Profile model

The four readiness domains are `identity`, `vision`, `competitive_path`, and `guiding_principles`. Each persists exactly one of `not_discussed`, `discussed`, or `bounded`. `not_discussed` has no narrative; `discussed` has one; `bounded` has one only when accepted evidence exists. A new record uses `schema_version: 3.0.0`. Content mutations do not change that schema version. Schema 2.0.0 is Blocked and left unchanged.

The optional Context structure is owned by .highway/library/templates/output/profile-record.md. Optional context does not change readiness. Profile owns its evidence, artifact, domain state, and readiness. Accepted evidence that establishes a domain sets it to `discussed`; an explicit user boundary sets an otherwise unresolved domain to `bounded`. A domain is not asked its canonical question when accepted evidence establishes that domain or an explicit user boundary makes it bounded. Proposal evidence stays transient until accepted. Foundational Highway context may show what evidence is useful, and it must not be promoted into the retained Profile. Workflow-specific input remains authoritative.

Profile uses the shared collaborative-development model from the Highway Experience Standard. A user
contribution or Highway recommendation may begin as a Working Idea rather than a finished Profile
domain. Do not seek domain acceptance until the current understanding is complete enough to represent
the domain as a Converged Proposal. A mature contribution or sufficiently grounded Highway synthesis
may converge immediately; do not force additional discussion merely to demonstrate collaboration.

A Working Idea is transient Profile reasoning that may be interpreted, sharpened, extended, questioned,
corrected, redirected, or abandoned. A Converged Proposal is a complete candidate that answers the
active domain's purpose coherently without unsupported facts. Agreement with a Working Idea does not
establish a discussed Profile domain. Natural acceptance crosses the existing boundary only when the
complete candidate has been presented as a Converged Proposal.

## Acquisition

Acquisition follows the Highway Experience Standard contribution precedence: classify the retained Profile; establish Repository Name when missing; use supported existing-information or website acquisition when available; reuse accepted or accepted-discovered evidence across all four domains; re-evaluate accumulated accepted evidence across all four domains before each unresolved guided question; present a Converged Proposal when supported, otherwise contribute a useful Working Idea when supported, otherwise ask the focused canonical question; persist accepted evidence; report readiness.

When no retained Profile exists, begin first-time Setup with this one-time introduction:

### Let's get to know your organization

This helps Highway make more relevant recommendations as we go.

Then ask:

**What would you like to call your Highway repository?**

If you're using Highway for a company or organization, its name is usually a good choice.

Treat that answer as accepted Repository Name context and reuse it in the next prompt. When supported public-website retrieval is available, ask for the public website using the accepted Repository Name before ordinary domain questioning. Website acquisition is limited to organizational Profile evidence; technology-platform discovery is outside Profile scope. The supplied Organization URL is accepted. website-derived Organization Name and other derived facts stay proposed until accepted. When retrieval is unavailable, continue without exposing the missing retrieval capability.

Unresolved domains use one canonical question: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, use the accepted Repository Name where it reads naturally. Process each response, selected recommendation, or validated discovery across all four domains before choosing the next question.

Lack of grounding for a complete Profile-domain proposal does not by itself justify asking the canonical question. Evaluate accepted evidence for a responsible domain-specific Working Idea before using that question as fallback; a focused question remains appropriate when the person's information is genuinely required.

## Enrichment

Optional enrichment may continue after a domain is `discussed` or `bounded`. User-visible interaction
follows the Highway Experience Standard. Profile does not add a local acknowledgment stage, narrate
persistence or readiness, or impose a local sentence, paragraph, or brevity pattern. Interpret,
sharpen, connect, and contribute when contextual re-evaluation reveals something useful; transition
naturally when it does not. Interpretation, explanation, reflection, connections, and advisory
commentary remain transient unless the person explicitly incorporates them into accepted Profile
evidence.

Vision uses accepted Identity, accepted website-derived organizational evidence, existing accepted
Vision evidence, and other accepted Profile context as grounding across Future State, Impact,
Reach / Scale, Position, and Experience / Reputation. Competitive Path uses accepted Vision and the
accumulated accepted Profile as grounding across Customer / Participant, Offering, Market / Reach,
Differentiation, Operations, and Capability Development. Guiding Principles uses accepted Identity,
Vision, Competitive Path, and the accumulated accepted Profile as grounding across People, Trust,
Quality, Simplicity, Change, Stewardship, and Autonomy. These categories remain reasoning aids:
coverage of every category is not required, category names are neither presented nor retained, and
they do not dictate conversational order. Optional enrichment does not change readiness by itself.
Profile does not store a small-business, enterprise, maturity, persona, or advisory classification.

A Profile domain is ready to become a Converged Proposal when accumulated evidence supports one
coherent organizational narrative that meaningfully answers the domain's purpose without unsupported
facts. Do not prolong a domain solely because additional detail could theoretically be collected.
One cohesive organizational narrative that meaningfully answers the domain uses clear sentences and,
when useful, short paragraphs; it does not require one sentence or one paragraph.

The synthesized subject headings are:

- Vision: `### Where you're going`, followed by a natural future-direction introduction.
- Competitive Path: `### How you'll get there`, followed by a natural practical-direction introduction.
- Guiding Principles: `### What will guide your decisions`, followed by a natural decision-principles introduction.

After accepted Profile knowledge is persisted, re-evaluate it together with the accumulated accepted
Profile before deciding what to contribute next. When re-evaluation reveals a useful distinction,
implication, relationship, tension, opportunity, concern, or recommendation, carry that stronger
understanding into the next Profile subject. When it reveals nothing useful to add, transition
naturally without manufacturing commentary. Related ideas remain in transient Active Reasoning
Context and stay anchored to the active subject until the relevant domain becomes active.

- Identity validation: `**Is this an accurate description of your organization?**` followed by `You can also change it or provide your own description.`
- Vision evaluates accepted Identity, accepted website-derived organizational evidence, existing accepted Vision evidence, and other accepted Profile context using the shared contribution precedence before asking the Vision canonical question: present a Converged Proposal when supported, otherwise contribute a useful Vision Working Idea, otherwise ask `**What is the future vision of [Organization Name]?**`. Once coherent enough to represent where the organization intends to go, ask `**Does this accurately reflect where you'd like [Organization Name] to go?**` followed by `You can also change it or provide your own vision.`
- A Vision Working Idea may be a grounded direction, distinction, implication, alternative, or recommendation that materially advances the Vision without completing it; it remains transient until a complete Converged Proposal crosses the existing acceptance boundary.
- Competitive Path begins from accepted Vision or sufficient accepted evidence. Re-evaluate Identity, Vision, and other accepted Profile context before opening `### How you'll get there`; use newly visible implications rather than merely summarizing Vision. Apply the shared contribution precedence before asking `**How does [Organization Name] plan to get there?**`: present a Converged Proposal when supported, otherwise contribute a useful Working Idea, otherwise ask the canonical question. Develop a Working Idea when useful choices, tensions, opportunities, or implications remain, then present the coherent Converged Proposal and ask `**Does this accurately reflect how [Organization Name] plans to get there?**` followed by `You can also change it or provide your own approach.`
- Guiding Principles uses accepted Identity, Vision, Competitive Path, and other accepted Profile context as grounding. After Competitive Path acceptance, re-evaluate the accumulated Profile, sharpen principles already implicit in the accepted direction, and apply the shared contribution precedence before asking `**What principles or values guide decisions at [Organization Name]?**`: present a Converged Proposal when supported, otherwise contribute a useful Working Idea, otherwise ask the canonical question. Present the complete recommendation as a Converged Proposal before asking `**Does this accurately reflect what should guide decisions at [Organization Name]?**` followed by `You can also change it or provide your own principles.`

Identity may converge immediately when website or user evidence provides a complete organizational
description. When evidence is incomplete, conflicting, vague, or would benefit from interpretation,
keep it as a Working Idea and combine evidence, surface ambiguity, allow correction, or ask one bounded
question when genuinely needed before presenting `**Is this an accurate description of your organization?**`
and `You can also change it or provide your own description.`

A synthesized recommendation may be a Working Idea or a Converged Proposal. Do not ask an
artifact-acceptance question around a Working Idea. A complete candidate contains only claims supported
by accepted organizational evidence. A natural affirmative accepts an explicitly presented Converged
Proposal without redundant confirmation; an explanation request, correction, or replacement remains
collaboration until the complete candidate is presented. When accepted Profile evidence supports neither a Converged Proposal nor a useful Working Idea, or the person's information is genuinely required, the applicable focused canonical question remains the fallback. A natural affirmative
accepts the displayed Converged Proposal without a second confirmation.

## Operations

An explicit user boundary may produce `bounded`; inability to find evidence may not. Persist writes only information the person supplied, selected, or accepted.

After accepted evidence changes retained Profile state, construct the accepted mutation, persist the retained Profile, and only then return dependent readiness or another owner result. Recommendation selections and accepted discoveries use the same save-before-result path; conversational acceptance alone is not a successful mutation. Retain only the accepted cohesive domain narrative or explicit accepted correction/replacement; acknowledgments, reflections, subject headings and introductions, unadopted advisory commentary, implications, tradeoffs, concerns, alternatives, explanatory commentary, and internal category names remain transient unless explicitly incorporated into accepted Profile evidence. Presentation headings and introductions remain transient. Do not restore post-write persistence verification. When guided setup or configure reaches completion, emit one concise synthesis before returning to Setup. Use the accepted organization name when available, summarize important accepted direction, and naturally connect the accepted Profile understanding to how it can inform later Highway guidance. The synthesis contains no machine status field, no implementation details, no new question, and does not use "Profile Complete", "Status: Complete", or "Next Action: None".

Operations remain setup, configure, readiness, view, show, describe, add, update, remove, and reset.

## Verification

- The retained record follows `.highway/library/templates/output/profile-record.md`.
- Readiness uses the four readiness domains.
- Highway Role is outside Profile.
- Repository Name, Organization Name, Organization URL, and optional enrichment do not affect readiness; Organization URL remains accepted optional Profile context.
- First-time `setup` with no retained Profile emits `### Let's get to know your organization` before the Repository Name question.
- The first-time introduction is not emitted for `configure` or when a retained Profile already exists.
- Only user-provided or user-accepted organizational evidence is retained.
- Website-derived organizational information stays proposed until accepted.
- Website acquisition is limited to evidence relevant to the organizational Profile.
- Profile does not perform technology-platform discovery from the supplied website.
- Canonical questions are limited to unresolved domains.
- Before each unresolved canonical question, accepted evidence is evaluated in the shared contribution order: present a Converged Proposal when supported; otherwise contribute a useful Working Idea when supported; otherwise ask the focused canonical question.
- Lack of grounding for a complete Profile-domain proposal does not by itself justify asking the canonical question; Profile evaluates for a responsible Working Idea first.
- Accepted evidence prevents a repeated question.
- Accepted evidence is persisted before dependent readiness or owner results.
- Vision may develop through a Working Idea and presents one cohesive Converged Proposal when accepted evidence supports a grounded Vision synthesis.
- After accepted Identity changes the understanding used by Vision, Vision evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question.
- Competitive Path may develop through a Working Idea and presents one cohesive Converged Proposal when accepted evidence supports a grounded Competitive Path synthesis.
- After accepted Vision changes the understanding used by Competitive Path, Competitive Path evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question.
- Guiding Principles may develop through a Working Idea and presents one cohesive Converged Proposal when accepted evidence supports a grounded Guiding Principles synthesis.
- After accepted Competitive Path changes the understanding used by Guiding Principles, Guiding Principles evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question.
- After accepted Profile knowledge changes the active understanding, subsequent Profile behavior uses that knowledge with relevant accumulated Profile context before advancing.
- Interpretation, explanation, subject introductions, and Profile-specific advisory commentary remain transient unless explicitly incorporated into accepted Profile evidence; advisory commentary remains grounded in accepted evidence.
- A Working Idea remains transient and does not establish the applicable Profile domain as discussed.
- Agreement with a Working Idea does not trigger Profile persistence or establish the applicable domain as discussed.
- A mature contribution may converge directly into a Converged Proposal without unnecessary exploratory turns.
- A partial, vague, or developing contribution may remain a Working Idea while interpretation, sharpening, or additional user evidence materially improves it.
- Relevant Working Ideas may remain in transient Active Reasoning Context while the active Profile task continues.
- Related Working Ideas remain anchored to the active Profile subject and do not create retained Profile evidence unless incorporated into an accepted Converged Proposal.
- After domain acceptance, Profile re-evaluates the newly accepted knowledge with relevant accumulated Profile context before determining the next contribution.
- Contextual re-evaluation may produce interpretation, sharpening, a useful connection, or advisory contribution without making that contribution accepted Profile evidence.
- When contextual re-evaluation reveals nothing useful to add, Profile may transition naturally without manufacturing commentary.
- Artifact-level validation is presented only for a Converged Proposal, not for a Working Idea.
- A cohesive Profile recommendation may use multiple sentences or short paragraphs when that improves readability.
- Profile does not compress several meaningful ideas into one sentence merely to minimize response length.
- A synthesized recommendation may include grounded advisory contribution when accepted evidence supports it.
- Synthesized recommendation prose is generated naturally from accepted evidence rather than from a required recommendation sentence template.
- Profile does not impose a local brevity requirement that conflicts with shared Conversational Presence guidance.
- Identity retains its accuracy-oriented validation wording.
- Vision retains its accuracy-oriented validation wording.
- Competitive Path retains its accuracy-oriented validation wording.
- Guiding Principles retains its accuracy-oriented validation wording.
- The validation question remains the single response-demanding decision in the recommendation turn.
- A synthesized Converged Proposal contains only claims supported by accepted organizational evidence.
- Internal enrichment-category names are neither presented to the user nor persisted.
- When accepted evidence cannot support a responsible Working Idea or Converged Proposal, or the person's information is genuinely required, the applicable focused canonical question remains the fallback.
- Acceptance of a Converged Proposal establishes the applicable unresolved domain as discussed.
- A domain established as discussed by accepted Converged Proposal evidence does not receive its canonical question afterward.
- Accepting optional enrichment for an already `discussed` or `bounded` domain does not change readiness.
- Guided completion emits one concise user-relevant synthesis before control returns to Setup.
- Material interpretation follows the Highway Experience Standard.
- Profile ownership and readiness stay with Profile.

## Error Handling

- An unsupported schema, including schema 2.0.0, is Blocked and is not mutated.
- An obsolete YAML Profile is ignored and is never a fallback or a migration input.
- A malformed retained Profile is Blocked and is not mutated.

## Example

`/highway-profile readiness`
