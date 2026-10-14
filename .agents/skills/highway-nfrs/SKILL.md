---
name: highway-nfrs
description: "Manages the repository-wide Non-Functional Requirement baseline; use it to add, update, remove, replace, or inspect NFRs."
usage: "Invoke as `/highway-nfrs` and state the NFR baseline change in plain language."
compatibility: all
metadata:
  version: 11.0.0
---

# highway-nfrs

## Purpose

Maintains the repository-wide Non-Functional Requirement baseline as user-owned records.

## Experience

User-visible interaction follows the Highway Experience Standard.

## Response Support Text

Use the support text that matches the active interaction. Keep the Validation Question as the only emphasized element in an NFR review.

**Validation Question**

**What would you add, correct, or remove?**

A sharper question may replace it when it still invites correction rather than agreement.

**Acceptance Reassurance**

If this is accurate, just say so.

Use when reviewing an NFR proposal.

**Discovery Reassurance**

If you're not sure, just say "I don't know," and we'll work through it together.

Use when the person is originating unresolved operational expectation information without a grounded recommendation, interpretation, or Working Idea.

**Combined Reassurance**

If this is accurate, just say so. If you're not sure, just say "I don't know," and we'll work through it together.

Use when either confirming a grounded proposal or not knowing is reasonable.

**Recommendation Reassurance**

If none of these fit, feel free to suggest your own operational expectation.

Use whenever recommendations are presented. The user-authored path remains available and a recommendation never requires adoption.

**Additional Suggestions Reassurance**

If you'd like additional suggestions, just let me know.

Use after recommendations, captured NFRs, portfolio assessments, or other active collection steps when future recommendation support remains available.

## Recommendation Development

Recommendations are grounded in accepted Profile evidence, accepted Objectives, accepted Controls, and existing NFRs. Control context remains recommendation context and informs NFR recommendations without transferring Control ownership or creating candidate state. When useful accepted context supports an operational expectation, offer a grounded recommendation before asking an unnecessary question and keep the user-authored path available.

Recommendations remain Working Ideas until accepted.

### Control-Informed Recommendations

Every accepted Control should be evaluated as a potential source of NFR recommendations.

Accepted Controls may strongly influence NFR recommendations. Controls remain recommendation context.

Controls participate in recommendation generation.

Controls do not create NFRs.
Controls do not capture NFRs.
Controls do not transfer ownership.
Controls do not create candidate state.

Control influence is recommendation-oriented, not lifecycle-oriented.
The NFR owner develops, accepts, captures, and persists NFRs independently.
Control relationships improve recommendation quality, not ownership.

```text
Control
↓
Recommendation
```

Control influence does not mean:

```text
Control
↓
Automatic NFR
```

Examples:

```text
Protect Sensitive Information
↓
Encrypt Sensitive Data At Rest

Require MFA
↓
Administrative Authentication Expectations

Maintain Audit Logging
↓
Audit Retention Expectations
```

## NFR Coverage Areas

NFR Coverage Areas exist to improve recommendation coverage and diversity. They remain recommendation guidance only: never expose them to the user, persist them, classify NFR records by them, or make readiness depend on them.

### Coverage Principle

Accepted context may reveal operational expectations, but useful NFRs may not be visible in that context alone. Coverage areas surface commonly useful expectation areas without asserting that a gap or problem exists.

### Reliability

- Prevent data loss
- Recover gracefully from failure
- Maintain operational continuity

Potential recommendations:

- Recover Critical Data Within 4 Hours
- Prevent Data Loss During Service Failure
- Restore Operations Within One Business Day

### Availability

- Remain available during expected usage
- Minimize downtime
- Support critical operating periods

Potential recommendations:

- Maintain 99.9% Availability
- Limit Planned Downtime
- Support Core Operational Hours

### Performance

- Response time expectations
- Throughput expectations
- Processing expectations

Potential recommendations:

- Dashboard Loads Within 2 Seconds
- Transactions Complete Within 5 Seconds
- Support Expected Throughput

### Scalability

- Growth expectations
- Capacity expectations
- Expansion expectations

Potential recommendations:

- Support Growth Without Major Redesign
- Accommodate Seasonal Demand
- Scale User Capacity

### Security

- Protection expectations
- Access expectations
- Integrity expectations

Potential recommendations:

- Encrypt Sensitive Data At Rest
- Encrypt Sensitive Data In Transit
- Audit Sensitive Data Access

### Compliance

- Auditability
- Retention
- Regulatory requirements

Potential recommendations:

- Retain Audit Records For One Year
- Support Compliance Reporting
- Maintain Traceable Operational Evidence

### Maintainability

- Ease of change
- Operational simplicity
- Complexity management

Potential recommendations:

- Reduce Operational Complexity
- Simplify Change Management
- Support Independent Component Updates

### Operability

- Monitoring
- Diagnostics
- Alerting
- Troubleshooting

Potential recommendations:

- Maintain Operational Monitoring
- Alert On Critical Failures
- Provide Diagnostic Logging

## Recommendation Generation

When possible, adapt recommendations to accepted Profile evidence, accepted Objectives, accepted Controls, and existing NFRs rather than presenting generic labels.

When generating recommendations:

1. Generate context-grounded recommendations first.
2. Evaluate recommendation coverage across the eight NFR Coverage Areas.
3. Determine whether meaningful coverage gaps exist.
4. When useful coverage gaps exist, generate one or more area-informed recommendations.
5. Present all recommendations together as one unified recommendation set.

Do not expose coverage areas, recommendation source, or internal coverage evaluation.

## Coverage Evaluation

Before presenting recommendations, evaluate whether accepted NFRs are concentrated in one operational area or whether meaningful gaps, overlap, or duplication exist. The purpose is recommendation coverage rather than recommendation volume. Do not manufacture recommendations simply to satisfy every area.

## Recommendation Presentation

Keep the **NFR** as the primary conversational anchor. When multiple recommendations are presented, use visually distinct bullets with concise operational expectation titles, short descriptions, and obvious distinctions. Support selecting one, several, or all recommendations, modifying them before adoption, providing a user-authored NFR, and requesting additional suggestions.

#### Illustrative Recommendation Presentation Example

```text
Based on your accepted context,
these operational expectations
appear most relevant:

- Encrypt Sensitive Information At Rest
  Sensitive information remains encrypted while stored.

- Encrypt Sensitive Information In Transit
  Sensitive information remains encrypted during transmission.

- Audit Sensitive Information Access
  Access to sensitive information remains auditable.

- Recover Sensitive Information Within 4 Hours
  Sensitive information can be recovered within four hours of disruption.

- Maintain Operational Monitoring
  Critical operational conditions are continuously monitored.

Would you like to select one,
several,
or all of these expectations,
modify any of them,
or provide your own?

If none fit,
feel free to suggest your own.

If you'd like additional suggestions,
just let me know.
```

## Recommendation Exploration

Recommendation Exploration, Queue Construction, and review of selected NFRs are separate phases.

```text
Recommendation Exploration
↓
Queue Construction
↓
Review of selected NFRs
```

Review of selected NFRs begins only when:

- recommendation exploration is exhausted; or
- the person explicitly requests review of the selected NFRs.

Examples of explicit review requests include:

```text
Review the selected NFRs.

Let's review these NFRs.
```

Recommendation selection alone does not begin review.

Recommendation exhaustion occurs when:

- no useful grounded non-duplicate recommendation remains; or
- remaining recommendations would primarily repeat existing coverage, overlap accepted NFRs, or restate already queued recommendations.

Recommendation exploration continues while:

- useful grounded recommendations remain;
- the user requests additional suggestions;
- the user continues selecting recommendations.

Selecting recommendations does not begin review. Selecting recommendations continues
recommendation exploration and queue construction. Recommendation exploration remains active after
recommendation selection. Selection alone does not begin proposal development. The queue may continue growing while recommendation exploration remains active.

Selecting recommendations expands the active queue.

Selection does not end recommendation exploration.

Recommendation exploration ends when:

- recommendation exhaustion occurs;
- the user provides an NFR;
- the person explicitly requests review of the selected NFRs.

A user-provided NFR follows the same proposal and acceptance path; it does not silently review the selected NFRs.

Recommendations currently under evaluation are not queue members.

Queued recommendations are recommendations the person has selected.

Only queued recommendations are eligible for queue processing.

If no useful grounded recommendations exist, ask: **Are there any qualities or operational expectations you'd like future solutions to meet?**

Once queue processing begins, recommendation exploration is closed. Do not return to recommendation generation until queue processing is complete.

#### Illustrative Recommendation Exploration Example

```text
Recommendations:

- Encrypt Sensitive Data At Rest
- Encrypt Sensitive Data In Transit
- Maintain Auditability
- Operational Monitoring

User:
Select all.

Owner:
The selected recommendations are added
to the active NFR queue.

Recommendation exploration remains active.

Queue processing has not started.

Additional Recommendations:

- Recovery Time Expectation
- Recovery Point Expectation

User:
Select both.
```

The queue now contains six recommendations.

Recommendation exploration remains active.

Queue processing has not started.

## Additional Suggestions

When a person requests additional suggestions, evaluate accepted Profile evidence, accepted Objectives, accepted Controls, and the current NFR portfolio. Additional suggestions may come from unaddressed accepted context, coverage gaps, or meaningful overlap and gaps in accepted NFRs. If no useful grounded non-duplicate suggestion remains, say so rather than manufacturing one.

## Recommendation Boundaries

NFR Coverage Areas:

- recommend;
- illuminate coverage gaps;
- improve recommendation diversity.

NFR Coverage Areas do not:

- establish accepted NFRs;
- establish organizational facts;
- establish readiness requirements;
- establish lifecycle stages;
- change NFR ownership.

Recommended NFRs remain Working Ideas until accepted.

## NFR Development Lifecycle

Every NFR follows the same development lifecycle:

```text
Recommendation Selected or User Provided NFR
↓
Present Converged NFR proposal
↓
User Acceptance
↓
Capture
↓
Next NFR
```

A Converged NFR proposal contains a title, operational expectation statement, and synthesized rationale. The owner should develop a complete first-pass proposal whenever accepted context reasonably supports one. Discovery remains the exception path when evidence cannot support a responsible proposal or consequential ambiguity remains unresolved.

When presenting a materially interpreted proposal:

**Here's what I've captured as your NFR:**

**Title:**
[NFR title]

**Statement:**
[Operational expectation]

**Why it matters:**
[Rationale]

**What would you add, correct, or remove?**

If this is accurate, just say so.

Only an explicitly accepted proposal may proceed to capture. Rejected, corrected, replaced, cancelled, abandoned, or interrupted proposals remain transient and write no record. A direct, complete user-authored NFR may use the short path only when no material interpretation is needed. When classification is ambiguous, distinguish a desired quality or operational outcome from an enforceable, auditable, or checkable safeguard.

## NFR Queue And Acceptance Boundaries

Selection does not capture. Explicitly selected recommendations enter the active NFR queue. Queue membership determines development order only; it is not NFR capture.

Queue membership is not NFR capture.

Queue membership does not allocate identifiers.

Queue membership does not mutate records.

Capture requires a presented Converged NFR proposal and the person's acceptance.

The owner MUST NOT transition directly from recommendation selection to NFR capture.

Selected recommendations enter the active development queue and are never captured directly. Material revision invalidates prior acceptance and requires a new correction or acceptance opportunity.

#### Illustrative Queue Interaction

```text
User:

Select all.

Owner:
The selected recommendations are added
to the active NFR queue.

The queued recommendations remain
unreviewed Working Ideas until review begins.

Queue membership does not:

- capture NFRs
- allocate identifiers
- update records
- update relationships

Recommendation exploration remains active.
```

## Interpretation Confidence

Prefer a grounded operational expectation that can be corrected over a missing interpretation that forces the person to create it from scratch.

When accepted evidence supports a useful expectation, implication, relationship, distinction, or Working Idea, do not ask a question that merely seeks permission to express it.

## NFR Contribution Guidance

When accepted context and the NFR portfolio support a useful contribution, reveal one grounded observation at a time before asking an unnecessary exploratory question. Contribution types may include overlap, duplication, coverage, dependencies, operational implications, monitoring implications, recovery implications, and performance implications. Do not manufacture one when accepted evidence does not support it. Keep recommendations provisional and the user-authored path available.

## NFR Portfolio Assessment Guidance

After multiple NFRs are accepted, provide a concise advisory assessment when useful. **Portfolio assessment is advisory** and may describe overlap, duplication, coverage, dependencies, gaps, tensions, operational implications, monitoring implications, recovery implications, or performance implications. It does not reject NFRs, force completion, block additional NFRs, mutate the baseline, or replace the person's authority.

After an NFR is captured, the owner may provide a brief synthesis of the accepted NFR set. The synthesis should describe current coverage, explain how the newly accepted NFR fits within the portfolio, remain concise, and avoid repeating the full contents of accepted NFRs. The synthesis is advisory, creates no lifecycle state or durable portfolio artifact, and is not a second review, proposal, or recommendation set.

#### Illustrative Post-Capture Continuity Examples

Queue Transition:

```text
Your accepted NFRs now establish
security and recoverability expectations.

Next we'll develop
Operational Monitoring.
```

Collection Transition:

```text
Your accepted NFRs now provide
coverage across security,
reliability,
and recoverability.

If you'd like additional suggestions,
just let me know.

Is there another operational expectation
you'd like to establish?
```

Setup Transition:

```text
Your accepted NFRs now define
the operational expectations future
solutions should meet.

Your foundational Highway context
is now in place.
```

## When to use

Use this skill to set up, configure, inspect, add, create, update, remove, replace, reset, or assess the repository-wide NFR baseline. Use `setup` or `configure` to collect NFRs until the user explicitly finishes. Direct `add` is a single-NFR operation. Use `readiness` for a read-only owner assessment.

## When not to use

Do not use this skill for a specific enforceable, auditable, or checkable safeguard; route it to `/highway-controls`. Do not edit records or generated catalogs directly.

## Inputs

Runtime dependencies are:

- the project root located from `.highway/`;
- authoritative NFR artifacts at `library/governance/nfrs/NFRXXXXXX.md` and `library/governance/nfrs.md`;
- shared output templates at `.highway/library/templates/output/nfr-record.md` and `.highway/library/templates/output/nfr-catalog.md`;
- the Highway Experience Standard at `.highway/governance/experience-standard.md`;
- `.highway/library/knowledge/highway-identity.md` for behavioral framing;
- `.highway/library/knowledge/highway-vision.md` for strategic direction;
- `.highway/library/knowledge/highway-platform-objectives.md` for evaluation criteria;
- `.highway/library/knowledge/profile.md` for accepted organizational context;
- accepted Business Objective records and catalog as recommendation and operational-context inputs;
- accepted Control records and catalog as optional context and relationship inputs;
- existing accepted NFR records and catalog as reuse, duplicate, overlap, and recommendation context;
- the `/highway-setup` owner contract at `.highway/skills/highway-setup/SKILL.md` for setup/configure collection completion;
- the active user request and active interaction evidence;
- the `/highway-controls` owner contract at `.highway/skills/highway-controls/SKILL.md` for the independent Control ownership boundary;
- the `/highway-relationships` owner contract at `.highway/skills/highway-relationships/SKILL.md`, its impact analysis, and its authoritative impact result for destructive NFR mutations.

Recommendations may use accepted Profile, Objectives, Controls, and existing NFRs. Control benchmark grounding does not itself establish benchmark applicability for an NFR. Controls and NFRs are independent owners. NFRs are independently managed NFRs and own classification, records and identifiers, the catalog, Control relationships, readiness, and collection completion. NFR work does not require a Control identifier, Control capture transaction, or upstream lifecycle result.

## Outputs

NFR readiness is owner-controlled and separate from collection completion:

```text
Status: Complete|Missing|Blocked
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

- `Missing`: no accepted NFRs or valid NFR artifacts exist.
- `Complete`: accepted valid NFR artifacts exist.
- `Blocked`: required NFR records, catalog, or allocation state is malformed, unavailable, or inconsistent.

Setup/configure separately returns exactly:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Continue` means collection remains active; `Finished` requires explicit user finish intent. The finished result is `Collection Result: Finished`; it does not include a created-NFR-ID list. Readiness is independent of Control collection and does not inspect upstream collection state without requiring Control-originated state.

## Action Selection

Classify the action and authoritative NFR baseline. Accept exactly these actions: `setup`, `configure`, `view`, `show`, `describe`, `readiness`, `add`, `new`, `update`, `remove`, and `reset`. `view`, `show`, and `describe` are equivalent read-only actions. `setup`, `configure`, `add`, and `new` are guided creation workflows. If the request contains an unsupported or ambiguous action, stop and ask the user to clarify. Do not infer an action and do not write any file.

## Read-Only Workflow

For `view`, `show`, `describe`, or `readiness`, inspect the authoritative NFR baseline without writing records, catalogs, identifiers, relationships, queue state, or proposals. Report readiness as Missing, Complete, or Blocked and keep readiness independent of Control collection.

## Creation Workflow

For `setup` and `configure`, Creation Workflow orchestrates Recommendation Presentation, Recommendation Exploration, review of selected NFRs, the NFR Development Lifecycle, continuation, and explicit finish. It uses the canonical no-recommendation question when useful grounded recommendations cannot be supported and does not manufacture a recommendation.

Recommendation selection continues queue construction. Recommendation exploration may continue across multiple recommendation sets before review begins. Collection Result: Continue does not require review to have started.

Process each selected NFR through proposal and acceptance, capture accepted NFRs atomically, and continue until explicit finish. For `add` or `new`, develop and capture one accepted NFR, then terminate. A user-provided NFR follows the same proposal, acceptance, capture, and relationship validation rules as a selected recommendation.

## Update Workflow

For `update`, identify the target, preserve its identifier and accepted content unless the user authorizes a change, develop the amendment through the applicable proposal and acceptance boundary, revalidate duplicates, overlap, relationships, and allocation state, then update record and catalog atomically.

## Destructive Workflow

For `remove` or `reset`, identify the affected NFR records and relationships, obtain explicit Experience Standard confirmation naming what will be lost, obtain authoritative relationship impact, validate the baseline and allocation state, then apply the destructive mutation atomically. If confirmation, impact, or validation is unavailable, stop without mutation.

## Baseline Invariants And Transactions

Before mutation, validate the authoritative baseline, allocation state, duplicate/overlap state, and relationship impact. Allocate permanent non-reused identifiers, update record/catalog/relationships atomically as one transaction, generate deterministic catalog output, preserve semantic version behavior, and apply destructive safeguards. Direct user-authored NFR creation uses `controls: []`; retained relationships remain unchanged unless a user-authorized NFR mutation requests a change. Relationship updates remain within the existing Control/NFR ownership boundary. No post-write persistence verification is required.

## Verification

Verify that NFR records and the catalog follow their shared templates; readiness preserves Missing, Complete, and Blocked; collection completion remains separate; no Control-originated state is required; grounded recommendations are offered before unnecessary questions; NFR Coverage Areas remain internal; recommendation exploration, queue construction, and queue processing remain distinct; recommendation exploration freezes during queue processing; queue membership does not capture, allocate identifiers, or mutate records; each captured NFR has a Converged NFR proposal and crosses explicit acceptance; corrections, rejection, and abandonment write nothing; portfolio assessment is advisory; classification remains transient; direct NFRs use `controls: []`; retained relationships remain unchanged unless user-authorized; duplicate handling, identifiers, deterministic catalogs, atomic persistence, and destructive safeguards remain intact; no post-write verification or duplicated Constitution, Experience Standard, or development-governance rules remain.

## Error Handling

Rely on the Constitution common failure model. NFR-specific exceptions are:

- malformed NFR record, catalog, or allocation state: `Blocked` without mutation;
- unavailable upstream Control context does not block independent NFR work;
- unavailable recommendation context does not block user-authored NFR work;
- an empty queue or exhausted recommendations do not capture anything implicitly;
- unresolved update/remove target: stop and identify the target;
- Control-shaped evidence routes to `/highway-controls`; unresolved NFR-versus-Control classification: ask the bounded classification question;
- destructive Remove/Set: use Experience Standard confirmation;
- unavailable relationship impact for a destructive action: stop without mutation and write nothing.

## Example

For `setup`, offer grounded recommendations or ask the fallback question when no useful grounding exists. Add selected items to the ordered NFR queue, close recommendation exploration when queue processing begins, and process items one at a time through a Converged NFR proposal and explicit acceptance. Persist each accepted decision before proceeding, then return advisory portfolio assessment, continuation support, and the separate collection result and owner readiness result.

