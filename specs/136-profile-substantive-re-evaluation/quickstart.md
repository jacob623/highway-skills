# Feature 136 Validation Guide

## Prerequisites

Run from the repository root on macOS or a POSIX-compatible shell with Bash 3.2 support.

The feature branch is `136-profile-substantive-re-evaluation`. No `.specify/extensions.yml` hooks are required.

## Focused contract validation

After implementation, run the Profile-specific contracts:

```sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-context-contract.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh
```

Expected result: each command exits 0 and reports its contract passes. The Feature 136 assertions
must cover substantive re-evaluation in all four domains, zero ceremonial clarification for a clear
interpretation, one focused clarification for consequential uncertainty, provisional Identity facets,
direct complete Identity, acceptance plus new information, cross-domain relationship reasoning,
technology exclusion, transient reasoning, and unchanged schema/ownership boundaries.

## Generated artifact validation

Regenerate the source-derived adapters and catalogs using the repository's supported generators,
then run the adapter and catalog correspondence checks discovered by `run-all.sh`. Do not hand-edit
generated copies.

Confirm all distributed Profile skill copies carry version `5.3.0` and match the authoritative source.
Confirm the Profile record template remains schema `3.0.0` and protected artifacts have no diff.

## Full suite

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: the complete repository suite passes with zero failures. Also run:

```sh
git diff --check
git diff --name-only -- .highway/governance/experience-standard.md \
  .highway/library/templates/output/profile-record.md \
  .highway/skills/highway-setup/SKILL.md \
  .highway/skills/highway-clarify/SKILL.md \
  .highway/governance/constitution.md
```

The protected-path command must produce no output. The data model and spec define the transient and
retained boundaries that the static contracts must verify.

Final validation result: `bash .highway/tools/tests/run-all.sh` reported 65 passed and 0 failed.
