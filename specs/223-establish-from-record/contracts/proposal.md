# Contract: Codify proposal

## `provider` in `highway-codify`

Read Execution on the selected implementation. The action is establishing when its title contains `establish`, compared without regard to case.

1. When the action is establishing, the Executor is Deployed by. Otherwise the Executor is Managed by.
2. When that value is `Needed`, empty, or names a platform with no row, emit `[Field] is needed. Name it on the implementation.` Write nothing else. Stay on `provider`.
3. Do not copy the Executor onto a task's Provider.
4. Do not take this implementation's row or the first catalog row.

## Draft

A task's Provider is the platform that task uses. It may differ from the Executor. Method names how, including a tool such as Helm, Terraform, or CloudFormation. The implementation being automated is a target, not the Executor.

## Proposal

```markdown
**Executor:** [Executor.]
```

The diagram starts at the Executor. Each task adds its Provider as a target. The arrow shape stays `P -->|[Next action]|`.

```markdown
flowchart TB
  P["[Executor]"] -->|[First action]| T1["[First task platform]"]
  P -->|[Next action]| T2["[Next task platform]"]
```

## `standards`

Keep two standards even when a When to use entry does not appear in the task:

- Language, on a task whose Provider or Method names that standard's Technology on its own.
- The standard whose Technology appears on its own in the task's Provider.

Any other candidate still drops when a When to use entry does not appear. A task with no standard says `No coding standard applies.` Its file is named at the product root from the task.

## Revise

An edit that names a different Executor changes the Executor and the diagram start. It does not change a task's Provider. An edit that names a different Provider changes that task only.

## Out of the catalog

A task Provider or Method that is not a platforms-catalog row does not follow `highway-codify-config` or `highway-onboarding`.
