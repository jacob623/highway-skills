# Research: Onboarding Technology Capabilities

## R1. Overview lines

- Decision: The level-3 heading becomes "Let's get to know your technology landscape". The sentence "This is where Highway helps you navigate your technology landscape." is removed. The first bullet becomes "- **Identify the technology capabilities** that support your business."
- Rationale: The user's replacement and the clarification answer. The new heading already says "technology landscape", so the removed sentence would repeat it.
- Alternatives considered: Keeping the old bullet. Rejected in clarification, because it asks for business capabilities while the rule asks for technology capabilities.

## R2. Capability rule

- Decision: `capabilities` defines a technology capability, then proposes the technology capability each business activity in accepted context relies on. The title names what the technology does, not a product or vendor. An activity that no technology supports is left out. Two activities that rely on one technology yield one capability. "Do not include a provider." stays.
- Rationale: The clarification answer keeps the starting point useful when context describes only the business. A title without a product or vendor names no system the context does not name. `map` already asks for an `Unknown` provider.
- Alternatives considered: Proposing only when context names the system. Rejected in clarification, because Profile and Objectives describe the business and the list would be nearly empty.

## R3. Placeholder

- Decision: `[What the organization does.]` becomes `[What the technology does for the organization.]` in `capabilities` and in `map`. Business Purpose stays.
- Rationale: The description has to match the title. Business Purpose already carries the business reason.
- Alternatives considered: Dropping Business Purpose. Rejected, because `orchestrate` uses it for the decision.

## R4. Pins and moved assertions

- `codify-platform-catalog.test.sh` pins `highway-onboarding` at `version: 9.0.0`. It moves to `version: 10.0.0`. Reason: the MAJOR bump in the plan.
- `onboarding-assessment-guidance.test.sh` stops requiring `Emit "What we'll do together" as a level-3 heading.` and requires `Emit "Let's get to know your technology landscape" as a level-3 heading.` Reason: R1.
- `onboarding-assessment-guidance.test.sh` stops requiring `This is where Highway helps you navigate your technology landscape.` Reason: R1 removes it. The new test rejects it.
- `onboarding-assessment-guidance.test.sh` stops requiring `- **Identify important business capabilities** your organization relies on.` and requires `- **Identify the technology capabilities** that support your business.` Reason: R1.
