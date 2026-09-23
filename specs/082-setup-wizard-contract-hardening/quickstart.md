# Feature 082 Quickstart

## Prerequisites

- Repository root: `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`
- Bash 3.2.57-compatible shell
- Feature 081 Setup Wizard source and owner workflow fixtures
- No `.specify/extensions.yml` hooks are required

## Focused Validation

From the repository root:

```sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
```

Expected result: both commands exit `0`, with static assertions and executable fixtures covering wording, ordering, terminality, Guided Setup entry, resume, cancellation, and owner authority.

## Feature 082 Scenarios

1. **Terminal completion**: Run a completion fixture and verify `Current Stage: Complete` has no numeric `Step`.
2. **Multi-message owner output**: Supply informational output followed by a question and verify that order and bytes are preserved.
3. **Outcome classification**: Supply `pause`, `cancel`, `stop responding`, `declined`, `aborted`, and `blocked` cases and verify their distinct classifications.
4. **Readiness entry**: Start with Profile, Objectives, Controls, and NFRs as the first incomplete owner in turn and verify Guided Setup begins at that owner.
5. **Transient state**: Interrupt collection and verify no owner collection state, unanswered question, draft response, cancellation marker, or wizard checkpoint is created.
6. **Ownership**: Verify Setup creates no identifiers, catalogs, owner artifacts, candidate state, or relationship state.

## Generated Artifacts

After changing `.highway/skills/highway-setup/SKILL.md`, regenerate and validate derived artifacts:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/adapter-coverage.test.sh
```

## Full Validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the full suite exits `0`, generated artifacts are current, and `git diff --check` reports no whitespace errors.

See [setup-wizard.md](contracts/setup-wizard.md) for the normative contract and [data-model.md](data-model.md) for the progress and outcome model.
