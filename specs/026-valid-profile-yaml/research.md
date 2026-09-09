# Research: Valid Profile YAML

## Decision: Use spaces for YAML indentation

**Decision**: Replace tab indentation in the canonical profile with spaces while preserving every
key, value, section, and ordering decision from Feature 025.

**Rationale**: Standard YAML parsers reject tab characters used for indentation. The existing
profile is a constrained pure-YAML document, so a whitespace-only correction addresses the defect
without changing the profile contract.

**Alternatives considered**:

- Keep tabs and rely on the repository's structural validator: rejected because that validator is
  intentionally not a general-purpose YAML parser and standard parsers still fail.
- Rework the profile schema: rejected because Feature 025 already defines the required schema and
  this feature is limited to syntax validity.

## Decision: Add a parser-backed focused regression test

**Decision**: Add a focused test that invokes the development host's standard YAML parser against
the canonical profile, and include it in the existing profile validation workflow.

**Rationale**: A parser-backed check directly proves the behavior requested by FR-001 and catches
future indentation or syntax regressions that lexical checks could miss. The test is development
tooling and does not add a runtime dependency to the distributed profile.

**Alternatives considered**:

- Check only for tab characters: rejected because absence of tabs does not prove YAML validity.
- Extend the existing shell structural validator into a general YAML parser: rejected because the
  validator explicitly documents that it is not a general-purpose parser and such a parser would
  add complexity beyond this feature.

## Decision: Keep semantic validation separate

**Decision**: Continue using `validate-profile.sh` and `profile-structure.test.sh` for schema,
ordering, metadata, and fixture semantics; use the new focused test only for parser acceptance.

**Rationale**: Separation keeps each check's failure mode clear and preserves existing fixture
coverage without weakening or duplicating the structural validator.