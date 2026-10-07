# Quickstart: Experience Runtime Refactor

## Prerequisites

- macOS or a GNU-compatible shell environment.
- Repository root at `highway-skills`.
- Bash 3.2-compatible scripts available through the repository toolchain.

## Focused validation

From the repository root, run:

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/experience-standard-convergence.test.sh
bash .highway/tools/tests/feature-141-experience-standard-refactor.test.sh
```

Expected outcome: each test exits 0 and reports an Experience Standard contract pass. The focused checks should verify:

- no runtime dependency on the Highway Skills Constitution or development/test tier metadata;
- version `9.0.0` and the recorded major amendment;
- retained X2.4, X2.37, X2.38, and X2.41 ownership;
- retirement and successor mapping for X2.8, X2.14, X2.39, and X2.40;
- separate rationalization of X2.2 and X2.13;
- constructive advisory, re-evaluation, convergence, acceptance, and short-path behavior.

## Full regression validation

Run the complete repository suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the suite exits 0 with no failed tests. Report the suite result separately from requirement coverage.

## Manual document audit

Review `.highway/governance/experience-standard.md` and confirm:

1. An executing workflow can use the document without the Highway Skills Constitution.
2. Owning skills remain authoritative for domain semantics, completeness, ownership, acceptance, and persistence.
3. Highway-originated reasoning is visibly advisory until accepted.
4. The Interaction Model continues grounded development while another contribution could materially improve understanding, but permits rapid progress when further work would be optional, repetitive, unsupported, manufactured, or low-value.
5. The acceptance boundary follows convergence and does not prove persistence success.
6. No protected file named in the feature spec was modified.

## Completion evidence

Use `git diff --check` for whitespace validation and `git status --short` for the changed-file audit. The implementation should change the Experience Standard and approved development records only; no `contracts/` artifact is expected.
