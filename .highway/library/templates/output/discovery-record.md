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

## Candidate Solution Options

<two through five deterministic, viable Candidate Solution Options in assigned OPT order>

### OPTXXXXXX - <deterministic option title>

Summary: <deterministic architecture approach summary>

Benefits:
- <deterministic benefit>

Risks:
- <deterministic option-specific risk>

Assumptions:
- <deterministic option-specific assumption>

Dependencies:
- <unique dependency, or `None`>

Supporting Evidence:
- <closed, redacted evidence reference>

Alignment:
- Desired Change: <alignment value>
- Objective: <alignment value>
- Constraints: <alignment value>

Reference Architecture Matches:
- <RA identifier and highest-precedence match reason, or `None`>

## Candidate Solution Comparison Matrix

| Option ID | Desired Change | Objective | NFR | Control | Profile | Risk Reduction | Total | Reference Architecture Matches | Recommendation Status | Complexity | Governance Impact | Operational Overhead |
|-----------|----------------|-----------|-----|---------|---------|----------------|-------|-------------------------------|-----------------------|------------|-------------------|----------------------|
| OPTXXXXXX | 0 | 0 | 0 | 0 | 0 | 0 | 0 | None | Candidate | Low | Low | Low |

## Recommendation

Recommended Option: OPTXXXXXX

Scores:
- Objective (30): 0
- NFR (30): 0
- Control (20): 0
- Profile (10): 0
- Risk Reduction (10): 0
- Total: 0

Confidence: Low

Rationale: <deterministic advisory rationale>

Reference Architecture Matches: <RA identifiers, or `None`>

## Objective Relationships

<advisory Objective candidates with rationale and confidence, or an explicit empty statement>

## Control Relationships

<advisory Control candidates with rationale and confidence, or an explicit empty statement>

## NFR Relationships

<advisory NFR candidates with rationale and confidence, or an explicit empty statement>

## Reference Architecture Matches

<every independently matched Reference Architecture with identifier, confidence, highest-precedence
match reason, matched option identifiers, and Reference Implementation count, or an explicit empty
statement>
```

The skill owns generated analysis text and relationship observations. The Request and governance
baselines remain read-only inputs, and relationship sections never approve or mutate a baseline.
