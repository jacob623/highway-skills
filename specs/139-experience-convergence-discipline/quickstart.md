# Quickstart: Experience Convergence Discipline

## Prerequisites

- Run from the repository root.
- Use the repository's POSIX shell environment.
- Keep `.highway/governance/constitution.md` and `.highway/library/knowledge/highway-identity.md` available for review.

## Validation Scenarios

### 1. Focused convergence contract

Run:

```sh
bash .highway/tools/tests/experience-standard-convergence.test.sh
```

Expected result: the test passes and confirms the revised Converged Proposal definition, X2.13 Observable, X2.41, recursive interaction guidance, advisory uncertainty guidance, Contribution Opportunity behavior, contextual re-evaluation flow, interaction examples, recommendation guidance, safeguards, version metadata, and protected-path stability.

### 2. Existing Experience Standard contract

Run:

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
```

Expected result: the existing Experience Standard rules, metadata, and amendment-history invariants remain valid.

### 3. Cross-document UX alignment

Run:

```sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected result: owner skills continue to cite the Experience Standard without duplicating shared interaction contracts, and the amended standard remains the shared authority.

### 4. Full shipped-tree validation

Run:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: all registered tests pass with zero failures.

## Review Checks

- Confirm the Experience Standard's version and `Last Amended` metadata match the amendment policy.
- Confirm X2.41 is added after X2.40 and no existing X-rule identifier changes.
- Confirm the Constitution, `highway-profile`, owner schemas, and persistence semantics are unchanged.
- Confirm a mature or directly domain-complete contribution can still converge without a ceremonial extra turn.
- Confirm useful substantive development can continue after a Highway contribution or a materially changing Contribution Opportunity response.
