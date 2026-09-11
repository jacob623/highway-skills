# Feature 036 Research

## Decision: Use isolated executable Profile fixtures

- **Decision**: Exercise Profile readiness through temporary fixture copies and explicit observed status, byte, and content assertions.
- **Rationale**: Static phrase checks prove only that a contract is written. Temporary copies permit declined and malformed paths to be tested without mutating the canonical Profile artifact.
- **Alternatives considered**: Testing only the distributed default was rejected because it does not cover absent, malformed, or declined states. Editing the canonical artifact during tests was rejected because negative tests must preserve repository bytes.

## Decision: Validate workflow variants through a parameterized parser

- **Decision**: Parse a supplied workflow file, not a hard-coded canonical path, and run canonical plus one-defect temporary variants for missing, duplicate, non-sequential, and dangling references.
- **Rationale**: A parameterized parser proves the validator detects defects instead of merely observing that the current file is valid.
- **Alternatives considered**: Text presence checks were rejected because they cannot fail on malformed variants. Mutating the source file in place was rejected because it risks test residue and violates artifact preservation.

## Decision: Drive NFR assertions from candidate-result data

- **Decision**: Represent generation success, candidate count, proposal state, accepted artifact state, and malformed/unavailable conditions as input data consumed by one decision function.
- **Rationale**: Expected statuses must be derived from candidate input, not assigned directly from labels that already encode the expected answer.
- **Alternatives considered**: The existing label-to-status fixture switch was rejected because it can pass while the real routing rule is wrong. Invoking an unavailable production generator was rejected because the current repository exposes the contract as Markdown; a deterministic owner-compatible decision function is the testable boundary.

## Decision: Document generator targets explicitly

- **Decision**: Every distribution-generation instruction includes a disposable target-directory argument and explains that a pre-created untracked non-empty target is rejected.
- **Rationale**: The generator contract requires one positional target and protects existing outputs from accidental overwrite.
- **Alternatives considered**: Omitting the argument was rejected because the documented command cannot execute. Using the checked-in distribution as a test target was rejected because it risks unrelated changes.
