# Feature 117 Quickstart

This guide validates the Experience Standard amendment after implementation.

## Prerequisites

- Run from the repository root.
- Use the repository's Bash-compatible shell environment.
- Ensure Feature 117's plan and implementation changes are present.

## Focused validation

Run the tests that directly pin the amended standard and its interaction contract:

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/experience-x23-contract.test.sh
```

Expected result: each command exits `0` and reports an `OK` or `PASS` result.

These checks validate:

- the 5.0.0 to 6.0.0 amendment metadata;
- stable existing X rules and the required interaction observables;
- recommendation, Decision Context, review, Setup transition, synthesis, and owner-result behavior;
- corrected non-normative examples and the absence of superseded wording.

## Full validation

Run the repository suite:

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: the summary reports zero failed tests.

## Manual consistency review

Compare the amended standard with these authoritative owner documents:

- `.specify/memory/constitution.md`
- `.highway/skills/highway-setup/SKILL.md`
- `.highway/skills/highway-profile/SKILL.md`
- `.highway/skills/highway-objectives/SKILL.md`
- `.highway/skills/highway-controls/SKILL.md`
- `.highway/skills/highway-nfrs/SKILL.md`

Confirm that shared presentation rules remain in the Experience Standard while each owner retains its
own domain semantics, persistence, readiness, identifiers, derivation, and orchestration behavior.

## Expected acceptance evidence

- Existing X identifiers remain stable and no retired identifier is reused.
- The footer and sync impact report identify version `6.0.0` and the MAJOR rationale.
- No Constitution rule sentence is copied into the Experience Standard.
- Normal orchestrated output hides machine-only owner results, while direct result requests remain visible.
- Profile compatibility remains limited to its four readiness domains, with optional enrichment non-blocking.
