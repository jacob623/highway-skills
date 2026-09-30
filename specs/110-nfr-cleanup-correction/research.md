# Research: Final NFR Contract Cleanup

## Decision: Treat the current 11.0.0 skill and 2.0.0 record template as the baseline

**Rationale**: The requested work is a contract correction and wording cleanup, not a new
versioned behavior. Existing NFR readiness, collection, relationship, persistence, and ownership
contracts already define the required behavior.

**Alternatives considered**:
- Incrementing either version: rejected because the request explicitly preserves both versions.
- Rewriting candidate lifecycle behavior: rejected because the request preserves the short workflow
  and current NFR ownership boundary.

## Decision: Keep candidate-state detail in `.highway/catalog/nfr-candidate-state.md`

**Rationale**: This is the existing persisted recovery artifact. The runtime skill should reference
its purpose and limits without introducing a second schema authority or repeating its full record
shape.

**Alternatives considered**:
- Add a second candidate-state schema/template: rejected because it would create competing
  authorities.
- Remove persisted candidate state: rejected because ordered review and resume depend on it.

## Decision: Use the Highway Experience Standard as the interaction authority

**Rationale**: Direct capture, recommendation selection, materially interpreted review, and
acceptance placement are already governed by X2.18, X2.21, and X2.22. The NFR skill should state
only the NFR-specific boundary and exact captured-NFR shape required by the feature.

**Alternatives considered**:
- Restore local interaction rules: rejected because they duplicate shared governance.

## Decision: Validate through focused static contract checks plus the full suite

**Rationale**: The changes are primarily Markdown contracts and generated outputs. Focused checks can
assert exact wording, forbidden legacy material, versions, and unchanged record structure; the full
suite verifies generated artifact currency and cross-skill compatibility.

**Alternatives considered**:
- Add runtime application code: rejected because this repository's relevant behavior is expressed
  through skills, templates, fixtures, and shell contract tests.

## Constraints resolved

- No unresolved technology, integration, security, or scale decisions remain.
- Bash 3.2 compatibility and existing generator workflows remain unchanged.
- `nfr-record.md` receives no structural change beyond confirming its current contract.
