---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 7.0.0
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
repeat its complete skeleton. The optional Context structure is owned by .highway/library/templates/output/profile-record.md.

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

The retained Profile follows the complete structure in .highway/library/templates/output/profile-record.md. Profile owns the meaning, evidence, state, and readiness of Identity, Vision, Competitive Path, and Guiding Principles. Accepted evidence that establishes a domain sets it to `discussed`; an explicit user boundary may set an otherwise unresolved domain to `bounded`. Optional Context does not change readiness. Schema 2.0.0 is Blocked and left unchanged.

Content mutations do not change the Profile schema version. A domain becomes bounded only when the person explicitly indicates that they do not want to establish further Profile evidence for that domain. Missing evidence, uncertainty, inability to discover evidence, or "I don't know" alone does not establish bounded. A domain is not asked its canonical question when accepted evidence establishes that domain or an explicit user boundary makes it bounded. Proposal evidence stays transient until accepted. Foundational Highway context may show what evidence is useful, but it is not retained as organizational fact. Workflow-specific input remains authoritative.

Profile uses the collaborative-development model defined by the Highway Experience Standard. Working Ideas, Substantive Contributions, Conversational Clarification, Contribution Opportunities, Converged Proposals, and their interaction boundaries follow that shared contract. Profile defines what constitutes a complete candidate for each Profile domain and the Profile-specific evidence, readiness, persistence, and downstream ownership boundaries below.

When Profile has materially shaped an Identity, Vision, Competitive Path, or Guiding Principles Working Idea, apply the shared X2.37 Contribution Opportunity unless an equivalent opportunity already occurred. A user-supplied domain-complete Identity that Profile does not materially reshape may proceed directly to its accuracy-oriented validation path. When Profile materially assembles Identity from website discovery, imported organizational material, multiple evidence sources, or substantial interpretation, apply the shared Contribution Opportunity unless an equivalent opportunity already occurred.

## Acquisition

Acquisition follows the Highway Experience Standard contribution precedence: classify the retained Profile; establish Repository Name when missing; use supported existing organizational material or public-website acquisition when available; process acquired evidence across all unresolved Profile domains; reuse accepted evidence across all four domains; re-evaluate accumulated accepted evidence before each unresolved guided question; present a Converged Proposal when supported, otherwise contribute a useful Working Idea when supported, otherwise ask the focused canonical question; persist accepted evidence; report readiness.

When no retained Profile exists, begin first-time Setup with this one-time introduction:

### Let's get to know your organization

This helps Highway make more relevant recommendations as we go.

Then ask:

**What would you like to call your Highway repository?**

If you're using Highway for a company or organization, its name is usually a good choice.

Treat that answer as accepted Repository Name context and reuse it in the next prompt. A Repository Name supplied directly in response to this request is accepted as supplied and does not require a separate proposal review. This direct Context capture does not accept Organization Name or other organizational facts by implication. After Repository Name is accepted, give the person one opportunity to reuse existing organizational material before ordinary domain questioning. An illustrative prompt is `**Do you already have something I can use to start understanding [Repository Name]?**` followed by `You can share a public website, an existing description or strategy document, or an export or summary from another assistant. You can also build the Profile with me.` That wording is illustrative, not required literal wording. The supplied Organization URL is accepted optional Profile context. Supplying a URL does not accept organizational facts derived from that website. website-derived Organization Name and other derived facts stay proposed until accepted. Website-derived and imported organizational information remains proposed until the applicable Profile acceptance boundary is crossed. When retrieval is unavailable, continue without exposing the missing retrieval capability. Do not require imported material to follow Profile's internal domains, retained schema, headings, or vocabulary. Do not automatically treat Repository Name as Organization Name, and do not invent Organization Name from Repository Name.

User-supplied existing organizational material is reusable acquisition evidence, not automatically accepted Profile truth. Evidence in one acquisition source may support multiple unresolved Profile domains. Evaluate that evidence before determining what the person still needs to provide, and do not ask the person to reproduce information already present in supplied acquisition material. When multiple acquisition sources are available, consider them together before selecting the next Profile behavior. A website and user-supplied material may differ in breadth or emphasis. Neither source silently overrides the person's active input. Once substantive organizational evidence is accepted, later reasoning does not assign different authority solely because it came from a website, imported material, or direct conversation. Do not introduce source-precedence state or retained acquisition metadata. Do not treat unspecified model memory, prior-agent memory, or information the executing agent cannot identify in the active interaction as organizational evidence. Useful context from another assistant is usable only when the person supplies it in a form Profile can evaluate. Website and imported-source acquisition are limited to evidence relevant to the organizational Profile. Do not perform technology-platform discovery from a supplied website, and do not turn an imported organizational description or assistant export into a technology-platform inventory. Acquisition-source availability does not affect readiness. When no reusable material is supplied, continue conversational Profile development.

Unresolved domains use one canonical question: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, use the accepted Repository Name where it reads naturally. Evaluate acquired, direct, and newly supplied substantive organizational evidence across all unresolved Profile domains before selecting the next Profile behavior. Lack of grounding for a complete Profile-domain proposal does not by itself justify asking the canonical question. When accepted Profile evidence supports neither a Converged Proposal nor a useful Working Idea, or the person's information is genuinely required, the applicable focused canonical question remains the fallback.

## Enrichment

Optional enrichment may continue after a domain is discussed or bounded. Optional enrichment does not change readiness by itself. User-visible collaborative behavior follows the Highway Experience Standard. Profile-specific enrichment remains transient unless the person incorporates it into accepted Profile evidence.

Suitable acquisition sources may also provide organizational expression evidence, including characteristic terminology, recurring language, recognizable phrasing, degree of formality, and other communication patterns. Organizational expression influences representation, not organizational truth. Expression evidence remains transient synthesis guidance. It does not establish unsupported organizational facts, strategy, intentions, priorities, or principles. When suitable acquisition evidence consistently uses recognizable organizational terminology that accurately expresses supported meaning, use that terminology in Working Ideas and Converged Proposals. Do not imitate marketing language merely for stylistic similarity, preserve unsupported marketing claims, or sacrifice clarity for source mimicry. The person's active wording and corrections remain authoritative. Organizational expression guidance discovered during acquisition may remain available throughout the active Profile interaction for later domain proposals when it remains suitable. Profile-owned organizational expression guidance affects Profile synthesis only and does not automatically control Objectives, Controls, NFRs, or other Highway owners. Do not use tone, style, phrasing, terminology, or communication patterns as evidence that a substantive organizational claim is true. Profile does not add retained tone, voice, persona, style, or expression fields to the Profile schema. Do not persist transient organizational-expression guidance under retained Organizational Context.

Profile does not store a small-business, enterprise, maturity, persona, or advisory classification. Profile does not add a local acknowledgment stage, narrate persistence or readiness, or impose a local sentence, paragraph, or brevity pattern. Profile does not impose a local brevity requirement that conflicts with shared Conversational Presence guidance. One cohesive organizational narrative that meaningfully answers the domain uses clear sentences and, when useful, short paragraphs. Synthesized recommendation prose is generated naturally from accepted evidence rather than from a required recommendation sentence template. Interpretation, clarification reasoning, explanation, reflection, connections, and advisory commentary remain transient unless the person explicitly incorporates them into accepted Profile evidence.

A Profile domain is ready to become a Converged Proposal when accumulated evidence supports one coherent organizational narrative that meaningfully answers the domain's purpose without unsupported facts. Completeness is a coherent answer to the active Profile domain, not coverage of an internal category framework. Do not prolong a domain solely because additional detail could theoretically be collected.

The synthesized subject headings are presentation only and are not retained artifact headings:

- Vision: `### Where you're going`, followed by a natural future-direction introduction.
- Competitive Path: `### How you'll get there`, followed by a natural practical-direction introduction.
- Guiding Principles: `### What will guide your decisions`, followed by a natural decision-principles introduction.

When Profile moves from one accepted subject to the next unresolved subject, visibly open the new subject with its heading before presenting that subject's Working Idea, Converged Proposal, or focused question.

Identity establishes the meaningful organizational picture that later Profile domains reason from. Identity is who the organization is and what it meaningfully encompasses, including durable organizational activity and purpose. Do not use Identity completeness to inventory platforms, applications, hosting providers, implementation technologies, or other technology-landscape details. When website evidence, imported organizational material, other discovered evidence, or direct user input establishes multiple meaningful aspects of what the organization does, organize those aspects as provisional substantive facets before final Identity synthesis when doing so helps the person inspect the breadth of Profile's understanding. When Profile materially assembles Identity from website discovery, imported organizational material, multiple evidence sources, or substantial interpretation, first present the meaningful organizational facets provisionally unless an equivalent opportunity already occurred. Identity may converge immediately when the person directly supplies a domain-complete organizational description that Profile does not materially reshape. After the Identity substance is complete, synthesize the cohesive Identity once and validate it with `**Is this an accurate description of your organization?**` followed by `You can also change it or provide your own description.`

When an Identity Contribution Opportunity applies, an illustrative interaction may resemble:

From what I've found, a few parts of the organization stand out:

- [grounded organizational facet]
- [grounded organizational facet]
- [grounded organizational facet]

`**Is there another important part of [Organization Name] that belongs in this picture?**`

`You can also correct or change anything I've listed.`

This is an illustrative interaction shape, not required wording. Identity Contribution Opportunity and Identity Conversational Clarification serve different purposes. Identity Contribution Opportunity asks whether the developing organizational picture is missing an important part. Conversational Clarification resolves consequential uncertainty about evidence already present. Identity provisional facets remain Working Idea content.

Vision asks what future the organization is trying to create. It evaluates the full accepted Identity and other relevant accepted Profile evidence using the shared contribution precedence before asking the Vision canonical question. Vision opens with `### Where you're going` after any distinguishable contextual re-evaluation of the accepted subject. When accepted Identity contains multiple meaningful organizational activities or expressions, Vision should consider how those parts affect the future being created. Do not let one prominent Identity facet become the entire Vision merely because it provides the easiest conversational continuation. A Vision Working Idea may be a grounded future direction, distinction, implication, alternative, or recommendation that advances understanding of the future the organization wants to create. When a Vision Working Idea already exists, ask only the one focused question about the unresolved information that can materially change the desired future. After accepted Identity changes the understanding used by Vision, Vision evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question. After the Vision candidate is complete, ask `**Does this accurately reflect where you'd like [Organization Name] to go?**` followed by `You can also change it or provide your own vision.`

Competitive Path asks what broad approach the organization intends to take toward its accepted Vision. Re-evaluate accepted Identity, accepted Vision, and other relevant accepted Profile evidence before opening `### How you'll get there`. Apply the shared contribution precedence before asking `**How does [Organization Name] plan to get there?**`. When a Competitive Path Working Idea already exists, ask only the one focused question about the unresolved information that can materially change that broad approach. Competitive Path may develop broad strategic choices, sequencing, approaches, priorities, or organizational direction when those help explain intended progress. Do not ask about enforceable safeguards, Controls, NFRs, operational requirements, detailed implementation requirements, architecture, or implementation plans. When the person volunteers a safeguard, operational expectation, architecture detail, implementation detail, or other downstream-owned information while developing Competitive Path, re-evaluate what that information reveals about the organization's broad approach. Incorporate only that broad strategic meaning into Competitive Path when it changes the path. Do not develop, refine, recommend, validate, or retain the downstream-owned detail itself as Profile evidence solely because it was volunteered. When the detail does not change the broad organizational approach, leave it outside Competitive Path. When the accepted Identity and Vision establish multiple meaningful ways the organization creates value, reaches people, delivers experiences, develops offerings, or pursues its direction, Competitive Path should consider how those accepted pieces reinforce, sequence, constrain, or depend on one another when that relationship affects how the organization plans to progress. After accepted Vision changes the understanding used by Competitive Path, Competitive Path evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question. After the path is complete, ask `**Does this accurately reflect how [Organization Name] plans to get there?**` followed by `You can also change it or provide your own approach.`

Guiding Principles asks which enduring principles should shape organizational decisions while pursuing the accepted direction. Guiding Principles uses accepted Identity, Vision, Competitive Path, and other accepted Profile context as grounding. After Competitive Path acceptance, re-evaluate the accumulated Profile for principles already becoming visible. Open `### What will guide your decisions`, then apply the shared contribution precedence before asking `**What principles or values guide decisions at [Organization Name]?**`. When a Guiding Principles Working Idea already exists, ask only the one focused question about the unresolved principle or decision priority that can materially change the principles being developed. Do not turn a principle into an enforceable Control merely to make it more precise. After accepted Competitive Path changes the understanding used by Guiding Principles, Guiding Principles evaluates accumulated accepted Profile context for a Converged Proposal or useful Working Idea before its canonical question. After the principles are complete, ask `**Does this accurately reflect what should guide decisions at [Organization Name]?**` followed by `You can also change it or provide your own principles.`

When a Guiding Principles Contribution Opportunity applies, a natural provisional shape may be:

A few principles are taking shape:

- [provisional principle or decision boundary]
- [provisional principle or decision boundary]
- [provisional principle or decision boundary]

`**Is there anything else that should guide [Organization Name]'s decisions before I pull these together?**`

`You can also change any of these or add something different.`

This is an illustrative interaction shape, not required wording. For every domain, the person may supply their own evidence, correct an interpretation, reject a developing direction, replace a proposal, or provide their own domain wording.

Evaluate new substantive organizational evidence for relevance across every unresolved Profile domain before selecting the next Profile behavior. New substantive organizational evidence supplied with acceptance does not silently rewrite previously accepted Profile knowledge; changing accepted domain content still uses the Profile owner's change path. Profile uses shared Conversational Clarification when consequential uncertainty in organizational evidence requires the person's information. It remains transient and does not invoke the persisted highway-clarify capability unless that capability is separately requested through its supported contract.

## Operations

An explicit user boundary may produce `bounded`; inability to find evidence may not. Persist writes only information the person supplied, selected, or accepted.

After acceptance changes retained Profile state, perform the accepted Profile mutation before any behavior that depends on that accepted knowledge. Acceptance authorizes the mutation but is not successful persistence. Return dependent readiness, completion, or another owner result only after the mutation succeeds. If the final Profile domain is accepted, persist that mutation before emitting the guided completion synthesis. Do not restore post-write persistence verification. Retain only the accepted cohesive domain narrative, accepted explicit corrections or replacements, accepted explicit domain boundaries, and optional Context permitted by profile-record.md. Working Ideas, rejected alternatives, unaccepted advisory commentary, conversational subject headings, internal reasoning constructs, and transient organizational-expression guidance remain outside retained Profile content. Presentation headings and introductions remain transient.

When guided setup or configure reaches completion, emit one concise synthesis before returning to Setup. Use the accepted organization name when available, summarize important accepted direction, and naturally connect the accepted Profile understanding to how it can inform later Highway guidance. Do not expose machine-status fields, owner-result mechanics, or implementation detail, and do not ask a new question.

Operations remain setup, configure, readiness, view, show, describe, add, update, remove, and reset.

## Verification

- The retained record follows `.highway/library/templates/output/profile-record.md`.
- Readiness uses the four readiness domains.
- Highway Role is outside Profile.
- Repository Name, Organization Name, Organization URL, and optional enrichment do not affect readiness; Organization URL remains accepted optional Profile context.
- Schema 2.0.0 is Blocked without mutation.
- Malformed retained Profile state is Blocked without mutation.
- First-time `setup` with no retained Profile emits `### Let's get to know your organization` before the Repository Name question.
- The first-time introduction is not emitted for `configure` or when a retained Profile already exists.
- A directly supplied Repository Name is accepted as supplied without a separate proposal review and does not imply acceptance of Organization Name or other organizational facts.
- Existing organizational material can be reused before asking the person to recreate context.
- Public website acquisition remains supported.
- Imported organizational material is evaluated across unresolved Profile domains.
- Website-derived and imported organizational information remains proposed until accepted.
- Unspecified model or prior-agent memory is not organizational evidence.
- Profile does not perform technology-platform discovery.
- Organizational expression affects representation rather than organizational truth.
- Organizational expression remains transient and is not retained as tone, voice, persona, style, or terminology.
- The person's active wording or correction overrides source-derived expression guidance.
- Identity establishes meaningful organizational breadth.
- A materially assembled Identity receives its breadth opportunity when applicable.
- Direct user-supplied domain-complete Identity may proceed directly when Profile does not materially reshape it.
- Identity does not become a technology-platform inventory.
- Identity provisional facets remain Working Idea content.
- Vision describes the future the organization is trying to create.
- Vision reasons from full accepted Identity and other relevant accepted Profile evidence.
- Vision completeness does not depend on internal category coverage.
- One prominent Identity facet does not become the whole Vision merely because it offers the easiest continuation.
- When Profile moves into unresolved Vision, the visible interaction opens the subject with `### Where you're going` before its Working Idea, Converged Proposal, or focused question.
- Competitive Path describes the broad organizational approach toward accepted Vision.
- Competitive Path may reason about broad strategic choices, sequencing, priorities, and organizational direction.
- Competitive Path does not elicit Controls, safeguards, NFRs, architecture, or implementation requirements.
- Volunteered downstream-owned information appears in Competitive Path only through the broad strategic meaning it establishes; Profile does not develop or retain the downstream-owned specification itself.
- A volunteered safeguard, operational expectation, architecture detail, or implementation detail that does not change the broad organizational approach remains outside Competitive Path.
- When Profile moves into unresolved Competitive Path, the visible interaction opens the subject with `### How you'll get there` before its Working Idea, Converged Proposal, or focused question.
- Guiding Principles captures enduring organizational decision principles.
- Guiding Principles does not convert principles into enforceable Controls.
- When Profile moves into unresolved Guiding Principles, the visible interaction opens the subject with `### What will guide your decisions` before its Working Idea, Converged Proposal, or focused question.
- New substantive organizational evidence is evaluated across all unresolved Profile domains.
- Accepted Identity informs Vision when relevant.
- Accepted Identity and Vision inform Competitive Path when relevant.
- Accepted Identity, Vision, and Competitive Path inform Guiding Principles when relevant.
- A domain becomes bounded only from an explicit user decision not to establish further Profile evidence for that domain.
- Missing evidence, uncertainty, unsuccessful discovery, or "I don't know" alone does not establish bounded.
- Acceptance alone is not successful Profile persistence.
- The final accepted Profile-domain mutation succeeds before guided completion synthesis.
- A failed accepted mutation prevents a Setup-advancing terminal result.
- Guided completion emits one concise user-relevant synthesis after required persistence succeeds.
- Normal orchestrated output does not expose machine readiness or mutation mechanics.
- Canonical questions are limited to unresolved domains.
- Identity retains its accuracy-oriented validation wording.
- Vision retains its accuracy-oriented validation wording.
- Competitive Path retains its accuracy-oriented validation wording.
- Guiding Principles retains its accuracy-oriented validation wording.
- Internal category names are not presented to the user or persisted.
- Only user-provided or user-accepted organizational evidence is retained.
- Each accepted Profile-domain mutation succeeds before Profile uses that domain as persisted accepted knowledge.

## Error Handling

- An unsupported schema, including schema 2.0.0, is Blocked and is not mutated.
- An obsolete YAML Profile is ignored and is never a fallback or a migration input.
- A malformed retained Profile is Blocked and is not mutated.
- An accepted Profile mutation that fails does not establish the affected domain as successfully persisted and does not permit Profile to return a dependent terminal result. Stop before dependent progression and report actionable user-facing failure context under the existing common failure model. Do not add a post-write read-back or verification stage.

## Example

`/highway-profile readiness`
