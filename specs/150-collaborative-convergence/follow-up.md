# Follow-up Registration

**Feature**: 150 | **Date**: 2026-10-07 | **Discharges**: FR-037

Clarification Q5 chose repository-wide applicability with no skill-specific exemption (FR-036), and
verification limited to `highway-profile` (FR-038). The gap that creates is recorded here rather
than left implicit.

## What binds immediately

Rules X2.37, X2.41, and X2.42 through X2.57 of the Highway Experience Standard apply to every
Interactive Workflow from the moment this feature merges.

## What is verified in this feature

`highway-profile` only.

## What is not verified

| Skill | Known exposure |
|---|---|
| `highway-objectives` | Converges on authored objectives; open-acceptance form and attribution unverified |
| `highway-controls` | Presents recommendation sets; X2.47 and X2.54 unverified |
| `highway-nfrs` | Presents recommendation sets; X2.47 and X2.54 unverified |
| `highway-new` | Captures request substance; X2.37 and X2.41 unverified |
| `highway-discovery` | Materially interprets discovered evidence; X2.52 and X2.53 unverified |
| `highway-adr` | Converges on decision records; X2.49 and X2.51 unverified |
| `highway-clarify` | Owns persisted clarification records; interaction with X2.50 unverified |
| `highway-setup` | Orchestrates the others; X2.57's per-subject budget across domains unverified |

## Obligation

A follow-up specification brings these eight skills into verified conformance. It is not in this
feature's scope, and this feature makes no claim that they conform.
