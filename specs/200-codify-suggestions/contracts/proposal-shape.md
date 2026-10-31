# Contract: Proposal Shape

## Proposal block

The proposal still opens with `Here is a proposed starting point for your automation:` and still asks `What would you add, correct, or remove?` and `If this is accurate, just say so.`

The block contains, in this order: title, summary, description, diagram, acceptance criteria, components, current state, action, day, and means.

The title and the summary are the ones just selected. The action is that same automation.

## Diagram

One fenced block tagged `flowchart`. One node per component, in proposal order, with an arrow from each node to the next labeled with the action. When components are `None`, one node is the action title and there is no component arrow.

## Components

Each component line states the name, `Responsibility:`, and `Boundary:`. The boundary is where that responsibility in this automation starts and stops. `None` means the proposal names no component.

## Acceptance

At least one acceptance criterion is present before a write. Removing the last one stays on the proposal and writes nothing.

Acceptance saves every field above in `codify.md`. It does not run the automation and does not change the implementation.

## Record

`codify-record.md` version 2.0.0 adds `## Summary`, `## Description`, `## Diagram`, and `## Acceptance Criteria`. `## Components` states responsibility and boundary for each component, or `None`. `## Current State`, `## Action`, `## Day`, and `## Means` remain.
