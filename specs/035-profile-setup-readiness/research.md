# Feature 035 Research

## Decision: Make Profile the sole owner of organization readiness

- **Decision**: Define `organization.name` collection, validation, confirmation, and Profile completeness in `highway-profile`; Setup consumes the Profile owner's readiness result.
- **Rationale**: Profile already owns the Profile artifact and confirmation gate. Moving the rule to that owner removes conflicting definitions and keeps Setup orchestration-only.
- **Alternatives considered**: Keeping the check in Setup was rejected because it duplicates owner semantics. Adding a shared helper was rejected because the repository uses Markdown skill contracts and the Profile owner remains the authoritative boundary.

## Decision: Use ten sequential Setup workflow steps

- **Decision**: Number the existing Setup workflow from 1 through 10 and preserve the current step references after numbering.
- **Rationale**: P8.1 requires numbered workflow steps, and explicit numbering makes the routing graph mechanically inspectable.
- **Alternatives considered**: Renumbering into smaller substeps was rejected because it would change the established routing contract. Removing references was rejected because failure and continuation paths need explicit destinations.

## Decision: Represent zero NFR candidates as `Not Applicable`

- **Decision**: When Profile, Objectives, and Controls are complete, candidate generation succeeds, and the result is exactly zero candidates with no accepted NFRs, report `NFRs: Not Applicable` and treat Setup as terminally complete without creating an NFR artifact.
- **Rationale**: A valid Control with no matching derivation rule is a valid governance state, not a failed or pending workflow. `Not Applicable` distinguishes it from accepted NFR completion and from candidate-generation failure.
- **Alternatives considered**: Treating zero candidates as `In Progress` was rejected because it creates an impossible onboarding loop. Treating it as ordinary `Complete` was rejected because it loses the reason no NFR baseline exists. Fabricating an NFR was rejected because it violates owner boundaries.

## Decision: Validate workflow references structurally

- **Decision**: Add a focused check that extracts numbered Setup steps, verifies uniqueness and contiguous numbering, and verifies every `Step N` reference resolves.
- **Rationale**: Text presence checks do not detect duplicate, missing, or dangling step references. A structural assertion directly observes P8.1 compliance.
- **Alternatives considered**: Manual review only was rejected because numbering integrity is deterministic and cheap to test.
