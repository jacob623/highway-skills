# Research: Setup Runtime Architecture Alignment

## Decision: Keep Setup as a thin Markdown orchestrator

**Rationale**: The existing Setup skill already delegates Profile, Objectives, Controls, and NFR work. The requested change is a runtime-contract correction, not a new orchestration engine. Keeping the change in the skill document preserves the existing owner boundary and avoids introducing state or a shared result schema.

**Alternatives considered**: Moving orchestration into a shared runtime helper was rejected because Setup-specific ownership and presentation would become less visible, and the feature explicitly requires Setup to consume owner-specific contracts rather than normalize them.

## Decision: Treat the Skills Constitution as development-time only

**Rationale**: The repository Constitution states that executing skills do not consult it. Setup's runtime Error Handling section will therefore describe its own stop conditions without citing Constitution governance or importing a common failure model.

**Alternatives considered**: Replacing the Constitution reference with another shared governance reference was rejected because generic runtime interaction belongs to the Experience Standard and owner-specific behavior belongs to the owning skills.

## Decision: Preserve owner-specific result contracts

**Rationale**: Controls and NFRs use Collection Result contracts while Profile and Objectives use their own declared contracts. Setup will continue to consume those declarations directly and will not create a common result shape.

**Alternatives considered**: A normalized Setup result schema was rejected because it would move owner semantics into the orchestrator and could hide contract-specific continuation behavior.

## Decision: Absorb only Setup-specific presentation behavior

**Rationale**: The revised Experience Standard no longer owns Setup-specific transition, horizontal-rule, final-block, and completed-domain synthesis behavior. Setup will own those presentation constraints while continuing to delegate generic advisory, clarification, convergence, acceptance, and persistence behavior.

**Alternatives considered**: Restating generic Experience rules in Setup was rejected because it would create competing runtime authorities and duplicate the Experience Standard.

## Decision: Use existing Setup validators plus focused contract coverage

**Rationale**: Existing tests already cover owner order, readiness ownership, executable Setup behavior, and owner-loop semantics. The implementation should extend or adjust those document contracts for explicit failure handling and Setup-owned presentation without weakening existing checks.

**Alternatives considered**: A new test framework or runtime fixture system was rejected because the repository uses Bash 3.2-compatible shell validators and the feature changes a Markdown skill contract.

## Unknowns resolved

- No external API, persistence model, or generated artifact is involved.
- No performance, scale, authentication, or compliance decision materially affects this feature; those concerns are outside the Setup document contract.
- No `contracts/` artifact is required because the project surface is an internal skill and its existing shell-tested user-visible contract.
