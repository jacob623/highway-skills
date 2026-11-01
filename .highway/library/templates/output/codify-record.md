---
name: codify-record
description: "Complete output skeleton for one accepted automation proposal."
metadata:
  version: 4.0.0
---

## File Frontmatter

```yaml
---
id: CDYXXXXXX
implementation: RIXXXXXX
architecture: RAXXXXXX
status: accepted
---
```

## Body

```markdown
# <automation title>

## Summary

<one sentence that expands on the action>

## Description

<what this one automation does, for whom, and what it returns>

## Acceptance Criteria

- <one observable result of this automation; at least one>

## Diagram

<one fenced flowchart block, shaped as the Diagram Block below>

## Tasks

1. **<action>:**
   - **Scope:** <what the task does>
   - **Provider:** <the platform executing this automation>
   - **Method:** <how it is done, naming the plugins, modules, libraries, MCP servers, or APIs it uses>
   - **Assumptions:**
     - <what the task relies on that is not an earlier task, or `None`>
```

The id is `CDY` plus eight hex digits derived from the automation title. `implementation` is the accepted implementation this automation serves. `architecture` is the accepted architecture this automation follows. `status` is `accepted`.

The body is the accepted proposal. It states one action, and the title is that action. The title and summary are the ones the person selected. It does not copy the implementation, the architecture, or the decision. It contains no instruction to run the automation.

Each task is one action against one platform, object, or API, in the order the diagram shows. At least one task is present. Every task names the same Provider. The implementation this automation serves is a target, not the Provider.

## Diagram Block

```flowchart
flowchart TB
  P["<provider>"] -->|<first action>| T1["<first target>"]
  P -->|<next action>| T2["<next target>"]
```

The diagram is one logical flow. The first node is the Provider: the platform executing the automation. It is not a task. Each task adds one arrow from the Provider and one new node for its target, in task order. No arrow leaves a target. Each arrow label is its task's action and starts with a verb. Every target has its own node, even when two targets share a name.

## Readme

The same folder contains `README.md` with two parts, in this order.

```markdown
## Implement

<what is put in place, where it goes, and how to enable it, including preparation>

## Use

<how a non-technical person starts this one automation, what they provide, and what comes back>
```

Implement is for the person who accepted the proposal. Use follows the interface of the accepted architecture. Use does not ask that person to edit the generated files or read the implementation record.
