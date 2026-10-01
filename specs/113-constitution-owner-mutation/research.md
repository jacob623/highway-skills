# Research: Constitution Owner Mutation Boundary

## Decision 1: Make the amendment in the existing runtime Constitution

- **Decision**: Edit only `.highway/governance/constitution.md`.
- **Rationale**: The feature explicitly scopes the change to the runtime Highway Skills
  Constitution and requires all other skills, templates, and experience guidance to remain
  unchanged.
- **Alternatives considered**: Updating `.specify/memory/constitution.md` was rejected because it
  governs development process rather than shipped skill behavior. Updating individual skills was
  rejected because the requested amendment must be completed before downstream skill reviews.

## Decision 2: Extend Principle XII without redesigning existing owner rules

- **Decision**: Preserve P12.5–P12.12 byte-for-byte and append P12.13–P12.15, then update only
  Principle XII's rationale and precedence reason.
- **Rationale**: The specification adds three narrowly observable obligations while explicitly
  preserving existing readiness, domain-state, action, delegation, and owner-boundary rules.
- **Alternatives considered**: Rewriting the entire Principle XII section was rejected because it
  increases the risk of accidental changes to retained rules.

## Decision 3: Validate the amendment as a document contract

- **Decision**: Use the existing full test suite plus focused checks for rule IDs, exact rule
  text, version metadata, counts, precedence, self-application scope, and changed-path scope.
- **Rationale**: The feature changes governance text and metadata, not executable application code.
  The focused checks make the new observables and exclusions directly auditable.
- **Alternatives considered**: Adding a new validation test was rejected because the scope permits
  only `constitution.md`; existing governance inventory and suite checks remain the validation
  mechanism.

## Decision 4: No post-write persistence verification

- **Decision**: Record the lifecycle as acceptance → owner mutation → owner result →
  orchestration, with no post-write verification stage.
- **Rationale**: This is an explicit feature requirement and preserves the Constitution's
  distinction between mutation ownership and persistence verification.
- **Alternatives considered**: Read-after-write or byte-comparison verification was rejected
  because it would reintroduce the explicitly removed persistence model.
