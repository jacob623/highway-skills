# Feature Specification: Readiness Ownership Refactor

**Feature Branch**: `037-readiness-ownership-refactor`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Move readiness determination into the owning skills and make `/highway-setup` consume readiness instead of implementing completeness rules directly."

## Clarifications

### Session 2026-09-10

- Q: When NFR candidates exist but none have been accepted, should NFR readiness always return `In Progress`? → A: Always return `In Progress` whenever candidates exist but none are accepted.

## User Scenarios & Testing

### User Story 1 - Query owner readiness consistently (Priority: P1)

As a Highway maintainer, I want Profile, Objectives, Controls, and NFRs to expose a read-only readiness result so that each artifact's owner determines whether that artifact is ready and what action is appropriate next.

**Why this priority**: Ownership is the foundation of correct routing. Without a consistent owner response, Setup cannot become a pure orchestrator and downstream workflows can make conflicting completeness decisions.

**Independent Test**: Evaluate each owner skill against complete, missing, in-progress, blocked, and not-applicable states where applicable; verify the same four-field response shape, allowed status values, correct summary, next action, and blocking reason behavior.

**Acceptance Scenarios**:

1. **Given** any owner skill and a readiness request, **When** readiness is evaluated, **Then** it emits exactly `Status`, `Summary`, `Next Action`, and `Blocking Reason` fields and performs no writes or identifier allocation.
2. **Given** a valid Profile with a supplied organization name, valid Objective and Control baselines, or accepted NFR artifacts, **When** the owning readiness request is evaluated, **Then** it returns `Complete` with `Next Action: None` and `Blocking Reason: None`.
3. **Given** missing, malformed, pending, or zero-candidate owner state, **When** readiness is evaluated, **Then** it returns the defined owner status without starting a mutation workflow.

---

### User Story 2 - Keep readiness rules with the owning artifacts (Priority: P1)

As a Highway maintainer, I want each owner skill to define its own readiness rules so that changes to Profile, Objectives, Controls, or NFR artifacts do not require duplicated completeness logic in Setup.

**Why this priority**: Duplicated rules are the source of conflicting status decisions and make ownership boundaries difficult to maintain.

**Independent Test**: Run owner-specific readiness fixtures for Profile identity, Objective records, Control baselines, and NFR candidate outcomes; verify each owner classifies its own states and does not mutate artifacts or invoke downstream workflows automatically.

**Acceptance Scenarios**:

1. **Given** an absent, malformed, or incomplete Profile, **When** Profile readiness is requested, **Then** Profile returns `Missing` or `Blocked` according to the condition and identifies `/highway-profile setup` or repair as the next action.
2. **Given** no valid Objective records or a malformed Objective baseline, **When** Objective readiness is requested, **Then** Objectives returns `Missing` or `Blocked`; one or more valid records return `Complete`.
3. **Given** no valid Controls, a malformed Control baseline, or one or more valid Controls, **When** Control readiness is requested, **Then** Controls returns `Missing`, `Blocked`, or `Complete` without starting NFR proposal generation.
4. **Given** unavailable or malformed candidate generation, zero candidates, candidates awaiting review, or accepted NFR artifacts, **When** NFR readiness is requested, **Then** NFRs returns `Blocked`, `Not Applicable`, `Missing`, `In Progress`, or `Complete` according to the owner state.

---

### User Story 3 - Orchestrate by readiness results (Priority: P1)

As a Highway user, I want Setup to invoke owner readiness in order and route from returned statuses so that Setup remains orchestration-only and every blocked or incomplete state has one clear next action.

**Why this priority**: Setup is the user-facing entry point. Incorrect routing can skip required governance work, fabricate completion, or hide the actual blocking owner.

**Independent Test**: Feed Setup ordered readiness responses for Profile, Objectives, Controls, and NFRs; verify it stops at the first non-complete prerequisite, emits the correct dashboard activity, and reaches completion for `Complete` and `Not Applicable` NFR results.

**Acceptance Scenarios**:

1. **Given** a non-complete Profile readiness response, **When** Setup runs, **Then** it stops before Objectives, reports Profile as the current activity, and does not inspect or mutate downstream artifacts.
2. **Given** complete Profile readiness and a non-complete Objectives or Controls response, **When** Setup runs, **Then** it stops at that owner and reports the owner-provided status and next action.
3. **Given** all prerequisite owners are complete and NFR readiness is `Complete` or `Not Applicable`, **When** Setup runs, **Then** it emits a completion dashboard and preserves `NFRs: Not Applicable` for the zero-candidate state.
4. **Given** NFR readiness is `Missing`, `In Progress`, or `Blocked`, **When** Setup runs, **Then** it reports the corresponding NFR activity and includes the owner-provided blocking reason when present.

### Edge Cases

- A readiness request is repeated against unchanged artifacts; status and all response fields remain identical.
- A valid-looking Profile lacks `organization.name`; Profile reports `Missing` rather than `Complete`.
- A candidate result reports zero candidates while containing candidate entries; NFR reports `Blocked`, not `Not Applicable`.
- A blocked owner response has a non-empty blocking reason; non-blocked responses emit `Blocking Reason: None`.
- An owner readiness request is made while its mutation workflow would normally be available; readiness remains read-only and does not invoke it.
- Setup receives an unknown status or malformed readiness response; it reports a deterministic blocked orchestration state rather than assuming completion.

## Requirements

### Functional Requirements

- **FR-001**: Each of `highway-profile`, `highway-objectives`, `highway-controls`, and `highway-nfrs` MUST support a read-only `readiness` action.
- **FR-002**: Every readiness response MUST contain exactly `Status`, `Summary`, `Next Action`, and `Blocking Reason` fields in that order.
- **FR-003**: Readiness MUST use only the statuses `Complete`, `Missing`, `In Progress`, `Blocked`, and `Not Applicable`.
- **FR-004**: Readiness MUST NOT write artifacts, allocate identifiers, start mutation workflows, or invoke proposal acceptance automatically.
- **FR-005**: Profile readiness MUST classify absent, malformed, missing, empty, and whitespace-only organization identity as `Missing` or `Blocked`, and a valid populated identity as `Complete`.
- **FR-006**: Objective readiness MUST classify no valid records as `Missing`, malformed records/catalog/next identifier state as `Blocked`, and one or more valid records as `Complete`.
- **FR-007**: Control readiness MUST classify no valid baseline as `Missing`, malformed or inconsistent baseline state as `Blocked`, and one or more valid Controls as `Complete`.
- **FR-008**: NFR readiness MUST classify unavailable or malformed candidate generation as `Blocked`, zero candidates with no accepted artifacts as `Not Applicable`, candidates without acceptance as `In Progress`, and accepted valid artifacts as `Complete`.
- **FR-009**: Setup MUST invoke owner readiness in Profile, Objectives, Controls, then NFR order and stop at the first non-complete prerequisite.
- **FR-010**: Setup MUST consume owner-provided readiness statuses, summaries, next actions, and blocking reasons without reimplementing owner completeness rules.
- **FR-011**: Setup MUST emit a completion dashboard for NFR `Complete` and `Not Applicable` and preserve the zero-candidate `NFRs: Not Applicable` label.
- **FR-012**: Setup MUST route NFR `Missing`, `In Progress`, and `Blocked` to distinct activities and include a blocking reason for `Blocked` results.
- **FR-013**: Repeated readiness requests against unchanged inputs MUST return identical fields, statuses, routes, and artifact bytes.
- **FR-014**: Verification MUST include owner-specific fixtures, read-only/no-write checks, malformed and contradictory inputs, ordered Setup routing, and static contract checks reported separately.
- **FR-015**: Documentation MUST identify readiness ownership for all four owner skills and state that Setup owns orchestration only.

### Key Entities

- **Readiness Response**: The ordered four-field result emitted by an owner, including status, explanation, next action, and optional blocking reason.
- **Owner Readiness State**: The artifact-specific inputs used by Profile, Objectives, Controls, or NFRs to classify readiness.
- **Setup Route**: The ordered orchestration decision made from owner readiness responses.
- **Readiness Evidence Record**: An observed status, response payload, route, and before/after artifact evidence for one fixture.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of the four owner skills support readiness with the exact four-field response contract and only the five allowed statuses.
- **SC-002**: 100% of required owner-state categories produce the documented status and next action, including Profile identity, Objective baseline, Control baseline, and six NFR outcome categories.
- **SC-003**: 100% of readiness fixtures leave source artifacts, identifiers, and catalogs byte-for-byte unchanged.
- **SC-004**: Setup routes 100% of ordered readiness fixtures to the first non-complete owner and never evaluates a later owner after a blocking prerequisite.
- **SC-005**: At least three repeated runs for unchanged Profile, Objective, Control, and NFR inputs produce identical readiness responses and artifact hashes.
- **SC-006**: Zero-candidate NFR readiness produces `Not Applicable`, Setup completion, and zero generated NFR artifacts across at least three repeated runs.
- **SC-007**: All blocked readiness responses include a non-empty blocking reason, while all non-blocked responses report `Blocking Reason: None`.
- **SC-008**: Final verification separately reports executable owner behavior, Setup routing behavior, static contract checks, generated-artifact checks, and remaining limitations.

## Assumptions

- Existing owner workflows and artifact formats remain the source of truth; this feature changes readiness ownership and routing, not mutation semantics.
- The standard readiness response is textual and read-only; it does not introduce a new persistent artifact.
- `Not Applicable` is valid only for successful zero-candidate generation with no accepted NFR artifacts.
- Setup may render owner response fields in its dashboard but does not reinterpret owner-specific completeness rules.
- Existing Bash-compatible fixtures, validators, and generators remain available for verification.
- No new runtime dependency or external service is required.
