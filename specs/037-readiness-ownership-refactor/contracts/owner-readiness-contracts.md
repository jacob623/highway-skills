# Owner Readiness Contracts

## Profile

- Valid non-empty `organization.name`: `Complete`; next action `None`.
- Absent, empty, or whitespace-only identity: `Missing`; next action `/highway-profile setup`.
- Malformed or contradictory profile structure: `Blocked`; next action identifies repair; blocking reason is non-empty.

## Objectives

- At least one valid Objective with consistent catalog and next identifier state: `Complete`; next action `None`.
- No valid Objective records: `Missing`; next action `/highway-objectives setup`.
- Malformed record, catalog, or next identifier state: `Blocked`; blocking reason identifies the invalid state.

## Controls

- At least one valid Control with a consistent baseline: `Complete`; next action `None`.
- No valid Controls: `Missing`; next action identifies the Control creation workflow.
- Malformed or inconsistent baseline: `Blocked`; blocking reason identifies the inconsistency.

## NFRs

- Candidate generation unavailable or malformed: `Blocked`; blocking reason identifies the generation failure.
- Zero candidates and no accepted NFR artifacts: `Not Applicable`; next action `None`.
- Candidates exist and none are accepted: `In Progress`; next action identifies author review.
- Accepted valid NFR artifacts exist: `Complete`; next action `None`.
