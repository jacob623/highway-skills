---
name: highway-profile
description: "Manages the repository-wide organizational Profile and its contextual guidance."
usage: "Invoke as `/highway-profile` to inspect Profile context, or state setup, view, add, update, remove, or reset."
compatibility: all
metadata:
  version: 3.0.0
---

## highway-profile

## Purpose

Collects adaptive organizational evidence and persists accepted context in the Markdown Profile.

## Scope

The Profile tracks five evidence domains: identity, vision, competitive path, guiding principles, and Highway role.

## When to use

Use `setup` or `configure` to collect evidence, `readiness` to assess the persisted Profile, `view`,
`show`, or `describe` to inspect it, and `add`, `update`, `remove`, or `reset` for explicit changes.

## When not to use

Do not create Controls, NFRs, Objectives, governance rules, or Highway identity. Do not use the
obsolete YAML artifact as a source, fallback, authority, migration input, or mutation target.

## Inputs

- Project root containing `.highway/`.
- The authoritative Profile at `.highway/library/knowledge/profile.md`, when present.
- The shared structural template at `.highway/library/templates/output/profile-record.md`.
- `.highway/library/knowledge/highway-identity.md` for behavioral guidance when available.
- `.highway/library/knowledge/highway-vision.md` for strategic direction when available.
- `.highway/library/knowledge/highway-platform-objectives.md` for evaluation criteria when available.
- `.highway/governance/experience-standard.md` as the authoritative interaction contract.
- `.highway/tools/validate-profile.sh` for retained Profile structural validation.
- A user request and proposal evidence for the active interaction.
- Profile workflow Steps 1 through 7, in order, before Step 8 preserves ownership.

## Outputs

The retained artifact is `.highway/library/knowledge/profile.md`. Its complete reusable structure is
owned by `.highway/library/templates/output/profile-record.md`; this skill cites that file and does not
repeat its complete skeleton.

Readiness emits exactly:

```text
Status: <Complete, Missing, or Blocked>
Summary: <Profile readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Readiness classifies the retained artifact in this order: an absent Profile is `Missing` with
`Next Action: /highway-profile setup`; a present Profile with missing, malformed, contradictory, or
unsupported schema structure is `Blocked` with `Next Action: None`; a valid incomplete Profile with
any `not_discussed` domain is `Missing` with `Next Action: /highway-profile configure`; and a valid
Profile with all five outcomes `discussed` or `bounded` is `Complete` with `Next Action: None`.
Readiness is read-only and evaluates no proposal state.

## Evidence and domain evaluation

The five domains are `identity`, `vision`, `competitive_path`, `guiding_principles`, and
`highway_role`. Each persists exactly one of `not_discussed`, `discussed`, or `bounded`.

Begin first-time Setup with Identity's broad starting question. Process every response for evidence
in every supported domain before selecting another question. Ask no more than one unresolved question
at a time. Evaluate the following follow-up decision table in order:

| Condition | Action |
|---|---|
| Resolving missing evidence could alter recommendation selection, recommendation depth, explanation depth, assumed organizational responsibility, governance interpretation, workflow selection, or generated artifact content | Ask one follow-up and explain the affected downstream decision in Decision Context |
| Otherwise | Advance without a follow-up |

An explicit user boundary may produce `bounded`; inability to find evidence may not.

Proposal evidence is transient until the user accepts the complete proposal. Accepted evidence is the
only authoritative retained context. Cross-domain evidence may establish a later domain without its
canonical starting question when no remaining information need applies. Do not ask for evidence already
present in the active proposal or accepted Profile, and do not infer facts, capabilities, structures,
personas, maturity tiers, or advisory classes.

## Profile operations

- **Add**: add accepted evidence to a `discussed` or `bounded` domain; use Setup or Configure for `not_discussed`.
- **Update**: revise uniquely identified evidence and preserve the outcome while its basis remains.
- **Remove**: preview exact evidence loss; removing the last evidence yields `not_discussed` unless the same request explicitly establishes `bounded`.
- **Reset**: remove evidence and boundary for one domain and yield `not_discussed`.
- **Setup/Configure**: use accepted state plus transient proposal evidence; present the complete proposal for acceptance before writing.

Every mutation validates the authoritative artifact, previews evidence and outcome changes, requests
confirmation, writes only after confirmation, verifies persisted bytes, and reports readiness. Declined,
ambiguous, malformed, failed, and byte-identical no-op mutations do not write. Interrupted Configure
preserves the accepted artifact byte-for-byte. Setup never persists a `not_discussed` initial Profile.

## Profile workflow

### Step 1: Locate and classify

Locate the project root and retained Profile artifact. Classify readiness and validate the retained
Profile schema when the artifact is present.

### Step 2: Consult declared context

After Step 1, and before the first context-dependent evidence evaluation or proposal decision, consult
each available declared Repository Context document using its declared role and record unavailable
documents.

### Step 3: Collect evidence

After Step 2, collect one unresolved question at a time, processing each response across all
supported domains.

### Step 4: Build the proposal

After Step 3, build a complete proposal from accepted state and transient proposal evidence without
inventing facts.

### Step 5: Obtain acceptance

After Step 4, present the proposal and obtain user acceptance before any mutation.

### Step 6: Persist and verify

After Step 5 receives acceptance, persist the accepted proposal and verify the written bytes and
structural invariants.

### Step 7: Emit the result

After Step 6 succeeds, emit the readiness result and user-relevant outcome, or report the applicable
exit or failure.

### Step 8: Preserve ownership

After Steps 1 through 7, keep Profile ownership of evidence, persistence, and readiness; do not
delegate those decisions to Setup or another workflow.

## Persistence and rendering

The Markdown Profile begins with the required frontmatter and `# Organizational Profile`. It contains
exactly five domain outcomes, deterministic frontmatter and narrative order, and only evidence-backed
sections. `not_discussed` has no narrative; `discussed` requires one; `bounded` may have one when
accepted evidence exists. The initial Markdown artifact uses `schema_version: 2.0.0`; content
mutations do not change that schema version.

Before context-dependent evidence evaluation or proposal generation, consult each available declared
context document using its declared role. Record each unavailable document without substituting
inferred organizational facts; workflow-specific input remains authoritative. Before a successful
completion claim, verify file existence, frontmatter, all domain outcomes, state-to-narrative
invariants, and byte equality with the accepted proposal. Name the artifact on any persistence
failure. The former YAML artifact is ignored and has no behavioral effect.

## Repository Context participation

A Participating Skill must declare Profile in Inputs, consult it before context-dependent output, and
use it only when it changes a declared behavior category. Workflow-specific inputs remain authoritative
for the active execution. Profile remains user-owned context and does not become a governed artifact.
Foundational context may influence evidence significance and follow-up selection, but it is not
organizational evidence and must not be promoted into the retained Profile without user input.

## Verification

- Validate the shared template and retained artifact with `.highway/tools/validate-profile.sh`.
- Confirm adaptive fixtures process all evidence, ask at most one behavior-changing follow-up, and preserve boundaries.
- Confirm available and absent Identity, Vision, and Platform Objectives context by role, with no context promotion.
- Confirm repeated equivalent proposals render identical bytes and no generated values.
- Confirm declined, interrupted, ambiguous, malformed, and no-op paths preserve bytes.
- Confirm legacy YAML is not read, migrated, or used as fallback.
- Confirm persistence verification precedes every successful completion claim.

## Error Handling

Every numbered workflow step maps to one of these failure actions:

| Step | Failure condition | Error Handling action |
|---|---|---|
| 1 | The project root or retained Profile path cannot be located | abort and report the actionable path |
| 2 | A declared context document is inaccessible or unavailable | escalate after recording the unavailable document; do not substitute context |
| 3 | A response is ambiguous, malformed, or fails evidence validation | abort and preserve the original artifact |
| 4 | A proposal would require invented facts or cannot be rendered structurally | abort and preserve the original artifact |
| 5 | The user declines or does not confirm the proposal | abort without writing and preserve the original artifact |
| 6 | Persistence verification or structural validation fails | abort, name the authoritative artifact, and preserve its bytes |
| 7 | A result cannot be emitted without claiming unsupported completion | abort and report the applicable failure |
| 8 | Another workflow attempts to take Profile ownership | abort and preserve Profile ownership |

An absent Profile is a valid initial state: readiness reports `Missing`, Setup begins collection,
and view, show, or describe reports absence without creating an artifact. It is not an error path.

## Example

`/highway-profile readiness`

## Interactive Workflow UX Contract

This contract applies the Highway Experience Standard's Interactive Workflow rules to Profile
responses; the Experience Standard remains the normative authority for user-visible interaction.
Current Question, Domain Progress, and Current Activity are transient presentation labels; accepted
evidence and domain outcomes remain the persisted Profile state. Progress is described using domain
outcomes rather than question counts. The workflow suppresses implementation details unless requested,
identifies User Exits and Owner Outcomes, states Resume Applicability, and makes ownership explicit.
When a requested answer can affect a downstream recommendation, decision, artifact, governance
interpretation, or workflow action, the question includes Decision Context explaining that affected
outcome.
