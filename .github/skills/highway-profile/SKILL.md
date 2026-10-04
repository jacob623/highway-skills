---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 6.0.0
---

# highway-profile

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
- User-supplied existing organizational material provided for Profile acquisition, including an organizational description, strategy material, or an export or summary from an existing assistant when the person chooses to provide one.
- A public organizational website supplied by the person when supported retrieval is available.

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

Profile uses the shared collaborative-development model from the Highway Experience Standard. A user contribution or Highway recommendation may begin as a Working Idea rather than a finished Profile domain. Apply X2.38-X2.40 to each Substantive Contribution before selecting the next Profile behavior: re-evaluate what the contribution changes in the active understanding, resolve consequential uncertainty through one focused Conversational Clarification when the person's information is required, and otherwise incorporate one responsible interpretation without a ceremonial question. Do not seek domain acceptance until the current understanding is complete enough to represent the domain as a Converged Proposal. A mature contribution or sufficiently grounded Highway synthesis may converge immediately; do not force additional discussion merely to demonstrate collaboration.

A Working Idea is transient Profile reasoning that may be interpreted, sharpened, extended, questioned, clarified, corrected, redirected, or abandoned. Each Substantive Contribution becomes new reasoning material for the active Working Idea and may also affect related unresolved Profile domains when the contribution supplies relevant evidence. A Converged Proposal is a complete candidate that answers the active domain's purpose coherently without unsupported facts. Agreement with a Working Idea does not establish a discussed Profile domain. Natural acceptance crosses the existing boundary only when the complete candidate has been presented as a Converged Proposal.

Profile consumes the shared Contribution Opportunity behavior in X2.37. When Profile has materially
shaped an incomplete Identity, Vision, Competitive Path, or Guiding Principles Working Idea, and no equivalent
opportunity has already occurred, present provisional substantive pieces and offer one Contribution
Opportunity before the Converged Proposal. The person may add, correct, remove, extend, or redirect
the developing substance. This opportunity is part of Working Idea development: it remains transient,
does not authorize persistence, and is not acceptance, provisional acceptance, or a readiness result.

Do not manufacture a Contribution Opportunity for a domain-complete contribution, a prior equivalent
opportunity, an explicitly finished substantive contribution, or a Profile-independent Converged
Proposal. A user-supplied domain-complete Identity that Profile does not materially reshape may proceed directly to its accuracy-oriented validation path. When Profile materially assembles Identity from website discovery, imported organizational material, multiple evidence sources, or substantial interpretation, apply the shared Contribution Opportunity unless an equivalent opportunity already occurred.
The opportunity is the only response-demanding question in its turn; do not combine it with domain
acceptance or another unresolved discovery question. A response such as "nothing else" completes the
substantive opportunity but does not accept the domain. Additions, corrections, removals, and
extensions return to the active Working Idea for re-evaluation.

## Acquisition

Acquisition follows the Highway Experience Standard contribution precedence: classify the retained Profile; establish Repository Name when missing; use supported existing organizational material or public-website acquisition when available; process acquired evidence across all unresolved Profile domains; reuse accepted evidence across all four domains; re-evaluate accumulated accepted evidence before each unresolved guided question; present a Converged Proposal when supported, otherwise contribute a useful Working Idea when supported, otherwise ask the focused canonical question; persist accepted evidence; report readiness.

When no retained Profile exists, begin first-time Setup with this one-time introduction:

### Let's get to know your organization

This helps Highway make more relevant recommendations as we go.

Then ask:

**What would you like to call your Highway repository?**

If you're using Highway for a company or organization, its name is usually a good choice.

Treat that answer as accepted Repository Name context and reuse it in the next prompt. After Repository Name is accepted, give the person one opportunity to reuse existing organizational material before ordinary domain questioning. An illustrative prompt is `**Do you already have something I can use to start understanding [Repository Name]?**` followed by `You can share a public website, an existing description or strategy document, or an export or summary from another assistant. You can also build the Profile with me.` That wording is illustrative, not required literal wording. The supplied Organization URL is accepted. A supplied Organization URL remains accepted optional Profile context. website-derived Organization Name and other derived facts stay proposed until accepted. Website-derived and imported organizational information stays proposed until accepted. When retrieval is unavailable, continue without exposing the missing retrieval capability. Do not require imported material to follow Profile's internal domains, retained schema, headings, or vocabulary.

User-supplied existing organizational material is reusable acquisition evidence, not automatically accepted Profile truth. Evidence in one acquisition source may support multiple unresolved Profile domains. Evaluate that evidence before determining what the person still needs to provide, and do not ask the person to reproduce information already present in supplied acquisition material. When multiple acquisition sources are available, consider them together before selecting the next Profile behavior. A website and user-supplied material may differ in breadth or emphasis. Neither source silently overrides the person's active input. Incorporate responsibly combinable evidence. When consequentially different interpretations require the person's information, use existing Conversational Clarification. Do not introduce source-precedence state or retained acquisition metadata. Do not treat unspecified model memory, prior-agent memory, or information the executing agent cannot identify in the active interaction as organizational evidence. Useful context from another assistant is usable only when the person supplies it in a form Profile can evaluate. Website and imported-source acquisition are limited to evidence relevant to the organizational Profile. Website acquisition is limited to evidence relevant to the organizational Profile. Do not perform technology-platform discovery from a supplied website, and do not turn an imported organizational description or assistant export into a technology-platform inventory.

Unresolved domains use one canonical question: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, use the accepted Repository Name where it reads naturally. Process each response, selected recommendation, or validated discovery across all four domains before choosing the next behavior. When the response is a Substantive Contribution, first re-evaluate what it changes, clarifies, introduces, qualifies, connects, or leaves unresolved in the active Profile understanding. Use one focused Conversational Clarification only when consequential uncertainty can change the active result and requires the person's information to resolve.

Lack of grounding for a complete Profile-domain proposal does not by itself justify asking the canonical question. Evaluate accepted evidence for a responsible domain-specific Working Idea before using that question as fallback; a focused question remains appropriate when the person's information is genuinely required.

## Enrichment

Optional enrichment may continue after a domain is `discussed` or `bounded`. User-visible interaction follows the Highway Experience Standard. Profile does not add a local acknowledgment stage, narrate persistence or readiness, or impose a local sentence, paragraph, or brevity pattern. After each Substantive Contribution, re-evaluate the active understanding before deciding whether to interpret, clarify, sharpen, connect, contribute, converge, or continue. A substantive response is new reasoning material rather than merely completion of the preceding Profile question. Interpret, sharpen, connect, and contribute when re-evaluation reveals something useful; transition naturally when it does not. Ask a Conversational Clarification only when the person's information is required to resolve consequential uncertainty that can change the active result. Interpretation, clarification reasoning, explanation, reflection, connections, and advisory commentary remain transient unless the person explicitly incorporates them into accepted Profile evidence.

Suitable acquisition sources may also provide organizational expression evidence, including characteristic terminology, recurring language, recognizable phrasing, degree of formality, and other communication patterns. Organizational expression influences representation, not organizational truth. Expression evidence remains transient synthesis guidance. It does not establish unsupported organizational facts, strategy, intentions, priorities, or principles. When suitable acquisition evidence consistently uses recognizable organizational terminology that accurately expresses supported meaning, use that terminology in Working Ideas and Converged Proposals. Do not imitate marketing language merely for stylistic similarity, preserve unsupported marketing claims, or sacrifice clarity for source mimicry. The person's active wording and corrections remain authoritative. Organizational expression guidance discovered during acquisition may remain available throughout the active Profile interaction for later domain proposals when it remains suitable. Profile-owned organizational expression guidance affects Profile synthesis only and does not automatically control Objectives, Controls, NFRs, or other Highway owners. Do not use tone, style, phrasing, terminology, or communication patterns as evidence that a substantive claim is true. Profile does not add retained tone, voice, persona, style, or expression fields to the Profile schema.

For Vision, Competitive Path, and Guiding Principles, Contribution Opportunity substance must be
provisional and meaningfully useful rather than a restatement of accepted evidence. Keep the
provisional pieces distinct from the later cohesive Converged Proposal, and do not repeat
substantially identical cohesive final-form domain prose twice. After the opportunity resolves,
synthesize the complete proposal once, then retain the existing separate domain acceptance question.
The opportunity response may improve the Working Idea, but it never replaces the Converged Proposal
review or the existing save-before-result persistence path.

Vision, Competitive Path, and Guiding Principles reason from relevant accumulated accepted Profile evidence. Completeness is a coherent answer to the active Profile domain, not coverage of an internal category framework. Optional enrichment does not change readiness by itself. Profile does not store a small-business, enterprise, maturity, persona, or advisory classification.

A Profile domain is ready to become a Converged Proposal when accumulated evidence supports one
coherent organizational narrative that meaningfully answers the domain's purpose without unsupported
facts. Do not prolong a domain solely because additional detail could theoretically be collected.
One cohesive organizational narrative that meaningfully answers the domain uses clear sentences and,
when useful, short paragraphs; it does not require one sentence or one paragraph.

The synthesized subject headings are:

- Vision: `### Where you're going`, followed by a natural future-direction introduction.
- Competitive Path: `### How you'll get there`, followed by a natural practical-direction introduction.
- Guiding Principles: `### What will guide your decisions`, followed by a natural decision-principles introduction.

When Profile moves from one accepted subject to the next unresolved subject, visibly open the new
subject with its heading before presenting that subject's Working Idea, Converged Proposal, or focused
question. Keep any useful contextual re-evaluation of the previously accepted subject distinguishable
from the new heading and its developing content. Headings and introductions are presentation only;
they do not create retained subject-transition state.

After accepted Profile knowledge is persisted, re-evaluate it together with the accumulated accepted
Profile before deciding what to contribute next. When re-evaluation reveals a useful distinction,
implication, relationship, tension, opportunity, concern, or recommendation, carry that stronger
understanding into the next Profile subject. When it reveals nothing useful to add, transition
naturally without manufacturing commentary. Related ideas remain in transient Active Reasoning
Context and stay anchored to the active subject until the relevant domain becomes active.

Contextual re-evaluation is user-visible only through its useful result. Do not describe accepted
Profile evidence as being established as context, loaded, retained, stored, available for the next
domain, or otherwise announce the internal state change. Express what the accepted information means
for the organization or for the subject now being developed.

- Vision opens with `### Where you're going` after any distinguishable contextual re-evaluation of the accepted subject. Vision asks what future the organization is trying to create. It evaluates the full accepted Identity and other relevant accepted Profile evidence using the shared contribution precedence before asking the Vision canonical question: present a Converged Proposal when supported, otherwise contribute a useful Vision Working Idea, otherwise ask `**What is the future vision of [Organization Name]?**`. When a Vision Working Idea already exists, ask only the one focused question about the unresolved information that can materially change the desired future; do not restart with the broad canonical question. When the Vision Working Idea has a coherent substantive shape and Profile materially shaped that substance, apply the shared Contribution Opportunity before convergence unless an equivalent opportunity or another shared exception already applies. After that opportunity resolves, synthesize the complete Vision once as the Converged Proposal and ask `**Does this accurately reflect where you'd like [Organization Name] to go?**` followed by `You can also change it or provide your own vision.`
- A Vision Working Idea may be a grounded future direction, distinction, implication, alternative, or recommendation that advances understanding of the future the organization wants to create; it remains transient until a complete Converged Proposal crosses the existing acceptance boundary. When a Vision Contribution Opportunity applies, present only the substantive future-direction pieces needed for the person to add to or correct that developing Vision before Profile synthesizes the cohesive final narrative. Do not expose internal enrichment-category names.
- When accepted Identity contains multiple meaningful organizational activities or expressions, Vision should consider how those parts affect the future being created. Do not let one prominent Identity facet become the entire Vision merely because it provides the easiest conversational continuation.

  A focused Vision question may explore that relationship only when it creates consequential uncertainty about the desired future and the person's information is required. The question should arise from accepted Identity evidence rather than from an internal category.

  When the responsible relationship is already supported by accepted evidence, incorporate it into the Working Idea without a clarification question.
- When accepted evidence supports materially distinct future directions, a Working Idea may present a small set of grounded alternatives and a grounded advisory preference, while keeping the user-authored path available and making clear that none is accepted organizational truth. Do not invent alternatives merely to create a choice or to cover an internal Vision dimension, and keep generic examples subordinate to the grounded future direction, distinction, alternative, or implication already under development.
- Competitive Path asks what broad approach the organization intends to take toward its accepted Vision. Re-evaluate accepted Identity, accepted Vision, and other relevant accepted Profile evidence before opening `### How you'll get there`; use newly visible implications rather than merely summarizing Vision. Apply the shared contribution precedence before asking `**How does [Organization Name] plan to get there?**`: present a Converged Proposal when supported, otherwise contribute a useful Working Idea, otherwise ask the canonical question. When a Competitive Path Working Idea already exists, ask only the one focused question about the unresolved information that can materially change that broad approach; do not restart with the broad canonical question. Competitive Path may develop broad strategic choices, sequencing, approaches, priorities, or organizational direction when those help explain intended progress. Do not ask about enforceable safeguards, Controls, NFRs, detailed implementation requirements, architecture, or implementation plans. If the person volunteers such downstream detail, Profile may use it as evidence of the broad Competitive Path, but it does not develop or retain that detail as a safeguard, NFR, architecture, or implementation requirement. Constraint, dependency, capability, concern, and tradeoff reasoning remains inside Competitive Path only when it changes interpretation of the broad organizational approach. When Profile materially shaped the resulting substantive path and no equivalent Contribution Opportunity or other shared exception already applies, present the developing broad approach provisionally and give the person the shared Contribution Opportunity before convergence. After incorporating any additions or corrections, synthesize the coherent Competitive Path once as the Converged Proposal and ask `**Does this accurately reflect how [Organization Name] plans to get there?**` followed by `You can also change it or provide your own approach.`

  When the accepted Identity and Vision establish multiple meaningful ways the organization creates value, reaches people, delivers experiences, develops offerings, or pursues its direction, Competitive Path should consider how those accepted pieces reinforce, sequence, constrain, or depend on one another when that relationship affects how the organization plans to progress.

  When the relationship is consequentially ambiguous and the person's information is required, use one focused Conversational Clarification. When one responsible interpretation is already supported, incorporate it directly.
- Guiding Principles asks which enduring principles should shape organizational decisions while pursuing the accepted direction. Guiding Principles uses accepted Identity, Vision, Competitive Path, and other accepted Profile context as grounding. After Competitive Path acceptance, re-evaluate the accumulated Profile for principles already becoming visible. During Guiding Principles development, treat each Substantive Contribution as new reasoning material and apply X2.38-X2.40 before selecting the next behavior. Open `### What will guide your decisions`, then apply the shared contribution precedence before asking `**What principles or values guide decisions at [Organization Name]?**`: present a Converged Proposal when supported, otherwise contribute a useful Working Idea, otherwise ask the canonical question. When a Guiding Principles Working Idea already exists, ask only the one focused question about the unresolved principle or decision priority that can materially change the principles being developed; do not restart with the broad canonical question. Do not turn a principle into an enforceable Control merely to make it more precise. Governance obligations remain owned by their downstream workflows. When the developing principles have a coherent substantive shape and Profile materially shaped that substance, apply the shared Contribution Opportunity before convergence unless an equivalent opportunity or another shared exception already applies. Present the emerging principles provisionally so the person can add, correct, remove, extend, or redirect what should guide decisions. After that opportunity resolves, synthesize the complete Guiding Principles once as the Converged Proposal and ask `**Does this accurately reflect what should guide decisions at [Organization Name]?**` followed by `You can also change it or provide your own principles.`

When a Guiding Principles Contribution Opportunity applies, a natural provisional shape may be:

A few principles are taking shape:

- [provisional principle or decision boundary]
- [provisional principle or decision boundary]
- [provisional principle or decision boundary]

`**Is there anything else that should guide [Organization Name]'s decisions before I pull these together?**`

`You can also change any of these or add something different.`

This is an illustrative interaction shape, not required wording. The provisional list remains a Working Idea. After the person's response, synthesize the resulting substance once into the cohesive Guiding Principles Converged Proposal.

For Vision, Competitive Path, and Guiding Principles, Contribution Opportunity wording remains generative. The domain-specific provisional substance should make the developing understanding easy to inspect and extend without prematurely presenting the cohesive final artifact.

Across Identity, Vision, Competitive Path, and Guiding Principles, a person's Substantive Contribution is not merely completion of the preceding question. Re-evaluate it against the active Working Idea and relevant accumulated Profile context before selecting the next contribution, clarification, question, Contribution Opportunity, or Converged Proposal.

Re-evaluation may reveal:

- a newly relevant organizational fact;
- a meaningful relationship between accepted or developing evidence;
- a distinction or qualification that changes the Working Idea;
- tension with earlier evidence;
- an assumption Profile was making;
- consequential uncertainty requiring the person's information;
- a stronger interpretation or recommendation;
- no useful change beyond direct incorporation.

Do not manufacture visible commentary for every item in this list. The user-visible response should express only what is useful to the active conversation.

When a response both accepts a displayed Converged Proposal and supplies new substantive information, preserve the normal acceptance behavior and also re-evaluate the new information under X2.38 before choosing the next Profile behavior. The newly supplied information does not silently rewrite the already accepted domain. When it materially changes that accepted domain, treat it as new Profile evidence and use the existing owner-controlled change path before representing the changed content as accepted Profile knowledge.

A Conversational Clarification is the one unresolved response-demanding question for that turn. Do not combine it with another discovery question, a Contribution Opportunity, or a domain acceptance question. After the clarification response, re-evaluate again before selecting the next behavior.

Do not treat every clarification response as satisfying Profile's Contribution Opportunity. A clarification response counts as an equivalent Contribution Opportunity only when the same interaction meaningfully gave the person room to add, correct, remove, extend, or redirect the broader developed substance. Resolving one ambiguity does not by itself mean the person had an opportunity to complete the whole developing domain.

New substantive evidence is evaluated for relevance across all unresolved Profile domains before Profile chooses the next behavior.

The intended shape is:

provisional substantive pieces

→ one invitation to add, correct, remove, extend, or redirect

→ person responds

→ re-evaluate the Working Idea

→ synthesize once

→ Converged Proposal

→ existing domain acceptance question

Do not present the Contribution Opportunity and domain acceptance question in the same turn.

Identity establishes the meaningful organizational picture that later Profile domains reason from. When website evidence, imported organizational material, other discovered evidence, or direct user input establishes multiple meaningful aspects of what the organization does, organize those aspects provisionally before final Identity synthesis when doing so helps the person inspect the breadth of Profile's understanding. Apply substantive-contribution re-evaluation and selective Conversational Clarification throughout Identity development. Before final Identity convergence, give the person a Contribution Opportunity when Profile materially assembled or interpreted the organizational picture and the person has not already had an equivalent opportunity. After that opportunity resolves, synthesize the cohesive Identity once and validate it with `**Is this an accurate description of your organization?**` followed by `You can also change it or provide your own description.`

Identity may converge immediately when the person directly supplies a domain-complete organizational description that Profile does not materially reshape. When Profile materially assembles Identity from website discovery, imported organizational material, multiple evidence sources, or substantial interpretation, first present the meaningful organizational facets provisionally when that gives the person a useful opportunity to identify something missing, incorrect, overstated, or incomplete. When evidence is incomplete, conflicting, ambiguous, qualified, or leaves a consequential relationship unresolved, apply X2.38-X2.40 before convergence: re-evaluate the changed understanding, ask one focused Conversational Clarification only when the person's information is required, and otherwise incorporate the responsible interpretation directly. After the Identity substance is complete, synthesize the cohesive Identity once and present `**Is this an accurate description of your organization?**` followed by `You can also change it or provide your own description.`

When an Identity Contribution Opportunity applies, prefer provisional substantive facets over a completed Identity narrative. Facets may describe meaningful parts of what the organization does, whom or what it serves, important forms of its offering or participation, and other organizational activities supported by available evidence. Do not create mandatory Identity categories or require a fixed number of facets.

A natural interaction may resemble:

From what I've found, a few parts of the organization stand out:

- [grounded organizational facet]
- [grounded organizational facet]
- [grounded organizational facet]

`**Is there another important part of [Organization Name] that belongs in this picture?**`

`You can also correct or change anything I've listed.`

This is an illustrative interaction shape, not required wording. The provisional facets remain a Working Idea. The person's response is a Substantive Contribution when it adds, corrects, removes, qualifies, or redirects organizational evidence, and Profile re-evaluates the resulting Identity before convergence.

Identity breadth concerns durable organizational activity and purpose, not the organization's technology estate. Do not use Identity completeness to inventory platforms, applications, hosting providers, implementation technologies, or other technology-landscape details.

Identity Contribution Opportunity and Identity Conversational Clarification serve different purposes.

- Contribution Opportunity asks whether Profile's developing organizational picture is missing an important part the person can add.
- Conversational Clarification resolves consequential uncertainty about the meaning or relationship of evidence that is already present.

For example, disclosure of another meaningful activity does not automatically require a clarification question. Re-evaluate what the disclosure changes first. Clarify only when materially different interpretations of that activity can change the Identity or later Profile reasoning and the person's information is required to distinguish them.

A synthesized recommendation may be a Working Idea or a Converged Proposal. Do not ask an
artifact-acceptance question around a Working Idea. A complete candidate contains only claims supported
by accepted organizational evidence. A natural affirmative accepts an explicitly presented Converged
Proposal without redundant confirmation; an explanation request, correction, or replacement remains
collaboration until the complete candidate is presented. When accepted Profile evidence supports neither a Converged Proposal nor a useful Working Idea, or the person's information is genuinely required, the applicable focused canonical question remains the fallback. A natural affirmative
accepts the displayed Converged Proposal without a second confirmation.

## Operations

An explicit user boundary may produce `bounded`; inability to find evidence may not. Persist writes only information the person supplied, selected, or accepted.

After a Converged Proposal or other accepted change is accepted and changes retained Profile state, immediately construct and perform the accepted Profile mutation before selecting any behavior that depends on that accepted domain. Do not advance from an accepted Profile domain as though its knowledge were retained until the applicable Profile mutation succeeds. After successful persistence, the accepted domain becomes available for contextual re-evaluation and subsequent Profile behavior. Recommendation selections, accepted discoveries, imported evidence, and accepted corrections use the same save-before-result path; conversational acceptance alone is not a successful mutation. Acceptance alone is not treated as successful Profile persistence. persist the retained Profile, and only then return dependent readiness or another owner result. Guided Profile completion requires the accepted mutations for every discussed or bounded domain represented in the retained Profile to have succeeded. Do not emit the guided completion synthesis or return a terminal Profile result while an accepted Profile mutation remains unperformed or failed. If the final domain is accepted, persist that mutation before emitting the completion synthesis. Retain only the accepted cohesive domain narrative or explicit accepted correction/replacement; acknowledgments, reflections, subject headings and introductions, unadopted advisory commentary, implications, tradeoffs, concerns, alternatives, explanatory commentary, and internal category names remain transient unless explicitly incorporated into accepted Profile evidence. Presentation headings and introductions remain transient. Do not restore post-write persistence verification. When guided setup or configure reaches completion, emit one concise synthesis before returning to Setup. Use the accepted organization name when available, summarize important accepted direction, and naturally connect the accepted Profile understanding to how it can inform later Highway guidance. The synthesis contains no machine status field, no implementation details, no new question, and does not use "Profile Complete", "Status: Complete", or "Next Action: None".

Operations remain setup, configure, readiness, view, show, describe, add, update, remove, and reset.

## Verification

- The retained record follows `.highway/library/templates/output/profile-record.md`.
- When Profile moves into unresolved Vision, the visible interaction opens the subject with `### Where you're going` before its Working Idea, Converged Proposal, or focused question.
- When Profile moves into unresolved Competitive Path, the visible interaction opens the subject with `### How you'll get there` before its Working Idea, Converged Proposal, or focused question.
- When Profile moves into unresolved Guiding Principles, the visible interaction opens the subject with `### What will guide your decisions` before its Working Idea, Converged Proposal, or focused question.
- When a useful Working Idea exists, any question requests only the unresolved information needed to develop that Working Idea rather than restarting the domain with its broad canonical question.
- A Working Idea gives the person something concrete to react to; it is not merely a restatement of accepted evidence or a preface to the broad canonical question.
- When Profile has materially shaped an Identity, Vision, Competitive Path, or Guiding Principles Working Idea, it offers one substantive Contribution Opportunity before the Converged Proposal unless an equivalent opportunity or another shared exception applies.
- A Contribution Opportunity permits the person to add, correct, remove, extend, or redirect provisional substance; it remains transient and does not authorize persistence.
- A response of "nothing else" completes substantive contribution without accepting the Profile domain; additions, corrections, removals, and extensions return to the active Working Idea for re-evaluation.
- A domain-complete contribution, prior equivalent opportunity, or explicitly finished substantive contribution may skip a distinct Contribution Opportunity.
- Contribution Opportunity substance is kept distinct from the cohesive Converged Proposal, so Profile does not repeat substantially identical cohesive final-form domain prose twice.
- The Contribution Opportunity is the only response-demanding question in its turn and remains separate from domain acceptance and other unresolved discovery questions.
- A user-supplied domain-complete Identity may proceed directly to the existing Identity accuracy validation when Profile does not materially reshape its substance.
- When Profile materially assembles Identity from website discovery, imported organizational material, multiple evidence sources, or substantial interpretation, the person receives a provisional opportunity to identify another important organizational facet unless an equivalent Contribution Opportunity already occurred.
- Identity provisional facets remain Working Idea content; the cohesive Identity narrative is synthesized once afterward for the existing accuracy validation.
- Identity breadth captures durable organizational activity and purpose without becoming a technology-platform inventory.
- When Profile presents multiple Working Idea directions, each direction is grounded in accepted Profile evidence, meaningfully distinct, and remains transient until incorporated into an accepted Converged Proposal.
- Profile may state a grounded advisory preference among presented Working Idea directions when accepted evidence supports that perspective.
- User-visible contextual re-evaluation expresses what accepted information means rather than announcing that information has been established, retained, persisted, loaded, stored, or made available as workflow context.
- Readiness uses the four readiness domains.
- Highway Role is outside Profile.
- Repository Name, Organization Name, Organization URL, and optional enrichment do not affect readiness; Organization URL remains accepted optional Profile context.
- First-time `setup` with no retained Profile emits `### Let's get to know your organization` before the Repository Name question.
- The first-time introduction is not emitted for `configure` or when a retained Profile already exists.
- Only user-provided or user-accepted organizational evidence is retained.
- Website-derived organizational information stays proposed until accepted.
- Website-derived and imported organizational information stays proposed until accepted.
- Initial acquisition can reuse a public website or user-supplied existing organizational material.
- Imported organizational material is evaluated across unresolved Profile domains rather than being accepted wholesale.
- Organizational expression guidance remains transient and is not retained as tone, voice, persona, style, or terminology.
- Website acquisition is limited to evidence relevant to the organizational Profile.
- Profile does not perform technology-platform discovery from the supplied website.
- Each accepted Profile-domain mutation succeeds before Profile uses that domain as persisted accepted knowledge.
- Acceptance alone is not treated as successful Profile persistence.
- The final accepted Profile-domain mutation succeeds before the guided completion synthesis and before control returns to Setup.
- Canonical questions are limited to unresolved domains.
- Before each unresolved canonical question, accepted evidence is evaluated in the shared contribution order: present a Converged Proposal when supported; otherwise contribute a useful Working Idea when supported; otherwise ask the focused canonical question.
- Lack of grounding for a complete Profile-domain proposal does not by itself justify asking the canonical question; Profile evaluates for a responsible Working Idea first.
- Accepted evidence prevents a repeated question.
- Vision may develop through a Working Idea; when Profile materially shaped the substantive Vision and no shared exception applies, the Contribution Opportunity precedes the one cohesive Converged Proposal.
- After accepted Identity changes the understanding used by Vision, Vision evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question.
- Competitive Path may develop through a Working Idea; when Profile materially shaped the substantive path and no shared exception applies, the Contribution Opportunity precedes the one cohesive Converged Proposal.
- After accepted Vision changes the understanding used by Competitive Path, Competitive Path evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question.
- Guiding Principles may develop through a Working Idea; when Profile materially shaped the substantive principles and no shared exception applies, the Contribution Opportunity precedes the one cohesive Converged Proposal.
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
- Completeness is a coherent answer to the active Profile domain, not coverage of an internal category framework.
- Competitive Path completeness does not depend on internal Operations, Capability Development, Market, Differentiation, or similar categories.
- Guiding Principles are not converted into enforceable Controls.
- A failed accepted Profile mutation blocks a Setup-advancing terminal result.
- Identity retains its accuracy-oriented validation wording.
- Vision retains its accuracy-oriented validation wording.
- Competitive Path retains its accuracy-oriented validation wording.
- Guiding Principles retains its accuracy-oriented validation wording.
- The validation question remains the single response-demanding decision in the recommendation turn.
- A synthesized Converged Proposal contains only claims supported by accepted organizational evidence.
- Internal category names are not presented to the user or persisted.
- When accepted evidence cannot support a responsible Working Idea or Converged Proposal, or the person's information is genuinely required, the applicable focused canonical question remains the fallback.
- Acceptance of a Converged Proposal establishes the applicable unresolved domain as discussed.
- A domain established as discussed by accepted Converged Proposal evidence does not receive its canonical question afterward.
- Accepting optional enrichment for an already `discussed` or `bounded` domain does not change readiness.
- Guided completion emits one concise user-relevant synthesis before control returns to Setup.
- Material interpretation follows the Highway Experience Standard.
- Profile ownership and readiness stay with Profile.
- After each Substantive Contribution, Profile re-evaluates what changed in the active understanding before selecting its next user-relevant behavior.
- Re-evaluation considers the active Working Idea together with relevant accepted and developing Profile evidence rather than treating the person's response merely as completion of the preceding question.
- A clear Substantive Contribution is incorporated without a ceremonial clarification question when one responsible interpretation is already supported.
- When re-evaluation reveals consequential ambiguity, an unresolved assumption, contradiction, missing organizational fact, unclear relationship, or materially different interpretation that can change the active result and requires the person's information, Profile asks one focused Conversational Clarification before advancing past that uncertainty.
- Profile does not ask a Conversational Clarification merely to demonstrate that it noticed new information.
- Profile does not create a clarification record or invoke highway-clarify for Conversational Clarification unless that separate capability is explicitly requested through its own supported contract. Conversational Clarification remains transient.
- New substantive evidence is evaluated for relevance across all unresolved Profile domains before Profile chooses the next behavior.
- Vision reasons from the full accepted Identity rather than selecting one Identity facet merely because it provides the easiest continuation.
- When multiple accepted Identity facets create a consequential unresolved relationship for future direction, Vision may explore that relationship through a focused question.
- Competitive Path reasons over accepted Identity, Vision, and useful relationships among them when those relationships affect how the organization plans to progress.

## Error Handling

- An unsupported schema, including schema 2.0.0, is Blocked and is not mutated.
- An obsolete YAML Profile is ignored and is never a fallback or a migration input.
- A malformed retained Profile is Blocked and is not mutated.
- An accepted Profile mutation that fails does not establish the affected domain as successfully persisted and does not permit Profile to return a dependent terminal result. Stop before dependent progression and report actionable user-facing failure context under the existing common failure model. Do not add a post-write read-back or verification stage.

## Example

`/highway-profile readiness`
