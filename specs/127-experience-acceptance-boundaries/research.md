# Feature 127 Research: Experience Acceptance Boundaries

## Decision 1: Treat acceptance as a Converged Proposal boundary

**Decision**: Replace immediate recommendation acceptance with acceptance of a displayed Converged Proposal in X2.18, X2.21, X2.22, and X2.25.

**Rationale**: The current Experience Standard already defines Working Ideas, Converged Proposals, artifact acceptance boundaries, and owner-controlled completeness. The requested cleanup must make the rule rows use that lifecycle consistently: a recommendation can remain a grounded starting point, while only a complete candidate presented for acceptance becomes authoritative when selected.

**Alternatives considered**:

- Keep recommendation selection as universal acceptance: rejected because it silently persists incomplete Working Ideas.
- Add a new rule namespace or new provisional-acceptance state: rejected because the request explicitly preserves rule IDs and avoids broader rationalization.

## Decision 2: Keep X2.8 and X2.36 unchanged

**Decision**: Do not alter X2.8 or X2.36, their Observables, or their `[agent-checkable]` tiers.

**Rationale**: X2.8 already requires newly accepted information to be used with relevant accumulated context and rejects mere repetition and workflow narration. X2.36 already prevents visible persistence, state-transition, and processing narration. The cleanup should remove stale dependent sequencing rather than redefine either rule.

**Alternatives considered**:

- Rewrite X2.8 to mention the full lifecycle: rejected because it would expand a requested supporting cleanup into another normative rule redefinition.
- Remove X2.36 as redundant: rejected because it remains the explicit shared boundary against workflow narration.

## Decision 3: Replace acknowledgment sequencing with contextual re-evaluation

**Decision**: Remove the stale acknowledgment-specific paragraphs from Contextual Re-evaluation and use the requested sequence from new or accepted information through contextual re-evaluation, useful interpretation or sharpening, grounded contribution, continued development or Converged Proposal, a needed question, or natural conclusion.

**Rationale**: The current standard's surrounding guidance already distinguishes Conversational Presence and Constructive Advisory. Repeating those concepts as a required acknowledgment sequence conflicts with the updated X2.8 and makes paraphrase appear mandatory.

**Alternatives considered**:

- Retain the old sequence and add an exception for collaborative turns: rejected because two competing continuity models would remain.
- Remove all continuity guidance: rejected because the standard still needs an explanatory, non-normative interaction pattern.

## Decision 4: Update only the requested dependent guidance and examples

**Decision**: Modify X2.18, X2.19 Observable, X2.21, X2.22, X2.25, Contextual Guidance, the stale Contextual Re-evaluation material, Constructive Advisory's conversational pattern, specified compliant examples, Interaction Examples, and Recommendation sets.

**Rationale**: This is the smallest surface that removes the identified conflicts while preserving the current interaction model, Collaborative Development guidance, first two Contextual Re-evaluation paragraphs, readability guidance, evolution-aware guidance, stable X namespace, and Contextual Acknowledgment definition.

**Alternatives considered**:

- Rationalize the entire Experience Standard: rejected explicitly by the request and unnecessary for this conflict cleanup.
- Synchronize individual skills in the same change: rejected because the requested implementation boundary is the shared standard only; `highway-profile` is the later implementation step.

## Decision 5: Preserve owner-controlled completeness and user alternatives

**Decision**: State that the owning skill determines domain completeness, permit direct domain-complete input and selected complete candidates to bypass redundant interpretation review, and preserve the user-authored alternative.

**Rationale**: The Constitution and Highway Identity protect user ownership and owner responsibility. The Experience Standard should govern presentation and acceptance behavior without deciding the completeness of Profile, Objectives, Controls, or NFR artifacts.

**Alternatives considered**:

- Let the Experience Standard decide when a candidate is complete: rejected because it would move domain authority out of the owning skill.
- Remove the multi-candidate recommendation choice behavior: rejected because the request preserves the existing ability to choose one, several, all, or provide an alternative.

## Decision 6: Retain the current development version and stable namespace

**Decision**: Keep version `8.0.0` and do not renumber X rules.

**Rationale**: The request explicitly directs the active-development versioning approach for this targeted cleanup and says not to rationalize or renumber the X namespace. The existing document is already version 8.0.0 after the X2.8 redefinition.

**Alternatives considered**:

- Bump to a new major version: rejected for this active-development cleanup because the requested versioning approach retains 8.0.0.
- Renumber affected rules: rejected because rule IDs are stable references.

## Decision 7: Validate through existing focused contracts and full-suite reporting

**Decision**: Use the existing Experience Standard amendment and UX alignment contracts, plus the full repository suite, and distinguish requirement coverage from suite results.

**Rationale**: The repository already has focused checks for rule rows, examples, interaction-model structure, skill references, and stale behavior. The implementation changes their stale assertions where they encode superseded immediate-acceptance or acknowledgment behavior; no new validation framework is required.

**Alternatives considered**:

- Add a new feature-specific test harness: rejected because existing contracts cover the target and the feature adds no new runtime behavior.
- Treat static contract success as complete behavioral proof: rejected by D3.8 and the plan's separate requirement/suite reporting.
