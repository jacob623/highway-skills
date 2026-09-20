---
name: discovery-record
description: "Complete output skeleton for a retained Discovery analysis record."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
id: DISCXXXXXX
request: REQXXXXXX
status: proposed
---
```

## Body

```markdown
# <deterministic discovery title>

## Request

Request: REQXXXXXX

<authoritative Request evidence copied in source order>

## Research Findings

<deterministic findings from the closed Request evidence>

## Assumptions

<deterministic assumptions, or an explicit empty statement>

## Risks

<deterministic risks, or an explicit empty statement>

## Unknowns

<deterministic unknowns, or an explicit empty statement>

## Candidate Approaches

<explicit desired-change approaches, or the deterministic no-candidate statement>

## Objective Relationships

<advisory Objective candidates with rationale and confidence, or an explicit empty statement>

## Control Relationships

<advisory Control candidates with rationale and confidence, or an explicit empty statement>

## NFR Relationships

<advisory NFR candidates with rationale and confidence, or an explicit empty statement>
```

The skill owns generated analysis text and relationship observations. The Request and governance
baselines remain read-only inputs, and relationship sections never approve or mutate a baseline.
