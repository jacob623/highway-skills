# Quickstart: Constitution Owner Mutation Boundary

## Prerequisites

- Run from the repository root.
- Bash and the repository's existing Highway validation tools are available.

## Validate the baseline

```bash
bash .highway/tools/tests/run-all.sh
```

Expected result: exit code 0 with zero failed tests before editing the Constitution.

## Review the amendment

Confirm `.highway/governance/constitution.md` contains:

1. Version `6.0.0` and a MAJOR Sync Impact Report.
2. P12.13, P12.14, and P12.15 with their exact rule, observable, and
   `[agent-checkable]` tier.
3. Unchanged P12.5–P12.12.
4. The updated Principle XII rationale, precedence reason, and non-normative persistence
   boundary.
5. No Experience Standard, skill, template, post-write verification, or Verified Completion Claim
   changes.

## Validate the final state

```bash
bash .highway/tools/tests/run-all.sh
git diff --check
git diff --name-only
```

Expected results:

- The suite exits 0 with zero failures.
- `git diff --check` exits 0.
- The only implementation path changed by this feature is
  `.highway/governance/constitution.md`; development planning artifacts remain under
  `specs/113-constitution-owner-mutation/`.

## Acceptance evidence

The completion report must separate the test-suite result from requirement coverage and state the
changed-path audit, rule-count/version synchronization, self-application review, and exclusions.
