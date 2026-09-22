# Research: Discovery Clarification Status Rules

## Decision 1: Keep Clarification status advisory-only

**Decision**: Status may control which evidence is projected into Discovery advisory sections, but never candidate generation, filtering, scoring, ordering, recommendation selection, or ADR ownership.

**Rationale**: Feature 069 established Clarification as optional evidence and Discovery as the owner of architectural evaluation. Status-specific projection clarifies that boundary without changing behavior.

**Alternatives considered**: Treating `blocked` or open findings as a hard gate was rejected because it would make optional Clarification a Discovery prerequisite and violate the existing ownership boundary.

## Decision 2: Preserve Request-over-response precedence

**Decision**: Request evidence remains authoritative. Clarification responses supplement, explain, or clarify it; disagreement is advisory risk evidence and never mutates the Request.

**Rationale**: The Request is the user-owned source of intent. Clarification is a downstream interpretation and cannot silently replace the source artifact.

**Alternatives considered**: Merging conflicting text into a new authoritative value was rejected because it would create an undocumented third authority and broaden Discovery ownership.

## Decision 3: Validate the complete Clarification record before consumption

**Decision**: Unreadable, malformed, path-mismatched, state-invalid, and count-invalid artifacts are unavailable as a whole. Discovery preserves bytes, continues, and may record advisory risk evidence.

**Rationale**: Partial consumption of an internally inconsistent record could produce misleading evidence and would diverge from Clarification's blocked and malformed-record rules.

**Alternatives considered**: Best-effort field-level consumption was rejected because it weakens deterministic validation and can mix valid and invalid lifecycle state.

## Decision 4: Use existing Discovery evidence sections

**Decision**: Project accepted responses into Research Findings; project open-finding uncertainty into Assumptions, Unknowns, Risks, and confidence rationale; use no new Discovery schema section.

**Rationale**: Existing output sections already express the required advisory meanings and preserve downstream compatibility.

**Alternatives considered**: Adding a dedicated Clarification section was rejected because it would change the Discovery schema without adding user value.

## Decision 5: Test the contract with disposable fixtures and generated-artifact checks

**Decision**: Extend `highway-discovery.test.sh` with status, precedence, finding-state, invalidity, immutability, and repeated-run probes, then regenerate adapters and catalogs and run the full suite.

**Rationale**: The repository's implementation surface is primarily contract text and Bash assertions. Focused fixtures provide executable evidence without introducing runtime dependencies.

**Alternatives considered**: Adding a new test framework was rejected because the existing shell contract harness already covers the owning abstraction.
