---
id: CDY140b0b32
implementation: RIde140b32
architecture: RA22140b24
status: accepted
---

# Check reorder points

## Summary

Checks reorder points each night and lists the items below them.

## Description

Every night, a GitHub Actions workflow asks the order service for items at or below their reorder point and saves the list as a workflow artifact the warehouse lead can open.

## Acceptance Criteria

- Each night's run saves one list of every item at or below its reorder point.

## Diagram

```flowchart
flowchart TB
  P["GitHub Actions"] -->|Check reorder points| T1["Northwind Order Service"]
```

## Tasks

1. **Check reorder points:**
   - **Scope:** Calls the order service stock query and saves the result as a workflow artifact.
   - **Provider:** GitHub Actions
   - **Method:** A nightly scheduled workflow calls `GET /stock?below=reorder` with a read-only token and uploads the response with `actions/upload-artifact`.
   - **Standards:**
     1. No coding standard applies.
   - **Files:**
     1. `.github/workflows/reorder-check.yml`
   - **Assumptions:**
     - A read-only stock token is stored as the `STOCK_TOKEN` repository secret.

**Controls and NFRs:**

- Protect Customer Payment Data
- Order Service Monthly Availability

**Proposed project:** Existing restock-alerts

**Rationale:** The nightly check serves the same warehouse lead with the same restock data, so it belongs with the weekly alert.
