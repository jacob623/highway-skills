# Feature 094 Requirement-to-Test Coverage

This is the implementation-time correspondence register for Feature 094. It keeps requirement
coverage separate from executable check results. Tasks T003 and T058-T062 populate the detailed
requirement rows and final verdicts as implementation proceeds.

## Coverage classes

- **Contract**: static skill, template, output, or ownership wording.
- **Behavior**: executed fixture or workflow probe.
- **Correspondence**: canonical/generated artifact comparison.
- **Compliance**: phase-specific PASS, FAIL, N/A, or DEFERRED evidence.

## Initial mapping

| Requirement group | Primary artifact | Evidence class | Planned checks |
|---|---|---|---|
| FR-001-FR-006a, FR-036-FR-036d, FR-040b, FR-042f, FR-042k | `.highway/skills/highway-setup/SKILL.md` | Contract + Behavior | `highway-setup.test.sh`, `setup-owner-loop-contract.test.sh` |
| FR-007-FR-012, FR-018-FR-020b, FR-025-FR-025b, FR-041, FR-042 | `.highway/skills/highway-controls/SKILL.md` | Contract + Behavior | `highway-controls-onboarding.test.sh`, `highway-ux-alignment.test.sh` |
| FR-013-FR-017, FR-022-FR-024, FR-042a-FR-042b, FR-042g-FR-042h | `.highway/skills/highway-controls/SKILL.md` | Contract + Behavior | `profile-participation.test.sh`, `profile-context-contract.test.sh`, `highway-ux-alignment.test.sh` |
| FR-021, FR-028-FR-035, FR-038, FR-042c-FR-042d | `.highway/skills/highway-controls/SKILL.md` and `control-record.md` | Contract + Behavior | `highway-controls-onboarding.test.sh`, `relationship-integrity.test.sh`, `readiness-executable.test.sh` |
| FR-037-FR-037b, FR-042e, FR-042i | `.highway/skills/highway-nfrs/SKILL.md` | Contract + Behavior | `control-derived-nfr.test.sh`, `highway-nfr-onboarding.test.sh` |
| FR-041f, SC-011 | `coverage.md` and focused test reports | Compliance | Phase-specific PASS/FAIL/N/A/DEFERRED matrix |
| FR-041h, FR-042j, SC-012, SC-023 | canonical skills and generated copies | Correspondence + Behavior | `feature-092-correspondence.test.sh`, Setup/Controls fixtures |

## Phase evidence

- **US1**: Setup, owner-loop, and executable handoff probes pass. The Controls Action Result is
	ordered before fresh readiness, and `Continue` is non-terminal.
- **US2**: Controls onboarding, proposal framing, output-template, Controls context UX assertions,
	and Controls skill validation pass. The repository-wide UX alignment probe also passes.
- **US3**: Profile participation and Profile context probes pass. Controls records deterministic
	context priority, owner-blocked Profile handling, optional-context exclusion, advisory connections,
	and active-user precedence.
- **US4**: Controls onboarding, candidate, relationship-integrity, and readiness-executable probes
	pass. Static persistence contracts and executed disposable-fixture behavior are reported separately;
	failed writes preserve the verified baseline and reuse creates no new identifiers or candidates.
- **US5**: Controls, Control-derived NFR, NFR onboarding, and Setup probes pass. Candidate generation
	is declared immediate and exactly once per verified new Control; review remains deferred until
	explicit collection finish, with durable zero-candidate and blocked outcomes.

## Phase compliance matrix

| Workflow phase | Applicable evidence | Status |
|---|---|---|
| Adaptive discovery | Controls onboarding, UX, context, and no-progress-label assertions | PASS |
| Proposal validation | Action-first framing, retained-field, overlap, and persistence probes | PASS |
| Destructive action | Existing impact-analysis and explicit-confirmation contract retained | PASS |
| Read-only readiness | Controls and NFR four-field readiness contracts and executable fixtures | PASS |
| NFR review | Immediate candidate derivation, durable outcomes, and deferred review contract | PASS |
| Human-review rules | Release/compliance review items requiring human judgment | DEFERRED |
| Repository-wide UX alignment | UX alignment, Objectives compatibility, and generated correspondence checks | PASS |

## Final evidence register

## Final validation

- **T060**: `.highway/tools/tests/run-all.sh` completed, not timed out, within the requested
	240-second allowance: 60 passed and 0 failed.
- **T061**: `.specify/scripts/bash/check-prerequisites.sh --json --paths-only`,
	`feature-092-correspondence.test.sh`, generated adapter/catalog checks, and `git diff --check`
	all passed.
- **T062**: Final implementation reconciliation against `spec.md`, `plan.md`, and all contracts
	completed. Canonical Controls, Setup, and NFR contracts, templates, generated artifacts, focused
	probes, and ownership boundaries are aligned. No hooks file is present, so after-hook validation
	is not applicable.

A static contract check must not be presented as behavioral proof; the evidence above keeps those
	categories separate.