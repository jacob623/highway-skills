# Feature 033 Data Model

## Setup State

The ordered readiness snapshot for one repository.

| Field | Description | Validation |
|---|---|---|
| `project_root` | Repository root discovered from `.highway/` | Must be resolved; otherwise setup aborts without guessing |
| `profile_status` | `Complete`, `Missing`, `Blocked`, or `Not Evaluated` | Complete only when the Profile owner recognizes a valid profile and `organization.name` is non-empty |
| `objectives_status` | `Complete`, `Missing`, `Blocked`, or `Not Evaluated` | Complete only when at least one valid user-owned objective record exists |
| `controls_status` | `Complete`, `Missing`, `Blocked`, or `Not Evaluated` | Complete only when the Control owner recognizes an initial valid baseline |
| `nfr_status` | `Complete`, `Missing`, `In Progress`, `Blocked`, or `Not Evaluated` | Complete only when accepted NFR artifacts are present and valid; a pending proposal is not complete |
| `setup_status` | `Complete` or `In Progress` | Complete only when all four areas are Complete |
| `current_activity` | Current owner workflow or blocking step | Required for incomplete output; absent from the complete dashboard |

## Owner Workflow Result

The normalized result returned by an owning skill.

| Field | Description | Validation |
|---|---|---|
| `owner` | Owning skill identifier | Must be one of the declared owner routes |
| `outcome` | `Succeeded`, `Pending`, `Declined`, `Failed`, `Malformed`, or `Incomplete` | Every non-success outcome maps to one explicit setup stop or pause behavior |
| `artifact_state` | Resulting readiness evidence | Reassessed from repository state; never trusted solely from prose |
| `blocking_condition` | Actionable reason setup cannot continue | Required for `Pending`, `Declined`, `Failed`, `Malformed`, or `Incomplete` |

## Setup Dashboard

The deterministic user-facing projection of Setup State.

- Complete output uses the literal completion contract in `contracts/setup-output.md`.
- In-progress output uses the literal status contract with statuses and current activity substituted for the current blocking step.
- Later areas are `Not Evaluated` when an earlier prerequisite is incomplete.
- Ownership routes are guidance only; they do not transfer mutation authority to `highway-setup`.

## State Transitions

```text
Start
  -> Evaluate Profile
  -> [Profile incomplete] Profile Owner Workflow
  -> Reassess Profile
  -> Evaluate Objectives
  -> [Objectives incomplete] Objective Owner Workflow
  -> Reassess Objectives
  -> Evaluate Controls
  -> [Controls incomplete] Control Owner Workflow
  -> Reassess Controls
  -> Evaluate NFRs
  -> [NFRs missing] Control-Owned NFR Proposal
  -> [Proposal pending] Pause with In Progress dashboard
  -> [Accepted NFRs] Reassess NFRs
  -> Complete Dashboard

Any owner workflow:
  -> Declined | Failed | Malformed | Incomplete
  -> Blocking dashboard and stop
```
