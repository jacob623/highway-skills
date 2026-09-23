# Data Model: Highway UX Standard Alignment

This feature changes governance and skill instruction documents. It introduces no runtime database, hidden state store, or external schema. The entities below are document-level contract concepts used for validation and implementation planning.

## Interactive Workflow UX Contract

- **Authority**: Exactly one section in `.highway/governance/experience-standard.md`.
- **Purpose**: Organizes and scopes X2.2-X2.6 for applicable interactive workflows.
- **Required concepts**: Next-action priority, implementation-detail boundary, one unresolved collection question, current activity, applicable progress, User Exit versus Owner Outcome, ownership boundaries, and resume applicability.
- **Validation**: Must reference X2.2-X2.6, preserve their normative text, introduce no new X identifiers, and have no authoritative duplicate in a skill or standalone library file.

## Guided Collection Progress Report

- **Fields**: Workflow-specific current item/activity plus either completed and remaining counts or position and remaining count.
- **Examples**: `Current Question`, `Completed Questions Count`, `Remaining Questions Count`, `Current Activity`; `Current Candidate`, `Candidate Position`, `Remaining Candidates`, `Current Activity`.
- **Applicability**: Required only when meaningful ordered work or long-running activity exists; otherwise the owning skill records the applicable N/A condition.
- **Validation**: At most one unresolved response-demanding question or decision is active.

## User Exit

- **Values**: `pause`, `cancel`, `stop responding`.
- **Meaning**: A user-directed end or suspension of the current interaction.
- **Validation**: Must not be classified as an Owner Outcome and must state what a later invocation does.

## Owner Outcome

- **Values**: `declined`, `aborted`, `blocked`.
- **Meaning**: A result returned by the owner workflow that describes owner state or authority.
- **Validation**: Must not be presented as user intent or a User Exit.

## Resume Applicability

- **Values**: `Persisted owner evidence`, `Transient interaction state`, `New interaction`, `Not Applicable`.
- **Meaning**: The single declared state governing what a later invocation can resume.
- **Validation**: A skill must not claim restoration of unsupported unanswered questions, drafts, cancellation markers, or hidden checkpoints.

## Ownership Boundary

- **Scope**: Identifiers, artifacts, catalogs, proposals, candidates, relationships, completion claims, and other domain records.
- **Rule**: The owning workflow retains authority to create, update, remove, replace, approve, reject, or complete its records.
- **Validation**: An aligned skill must not allocate identifiers, write artifacts, modify catalogs, or claim completion on behalf of another workflow.

## In-Scope Workflow Set

- **Guided collection**: Profile, Objectives, Controls, NFRs, New, and Clarify.
- **Activity-focused non-wizard workflows**: Discovery and ADR.
- **Explicitly outside guided collection**: Help and Relationships unless their applicable behavior changes.
