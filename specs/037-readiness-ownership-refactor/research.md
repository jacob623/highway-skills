# Feature 037 Research

## Decision: Use an explicit read-only `readiness` action

**Rationale**: The four owner skills already expose user-facing action selection and Feature 035 describes Profile readiness as a callable owner result. An explicit action makes the ownership boundary testable: each owner evaluates its own artifacts, while Setup invokes the same read-only action in order.

**Alternatives considered**:
- Setup reading owner files directly: rejected because it duplicates ownership rules and violates FR-010.
- A private-only helper: rejected because the readiness contract must be independently verifiable at each owner boundary.
- A persistent readiness artifact: rejected because readiness is derived state and FR-004 requires no readiness writes.

## Decision: Emit four ordered plain-text fields

**Rationale**: Each owner will emit one `Field: value` line in this exact order: `Status`, `Summary`, `Next Action`, `Blocking Reason`. This is readable in skill output, deterministic for shell tests, and avoids introducing a parser or runtime dependency. Status values are restricted to the five values in FR-003.

**Alternatives considered**:
- YAML or JSON: rejected because the existing skills are Markdown/text guidance and no runtime parser is required.
- Reusing mutation output fields: rejected because readiness is read-only and must not imply confirmation or a write.

## Decision: Keep validity rules in existing owner artifacts and validators

**Rationale**: Profile uses the existing profile YAML contract; Objectives and Controls use their existing record/catalog formats; NFRs use the existing candidate and accepted-artifact outcome contract. The readiness additions should reference those definitions instead of creating parallel schemas.

**Alternatives considered**:
- A shared validator that decides every owner state: rejected because it would recreate centralized completeness logic.
- Presence-only checks: rejected because malformed and contradictory states must be `Blocked`, not `Complete`.

## Decision: NFR pending candidates always return `In Progress`

**Rationale**: The clarification resolved the only status ambiguity. `Missing` remains available for an absent required NFR state, while candidates awaiting acceptance have one stable Setup route.

**Alternatives considered**:
- Return `Missing` until acceptance: rejected because candidates exist and the state is an active review, not absence.
- Choose between `Missing` and `In Progress` based on review metadata: rejected because it would make routing and tests depend on an unnecessary second state.

## Decision: Setup is a response consumer and ordered short-circuit

**Rationale**: Setup invokes Profile, Objectives, Controls, then NFR readiness, stops at the first non-complete prerequisite, and renders the owner response. It may identify malformed response shape as a deterministic orchestration block, but it does not interpret owner-specific artifact completeness.

**Alternatives considered**:
- Evaluate all owners before routing: rejected because downstream inspection is forbidden after a blocking prerequisite.
- Recompute status from files: rejected by FR-010 and P7.3 ownership separation.

## Decision: Verification uses the existing Bash 3.2 test harness

**Rationale**: `.highway/tools/tests/run-all.sh`, focused test scripts, temporary fixtures, file hashes, and existing validators already match the repository toolchain. Tests will separately report executable owner behavior, Setup routing, static contract checks, generated-artifact checks, and limitations.

**Alternatives considered**:
- Add a new test framework: rejected by D2.4 and unnecessary for shell-driven skills.
- Test only Setup: rejected because owner classification and no-write behavior are the feature's primary risk.

## Resolved planning unknowns

- Invocation: explicit `/highway-<owner> readiness` action.
- Response format: four ordered plain-text `Field: value` lines.
- Objective validity: existing objective record/catalog validation rules.
- Control validity: existing Control baseline and record validation rules.
- NFR state source: existing candidate outcome and accepted-artifact state.
- Blocking display: Setup includes the owner-provided `Blocking Reason` in its dashboard for `Blocked` results.
- Fixture strategy: isolated temporary fixtures per owner, with repeated runs and before/after hashes.
- Documentation scope: each owner skill documents its readiness ownership; Setup documents orchestration-only behavior; contracts provide the shared reference.
