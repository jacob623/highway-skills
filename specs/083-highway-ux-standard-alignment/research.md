# Research: Highway UX Standard Alignment

## Decision: Keep one authoritative UX contract in the Experience Standard

Decision: Add the Interactive Workflow UX Contract as a reusable section inside `.highway/governance/experience-standard.md`, scoped beneath the existing interaction rules and without changing X2.2-X2.6 or adding X identifiers.
Rationale: The feature specification names the Experience Standard as the authority. This preserves one governance source, allows shared terminology and applicability guidance, and keeps domain-specific workflow behavior in the owning skills.
Alternatives considered: A standalone library document or skill-owned copies were rejected because they would create a second authority and permit wording drift. Adding a new X rule was rejected because the contract organizes existing rules rather than changing their normative obligations.

## Decision: Use direct, applicability-aware skill references

Decision: Each of the eight in-scope skills references the Interactive Workflow UX Contract directly and states only the collection, activity, resume, outcome, and ownership provisions applicable to its workflow.
Rationale: FR-002A permits direct references and applicability statements. This keeps the shared principles in one place while preserving Profile, Objective, Control, NFR, request, Discovery, ADR, and Clarify terminology and owner authority.
Alternatives considered: Copying the full contract into every skill was rejected as duplication. Treating every skill as a Setup Wizard was rejected because Discovery and ADR retain non-wizard or domain-specific behavior, and progress is N/A when no meaningful ordered work exists.

## Decision: Validate documents with a mixed static and executable shell test

Decision: Add one focused test under `.highway/tools/tests/` that checks contract uniqueness, X2.2-X2.6 references and preservation, valid skill references, required applicable fields, outcome/resume vocabulary, ownership statements, and duplicate-authority absence. Include disposable fixtures and seeded negative probes where the test claims executed behavior.
Rationale: The repository's existing test suite uses Bash 3.2-compatible static assertions, disposable fixtures, and explicit seeded-failure probes. A mixed test can distinguish document evidence from executable fixture evidence while remaining dependency-free.
Alternatives considered: Runtime observation was rejected by FR-025 and the repository has no conversation observer. A separate test per skill was rejected because one focused contract test can enforce cross-file correspondence without duplicating harness logic.

## Decision: Do not create external interface contracts

Decision: Do not create `contracts/` artifacts for this feature.
Rationale: The project is an internal governance/documentation and shell-tooling repository. The feature changes Markdown instructions and validation, not an API, CLI schema, wire protocol, or external data exchange. The user-facing contract is documented in the Experience Standard and skill files themselves.
Alternatives considered: A synthetic API or command schema would misrepresent the project boundary and add maintenance without improving validation.

## Decision: Preserve generated correspondence and regenerate only when required

Decision: Treat changed skill source documents as inputs to the existing catalog/adapter correspondence checks. Regenerate generated outputs only if the repository's generator workflow requires it; verify that generated artifacts and distribution packaging remain consistent.
Rationale: The constitution requires generated-artifact integrity and dependent review. Feature 083 does not add a new generator or distribution path, so unnecessary generated churn should be avoided while correspondence is still proven.
Alternatives considered: Manually editing generated adapters was rejected by the repository's generator rules. Ignoring generated outputs was rejected because stale correspondence can ship outdated skill content.

## Decision: Apply explicit resume and no-long-running-activity conventions

Decision: Each in-scope skill declares exactly one resume applicability state. Workflows without meaningful ordered or long-running activity use the repository's N5 applicability condition for X2.5/X2.6 rather than manufacturing progress fields.
Rationale: This makes interruption semantics observable without introducing hidden persistence and preserves the existing Experience Standard applicability boundary.
Alternatives considered: Persisting unanswered prompts or adding Setup checkpoints was rejected by FR-025 and the feature's explicit out-of-scope constraints. Artificial progress for read-only analysis was rejected because it would reduce user clarity.
