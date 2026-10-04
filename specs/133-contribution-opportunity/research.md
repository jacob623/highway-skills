# Research: Contribution Opportunity Before Convergence

## Decision 1: Add one shared X2 obligation

- **Decision**: Add X2.37 as an agent-checkable rule after X2.20, requiring a Contribution Opportunity when Highway materially shaped a Working Idea and no prior opportunity occurred.
- **Rationale**: The missing behavior is a shared interaction boundary, not an owner-specific workflow rule. Keeping it in X2 preserves common semantics for all Interactive Workflows.
- **Alternatives considered**: Adding separate Profile, Objectives, Controls, or NFR rules was rejected because it would duplicate shared interaction authority. Adding a new persisted state was rejected because the boundary exists inside transient Working Idea development.

## Decision 2: Keep the Contribution Opportunity before X2.21

- **Decision**: Place the opportunity after substantive Working-Idea development and before the existing materially interpreted Converged Proposal review and acceptance request.
- **Rationale**: The person contributes to substantive completeness, while X2.21 asks whether the final representation accurately captures the accepted understanding. Separating these boundaries prevents duplicate final-form prose and avoids treating "No, that's everything" as acceptance.
- **Alternatives considered**: Reusing X2.21 for both purposes was rejected because it collapses substance and representation. Adding a second acceptance question was rejected because the opportunity is not approval.

## Decision 3: Preserve adaptive depth through explicit skip conditions

- **Decision**: Skip a distinct opportunity for domain-complete user contributions, prior equivalent opportunities, explicit completion of contribution, selected Converged Proposals, or ceremonial cases.
- **Rationale**: The standard already requires mature contributions to converge without unnecessary exploratory turns. Contribution Opportunity prevents premature Highway-owned closure without making "anything else?" mandatory.
- **Alternatives considered**: Requiring the opportunity for every Working Idea was rejected because it would create conversational ceremony and conflict with adaptive depth.

## Decision 4: Present provisional substance, not a duplicate artifact

- **Decision**: Recommend themes, bullets, distinctions, alternatives, implications, or other decomposed Working-Idea material before convergence when that avoids repeating final-form prose.
- **Rationale**: The person needs to reason about what belongs in the answer before Highway synthesizes the final artifact representation once.
- **Alternatives considered**: Presenting a polished artifact and then asking what is missing was rejected because it forces substantially identical review twice.

## Decision 5: Preserve existing authority and contribution precedence

- **Decision**: Keep Working Ideas transient, preserve X2.2 and X2.13 contribution-first behavior, retain X2.18/X2.21/X2.22/X2.25 semantics, and leave owner mutation and persistence unchanged.
- **Rationale**: Contribution Opportunity is a refinement of collaborative development, not a new acceptance boundary or artifact lifecycle state.
- **Alternatives considered**: Making a Contribution Opportunity response authoritative or persistence-eligible was rejected because only the existing Converged Proposal acceptance boundary grants that authority.

## Decision 6: Use development versioning without renumbering rules

- **Decision**: Apply the current Experience Standard Versioning Policy and document the amendment rationale while leaving existing X identifiers unchanged.
- **Rationale**: The current document is version `8.0.0` and the repository is using development-versioning guidance; the new behavior adds one shared obligation.
- **Alternatives considered**: Renumbering existing X2 rules was rejected because the request explicitly requires stable identifiers.
