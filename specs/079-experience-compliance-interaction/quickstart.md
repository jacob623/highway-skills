# Feature 079 Validation Quickstart

## Prerequisites

Run from the repository root with the macOS default Bash or a compatible GNU/Linux Bash:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The repository's declared toolchain and existing shell fixtures must be available. No new package
or runtime dependency is required.

## Validate the governance documents

Confirm the constitution and Experience Standard contain the planned amendment:

```sh
grep -nE 'Experience Standard|Experience Compliance|P10\.1|P10\.2|rank 9|X2\.[2-6]' \
  .highway/governance/constitution.md .highway/governance/experience-standard.md
```

The output must show the definition, Principle X, precedence entry, protocol obligations, and all
five X2 rule IDs. Inspect the exact review-output shape in
[contracts/review-output.md](contracts/review-output.md).

## Run focused checks

Run the tests covering rule inventory, five-group reporting, and rule checks:

```sh
bash .highway/tools/tests/constitution-inventory.test.sh
bash .highway/tools/tests/coverage-summary.test.sh
bash .highway/tools/tests/rule-checks.test.sh
```

Expected result: each command exits 0; the coverage output contains `CHECKED:`, `FAILED:`,
`N/A:`, `DEFERRED:`, and `UNCHECKED:` exactly once, and every P/X rule is represented in one
and only one group.

## Run the complete suite

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the suite exits 0, the diff check exits 0, and no generated artifact or shipped
path contains a development-only reference.

## Manual experience review

For each newly created or amended skill, review the opening interaction, guided collection prompts,
progress messages, and any N/A conditions against X2.2-X2.6. Record the rule ID and evidence in
the existing Compliance Review Protocol format. Do not rewrite unchanged skills solely because
Feature 079 was adopted.
