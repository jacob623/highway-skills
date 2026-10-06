# Data Model: Profile Collaboration Convergence

This feature adds no retained Profile fields. The entities below describe development-time evaluation inputs and transient interaction concepts only.

## Profile Domain Candidate

- **Purpose**: Complete or incomplete transient understanding for one of Identity, Vision, Competitive Path, or Guiding Principles.
- **Attributes**: domain identifier, active evidence, relevant accepted Profile context, completeness result, and current development disposition.
- **Relationships**: may have one active Working Idea and may produce one Converged Proposal; may preserve implications for another unresolved domain.
- **Validation**: completeness does not independently establish conversational convergence; unsupported facts cannot be promoted to accepted content.

## Working Idea

- **Purpose**: Transient model-originated or jointly developed connection, implication, distinction, tension, alternative, opportunity, concern, or recommendation that could change a domain's substantive meaning.
- **Attributes**: source evidence references, provisional interpretation, affected domain, user response status, and acceptance disposition.
- **Relationships**: belongs to an active Profile Domain Candidate; may require a Contribution Opportunity; may be accepted, modified, rejected, narrowed, redirected, or extended.
- **Validation**: never persisted merely because it was discussed; it remains provisional until accepted through the existing domain acceptance path.

## Converged Proposal

- **Purpose**: A complete domain candidate that has also satisfied applicable conversational convergence behavior and is ready for existing Profile-specific validation.
- **Attributes**: domain, accepted supporting evidence, settled substantive development, and validation prompt reference.
- **Relationships**: follows a Profile Domain Candidate and may follow a Working Idea.
- **Validation**: cannot be emitted prematurely while useful grounded development or consequential user-owned ambiguity remains.

## Transcript Fixture

- **Purpose**: Synthetic, organization-neutral multi-turn scenario executed during development validation.
- **Attributes**: fixture identifier, scenario description, starting accepted Profile context, active transient context, user stimulus, expected observable behaviors, failure behaviors, applicable rubric dimensions, governance references, and hard-failure flags.
- **Relationships**: evaluates one or more Profile Domain Candidates and references the Evaluation Rubric.
- **Validation**: all eight required fixture categories run through the repository's development validation workflow; fixture data is not loaded by shipped Profile behavior.

## Evaluation Rubric

- **Purpose**: Reusable semantic evaluation dimensions applied to transcript fixtures.
- **Attributes**: dimension identifier, pass condition, fail condition, applicability, and hard-failure classification.
- **Dimensions**: contextual re-evaluation, constructive contribution, convergence timing, contribution opportunity, clarification discipline, authority boundary, conversational presence, implementation-detail leakage, and non-manufactured collaboration.
- **Validation**: every applicable dimension must pass; hard governance violations cannot be averaged away.

## State and Persistence Boundary

- Working Ideas, fixture transcripts, rubric judgments, and convergence disposition are transient or development-only.
- The retained Profile continues to contain only accepted organizational knowledge in the existing four-domain schema.
- Readiness remains the existing Profile-owned result and gains no new dimension.
