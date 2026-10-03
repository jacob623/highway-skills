# Research: Substantive Contribution Re-evaluation and Conversational Clarification

## Decision 1: Add X2.38, X2.39, and X2.40 without renumbering

**Decision**: Use the next three stable X2 identifiers after X2.37 for substantive-contribution re-evaluation, consequential-uncertainty handling, and anti-ceremony clarification.

**Rationale**: Existing rule IDs are stable references used by contracts and downstream skills. Appending rules preserves every existing identifier while making each new obligation independently checkable.

**Alternatives considered**: Renumbering the interaction table was rejected because it would invalidate existing references and create unrelated migration work.

## Decision 2: Keep the concepts transient and distinct from clarification records

**Decision**: Define Substantive Contribution and Conversational Clarification as transient conversational concepts. Do not add fields, records, identifiers, finding states, catalogs, or persisted history.

**Rationale**: The Experience Standard owns shared user-visible behavior, while `highway-clarify` owns deterministic clarification records for supported source artifacts. The amendment generalizes reasoning without moving that ownership boundary.

**Alternatives considered**: Reusing `highway-clarify` records was rejected because it would couple every Interactive Workflow to artifact-specific persistence and violate source-artifact ownership.

## Decision 3: Make re-evaluation universal and clarification conditional

**Decision**: Every Substantive Contribution triggers contextual re-evaluation before the next behavior; a visible clarification occurs only when consequential uncertainty remains and the person's information is required.

**Rationale**: This preserves contribution-first behavior and X2.4's anti-ceremony discipline while preventing workflows from treating meaningful responses as mere completion of the prior question.

**Alternatives considered**: Asking for clarification after every new contribution was rejected because it would create interrogation, verbosity, and unnecessary user burden.

## Decision 4: Preserve existing acceptance and Contribution Opportunity boundaries

**Decision**: Clarification may happen during Working Idea development, but it does not accept a Working Idea or Converged Proposal and does not automatically satisfy X2.37. Contribution Opportunity remains the distinct pre-convergence substantive-completeness boundary.

**Rationale**: X2.18, X2.19, X2.21, X2.22, and X2.37 already define acceptance and substantive contribution boundaries. The new guidance must compose with them rather than replace them.

**Alternatives considered**: Treating any clarification question as the Contribution Opportunity was rejected because resolving meaning and inviting completion of developed substance are different user decisions.

## Decision 5: Classify the change as a MINOR Experience Standard version increment

**Decision**: Advance the standard from 8.1.0 to 8.2.0.

**Rationale**: The amendment adds shared interaction obligations and guidance without removing or redefining existing X rules. This matches the existing Experience Standard Versioning Policy.

**Alternatives considered**: MAJOR was rejected because existing acceptance, persistence, one-question, contribution-first, and Contribution Opportunity semantics remain preserved; PATCH was rejected because new normative obligations are added.

## Decision 6: Validate with existing static contracts and the full suite

**Decision**: Extend the existing Experience Standard amendment contract only for changed anchors and rule count, then run UX alignment, rule checks, and the complete repository suite.

**Rationale**: The repository is a Markdown/Bash governance system. Static contract tests can verify rule IDs, required guidance, protected boundaries, and absence of forbidden artifact mechanics without introducing a runtime test harness.

**Alternatives considered**: A new runtime or API test layer was rejected because the feature changes no executable runtime or external interface.
