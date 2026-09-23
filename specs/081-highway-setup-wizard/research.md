# Feature 081 Research

## Decision: Delegate all owner collection and mutation to existing owner workflows

**Rationale**: The existing Profile, Objectives, Controls, and NFR skills already own their artifacts, proposal semantics, readiness contracts, and no-write behavior. Setup should orchestrate questions and outcomes without duplicating those rules or creating a competing artifact store.

**Alternatives considered**: Implementing collection logic or artifact writes inside `highway-setup` was rejected because it would violate the established ownership boundary and create divergent validation semantics.

## Decision: Resume from persisted owner readiness, not a Setup checkpoint

**Rationale**: A new invocation can deterministically identify the first incomplete owner from the authoritative readiness responses. This preserves completed stages without adding a second persistence model for unanswered questions or cancellation markers.

**Alternatives considered**: Persisting the exact unanswered question was rejected because it would create competing Setup state; restarting the entire workflow was rejected because it would discard completed owner progress.

## Decision: Use a fixed four-stage sequence and explicit terminality table

**Rationale**: Profile, Objectives, Controls, and NFRs have an established dependency order. An explicit decision table makes terminal success, resumable non-terminal states, blocked outcomes, and malformed responses testable without inferring behavior from prose.

**Alternatives considered**: Dynamic owner ordering was rejected because downstream readiness depends on earlier stages; implicit status handling was rejected because malformed or contradictory responses must never fabricate completion.

## Decision: Preserve owner questions and examples byte-for-byte

**Rationale**: Owner workflows are authoritative for collection wording and examples. Setup may add progress framing, but byte-identical owner content prevents accidental changes to owner semantics and makes output validation deterministic.

**Alternatives considered**: Setup-authored restatements or summaries were rejected because they could omit constraints, alter meaning, or drift from the owner workflow.

## Decision: Validate with focused static and executable Bash tests

**Rationale**: The repository already uses `highway-setup.test.sh` for document contracts and `highway-setup-executable.test.sh` for ordered routing. Extending those checks keeps validation local, portable, and compatible with the existing full suite.

**Alternatives considered**: Introducing a new test framework or runtime dependency was rejected because the feature is a skill/document contract and the existing Bash harness already covers its artifact classes.

## Decision: Keep the existing completion dashboard as the terminal view

**Rationale**: The dashboard is an established administration contract. The wizard adds progress while incomplete and emits the existing dashboard after terminal success, avoiding a breaking replacement of management routes.

**Alternatives considered**: Replacing the dashboard with a new wizard-only summary was rejected because it would remove established ownership routes and increase migration scope.
