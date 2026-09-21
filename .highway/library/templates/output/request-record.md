---
name: request-record
description: "Complete output skeleton for a retained business request record."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
id: REQXXXXXX
status: proposed
---
```

## Body

```markdown
# <deterministic request title>

## Problem

<user-authored problem evidence>

## Actors

<user-authored actor evidence>

## Current Process

<user-authored current-process evidence>

## Desired Change

<user-authored desired-change evidence>

## Success Measure

<user-authored success-measure evidence>

## Business Constraints

<user-authored constraint evidence or explicit no-constraint statement>

## Solution Constraints

allowed_solution_classes:
  - <user-owned solution class>
existing_platforms_required: []
existing_platforms_preferred: []
known_systems: []
hosting_restrictions: []
vendor_restrictions: []
procurement_constraints: []
regulatory_restrictions: []

## Completeness

Complete | Incomplete
```

The placeholders represent user-owned values. The template governs the presence and ordering of
request metadata and evidence sections; it does not define the meaning of user evidence.

Solution Constraints field shapes and states:

- `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`, and
  `known_systems` are list-shaped fields.
- `allowed_solution_classes` must contain one or more non-empty values or `unknown`; it cannot be
  empty because it defines the future Discovery candidate space. Reject an empty candidate space;
  the future Discovery handoff contains one or more allowed solution classes or `unknown`, never
  an empty list, and does not rank them.
- The other three list-shaped fields preserve a populated list, an explicit empty array, and
  `unknown` as distinct states.
- `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and
  `regulatory_restrictions` are scalar restriction fields. Each contains a non-empty value or
  `unknown`, never an empty array.
- Business Constraints uses `No business constraints` for confirmed absence while retaining its
  existing explicit empty state; `unknown` remains distinct for uncertainty.
- A malformed Solution Constraints value is corrected by naming the exact field, accepted shape,
  valid example, and replacement value or `unknown`; only the failed field is updated, collection
  continues without restarting the domain, and privacy-blocked replacements are not written.
