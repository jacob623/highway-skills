# Constitution Development Boundary Contract

## Layer Contract

The Highway Skills Constitution MUST be a development-time validation artifact for shipped Highway skills and shared runtime contracts. It MUST NOT be required input to an executing skill or runtime interaction.

The dependency direction is:

```text
Highway Development Constitution -> Highway Skills Constitution -> Highway Experience Standard / skills
```

The arrow describes development/validation authority. It MUST NOT create a runtime dependency upward from the Experience Standard or a skill to the Skills Constitution.

## Required Constitution Surface

The amended Constitution MUST contain, in equivalent sections or clearly delegated sections:

- development-time scope and non-runtime dependency boundary;
- Experience Compliance as development validation;
- correctness-critical deterministic requirements and bounded advisory variation;
- context declaration and ownership validation without runtime interaction semantics;
- owner-controlled completion and orchestration as contract design requirements;
- required skill-owned failure behavior and authoritative-state protection;
- explicit retirement or narrowing of runtime-only definitions and collaboration rules;
- development-time Principle Precedence and Governance;
- Sync Impact Report, versioning, stable rule-ID handling, and self-application evidence.

## Prohibited Constitution Surface

The current Constitution MUST NOT retain unqualified current rules that:

- call it runtime governance or runtime precedence;
- require executing agents to consult it;
- make it the runtime source of common failure behavior;
- make it the runtime owner of clarification, Working Ideas, convergence, recommendations, or conversational interaction;
- depend on `highway-vision.md` or `highway-platform-objectives.md`;
- characterize Highway Identity as behavioral guidance.

## Determinism Contract

The Constitution MUST distinguish repeatable contractual/authoritative decisions from adaptive advisory reasoning. It MUST preserve deterministic correctness requirements and MUST NOT require identical generative reasoning for advisory content.

## Protected Scope

This feature MUST NOT modify:

- `.highway/governance/experience-standard.md`;
- `.highway/library/knowledge/highway-identity.md`;
- individual `.highway/skills/*/SKILL.md` files;
- existing runtime output templates or persisted artifacts.

Downstream references requiring later cleanup MUST be listed in the amendment or its development record.
