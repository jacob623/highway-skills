# Research: Controls Alignment Recommendation

## Decision 1: Keep the authoritative source in highway-controls

- **Decision**: Implement the interaction alignment in `.highway/skills/highway-controls/SKILL.md`; regenerate adapters, catalogs, and manifests from that source.
- **Rationale**: The repository is source-first. Generated agent-tree skills are distribution artifacts and must remain derived from the authoritative skill.
- **Alternatives considered**: Editing adapters directly was rejected because it would violate generated-artifact integrity and create drift.

## Decision 2: Reuse Objectives' proposal-first interaction pattern

- **Decision**: Mirror the established Objectives concepts for response support, grounded recommendations, user-authored alternatives, correction, acceptance, additional suggestions, continuation, and portfolio awareness, while retaining Control-specific ownership and persistence behavior.
- **Rationale**: The feature goal is alignment with an interaction model already proven in the repository. Reuse reduces behavioral divergence and keeps user-visible language parallel across governance owners.
- **Alternatives considered**: Retaining Concern -> Condition -> Obligation as the primary flow was rejected because it preserves the discovery-first experience the feature explicitly replaces. Replacing the Controls owner contract wholesale was rejected because persistence, classification, relationships, and NFR generation remain in scope as preserved behavior.

## Decision 3: Treat recommendations and queues as transient interaction state

- **Decision**: Recommendations, selection order, queue membership, proposal revisions, coverage guidance, and portfolio assessment remain transient. A Control becomes retained only after proposal presentation, explicit acceptance, and owner capture.
- **Rationale**: The existing retained Control record has no field for recommendation or queue state, and the specification explicitly forbids changing the retained record structure. This keeps selection distinct from capture and prevents unaccepted ideas from becoming accepted knowledge.
- **Alternatives considered**: Persisting queue or recommendation metadata was rejected because it would expand the Control schema and introduce lifecycle state not required by the feature.

## Decision 4: Keep Coverage Areas internal and subordinate

- **Decision**: Generate context-derived recommendations first, evaluate gaps across the five internal Coverage Areas, and add only useful context-adapted coverage-derived recommendations. Present one unified recommendation set without exposing the categories.
- **Rationale**: Coverage guidance improves breadth without establishing policy, deficiency, readiness, obligation, or user-facing workflow stages. Context remains the preferred grounding source.
- **Alternatives considered**: Asking users to select Coverage Areas or displaying category labels was rejected because it would turn internal recommendation guidance into a workflow concept.

## Decision 5: Validate both documents and behavior

- **Decision**: Use focused Controls tests for the interaction contract, existing persistence/classification/relationship/NFR tests for preserved behavior, generator tests for derived correspondence, and the full suite for final verification.
- **Rationale**: Static skill text proves contract presence but cannot prove runtime behavior by itself. The constitution requires behavioral evidence to remain distinct from static document-contract evidence.
- **Alternatives considered**: Relying only on text assertions was rejected because it would not demonstrate preserved executable behavior. Adding a new runtime framework was rejected because the repository already has the required shell harness and no dependency is needed.

## Decision 6: No external contracts artifact

- **Decision**: Do not create `contracts/` for this feature.
- **Rationale**: The change is an internal Markdown skill contract with existing owner output formats, not a new public API, endpoint, serialized schema, or cross-system interface. Existing output contracts remain documented in the authoritative skill and are covered by its tests.
- **Alternatives considered**: Creating a duplicate contract document was rejected because it would compete with the skill's authoritative contract and increase drift risk.
