# Request Artifact Contract

## Request Record

Path: `requests/REQXXXXXX.md`

Required structure:

```markdown
---
id: REQ000001
status: proposed
---

# Deterministic Title

## Problem

## Actors

## Current Process

## Desired Change

## Success Measure

## Business Constraints

## Completeness

Complete | Incomplete
```

Rules:

- The identifier is `REQ` plus exactly six digits.
- The title uses an explicit requester title or deterministic Problem-derived generation.
- The six evidence sections are user-authored except for the explicit Business Constraints absence statements.
- No Context References, Related Objectives, Related Controls, or Related NFRs sections exist.
- Secrets and regulated personal data are not written.
- Status is `proposed` for records created by Version 1.

## Request Catalog

Path: `requests/requests.md`

Required fields:

```markdown
# Requests Catalog

Version: 1.0.0

Next ID: REQ000002

| ID | Title | Status |
|----|-------|--------|
| REQ000001 | Deterministic Title | Proposed |
```

Rules:

- The catalog owns `Version`, `Next ID`, and the request index.
- Missing catalog bootstrap initializes `Version: 1.0.0` and `Next ID: REQ000001`.
- Allocation never derives an ID from filenames, directory contents, or observed maxima.
- Each created request gets exactly one catalog index entry.

## Transaction Contract

The skill reads the catalog, allocates an identifier, builds both artifacts, validates both, and writes both as one transaction. Any failure writes nothing and preserves original bytes.
