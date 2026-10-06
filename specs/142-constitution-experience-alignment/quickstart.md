# Feature 142 Validation Guide

## Prerequisites

Run from the repository root on macOS or another environment with Bash-compatible shell tools:

- The Feature 142 branch and files are present.
- No extension hooks are required.
- The repository's existing `.highway/tools/tests` scripts are executable.

## Focused document checks

Confirm the Constitution contains the revised authority and convergence boundary:

```sh
grep -F '**Working Idea**' .highway/governance/constitution.md
grep -F '**Converged Proposal**' .highway/governance/constitution.md
grep -F 'A Converged Proposal requires a complete owner candidate and satisfaction of the applicable Experience Standard convergence requirements.' .highway/governance/constitution.md
grep -F 'The Experience Standard governs visible collaborative development' .highway/governance/constitution.md
```

Confirm the four collaborative-knowledge rules remain individually present:

```sh
grep -E '\| P12A\.[1-4] \|' .highway/governance/constitution.md
```

Confirm the lifecycle no longer equates completeness alone with convergence and uses current-state mutation wording:

```sh
! grep -F 'When the owning workflow can present a complete candidate' .highway/governance/constitution.md
! grep -F 'existing owner-controlled mutation path' .highway/governance/constitution.md
```

## Cross-document ownership checks

Review the Constitution and Experience Standard together and verify:

1. The Constitution retains authority, transience, context retention, owner completeness, mutation,
   persistence, orchestration, and context precedence.
2. The Experience Standard retains visible collaborative development, Substantive Contribution,
   Conversational Clarification, Contribution Opportunity, and convergence behavior.
3. The Constitution does not reproduce detailed X2.41 criteria or the Experience Standard's other
   interaction concepts.

## Semantic regression review

Evaluate these five cases against both documents:

- A complete but still developing candidate remains a Working Idea, not a Converged Proposal.
- A complete and settled candidate may qualify as a Converged Proposal.
- Agreement with a Working Idea does not create accepted repository knowledge.
- Acceptance authorizes owner mutation but is not itself successful persistence.
- Successful owner persistence creates accepted repository knowledge available to later reasoning.

## Full repository validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: all registered checks pass with zero failures, and the diff contains no whitespace errors.

## Observed Feature 142 Results

- Focused contract: `bash .highway/tools/tests/constitution-experience-alignment.test.sh` passed.
- Dependent Constitution inventory guard: `bash .highway/tools/tests/constitution-inventory.test.sh` passed.
- Full suite: `.highway/tools/tests/run-all.sh` reported 71 passed, 0 failed.
- Task markers: T001-T020 are complete.
