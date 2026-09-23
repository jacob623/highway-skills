# Research: Clarification Record Integrity

## Decision 1: Keep retained data and contract prose in separate sections

**Decision**: Treat the shared clarification-record template as a representative retained record first, and place workflow, ownership, and lifecycle explanations only in a separate explanatory contract section.

**Rationale**: Consumers must be able to parse Findings, Resolution History, Source, and Status without mistaking instructions for persisted fields. This directly addresses malformed frontmatter and embedded prose while preserving the existing template as the canonical contract.

**Alternatives considered**: Keeping explanatory rules inside finding examples was rejected because it blurs record data and documentation. Moving all examples to a separate document was rejected because the shared template must remain directly usable as a record example.

## Decision 2: Use list-item structures for history and evidence

**Decision**: Represent each Resolution History entry and each Evidence Source as a distinct list item with explicit fields. History contains Finding, Response, Revision, and Actor; evidence contains Source Type, Source Identifier, and Reason Used.

**Rationale**: Explicit list-item boundaries make one-to-one mapping and multi-source traceability deterministic and mechanically testable. They also prevent consumers from relying on ordering or free-form prose.

**Alternatives considered**: A paragraph-based format was rejected because entries cannot be reliably separated. A single flattened evidence string was rejected because it loses source boundaries and field-level validation.

## Decision 3: Make recommendation basis and state an explicit pair

**Decision**: Store recommendation state in Recommended Option and pair it with exactly one Recommendation Basis: `authoritative`, `evidence-gap`, or `conflict`. Map those values respectively to an evidence-backed recommendation, `Unknown`, or `Escalate for Decision`.

**Rationale**: Separating absence from conflict preserves deterministic behavior and makes the reason for guidance auditable without granting Clarification decision authority.

**Alternatives considered**: Combining both outcomes as `Unknown / Escalate for Decision` was rejected because evidence absence and conflicting evidence require different follow-up actions. Adding a new state outside the existing vocabulary was rejected because it would expand the contract unnecessarily.

## Decision 4: Preserve existing identity, lifecycle, and ownership contracts

**Decision**: Normalize fingerprint formatting and history identifiers without changing the existing version 2.0.0 finding identity, privacy filtering, source immutability, response acceptance, or escalation ownership rules.

**Rationale**: Feature 073 repairs record representation and traceability; Feature 072 remains authoritative for broader guided-resolution behavior. Limiting changes reduces regression risk and keeps generated consumers compatible.

**Alternatives considered**: Redesigning the finding identity or lifecycle was rejected because the requested feature explicitly refines representation rather than replacing the established contract.

## Decision 5: Extend existing Bash contract coverage and generation workflow

**Decision**: Add focused probes to the existing Clarification and output-template tests, then regenerate catalogs and adapters with the current repository scripts.

**Rationale**: The current harness already validates Markdown contracts in disposable fixtures and preserves Bash 3.2.57 compatibility. Existing generators enforce derived-artifact correspondence without introducing dependencies.

**Alternatives considered**: Introducing a parser framework or new test runner was rejected because it adds dependencies without improving the repository's established contract validation model. Hand-editing generated outputs was rejected because they are derived artifacts.
