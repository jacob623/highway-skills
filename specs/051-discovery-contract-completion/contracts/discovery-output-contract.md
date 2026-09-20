# Discovery Output Contract

## Purpose

Define the user-owned Discovery record, catalog, completion response, required content, and
no-output failure boundary.

## Outputs

- One user-owned Discovery record at `discoveries/DISCXXXXXX.md`.
- One user-owned Discovery catalog at `discoveries/discoveries.md`.
- The record contains Request Reference, Research Findings, Assumptions, Risks, Unknowns,
  Candidate Solution Options, Candidate Solution Comparison Matrix, Recommendation, Objective
  Relationships, Control Relationships, NFR Relationships, and Reference Architecture Matches.
- The catalog follows the shared Discovery catalog template.
- The completion response names the Discovery identifier, Request identifier, record path, and
  catalog path.

## Failure Boundary

Source resolution, validation, privacy review, scoring, allocation, or writing failure produces no
output and preserves existing bytes. Failure does not create an ADR, record a decision, authorize
implementation, or mutate governance baselines.

## Ordering and Ownership

The record is validated in shared-template order before writing. The catalog is allocated from its
existing identifier state and written as part of the existing ordered transaction. The record and
catalog remain user-owned outputs; ADR receives a read-only advisory handoff.
