# Research: Highway Organizational Profile

## Decision: Model the profile as a distributed structural artifact with user-owned values

**Decision**: Ship `.highway/profile.yaml` with Highway, validate its required structure and placement, and leave the semantic meaning of its values to the repository owner. Use `.highway/library/templates/requirements-inquiry.md` as the ownership and governance precedent.

**Rationale**: The questionnaire template is distributed under `.highway/`, governed for shape by the Highway framework, editable by users, and maintained by a skill without judging the user's content. The profile needs the same boundary while adding deterministic YAML and confirmation-gated mutation behavior.

**Alternatives considered**:
- Treat the profile as a governance baseline: rejected because profile context influences recommendations but does not impose obligations.
- Treat the profile as an unvalidated repository file: rejected because its distributed location, metadata, ordering, and safe mutation behavior need structural checks.
- Put the profile under a user-owned root-level directory: rejected because the requested artifact and precedent both place the file under `.highway/` in the distributed framework.

## Decision: Use a dedicated profile structure validator

**Decision**: Add validation for `.highway/profile.yaml` that checks YAML shape, required metadata, top-level ordering, omission of empty sections, and absence of generated values, while declining semantic validation of user values.

**Rationale**: `validate-library.sh` currently validates Markdown files under `library/templates/`, `library/knowledge/`, and `library/governance/`. The profile is YAML and must be validated without forcing it into a Markdown-only library schema or applying NFR/Control content rules.

**Alternatives considered**:
- Reuse `validate-library.sh` unchanged: rejected because it requires Markdown frontmatter and library-type path classification.
- Validate only through the skill's prose: rejected because distribution and generated-artifact checks need an executable structural gate.
- Judge values against organizational best practices: rejected because values are user-owned contextual guidance.

## Decision: Keep mutation previews transactional and deterministic

**Decision**: Parse and preserve the existing profile, construct a proposed state in memory, display the required preview, and write only after explicit confirmation. Declined or invalid operations perform no write.

**Rationale**: The profile is user-owned and destructive operations must be reviewable. A proposal-first flow also supports byte-identical no-op rewrites and prevents timestamps, random IDs, or environment-derived values from entering the artifact.

**Alternatives considered**:
- Write incrementally during questionnaire or mutation steps: rejected because a later decline or error could leave partial user changes.
- Normalize all values and ordering: rejected because the requirement preserves user wording, capitalization, grouping, and order unless requested.
- Add operation timestamps or change IDs: rejected because deterministic output is an explicit contract.

## Decision: Extend existing generated correspondence mechanisms

**Decision**: Add `highway-profile` to the source skill set, distribute `.highway/profile.yaml`, regenerate the skill catalog/adapters/distribution manifests, and add focused tests for source validation, profile structure, confirmation safety, and correspondence.

**Rationale**: The repository treats `.highway/skills/` as the source of distributed skills and requires generated outputs to match source inputs. The new profile artifact must be included in the same declared distribution path and validated independently.

**Alternatives considered**:
- Hand-edit adapters or manifests: rejected by D4.1 and D4.7.
- Ship only the skill and create the profile on first use: rejected because the requested model ships a default artifact with metadata.
- Add an external runtime dependency for YAML handling: rejected by the declared toolchain and distribution constraints; use the repository's existing shell/tooling approach or a checked-in structural validator compatible with the target environment.
