# Discovery Artifact Contract

## Record Structure

The shared record template remains authoritative. Its body order is Request, Research Findings,
Assumptions, Risks, Unknowns, Candidate Solution Options, Candidate Solution Comparison Matrix,
Recommendation, Objective Relationships, Control Relationships, NFR Relationships, and Reference
Architecture Matches. The catalog template remains authoritative for `DISC` allocation and index
serialization.

## Candidate Solution Options

Each option has a unique Discovery-scoped `OPT` identifier in the `OPT` plus six-digit format,
title, summary, benefits, risks, assumptions, dependencies, and supporting evidence. Options are
deduplicated and sorted before identifiers are assigned. A successful record contains two through
five viable options.

## Matrix and Recommendation

The matrix contains every option in option order, all five weighted score components, total score,
Reference Architecture matches, Recommendation Status, and mandatory Complexity, Governance
Impact, and Operational Overhead classifications. Exactly one option is `Recommended`.

Weights are Objective 30, NFR 30, Control 20, Profile 10, and Risk Reduction 10. Zero denominators
produce zero; totals are the sum of components and remain 0-100. Confidence is High for 90-100,
Medium for 70-89, and Low for 0-69. Matrix and Recommendation scores are identical.

Informational classifications do not affect score, confidence, ranking, selection, or option order.
Complexity uses dependency count; Governance Impact uses unique matched Objectives, Controls, NFRs,
and Reference Architectures; Operational Overhead uses the nine named operational dependency
categories and the thresholds defined in `data-model.md`.

## Reference Architecture Matches

Every candidate is evaluated independently using exact matching precedence: explicit identifier,
normalized title, capability identifier, Objective identifier, Control identifier, then NFR
identifier. Every matching candidate is reported with its highest-precedence reason. Semantic,
similarity, and inference matching are excluded from Version 1.

## ADR Boundary

The artifact contains advisory analysis only. It does not record a selected or rejected option,
approval, architecture decision, implementation authorization, or governance mutation. ADR may
select any option and owns all decision persistence.

## Tie-Break

For equal scores, a matched Reference Architecture outranks no match. When all tied options have
matches, each option uses the highest Reference Implementation count among its matched Reference
Architectures. An absent or unreadable Reference Implementation catalog makes every count zero;
equal counts select the lower `OPT` identifier.

## Feature 049 Serialization Invariants

The record serializes Candidate Solution Options before the Candidate Solution Comparison Matrix,
then Recommendation, existing governance relationship sections, and Reference Architecture
Matches. The matrix repeats every option in option order, every score component, total, match list,
exactly one `Recommended` status, and Complexity, Governance Impact, and Operational Overhead.
Recommendation score fields are identical to the selected matrix row. The handoff remains a
read-only advisory projection and contains no decision or governance-mutation fields.