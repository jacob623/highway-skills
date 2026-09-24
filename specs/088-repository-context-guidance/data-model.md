# Data Model: Repository Context Guidance

## Repository Context Document

An authoritative repository-level knowledge document used when it is relevant to a skill's
Behavior.

| Field | Value |
|---|---|
| Allowed identities | `.highway/library/knowledge/highway-identity.md`, `.highway/library/knowledge/highway-vision.md`, `.highway/library/knowledge/highway-platform-objectives.md` |
| Authority | Authoritative repository context; accepted repository artifacts may supplement but cannot replace or reinterpret it |
| Ordering | Identity -> Vision -> Platform Objectives when overlapping guidance must be resolved |
| Extension | Additional documents require a future amendment |

## Behavior

The recommendations, guidance, decisions, explanations, proposals, generated artifacts, workflow
actions, or user-visible outputs produced by a skill.

## Material Influence

Information that alters a recommendation, Behavior, governance interpretation, prioritization,
decision support, or generated artifact outcome.

## Participating Skill

A Highway skill whose Behavior is influenced by Repository Context. A skill that neither consumes
repository context nor produces context-dependent output is outside the Participating Skill set.

| Review fields | Source |
|---|---|
| Purpose | Skill `Purpose` section |
| Inputs | Skill `Inputs` section, including context declaration after FR-004 applies |
| Outputs | Skill `Outputs` section |
| Workflow decisions | Declared workflow steps and decision criteria |

## Relevant Repository Context

The subset of Repository Context Documents that can produce a Material Influence on the current
recommendation, proposal, explanation, decision, prioritization, generated artifact, or user
guidance. Presence alone does not establish relevance.

## Contextual Acknowledgment

A concise user-facing statement recognizing information that produces a Material Influence on
future recommendations. It explains the current or future recommendation or Behavior and does not
promote unrelated Highway capabilities.

## Relationships and invariants

- FR-004 establishes the context declaration in a Participating Skill's Inputs section.
- FR-019 applies only after FR-004 declaration and limits consumption to relevant documents.
- Workflow-specific inputs, governance artifacts, and user-owned content remain authoritative for
  workflow execution in their respective domains.
- Identity, Vision, and Platform Objectives are evaluated in order for overlapping context guidance.
- Missing documents produce no fabricated recommendations, assumed content, or substituted context.
- Existing X2.1-X2.6 identifiers, text, Observables, tiers, and applicability remain unchanged.
- X2.7 and X2.8 are the only new Experience Standard rule identifiers introduced by this feature.
