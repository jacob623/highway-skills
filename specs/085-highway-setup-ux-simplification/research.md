# Feature 085 Research

## Decision: Preserve owner orchestration and change only presentation

- **Decision**: Keep Profile, Objectives, Controls, and NFR readiness ownership, ordering, terminality, safe-stop behavior, and artifact boundaries unchanged.
- **Rationale**: FR-014 and FR-018 explicitly make presentation the change boundary. Existing Feature 033/034 contracts and the current setup skill already define the authoritative routing behavior.
- **Alternatives considered**: Rebuild setup routing around a new presentation authority; rejected because it would create the second setup authority prohibited by FR-018.

## Decision: Use ordered conversational output rather than named fields

- **Decision**: Represent collection output as the welcome message, owner introduction, and next unresolved question in order.
- **Rationale**: The existing skill emits ordered conversational content and forwards owner output; it does not expose a structured response-field protocol. This directly implements FR-010 without inventing a new interface.
- **Alternatives considered**: Add `Welcome Message`, `Owner Introduction`, and `Owner Question` as formal fields; rejected because that would misrepresent the existing contract and increase implementation surface.

## Decision: Retain a separate status and diagnostic path

- **Decision**: Suppress progress framing only during active collection. Permit dashboard or actionable owner context for completion, blocked, declined, aborted, and explicit status responses.
- **Rationale**: Owner Outcomes are distinct from User Exits, and blocked or terminal non-success outcomes need an actionable result. This implements FR-007, FR-008, and FR-011 without changing completion semantics.
- **Alternatives considered**: Suppress all dashboard and owner context until completion; rejected because it would hide actionable failure information and conflict with existing outcome handling.

## Decision: Make resume greeting deterministic without persistence

- **Decision**: A resumed interaction begins with a resume greeting, then the active owner introduction and unresolved question; no checkpoint or unanswered-question persistence is added.
- **Rationale**: Existing setup re-reads persisted owner readiness and resumes at the first incomplete owner. FR-019 specifies presentation while FR-018 and the existing skill prohibit new setup persistence.
- **Alternatives considered**: Restore the exact prior unanswered question; rejected because the current contract intentionally does not persist wizard conversation state.

## Decision: Validate with existing Bash 3.2 test conventions

- **Decision**: Amend `highway-setup.test.sh` for static contract assertions and `highway-setup-executable.test.sh` for deterministic fixture checks, then run `run-all.sh`.
- **Rationale**: These are the existing focused tests for the shipped setup skill and already use the repository's macOS-compatible Bash conventions.
- **Alternatives considered**: Introduce a new runtime or test framework; rejected by the repository's toolchain and no-new-dependency constraints.

## Baseline

- The canonical `highway-setup.test.sh` passed before implementation; its malformed-workflow failures are intentional seeded probes.
- The executable setup test passed through Bash before implementation; its malformed, declined, and aborted response diagnostics are intentional fixture probes.
- The direct executable bit is absent on `highway-setup-executable.test.sh` in this checkout, so focused execution uses `bash` explicitly.
