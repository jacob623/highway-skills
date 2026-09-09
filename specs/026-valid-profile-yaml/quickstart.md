# Quickstart: Valid Profile YAML

## Prerequisites

- macOS or GNU/Linux development environment.
- Repository checkout at the project root.
- The development host's standard YAML parser runtime available for the focused parser test.

## Validate the canonical profile

Run the focused parser check:

```sh
bash .highway/tools/tests/profile-yaml.test.sh
```

Expected result: the command exits 0 and reports that the canonical profile is valid YAML.

Run the existing structural check:

```sh
bash .highway/tools/tests/profile-structure.test.sh
```

Expected result: the canonical profile and existing valid fixtures pass, while malformed fixtures
remain rejected.

Run the complete suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: every test passes, including the focused YAML parser check.

Validated implementation result: `profile-yaml.test.sh`, `profile-structure.test.sh`,
`audit-profile-migration.sh`, and `run-all.sh` pass; the full suite reports 28 passed and 0 failed.

## Regression scenario

Introduce a tab as indentation in a disposable copy of the profile and run the parser-backed
check against that copy. The check must fail, then the repository file must remain unchanged.