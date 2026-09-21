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

## Request Reference

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

## Request Solution Constraints

allowed_solution_classes: <retained, privacy-filtered value>
existing_platforms_required: <retained, privacy-filtered value>
existing_platforms_preferred: <retained, privacy-filtered value>
known_systems: <retained, privacy-filtered value>
hosting_restrictions: <retained, privacy-filtered value>
vendor_restrictions: <retained, privacy-filtered value>
procurement_constraints: <retained, privacy-filtered value>
regulatory_restrictions: <retained, privacy-filtered value>

## Candidate Elimination Log

<empty when no candidates are excluded>

| Candidate ID | Candidate Title | Status | Constraint Category | Constraint Identifier or Value | Reason |
|--------------|-----------------|--------|---------------------|-------------------------------|--------|
| OPTXXXXXX | <candidate title> | Excluded | <category> | <identifier or value> | <deterministic reason> |

Entries are ordered by Candidate Identifier, then Constraint Category, then Constraint Identifier or Value.

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

Allowed Solution Class: <candidate class>

Alignment:
- Desired Change: <0-100>
- Objective: <0-100>
- Constraints: <0-100>

Constraint Alignment: <0-100>

Satisfied Constraints:
- <constraint identifier or `None`>

Unsatisfied Constraints:
- <constraint identifier or `None`>

Required Platform Match: 100 (traceability only)

Preferred Platform Match: <100 when used, otherwise 50>

Known-System Alignment: <100, 75, or 50>

Constraint Compliance: Fully Compliant

Reference Architecture Matches:
- <RA identifier and highest-precedence match reason, or `None`>

## Candidate Solution Comparison Matrix

| Option ID | Allowed Solution Class | Desired Change | Objective | NFR | Control | Constraint Alignment Score | Required Platform Match | Preferred Platform Match | Constraint Compliance | Risk Reduction | Total | Reference Architecture Matches | Recommendation Status | Complexity | Governance Impact | Operational Overhead |
|-----------|-------------------------|----------------|-----------|-----|---------|----------------------------|-------------------------|--------------------------|------------------------|----------------|-------|-------------------------------|-----------------------|------------|-------------------|----------------------|
| OPTXXXXXX | <class> | 0 | 0 | 0 | 0 | 0 | 100 | 50 | Fully Compliant | 0 | 0 | None | Candidate | Low | Low | Low |

## Recommendation

Recommended Option: OPTXXXXXX

Scores:
- Objective (25): 0
- NFR (25): 0
- Control (20): 0
- Constraint Alignment (20): 0
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
