# Research: Profile Runtime Architecture Alignment

## Decision: Keep Profile as the domain owner and delegate generic collaboration

**Rationale**: The Highway Experience Standard explicitly owns generic user-visible interaction,
Working Ideas, advisory reasoning, clarification, Contribution Opportunities, re-evaluation,
direct-contribution short paths, and conversational convergence. Profile must therefore retain only
Profile-specific domain completeness, acceptance, readiness, persistence, acquisition, and
cross-domain reasoning.

**Alternatives considered**:
- Retain the existing Profile convergence procedure: rejected because it duplicates the revised
  Experience Standard and creates competing convergence authority.
- Move domain completeness and acceptance into the Experience Standard: rejected because the
  Experience Standard explicitly does not own domain semantics, completeness, acceptance, or
  persistence.

## Decision: Use Highway Identity only as shared, non-normative context

**Rationale**: The current Highway Identity document defines itself as shared context about what
Highway is, why it exists, and what it is trying to achieve. It explicitly excludes runtime
governance and organizational facts. Profile can use that context to understand its role but must
not persist it as organizational evidence.

**Alternatives considered**:
- Continue using Highway Vision and Highway Platform Objectives: rejected because the feature
  explicitly retires those runtime dependencies.
- Treat Highway Identity as behavioral guidance or organizational evidence: rejected by the
  document's authority boundary and the feature requirements.

## Decision: Preserve the existing Markdown Profile record and readiness dimensions

**Rationale**: `profile-record.md` remains the authoritative retained structure with four domain
keys and optional Context. The feature changes runtime ownership and failure behavior, not the
retained schema. Readiness remains based only on Identity, Vision, Competitive Path, and Guiding
Principles states.

**Alternatives considered**:
- Add fields for Working Ideas, convergence, advisory reasoning, or collaboration: rejected because
  those are transient Experience concerns and are explicitly excluded from the retained contract.
- Make optional Context or enrichment a readiness dimension: rejected because existing Profile
  behavior treats them as optional and non-blocking.

## Decision: Classify the Profile skill version change as MAJOR

**Rationale**: The Skill Versioning Policy classifies removal or redefinition of a skill contract as
MAJOR. This feature removes runtime dependencies, removes a Profile-owned convergence procedure,
and replaces the Constitution common-failure dependency with local Profile failure behavior. The
source skill version therefore advances from `8.1.0` to `9.0.0`.

**Alternatives considered**:
- MINOR: rejected because the change removes and redefines existing contract obligations rather
  than adding a compatible capability.
- PATCH: rejected because the change affects Inputs, runtime ownership, Error Handling, and
  Verification rather than wording only.

## Decision: Treat generated adapters and catalog entries as derived outputs

**Rationale**: The development constitution requires declared generated artifacts to be regenerated
when their skill input changes. The implementation will update the source Profile skill and focused
validation tests, regenerate the four agent adapters and catalog, and run correspondence checks.

**Alternatives considered**:
- Hand-edit generated adapters: rejected by the generated-artifact integrity rules.
- Add an external contract: rejected because this repository exposes an internal Markdown skill
  contract rather than a public API or service interface.
