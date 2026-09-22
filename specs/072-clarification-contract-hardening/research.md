# Research: Clarification Contract Hardening

## Decision 1: Treat version alignment as one retained-output contract

**Decision**: Set the clarification-record template metadata version to `2.0.0`, matching the canonical `highway-clarify` skill, and preserve the same version in generated adapters and catalogs.

**Rationale**: Feature 071 changed the retained output shape by adding Question, Why It Matters, options, selection, and guided resolution. A major version mismatch would let consumers interpret the same record under incompatible contracts.

**Alternatives considered**: Keeping the template at `1.2.0` was rejected because it understates the breaking retained-output change. Introducing a separate template version was rejected because it would create two authoritative versions for one record shape.

## Decision 2: Filter sources before applying precedence

**Decision**: Guidance generation first selects the artifact-specific source set, then evaluates the existing global precedence order only over members of that set.

**Rationale**: This preserves the existing precedence vocabulary while preventing irrelevant sources from influencing REQ, DISC, ADR, or RA guidance. It also makes source eligibility independently testable.

**Alternatives considered**: Applying global precedence before filtering was rejected because a source excluded for the artifact type could incorrectly win. Maintaining four unrelated precedence lists was rejected because it would duplicate policy and permit drift.

## Decision 3: Keep absent evidence and conflicting evidence as distinct states

**Decision**: Use `Unknown` when no authoritative evidence exists in the selected source set. Use `Unknown / Escalate for Decision` only when authoritative evidence exists at the highest applicable precedence but contains conflicting values.

**Rationale**: The two states require different user actions: evidence gathering for absence versus decision-owner escalation for conflict. Both states remain advisory and deterministic.

**Alternatives considered**: One generic Unknown state was rejected because it loses the distinction between an evidence gap and an authority conflict. Arbitrary tie-breaking was rejected because it would make a decision without user authority.

## Decision 4: Represent evidence as a stable traceability tuple

**Decision**: Every evidence-backed recommendation or alternative exposes Source Type, Source Identifier, and Reason Used.

**Rationale**: A fixed three-field structure makes recommendations auditable, supports deterministic comparisons, and gives consumers enough context without granting them decision authority.

**Alternatives considered**: Free-form rationale alone was rejected because it cannot be reliably validated or traced. Source identifiers without reasons were rejected because they would show provenance without explaining relevance.

## Decision 5: Keep selection, response, and escalation ownership separate

**Decision**: Selected Option remains informational; only an explicitly accepted Response may transition open to resolved. Escalation ownership is an advisory routing result mapped by artifact type and never mutates source artifacts.

**Rationale**: This preserves Feature 071 lifecycle and ownership boundaries while making downstream handoffs explicit before ADR implementation.

**Alternatives considered**: Treating a selected option as a response was rejected because it would enable automatic resolution. Letting Clarification decide conflicts was rejected because escalation identifies the responsible authority without transferring the decision.

## Decision 6: Extend the existing contract test and generation workflow

**Decision**: Add focused probes for version alignment, fingerprint consistency, source-set filtering, precedence, absent/conflicting evidence, traceability, escalation ownership, consumer restrictions, and option lifecycle to the existing Clarification test. Regenerate all derived artifacts using existing generators.

**Rationale**: The current test harness already owns Clarification behavior and disposable-fixture isolation. Extending it preserves the repository's Bash 3.2.57-compatible verification model and avoids runtime dependencies.

**Alternatives considered**: A new test framework was rejected because it would add a dependency without improving coverage of Markdown contracts. Hand-editing generated adapters was rejected because generated artifacts must remain derived.
