---
product: CDY140b0b32
---

# Plan: Check reorder points

## Stories

### Story 1: Check reorder points

Done when: Calls the order service stock query and saves the result as a workflow artifact.

## Edge Cases

- The order service is unavailable: the run fails and no artifact is saved.

## Functional Requirements

- FR-001: The workflow runs every night at 02:00 UTC. Source: Proposal. Story: Story 1.
- FR-002: The workflow reads no payment data. Source: Protect Customer Payment Data. Story: Story 1.
- FR-003: The query runs outside business hours. Source: Order Service Monthly Availability. Story: Story 1.

## Decisions

- Nightly at 02:00 UTC. Why: outside business hours. Rejected: every hour.
