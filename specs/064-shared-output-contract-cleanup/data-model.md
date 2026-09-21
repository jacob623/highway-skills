# Data Model: Final Shared Output Contract Cleanup

## Control Catalog Template

The authoritative structural contract for the user-owned Control catalog.

| Field | Description | Validation |
|---|---|---|
| Catalog identity | Control catalog identity and represented baseline | Matches `control-catalog.md` |
| Version | Baseline version representation | Template conformance and existing version semantics |
| Next identifier | Next `CTL` identifier allocation value | Read from the catalog; never inferred from files |
| Control index | Stable Control identifier/title rows and ordering | Matches the complete catalog template |
| Ownership/layout | Catalog management statement and layout | Template conformance, not duplicated skill prose |

## Discovery Record Template

The authoritative structural contract for one user-owned Discovery record.

| Field | Description | Validation |
|---|---|---|
| Artifact identity | Discovery record identity and `DISC` artifact family | Path and identifier match the existing Discovery contract |
| Closed inputs | Request, constraints, optional governance baselines, and architecture inputs | Read-only resolution and validation remain skill behavior |
| Analysis sections | Findings, assumptions, risks, unknowns, candidates, matrix, recommendation, and relationships | Complete order and headings belong to the template |
| Candidate evidence | Options, elimination entries, scores, matches, and traceability | Shape belongs to the template; generation and scoring remain skill behavior |
| Advisory handoff | Data exposed to later ADR work without a decision | ADR boundary remains skill behavior |

## Discovery Catalog Template

The authoritative structural contract for the user-owned Discovery catalog.

| Field | Description | Validation |
|---|---|---|
| Catalog identity | Discovery catalog identity and represented record family | Matches `discovery-catalog.md` |
| Version | Catalog version representation | Template conformance and existing version semantics |
| Next identifier | Next `DISC` identifier allocation value | Read from the catalog and advanced exactly once after success |
| Discovery index | Stable Discovery/Request/title rows and ordering | Matches the complete catalog template |
| Ownership/layout | Catalog management statement and empty-state layout | Template conformance, not duplicated skill prose |

## Control Behavioral Contract

The Control skill remains responsible for:

- action selection and one version increment per accepted action;
- immutable identifier allocation and no reuse after removal;
- catalog derivation from Controls and recorded next identifier with no timestamp;
- validated transaction behavior and zero partial writes on failure;
- destructive-action impact analysis and explicit confirmation;
- readiness output and Control-derived NFR proposal review boundaries.

## Discovery Behavioral Contract

The Discovery skill remains responsible for:

- exact Request resolution and read-only closed-input loading;
- privacy redaction and deterministic candidate generation;
- constraint filtering before scoring, deterministic ordering, and two-to-five candidate bounds;
- exact Reference Architecture and Reference Implementation matching and tie-breaking;
- score calculation, matrix-before-recommendation ordering, and advisory Recommendation semantics;
- catalog allocation, transaction validation, no-write failure behavior, and ADR handoff boundaries.

## Generated Adapter

A derived representation of a canonical skill distributed to GitHub Copilot, Claude Code, and
Cursor.

- **Sources**: `.highway/skills/highway-controls/SKILL.md` and
  `.highway/skills/highway-discovery/SKILL.md`.
- **Integrity rule**: regenerate from canonical sources and validate correspondence; do not hand-edit.

## Contract Validation Fixture

A temporary valid or invalid skill or document copy used to prove one contract rule.

- **Valid fixture**: contains complete template citations and all retained behavior signals.
- **Invalid fixture**: changes one targeted citation, structural declaration, or behavior signal.
- **Isolation rule**: fixture execution leaves canonical skills, shared templates, generated adapters,
  and user-owned Control/Discovery outputs byte-for-byte unchanged.

## Relationships

```text
Control catalog template ---------------------> highway-controls behavior -----> Control adapters
Discovery record template -------------------> highway-discovery behavior ----> Discovery adapters
Discovery catalog template ------------------^
```

## Lifecycle

1. Inspect the canonical skills and shared templates.
2. Remove duplicated structural prose and add complete template citations/conformance wording.
3. Run independent disposable contract probes and byte-preservation checks.
4. Regenerate six adapters from the two canonical skills.
5. Validate correspondence, packaging, and the complete repository suite.
