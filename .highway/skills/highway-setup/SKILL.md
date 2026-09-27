---
name: highway-setup
description: "Orchestrates initial Highway setup through the owning governance skills."
usage: "Invoke as `/highway-setup` to assess readiness and complete missing foundational setup in order."
compatibility: all
metadata:
  version: 7.0.0
---

## highway-setup

## Purpose

Routes setup through Profile, Objectives, Controls, and NFR owners while preserving owner boundaries; orchestration only.

## When to use

Use this skill to assess readiness, continue initial setup, or resume at the first incomplete owner.

## When not to use

Do not use this skill to directly create, update, remove, replace, or repair an owner artifact.

## Inputs

Setup evaluates owner readiness in this order:

- Profile readiness;
- Objectives readiness;
- Controls readiness;
- NFR readiness.

- Project root found by locating `.highway/`.
- `/highway-profile readiness` and its four-line response contract.
- `/highway-objectives readiness`.
- `/highway-controls readiness`.
- `.highway/governance/experience-standard.md` as the authoritative user-visible interaction contract.
- `/highway-nfrs readiness` and its declared readiness response contract.
- The NFR-owner `Next Action` returned for `In Progress`.
- The delegated NFR owner result that Setup consumes before advancement.
- The Controls Action Result contract: `Action Status`, `Collection Result`, `Created Control IDs`, `Next Action`, and `Blocking Reason`.
- Controls Action Result:
  - `Action Status: Succeeded|Declined|Aborted|Blocked`
  - `Collection Result: Continue|Finished`
  - `Created Control IDs: [CTLXXXXXX, ...]`
  - `Next Action: <owner route or None>`
  - `Blocking Reason: <reason or None>`
- Controls Readiness Result:
  - `Status: Complete|Missing|Blocked`
  - `Summary: <Control baseline explanation>`
  - `Next Action: <owner route or None>`
  - `Blocking Reason: <reason or None>`
- Owner-provided next questions, summaries, next actions, and blocking reasons.

Setup validates the field order and accepted values before consuming either Controls result.

## Outputs

When input is required, Setup emits a welcome or resume greeting, the active owner introduction, and
exactly one owner question. Setup preserves owner output and ordering. Applicable multi-owner progress
 names the current owner activity and the number of owners completed and remaining without exposing routing
 or validation mechanics. Successful completion emits exactly this conclusion:

```text
**Your foundational Highway context is now in place.**

Highway understands more about your organization, what you're trying to accomplish, the safeguards that should guide future decisions, and the operational expectations those decisions may need to satisfy.

**This is where Highway starts becoming more useful.**
The context you've established can help Highway make future guidance more relevant, connect decisions back to your objectives and governance, and build on what it already knows instead of starting over each time.

**Where would you like to go next?**
Run `/highway-help` to explore what Highway can help you do.
```

The conclusion is emitted only after Workflow Step 27 establishes that every required owner returned the
terminal result required by its owner contract. Blocked, incomplete, malformed, declined, aborted, failed,
or explicit status requests emit actionable owner context without fabricating completion. Setup offers
`/highway-help` without invoking it.

For the Objective handoff, Setup owns only this purpose introduction:

**Setup-owned**:

> **Let's identify some explicit outcomes worth pursuing.**
>
> These give Highway something concrete to connect future decisions back to and help us evaluate whether you're accomplishing what you set out to do.

Setup emits it exactly once, immediately before delegating `/highway-objectives setup`, and only when
Profile is terminal-success and Objective readiness is non-terminal with `Next Action:
/highway-objectives setup`. Objectives owns and supplies this complete opening:

**Objectives-owned**:

> **What's an important outcome you'd like to achieve?**
>
> If you'd like some suggestions based on your organization's Profile, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

Setup renders the owner opening unchanged and forwards every subsequent Objective question, decision,
error, and result without interpreting or rewriting it. Setup does not ask Objective questions,
interpret Objective evidence, allocate identifiers, write Objective artifacts, or persist a draft.

### Controls handoff

**Setup-owned:**

> **We've identified what you're trying to accomplish. Now let's think about what needs to be true as you pursue those outcomes.**
>
> Highway can use what you've already shared to help identify conditions and safeguards that should guide future decisions.

Setup emits this transition exactly once immediately before delegating `/highway-controls setup`, and
only after Objectives reaches fresh terminal success, the pre-delegation Controls readiness result is
`Missing` with `Next Action: /highway-controls setup`, and active Setup orchestration requires Controls
setup. A pre-delegation `Complete` result skips the transition and Controls discovery. A pre-delegation
`Blocked` result stops Setup and does not emit the transition. Only `Missing` with the declared setup
route emits it. When Controls begins collection without usable active Control evidence, Controls owns and
Setup renders this complete opening unchanged immediately after the transition:

> **What concerns should future technology decisions take into account?**
>
> For example, you might care about protecting information, controlling access, managing changes, keeping important services available, or meeting an existing obligation.
>
> If you'd like some suggestions based on what Highway already knows, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

Controls owns every subsequent question, acknowledgment, suggestion, proposal, decision, result, and error.
Setup renders Controls-owned interaction unchanged and does not author a Controls discovery question.

### Controls-to-NFR handoff

**Setup-owned:**

> **We've established the safeguards that should guide future technology decisions. Now let's consider what those decisions need to achieve in operation.**
>
> Based on the Controls we've defined, Highway may already have identified qualities or operational outcomes worth considering.

After either pre-delegation Controls readiness `Complete` or fresh Controls readiness `Complete` following
an explicit Controls `Finished` result, Setup requests NFR readiness. If that readiness is `In Progress`
with an owner-provided `Next Action` that requires user input, Setup emits this transition exactly once
immediately before delegating that action to `/highway-nfrs`. A terminal NFR result with `Next Action: None`
does not require interaction, so Setup emits neither the transition nor a manufactured NFR interaction.
Setup does not emit the transition for Controls `Continue`, fresh Controls `Missing` or `Blocked`, direct
`/highway-nfrs` invocation, or resumed NFR work.

## Workflow

1. Locate `.highway/`; stop if it cannot be found.
2. After Step 1, request the active owner's four-field readiness response and validate its field order, status, action vocabulary, and blocking-reason consistency.
3. After Step 2, advance immediately only when the owner returns its declared terminal-success status.
4. After Step 3 during active orchestration, delegate a supported owner `Next Action`; on readiness or status-only requests, report it without initiating collection.
5. After Step 4, consume the delegated action result; after verified completion, request that owner's readiness again and advance only from the fresh terminal result.
6. After Step 5, stop on Blocked, malformed, unknown, declined, aborted, or failed owner results and report the owner's context without invoking a later owner.
7. After Step 6 permits continuation, request Profile readiness and advance only from its declared terminal result.
8. After Step 7 returns Profile terminal success, request Objective readiness and evaluate it in this order: if `Complete`, skip the Objective introduction and discovery and continue toward Controls readiness; if `Missing` with the Objective owner's declared setup/configure `Next Action`, emit the Setup-owned purpose introduction exactly once, delegate only the owner-provided Objective action, render Objective-owned interaction unchanged, and after verified Objective completion request fresh Objective readiness before Step 9; if `Blocked`, stop Setup and report the Objective-owner blocking context without invoking a later owner; otherwise treat the result as malformed and follow the declared malformed-owner-result error path. Do not restore transient state.
9. After Step 8 produces fresh Objective terminal success, request `/highway-controls readiness` before any Controls delegation.
10. After Step 9 returns pre-delegation Controls readiness `Complete`, skip the Controls transition and discovery, then fall back to Step 22.
11. After Step 9 returns pre-delegation Controls readiness `Blocked`, stop Setup and report the Controls owner's context.
12. After Step 9 returns pre-delegation Controls readiness `Missing` with `Next Action: /highway-controls setup`, emit the exact Setup-owned Controls transition once.
13. After Step 12, delegate `/highway-controls setup`.
14. After Step 13, render Controls-owned user-visible interaction unchanged.
15. After Step 13 and before using Controls readiness for advancement, consume every Controls Action Result; validate its field order and accepted values first.
16. After Step 15, if the Controls Action Result has `Action Status: Declined`, `Aborted`, or `Blocked`, stop Setup according to that owner result.
17. After Step 15 returns `Action Status: Succeeded` and `Collection Result: Continue`, fall back to Step 14 and remain with Controls.
18. While Step 17 remains active, do not treat Controls readiness `Complete` as collection completion.
19. After Step 15 returns `Action Status: Succeeded` and `Collection Result: Finished`, request fresh `/highway-controls readiness`.
20. After Step 19 returns fresh Controls readiness `Missing`, fall back to Step 13 as a New interaction, regardless of `Created Control IDs`; a zero-Control result with `Created Control IDs: []` remains at Controls and does not invoke NFR review or claim completion.
21. After Step 19 returns fresh Controls readiness `Blocked`, stop without invoking NFRs and report the Controls owner's context.
22. After Step 10 receives pre-delegation Controls readiness `Complete`, or after Step 19 returns fresh Controls readiness `Complete`, request `/highway-nfrs readiness` and evaluate the result at Step 23.
23. After Step 22, evaluate NFR readiness; if it is `In Progress` with an owner-provided `Next Action` that requires user input, emit the exact Setup-owned Controls-to-NFR transition once before the first NFR-owned interaction, then fall back to Step 4 and delegate that declared owner action. If the owner returns a terminal result with `Next Action: None`, do not manufacture an interaction or emit the transition.
24. After Step 22 returns NFR readiness `Blocked`, stop Setup and report the NFR owner's context.
25. After Step 22 returns NFR `Not Applicable` or the NFR owner's declared successful terminal state, treat it as terminal according to the NFR contract without manufacturing an interaction.
26. After Step 25 returns a terminal result, verify that every required owner has returned the terminal result required by its contract; otherwise stop without claiming completion.
27. After Step 26 passes, emit the exact forward-looking Setup conclusion once. Do not emit the former completion dashboard or its Profile, Business Objectives, Controls, or NFR summary fields.
28. On a New interaction after any prior step, re-read persisted readiness and resume at the first incomplete owner. Never restore an unanswered question, draft response, cancellation marker, Setup checkpoint, transient Controls discovery state, or the non-persisted handoff transition.

### Controls orchestration state

`Collection Result: Continue` means Controls still owns the active collection. `Collection Result: Finished`
means the user explicitly ended the Controls collection. Controls readiness `Complete` means the persisted
Control baseline is usable; it does not mean the active collection finished. `Continue` remains non-terminal
even when readiness becomes `Complete`, and `Finished` does not imply readiness `Complete`. After Controls
delegation, readiness never substitutes for the delegated Controls Action Result. A first accepted Control
may make readiness `Complete` while collection remains `Continue`; Setup remains with Controls until
`Finished`. A zero-Control `Finished` result followed by readiness `Missing` remains at Controls and does
not infer a Controls `Not Applicable` state.

## Error Handling

| Step | Failure condition | Action |
|---|---|---|
| 1 | The required project-root input is absent, unresolved, or self-contradictory | escalate to obtain the project root before continuing |
| 1 | A supplied project root resolves, but the required `.highway/` structure is absent from that root | abort and report that supplied project root as unusable |
| 2 | The readiness response is missing, reordered, duplicated, or invalid | abort with Blocked |
| 3 | The declared terminal-success status cannot be determined from the consumed owner result | abort with Blocked |
| 4 | The owner action is unsupported during active orchestration | abort with Blocked |
| 5 | The delegated action does not report verified completion | abort and preserve owner bytes |
| 6 | The owner result is Blocked, malformed, unknown, declined, aborted, or failed | abort without invoking a later owner |
| 7 | Profile readiness cannot be consumed after the Profile route is selected | abort with Blocked |
| 8 | Objectives readiness or its delegated result cannot be consumed after Profile terminal success | abort with Blocked |
| 9 | Fresh Objective terminal success cannot be established before requesting Controls readiness | abort with Blocked |
| 10 | Setup cannot continue to the declared NFR-readiness step after valid pre-delegation Controls `Complete` | abort with Blocked |
| 11 | A pre-delegation Controls `Blocked` result cannot be reported without invoking a later owner | abort with Blocked |
| 12 | Controls readiness is `Missing` but the declared `/highway-controls setup` route cannot be delegated | abort with Blocked |
| 13 | The `/highway-controls setup` owner route is unsupported after Step 12 | abort with Blocked |
| 14 | Controls interaction is unavailable after delegation | abort and preserve owner bytes |
| 15 | Controls Action Result is malformed or invalid | abort with Blocked and do not invoke a later owner |
| 16 | Controls Action Result has `Action Status: Declined` | abort and preserve owner bytes |
| 16 | Controls Action Result has `Action Status: Aborted` | abort and preserve owner bytes |
| 16 | Controls Action Result has `Action Status: Blocked` | abort and report the owner-provided Blocking Reason |
| 17 | Controls returns `Continue` but the active Controls interaction cannot continue | abort and preserve owner bytes |
| 18 | Setup attempts to advance beyond Controls because the active Controls Action Result remains `Collection Result: Continue` | abort without invoking a later owner |
| 19 | Fresh Controls readiness cannot be requested after `Finished` | abort with Blocked |
| 20 | Fresh Controls readiness is `Missing` but a New interaction cannot be delegated through the declared Controls setup route | abort with Blocked |
| 21 | Fresh Controls readiness is `Blocked` but its owner context cannot be reported without invoking NFRs | abort without invoking NFRs |
| 22 | NFR readiness cannot be requested after fresh Controls `Complete` | abort with Blocked |
| 23 | NFR readiness is `In Progress` but its declared owner review action cannot be delegated | abort with Blocked |
| 24 | NFR readiness is `Blocked` but its owner context cannot be reported without advancing beyond NFRs | abort without advancing beyond NFRs |
| 25 | A declared terminal NFR result cannot be consumed without contradicting the NFR owner contract | abort with Blocked |
| 26 | Any required owner lacks, fails, or returns an invalid terminal result | abort without claiming completion |
| 27 | A successful completion claim would not be supported by every required owner contract | abort without emitting the conclusion |
| 28 | Persisted readiness cannot identify the first incomplete owner on a New interaction | abort and report the owner context |

For each owner-result decision, evaluate recognized states in the declared order and use an explicit
default. Profile Readiness is evaluated in the order declared by `/highway-profile`: recognized `Complete`,
recognized `Missing` with an owner-supported `Next Action`, recognized `Blocked`, then otherwise malformed
and `abort with Blocked`. Objective Readiness is evaluated in the order declared by `/highway-objectives`:
recognized `Complete`, recognized `Missing` with an owner-supported `Next Action`, recognized `Blocked`, then
otherwise malformed and `abort with Blocked`. Controls Readiness is evaluated as `Complete`, then `Missing`,
then `Blocked`, then otherwise malformed and `abort with Blocked`. Controls Action Result is evaluated as
invalid/malformed, then `Declined`, `Aborted`, `Blocked`, `Succeeded + Continue`, `Succeeded + Finished`,
then otherwise malformed and `abort with Blocked`. NFR Readiness is evaluated in the order declared by
`/highway-nfrs`, then otherwise treated as malformed and `abort with Blocked`. All owner-result decision
structures are evaluated in their declared order; identical owner results select the same branch every run.

## Profile routing

- **Profile `Status: Missing`, `Next Action: /highway-profile setup`**: During active orchestration, delegate `/highway-profile setup`.
- **Profile `Status: Missing`, `Next Action: /highway-profile configure`**: During active orchestration, delegate `/highway-profile configure`.
- **Profile `Status: Complete`, `Next Action: None`**: Continue to Objective readiness.
- **Profile `Status: Blocked`, `Next Action: None`**: Stop Setup and report the Profile-owner blocking context.
- **Otherwise**: Treat the result as malformed and follow the declared malformed-owner-result path.

Setup consumes the Profile owner's readiness contract and does not inspect Profile metadata, recompute
the five Profile domains, use the retired identity field, or write the Profile artifact. It does not
recompute owner readiness. Setup owns ordered routing, continuation, status, and the final conclusion only. Profile owns
organizational evidence, domain outcomes, readiness, and its artifact.

## Guided Setup interaction contract

During routine collection, do not expose readiness evaluation, owner selection, forwarding, routing,
artifact inspection, or implementation details. Use one unresolved owner question at a time. User Exits
are `pause`, `cancel`, and `stop responding`; Owner Outcomes are `declined`, `aborted`, and `blocked`.
Neither category advances Setup or creates persisted wizard state. `Resume Applicability: New interaction`.
Setup resume behavior: never restore an unanswered question, draft response, cancellation marker, hidden checkpoint,
Concern, Condition, Obligation, suggestion, proposal, continuation state, collection state, or collection
provenance from a prior Controls interaction.

## Interactive Workflow UX Contract

Setup applies the authoritative Interactive Workflow UX Contract in the Highway Experience Standard.
It emits only user-relevant owner context, questions, decisions, results, actionable errors, and
applicable progress unless the user requests implementation details.

## Verification

### Controls handoff contract

After fresh Objectives terminal success, Setup requests Controls readiness. If pre-delegation Controls
readiness is `Complete`, Setup skips the Controls transition and Controls discovery. If it is `Missing` with
`Next Action: /highway-controls setup`, Setup emits this Controls-purpose transition exactly once immediately
before delegating `/highway-controls setup`:

> **We've identified what you're trying to accomplish. Now let's think about what needs to be true as you pursue those outcomes.**
>
> Highway can use what you've already shared to help identify conditions and safeguards that should guide future decisions.

If pre-delegation Controls readiness is `Blocked`, Setup stops, reports the Controls-owner context, emits no
Controls transition, and invokes no later owner. Otherwise, Setup treats the readiness result as malformed
and follows the declared malformed-owner-result path without emitting the transition. The Controls-purpose
transition is Setup-owned. When no usable active Control evidence exists, verify that Setup renders the
following Controls-owned opening unchanged immediately after that transition:

> **What concerns should future technology decisions take into account?**
>
> For example, you might care about protecting information, controlling access, managing changes, keeping important services available, or meeting an existing obligation.
>
> If you'd like some suggestions based on what Highway already knows, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

Verify that Controls owns and Setup renders every subsequent question, acknowledgment, suggestion, proposal,
decision, error, and result unchanged. Setup consumes the Controls Action Result
before requesting fresh Controls readiness. Before delegation, pre-delegation `Complete` skips this
route. The action result uses `Action Status`, `Collection Result: Continue|Finished`, `Created Control IDs`,
`Next Action`, and `Blocking Reason` in that order; `Finished` is terminal only after explicit user intent.
The separate readiness result uses `Status: Complete|Missing|Blocked`, `Summary`, `Next Action`, and
`Blocking Reason` in that order. Setup validates both field orders and accepted values before consumption.
A `Continue` result is non-terminal even when fresh readiness is `Complete`. A zero-Control finish
includes `Created Control IDs: []`, leaves fresh readiness `Missing`, and does not claim Controls or Setup completion.

Confirm the emitted conclusion exactly follows the declared forward-looking contract and is emitted only
after Workflow Step 27's required terminal owner-result condition.

After either pre-delegation Controls readiness `Complete` or post-Finished fresh Controls readiness `Complete`,
verify that Setup emits this exact transition once immediately before the first NFR-owned interaction:

> **We've established the safeguards that should guide future technology decisions. Now let's consider what those decisions need to achieve in operation.**
> Based on the Controls we've defined, Highway may already have identified qualities or operational outcomes worth considering.

The transition is Setup-owned and is not emitted for Controls `Continue`, fresh `Missing` or `Blocked`,
direct `/highway-nfrs` invocation, resumed NFR work, or a terminal result without requiring interaction.
Verify that NFR-owned questions, recommendations, decisions, errors, and results remain unchanged.
After all required owners satisfy their contracts, verify that Setup emits the exact forward-looking
conclusion once, including the exact line "Run `/highway-help` to explore what Highway can help you do.",
without invoking the command or restoring any former dashboard fields.

After explicit `Finished` and fresh Controls readiness, Setup may route to NFR review only when NFR
readiness permits it. Candidate-generation `Blocked` keeps Setup stopped and does not advance through NFR review. Setup never treats a stale result or a fresh Controls readiness `Complete` as a substitute
for the delegated collection result. This is the stop-before-NFR-review behavior.

- Confirm Profile readiness is consumed verbatim and Setup never recomputes it.
- Confirm Setup advances Profile -> Objectives -> Controls -> NFRs only after terminal owner results.
- Confirm Complete Profile advances to Objectives and no Profile artifact is written by Setup.
- Confirm non-terminal Objective readiness causes the exact Setup-owned purpose introduction once,
  followed by the exact Objectives-owned opening once, with no Setup-authored Objective question.
- Confirm terminal Objective readiness skips the purpose introduction and Objective discovery before
  Controls routing.
- Confirm Objective `Complete` skips discovery, Objective `Missing` delegates only its owner-provided route,
  Objective `Blocked` stops without invoking later owners, and malformed Objective results follow the
  malformed-owner-result path.
- Confirm Profile routing consumes only the Profile owner result: `Missing` delegates the owner-provided
  setup or configure route, `Complete` advances, `Blocked` stops, and malformed results follow the
  malformed-owner-result path. Confirm Setup does not independently classify Profile repository state.
- Confirm Objective answers, owner questions, decisions, failures, and completion results are
  forwarded unchanged and Setup writes no Objective artifact or transient state.
- Confirm interruption preserves owner artifacts and creates no Setup checkpoint.
- Confirm malformed and unknown owner responses produce Blocked without invoking later owners.
- Confirm owner mutations originate from the owning workflow.
- Confirm multi-owner progress names the current owner activity and completed/remaining owner counts
  without exposing routing or validation mechanics.
- Confirm fresh Objective terminal success precedes Controls readiness; pre-delegation `Complete` skips the
  transition and discovery and proceeds to NFR readiness, `Missing` with `Next Action: /highway-controls setup`
  emits the transition once and routes to setup, `Blocked` stops without emitting the transition or invoking a
  later owner, and any other result follows the malformed-owner-result path without emitting the transition.
- Confirm the Controls-owned opening and every subsequent Controls-owned question, acknowledgment,
  suggestion, proposal, decision, error, and result are rendered unchanged; Setup authors no Controls question.
- Confirm Controls Action Results are validated and consumed before fresh readiness, with exact field order,
  `Continue` non-terminal even after readiness becomes `Complete`, and `Finished` triggering fresh readiness.
- Confirm NFR readiness is requested after either pre-delegation Controls `Complete` or post-`Finished` fresh
  Controls `Complete`, without requiring the skipped Controls delegation steps in the former path.
- Confirm zero-Control `Finished` followed by readiness `Missing` remains at Controls without NFR review or
  completion claims; `Finished` followed by readiness `Complete` permits NFR readiness evaluation.
- Confirm declined, aborted, blocked, malformed, and failed-persistence results do not invoke later owners.
- Confirm Setup does not inspect candidate contents, candidate counts, NFR records, relationships, or
  `Created Control IDs` to derive NFR readiness or completion; it consumes the NFR owner's result.
- Confirm NFR `Blocked` stops Setup, `In Progress` delegates owner review, and `Not Applicable` is terminal
  according to the NFR contract.
- Confirm failed Controls creation or retained-output verification yields no completed Control baseline, a
  non-success owner result, no `Controls: Complete`, and no successful Setup conclusion claim.
- Confirm Setup writes no Control or NFR owner artifacts and restores no transient Controls state.

## Example

`/highway-setup`
