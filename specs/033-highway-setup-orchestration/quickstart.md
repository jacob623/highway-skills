# Feature 033 Quickstart

## Prerequisites

- Run from the repository root.
- Bash 3.2-compatible shell is available.
- The `.highway/` directory and existing owner skills are present.
- Generated catalog and adapter tools are available.

## Structural Validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-setup
```

Expected result: exit status 0.

Observed during Feature 033 implementation: `OK: highway-setup orchestration contract passes`.

## Focused Behavioral Validation

```sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin bash .highway/tools/tests/highway-setup.test.sh
```

The focused test must verify:

1. Empty repository: Profile is first, later areas are `Not Evaluated`.
2. Profile complete: Objectives is the next evaluated and delegated area.
3. Profile and Objectives complete: Controls is the next delegated area.
4. Controls complete with missing NFRs: the Control-owned proposal path is invoked, setup pauses, and no NFR is authored by setup.
5. Accepted NFR artifacts: setup resumes and emits the exact complete dashboard.
6. Declined, failed, malformed, or incomplete owner outcomes: setup stops without downstream calls or false completion.
7. Complete repository rerun: no owner mutation occurs and artifact bytes remain unchanged.

## Registration and Packaging Validation

After adding or changing the source skill, run the repository generation workflow required by the current tool README, then run:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: all tests pass, including catalog, adapter, distribution, and shipped-tree checks.

Observed during Feature 033 implementation: `.highway/tools/tests/run-all.sh` exited 0 with all repository tests passing.

## Manual Contract Review

Compare the emitted output with:

- [Setup output contract](contracts/setup-output.md)
- [Owner delegation contract](contracts/owner-delegation.md)
- [Feature specification](spec.md)
