# Research: Organization and Offering Boundary

## R1. When to ask for the organization name

- **Decision**: After Repository Name is stored, and before any Identity sentence, if Organization
  Name is not accepted, ask once: `**What is the organization's name?**` Store the reply as
  Organization Name. Do not copy Repository Name into Organization Name.
- **Rationale**: The spec forbids treating the repository name as the organization name and forbids
  inventing one. One question before Identity supplies the name those sentences use.
- **Alternatives**: Keep using Repository Name until an organization name appears (rejected: the
  spec forbids that). Infer the name from product text (rejected: that is the fusion this feature
  stops).

## R2. Which Profile step a later skill opens

- **Decision**: On accept, stop the current skill and run `highway-profile` `review` before any
  other record. On decline, stay stopped and add no objective, capability, or finding.
- **Rationale**: The contradiction is against an accepted stored Profile, so the existing review
  path is the revision. A new guided Profile would write a second record.
- **Alternatives**: Tell the person to open Profile later (rejected: acceptance must start the
  revision). Start the absent-file guided flow (rejected: a Profile already exists).

## R3. Where the offering name comes from

- **Decision**: Ordered steps. Take the person's words for the kind of thing. Drop the product's
  proper name, its feature list, and how it is built. One remaining kind is one offering. Different
  kinds are separate offerings. When no category word remains, ask one question and do not coin a
  category.
- **Rationale**: The same words in, the same offering name out. Coining "Agent Skills" from a
  product essay varies between passes.
- **Alternatives**: A fixed offering catalog (rejected: the person did not choose that list). A
  coined category that must repeat (rejected: nothing in the input forces the same coinage).

## R4. Identity finding count

- **Decision**: Emit one finding for who the organization is, then one finding per offering. Do not
  add a finding to reach 3. Keep the existing cap of 6 by not inventing findings. Omit a finding
  the source does not support.
- **Rationale**: The old "3 to 6" floor would invent offerings. The record section stays
  `## Who We Are`.
- **Alternatives**: Keep a 3-finding floor (rejected: invents offerings). Add an Offerings section
  (rejected: clarification A).

## R5. Shared-name home

- **Decision**: Add X2.73 to the Experience Standard. Profile's domain rules only choose the token:
  full organization name for an organizational sentence, short name only on the offering. No other
  skill copies the rule.
- **Rationale**: P10.1 and P7.3. Later skills already follow the Experience Standard.
- **Alternatives**: Copy the paragraph into every skill (rejected).

## R6. Versions

- **Decision**: Experience Standard `11.1.0` → `11.2.0` (rule added, none retired). Skill MINOR
  bumps: experience `1.5.0` → `1.6.0`, profile `14.5.0` → `14.6.0`, onboarding `10.13.0` →
  `10.14.0`, objectives `8.8.0` → `8.9.0`, assessment `5.5.0` → `5.6.0`. Plugin `0.1.2` → `0.1.3`
  in the finish order, after the suite excluding plugin-generation checks is green.
- **Rationale**: Record sections, `Finished`, and direct-invoke stay. The new steps are added
  behavior. P7.7 MINOR. D4.8 requires the plugin bump because `skills/` changes.
- **Alternatives**: MAJOR on profile (rejected: the stored section list and `Finished` still hold).
  Skip the plugin bump (rejected: D4.8).

## R7. Mixed subject

- **Decision**: Ordered. If the person has said the organization and the offering are the same
  subject, keep that. Otherwise, if the draft subject is the offering, or the offering name is who
  the organization is, ask one question and emit no proposal in that message. Otherwise propose
  with the organization as the subject.
- **Rationale**: Replaces "always propose" only for that case. One question, no proposal beside it.
- **Alternatives**: Always ask (rejected: a clear organization subject needs no question). Always
  propose (rejected: that is how the vision fused).
