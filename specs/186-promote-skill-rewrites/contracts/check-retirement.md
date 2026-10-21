# Contract: Check retirement

A check is retired only when its assertions exist to enforce the previous skill interaction. The retirement record is `specs/186-promote-skill-rewrites/retirements.md`. Each entry names the check and the superseded behavior.

These behaviors are superseded for the twelve promoted skills:

- Readiness fields Status, Summary, Next Action, Blocking Reason, Missing, Complete, and Blocked
- Sequential next-identifier allocation
- The previous architecture identifier prefix
- Transcript locks on the previous Profile, Objectives, Controls, Non-Functional Requirements, Setup, Request, Discovery, Decision, architecture, implementation, onboarding, and assessment wording

A mixed check loses only the assertions for those behaviors. Checks for the constitutions, the experience standard, skill authoring, generators, and shared templates remain.

New invariant checks must fail on the pre-promotion skills, and that failure must be recorded, before the drafts replace those skills.
