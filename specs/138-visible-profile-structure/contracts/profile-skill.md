# Contract: highway-profile

Source: `.highway/skills/highway-profile/SKILL.md`

Baseline: `6.0.0`. Published version: `7.0.0`. Retained path: `.highway/library/knowledge/profile.md`.

The skill must not contain MUST or SHOULD. It must be materially shorter than `6.0.0` without a fixed line target.

## Required sentences

- `The retained artifact is `.highway/library/knowledge/profile.md`.`
- `The retained Profile follows the complete structure in .highway/library/templates/output/profile-record.md. Profile owns the meaning, evidence, state, and readiness of Identity, Vision, Competitive Path, and Guiding Principles. Accepted evidence that establishes a domain sets it to discussed; an explicit user boundary may set an otherwise unresolved domain to bounded. Optional Context does not change readiness. Schema 2.0.0 is Blocked and left unchanged.`
- `Profile uses the collaborative-development model defined by the Highway Experience Standard. Working Ideas, Substantive Contributions, Conversational Clarification, Contribution Opportunities, Converged Proposals, and their interaction boundaries follow that shared contract. Profile defines what constitutes a complete candidate for each Profile domain and the Profile-specific evidence, readiness, persistence, and downstream ownership boundaries below.`
- `Website and imported-source acquisition are limited to evidence relevant to the organizational Profile.`
- `Website-derived and imported organizational information remains proposed until the applicable Profile acceptance boundary is crossed.`
- `Do not use tone, style, phrasing, terminology, or communication patterns as evidence that a substantive organizational claim is true.`
- `Optional enrichment may continue after a domain is discussed or bounded and does not change readiness by itself. User-visible collaborative behavior follows the Highway Experience Standard. Profile-specific enrichment remains transient unless the person incorporates it into accepted Profile evidence.`
- `A Profile domain is ready to become a Converged Proposal when accumulated evidence supports one coherent organizational narrative that meaningfully answers the domain's purpose without unsupported facts.`
- `Evaluate acquired, direct, and newly supplied substantive organizational evidence across all unresolved Profile domains before selecting the next Profile behavior.`
- `When the person volunteers a safeguard, operational expectation, architecture detail, implementation detail, or other downstream-owned information while developing Competitive Path, re-evaluate what that information reveals about the organization's broad approach. Incorporate only that broad strategic meaning into Competitive Path when it changes the path. Do not develop, refine, recommend, validate, or retain the downstream-owned detail itself as Profile evidence solely because it was volunteered. When the detail does not change the broad organizational approach, leave it outside Competitive Path.`
- `Evaluate new substantive organizational evidence for relevance across every unresolved Profile domain before selecting the next Profile behavior.`
- `Profile uses shared Conversational Clarification when consequential uncertainty in organizational evidence requires the person's information. Ordinary Profile clarification remains transient and does not invoke the persisted highway-clarify capability unless that separate capability is explicitly requested.`
- `New substantive organizational evidence supplied with acceptance does not silently rewrite previously accepted Profile knowledge; changing accepted domain content still uses the Profile owner's change path.`
- `After acceptance changes retained Profile state, perform the accepted Profile mutation before any behavior that depends on that accepted knowledge. Acceptance authorizes the mutation but is not successful persistence. Return dependent readiness, completion, or another owner result only after the mutation succeeds.`
- `If the final Profile domain is accepted, persist that mutation before emitting the guided completion synthesis.`
- `Retain only accepted cohesive domain narrative, accepted explicit corrections or replacements, accepted explicit domain boundaries, and optional Context permitted by profile-record.md.`

## Required preserved behavior

- Canonical questions: `What does [Organization Name] do?`, `What is the future vision of [Organization Name]?`, `How does [Organization Name] plan to get there?`, and `What principles or values guide decisions at [Organization Name]?`
- Conversational headings: `### Where you're going`, `### How you'll get there`, `### What will guide your decisions`
- Identity, Vision, Competitive Path, and Guiding Principles validation questions and their "you can also change it" follow-ups
- Illustrative Identity breadth pattern and Guiding Principles provisional pattern
- Readiness outcomes and next actions from the specification
- Schema `2.0.0` blocked without migration
- No literal `<br>`
- No duplicate sentence `Website acquisition is limited to evidence relevant to the organizational Profile.`
- No malformed fragment `persist the retained Profile, and only then return dependent readiness`

## Verification coverage

Verification cites the template for retained structure and does not restate heading order, Context child order, conditional rendering, or frontmatter ordering. It includes:

- Volunteered downstream-owned information appears in Competitive Path only through the broad strategic meaning it establishes; Profile does not develop or retain the downstream-owned specification itself.
- A volunteered safeguard, operational expectation, architecture detail, or implementation detail that does not change the broad organizational approach remains outside Competitive Path.

## Protected files

Do not modify `experience-standard.md`, `constitution.md`, `setup.md`, `objectives.md`, `controls.md`, or `nfrs.md`.
