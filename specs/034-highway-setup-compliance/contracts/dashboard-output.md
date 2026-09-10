# Feature 034 Dashboard Output Contract

Feature 033's original exact-output contract is authoritative. The following blocks are byte-significant: tab characters, line endings, blank lines, labels, and route text must be preserved.

## Complete

```text
Highway Setup Status

Profile: Complete
Business Objectives: Complete
Controls: Complete
NFRs: Complete

Setup: Complete

Governance Management

Profile:
	/highway-profile

Business Objectives:
	/highway-objectives

Controls and NFRs:
	/highway-controls

Help:
	/highway-help

Advanced Administration

Relationships:
	/highway-relationships

Questionnaire:
	/highway-inquiry
```

## In Progress: Objective Setup

```text
Highway Setup Status

Profile: Complete
Business Objectives: Missing
Controls: Not Evaluated
NFRs: Not Evaluated

Setup: In Progress

Current Activity:
Business Objective Setup
```

## In Progress: Pending NFR Acceptance

```text
Highway Setup Status

Profile: Complete
Business Objectives: Complete
Controls: Complete
NFRs: In Progress

Setup: In Progress

Current Activity:
NFR Author Acceptance
```

The complete dashboard MUST NOT be emitted for any Missing, In Progress, Blocked, or Not Evaluated state.
