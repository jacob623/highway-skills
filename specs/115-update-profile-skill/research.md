# Feature 115 Research

## Decision: Treat the source Profile skill as authoritative

- **Decision**: Update `.highway/skills/highway-profile/SKILL.md`, then synchronize the `.github`, `.claude`, `.cursor`, and `.agents` copies.
- **Rationale**: The repository's distribution model keeps these five skill documents byte-identical; the source copy is the maintained artifact.
- **Alternatives considered**: Updating one adapter only was rejected because it would violate generated/distributed correspondence.

## Decision: Keep the retained record and template unchanged

- **Decision**: Preserve `.highway/library/templates/output/profile-record.md` schema 3.0.0, the four readiness keys, and the existing retained path.
- **Rationale**: Feature 115 changes acquisition, recommendation, persistence timing, and completion presentation, not retained data shape.
- **Alternatives considered**: Adding grounding categories or a new readiness domain was rejected because those are internal recommendation inputs and would break the bounded Profile contract.

## Decision: Encode behavior in the Profile skill and focused Bash verification

- **Decision**: Amend the Profile skill text and the owning Profile behavior tests; retain structural and template validators for schema invariants.
- **Rationale**: This repository distributes declarative Markdown skills and validates them with Bash 3.2-compatible contract checks. The feature has no application runtime or external API.
- **Alternatives considered**: Introducing a new interpreter or package was rejected under the repository dependency constraint and would not improve validation of the shipped Markdown contract.

## Decision: Use Experience Standard references for generic interaction rules

- **Decision**: Profile cites Experience Standard 5.0.0 and keeps only Profile-specific grounding, canonical questions, ownership, persistence, and synthesis requirements.
- **Rationale**: Generic recommendation presentation, question ordering, acceptance, why-it-matters, and owner-result behavior are shared contracts and must not be duplicated.
- **Alternatives considered**: Copying the generic rules into Profile was rejected because it creates competing contracts and violates the feature specification.

## Decision: Validate before and after distribution synchronization

- **Decision**: Run focused Profile tests first, then the full `.highway/tools/tests/run-all.sh` suite, plus byte-identity and diff checks for all skill copies.
- **Rationale**: Feature 115 changes a distributed skill and its verification; both local behavior and repository-wide correspondence are required evidence.
- **Alternatives considered**: Relying only on Markdown inspection was rejected because the constitution requires executable verification for behavioral changes.
