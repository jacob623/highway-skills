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

## Acquisition

Acquisition follows this order: classify the retained Profile; establish Repository Name when missing; use supported existing-information or website acquisition when available; reuse accepted or accepted-discovered evidence across all four domains; re-evaluate accumulated accepted evidence across all four domains before each unresolved guided question; present a useful grounded recommendation instead of that canonical question when one exists; ask the canonical question only when grounding is insufficient; persist accepted evidence; report readiness.

When no retained Profile exists, begin first-time Setup with this one-time introduction:

### Let's get to know your organization

This helps Highway make more relevant recommendations as we go.

Then ask:

**What would you like to call your Highway repository?**

If you're using Highway for a company or organization, its name is usually a good choice.

Treat that answer as accepted Repository Name context and reuse it in the next prompt. When supported public-website retrieval is available, ask for the public website using the accepted Repository Name before ordinary domain questioning. Website acquisition is limited to organizational Profile evidence; technology-platform discovery is outside Profile scope. The supplied Organization URL is accepted. website-derived Organization Name and other derived facts stay proposed until accepted. When retrieval is unavailable, continue without exposing the missing retrieval capability.

Unresolved domains use one canonical question: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, use the accepted Repository Name where it reads naturally. Process each response, selected recommendation, or validated discovery across all four domains before choosing the next question.

## Enrichment

Optional enrichment may continue after a domain is `discussed` or `bounded`. When accepted evidence supports a useful synthesis, compose the user-visible turn around four concepts without exposing them as headings or stages: acknowledge the latest accepted information in the context of the Profile, optionally build with one useful grounded implication, opportunity, connection, tradeoff, tension, concern, or sharpening observation, recommend one cohesive paragraph, and validate it with one response-demanding question followed by a quiet correction or replacement path. Acknowledge and Build are optional conversational context; do not manufacture commentary or agreement merely to lengthen the response. Vision recommendations use accepted Identity, website-derived accepted information, existing Vision evidence, and other accepted Profile context across Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Competitive Path recommendations use accepted Profile evidence across Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Guiding Principles recommendations use accepted Identity, Vision, Competitive Path, website-derived accepted information, and previously accepted principles across People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy. Coverage of every category is not required, those names are not retained, and internal category names are not presented to the user; optional enrichment never changes readiness by itself, blocks continuation, or requires another question. Profile does not store a small-business, enterprise, maturity, persona, or advisory classification.

Use this Profile-specific composition when the evidence supports it. Acknowledge what Highway understood from the latest accepted information, optionally build with one grounded implication, opportunity, connection, tradeoff, tension, concern, or sharpening observation when it adds decision value, recommend one cohesive organizational paragraph, and validate it with one accuracy-oriented question and a quiet correction or replacement path. Do not expose these concepts as headings or workflow stages, and do not prescribe exact wording for Acknowledge, Build, or Recommend. The recommendation paragraph is the only portion intended to become retained domain narrative; acknowledgment and advisory commentary remain transient unless the person explicitly incorporates them into an accepted correction or replacement:

- Identity validation: `**Is this an accurate description of your organization?**` followed by `You can also change it or provide your own description.`
- Vision: contextualize the recommendation with accepted Identity or newly accepted direction when useful. Present one cohesive Vision paragraph that naturally expresses the recommended future direction from accepted evidence. Ask `**Does this accurately reflect where you'd like [Organization Name] to go?**` followed by `You can also change it or provide your own vision.`
- Competitive Path: contextualize the recommendation with accepted Vision when useful. Present one cohesive Competitive Path paragraph that naturally builds on the accepted Vision and preceding advisory context. Ask `**Does this accurately reflect how [Organization Name] plans to get there?**` followed by `You can also change it or provide your own approach.`
- Guiding Principles: contextualize the recommendation with the evolving Profile when useful. Present one cohesive Guiding Principles paragraph that naturally expresses the decision principles supported by accepted evidence. Ask `**Does this accurately reflect what should guide decisions at [Organization Name]?**` followed by `You can also change it or provide your own principles.`

Each paragraph contains only accepted-evidence claims and is offered as one reviewable recommendation. A natural affirmative accepts the displayed proposal through the existing acceptance boundary; a correction or replacement becomes the user's proposed alternative; an explanation request is not acceptance; and no second confirmation is added after acceptance. Advisory commentary is omitted when it adds no decision value, and additional commentary is included only when it adds useful context. Generic acceptance, alternatives, clarification handling, and presentation follow the Highway Experience Standard. When no useful cohesive paragraph can be grounded, ask the applicable canonical question. Accepted paragraph evidence establishes the domain as `discussed` and prevents that domain's canonical question; accepting enrichment for an already `discussed` or `bounded` domain does not change readiness.

## Operations

An explicit user boundary may produce `bounded`; inability to find evidence may not. Persist writes only information the person supplied, selected, or accepted.

After accepted evidence changes retained Profile state, construct the accepted mutation, persist the retained Profile, and only then return dependent readiness or another owner result. Recommendation selections and accepted discoveries use the same save-before-result path; conversational acceptance alone is not a successful mutation. Retain only the accepted cohesive domain narrative or explicit accepted correction/replacement; acknowledgment, unadopted advisory commentary, tradeoffs, concerns, alternatives, and internal category names remain transient. Do not restore post-write persistence verification. When guided setup or configure reaches completion, emit one concise synthesis before returning to Setup. Use the accepted organization name when available, summarize important accepted direction, and state that this understanding will improve later guidance. The synthesis contains no machine status field, no new question, and does not use "Profile Complete", "Status: Complete", or "Next Action: None".

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
- Before each unresolved canonical question, accepted evidence is evaluated for a useful grounded recommendation.
- Accepted evidence prevents a repeated question.
- Accepted evidence is persisted before dependent readiness or owner results.
- Vision uses one cohesive paragraph recommendation when accepted evidence supports a grounded Vision synthesis.
- Competitive Path uses one cohesive paragraph recommendation when accepted evidence supports a grounded Competitive Path synthesis.
- Guiding Principles uses one cohesive paragraph recommendation when accepted evidence supports a grounded Guiding Principles synthesis.
- Synthesized Vision, Competitive Path, and Guiding Principles turns may contextualize the recommendation with an acknowledgment.
- A synthesized recommendation may include one grounded advisory observation when accepted evidence supports one.
- Acknowledgment and advisory commentary remain transient unless explicitly incorporated into the accepted organizational narrative.
- Advisory commentary is omitted when it would add no decision value.
- Synthesized recommendation prose is generated naturally from accepted evidence rather than from a required recommendation sentence template.
- Identity retains its accuracy-oriented validation wording.
- Vision retains its accuracy-oriented validation wording.
- Competitive Path retains its accuracy-oriented validation wording.
- Guiding Principles retains its accuracy-oriented validation wording.
- The validation question remains the single response-demanding decision in the recommendation turn.
- A synthesized paragraph contains only claims supported by accepted organizational evidence.
- Internal enrichment-category names are neither presented to the user nor persisted.
- When no cohesive grounded paragraph can be produced, the applicable canonical question remains the fallback.
- Acceptance of a paragraph recommendation establishes the applicable unresolved domain as `discussed`.
- A domain established as `discussed` by accepted paragraph evidence does not receive its canonical question afterward.
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

## Experience

User-visible interaction follows the Highway Experience Standard.
