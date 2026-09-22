# Research: Clarification Guided Resolution Workflow

## Decision 1: Keep the implementation in the existing contract layer

**Decision**: Implement the feature in the canonical `highway-clarify` Markdown contract, the shared clarification-record template, and the existing Bash contract test. Regenerate adapters and catalogs with the existing generators.

**Rationale**: The repository ships distributed skill contracts and validates them with shell probes. No runtime service or new dependency is required by the feature.

**Alternatives considered**: Adding an application service or parser was rejected because it would introduce an unsupported runtime layer and duplicate the existing contract ownership model.

## Decision 2: Store guidance with every finding and retain it after resolution

**Decision**: Add deterministic guidance fields to each finding: Question, Why It Matters, Recommended Option, Recommended Rationale, Alternatives B and C with rationales, Custom, Selected Option, and source traceability. Preserve these fields for resolved findings.

**Rationale**: The specification requires traceability across the open-to-resolved transition and prohibits replacing the finding with a separate workflow record.

**Alternatives considered**: Storing guidance in a separate transient artifact was rejected because it would weaken history retention and complicate identity-preserving regeneration.

## Decision 3: Resolve recommendation conflicts conservatively and deterministically

**Decision**: Apply global source precedence independently for each artifact-specific guidance set. If multiple values conflict at the highest available precedence, recommend `Unknown / Escalate for Decision`, record all conflicting evidence sources, expose the conflicting values as alternatives B and C, explain the conflict, and require explicit selection A, B, C, or D Custom.

**Rationale**: This preserves user decision authority and prevents an arbitrary tie-break from becoming an implicit recommendation.

**Alternatives considered**: Selecting the first source by file order was rejected because filesystem ordering is not authoritative. Aborting every conflict was rejected because the feature requires advisory guidance and a usable escalation path.

## Decision 4: Keep option selection separate from accepted response resolution

**Decision**: `selected_option` accepts only A, B, C, D, or None and remains informational. Only an explicitly accepted response may transition `open` to `resolved`; no selection or generated option performs that transition.

**Rationale**: This preserves the existing lifecycle and user ownership contracts while adding traceability.

**Alternatives considered**: Treating selection as acceptance was rejected because it would introduce automatic resolution and violate Clarification ownership boundaries.

## Decision 5: Extend executable verification without weakening existing checks

**Decision**: Amend `highway-clarify.test.sh` with disposable probes for guidance completeness, deterministic generation, source precedence, same-precedence conflict handling, option selection, accepted-response resolution, invalid selections, privacy filtering, and source-byte preservation. Run validators, generators, dependent-skill checks, and the full suite.

**Rationale**: The existing test is the owning contract harness and already declares source-document, generated-artifact, and disposable-fixture coverage.

**Alternatives considered**: A new test framework was rejected because it would add a dependency without improving coverage of the Markdown contract surface.
