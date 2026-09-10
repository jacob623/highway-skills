# Quickstart: Highway Objective

## Prerequisites

- macOS or GNU/Linux development environment.
- Repository checkout at the project root.
- Existing Highway validators and test suite available under `.highway/tools/`.

## Validate the source skill and shared template

```sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives
bash .highway/tools/validate-library.sh .highway/library/templates/output/objective-record.md
```

Expected result: both commands exit 0, and the skill's complete output contract cites the shared
objective record template.

## Run focused objective workflow checks

```sh
bash .highway/tools/tests/objective-management.test.sh
```

Expected result: read-only actions do not mutate bytes; confirmed add/update/remove/reset actions
produce the expected records/catalog/version; declined and malformed operations leave fixtures
unchanged; identifiers remain unique and unreused.

## Verify generated artifacts and packaging

```sh
bash .highway/tools/generate-catalog.sh
bash .highway/tools/generate-library-catalog.sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/distribution-packaging.test.sh
```

Expected result: the new skill has one catalog entry, each declared adapter is current, the shared
template is cataloged once, and the distribution contains the source skill/template and adapters.

## Run the complete suite

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: all tests pass, including objective workflow and correspondence coverage.

## Feature 027 Validation Result

The Feature 027 implementation was validated with:

- `validate-skill.sh`: passed for `highway-objectives`.
- `validate-library.sh`: passed for `objective-record.md`.
- `objective-management.test.sh`: passed.
- `adapter-coverage.test.sh`: passed.
- `distribution-packaging.test.sh`: passed.
- `.highway/tools/tests/run-all.sh`: 29 passed, 0 failed.