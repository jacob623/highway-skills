# Feature 094 Research

## Decision 1: Candidate timing

**Decision**: Generate deterministic Control-derived NFR candidates immediately after each new Control is atomically persisted and all retained outputs verify. Defer only user-visible NFR candidate review until setup/configure returns `Collection Result: Finished`.

**Rationale**: Persisted Control title and statement are sufficient candidate inputs under the existing Controls contract. Immediate generation prevents an interrupted conversation from losing downstream work when transient `Created Control IDs` are intentionally not restored. A valid Control with zero matching rules remains valid; candidate-generation failure is a blocked downstream state and does not roll back the valid Control unless an existing canonical contract later requires that behavior.

**Alternatives considered**: Regenerate only at collection finish was rejected because an interrupted interaction could permanently bypass candidate generation. Persisting conversational checkpoints was rejected because `Resume Applicability: New interaction` forbids restoring discovery state.

## Decision 2: Owner boundaries

**Decision**: Controls owns deterministic initial candidate derivation from a verified new Control. NFRs own candidate-generation readiness, candidate classification/review, accepted NFR persistence, identifiers, catalogs, and completion claims. The implementation must reconcile and version both canonical contracts before completion.

**Rationale**: This preserves the existing split in which Controls understands the originating Control and NFRs own NFR decisions and readiness. It avoids silently transferring ownership through an ambiguous result shape.

**Alternatives considered**: Making Controls own the entire NFR review was rejected because it conflicts with NFR readiness and review ownership. Making NFRs derive candidates without Controls' verified Control context was rejected because it weakens provenance and the existing normalized title/statement rule.

## Decision 3: Result contracts

**Decision**: Define separate `Controls Action Result` and `Controls Readiness Result` contracts. Collection results use owner-only `Action Status`, `Collection Result`, cumulative `Created Control IDs`, and `Next Action`. Readiness retains the existing exact four-field response.

**Rationale**: Setup must consume delegated action completion before requesting fresh persisted readiness. Mixing the two permits false completion when readiness becomes `Complete` after the first Control while collection remains active.

**Alternatives considered**: Reusing readiness `Status` for collection was rejected because it overloads the four-field readiness contract.

## Decision 4: Direct action scope

**Decision**: `setup` and `configure` open multi-Control conversational collection. `add` creates one Control and returns the existing verified Add mutation result. `update`, `remove`, and `set` preserve their existing target-resolution and destructive safeguards.

**Rationale**: This keeps direct Add semantics stable while allowing setup/configure to support continuation and explicit finish.

## Decision 5: Context and interaction state

**Decision**: Active user input has highest priority, followed by accepted existing Controls, Profile, Business Objectives, and repository framing documents. Context can suggest or explain and may surface a relevant connection, but cannot choose policy or create a persisted relationship. Concern, Condition, Obligation, suggestions, proposal wording, continuation, and collection provenance are transient interaction state.

**Rationale**: The ordering makes identical inputs deterministic and preserves user authority and the distinction between advisory connections and identifier-backed relationships.

## Decision 6: Validation approach

**Decision**: Use the existing Bash 3.2.57 test harness and add focused contract/fixture coverage under `.highway/tools/tests/`. Run static contract checks separately from behavioral probes and regenerate all generated artifacts after canonical skill changes.

**Rationale**: The repository constitution requires Bash 3.2 compatibility, before/after suite evidence, behavioral test amendments, and generated artifact correspondence. No new runtime dependency is justified.
