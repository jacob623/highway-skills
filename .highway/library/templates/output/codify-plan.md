---
name: codify-plan
description: "Complete output skeleton for the plan of one accepted feature."
metadata:
  version: 2.0.0
---

## File Frontmatter

```yaml
---
product: CDYXXXXXX
---
```

## Body

```markdown
# Plan: <automation title>

## Stories

### Story 1: <one outcome a person can see>

Done when: <the condition that shows this outcome is reached>

## Edge Cases

- <a situation the accepted acceptance criteria do not name, and what happens>

## Functional Requirements

- FR-001: <one requirement>. Source: <Proposal, Control or NFR title, or Standard title>. Story: <Story N>.

## Decisions

- <what was chosen>. Why: <reason>. Rejected: <alternative>.

## Data

- <entity>: <fields and the states it moves through>

## Interface

- <endpoint, file format, or command>: <inputs and outputs>
```

`product` is the `CDY` id of the product this feature belongs to. The file is `plan.md` beside `codify.md` in `code/<folder>/.highway/features/<number>-<action>/`.

The plan holds one story per proposal task. It does not include a task's scope, method, standards, or files.

Stories follow proposal task order. The title is that task's action. When an acceptance criterion contains that action, ignoring case, Done when is the earliest such criterion. Otherwise Done when is the task's Scope sentence.

Each functional requirement comes from the accepted proposal, an applied Control or NFR, or a coding standard on a task. It names that source and the story that carries it. Each applied Control or NFR is the source of at least one requirement.

Decisions holds only choices the proposal, the standards, and the Controls left open. A question the person was not asked is recorded here as an assumption. With no such choice, Decisions reads `None`.

Data is present only when the feature has state. Interface is present only when the accepted proposal names an endpoint, a file format, or a command. Each is otherwise omitted.
