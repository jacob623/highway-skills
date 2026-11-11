---
product: CDY140b0b32
---

# Plan: Send the weekly restock alert

## Stories

### Story 1: Query items below reorder point

Done when: Calls the order service stock query for items at or below their reorder point.

### Story 2: Email the restock list

Done when: Sends the list to the warehouse lead.

## Edge Cases

- No item is below its reorder point: the email says nothing needs restocking.

## Functional Requirements

- FR-001: The workflow runs every Monday at 06:00 UTC. Source: Proposal. Story: Story 1.
- FR-002: The workflow reads no payment data. Source: Protect Customer Payment Data. Story: Story 1.
- FR-003: The query runs before business hours. Source: Order Service Monthly Availability. Story: Story 1.
- FR-004: One email lists every item below its reorder point. Source: Proposal. Story: Story 2.

## Decisions

- Monday at 06:00 UTC. Why: before the warehouse opens. Rejected: Sunday evening.
