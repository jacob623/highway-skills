# Highway Setup Output Contract

## Complete

When Profile, Business Objectives, Controls, and accepted NFRs are complete, emit exactly:

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

## In Progress

When setup is blocked or awaiting an owner decision, emit the same heading and ordered fields. Replace statuses and current activity with the actual state. The canonical example is:

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

The complete dashboard MUST NOT be emitted while any status is incomplete, blocked, pending, or not evaluated.

Before a Control-owned NFR proposal starts, the NFR status is `Missing`. While the proposal awaits author acceptance, the NFR status is `In Progress` and the complete dashboard remains withheld.
