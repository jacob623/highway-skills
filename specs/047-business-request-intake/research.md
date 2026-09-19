# Research: Business Request Intake

## Decision: Author one source skill and regenerate repository outputs

**Rationale**: The repository's authoring standard requires a single source at `.highway/skills/<id>/SKILL.md`; `.highway/catalog/` and the three agent trees are generated from it. This keeps the shipped skill, catalog registration, and adapters consistent.

**Alternatives considered**: Authoring agent-specific copies was rejected because generated adapters are the established distribution mechanism and hand-authored copies drift.

## Decision: Use natural-language skill workflow with explicit ordered rules

**Rationale**: Existing skills are Markdown instructions consumed by agents, not executable application code. The specification's completeness, title, example, identifier, privacy, and transaction rules will be expressed as numbered workflow steps, decision tables/lists, and exact output contracts so identical inputs yield identical decisions.

**Alternatives considered**: A new runtime or parser was rejected because the feature is a skill authoring change and the repository declares no runtime dependency for skills.

## Decision: Treat request creation as a validate-before-write transaction

**Rationale**: The request record and catalog are two coordinated user-owned artifacts. The skill will build both in memory, validate identifier/status/completeness/privacy constraints, and write neither artifact when validation or allocation fails. Catalog allocation and update remain one exclusive operation with retry on detected catalog change.

**Alternatives considered**: Writing the request first and repairing the catalog afterward was rejected because it permits duplicate identifiers and partial request creation.

## Decision: Bootstrap the catalog from a fixed initial state

**Rationale**: A missing `requests/requests.md` has no allocation state. Creating it with `Version: 1.0.0` and `Next ID: REQ000001` before allocation makes the first request deterministic without scanning filenames or directories.

**Alternatives considered**: Inferring the first identifier from existing files was rejected by the catalog-authority requirement.

## Decision: Keep Version 1 relationship-free

**Rationale**: The request artifact stores business evidence and completeness only. Profile, Objectives, Controls, and NFRs provide contextual example sources, but no Request-to-Artifact relationships are inferred or persisted. This preserves ownership boundaries and leaves discovery to a future skill.

**Alternatives considered**: Adding related-objective/control/NFR fields now was rejected because relationship discovery is not defined by this feature.

## Decision: Use the repository's existing validation and generation toolchain

**Rationale**: Validation uses `.highway/tools/validate-skill.sh`; catalog generation uses `.highway/tools/generate-catalog.sh`; adapters use `.highway/tools/generate-agent-adapters.sh`; the full regression suite is `.highway/tools/tests/run-all.sh`. The implementation adds no package, interpreter, or service dependency.

**Alternatives considered**: A separate test framework or metadata registry was rejected because it would duplicate existing repository mechanisms.

## Resolved Technical Context

- Shell/tooling: Bash 3.2-compatible repository scripts and Markdown skill instructions.
- Persistence: Plain Markdown files under `requests/` owned by the request workflow, plus generated catalog and adapter files.
- Interfaces: Agent-facing skill invocation and Markdown request/catalog artifacts; no network API.
- Platform: macOS and Linux-compatible repository tooling.
- Scale: Sequential request intake with a repository catalog; no independent service-scale target is required for Version 1.
