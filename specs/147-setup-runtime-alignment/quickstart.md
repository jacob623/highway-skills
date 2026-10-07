# Quickstart: Setup Runtime Architecture Alignment

## Prerequisites

Run from the repository root with macOS Bash 3.2-compatible tooling available.

## Focused Validation

Run the existing Setup contract checks:

```sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/setup-owner-loop-contract.test.sh
bash .highway/tools/tests/readiness-owner-states.test.sh
bash .highway/tools/tests/readiness-ownership.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
```

Expected outcome: every command exits `0` and confirms owner order, readiness ownership,
owner-specific result handling, executable orchestration, and resume/completion behavior.

## Full Validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: the full repository suite passes with zero failures.

## Manual Contract Audit

Inspect `.highway/skills/highway-setup/SKILL.md` and confirm:

- frontmatter is valid and contains the intended version metadata;
- exactly one `# Purpose` section preserves the existing orchestration meaning;
- owner order is Profile, Objectives, Controls, NFRs;
- the Inputs section retains the Experience Standard;
- the Constitution is absent from runtime dependencies and Error Handling;
- malformed, blocked, declined, aborted, unsupported-action, and unexpected-failure handling stops
  safely without false completion;
- owner-specific result contracts remain distinct and no common schema is introduced;
- transitions, `---` separation, final-block response demand, and completed-domain synthesis remain
  Setup-owned and are not duplicated for skipped or already-complete owners;
- welcome, resume, and final completion behavior remain correct;
- machine result fields, generic advisory, clarification, convergence, acceptance, and persistence
  mechanics are not exposed or reimplemented by Setup.

Protected runtime files that should remain unchanged by this feature include the four owner skills
and `.highway/governance/experience-standard.md`.
