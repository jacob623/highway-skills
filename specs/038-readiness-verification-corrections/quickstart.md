# Feature 038 Quickstart

## Prerequisites

Run from the repository root on macOS or Linux with Bash 3.2-compatible syntax and the existing
Highway shell utilities. Feature 037 remains unchanged.

## Planning Validation

Confirm the plan has no template residue and uses canonical source paths:

```sh
grep -nE 'ACTION REQUIRED|\[e\.g\.|Option [0-9]|\[REMOVE IF UNUSED\]' specs/038-readiness-verification-corrections/plan.md
find specs/038-readiness-verification-corrections -type f -maxdepth 2 -print
```

Expected result: the grep returns no lines, and the plan, research, data model, contracts, and
quickstart files exist.

## NFR State Validation

Review [contracts/nfr-readiness-state-contract.md](contracts/nfr-readiness-state-contract.md) and
verify every NFR fixture and route uses one of its five ordered rows. `Missing` must not appear in
NFR-specific Feature 038 contracts, fixtures, or coverage records.

## Executable Owner Validation

Run the executable owner fixture test created by Feature 038:

```sh
bash .highway/tools/tests/readiness-executable.test.sh
```

Expected result: disposable Profile, Objective, Control, and NFR fixtures produce parsed four-field
responses, preserve before/after hashes, and remain identical across three runs.

## Setup Routing Validation

```sh
bash .highway/tools/tests/highway-setup-executable.test.sh
```

Expected result: captured owner responses route in Profile, Objectives, Controls, NFR order, stop at
the first non-complete prerequisite, and distinguish retained NFR routes.

## Evidence Report

```sh
bash .highway/tools/tests/feature-038-evidence-report.sh /tmp/feature-038-evidence.tsv
```

Expected result: the report contains separate executable owner, Setup routing, static contract,
generated artifact, requirement coverage, and limitation results.

## Static and Generated Validation

```sh
bash .highway/tools/tests/readiness-contract.test.sh
bash .highway/tools/tests/feature-038-plan.test.sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/tests/run-all.sh
bash .highway/tools/tests/spec-record.test.sh
git diff --check
```

Expected result: static checks, generated correspondence, the full suite, spec-record integrity, and
whitespace validation all pass. Report these results separately from executable evidence.
