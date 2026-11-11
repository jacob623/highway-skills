---
id: RA34f8fb1c
status: accepted
---

# Delivery Pipeline Platform

## Current Decisions

- ADR03680218

Carries: A hosted pipeline that builds, deploys, and runs scheduled jobs.

## Context

Applies: When work needs to start from a repository change or a schedule.
Leaves Open: Which repositories use it.

## Architecture Summary

A hosted pipeline runs workflows defined in each repository. A workflow starts on a change, on a schedule, or by hand.

## Architecture Style

Style: Hosted pipeline
Why: The team does not run its own servers.

## Logical Components

- Component: Workflow runner
  Responsibility: Runs workflow steps on hosted machines.
  Interface: Workflow definition files
- Component: Secrets store
  Responsibility: Holds credentials for workflows.
  Interface: Named secrets

## Information

Workflow definitions and run logs, owned by each repository. Secrets never appear in logs.

## Variation

Must Keep: Workflows defined in the repository and credentials kept in a secrets store.
May Choose: None

## Responsibilities

- Run workflows on change, on schedule, or by hand
- Keep credentials out of workflow files

## Interaction Model

A trigger starts a workflow, and the runner executes its steps.

## Trust Boundaries

Secrets are scoped to a repository.

## Deployment Pattern

Hosted runners.

## Constraints

Payment data is never handled (CTLf124f030).

## Objective Relationships

None

## Control Relationships

- CTLf124f030: bound by

## NFR Relationships

None

## Required Capabilities

- Component: Workflow runner
  Capability: Scheduled workflow run
- Component: Workflow runner
  Capability: Repository workflow automation

## Assumptions

None

## Risks

None

## Reference Implementation Guidance

Use the hosted runner the team already pays for.

## Traceability

Request: None
Discovery: None
Current Decisions: ADR03680218
Architecture: RA34f8fb1c
