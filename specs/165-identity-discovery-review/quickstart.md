# Quickstart: Identity Discovery Contribution Opportunity

Run commands from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

## Prerequisites

- macOS Bash 3.2-compatible shell tooling.
- Active feature pointer resolves to `specs/165-identity-discovery-review`.
- No `.specify/extensions.yml` is present, so planning hooks are skipped.

## Focused validation

After adding the contract test and before completing the source wording, run it to record the expected
failure. After implementation, rerun it and expect success:

```sh
bash .highway/tools/tests/feature-165-identity-discovery-review.test.sh
```

Run adjacent Profile contracts:

```sh
bash .highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh
bash .highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
```

## Regenerate distributed adapters

Regenerate all adapters from the authoritative Profile source:

```sh
bash .highway/tools/generate-agent-adapters.sh
```

The generated copies should be byte-identical to the source and tracked by
`.highway/tools/.adapter-manifest`.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
 git diff --check
```

Expected outcome: the focused contract, adjacent Profile contracts, adapter correspondence checks, and
full suite exit successfully; `git diff --check` reports no whitespace errors. No network service or
runtime process is required.
