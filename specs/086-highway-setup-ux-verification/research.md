# Feature 086 Research

## Decision: Extend the existing highway-setup verification surfaces

- **Decision**: Amend `.highway/tools/tests/highway-setup.test.sh` for static document-contract assertions and `.highway/tools/tests/highway-setup-executable.test.sh` for deterministic output and outcome fixtures.
- **Rationale**: Feature 085 established these as the focused validation surfaces for the shipped `highway-setup` skill. Feature 086 adds verification obligations to the same output contract rather than introducing a new test harness.
- **Alternatives considered**: Add a separate verification framework; rejected because it would duplicate the existing focused tests and add no evidence that the current skill tree can be validated.

## Decision: Keep static contract evidence separate from executable behavior evidence

- **Decision**: Use static assertions for Purpose, output-mode wording, prohibited vocabulary, and contract distinctions; use executable fixtures for input-required opening order, routine collection suppression, explicit status, terminal outcomes, and completion output.
- **Rationale**: The constitution distinguishes document-contract evidence from executed-behavior evidence. Static checks can prove required language exists, while fixtures can prove output selection and absence of collection questions in completion cases.
- **Alternatives considered**: Treat the static skill-file test as proof of all success criteria; rejected because it would conflate documentation presence with runtime behavior.

## Decision: Preserve the existing conversational output contract

- **Decision**: Represent collection, status, and completion as ordered conversational modes over existing owner outcomes. Do not introduce structured response fields, a new orchestration authority, or a new persistence mechanism.
- **Rationale**: `highway-setup` already routes to authoritative owner workflows and emits their content. Feature 086 clarifies which existing content applies to each interaction mode and verifies the boundaries.
- **Alternatives considered**: Add a formal response schema or checkpoint store; rejected because both would change ownership and persistence boundaries that Feature 086 explicitly preserves.

## Decision: Use the closed prohibited vocabulary as the verification source of truth

- **Decision**: Store the five exact legacy phrases once in the feature contract and have both static requirements and executable assertions reference that closed list.
- **Rationale**: A closed list makes regression checks deterministic and prevents conceptual categories from drifting into inconsistent phrase matching. Explanation-category suppression remains a separate semantic assertion.
- **Alternatives considered**: Keep repeating the phrases in each requirement and test; rejected because duplication can drift and obscures the maintained vocabulary.

## Decision: Preserve generated-artifact synchronization when the shipped skill changes

- **Decision**: If implementation updates `.highway/skills/highway-setup/SKILL.md`, regenerate the declared GitHub Copilot, Claude, Cursor, catalog, and manifest outputs using the existing generator workflow and validate correspondence.
- **Rationale**: The source skill is a generator input and the generated adapters are shipped product surfaces. Feature 086 must not leave a clarified output contract available only in the development source.
- **Alternatives considered**: Edit generated adapters directly; rejected by the repository's generated-artifact integrity rules.

## Baseline and constraints

- Feature 085 is the behavioral baseline and remains authoritative for readiness order, owner authority, terminality, safe-stop behavior, and the Completion Dashboard.
- No new runtime dependency, interpreter, package, persistence store, or checkpoint mechanism is needed.
- Bash validation must remain compatible with macOS Bash 3.2.57 and the declared repository toolchain.
- The direct executable bit may be absent on the executable fixture in this checkout; invoke it through `bash` when required.
