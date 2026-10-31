---
name: codify-record
description: "Complete output skeleton for one accepted automation proposal."
metadata:
  version: 2.0.0
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

<one sentence for this automation>

## Description

<what this one automation does, for whom, and what it returns>

## Diagram

<one fenced flowchart block, shaped as the Diagram Block below>

## Acceptance Criteria

- <one observable result of this automation; at least one>

## Components

- **<component name>:** Responsibility: <its part of this automation>. Boundary: <where that part starts and stops>.
- or `None`

## Current State

<the sentence used to decide the instance, or `None`>

## Action

<the one automation>

## Day

<Day 1 or Day 2>

## Means

<title of the accepted architecture>
```

The id is `CDY` plus eight hex digits derived from the automation title. `implementation` is the accepted implementation this automation serves. `architecture` is the accepted architecture used as the means. `status` is `accepted`.

The body is the accepted proposal. It states one action. The title and summary are the ones the person selected. It does not copy the implementation, the architecture, or the decision. It does not contain a plan, tasks, or an instruction to run the automation.

## Diagram Block

```flowchart
flowchart LR
  C1["<first component>"] -->|<action>| C2["<next component>"]
```

One node per component, in the order of `## Components`. Each arrow goes to the next component and is labeled with the action. When components are `None`, the block has one node, the action title, and no arrow.

## Readme

The same folder contains `README.md` with two parts, in this order.

```markdown
## Implement

<what is put in place, where it goes, and how to enable it, including preparation>

## Use

<how a non-technical person starts this one automation, what they provide, and what comes back>
```

Implement is for the person who accepted the proposal. Use follows the interface of the accepted means. Use does not ask that person to edit the generated files or read the implementation record.
