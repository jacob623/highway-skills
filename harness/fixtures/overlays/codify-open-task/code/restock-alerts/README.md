## Setup Instructions

Copy `.github/workflows/restock-alert.yml` into the repository that holds the restock alerts. Add three repository secrets: `STOCK_TOKEN`, a read-only order service token, and `SMTP_USER` and `SMTP_PASSWORD` for the store's mail service. The workflow runs every Monday at 06:00 UTC once it is on the default branch.

## User Guide

The warehouse lead receives the restock list by email every Monday morning. To send it now, open the repository's Actions tab, choose Restock alert, and select Run workflow.
