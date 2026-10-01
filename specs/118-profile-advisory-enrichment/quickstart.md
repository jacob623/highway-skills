# Feature 118 Quickstart

## Prerequisites

Run from the repository root on macOS with the default Bash toolchain. No package installation or external service is required.

The feature changes the shipped Profile skill and its development contract tests. Do not edit `.highway/library/templates/output/profile-record.md`.

## Baseline

Run before implementation and record the result:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: exit 0 with all registered tests passing.

## Focused source validation

Validate the source skill:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-profile
```

Confirm the source skill contains the Profile-specific acquisition, enrichment, operations, verification, and completion contracts while its Experience section remains the single shared-standard sentence.

## Focused Profile contract checks

Run the existing Profile and Experience checks after each focused implementation slice:

```sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/output-template.test.sh
```

Feature 118 coverage must include:

- first-time Profile introduction and Repository Name ordering;
- website URL acceptance and proposed website-derived facts;
- accepted evidence re-evaluation across all four domains;
- grounded recommendation before canonical questioning;
- cohesive Vision, Competitive Path, and Guiding Principles paragraphs;
- hidden, unpersisted enrichment categories;
- constructive advisory contribution without manufactured disagreement;
- save-before-result mutation behavior;
- completion synthesis before Setup handoff;
- normal-orchestration suppression of machine-only owner results;
- direct readiness result availability;
- unchanged four-domain schema, optional Context, and Profile-specific error behavior.

## Generated correspondence

Because the source skill is a generator input, regenerate declared derived artifacts only after the source edit:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-library-catalog.sh
```

Run each applicable generator again and confirm no further content diff remains. Do not hand-edit generated adapters or catalogs.

## Full validation

Run the full suite and inspect whitespace:

```sh
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: all tests pass, no Profile template changes are present, no generated artifact is stale, and no development-only identifier appears in the shipped Profile skill.

## Requirement evidence

The implementation record should map tests to the four-domain readiness boundary, first-time acquisition, accepted/proposed evidence, recommendation pivot, cohesive enrichment, advisory behavior, persistence, completion synthesis, machine-result suppression, verification, and version compatibility. `data-model.md` defines the retained entities and state transitions used by those checks.

## Execution Record

Feature 118 implementation completed with the existing Profile fixture corpus and contract matrix; no new runtime dependency, storage mechanism, or public contract was required.

Validated commands and outcomes:

```text
focused Profile behavior, structure, lifecycle, Markdown, migration, UX, and output-template checks: PASS
.highway/tools/validate-skill.sh .highway/skills/highway-profile: PASS
Feature 092 contract matrix: PASS
generator correspondence: PASS
profile-record.md hash and diff check: unchanged
git diff --check: PASS
bash .highway/tools/tests/run-all.sh: 62 passed, 0 failed
```

The focused behavior contract includes the Feature 118 hidden-category assertion. It failed before the
skill wording change and passed afterward. Existing adaptive and Profile participation fixtures cover
accepted evidence, proposed discovery, cross-domain re-evaluation, grounded recommendations,
completion ownership, and machine-result boundaries. Profile remains version `5.1.0`; the retained
record remains schema `3.0.0`; and the shared Profile template remains unmodified.

Requirement evidence is distributed across `profile-behavior.test.sh`, `profile-lifecycle.test.sh`,
`profile-structure.test.sh`, `feature-092-contract.test.sh`, `profile-adaptive.test.sh`,
`profile-participation.test.sh`, `profile-markdown-contract.test.sh`, `profile-template-migration.test.sh`,
`highway-ux-alignment.test.sh`, and the full suite. No `.specify/extensions.yml` exists, so no task or
implementation extension hooks were dispatched.
