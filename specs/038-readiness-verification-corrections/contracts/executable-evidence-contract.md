# Executable Evidence Contract

## Owner Evaluation

For each owner fixture, the test harness MUST:

1. Create the disposable input tree.
2. Capture hashes for every fixture artifact and identifier source.
3. Invoke the documented readiness behavior or a deterministic test adapter explicitly mapped to that behavior.
4. Parse exactly four response fields and validate status-specific blocking-reason rules.
5. Capture after hashes and fail if any fixture artifact or identifier changed.
6. Repeat the unchanged evaluation two additional times and compare all response fields and hashes.

## Setup Evaluation

Setup fixtures feed captured owner responses in this order:

`Profile -> Objectives -> Controls -> NFRs`

Each non-complete prerequisite must stop evaluation before later owners. NFR `Complete` and
`Not Applicable` are terminal success. Each retained NFR non-complete state has a distinct route.

## Evidence Reporting

The final report separates:

- executable owner behavior
- Setup routing behavior
- static contract checks
- generated-artifact correspondence
- requirement coverage
- limitations

A passing static contract check MUST NOT be reported as executable owner behavior.
