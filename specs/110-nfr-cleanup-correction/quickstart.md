# Final NFR Cleanup Quickstart

Run from the repository root.

## Canonical validation

```sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-nfrs
bash .highway/tools/validate-library.sh .highway/library/templates/output/nfr-record.md
```

Expected result: both validators exit successfully.

## Focused contract checks

```sh
bash .highway/tools/tests/nfr-management.test.sh
bash .highway/tools/tests/highway-nfr-onboarding.test.sh
bash .highway/tools/tests/control-derived-nfr.test.sh
bash .highway/tools/tests/readiness-owner-states.test.sh
bash .highway/tools/tests/output-template.test.sh
bash .highway/tools/tests/setup-owner-loop-contract.test.sh
```

Verify that these checks cover:

- the exact captured-NFR review formatting;
- direct capture without inferred-content review but with persistence safeguards;
- pending candidate ordering and persisted resume behavior;
- readiness/collection separation and four-field owner results;
- direct `controls: []` and immutable Control-derived relationships;
- no NFR Recommendation Grounding field or post-write verification.

## Generated artifact validation

```sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/generate-library-catalog.sh
bash .highway/tools/generate-catalog.sh
bash .highway/tools/generate-instructions.sh
```

Generated outputs must remain synchronized with canonical sources.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: zero failures and no linter diagnostics in changed files.
