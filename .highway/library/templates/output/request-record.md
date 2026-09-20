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
