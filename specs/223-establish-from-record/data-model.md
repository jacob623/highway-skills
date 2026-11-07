# Data Model: Establish From Record

## Execution

Stored on the accepted implementation record.

| Field | Values | Rules |
|---|---|---|
| Deployed by | Platform title and its Implementation ID, or Needed | Earliest kind: pipeline, orchestrator, desired-state, agent. A blank Kind is not a candidate |
| Managed by | Platform title and its Implementation ID, or Needed | Earliest self-service, otherwise agent, otherwise Deployed by |
| Language | Coding standard title, or None | Earliest standard whose Technology appears on its own in a Technology Choice `Choice:`. A version stays on that choice |

The person can replace any field before acceptance. A replacement platform is a catalog row, or the proposal waits for configuration or onboarding. A replacement language is a catalog title or None.

## Platform row

| Field | Values | Rules |
|---|---|---|
| Platform | Title | Unchanged |
| Implementation ID | RI id | Unchanged |
| Kind | `agent`, `pipeline`, `orchestrator`, `self-service`, `desired-state`, or blank | Blank until configuration. GitOps is stored as `desired-state`. A self-service platform is `self-service` |
| When to use | Entries separated by `; ` | Unchanged for a platform row |
| When not to use | Entries separated by `; ` | Unchanged for a platform row |

## Platform standard

A coding standard whose Technology is a platform title, the whole value, compared without regard to case.

| Field | Values |
|---|---|
| When to use | `[Platform] is used` |
| When not to use | `[Platform] is not used` |

A standard that is not a platform standard keeps its class entries.

## Codify proposal

| Field | Values | Rules |
|---|---|---|
| Executor | Deployed by or Managed by | Deployed by when the action title contains `establish`. Managed by otherwise. Not copied onto tasks |
| Task Provider | The platform that task uses | Chosen by the model. May differ from the Executor. A name that is not a catalog row does not start configuration or onboarding |
| Method | How the task is done | May name Helm, Terraform, CloudFormation, or another tool |
| Standards | Ordered titles | Language stays on a task that writes the custom solution. The platform standard stays when its Technology appears on its own in the task Provider |

## State

1. The implementation proposal holds the three fields.
2. Acceptance writes them on the record.
3. Configuration writes Kind on the platform row.
4. A codify proposal reads the record and does not write it.
