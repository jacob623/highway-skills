# Data Model: Experience Profile Presentation Rhythm

This feature does not add or migrate stored data. It changes how existing Profile evidence is presented.

## Entities

### Profile domain

One of `Identity`, `Vision`, `Competitive Path`, or `Guiding Principles`.

- Readiness: `not_discussed`, `discussed`, or `bounded`
- Evidence: user-provided or user-accepted organizational information only
- Validation: existing domain-specific question and user-authored alternative
- Persistence: accepted mutation is written before a dependent readiness or owner result

### Accepted Profile evidence

The retained organizational facts that may ground later recommendations. Website-derived information remains proposed until accepted.

### Transient Profile presentation

Acknowledgment, subject heading, introduction, explanation, reflection, advisory commentary, implication, opportunity, tradeoff, concern, alternative, and internal enrichment category names. These are not retained unless explicitly incorporated into accepted Profile evidence.

### Profile subject

A user-facing presentation label for a synthesized domain:

| Domain | Heading | Presentation shape |
|---|---|---|
| Vision | `### Where you're going` | Future-direction introduction, cohesive grounded recommendation, existing Vision validation |
| Competitive Path | `### How you'll get there` | Practical-direction introduction, cohesive grounded recommendation, existing Competitive Path validation |
| Guiding Principles | `### What will guide your decisions` | Decision-principles introduction, cohesive grounded recommendation, existing Guiding Principles validation |

## Relationships and flow

`accepted evidence -> acknowledge when X2.8 applies -> introduce subject -> suggest grounded recommendation -> validate -> accept or author alternative -> persist accepted evidence`

After acceptance, the next subject is introduced only when grounded evidence supports it. If no useful recommendation can be grounded, the existing canonical question remains the fallback.

## Invariants

- Exactly four Profile domains remain authoritative.
- No new schema field or readiness state is introduced.
- No subject heading is written to the retained Profile template.
- Completion remains the existing concise synthesis after Guiding Principles acceptance.
- Generic suppression of workflow narration is owned by Experience Standard X2.36.
