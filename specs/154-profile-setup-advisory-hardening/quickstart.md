# Quickstart: Profile and Setup Advisory Hardening

**Feature**: 154 | **Date**: 2026-10-09

This guide validates delivery sites. It does not establish that a host produces the intended
conversation at runtime.

## Prerequisites

- Working directory: repository root
- macOS or Linux shell compatible with Bash 3.2.57
- No package installation required
- Read [contracts/delivery-sites.md](./contracts/delivery-sites.md)

## Step 1 - Observe focused failures

Run the focused delivery-site test in its seeded-failure mode before implementation, if the test
supports the repository's standard probe interface:

```bash
.highway/tools/tests/feature-154-delivery-sites.test.sh --probe source-document
.highway/tools/tests/feature-154-delivery-sites.test.sh --probe source-document --neutralise
```

Expected: the seeded run fails for the seeded missing delivery site; the neutralised run passes.

## Step 2 - Implement source documents

Update only the owning sources:

- `.highway/skills/highway-profile/SKILL.md`
- `.highway/governance/experience-standard.md` (X2.72 only)
- `.highway/skills/highway-setup/SKILL.md`

Add or update the focused test beside the existing tests under `.highway/tools/tests/`.

## Step 3 - Regenerate outputs

```bash
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-instructions.sh
```

Expected: generated Profile and Setup copies, catalogs, instruction outputs, and `AGENTS.md` change
only through their generators.

## Step 4 - Verify delivery sites

```bash
.highway/tools/tests/feature-154-delivery-sites.test.sh
```

Expected: exit 0. The test checks the restored reassurance, X2.72 heading, boundary cue, direct
approval path, advisory scaffolding, and fresh Setup welcome ordering.

## Step 5 - Run the full suite

```bash
time .highway/tools/tests/run-all.sh
```

Expected: exit 0 with every existing test passing. Record pass count and duration separately from
feature coverage.

## Step 6 - Human evaluation

Review representative fresh, resumed, direct-contribution, imported-evidence, approval, boundary,
and exploratory-question traces. Record conversational quality separately; a green static suite proves
only that the contracted delivery sites exist and are shaped correctly.
