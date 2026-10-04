# Feature 119 Data Model

## Accepted Profile Evidence

User-provided or user-accepted organizational information that can be persisted and reused across the four Profile domains. Accepted evidence remains the only source for retained organizational claims.

## Validation Prompt

A Profile-specific accuracy-oriented question followed by a quiet correction or replacement option.

| Domain | Validation question | Alternative path |
|---|---|---|
| Identity | `**Is this an accurate description of your organization?**` | `You can also change it or provide your own description.` |
| Vision | `**Does this accurately reflect where you'd like [Organization Name] to go?**` | `You can also change it or provide your own vision.` |
| Competitive Path | `**Does this accurately reflect how [Organization Name] plans to get there?**` | `You can also change it or provide your own approach.` |
| Guiding Principles | `**Does this accurately reflect what should guide decisions at [Organization Name]?**` | `You can also change it or provide your own principles.` |

The accepted Organization Name is used when available. A natural affirmative accepts the displayed proposal through the existing Experience Standard boundary. A correction or replacement becomes the user's proposed alternative. An explanation request is clarification, not acceptance. No second confirmation is emitted after acceptance.

## Conversational Composition

The user-visible synthesized turn has four conceptual parts, without exposing these labels as headings or stages:

1. **Acknowledge**: Briefly connect the latest accepted information to accumulated Profile context. Avoid empty praise and simple repetition.
2. **Build**: Optionally contribute one useful, respectful observation grounded in accepted evidence: implication, opportunity, connection, tradeoff, tension, concern, or sharpening direction. Omit it when no useful contribution exists.
3. **Recommend**: Present one cohesive grounded Vision, Competitive Path, or Guiding Principles paragraph. Only this paragraph is eligible to become retained domain narrative.
4. **Validate**: End with exactly one response-demanding validation question followed by the quiet correction/replacement path.

Acknowledge and Build are transient conversation context unless the person explicitly incorporates the content into an accepted replacement or correction. They do not establish readiness by themselves.

## Cohesive Domain Recommendation

A single reviewable paragraph for Vision, Competitive Path, or Guiding Principles, grounded only in accepted organizational evidence. Internal enrichment categories remain reasoning inputs and are neither presented nor persisted.

- Vision uses accepted Identity and other Profile evidence to express where the organization is going.
- Competitive Path uses accepted Identity, Vision, and other Profile evidence to express how the organization plans to get there.
- Guiding Principles uses accepted Identity, Vision, Competitive Path, and other organizational evidence to express principles with decision value.

When grounding is insufficient, the applicable canonical question remains the fallback.

## Domain State Transition

| Event | Result |
|---|---|
| No accepted evidence or boundary | Domain remains `not_discussed` |
| Accepted recommendation or accepted user-authored narrative | Domain becomes `discussed` |
| Explicit boundary on unresolved domain | Domain becomes `bounded` |
| Optional enrichment for `discussed` or `bounded` domain | Readiness remains unchanged |

An accepted recommendation prevents the corresponding canonical question. Persistence of the accepted mutation occurs before dependent readiness or owner results.

## Retained Profile Boundary

The existing Markdown Profile remains schema `3.0.0` with exactly four readiness domains: Identity, Vision, Competitive Path, and Guiding Principles. The shared `profile-record.md` template remains unchanged. Organization URL and optional context remain non-readiness-bearing. Technology-platform and brownfield discovery remain outside Profile.

## Completion Synthesis

The existing concise user-relevant completion synthesis remains after the final accepted mutation and before Setup resumes. It summarizes accepted Profile understanding and does not retain transient acknowledgment, advisory commentary, internal categories, or machine-result fields.
