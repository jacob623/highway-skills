# Contract: the harness experience invariant, selection, and paths

## Driver

`DriveResult.skillsBeforeOutput: string[]` holds each skill invoked before the first output the
person sees.

The first output is the earlier of:

- the first question sent to the person (`onUserInputRequest`);
- the first `assistant.message` with no `parentToolCallId`, non-empty `content`, and no
  `toolRequests` (absent or empty).

When neither happens, the list holds every skill invoked.

## Check

`experienceInvariant(skillsBeforeOutput): CheckFailure[]` in `harness/src/checks.ts`:

- returns `[]` when `highway-experience` is in the list;
- otherwise returns one failure: check `experience`, path `highway-experience`, expected
  `highway-experience activated before the first output`, actual the list or `no skill`.

The runner adds it with kind `experience-order` for every attempt whose outcome is not `error`.
`failure.ts` gives the kind a likely cause naming the skill's activation step.

Tests:

- `harness/test/checks.test.ts`: the pass case, and a seeded run without the skill that fails.
- `harness/test/runner.test.ts`: a driver result without the skill fails the attempt with
  `"kind":"experience-order"`, and the existing passing cases still pass.

## Selection

`harness/selection/shared.txt`:

```text
smoke	skills/highway-experience/**
```

`harness/bin/path-map.sh` maps:

- every file under `skills/highway-experience/` to `smoke smoke`;
- `.highway/governance/*` and `.highway/instructions/*`, which no longer exist, to `none` ("not a
  shipped skill input").

## Paths helper

`framework/lib/paths.sh`:

- `HW_EXPERIENCE="$HW_SKILLS/highway-experience"`;
- `hw_doc experience-standard`, `hw_doc storage`, and `hw_doc highway-identity` resolve to
  `$HW_EXPERIENCE/references/experience-standard.md`, `storage-contract.md`, and
  `highway-identity.md`;
- no `HW_GOVERNANCE`, `HW_INSTRUCTIONS`, `HW_CURSOR_RULES`, `HW_CLAUDE_MD`, `HW_COPILOT_MD`, or
  `HW_AGENTS_MD`.
