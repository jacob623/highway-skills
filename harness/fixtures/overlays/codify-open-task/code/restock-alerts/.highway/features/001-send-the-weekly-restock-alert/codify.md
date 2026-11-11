---
id: CDY140b0b32
implementation: RIde140b32
architecture: RA22140b24
status: accepted
---

# Send the weekly restock alert

## Summary

Sends the warehouse lead a weekly list of items to restock.

## Description

Every Monday morning, a GitHub Actions workflow asks the order service for items at or below their reorder point and emails the list to the warehouse lead.

## Acceptance Criteria

- The warehouse lead receives one email each Monday listing every item at or below its reorder point.

## Diagram

```flowchart
flowchart TB
  P["GitHub Actions"] -->|Query items below reorder point| T1["Northwind Order Service"]
  P -->|Email the restock list| T2["Store mail service"]
```

## Tasks

1. **Query items below reorder point:**
   - **Scope:** Calls the order service stock query for items at or below their reorder point.
   - **Provider:** GitHub Actions
   - **Method:** A scheduled workflow step calls `GET /stock?below=reorder` with a read-only token from repository secrets.
   - **Standards:**
     1. No coding standard applies.
   - **Files:**
     1. `.github/workflows/restock-alert.yml`
   - **Assumptions:**
     - A read-only stock token is stored as the `STOCK_TOKEN` repository secret.
2. **Email the restock list:**
   - **Scope:** Sends the list to the warehouse lead.
   - **Provider:** GitHub Actions
   - **Method:** A workflow step sends the list through the store's mail service with its SMTP credentials from repository secrets.
   - **Standards:**
     1. No coding standard applies.
   - **Files:**
     1. `.github/workflows/restock-alert.yml`
   - **Assumptions:**
     - SMTP credentials are stored as repository secrets.

**Controls and NFRs:**

- Protect Customer Payment Data
- Order Service Monthly Availability

**Proposed project:** New restock-alerts

**Rationale:** The weekly alert is the first automation for the restock alerts implementation, so it starts its own project.
