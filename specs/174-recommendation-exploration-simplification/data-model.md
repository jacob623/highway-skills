# Data Model: Recommendation Exploration Simplification Pass

This feature changes workflow contracts and does not add durable storage. The entities below are
transient interaction concepts already present in the owner skills; their boundaries are clarified,
not expanded.

## Recommendation Set

- **Owner**: One of `highway-objectives`, `highway-controls`, or `highway-nfrs`.
- **Contents**: Grounded Working Ideas for that owner's artifact type.
- **Identity**: Recommendations remain distinguishable from accepted artifacts and from duplicate or overlapping recommendations.
- **Lifecycle**: Presented -> under exploration -> selected or declined -> exhausted or replaced by additional suggestions.
- **Validation**: Recommendations must be grounded and useful; no recommendation is manufactured solely to fill coverage.

## Selected Artifact Queue

- **Owner**: The domain skill that presented the recommendations.
- **Contents**: Selected recommendations in selection order.
- **Identity**: Queue membership is distinct from review, proposal development, acceptance, and capture.
- **Lifecycle**: Empty -> selected items -> available for review after exhaustion or explicit review intent -> sequential lifecycle processing.
- **Validation**: Selection does not directly capture an artifact or imply user acceptance.

## Review Intent

- **Owner**: The person using the domain workflow.
- **Meaning**: An explicit request to review selected Objectives, Controls, or NFRs.
- **Effect**: Ends recommendation exploration before exhaustion when explicitly requested and hands selected artifacts to the existing owner lifecycle.
- **Non-effect**: Does not itself accept, persist, or capture an artifact.

## Domain Artifact

- **Types**: Objective, Control, or NFR.
- **Lifecycle**: Selected or user-authored -> proposal presented -> correction, replacement, rejection, or acceptance -> capture -> continuation or explicit finish.
- **Ownership**: The corresponding owner skill remains responsible for proposal development, acceptance, persistence, and capture.
- **Validation**: Existing type-specific lifecycle and acceptance rules remain unchanged.

## Creation Workflow Orchestrator

- **Role**: Entry-point routing only.
- **Inputs**: Active user intent and accepted context, with or without useful grounded recommendations.
- **Routes**: Recommendation Presentation and Exploration, canonical no-recommendation question path, review of selected artifacts, existing Domain Development Lifecycle, continuation, and explicit finish.
- **Constraint**: It must not redefine rules owned by those dedicated sections.
