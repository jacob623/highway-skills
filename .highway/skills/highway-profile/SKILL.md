---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 4.0.0
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

Profile readiness emits exactly:

```text
Status: <Complete, Missing, or Blocked>
Summary: <Profile readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

An absent Profile is a valid initial state. Readiness classifies the retained artifact in this order: an absent Profile is `Missing` with
`Next Action: /highway-profile setup`; a present Profile with missing, malformed, contradictory, or
unsupported schema structure, including schema 2.0.0, is `Blocked` with `Next Action: None` and is left unchanged; a valid incomplete Profile with
any `not_discussed` domain is `Missing` with `Next Action: /highway-profile configure`; and a valid
Profile with all four outcomes `discussed` or `bounded` is `Complete` with `Next Action: None`.
Optional context and optional enrichment do not change readiness.

## Evidence

The four readiness domains are `identity`, `vision`, `competitive_path`, and `guiding_principles`. Each persists exactly one of `not_discussed`, `discussed`, or `bounded`. `not_discussed` has no narrative; `discussed` has one; `bounded` has one only when accepted evidence exists. A new record uses `schema_version: 3.0.0`. Content mutations do not change that schema version. Schema 2.0.0 is Blocked and left unchanged.

Accepted optional context is body Markdown after the domain narratives and is omitted rather than stored as a placeholder: Repository Name, Organization Name, Organization URL, and Organizational Context.

Profile orders work as: classify the retained record, acquire context, accept evidence, Persist, and report readiness.

Begin first-time Setup with:

**What would you like to call your Highway repository?**

If you're using Highway for a company or organization, its name is usually a good choice.

Treat that answer as accepted Repository Name context and reuse it in the next prompt. When supported public-website retrieval is available, ask for the public website using the accepted Repository Name before ordinary domain questioning. The supplied Organization URL is accepted. website-derived Organization Name and other derived facts stay proposed until accepted. When retrieval is unavailable, continue without exposing the missing retrieval capability.

Unresolved domains use one canonical question: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, use the accepted Repository Name where it reads naturally. Process each response across all four domains before choosing the next question. When evidence is already accepted or active, a domain with accepted or active evidence is not asked. One question at a time, `**Why it matters:**`, and examples follow the Highway Experience Standard.

Optional enrichment may continue after a domain is `discussed` or `bounded`. Vision grounding uses Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Competitive Path grounding uses Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Guiding Principles grounding uses People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy, for how a principle should influence later decisions. Coverage of every category is not required, those names are not retained, and enrichment does not block completion. A grounded recommendation is preferred, and a selected recommendation is accepted without a second confirmation. Ask another question only when available evidence cannot support a useful recommendation. Profile does not store a small-business, enterprise, maturity, persona, or advisory classification.

An explicit user boundary may produce `bounded`; inability to find evidence may not. proposal evidence stays transient until accepted. Persist writes only information the person supplied, selected, or accepted. Foundational Highway context may show what evidence is useful, and it must not be promoted into the retained Profile. Workflow-specific input remains authoritative. Profile ownership of evidence and readiness stays with Profile.

Operations remain setup, configure, readiness, view, show, describe, add, update, remove, and reset. Destructive confirmation follows the Highway Experience Standard. An action that standard already counts as acceptance does not gain another confirmation.

## Verification

- The retained record follows `.highway/library/templates/output/profile-record.md`.
- Readiness uses the four readiness domains.
- Highway Role is outside Profile.
- Repository Name, Organization Name, and Organization URL do not affect readiness.
- Only user-provided or user-accepted organizational evidence is retained.
- website-derived information stays proposed until accepted.
- Canonical questions are limited to unresolved domains.
- Accepted evidence prevents a repeated question.
- Enrichment categories are not persisted.
- A selected recommendation needs no second confirmation.
- Material interpretation follows the Highway Experience Standard.
- No validator run or byte check is required.
- Profile ownership and readiness stay with Profile.

## Error Handling

- An unsupported schema, including schema 2.0.0, is Blocked and is not mutated.
- An obsolete YAML Profile is ignored and is never a fallback or a migration input.
- A malformed retained Profile is Blocked and is not mutated.

A failed mutation is not reported as success. That remains the common failure model, without a second procedure here.

## Example

`/highway-profile readiness`

## Experience

Profile responses follow the Highway Experience Standard. The Experience Standard remains the normative authority for user-visible interaction.
