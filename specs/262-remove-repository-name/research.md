# Research: Remove Repository Name

## R1. First-question placement

- **Decision**: Replace the `name` step content with the organization-name question
  `**What is the organization's name?**`. Keep the heading `#### Let's get to know your organization`.
  Remove the repository-name question and its "often a good choice" hint. Remove the separate
  post-offer `### organization-name` step. Guided order: organization name → offer → Identity →
  Vision → Competitive Path → Guiding Principles → split → write.
- **Rationale**: Spec FR-001 and the clarify assumption move the existing question into the first
  slot. A second organization-name step would re-ask.
- **Alternatives**: Keep `name` as repository then ask organization name (rejected: feature removes
  Repository Name). Rename the step id only and keep both questions (rejected).

## R2. Decline and unknown on the first question

- **Decision**: On the first organization-name question, `decline` and `unknown` re-emit the same
  question and stay. Do not advance, invent a name, or return `Finished`. Any reply that supplies a
  name is stored as Organization Name and advances to `offer`.
- **Rationale**: Clarification A. Later skills have no Repository Name fallback.
- **Alternatives**: Advance with empty name (rejected). Stop Setup without `Finished` (rejected).

## R3. Offer and Identity routing

- **Decision**: Offer templates use `[Organization Name]`. Offer routes go directly to
  `identity.review` or `identity.ask` (no `organization-name` hop). Error handling for a link with
  no retrieval continues at `identity.ask`. Domain order drops the organization-name entry.
- **Rationale**: Organization Name is already accepted before offer.
- **Alternatives**: Keep the hop and skip when accepted (rejected: dead step).

## R4. Profile review

- **Decision**: Leave `review` as show body + validation question. No migration prompt for a missing
  Organization Name.
- **Rationale**: Clarification: backward compatibility is not required.
- **Alternatives**: Ask once during review when missing (rejected). Block Finished until named
  (rejected).

## R5. Skill naming fallbacks

- **Decision**: In Profile, onboarding proposal, objectives, controls, and NFRs, delete every
  "Use Repository Name when no Organization Name is accepted" (and equivalent) instruction. Keep
  "Use the accepted Organization Name". Keep the invent ban via the Experience Standard and FR-009.
- **Rationale**: FR-008, FR-010.
- **Alternatives**: Leave fallbacks for older Profiles (rejected: no backward compatibility).

## R6. Record skeleton

- **Decision**: Remove `### Repository Name` and its placeholder from
  `skills/highway-profile/assets/profile-record.md`. Context child order becomes Organization Name,
  Organization URL, Organizational Context. Write instructions store Organization Name from the
  first question and omit Repository Name. Bump template metadata `3.1.0` → `3.2.0`.
- **Rationale**: FR-005, FR-011. Optional child removed; domain sections unchanged → MINOR template.
- **Alternatives**: Leave heading and never fill it (rejected: keeps the concept). MAJOR template bump
  (rejected: Context children were already optional).

## R7. Versions and finish order

- **Decision**: Profile `14.6.0` → `14.7.0`. Onboarding `10.14.0` → `10.15.0`. Objectives `8.9.0` →
  `8.10.0`. Controls `8.8.0` → `8.9.0`. NFRs `9.9.0` → `9.10.0`. Plugin `0.1.3` → `0.1.4`. Run the
  documented finish order after skill edits.
- **Rationale**: P7.7 MINOR for added/removed procedure while `Finished` and domain sections hold.
  Plugin patch matches prior packaging judgment for instruction edits.
- **Alternatives**: MAJOR Profile bump (rejected: domains and Finished unchanged). Skip plugin bump
  (rejected: D4.8).
