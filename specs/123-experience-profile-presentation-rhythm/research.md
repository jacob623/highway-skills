# Research: Experience Profile Presentation Rhythm

## Decision: Amend the existing Experience Standard in place

- Add X2.36 immediately after X2.35 and increment the standard from 7.1.0 to 7.2.0 as a MINOR amendment.
- Preserve X2.3, X2.5, X2.6, X2.8, X2.33, X2.34, and X2.35 byte-for-byte.
- Put the generic no-workflow-narration obligation in the standard; Profile cites and applies it without duplicating a second global rule.

**Rationale:** The standard owns user-visible interaction across all skills. Profile owns only its domain-specific acquisition, grounding, validation, acceptance, readiness, and persistence behavior.

**Alternatives considered:** A Profile-only rule would leave other Interactive Workflows inconsistent and would duplicate global experience policy. A new standard section without a rule ID would be difficult to review and would violate the existing rule inventory convention.

## Decision: Extend the existing Profile enrichment contract

- Replace the generic recommendation-flow guidance with the subject rhythm `Introduce -> Suggest -> Validate`.
- Use the prescribed headings for Vision, Competitive Path, and Guiding Principles.
- Apply X2.8 after accepted subject information, then introduce the next subject only when one remains.

**Rationale:** The current Profile already owns accepted-evidence grounding and validation. The feature changes presentation framing while retaining the existing acceptance and fallback boundaries.

**Alternatives considered:** Adding retained fields or a new readiness state would change Profile semantics without supporting the requested presentation behavior. A fixed prose template would conflict with the existing natural conversational guidance.

## Decision: Keep retained storage unchanged

- Do not modify `profile-record.md`, schema version 3.0.0, readiness values, domain count, persistence ordering, or completion synthesis.
- Keep headings, introductions, acknowledgments, and unadopted commentary transient.

**Rationale:** The specification explicitly protects the data model and distinguishes user-facing presentation from accepted organizational evidence.

**Alternatives considered:** Persisting presentation text would pollute retained organizational evidence and create a migration requirement with no user benefit.

## Decision: Verify through existing contracts and regeneration

- Add or amend focused Experience Standard and Profile contract assertions, observe them fail before implementation, and run the full suite afterward.
- Regenerate catalogs and Profile adapters from the canonical `.highway/skills/highway-profile/SKILL.md` source.

**Rationale:** The repository's existing tests cover shipped documents, Profile lifecycle boundaries, and generated correspondence. No new runtime dependency or test framework is needed.

**Alternatives considered:** A new test harness would duplicate established repository checks and increase maintenance surface.
