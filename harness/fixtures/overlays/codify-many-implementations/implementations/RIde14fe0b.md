---
id: RIde14fe0b
architecture: RA34f8fb1c
status: accepted
---

# Northwind Returns Portal

## Architecture Reference

Architecture: RA34f8fb1c
Title: Delivery Pipeline Platform
Status: accepted

## Variation Choices

- Workflow runner: GitHub-hosted runners deploy the portal

## Coverage

| Responsibility | Status |
|---|---|
| Run workflows on change, on schedule, or by hand | covered |
| Keep credentials out of workflow files | covered |

Conformance: compatible

## Realized Interfaces

- Workflow definition files: portal deployment workflow

Conformance Evidence: None

## Limitations

None

## Technology Choice

Intent: A self-service returns page.
Choice: Loop Returns
Reason: Connects to the store without custom code.
Evidence: Current subscription.

## Execution

Deployed by: GitHub Actions (RI680202d2)
Managed by: GitHub Actions (RI680202d2)
Language: None

## Context

An instance is running for customer returns.

## Implementation Summary

Customers start returns on a hosted returns page connected to the store.

## Realized Capabilities

- Title: Customer return request
  Realized By: Loop Returns
  Evidence: Customers start returns on the portal today.

## Runtime Components

- Returns page: Customer returns

## Data Realization

Return requests are held by Loop Returns.

## Integration Realization

The portal reads orders from the store.

## Security Control Realization

CTLf124f030: Refunds go through the store's payment provider.

## NFR Realization

None

## Assumptions

None

## Risks

None

## Constraints

None

## Dependencies

Loop Returns

## Traceability

Request: None
Discovery: None
ADR: ADR03680218
Implementation: RIde14fe0b
