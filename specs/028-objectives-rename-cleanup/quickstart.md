# Quickstart: Objectives Skill Rename

## Prerequisites

- macOS or GNU/Linux checkout at the repository root.
- Existing Highway tools under `.highway/tools/`.
- No live objective baseline is required; if one exists, snapshot it before validation.

## Capture the migration baseline

```sh
old_token='highway-objective([^s]|$)'
find library/objectives library/governance/objectives.md -type f -print 2>/dev/null | sort
```

Record any existing root-level objective files and their hashes. The migration must not write those
paths.

## Validate the canonical source and regenerate outputs

```sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives
bash .highway/tools/validate-library.sh .highway/library/templates/output/objective-record.md
bash .highway/tools/generate-catalog.sh
bash .highway/tools/generate-library-catalog.sh
bash .highway/tools/generate-agent-adapters.sh
```

Expected result: all commands exit 0 and generated outputs refer only to `highway-objectives`.

## Verify stale paths and references

Use an exact-token scan, not a substring scan that would match the valid plural name:

```sh
rg -n --hidden --glob '!.git/**' --glob '!specs/028-objectives-rename-cleanup/**' \
  '(^|[^A-Za-z0-9_-])highway-objective([^A-Za-z0-9_-]|$)' .
find . -path '*highway-objective*' -print
```

Expected result: no output. The singular source, adapters, manifests, tests, fixtures, catalogs,
Feature 027 references, and prompt artifacts must all be absent or updated.

## Validate correspondence and packaging

```sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/distribution-packaging.test.sh
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: adapter, packaging, and full-suite checks pass with zero failures.

## Verify user-owned data protection

Recompute the hashes captured before validation and confirm every existing file beneath
`library/objectives/` and `library/governance/objectives.md` is byte-identical. Confirm no live
objective path was created when the baseline was initially absent.
